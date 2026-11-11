local M = {}

---@type snacks.picker.Config
M.source = {
    title = "Tabs",
    preview = "file",
    format = function(item, picker)
        local ret = {
            { string.format("%d ", item.tabnr), "SnacksPickerIdx" },
        }
        vim.list_extend(ret, Snacks.picker.format.filename(item, picker))
        if item.others ~= "" then
            ret[#ret + 1] = { " " .. item.others, "SnacksPickerComment" }
        end
        return ret
    end,
    -- one item per tab showing its current window's file plus names of other windows in the tab
    finder = function()
        local items = {}
        for tabnr, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local win = vim.api.nvim_tabpage_get_win(tab)
            local names = {}
            for _, w in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
                local name = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
                if w ~= win and name ~= "" and vim.api.nvim_win_get_config(w).relative == "" then
                    table.insert(names, vim.fn.fnamemodify(name, ":t"))
                end
            end
            local file = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
            table.insert(items, {
                text = file .. " " .. table.concat(names, " "),
                tabnr = tabnr,
                tab = tab,
                file = file ~= "" and file or "[No Name]",
                pos = vim.api.nvim_win_get_cursor(win),
                others = table.concat(names, " "),
            })
        end
        return items
    end,
    -- confirm is an action rather than a top level field so it also works when the source is merged in
    -- a config hook as snacks resolves top level confirm before running hooks
    actions = {
        confirm = function(picker, item)
            picker:close()
            if item then
                vim.api.nvim_set_current_tabpage(item.tab)
            end
        end,
        tab_close = function(picker)
            for _, item in ipairs(picker:selected({ fallback = true })) do
                if vim.api.nvim_tabpage_is_valid(item.tab) and #vim.api.nvim_list_tabpages() > 1 then
                    vim.cmd.tabclose(vim.api.nvim_tabpage_get_number(item.tab))
                end
            end
            picker:find()
        end,
    },
    -- same keys as the snacks buffers picker uses for bufdelete.
    -- written the way snacks normalizes keys so merging in a config hook does not duplicate <c-x>
    win = {
        input = { keys = { ["<C-X>"] = { "tab_close", mode = { "n", "i" } } } },
        list = { keys = { ["dd"] = "tab_close" } },
    },
}

-- registers the tabs source so it opens with Snacks.picker.tabs() and is listed in Snacks.picker.pickers()
---@param opts? snacks.picker.Config overrides for the source
M.setup = function(opts)
    M.source = vim.tbl_deep_extend("force", M.source, opts or {})
    if Snacks and pcall(require, "snacks.picker") then
        Snacks.picker.sources.tabs = M.source
    else
        vim.notify("snacks-tabs: snacks.nvim picker is not available", vim.log.levels.ERROR)
    end
end

return M
