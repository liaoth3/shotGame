local WinScene = class("WinScene",function()
    return cc.Scene:create()
end)

function WinScene:create()
   local instance = self.new()
   return instance
end

function WinScene:ctor()
   
end

function WinScene:init()
    self:createLabel()
end
function WinScene:createLabel()
    local layer = cc.Layer:create()
    local label = cc.LabelTTF:create("you win !", "Arial",40)
    label:setColor(cc.c3b(255,0,0))
    layer:addChild(label)
    label:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(layer)
end
return WinScene