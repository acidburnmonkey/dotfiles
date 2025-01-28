-- Variable to track highlight state
local highlight_enabled = false

-- Variab
local last_click_time = 0
local double_click_threshold = 300 
local last_buffer = nil 

-- Function to clear references
local function clear_references(bufnr)
    if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
        vim.api.nvim_buf_call(bufnr, function()
            vim.lsp.buf.clear_references()
        end)
    end
end

-- Function to handle double-click logic
local function on_double_click()
    if not highlight_enabled then
        return
    end

    local bufnr = vim.api.nvim_get_current_buf()
    clear_references(bufnr)
    
    vim.lsp.buf.document_highlight()

    if last_buffer and last_buffer ~= bufnr then
        clear_references(last_buffer)
    end

    last_buffer = bufnr
end

-- Autocommands
local group = vim.api.nvim_create_augroup("HighlightToggle", { clear = true })

vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    pattern = "*",
    callback = function()
        if highlight_enabled then
            local current_time = vim.loop.now()
            if current_time - last_click_time < double_click_threshold then
                on_double_click()
            end
            last_click_time = current_time
        end
    end,
})

vim.api.nvim_create_autocmd("BufLeave", {
    group = group,
    pattern = "*",
    callback = function()
        if highlight_enabled and vim.api.nvim_get_current_buf() == last_buffer then
            clear_references(last_buffer)
        end
    end,
})

-- Command to toggle highlight functionality
vim.api.nvim_create_user_command("ToggleHighlight", function()
    highlight_enabled = not highlight_enabled
    if not highlight_enabled then
        print("Highlighting Disabled")
        -- Clear references if disabling
        if last_buffer then
            clear_references(last_buffer)
        end
    else
        print("Highlighting Enabled")
    end
end, {})


