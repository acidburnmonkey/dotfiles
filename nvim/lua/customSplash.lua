vim.api.nvim_create_augroup("CustomSplash", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = "CustomSplash",
  callback = function()
    if vim.fn.argc() ~= 0 then
      return
    end

    local splash_win = vim.api.nvim_get_current_win()
    local orig_number         = vim.api.nvim_win_get_option(splash_win, "number")
    local orig_relativenumber = vim.api.nvim_win_get_option(splash_win, "relativenumber")

    local bufnr = vim.api.nvim_get_current_buf()
    vim.b[bufnr].splash_winid            = splash_win
    vim.b[bufnr].splash_orig_number      = orig_number
    vim.b[bufnr].splash_orig_relativenumber = orig_relativenumber

    vim.api.nvim_win_set_option(splash_win, "number", false)
    vim.api.nvim_win_set_option(splash_win, "relativenumber", false)

    vim.opt_local.buftype   = "nofile"
    vim.opt_local.bufhidden = "hide"
    vim.opt_local.swapfile  = false
    vim.opt_local.buflisted = false

    local splash_path = vim.fn.expand("$HOME/.config/nvim/splash.txt")
    local ascii_lines = {}
    if vim.fn.filereadable(splash_path) == 1 then
      ascii_lines = vim.fn.readfile(splash_path)
    else
      -- Hard‐coded fallback:
      ascii_lines = {
        "   ____  __   __   _____      __",
        "  / __ \\/ /  / /  / ___/___  / /_",
        " / / / / /  / /   \\__ \\/ _ \\/ __/",
        "/ /_/ / /__/ /   ___/ /  __/ /_ ",
        "\\____/ \\____/   /____/\\___/\\__/",
        "",
        "  Welcome to Neovim,  " .. os.getenv("USER") .. "!",
      }
    end

    local width = vim.api.nvim_win_get_width(splash_win)
    local padded = {}
    for _, line in ipairs(ascii_lines) do
      local linelen = #line
      local left_pad = math.floor((width - linelen) / 2)
      if left_pad < 0 then left_pad = 0 end
      table.insert(padded, string.rep(" ", left_pad) .. line)
    end

    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, padded)

    local clear_grp = vim.api.nvim_create_augroup("SplashClear" .. bufnr, { clear = true })

    vim.api.nvim_create_autocmd("InsertEnter", {
      group = clear_grp,
      buffer = bufnr,
      once = true,
      callback = function()
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "" })
        vim.api.nvim_win_set_cursor(splash_win, {1, 0})
        vim.api.nvim_win_set_option(splash_win, "number", vim.b[bufnr].splash_orig_number)
        vim.api.nvim_win_set_option(splash_win, "relativenumber", vim.b[bufnr].splash_orig_relativenumber)
      end,
    })

    vim.api.nvim_create_autocmd("BufLeave", {
      group = clear_grp,
      buffer = bufnr,
      once = true,
      callback = function()
        vim.api.nvim_win_set_option(splash_win, "number", vim.b[bufnr].splash_orig_number)
        vim.api.nvim_win_set_option(splash_win, "relativenumber", vim.b[bufnr].splash_orig_relativenumber)
      end,
    })

    vim.api.nvim_win_set_cursor(splash_win, {1, 0})
  end,
})

