---@module "lazyvim.plugins.lsp"
return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.lsp.enable("copilot")
  end,
  ---@type PluginLspOpts
  opts = {
    servers = {
      dartls = {
        settings = {
          dart = {
            includeDependenciesInWorkspaceSymbols = false,
          },
        },
      },
      eslint = {
        settings = {
          validate = "probe",
          workingDirectory = {
            mode = "auto",
          },
        },
      },
    },
    ---@type vim.diagnostic.Opts
    diagnostics = {
      virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
      }
    }
  },
}
