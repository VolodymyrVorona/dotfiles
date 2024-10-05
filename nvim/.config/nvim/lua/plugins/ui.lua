return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
      },
    },
  },

  {
    "AstroNvim/astroui",
    ---@type AstroUIOpts
    opts = {
      colorscheme = "vscode_modern",
    },
  },

  {
    "gmr458/vscode_modern_theme.nvim",
    lazy = true,
    opts = {
      cursorline = true,
      transparent_background = false,
      nvim_tree_darker = true,
    },
  },

  {
    "rebelot/heirline.nvim",
    opts = function(_, opts) opts.winbar = nil end,
  },
}
