return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      dartls = {
        settings = {
          dart = {
            includeDependenciesInWorkspaceSymbols = false,
          },
        },
      },
    },
  },
}
