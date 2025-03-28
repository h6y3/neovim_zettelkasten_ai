-- markdown_status_filter.lua
-- Place this in ~/.config/nvim/lua/

-- Utility function to read frontmatter from a file
local function get_frontmatter_status(file_path)
    local file = io.open(file_path, "r")
    if not file then return nil end
    
    local content = file:read(4096) -- Read just the first 4KB (enough for frontmatter)
    file:close()
    
    -- Only process if file starts with frontmatter delimiter
    if not content or not content:match("^%-%-%-") then return nil end
    
    -- Extract frontmatter between --- markers
    local frontmatter = content:match("^%-%-%-(.-)%-%-%-")
    if not frontmatter then return nil end
    
    -- Look for status field with flexible parsing
    -- Match different variations of status specification
    local status = frontmatter:match("status%s*:%s*([%w_%-]+)")
                or frontmatter:match("status%s*=%s*['\"]*([%w_%-]+)['\"]*")
                or frontmatter:match("['\"]*status['\"]*%s*:%s*['\"]*([%w_%-]+)['\"]*")
    
    return status
end

-- Function to filter markdown files by status
local function filter_by_status(status_value)
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local previewers = require("telescope.previewers")
    
    -- Find all markdown files in the current directory and subdirectories
    local md_files = vim.fn.glob(vim.fn.getcwd() .. "/**/*.md", false, true)
    local filtered_files = {}
    
    -- Process status filter
    for _, file in ipairs(md_files) do
        local file_status = get_frontmatter_status(file)
        if file_status and (status_value == "all" or file_status:lower() == status_value:lower()) then
            table.insert(filtered_files, {
                filename = file,
                display = vim.fn.fnamemodify(file, ":t") .. " [" .. file_status .. "]", 
                ordinal = vim.fn.fnamemodify(file, ":t") .. " " .. file_status,
                status = file_status
            })
        end
    end
    
    -- Sort results by status and then by filename
    table.sort(filtered_files, function(a, b)
        if a.status == b.status then
            return a.filename < b.filename
        else
            return a.status < b.status
        end
    end)
    
    -- Create the picker
    pickers.new({}, {
        prompt_title = "Markdown Files with Status: " .. status_value,
        finder = finders.new_table({
            results = filtered_files,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.display,
                    ordinal = entry.ordinal,
                    filename = entry.filename,
                    status = entry.status,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        previewer = previewers.vim_buffer_cat.new({}),
        attach_mappings = function(prompt_bufnr, map)
            -- Add action to change status directly from the picker
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                vim.cmd('edit ' .. selection.filename)
            end)
            
            -- Add a custom mapping to change status
            map('i', '<C-s>', function()
                local selection = action_state.get_selected_entry()
                local new_status = vim.fn.input("New status: ")
                if new_status ~= "" then
                    -- Open the file, find the status line and change it
                    local file_content = {}
                    local file = io.open(selection.filename, "r")
                    if file then
                        for line in file:lines() do
                            table.insert(file_content, line)
                        end
                        file:close()
                        
                        local found = false
                        for i, line in ipairs(file_content) do
                            if line:match("status%s*:") then
                                file_content[i] = line:gsub("status%s*:%s*[%w_%-]+", "status: " .. new_status)
                                found = true
                                break
                            end
                        end
                        
                        if found then
                            file = io.open(selection.filename, "w")
                            if file then
                                for _, line in ipairs(file_content) do
                                    file:write(line .. "\n")
                                end
                                file:close()
                                
                                -- Update the display in telescope
                                selection.status = new_status
                                selection.display = vim.fn.fnamemodify(selection.filename, ":t") .. " [" .. new_status .. "]"
                                selection.ordinal = vim.fn.fnamemodify(selection.filename, ":t") .. " " .. new_status
                                
                                -- Refresh the picker
                                action_state.get_current_picker(prompt_bufnr):refresh(finders.new_table({
                                    results = filtered_files,
                                    entry_maker = function(entry)
                                        return {
                                            value = entry,
                                            display = entry.display,
                                            ordinal = entry.ordinal,
                                            filename = entry.filename,
                                            status = entry.status,
                                        }
                                    end,
                                }), { reset_prompt = true })
                            end
                        end
                    end
                end
            end)
            
            return true
        end,
    }):find()
end

-- Create status count function to show overview
local function count_status_types()
    local md_files = vim.fn.glob(vim.fn.getcwd() .. "/**/*.md", false, true)
    local status_counts = {}
    local total_files = 0
    local files_with_status = 0
    
    for _, file in ipairs(md_files) do
        total_files = total_files + 1
        local status = get_frontmatter_status(file)
        if status then
            files_with_status = files_with_status + 1
            status_counts[status] = (status_counts[status] or 0) + 1
        end
    end
    
    -- Display results
    print("Markdown Status Overview:")
    print("-------------------------")
    print("Total markdown files: " .. total_files)
    print("Files with status: " .. files_with_status)
    print("Status breakdown:")
    
    local sorted_statuses = {}
    for status, _ in pairs(status_counts) do
        table.insert(sorted_statuses, status)
    end
    table.sort(sorted_statuses)
    
    for _, status in ipairs(sorted_statuses) do
        print("  " .. status .. ": " .. status_counts[status])
    end
end

-- Export functions
return {
    filter_by_status = filter_by_status,
    count_status_types = count_status_types
}
