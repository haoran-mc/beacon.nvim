local utils = require('beacon.utils')
local M = {}

local fake_buf = vim.api.nvim_create_buf(false, true)
local float_id = 0
local fade_timer = vim.loop.new_timer()
local config = nil
local ignore_buffers_set = {}
local ignore_filetypes_set = {}

-- 1. setup
M.setup = function(opts)
  config = opts
  for _, ignore_buffer in ipairs(config.ignore_buffers) do
    ignore_buffers_set[ignore_buffer] = true
  end
  for _, ignore_filetype in ipairs(config.ignore_filetypes) do
    ignore_filetypes_set[ignore_filetype] = true
  end
end

-- 2. highlight
M.highlight_position = function()
  if float_id > 0 then
    M.clear_highlight()
  end

  -- float window
  local win_config = vim.api.nvim_win_get_config(0)
  if win_config.relative and win_config.relative ~= '' then
    return
  end

  local fader_opts = {
    relative = 'cursor',
    width = math.max(vim.api.nvim_win_get_width(0) - vim.fn.wincol(), 1),
    col = 0,
    row = 0,
    height = 1,
    anchor = 'NW',
    style = 'minimal',
    focusable = false,
  }

  -- some plugins wipe out the buffer, so here need to create a new one
  if not vim.api.nvim_buf_is_valid(fake_buf) then
    fake_buf = vim.api.nvim_create_buf(false, true)
  end
  float_id = vim.api.nvim_open_win(fake_buf, false, fader_opts)
  vim.api.nvim_win_set_option(float_id, 'winhl', 'Normal:Beacon')
  vim.api.nvim_win_set_option(float_id, 'winblend', 70)

  vim.defer_fn(M.clear_highlight, config.timeout)
end

-- 3. clear highlight
M.clear_highlight = function()
  if float_id > 0 and vim.api.nvim_win_is_valid(float_id) then
    fade_timer:stop()
    vim.api.nvim_win_close(float_id, false)
    float_id = 0
  end
end

local prev_buf = 0
local prev_line = 0

-- 4. cursor move
M.cursor_move = function()
  local cur_buf = vim.fn.bufnr('%')
  local cur_line = vim.fn.line(".")
  local diff_line = math.abs(cur_line - prev_line)
  local win_height = math.max(vim.fn.winheight(0) - 1, 1)

  if cur_buf ~= prev_buf or diff_line >= win_height then
    if utils.is_ignored_filetype(ignore_filetypes_set)
      or utils.is_ignored_buffer(ignore_buffers_set) then
      return
    end

    vim.cmd("normal! zz")
    M.highlight_position()
  end
  prev_buf = cur_buf
  prev_line = cur_line
end

return M
