require([
  'nbextensions/vim_binding/vim_binding',   // depends your installation
], function() {
    CodeMirror.Vim.map("+", "$", "normal");
    CodeMirror.Vim.map("<Tab>", "<C-n>", "insert");
});

// Configure Jupyter Keymap
require([
  'nbextensions/vim_binding/vim_binding',
  'base/js/namespace',
], function(vim_binding, ns) {
  // Add post callback
  vim_binding.on_ready_callbacks.push(function(){
    var km = ns.keyboard_manager;
    // Allow Ctrl-2 to change the cell mode into Markdown in Vim normal mode
    // Update Help
    km.edit_shortcuts.events.trigger('rebuild.QuickHelp');
  });
});
