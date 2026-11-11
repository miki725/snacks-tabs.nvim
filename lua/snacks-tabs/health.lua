local M = {}

M.check = function()
    vim.health.start("snacks-tabs")
    if not (Snacks and pcall(require, "snacks.picker")) then
        vim.health.error("snacks.nvim picker is not available")
        return
    end
    vim.health.ok("snacks.nvim picker is available")
    -- includes sources added in the snacks config as well as ones registered by setup()
    if Snacks.picker.config.get().sources.tabs then
        vim.health.ok("tabs source is registered")
    else
        vim.health.warn(
            "tabs source is not registered",
            { 'call require("snacks-tabs").setup() or add require("snacks-tabs").source to snacks picker sources' }
        )
    end
end

return M
