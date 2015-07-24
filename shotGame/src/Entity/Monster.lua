
local Monster = class("Monster",function()
    return cc.Sprite:create("../res/player.png")
end)

local Bullet = require("Entity.Bullet")

function Monster:create(name,x,y)--x,y is the position
    local sprite = self.new()
    sprite:setName(name)
    sprite:setPosition(cc.p(x,y))
    --self:BindBloodSlider()
    return sprite
end

function Monster:hide()--x,y is the position
    self:setVisible(false)
end

function Monster:show()--x,y is the position
    self:setVisible(true)
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

function Monster:setAliveState(isAlive)
    return self._isAlive == isAlive
end

function Monster:relive()
    self:setCurrentHPValue(self:getTotolHPValue())
    self._isAlive = true
    self:show()
end

function Monster.update(self)
    self:setCurrentHPValue(self:getCurrentHPValue()-100)
    if(self:getCurrentHPValue()<=0)then
        self:setAliveState(false)
        self:hide()
    end
    self._HPSlider:setValue(self:getCurrentHPValue())
    self._HPLabel:setString(self:getCurrentHPValue() .. "/" .. self:getTotolHPValue() )
end

function Monster:createBullet()
    for k=1,self._bulletAmount do
        local bullet = Bullet:create()
        --bullet:retain()
        self._bullets[k] = bullet
        bullet:hide()
        self:addChild(bullet)
    end 
    
    
end
function Monster:ctor()
    self._TotolHPValue = 1000 --总血量
    self._CurrentHPValue = 1000--当前血量
    self._isAlive = true --怪物存活状况
    self._HPSlider = nil --血条
    self._HPLabel = nil --数字表示的血量
    self._bullets = {} -- 子弹
    self._bulletAmount = 10 --子弹数量
    self:CreateHPLabel()
    self:createHPSlider()
    self._scheduler = cc.Director:getInstance():getScheduler()
    schedule(self, self.update, 1)
end

return Monster
