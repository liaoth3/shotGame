local Bullet = class(
	"Bullet", function () return cc.Sprite:create("../res/bullet.png") end 
)
function Bullet:ctor()  
    self._range = 20 --子弹射程
end

function Bullet.create()
	local instance = Bullet.new()
	return instance
end

function Bullet:show()
    self:setVisible(true)
end

function Bullet:hdie()
    self:setVisible(false)
end


function Bullet:init()
	
end
	
return Bullet