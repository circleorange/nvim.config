return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "bash", "lua", "java", "vim" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    inlay_hints = {enabled=false},
    autoformat = false,
  }
}
