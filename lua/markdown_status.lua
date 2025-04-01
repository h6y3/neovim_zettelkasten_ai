-- markdown_status.lua
-- Module for managing markdown file status in frontmatter

local M = {}

-- Valid status values
M.valid_statuses = {"unread", "wip", "complete"}

-- Function to cycle through statuses
function M.cycle_status()
  -- Get current buffer content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Check if file has frontmatter (starts with ---)
  if #lines == 0 or lines[1] ~= "---" then
    vim.notify("No frontmatter found in this file", vim.log.levels.WARN)
    return
  end
  
  -- Find the end of frontmatter and the status line
  local frontmatter_end = -1
  local status_line = -1
  local current_status = nil
  
  for i, line in ipairs(lines) do
    if i > 1 and line == "---" then
      frontmatter_end = i
      break
    end
    
    -- Check if this is the status line
    local status_match = line:match("^status:%s*(.+)$")
    if status_match then
      status_line = i
      current_status = vim.trim(status_match)
    end
  end
  
  -- Validate frontmatter
  if frontmatter_end == -1 then
    vim.notify("Incomplete frontmatter (missing closing ---)", vim.log.levels.WARN)
    return
  end
  
  -- If no status line found, create one before the end of frontmatter
  if status_line == -1 then
    -- Insert a new status line before the end of frontmatter
    table.insert(lines, frontmatter_end, "status: unread")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.notify("Added status: unread", vim.log.levels.INFO)
    return
  end
  
  -- Find the next status in the cycle
  local next_status = "unread" -- Default if current status is invalid
  local found_current = false
  
  for i, status in ipairs(M.valid_statuses) do
    if status == current_status then
      found_current = true
      -- Get next status or wrap around to first
      next_status = M.valid_statuses[i % #M.valid_statuses + 1]
      break
    end
  end
  
  if not found_current then
    vim.notify("Current status '" .. (current_status or "nil") .. "' is not valid, resetting to 'unread'", vim.log.levels.WARN)
  end
  
  -- Update the status line
  lines[status_line] = "status: " .. next_status
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify("Status changed to: " .. next_status, vim.log.levels.INFO)
  
  -- Mark buffer as modified
  vim.opt.modified = true
end

-- Function to set a specific status
function M.set_status(status)
  -- Validate the status
  local valid = false
  for _, valid_status in ipairs(M.valid_statuses) do
    if status == valid_status then
      valid = true
      break
    end
  end
  
  if not valid then
    vim.notify("Invalid status: " .. status .. ". Valid options are: " .. table.concat(M.valid_statuses, ", "), vim.log.levels.ERROR)
    return
  end
  
  -- Get current buffer content
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  
  -- Check if file has frontmatter (starts with ---)
  if #lines == 0 or lines[1] ~= "---" then
    vim.notify("No frontmatter found in this file", vim.log.levels.WARN)
    return
  end
  
  -- Find the end of frontmatter and the status line
  local frontmatter_end = -1
  local status_line = -1
  
  for i, line in ipairs(lines) do
    if i > 1 and line == "---" then
      frontmatter_end = i
      break
    end
    
    -- Check if this is the status line
    if line:match("^status:") then
      status_line = i
    end
  end
  
  -- Validate frontmatter
  if frontmatter_end == -1 then
    vim.notify("Incomplete frontmatter (missing closing ---)", vim.log.levels.WARN)
    return
  end
  
  -- If no status line found, create one before the end of frontmatter
  if status_line == -1 then
    -- Insert a new status line before the end of frontmatter
    table.insert(lines, frontmatter_end, "status: " .. status)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  else
    -- Update the existing status line
    lines[status_line] = "status: " .. status
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  end
  
  vim.notify("Status set to: " .. status, vim.log.levels.INFO)
  
  -- Mark buffer as modified
  vim.opt.modified = true
end

return M
