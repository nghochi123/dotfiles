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

local function command_for_buffer(file, filetype)
    local file_arg = quote(file)
    local interpreter = {
        python = { "python3", "python" },
        lua = { "lua" },
        javascript = { "node" },
        sh = { "sh" },
        bash = { "bash" },
        zsh = { "zsh" },
        fish = { "fish" },
        ruby = { "ruby" },
        perl = { "perl" },
        php = { "php" },
        vim = { "nvim" },
    }

    if interpreter[filetype] then
        local path = executable(interpreter[filetype])
        if filetype == "lua" and not path then
            path = executable({ "nvim" })
            if path then
                return table.concat({ quote(path), "--headless", "-u", "NONE", "-l", file_arg }, " ")
            end
        end
        if not path then
            return nil, ("No interpreter found for %s"):format(filetype)
        end
        if filetype == "vim" then
            return table.concat({ quote(path), "--headless", "-u", "NONE", "-S", file_arg, "+qa" }, " ")
        end
        return table.concat({ quote(path), file_arg }, " ")
    end

    if filetype == "typescript" or filetype == "typescriptreact" then
        local path = executable({ "bun", "tsx", "deno" })
        if not path then
            return nil, "Install bun, tsx, or deno to run TypeScript files"
        end
        if vim.fn.fnamemodify(path, ":t") == "deno" then
            return table.concat({ quote(path), "run", file_arg }, " ")
        end
        if vim.fn.fnamemodify(path, ":t") == "tsx" then
            return table.concat({ quote(path), file_arg }, " ")
        end
        return table.concat({ quote(path), "run", file_arg }, " ")
    end

    if filetype == "javascriptreact" then
        local path = executable({ "bun", "tsx" })
        if not path then
            return nil, "Install bun or tsx to run JSX files"
        end
        if vim.fn.fnamemodify(path, ":t") == "tsx" then
            return table.concat({ quote(path), file_arg }, " ")
        end
        return table.concat({ quote(path), "run", file_arg }, " ")
    end

    if filetype == "go" then
        local path = executable({ "go" })
        if not path then
            return nil, "Install Go to run Go files"
        end
        return table.concat({ quote(path), "run", file_arg }, " ")
    end

    if filetype == "make" then
        local path = executable({ "make" })
        if not path then
            return nil, "Install make to run Makefiles"
        end
        return table.concat({ quote(path), "-f", file_arg }, " ")
    end

    if filetype == "c" or filetype == "cpp" then
        local compiler = filetype == "c"
            and executable({ "cc", "gcc", "clang" })
            or executable({ "c++", "g++", "clang++" })
        if not compiler then
            return nil, ("No C%s compiler found"):format(filetype == "c" and "" or "++")
        end
        local cache = vim.fn.stdpath("cache") .. "/run"
        vim.fn.mkdir(cache, "p")
        local stem = vim.fn.fnamemodify(file, ":t:r")
        local output = cache .. "/" .. stem .. "-" .. vim.fn.sha256(file):sub(1, 8)
        return table.concat({
            quote(compiler),
            file_arg,
            "-o",
            quote(output),
            "&&",
            quote(output),
        }, " ")
    end

    if filetype == "rust" then
        local compiler = executable({ "rustc" })
        if not compiler then
            return nil, "Install rustc to run Rust files"
        end
        local cache = vim.fn.stdpath("cache") .. "/run"
        vim.fn.mkdir(cache, "p")
        local stem = vim.fn.fnamemodify(file, ":t:r")
        local output = cache .. "/" .. stem .. "-" .. vim.fn.sha256(file):sub(1, 8)
        return table.concat({ quote(compiler), file_arg, "-o", quote(output), "&&", quote(output) }, " ")
    end

    if vim.fn.executable(file) == 1 then
        return file_arg
    end
end

local function close_previous_terminal()
    if state.job_id then
        local status = vim.fn.jobwait({ state.job_id }, 0)[1]
        if status == -1 then
            vim.fn.jobstop(state.job_id)
        end
    end
    if state.winid and vim.api.nvim_win_is_valid(state.winid) then
        vim.api.nvim_win_close(state.winid, true)
    end
    if state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
        vim.api.nvim_buf_delete(state.bufnr, { force = true })
    end
    state = { bufnr = nil, job_id = nil, winid = nil }
end

function M.current_file()
    local file = vim.api.nvim_buf_get_name(0)
    if file == "" then
        vim.notify("Save the buffer before running it", vim.log.levels.WARN)
        return
    end
    if vim.bo.modified then
        vim.cmd.write()
    end

    local command, error_message = command_for_buffer(file, vim.bo.filetype)
    if not command then
        vim.notify(error_message or ("No runner configured for filetype: " .. (vim.bo.filetype or "unknown")), vim.log.levels.WARN)
        return
    end

    close_previous_terminal()
    vim.cmd("botright split")
    local winid = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_height(winid, 15)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(winid, bufnr)
    vim.bo[bufnr].bufhidden = "wipe"
    vim.bo[bufnr].buflisted = false
    vim.api.nvim_buf_set_name(bufnr, "Run: " .. vim.fn.fnamemodify(file, ":t"))

    local job_id = vim.fn.termopen({ "sh", "-c", command }, {
        cwd = vim.fn.getcwd(),
        on_exit = function(_, code)
            if code == 0 then
                vim.schedule(function()
                    vim.notify("Finished: " .. vim.fn.fnamemodify(file, ":t"), vim.log.levels.INFO)
                end)
            end
        end,
    })
    state = { bufnr = bufnr, job_id = job_id, winid = winid }
    vim.cmd("startinsert")
end

function M.setup()
    vim.api.nvim_create_user_command("RunFile", M.current_file, { desc = "Run the current file" })
    vim.keymap.set("n", "<leader>r", M.current_file, { desc = "Run current file" })
end

return M
