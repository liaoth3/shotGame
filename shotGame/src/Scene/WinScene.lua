
local WinScene = class("WinScene",function()
    return cc.Scene:create()
end)
function WinScene:create()
    local scene = self.new()
    return scene
end
return WinScene
