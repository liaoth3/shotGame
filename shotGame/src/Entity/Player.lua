
local Player = class("Player",function()
    return cc.Sprite:create("../res/shizi.jpg")
end)
local Bullet = require("Entity.Bullet")
function Player:create()
    local instance = self.new()
    instance:setScale(0.15)
    return instance
end

function Player:init()
    self:collisionCheck()
    
end
function Player:createBullets()
    for k=1,self._bulletsAmount do
        local bullet = Bullet:create()
        bullet:setContentSize(8,5)
        bullet:setName("bullet" .. k)
        self:addChild(bullet)
        bullet:setPosition(self._centerPoint)
    end 

end

function Player:ctor()
    self._centerPoint = cc.p(10,20)    
    self._TotolHPValue = 1000 --总血量
    self._CurrentHPValue = 1000--当前血量
    self._isAlive = true --存活状况
    self._bulletsAmount = 10 --子弹足够
    self._range = 500   --子弹射程
    self._bulletSpeed = 5 -- 子弹移动速度 像素/帧
    self._isShotting = false --是否正在发送子弹
    self._power = 1 --子弹射程
    self:createBullets()
    self._scheduler = cc.Director:getInstance():getScheduler()
    --schedule(self, self.update, 1/60)
end
function Player:setPower(power)
    self._power = power
end

function Player:getPower(power)
    return self._power
end

function Player:shot()
    
end

function Player:collisionCheck()

end

return Player
