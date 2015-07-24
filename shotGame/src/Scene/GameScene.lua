
local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)
local TmxLayer = require("Layer.TMXLayer")
local DirectionController = require("Controller.DirectionController")
function GameScene:create()
    local scene = self.new()
    local directionController = DirectionController:create()
    scene:addChild(directionController)
    directionController:init()
    return scene
end
return GameScene
