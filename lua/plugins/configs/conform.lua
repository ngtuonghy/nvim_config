return {
  formatters_by_ft = {
    svelte = { "prettier" },
    lua = { "stylua" },
    c = { "clang-format" },
    cs = { "clang-format" },
    cpp = { "clang-format" },
    java = { "clang-format" },
    sql = { "sql_formatter" },
    python = { "autopep8" },


    -- webdev
    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    vue = { "prettier" },

    css = { "biome" },
    html = { "prettier" },
    json = { "biome" },
    astro = { "biome" },
    jsonc = { "biome" },

    sh = { "shfmt" },
    yaml = { "yamlfmt" },
  },
}
