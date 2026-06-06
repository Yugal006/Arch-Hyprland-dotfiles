return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,

    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
        hide_fillchars = true,
        borderless_telescope = false,
        terminal_colors = true,

        highlights = {
          CursorLine = {
            bg = "#1e2127",
          },
          TelescopeNormal = {
            bg = "NONE",
          },
          NeoTreeNormal = {
            bg = "NONE",
          },
          LspInlayHint = {
            italic = true,
          },
        },
      })

      vim.cmd.colorscheme("cyberdream")
    end,
  },
}
