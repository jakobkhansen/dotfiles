local vimscript = vim.api.nvim_exec

vim.g.startify_files_number = 5

vim.g.startify_commands = {
    {'Reload Vim', 'luafile $MYVIMRC'},
    {'Update plugins', 'PlugUpdate'},
    {'Clean plugins', 'PlugClean'}
}


-- Often Used
local function oftenUsed()
    return {
        {line = ' TODO', cmd = 'edit $HOME/Documents/TODO.norg'},
        {line = 'Neovim', cmd = 'cd $HOME/.config/nvim/'},
        {line = 'Kattis', cmd = 'cd $HOME/Documents/Personal/KattisSolutions'},
        {line = ' Timeliste', cmd = 'edit $HOME/Documents/School/GRUPPELÆRER/IN2010_2021/timeliste-august.norg'},
        {line = ' IN5320 - Plattform', cmd = 'cd $HOME/Documents/School/IN5320'},
        {line = ' IN5170 - Parallel', cmd = 'cd $HOME/Documents/School/IN5170'},
        {line = ' IN5290 - Ethical Hacking', cmd = 'cd $HOME/Documents/School/IN5290'},
        {line = 'jakobhansen.dev', cmd = 'cd $HOME/Documents/Dev/jakobhansen.dev'},
        {line = 'veggen-react', cmd = 'cd $HOME/Documents/Dev/veggen-react'},

    }
end

local function configFiles()
    local files = {
        {line = 'vim', path = '$MYVIMRC'},
        {line = 'bashrc', path = '$HOME/.bashrc'},
        {line = 'bash aliases', path = '$HOME/.bash_aliases'},
        {line = 'i3', path = '$HOME/.config/i3/config'},
        {line = 'ranger', path = '$HOME/.config/ranger/rc.conf'},
        {line = 'kitty', path = '$HOME/.config/kitty/kitty.conf'},
        {line = 'polybar', path = '$HOME/.config/polybar/config'},
        {line = 'compton', path = '$HOME/.config/compton/compton.conf'},
    }

    return files
end

-- Lua config files
local function luaFiles()
    local scan = require('plenary').scandir
    local home = vim.env['HOME']
    local files = scan.scan_dir(home .. '/.config/nvim/lua')
    out = {}
    for i,v in ipairs(files) do
        out[i] = {line = v, path = v}
    end
    return out
end


vim.g.startify_lists = {
    { type = 'files', header = {'   Recent'} },
    { type = oftenUsed, header = {'   Often used'}, indices={'todo', 'nv', 'ka', 'time', '5320', '5170', '5290'}},
    { type = configFiles, header = {'   Config files'}, indices = {'cv', 'cb', 'ca', 'ci', 'cr', 'ck', 'cp', 'co'}},
    { type = 'commands', header = {'   Commands'}, indices = {'cs', 'pu', 'pc'} },
    { type = luaFiles, header = {'   Lua config files'} },

}
