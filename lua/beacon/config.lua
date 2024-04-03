local M = {}

M.items = {
  timeout = 200,
  ignore_buffers = {},
  ignore_filetypes = {},
}

M.merge_config = function(opts)
  opts = opts or {}
  M.items = vim.tbl_deep_extend('force', M.items, opts)
end

return M
