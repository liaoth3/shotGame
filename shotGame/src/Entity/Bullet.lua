local Bullet = class(
	"Bullet", function () return cc.Sprite:create("../res/bullet.png") end 
)
local config = require("inc.readConfig")
function Bullet.create()
    local instance = Bullet.new()
    instance:setContentSize(8,5)
    return instance
end

function Bullet:ctor()  
    self._isRunning = false
end

function Bullet:init()
	
end
	
function Bullet:show()
    self:setVisible(true)
end

function Bullet:hide()
    self:setVisible(false)
end

function Bullet:setRunningState(isRunning)
    self._isRunning = isRunning
end

function Bullet:getRunningState()
    return self._isRunning
end

return Bullet