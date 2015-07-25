
local Monster = class("Monster",function()
    return cc.Sprite:create("../res/player.png")
end)

local Bullet = require("Entity.Bullet")

function Monster:create(name,x,y)--x,y is the position
    local instance = self.new()
    instance:setName(name)
    instance:setPosition(cc.p(x,y))
    --self:BindBloodSlider()
    return instance
end

function Monster:hide()
    self:setVisible(false)
end

function Monster:show()
    self:setVisible(true)
end

function Monster:shot(shouldShot)
    
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
    if shouldShot then 
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
end

function Monster:didShot()
    local player = self:getParent():getChildByName("player")
    local x,y = self:getPosition()
    local x1,y1 = player:getPosition()
    local diff = cc.pSub(cc.p(x,y),cc.p(x1,y1))
    local distance = math.sqrt(math.pow(diff.x,2),math.pow(diff.y,2))    
    if distance < self._attackRadius then
        return true
    end
    return false; 
end

function Monster:collisionCheck()
    local function isIntersect(a ,b)
        --print(a.leftX,a.leftY,a.rightX,a.rightY)
        --print(b.leftX,b.leftY,b.rightX,b.rightY)
        if a.rightX <b.leftX or a.leftX > b.rightX  or a.rightY <b.leftY or  a.leftY > b.rightY then
            return false
        end
        return true
    end
    local player = self:getParent():getChildByName("player")
    local playerPositionX,playerPositionY = player:getPosition()
    local playerSize = player:getContentSize()
    local selfSize = self:getContentSize()
    local selfX,selfY = self:getPosition()
    local selfRect = {leftX=selfX-selfSize.width/2,leftY=selfY-selfSize.height/2,rightX=selfX+selfSize.width/2,rightY=selfY+selfSize.height/2 }
    local children = player:getChildren()
    local count = 0
    for k,v in pairs(children) do
        if string.find(v:getName(),"bullet") then
            local x,y = v:getPosition()
            local size = v:getContentSize()
            local bulletRect = {leftX=playerPositionX+x-size.width/2,leftY=playerPositionY+y-size.height/2,rightX=playerPositionX+x+size.width/2,rightY=playerPositionY+y+size.height/2 }
            if isIntersect(selfRect,bulletRect) then
                self:setCurrentHPValue(self:getCurrentHPValue()-10*player:getPower())
            end
        end
    end
    --print(count)
end

function Monster.update(self)
    self:collisionCheck()
    if(self:getCurrentHPValue()<=0)then
        self:setAliveState(false)
        self:hide()
    end
    self:shot(self:didShot())
    self._HPSlider:setValue(self:getCurrentHPValue())
    self._HPLabel:setString(self:getCurrentHPValue() .. "/" .. self:getTotolHPValue() )
end

function Monster:createHPSlider()
    self._HPSlider = cc.ControlSlider:create(cc.Sprite:create("../res/backGround.png"),cc.Sprite:create("../res/progress.png"),cc.Sprite:create("../res/sliderThumb.png"))
    self:addChild(self._HPSlider)
    self._HPSlider:setPosition(cc.p(12,self._HPSlider:getParent():getContentSize().height))
    self._HPSlider:setMaximumValue(1000)
    self._HPSlider:setScale(0.5)
    self._HPSlider:setTouchEnabled(false)
    self._HPSlider:setVisible(true)
    self._HPSlider:setValue(self:getCurrentHPValue())
end 

function Monster:CreateHPLabel()
    self._HPLabel = cc.LabelAtlas:_create("100", "fonts/tuffy_bold_italic-charmap.plist")
    --self._HPLabel:retain()
    self:addChild(self._HPLabel)
    self._HPLabel:setScale( 0.12 )
    self._HPLabel:setString(self:getCurrentHPValue() .. "/" .. self:getTotolHPValue())
    self._HPLabel:setColor(cc.c3b(0,0,0))
    self._HPLabel:setPosition(cc.p(-12,self._HPLabel:getParent():getContentSize().height+5))
    
end

function Monster: getCurrentHPValue ()
    return self._CurrentHPValue
end

function Monster:getTotolHPValue()
	return self._TotolHPValue
end

function Monster: setCurrentHPValue (value)
    self._CurrentHPValue = value
end

function Monster:setTotolHPValue(value)
    self._TotolHPValue = value
end

function Monster:setAliveState(isAlive)
    self._isAlive = isAlive
end

function Monster:getAliveState()
    return self._isAlive == isAlive
end

function Monster:relive()
    self:setCurrentHPValue(self:getTotolHPValue())
    self._isAlive = true
    self:show()
end



function Monster:createBullets()
    for k=1,self._bulletsAmount do
        local bullet = Bullet:create()
        bullet:setContentSize(8,5)
        bullet:setName("bullet" .. k)
        self:addChild(bullet)
        bullet:setPosition(self._centerPoint)
    end 

end
function Monster:ctor()
    self._centerPoint = cc.p(10,20)    self._TotolHPValue = 1000 --总血量
    self._CurrentHPValue = 1000--当前血量
    self._attackRadius = 100 --角色在该范围内，怪物会发动攻击
    self._isAlive = true --怪物存活状况
    self._HPSlider = nil --血条
    self._HPLabel = nil --数字表示的血量
    self._bulletsAmount = 10 --子弹数量
    self._range = 500   --子弹射程
    self._bulletSpeed = 5 -- 子弹移动速度 像素/帧
    self._isShotting = false --是否正在发送子弹
    self:createBullets()
    self:CreateHPLabel()
    self:createHPSlider()
    self._scheduler = cc.Director:getInstance():getScheduler()
    schedule(self, self.update, 1/60)
end

return Monster
