
local GameScene = class("GameScene",function()
    return cc.Scene:create()
end)

local DirectionController = require("Controller.DirectionController")
function GameScene:create()
    local scene = self.new()
    return scene
end

function GameScene:ctor()
   
end

function GameScene:init()
    local directionController = DirectionController:create()
    directionController:init()
    self:addChild(directionController)
    
end

return GameScene
