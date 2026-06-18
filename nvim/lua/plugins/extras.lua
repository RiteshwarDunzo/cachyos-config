-- ~/.config/nvim/lua/plugins/extras.lua

return {
  { "f-person/git-blame.nvim" },
  { "kdheepak/lazygit.nvim" },

  {
    "karb94/neoscroll.nvim",
    config = true,
  },

  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },

  { "wakatime/vim-wakatime" },

  {
    "catppuccin/nvim",
  name = "catppuccin",
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}