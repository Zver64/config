return {
  "neovim/nvim-lspconfig",
  init = function()
    vim.lsp.enable("copilot")
  end,
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
  },
}
