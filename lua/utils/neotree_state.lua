return {
  states = function()
    local manager = require('neo-tree.sources.manager')
    local renderer = require('neo-tree.ui.renderer')

    local state = manager.get_state('filesystem')
    local expanded_nodes = renderer.get_expanded_nodes(state.tree)
    return { path = state.path, expanded_nodes = expanded_nodes, show_hidden = state.filtered_items.visible }
  end,

  ---@param data { show_hidden: boolean, expanded_nodes: string[] }
  restore = function(data)
    local manager = require('neo-tree.sources.manager')
    local state = manager.get_state('filesystem')

    state.filtered_items.visible = data.show_hidden
    state.force_open_folders = data.expanded_nodes
    require("neo-tree.sources.filesystem")._navigate_internal(state, nil, nil, nil, false)
  end,
}
