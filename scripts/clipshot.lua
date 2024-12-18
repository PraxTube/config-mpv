-- Screenshot the current frame and copy it to the clipboard

local ClipshotOptions = {
    name = 'mpv-clipshot-screenshot.png',
    type = 'png'
}
require('mp.options').read_options(ClipshotOptions, 'clipshot')

local file, cmd

local platform = mp.get_property_native('platform')
assert(platform ~= 'windows')
assert(platform ~= 'darwin')

file = '/tmp/'..ClipshotOptions.name
if os.getenv('XDG_SESSION_TYPE') == 'wayland' then
    cmd = {'sh', '-c', ('wl-copy < %q'):format(file)}
else
    local type = ClipshotOptions.type ~= '' and ClipshotOptions.type or 'image/jpeg'
    cmd = {'xclip', '-sel', 'c', '-t', type, '-i', file}
end

local function clipshot()
    mp.commandv('screenshot-to-file', file)
    mp.command_native_async({'run', unpack(cmd)}, function(suc, _, err)
        mp.osd_message(suc and 'Copied screenshot to clipboard' or err, 1)
    end)
end

mp.add_key_binding("C", "clipshot", clipshot)
