-- Variab
local last_click_time = 0
local double_click_threshold = 300 
local last_buffer = nil 

-- Fun
local function clear_references(bufnr)
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
            vim.lsp.buf.clear_references()
        end)
    end
end

-- Function to handle double-click logic
local function on_double_click()
    local bufnr = vim.api.nvim_get_current_buf()

    clear_references(bufnr)

    
    vim.lsp.buf.document_highlight()

    if last_buffer and last_buffer ~= bufnr then
        clear_references(last_buffer)
    end

    last_buffer = bufnr
end

-- Autocommand to detect mouse clicks and emulate double-click behavior
vim.api.nvim_create_autocmd("CursorMoved", {
    pattern = "*",
    callback = function()
        local current_time = vim.loop.now()
        if current_time - last_click_time < double_click_threshold then
            on_double_click()
        end
        last_click_time = current_time
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "*",
    callback = function()
        if vim.api.nvim_get_current_buf() == last_buffer then
            clear_references(last_buffer)
        end
    end,
})
