-- Copy the file name of the current file

require 'mp'
require 'mp.msg'

local utils = require 'mp.utils'
local workdir = utils.to_string(mp.get_property_native("working-directory"))
assert(not string.find(workdir, "\\"));

local function cmd(text)
    if os.getenv('XDG_SESSION_TYPE') == 'wayland' then
        return {'wl-copy', text}
    else
        return {'xclip', '-silent',  '-in',  '-selection', 'clipboard', text}
    end
end

local function copy_file_name()
    local file = mp.get_property_osd("path")

    mp.command_native_async({'run', unpack(cmd(file))}, function(suc, _, err)
        mp.osd_message(suc and 'Copied file name or URL to clipboard' or err, 1)
    end)
end

local function copy_full_path()
    path = string.format("%s/%s", mp.get_property_osd("working-directory"), mp.get_property_osd("path"))

    mp.command_native_async({'run', unpack(cmd(path))}, function(suc, _, err)
        mp.osd_message(suc and 'Copied full file path to clipboard' or err, 1)
    end)
end

-- Key-Bindings
mp.add_key_binding("c", "copy_file_name", copy_file_name)
mp.add_key_binding("p", "copy_full_path", copy_full_path)
