return {
  'saghen/blink.cmp',
  dependencies = 'rafamadriz/friendly-snippets',
  event = 'User FileOpened',
  build = 'cargo build --release',
  opts = {
    keymap = {
      accept = "<CR>",
      select_next = { "<Down>", "<Tab>" },
      select_prev = { "<Up>", "<S-Tab>" },
      snippet_forward = "<Right>",
      snippet_backward = "<Left>",
    },
    highlight = {
      use_nvim_cmp_as_default = true,
    },
    trigger = {
      completion = {
        show_on_insert_on_trigger_character = false,
        blocked_trigger_characters = { ' ', '\n', '\t', ',' },
      },
      signature_help = { enable = true },
    },
    windows = {
      autocomplete = {},
      documentation = {
        auto_show = true,
      },
    },
  }
}
