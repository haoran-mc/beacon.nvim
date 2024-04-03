local M = {}

local config_module = require('beacon.config')
local utils = require('beacon.utils')
local fader = require('beacon.fader')

M.cursor_moved = function()
  fader.cursor_move()
end

M.highlight_position = function()
  fader.highlight_position()
end

M.clear_highlight = function()
  fader.clear_highlight()
end

M.load = function()
  fader.setup(config_module.items)
  utils.create_default_highlight_group()

  -- TODO highlight position false
  local ac = [[
        augroup BeaconHighlightMoves
            autocmd!
            silent autocmd CursorMoved * lua require'beacon'.cursor_moved()
            silent autocmd WinEnter * lua vim.schedule(function() require'beacon'.highlight_position() end)
            silent autocmd CmdwinLeave * lua require'beacon'.clear_highlight()
        augroup end
    ]]
  vim.cmd(ac)
  vim.cmd([[
        command! Beacon lua require'beacon'.highlight_position()
    ]])
end

-- beacon start
M.setup = function(opts)
  config_module.merge_config(opts)
  fader.setup(config_module.items)
end

return M
