
return {
  snippets = { preset = "luasnip" },
  cmdline = { enabled = true },
  appearance = { nerd_font_variant = "normal" },
  fuzzy = { implementation = "prefer_rust" },
  sources = { default = { "lsp", "snippets", "buffer", "path" } },
   signature = { enabled = true },

  keymap = {
    preset = "super-tab",
    ["<CR>"] = { "accept", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f"] = { "scroll_documentation_down", "fallback" },
  },

  completion = {
    ghost_text = { enabled = true },
    documentation = {
      auto_show = false,
      auto_show_delay_ms = 200,
      window = { border = "single" },
    },
  },
}
