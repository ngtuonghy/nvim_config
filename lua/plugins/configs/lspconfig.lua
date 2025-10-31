-- Use LspAttach autocommand to only map the following keys
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
  end,
})

-- local capabilities = require("blink.cmp").get_lsp_capabilities()
local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem = {
  documentationFormat = { "markdown", "plaintext" },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  },
}

-- vim.lsp.config("*", { capabilities = capabilities })
-- local servers = { "html", "cssls", "lua_ls" }

-- vim.lsp.enable(servers)

vim.diagnostic.config {
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ",
      [vim.diagnostic.severity.WARN] = "󰀪 ",
      [vim.diagnostic.severity.INFO] = "󰋽 ",
      [vim.diagnostic.severity.HINT] = "󰌶 ",
    },
  } or {},
  virtual_text = {
    source = "if_many",
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
}

local function get_pkg_path(pkg, path, opts)
  local root = vim.env.MASON or (vim.fn.stdpath "data" .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  return ret
end

local servers = {
  -- clangd = {},
  -- gopls = {},
  tailwindcss = {
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
          },
        },
      },
    },
  },
  astro = {},
  angularls = {},

  vtsls = {
    filetypes = {
      "javascript",
      "javascriptreact",
      "javascript.jsx",
      "typescript",
      "typescriptreact",
      "typescript.tsx",
      "vue",
    },
    settings = {
      vtsls = {
        tsserver = {
          globalPlugins = {
            {
              name = "@vue/typescript-plugin",
              location = get_pkg_path("vue-language-server", "/node_modules/@vue/language-server"),
              languages = { "vue" },
              configNamespace = "typescript",
              enableForWorkspaceTypeScriptVersions = true,
            },
          },
        },
      },
    },
  },

  basedpyright = {
    settings = {
      basedpyright = {
        analysis = {
          diagnosticMode = "openFilesOnly",
          typeCheckingMode = "basic",
          capabilities = capabilities,
          useLibraryCodeForTypes = true,
          diagnosticSeverityOverrides = {
            autoSearchPaths = true,
            enableTypeIgnoreComments = false,
            reportGeneralTypeIssues = "none",
            reportArgumentType = "none",
            reportUnknownMemberType = "none",
            reportAssignmentType = "none",
          },
        },
      },
    },
  },
  -- rust_analyzer = {},
  -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  -- ts_ls = {},
  --

  lua_ls = {
    -- cmd = { ... },
    -- filetypes = { ... },
    -- capabilities = {},
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        completion = {
          callSnippet = "Replace",
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua", -- Used to format Lua code
})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

-- require("mason-lspconfig").setup {
--   ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
--   automatic_installation = false,
--   handlers = {
--     function(server_name)
--       local server = servers[server_name] or {}
--       -- This handles overriding only values explicitly passed
--       -- by the server configuration above. Useful when disabling
--       -- certain features of an LSP (for example, turning off formatting for ts_ls)
--       server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--       require("lspconfig")[server_name].setup(server)
--     end,
--   },
-- }
for server_name, server_config in pairs(servers) do
  require("lspconfig")[server_name].setup(server_config)
end

require("lspconfig").tailwindcss.setup {
  settings = {
    tailwindCSS = {
      classFunctions = { "cva", "cx" },
      -- experimental = {
      --   classRegex = {
      -- { "([\"'`][^\"'`]*.*?[\"'`])", "[\"'`]([^\"'`]*).*?[\"'`]" },
      -- },
      -- },
    },
  },
}

require("lspconfig").basedpyright.setup {
  settings = {
    basedpyright = {
      analysis = {
        diagnosticMode = "openFilesOnly",
        typeCheckingMode = "basic",
        capabilities = capabilities,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          autoSearchPaths = true,
          enableTypeIgnoreComments = false,
          reportGeneralTypeIssues = "none",
          reportArgumentType = "none",
          reportUnknownMemberType = "none",
          reportAssignmentType = "none",
        },
      },
    },
  },
}
