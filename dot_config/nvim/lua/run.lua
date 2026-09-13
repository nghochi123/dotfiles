local M = {}

local state = {
    bufnr = nil,
    job_id = nil,
    winid = nil,
}

local function executable(names)
    for _, name in ipairs(names) do
        local path = vim.fn.exepath(name)
        if path ~= "" then
            return path
        end
    end
end

local function quote(value)
    return vim.fn.shellescape(value)
end

local function close_previous_terminal()
    if state.job_id and vim.fn.jobwait({ state.job_id }, 0)[1] == -1 then
        vim.fn.jobstop(state.job_id)
    end
    if state.winid and vim.api.nvim_win_is_valid(state.winid) then
        vim.api.nvim_win_close(state.winid, true)
    end
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        vim.api.nvim_buf_delete(state.bufnr, { force = true })
    end
    state = { bufnr = nil, job_id = nil, winid = nil }
end

local function run_in_terminal(command, display_name)
    close_previous_terminal()
    vim.cmd("botright split")
    local winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(winid, 15)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(winid, bufnr)
    vim.bo[bufnr].bufhidden = "wipe"
    vim.bo[bufnr].buflisted = false
    vim.api.nvim_buf_set_name(bufnr, "Run: " .. display_name)

    local job_id = vim.fn.termopen({ "sh", "-c", command }, {
        cwd = vim.fn.getcwd(),
        on_exit = function(_, code)
            if code == 0 then
                vim.schedule(function()
                    vim.notify("Finished: " .. display_name, vim.log.levels.INFO)
                end)
            end
        end,
    })
    state = { bufnr = bufnr, job_id = job_id, winid = winid }
    vim.cmd("startinsert")
end

local function current_python_file()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("Save the buffer before running it", vim.log.levels.WARN)
        return
    end
    if vim.bo.filetype ~= "python" then
        vim.notify("The current-file runner is configured for Python", vim.log.levels.WARN)
        return
    end
    if vim.bo.modified then
        vim.cmd.write()
    end
    return file
end

function M.current_file()
    local file = current_python_file()
    if not file then
        return
    end
    local python = executable({ "python3", "python" })
    if not python then
        vim.notify("No Python interpreter found", vim.log.levels.ERROR)
        return
    end
    run_in_terminal(table.concat({ quote(python), quote(file) }, " "), vim.fn.fnamemodify(file, ":t"))
end

function M.ruff_check()
    local file = current_python_file()
    if not file then
        return
    end

    local ruff = executable({ "ruff" })
    local command
    if ruff then
        command = table.concat({ quote(ruff), "check", quote(file) }, " ")
    else
        local uvx = executable({ "uvx" })
        if not uvx then
            vim.notify("Ruff and uvx are not available", vim.log.levels.ERROR)
            return
        end
        command = table.concat({ quote(uvx), "ruff", "check", quote(file) }, " ")
    end
    run_in_terminal(command, "Ruff: " .. vim.fn.fnamemodify(file, ":t"))
end

function M.setup()
    vim.api.nvim_create_user_command("RunFile", M.current_file, { desc = "Run the current Python file" })
    vim.api.nvim_create_user_command("RuffCheck", M.ruff_check, { desc = "Run Ruff on the current Python file" })
    vim.keymap.set("n", "<leader>r", M.current_file, { desc = "Run current Python file" })
    vim.keymap.set("n", "<leader>l", M.ruff_check, { desc = "Lint current Python file with Ruff" })
end

return M
