
local Player = class("Player",function()
    return cc.Sprite:create("../res/shizi.jpg")
end)
local Bullet = require("Entity.Bullet")
local config = require("inc.readConfig")
function Player:create()
    local instance = self.new()
    return instance
end

function Player:ctor()
    self._isAlive = true --存活状况
    self._centerPoint = cc.p(20,20)    
    self._totolHPValue = config["Player"]["_totolHPValue"] --总血量
    self._currentHPValue = config["Player"]["_currentHPValue"]--当前血量
    self._bulletsAmount = config["Player"]["_bulletsAmount"] --子弹足够
    self._range = config["Player"]["_range"]   --子弹射程
    self._bulletSpeed = config["Player"]["_bulletSpeed"] -- 子弹移动速度 像素/帧
    self._power = config["Player"]["_power"] --子弹威力
    self._moveSpeed = config["Player"]["_moveSpeed"] -- 每秒移动多少像素
    self._scheduler = cc.Director:getInstance():getScheduler()

end

function Player:init()
    self:createBullets()
    
    local function update()
        self:collisionCheck()
        self:shot(1)
    end
    self._scheduler:scheduleScriptFunc(update,1/60,false)

end
function Player:createBullets()
    for k=1,self._bulletsAmount do
        local bullet = Bullet:create()
        bullet:setName("bullet" .. k)
        self:addChild(bullet)
        bullet:setPosition(self._centerPoint)
    end 

end


function Player:setPower(power)
    self._power = power
end

function Player:getPower()
    return self._power
end


function Player: getCurrentHPValue ()
    return self._currentHPValue
end

function Player: setCurrentHPValue (value)
    self._currentHPValue = value
end

function Player:shot(shotSyle)
    -- print("shot")
    local intervalWidth = self._range / self._bulletsAmount
    local children = self:getChildren()
    for k,v in pairs(children) do
        if string.find(v:getName(),"bullet") and v:getRunningState() then
            local x,y = v:getPosition()
            x = x + self._bulletSpeed
            if x >= self._range then
                v:setPosition(self._centerPoint)
                v:hide()
                v:setRunningState(false)
            else
                v:setPosition(cc.p(x,y))
            end
        end
    end

    local min = self._range
    local isAllStatic = true 

    for k,v in pairs(children) do
        if string.find(v:getName(),"bullet") and v:getRunningState() then
            local x,y = v:getPosition()
            min = math.min(min,x)
            isAllStatic = false
        end
    end
    
    if min > intervalWidth+self._centerPoint.x or isAllStatic then
        for k,v in pairs(children) do
            if string.find(v:getName(),"bullet") and v:getRunningState()==false   then
                local x,y = v:getPosition()
                v:show()
                v:setRunningState(true)
                x = x + self._bulletSpeed
                v:setPosition(cc.p(x,y))
                break
            end
        end
    end

end
function Player:collisionCheck()
    local function isIntersect(a ,b)
       -- print(a.leftX,a.leftY,a.rightX,a.rightY)
       -- print(b.leftX,b.leftY,b.rightX,b.rightY)
        if a.rightX <b.leftX or a.leftX > b.rightX  or a.rightY <b.leftY or  a.leftY > b.rightY then
            return false
        end
        return true
    end
    local selfX,selfY = self:getPosition()
    local selfSize = self:getContentSize()
    local children = self:getParent():getChildren()
    local selfRect = {leftX=selfX-selfSize.width/2,leftY=selfY-selfSize.height/2,rightX=selfX+selfSize.width/2,rightY=selfY+selfSize.height/2 }
    for k,v in pairs(children) do
        if string.find(v:getName(),"monster") then
            local children_ = v:getChildren()
            local monsterX,monsterY = v:getPosition()
            for kk,vv in pairs(children_) do
                if string.find(vv:getName(),"bullet") then
                    if vv:getRunningState() then
                        local x,y = vv:getPosition()
                        local size = vv:getContentSize()
                        local rect = {leftX=monsterX+x-size.width/2,leftY=monsterY+y-size.height/2,rightX=monsterX+x+size.width/2,rightY=monsterY+y+size.height/2 }
                        local isCollision = isIntersect(selfRect,rect)
                       -- print(isCollision)
                        if isCollision then
                            self:setCurrentHPValue(self:getCurrentHPValue()-v:getPower())
                            
                        end
                    end

                end
            end
        end
    end
end

function Player:setMoveSpeed(speed)
    self._moveSpeed = speed
end 

function Player:getMoveSpeed()
    return self._moveSpeed 
end

return Player
