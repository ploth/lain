--[[

     Licensed under GNU General Public License v2
      * (c) 2013, Luke Bonham

--]]

local helpers  = require("lain.helpers")
local wibox    = require("wibox")

-- coretemp
-- lain.widget.temp

local function factory(args)
    local console  = { widget = wibox.widget.textbox() }
    local args     = args or {}
    local name     = args.name
    local commands = args.commands
    local timeout  = args.timeout or 2
    local settings = args.settings or function() end

    function console.update()
      outputs = {}
      for i,command in ipairs(commands) do
        local output = ""
        local f = io.popen(command)
        if f then
            output = f:read("*all")
            f:close()
        else
            output = "N/A"
        end
        -- Remove newline and add whitespace to string
        table.insert(outputs,output)
      end
      widget = console.widget
      settings()
    end

    helpers.newtimer(name, timeout, console.update)

    return console
end

return factory
