local M = {}

local function visual_selection_range()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<esc>', true, false, true), 'x', false)
  local _, startRow, startCol, _ = unpack(vim.fn.getpos("'<"))
  local _, endRow, endCol, _ = unpack(vim.fn.getpos("'>"))
  if startRow < endRow or (startRow == endRow and startCol <= endCol) then
    return startRow -1, startCol, endRow, endCol
  else
    return endRow -1, endCol, startRow, startCol
  end
end


function M._align(searchChar, start, lines, pre)
  if pre == nil then
    pre = true
  end
  local cache = {}
  local max = 0

  for i, line in ipairs(lines) do
    local index = string.find(line, searchChar, start)
    if  index then
      max = math.max(max, index)
    end
  end

  if max == 0 then
    return lines
  end

  for _, line in ipairs(lines) do
    local index = string.find(line, searchChar, start)

    -- line without searchChar
    if not index then
      table.insert(cache, line)
      break;
    end

    local spaces = max - index
    local space = ""
    for i = 1, spaces do
      space = space .. " "
    end
    if pre then
      table.insert(cache, line:sub(1, index-1) .. space .. line:sub(index, #line))
    else
      table.insert(cache, line:sub(1, index) .. space .. line:sub(index+1, #line))
     end
  end
  return cache
end


function M.setup(opts)
  opts = opts or {}
  P(opts)
  vim.keymap.set("v", "<leader>h", function()
    local  startRow, _, endRow, _= visual_selection_range()
    local lines = vim.api.nvim_buf_get_lines(0, startRow, endRow, false)
    local alignedLines = M._align("=", 1, lines)
    vim.api.nvim_buf_set_lines(0, startRow, endRow, false, alignedLines)
  end)
end

return M
