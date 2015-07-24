local Bullet = class(
	"Bullet", function () return cc.Sprite:create("../res/bullet.png") end 
)
function Bullet:ctor()  
    self._isRunning = false
end

function Bullet.create()
	local instance = Bullet.new()
	return instance
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


function Bullet:init()
	
end
	
return Bullet