local helpers        = require("lain.helpers")
local wibox           = require("wibox")

local function worker(args)
  local maildir      = { widget = wibox.widget.textbox() }
  local args         = args or {}
  local timeout      = args.timeout or 60
  local mailpathes   = args.mailpathes
  local settings     = args.settings or function() end

  function maildir.update()
    nummails = {}
    for i,mailpath in ipairs(mailpathes) do
      local f = io.popen("/bin/ls -afq " .. mailpath .. "/new | wc -l")
      local s = f:read("*all")
      f:close()
      local new = tonumber(s)- 2
      local f = io.popen("find " .. mailpath .. "/cur -type f -regex '.*/cur/.*2,[^S]*$' | wc -l")
      local s = f:read("*all")
      f:close()
      local oldnew = tonumber(s)
      table.insert(nummails, new + oldnew)
    end
    widget = maildir.widget
    settings()
  end

  helpers.newtimer("mail", timeout, maildir.update)

  return maildir
end

return worker
