
local LoseScene = class("LoseScene",function()
    return cc.Scene:create()
end)
function LoseScene:create()
    local scene = self.new()
    return scene
end

function LoseScene:ctor()
    
end

function LoseScene:init()
    self:createLabel()
end

function LoseScene:createLabel()
    local layer = cc.Layer:create()
    local label = cc.LabelTTF:create("Game over !", "Arial",40)
    label:setColor(cc.c3b(255,0,0))
    layer:addChild(label)
    label:setPosition(cc.p(cc.Director:getInstance():getWinSize().width/2,cc.Director:getInstance():getWinSize().height/2))
    self:addChild(layer)
end

return LoseScene
