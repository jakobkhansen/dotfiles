<#
.SYNOPSIS
    Connects/disconnects a Bluetooth audio device and makes it the default playback
    device - fast (~1s), silently, and without admin rights.

.DESCRIPTION
    Portable: no build step and no external dependencies. The embedded C# is compiled
    once into a cached windowless .exe (under %LOCALAPPDATA%\btaudio) and reused on
    every later run, so a keypress costs no PowerShell/Roslyn start-up. If no C#
    compiler is present it falls back to compiling in-process via Add-Type.

    It works by asking the *audio driver* to reconnect the device through its Kernel
    Streaming filter (KSPROPSETID_BtAudio / KSPROPERTY_ONESHOT_RECONNECT) - the same
    mechanism the Windows sound flyout uses - then sets the default endpoint with
    IPolicyConfig. This avoids BluetoothSetServiceState, which installs/uninstalls PnP
    profile nodes at a cost of ~3 seconds per profile.

.PARAMETER Device
    Bluetooth MAC (AC0775ED0C4F or AC:07:75:ED:0C:4F) or a device-name substring.

.PARAMETER Disconnect
    Disconnect instead of connect.

.PARAMETER Toggle
    Connect if the device is disconnected, disconnect if it is connected. Ideal for
    a single hotkey.

.PARAMETER List
    List Bluetooth-capable render endpoints and exit.

.PARAMETER NoDefault
    Connect but do not change the default playback device.

.PARAMETER Watch
    After connecting, poll for this many ms and report when audio actually flows.

.PARAMETER Retry
    Re-send the connect request every N ms while waiting. Measured to make no
    difference when stealing AirPods off an iPhone (that delay is the headset's, not
    Windows'), so it is off by default.

.PARAMETER Build
    Force a rebuild of the cached executable, then exit.

.PARAMETER ExePath
    Print the path of the cached executable and exit (handy for hotkey bindings).

.PARAMETER Nudge
    Interval (ms) for re-asking A2DP to connect once the Bluetooth link is up.
    0 disables it. Default 700.

.NOTES
    Timings measured on AirPods Pro:
      from the iPhone, or idle ... ~2.2s from keypress to audio actually playing
                                   (BT link ~0.8s, endpoint ACTIVE ~0.7s later,
                                   default device + app switch ~0.7s)

    Two things matter and both were learned the hard way:
      * Connect and disconnect EVERY profile endpoint (A2DP playback *and* the
        hands-free mic). Poking A2DP alone never drops the Bluetooth link on
        disconnect, and Windows still shows the device as Connected.
      * Once the link is up, re-send the A2DP one-shot. The hands-free profile
        tends to win the link first, after which A2DP can idle for 10s+ waiting
        on its own attempt. Nudging it closes a 12s gap down to ~0.7s.

.EXAMPLE
    .\bt-audio.ps1 AC0775ED0C4F
.EXAMPLE
    .\bt-audio.ps1 "AirPods" -Disconnect
.EXAMPLE
    .\bt-audio.ps1 AC0775ED0C4F -Toggle    # one hotkey for connect/disconnect
.EXAMPLE
    # GlazeWM binding that pays no PowerShell start-up cost:
    #   shell-exec --hide-window <output of: .\bt-audio.ps1 -ExePath> AC0775ED0C4F
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Device,
    [switch]$Disconnect,
    [switch]$Toggle,
    [switch]$List,
    [switch]$NoDefault,
    [int]$Watch = 0,
    [int]$Retry = 0,
    [int]$Nudge = -1,
    [int]$TimeoutMs = 12000,
    [string]$Log,
    [string]$Fallback,
    [switch]$Build,
    [switch]$ExePath
)

$ErrorActionPreference = 'Stop'

$CSharp = @'
// btaudio.exe - connect/disconnect a Bluetooth audio device and make it the default
// playback device, by talking to the audio driver's Kernel Streaming filter
// (KSPROPSETID_BtAudio / ONESHOT_RECONNECT) - the same mechanism the Windows sound
// flyout uses. This avoids BluetoothSetServiceState, whose PnP install/uninstall
// costs ~3 seconds per profile.
//
// Usage: btaudio.exe <MAC|name-substring> [--disconnect] [--list] [--no-default]
//                    [--timeout <ms>] [--log <file>] [--fallback <script.ps1>]
//
// Build (C# 5 / .NET Framework, no SDK required):
//   csc /nologo /target:winexe /optimize /out:btaudio.exe btaudio.cs

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;

internal static class Program
{
    // ---------------------------------------------------------------- constants
    static readonly Guid KSPROPSETID_BtAudio = new Guid("7FA06C40-B8F6-4C7E-8556-E8C33A12E54D");
    const uint KSPROPERTY_ONESHOT_RECONNECT = 0;
    const uint KSPROPERTY_ONESHOT_DISCONNECT = 1;
    const uint KSPROPERTY_TYPE_GET = 0x00000001;

    const int DEVICE_STATE_ACTIVE = 0x1;
    const int DEVICE_STATE_UNPLUGGED = 0x8;
    const int DEVICE_STATE_ALL = 0xF;
    const int STGM_READ = 0x0;
    const int CLSCTX_ALL = 23;

    const int eRender = 0, eCapture = 1;
    const int eConsole = 0, eMultimedia = 1, eCommunications = 2;

    static Stopwatch _clock = Stopwatch.StartNew();
    static int nudgeMs = 700;
    static string _linkedName;
    static TextWriter _log;

    // ---------------------------------------------------------------- entry
    [STAThread]
    static int Main(string[] args)
    {
        string target = null, logPath = null, fallback = null;
        bool disconnect = false, list = false, setDefault = true, toggle = false;
        int timeoutMs = 12000, watchMs = 0, retryMs = 0, monitorMs = 0;

        for (int i = 0; i < args.Length; i++)
        {
            string a = args[i];
            if (a.Equals("--disconnect", StringComparison.OrdinalIgnoreCase)) disconnect = true;
            else if (a.Equals("--toggle", StringComparison.OrdinalIgnoreCase)) toggle = true;
            else if (a.Equals("--list", StringComparison.OrdinalIgnoreCase)) list = true;
            else if (a.Equals("--no-default", StringComparison.OrdinalIgnoreCase)) setDefault = false;
            else if (a.Equals("--timeout", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                timeoutMs = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--monitor", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                monitorMs = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--nudge", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                nudgeMs = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--retry", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                retryMs = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--watch", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                watchMs = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--log", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length) logPath = args[++i];
            else if (a.Equals("--fallback", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length) fallback = args[++i];
            else if (!a.StartsWith("--")) target = a;
        }

        try
        {
            if (logPath != null) _log = new StreamWriter(logPath, false) { AutoFlush = true };

            if (list) { ListEndpoints(); return 0; }
            if (monitorMs > 0) { Monitor(target, monitorMs); return 0; }
            if (target == null) { Say("usage: btaudio.exe <MAC|name> [--connect|--disconnect|--toggle] [--list]"); return 64; }

            return Run(target, disconnect, toggle, setDefault, timeoutMs, fallback, watchMs, retryMs);
        }
        catch (Exception ex)
        {
            Say("FATAL " + ex.GetType().Name + ": " + ex.Message);
            return 99;
        }
        finally
        {
            if (_log != null) _log.Dispose();
        }
    }

    static void Say(string msg)
    {
        string line = _clock.ElapsedMilliseconds.ToString("00000", CultureInfo.InvariantCulture) + "ms  " + msg;
        if (_log != null) _log.WriteLine(line);
        try { Console.Out.WriteLine(line); Console.Out.Flush(); } catch { }
    }

    // ---------------------------------------------------------------- model
    sealed class Endpoint
    {
        public string Id;
        public string Name;
        public int State;
        public int Flow;
        public string KsDeviceId;
        public bool IsA2dp;          // media/"Headphones" endpoint
        public bool Active { get { return State == DEVICE_STATE_ACTIVE; } }
    }

    static int Run(string target, bool disconnect, bool toggle, bool setDefault, int timeoutMs, string fallback, int watchMs, int retryMs)
    {
        string mac = OnlyHex(target);
        bool byMac = mac.Length == 12;
        string nameNeedle = byMac ? null : target;

        List<Endpoint> all = new List<Endpoint>();
        foreach (Endpoint e in EnumerateAll())
            if (e.State == DEVICE_STATE_ACTIVE || e.State == DEVICE_STATE_UNPLUGGED) all.Add(e);
        Say("enumerated " + all.Count + " endpoint(s)");

        // Match on the KS filter's device path (contains the BT address) or friendly name.
        List<Endpoint> hits = new List<Endpoint>();
        foreach (Endpoint e in all)
        {
            bool hit = byMac
                ? (e.KsDeviceId != null && e.KsDeviceId.IndexOf(mac, StringComparison.OrdinalIgnoreCase) >= 0)
                : (e.Name != null && e.Name.IndexOf(nameNeedle, StringComparison.OrdinalIgnoreCase) >= 0);
            if (hit) hits.Add(e);
        }

        // A MAC only appears in the A2DP path; pull in the sibling HFP endpoint by name.
        if (byMac && hits.Count > 0)
        {
            string core = CoreName(hits[0].Name);
            foreach (Endpoint e in all)
                if (!hits.Contains(e) && core.Length > 0 &&
                    e.Name.IndexOf(core, StringComparison.OrdinalIgnoreCase) >= 0) hits.Add(e);
        }

        if (hits.Count == 0)
        {
            Say("no audio endpoint matched '" + target + "'");
            if (fallback != null) { SpawnFallback(fallback, target, disconnect); return 0; }
            return 1;
        }
        foreach (Endpoint e in hits)
            Say("  match: " + e.Name + " [" + StateName(e.State) + (e.Flow == eCapture ? ", mic" : "") + (e.IsA2dp ? ", A2DP" : "") + "]");

        Endpoint primary = PickPrimary(hits);

        // Link-state polling (and therefore the A2DP nudge) needs the address. When the
        // device was matched by name, recover it from the A2DP endpoint's device path.
        if (mac.Length != 12) mac = MacFromKs(primary.KsDeviceId);
        if (mac.Length == 12) Say("  address " + mac);

        if (toggle)
        {
            disconnect = primary.Active;
            Say("toggle -> " + (disconnect ? "disconnect" : "connect"));
        }

        if (disconnect)
        {
            // Tearing down only the A2DP stream leaves the Bluetooth link up, so Windows
            // still shows the device as Connected. Drop every profile endpoint instead.
            bool any = false;
            foreach (Endpoint e in hits) if (e.Active) any |= OneShot(e.Id, KSPROPERTY_ONESHOT_DISCONNECT);
            Say(any ? "disconnect sent to all profiles" : "nothing to disconnect");
            if (any && mac.Length == 12)
            {
                Stopwatch sw = Stopwatch.StartNew();
                while (sw.ElapsedMilliseconds < 6000 && BtLinkState(mac) == 1) Thread.Sleep(100);
                Say("BT link connected=" + (BtLinkState(mac) == 1));
            }
            return any ? 0 : 1;
        }

        if (primary.Active)
        {
            Say("already connected: " + primary.Name);
            if (setDefault) MakeDefault(primary, hits);
            return 0;
        }

        // Ask every profile to reconnect, not just A2DP: bringing up the hands-free link
        // as well is what the Windows UI does, and the ACL it establishes lets the A2DP
        // stream come up immediately instead of waiting on its own connect attempt.
        int sent = 0;
        if (OneShot(primary.Id, KSPROPERTY_ONESHOT_RECONNECT)) sent++;
        foreach (Endpoint e in hits)
            if (e != primary && OneShot(e.Id, KSPROPERTY_ONESHOT_RECONNECT)) sent++;
        if (sent == 0)
        {
            Say("KS reconnect failed on every endpoint");
            if (fallback != null) SpawnFallback(fallback, target, false);
            return 2;
        }
        Say("reconnect sent to " + sent + " endpoint(s)");

        if (!WaitActive(primary.Id, timeoutMs, retryMs, primary, hits, mac))
        {
            Say("timed out waiting for endpoint to go ACTIVE");
            return 3;
        }
        Say("endpoint ACTIVE");

        if (setDefault) MakeDefault(primary, hits);
        Say("done");
        if (watchMs > 0) Watch(primary, watchMs);
        return 0;
    }

    // Poll the endpoint's peak meter to find when audio really starts flowing to it, and
    // watch the default device in case Windows overrides us.
    static void Watch(Endpoint target, int ms)
    {
        Say("watching for audio on " + target.Name + " for " + ms + "ms");
        IMMDeviceEnumerator en = (IMMDeviceEnumerator)new MMDeviceEnumeratorComObject();
        IAudioMeterInformation meter = null;
        string lastDefault = null;
        bool sawAudio = false;
        try
        {
            IMMDevice dev;
            if (en.GetDevice(target.Id, out dev) >= 0 && dev != null)
            {
                object o;
                Guid iid = typeof(IAudioMeterInformation).GUID;
                if (dev.Activate(ref iid, CLSCTX_ALL, IntPtr.Zero, out o) >= 0 && o != null)
                    meter = (IAudioMeterInformation)o;
                Marshal.ReleaseComObject(dev);
            }
            Stopwatch sw = Stopwatch.StartNew();
            while (sw.ElapsedMilliseconds < ms)
            {
                IMMDevice def;
                if (en.GetDefaultAudioEndpoint(eRender, eMultimedia, out def) >= 0 && def != null)
                {
                    string n = FriendlyName(def);
                    if (n != lastDefault) { Say("  default is now: " + n); lastDefault = n; }
                    Marshal.ReleaseComObject(def);
                }
                if (meter != null && !sawAudio)
                {
                    float peak;
                    if (meter.GetPeakValue(out peak) >= 0 && peak > 0.0001f)
                    {
                        Say("  AUDIO FLOWING (peak=" + peak.ToString("F4", CultureInfo.InvariantCulture) + ")");
                        sawAudio = true;
                    }
                }
                Thread.Sleep(50);
            }
            if (!sawAudio) Say("  no audio seen on this endpoint within " + ms + "ms");
        }
        finally
        {
            if (meter != null) Marshal.ReleaseComObject(meter);
            Marshal.ReleaseComObject(en);
        }
    }

    static Endpoint PickPrimary(List<Endpoint> hits)
    {
        foreach (Endpoint e in hits) if (e.IsA2dp) return e;     // media audio first
        return hits[0];
    }

    // Console+Multimedia -> media (A2DP) endpoint; Communications -> headset endpoint,
    // mirroring what Windows does itself when a headset connects.
    static void MakeDefault(Endpoint primary, List<Endpoint> hits)
    {
        object o = null;
        try
        {
            Type t = Type.GetTypeFromCLSID(new Guid("870af99c-171d-4f9e-af0d-e63df40c2bc9"));
            o = Activator.CreateInstance(t);
            IPolicyConfig pc = (IPolicyConfig)o;

            pc.SetDefaultEndpoint(primary.Id, eConsole);
            pc.SetDefaultEndpoint(primary.Id, eMultimedia);

            Endpoint comms = null;
            foreach (Endpoint e in hits)
                if (!e.IsA2dp && e.Name.IndexOf("Free", StringComparison.OrdinalIgnoreCase) < 0) { comms = e; break; }
            pc.SetDefaultEndpoint((comms ?? primary).Id, eCommunications);

            Say("default playback -> " + primary.Name);
        }
        catch (Exception ex) { Say("set-default failed: " + ex.Message); }
        finally { if (o != null) Marshal.ReleaseComObject(o); }
    }

    // A single one-shot can lose the race when the device is busy with another host
    // (e.g. AirPods held by an iPhone). Re-sending it while waiting keeps trying.
    static bool WaitActive(string id, int timeoutMs, int retryMs, Endpoint primary, List<Endpoint> hits, string mac)
    {
        Stopwatch sw = Stopwatch.StartNew();
        long nextRetry = retryMs > 0 ? retryMs : long.MaxValue;
        long nextNudge = long.MaxValue;
        int lastLink = -2;
        IMMDeviceEnumerator en = (IMMDeviceEnumerator)new MMDeviceEnumeratorComObject();
        try
        {
            while (sw.ElapsedMilliseconds < timeoutMs)
            {
                if (mac != null && mac.Length == 12)
                {
                    int link = BtLinkState(mac);
                    if (link != lastLink)
                    {
                        Say("  BT link connected=" + (link == 1));
                        // The hands-free profile usually wins the link; A2DP can then sit
                        // idle for 10s+ waiting for its own attempt. Re-ask it now that an
                        // ACL exists - that is the difference against the Windows UI.
                        if (link == 1 && nudgeMs > 0) nextNudge = sw.ElapsedMilliseconds;
                        lastLink = link;
                    }
                }
                IMMDevice d;
                if (en.GetDevice(id, out d) >= 0 && d != null)
                {
                    int st;
                    d.GetState(out st);
                    Marshal.ReleaseComObject(d);
                    if (st == DEVICE_STATE_ACTIVE) return true;
                }
                if (sw.ElapsedMilliseconds >= nextNudge)
                {
                    Say("  nudge A2DP over the live link (" + sw.ElapsedMilliseconds + "ms)");
                    OneShot(primary.Id, KSPROPERTY_ONESHOT_RECONNECT);
                    nextNudge = sw.ElapsedMilliseconds + nudgeMs;
                }
                if (sw.ElapsedMilliseconds >= nextRetry)
                {
                    Say("  retry reconnect (" + sw.ElapsedMilliseconds + "ms)");
                    OneShot(primary.Id, KSPROPERTY_ONESHOT_RECONNECT);
                    foreach (Endpoint e in hits)
                        if (e != primary) OneShot(e.Id, KSPROPERTY_ONESHOT_RECONNECT);
                    nextRetry = sw.ElapsedMilliseconds + retryMs;
                }
                Thread.Sleep(40);
            }
        }
        finally { Marshal.ReleaseComObject(en); }
        return false;
    }

    static void SpawnFallback(string script, string target, bool disconnect)
    {
        try
        {
            Say("falling back to " + script);
            ProcessStartInfo psi = new ProcessStartInfo("pwsh",
                "-NoProfile -NonInteractive -File \"" + script + "\" -Address " + target + (disconnect ? " -Disconnect" : ""));
            psi.UseShellExecute = false;
            psi.CreateNoWindow = true;
            Process.Start(psi);
        }
        catch (Exception ex) { Say("fallback failed: " + ex.Message); }
    }

    // ---------------------------------------------------------------- enumeration
    static List<Endpoint> Enumerate()
    {
        return Enumerate(eRender, DEVICE_STATE_ACTIVE | DEVICE_STATE_UNPLUGGED);
    }

    static List<Endpoint> EnumerateAll()
    {
        List<Endpoint> all = Enumerate(eRender, DEVICE_STATE_ALL);
        all.AddRange(Enumerate(eCapture, DEVICE_STATE_ALL));
        return all;
    }

    static List<Endpoint> Enumerate(int flow, int stateMask)
    {
        List<Endpoint> list = new List<Endpoint>();
        IMMDeviceEnumerator en = (IMMDeviceEnumerator)new MMDeviceEnumeratorComObject();
        try
        {
            IMMDeviceCollection col;
            en.EnumAudioEndpoints(flow, stateMask, out col);
            int n;
            col.GetCount(out n);
            for (int i = 0; i < n; i++)
            {
                IMMDevice dev;
                col.Item(i, out dev);
                try
                {
                    Endpoint e = new Endpoint();
                    e.Flow = flow;
                    dev.GetId(out e.Id);
                    dev.GetState(out e.State);
                    e.Name = FriendlyName(dev);
                    e.KsDeviceId = KsDeviceId(dev);
                    e.IsA2dp = e.KsDeviceId != null &&
                               e.KsDeviceId.IndexOf("0000110b", StringComparison.OrdinalIgnoreCase) >= 0;
                    list.Add(e);
                }
                finally { Marshal.ReleaseComObject(dev); }
            }
            Marshal.ReleaseComObject(col);
        }
        finally { Marshal.ReleaseComObject(en); }
        return list;
    }

    // Log every audio-endpoint state change plus the Bluetooth link state, so a manual
    // connect from the Windows UI can be compared against what this tool does.
    static void Monitor(string target, int ms)
    {
        string mac = OnlyHex(target ?? "");
        Say("monitoring (all endpoint states, render+capture) for " + ms + "ms");
        // When given a MAC, learn the device's display name from the endpoint that carries
        // it, so sibling endpoints (the hands-free mic) are picked up too.
        if (mac.Length == 12)
            foreach (Endpoint e in EnumerateAll())
                if (e.KsDeviceId != null && e.KsDeviceId.IndexOf(mac, StringComparison.OrdinalIgnoreCase) >= 0)
                { _linkedName = CoreName(e.Name); break; }
        Dictionary<string, int> seen = new Dictionary<string, int>();
        string lastDefault = null;
        int lastLink = -1;
        Stopwatch sw = Stopwatch.StartNew();

        while (sw.ElapsedMilliseconds < ms)
        {
            if (mac.Length == 12)
            {
                int link = BtLinkState(mac);
                if (link != lastLink) { Say("BT LINK connected=" + (link == 1)); lastLink = link; }
            }

            foreach (Endpoint e in EnumerateAll())
            {
                bool relevant = (mac.Length == 12 && e.KsDeviceId != null &&
                                 e.KsDeviceId.IndexOf(mac, StringComparison.OrdinalIgnoreCase) >= 0)
                                || (mac.Length != 12 && target != null && e.Name != null &&
                                    e.Name.IndexOf(target, StringComparison.OrdinalIgnoreCase) >= 0)
                                || (mac.Length == 12 && e.Name != null && _linkedName != null &&
                                    e.Name.IndexOf(_linkedName, StringComparison.OrdinalIgnoreCase) >= 0);
                if (!relevant) continue;
                int prev;
                if (!seen.TryGetValue(e.Id, out prev)) prev = -1;
                if (prev != e.State)
                {
                    Say((prev == -1 ? "  seen   " : "  CHANGE ") + "[" + StateName(e.State) + "] " +
                        (e.Flow == eCapture ? "(mic) " : "") + e.Name);
                    seen[e.Id] = e.State;
                }
            }

            IMMDeviceEnumerator en2 = (IMMDeviceEnumerator)new MMDeviceEnumeratorComObject();
            try
            {
                IMMDevice def;
                if (en2.GetDefaultAudioEndpoint(eRender, eMultimedia, out def) >= 0 && def != null)
                {
                    string n = FriendlyName(def);
                    if (n != lastDefault) { Say("  DEFAULT -> " + n); lastDefault = n; }
                    Marshal.ReleaseComObject(def);
                }
            }
            finally { Marshal.ReleaseComObject(en2); }

            Thread.Sleep(100);
        }
        Say("monitor finished");
    }

    static string StateName(int s)
    {
        if (s == 1) return "ACTIVE";
        if (s == 2) return "DISABLED";
        if (s == 4) return "NOTPRESENT";
        if (s == 8) return "unplugged";
        return "0x" + s.ToString("X");
    }

    // 1 = connected, 0 = not, -1 = unknown/not paired
    static int BtLinkState(string mac)
    {
        try
        {
            BLUETOOTH_FIND_RADIO_PARAMS p = new BLUETOOTH_FIND_RADIO_PARAMS();
            p.dwSize = Marshal.SizeOf(typeof(BLUETOOTH_FIND_RADIO_PARAMS));
            IntPtr radio;
            IntPtr find = BluetoothFindFirstRadio(ref p, out radio);
            if (find == IntPtr.Zero) return -1;
            try
            {
                BLUETOOTH_DEVICE_INFO info = new BLUETOOTH_DEVICE_INFO();
                info.dwSize = Marshal.SizeOf(typeof(BLUETOOTH_DEVICE_INFO));
                info.Address = ulong.Parse(mac, NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                if (BluetoothGetDeviceInfo(radio, ref info) != 0) return -1;
                return info.fConnected ? 1 : 0;
            }
            finally { CloseHandle(radio); BluetoothFindRadioClose(find); }
        }
        catch { return -1; }
    }

    static void ListEndpoints()
    {
        foreach (Endpoint e in EnumerateAll())
        {
            if (e.State != DEVICE_STATE_ACTIVE && e.State != DEVICE_STATE_UNPLUGGED) continue;
            Say("[" + StateName(e.State) + "] " + (e.Flow == eCapture ? "(mic)  " : "(play) ") +
                (e.IsA2dp ? "[A2DP] " : "") + e.Name + "\n              ks=" + (e.KsDeviceId ?? "<none>"));
        }
    }

    static string FriendlyName(IMMDevice dev)
    {
        IPropertyStore store;
        if (dev.OpenPropertyStore(STGM_READ, out store) < 0) return "";
        try
        {
            PROPERTYKEY key = new PROPERTYKEY();
            key.fmtid = new Guid("a45c254e-df1c-4efd-8020-67d146a850e0");
            key.pid = 14;
            PROPVARIANT pv;
            if (store.GetValue(ref key, out pv) < 0) return "";
            try { return Marshal.PtrToStringUni(pv.p) ?? ""; }
            finally { PropVariantClear(ref pv); }
        }
        finally { Marshal.ReleaseComObject(store); }
    }

    // Walk endpoint -> device topology -> connected filter, and return its device path.
    static string KsDeviceId(IMMDevice endpoint)
    {
        object topoObj;
        Guid iid = typeof(IDeviceTopology).GUID;
        if (endpoint.Activate(ref iid, CLSCTX_ALL, IntPtr.Zero, out topoObj) < 0 || topoObj == null) return null;
        IDeviceTopology topo = (IDeviceTopology)topoObj;
        try
        {
            uint count;
            topo.GetConnectorCount(out count);
            for (uint i = 0; i < count; i++)
            {
                IConnector conn;
                if (topo.GetConnector(i, out conn) < 0 || conn == null) continue;
                try
                {
                    bool connected;
                    if (conn.IsConnected(out connected) < 0 || !connected) continue;
                    string devId;
                    if (conn.GetDeviceIdConnectedTo(out devId) >= 0 && !string.IsNullOrEmpty(devId)) return devId;
                }
                finally { Marshal.ReleaseComObject(conn); }
            }
        }
        finally { Marshal.ReleaseComObject(topo); }
        return null;
    }

    static bool OneShot(string endpointId, uint propertyId)
    {
        IMMDeviceEnumerator en = (IMMDeviceEnumerator)new MMDeviceEnumeratorComObject();
        try
        {
            IMMDevice endpoint;
            if (en.GetDevice(endpointId, out endpoint) < 0 || endpoint == null) return false;
            try
            {
                string ksId = KsDeviceId(endpoint);
                if (ksId == null) return false;
                IMMDevice filter;
                if (en.GetDevice(ksId, out filter) < 0 || filter == null) return false;
                try
                {
                    object ksObj;
                    Guid iid = typeof(IKsControl).GUID;
                    if (filter.Activate(ref iid, CLSCTX_ALL, IntPtr.Zero, out ksObj) < 0 || ksObj == null) return false;
                    IKsControl ks = (IKsControl)ksObj;
                    try
                    {
                        KSPROPERTY prop = new KSPROPERTY();
                        prop.Set = KSPROPSETID_BtAudio;
                        prop.Id = propertyId;
                        prop.Flags = KSPROPERTY_TYPE_GET;
                        uint returned;
                        int hr = ks.KsProperty(ref prop, (uint)Marshal.SizeOf(typeof(KSPROPERTY)),
                                               IntPtr.Zero, 0, out returned);
                        if (hr < 0) Say("  KsProperty hr=0x" + hr.ToString("X8"));
                        return hr >= 0;
                    }
                    finally { Marshal.ReleaseComObject(ks); }
                }
                finally { Marshal.ReleaseComObject(filter); }
            }
            finally { Marshal.ReleaseComObject(endpoint); }
        }
        finally { Marshal.ReleaseComObject(en); }
    }

    // ---------------------------------------------------------------- helpers
    // "...#5&1cd044e&0&ac0775ed0c4f_c00000000#..." -> "ac0775ed0c4f"
    static string MacFromKs(string ksId)
    {
        if (string.IsNullOrEmpty(ksId)) return "";
        Match m = Regex.Match(ksId, @"&([0-9a-fA-F]{12})_");
        if (!m.Success) m = Regex.Match(ksId, @"&([0-9a-fA-F]{12})[#&]");
        return m.Success ? m.Groups[1].Value : "";
    }

    static string OnlyHex(string s)
    {
        StringBuilder sb = new StringBuilder();
        foreach (char c in s) if (Uri.IsHexDigit(c)) sb.Append(c);
        return sb.ToString();
    }

    // "Headphones (AirPods Pro)" -> "AirPods Pro"
    static string CoreName(string friendly)
    {
        if (string.IsNullOrEmpty(friendly)) return "";
        int o = friendly.IndexOf('('), c = friendly.LastIndexOf(')');
        string inner = (o >= 0 && c > o) ? friendly.Substring(o + 1, c - o - 1) : friendly;
        int dash = inner.IndexOf(" - ", StringComparison.Ordinal);
        if (dash > 0) inner = inner.Substring(0, dash);
        return inner.Trim();
    }

    // ---------------------------------------------------------------- interop
    [DllImport("ole32.dll")] static extern int PropVariantClear(ref PROPVARIANT pvar);

    [StructLayout(LayoutKind.Sequential)]
    struct BLUETOOTH_FIND_RADIO_PARAMS { public int dwSize; }

    [StructLayout(LayoutKind.Sequential)]
    struct SYSTEMTIME { public ushort y, mo, dow, d, h, mi, s, ms; }

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    struct BLUETOOTH_DEVICE_INFO
    {
        public int dwSize;
        public ulong Address;
        public uint ulClassofDevice;
        [MarshalAs(UnmanagedType.Bool)] public bool fConnected;
        [MarshalAs(UnmanagedType.Bool)] public bool fRemembered;
        [MarshalAs(UnmanagedType.Bool)] public bool fAuthenticated;
        public SYSTEMTIME stLastSeen;
        public SYSTEMTIME stLastUsed;
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 248)] public string szName;
    }

    [DllImport("bthprops.cpl", SetLastError = true)]
    static extern IntPtr BluetoothFindFirstRadio(ref BLUETOOTH_FIND_RADIO_PARAMS p, out IntPtr radio);
    [DllImport("bthprops.cpl", SetLastError = true)]
    static extern bool BluetoothFindRadioClose(IntPtr find);
    [DllImport("bthprops.cpl", SetLastError = true)]
    static extern uint BluetoothGetDeviceInfo(IntPtr radio, ref BLUETOOTH_DEVICE_INFO info);
    [DllImport("kernel32.dll", SetLastError = true)]
    static extern bool CloseHandle(IntPtr h);

    [StructLayout(LayoutKind.Sequential)]
    struct KSPROPERTY { public Guid Set; public uint Id; public uint Flags; }

    [StructLayout(LayoutKind.Sequential)]
    struct PROPERTYKEY { public Guid fmtid; public int pid; }

    [StructLayout(LayoutKind.Explicit)]
    struct PROPVARIANT { [FieldOffset(0)] public short vt; [FieldOffset(8)] public IntPtr p; }

    [ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")]
    class MMDeviceEnumeratorComObject { }

    [ComImport, Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceEnumerator
    {
        [PreserveSig] int EnumAudioEndpoints(int flow, int stateMask, out IMMDeviceCollection col);
        [PreserveSig] int GetDefaultAudioEndpoint(int flow, int role, out IMMDevice dev);
        [PreserveSig] int GetDevice([MarshalAs(UnmanagedType.LPWStr)] string id, out IMMDevice dev);
        [PreserveSig] int RegisterEndpointNotificationCallback(IntPtr c);
        [PreserveSig] int UnregisterEndpointNotificationCallback(IntPtr c);
    }

    [ComImport, Guid("0BD7A1BE-7A1A-44DB-8397-CC5392387B5E"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDeviceCollection
    {
        [PreserveSig] int GetCount(out int count);
        [PreserveSig] int Item(int i, out IMMDevice dev);
    }

    [ComImport, Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IMMDevice
    {
        [PreserveSig] int Activate(ref Guid iid, int clsCtx, IntPtr param, [MarshalAs(UnmanagedType.IUnknown)] out object o);
        [PreserveSig] int OpenPropertyStore(int access, out IPropertyStore store);
        [PreserveSig] int GetId([MarshalAs(UnmanagedType.LPWStr)] out string id);
        [PreserveSig] int GetState(out int state);
    }

    [ComImport, Guid("886d8eeb-8cf2-4446-8d02-cdba1dbdcf99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IPropertyStore
    {
        [PreserveSig] int GetCount(out int c);
        [PreserveSig] int GetAt(int i, out PROPERTYKEY key);
        [PreserveSig] int GetValue(ref PROPERTYKEY key, out PROPVARIANT pv);
        [PreserveSig] int SetValue(ref PROPERTYKEY key, ref PROPVARIANT pv);
        [PreserveSig] int Commit();
    }

    [ComImport, Guid("2A07407E-6497-4A18-9787-32F79BD0D98F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IDeviceTopology
    {
        [PreserveSig] int GetConnectorCount(out uint count);
        [PreserveSig] int GetConnector(uint index, out IConnector conn);
        [PreserveSig] int GetSubunitCount(out uint count);
        [PreserveSig] int GetSubunit(uint index, out IntPtr subunit);
        [PreserveSig] int GetPartById(uint id, out IntPtr part);
        [PreserveSig] int GetDeviceId([MarshalAs(UnmanagedType.LPWStr)] out string id);
        [PreserveSig] int GetSignalPath(IntPtr from, IntPtr to, [MarshalAs(UnmanagedType.Bool)] bool rejectMixed, out IntPtr parts);
    }

    [ComImport, Guid("9c2c4058-23f5-41de-877a-df3af236a09e"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IConnector
    {
        [PreserveSig] int GetType(out int type);
        [PreserveSig] int GetDataFlow(out int flow);
        [PreserveSig] int ConnectTo(IConnector other);
        [PreserveSig] int Disconnect();
        [PreserveSig] int IsConnected([MarshalAs(UnmanagedType.Bool)] out bool connected);
        [PreserveSig] int GetConnectedTo(out IConnector other);
        [PreserveSig] int GetConnectorIdConnectedTo([MarshalAs(UnmanagedType.LPWStr)] out string id);
        [PreserveSig] int GetDeviceIdConnectedTo([MarshalAs(UnmanagedType.LPWStr)] out string id);
    }

    [ComImport, Guid("28F54685-06FD-11D2-B27A-00A0C9223196"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IKsControl
    {
        [PreserveSig] int KsProperty(ref KSPROPERTY prop, uint propLen, IntPtr data, uint dataLen, out uint bytesReturned);
        [PreserveSig] int KsMethod(IntPtr m, uint mLen, IntPtr data, uint dataLen, out uint bytesReturned);
        [PreserveSig] int KsEvent(IntPtr e, uint eLen, IntPtr data, uint dataLen, out uint bytesReturned);
    }

    [ComImport, Guid("C02216F6-8C67-4B5B-9D00-D008E73E0064"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IAudioMeterInformation
    {
        [PreserveSig] int GetPeakValue(out float peak);
        [PreserveSig] int GetMeteringChannelCount(out uint count);
        [PreserveSig] int GetChannelsPeakValues(uint count, [Out] float[] peaks);
        [PreserveSig] int QueryHardwareSupport(out uint mask);
    }

    // Only SetDefaultEndpoint is used; the earlier slots just have to keep the vtable
    // aligned, so their pointer arguments stay untyped.
    [ComImport, Guid("f8679f50-850a-41cf-9c72-430f290290c8"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    interface IPolicyConfig
    {
        [PreserveSig] int GetMixFormat([MarshalAs(UnmanagedType.LPWStr)] string id, out IntPtr fmt);
        [PreserveSig] int GetDeviceFormat([MarshalAs(UnmanagedType.LPWStr)] string id, int def, out IntPtr fmt);
        [PreserveSig] int ResetDeviceFormat([MarshalAs(UnmanagedType.LPWStr)] string id);
        [PreserveSig] int SetDeviceFormat([MarshalAs(UnmanagedType.LPWStr)] string id, IntPtr endpointFmt, IntPtr mixFmt);
        [PreserveSig] int GetProcessingPeriod([MarshalAs(UnmanagedType.LPWStr)] string id, int def, out long defPeriod, out long minPeriod);
        [PreserveSig] int SetProcessingPeriod([MarshalAs(UnmanagedType.LPWStr)] string id, IntPtr period);
        [PreserveSig] int GetShareMode([MarshalAs(UnmanagedType.LPWStr)] string id, out IntPtr mode);
        [PreserveSig] int SetShareMode([MarshalAs(UnmanagedType.LPWStr)] string id, IntPtr mode);
        [PreserveSig] int GetPropertyValue([MarshalAs(UnmanagedType.LPWStr)] string id, int store, ref PROPERTYKEY key, out PROPVARIANT pv);
        [PreserveSig] int SetPropertyValue([MarshalAs(UnmanagedType.LPWStr)] string id, int store, ref PROPERTYKEY key, ref PROPVARIANT pv);
        [PreserveSig] int SetDefaultEndpoint([MarshalAs(UnmanagedType.LPWStr)] string id, int role);
        [PreserveSig] int SetEndpointVisibility([MarshalAs(UnmanagedType.LPWStr)] string id, int visible);
    }
}
'@

function Get-CachedExePath {
    Join-Path (Join-Path $env:LOCALAPPDATA 'btaudio') 'btaudio.exe'
}

function Get-SourceHash {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { [BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($CSharp))).Replace('-', '') }
    finally { $sha.Dispose() }
}

function Test-ExeCurrent([string]$Path) {
    if (-not (Test-Path $Path)) { return $false }
    $stamp = "$Path.hash"
    (Test-Path $stamp) -and ((Get-Content $stamp -Raw).Trim() -eq (Get-SourceHash))
}

function Find-Csc {
    # csc.exe ships with the in-box .NET Framework on every supported Windows build.
    Get-ChildItem "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\csc.exe",
                  "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\csc.exe" -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}

function Build-Exe([string]$Path) {
    $dir = Split-Path $Path -Parent
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $csc = Find-Csc
    if (-not $csc) { return $false }

    $src = [IO.Path]::GetTempFileName() + '.cs'
    try {
        Set-Content -LiteralPath $src -Value $CSharp -Encoding UTF8
        # /target:winexe => no console subsystem, so the process can never flash a window.
        $out = & $csc /nologo /target:winexe /optimize /out:"$Path" "$src" 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Verbose ($out -join "`n"); return $false }
        Set-Content -LiteralPath "$Path.hash" -Value (Get-SourceHash) -Encoding ASCII
        return $true
    } finally { Remove-Item $src -Force -ErrorAction SilentlyContinue }
}

# --- assemble arguments -------------------------------------------------------
$argv = @()
if ($Device)   { $argv += $Device }
if ($Disconnect) { $argv += '--disconnect' }
if ($Toggle)     { $argv += '--toggle' }
if ($List)       { $argv += '--list' }
if ($NoDefault)  { $argv += '--no-default' }
if ($Watch -gt 0){ $argv += @('--watch', $Watch) }
if ($Retry -gt 0){ $argv += @('--retry', $Retry) }
if ($Nudge -ge 0) { $argv += @('--nudge', $Nudge) }
if ($TimeoutMs)  { $argv += @('--timeout', $TimeoutMs) }
if ($Log)        { $argv += @('--log', $Log) }
if ($Fallback)   { $argv += @('--fallback', $Fallback) }

$exe = Get-CachedExePath

if ($ExePath) { $exe; exit 0 }

if ($Build -or -not (Test-ExeCurrent $exe)) {
    if (Build-Exe $exe) {
        Write-Verbose "built $exe"
    } elseif (-not $Build) {
        # No compiler: run the same code in-process (slower start-up, same behaviour).
        Write-Verbose 'no csc.exe found - falling back to in-process Add-Type'
        if (-not ('Program' -as [type])) {
            Add-Type -TypeDefinition $CSharp -Language CSharp
        }
        exit ([Program].GetMethod('Main', [Reflection.BindingFlags]'NonPublic,Static').Invoke($null, @(, [string[]]$argv)))
    } else {
        throw 'No C# compiler found (expected csc.exe from the in-box .NET Framework).'
    }
    if ($Build) { $exe; exit 0 }
}

if (-not $Device -and -not $List) { throw 'Specify a device MAC or name (or use -List).' }

# Pre-quote so paths containing spaces survive Start-Process's naive joining.
$quoted = $argv | ForEach-Object { if ("$_" -match '\s') { '"' + $_ + '"' } else { "$_" } }
$p = Start-Process -FilePath $exe -ArgumentList $quoted -NoNewWindow -Wait -PassThru
exit $p.ExitCode
