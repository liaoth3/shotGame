local StatusBar = class("StatusBar",function()
    return cc.Sprite:create()
end)
function StatusBar:create()--x,y is the position
    local instance = self:new()
    return instance
end

function StatusBar:ctor()--x,y is the position
    self._currentHPValue = 1000
    self._totolHPValue = 1000
    self._HPSlider = nil --血条
    self._HPLabel = nil --数字表示的血量
end 

function StatusBar:init()--x,y is the position
    self:CreateHPLabel()
    self:createHPSlider()
end 

function StatusBar: getCurrentHPValue ()
    return self._currentHPValue
end

function StatusBar:getTotolHPValue()
    return self._totolHPValue
end

function StatusBar: setCurrentHPValue (value)
    self._currentHPValue = value
end

function StatusBar:setTotolHPValue(value)
    self._totolHPValue = value
end

function StatusBar:setLabelHPValue(value)
    self._HPLabel:setString(value .. "/" .. self:getTotolHPValue())
end

function StatusBar:createHPSlider()
    self._HPSlider = cc.ControlSlider:create(cc.Sprite:create("../res/backGround.png"),cc.Sprite:create("../res/progress.png"),cc.Sprite:create("../res/sliderThumb.png"))
    self:addChild(self._HPSlider)
    self._HPSlider:setName("HPSlider")
    self._HPSlider:setMaximumValue(1000)
    self._HPSlider:setScale(2)
    self._HPSlider:setTouchEnabled(false)
    self._HPSlider:setVisible(true)
    self._HPSlider:setPosition(cc.p(0,0))
    self._HPSlider:setContentSize(300,10)
    self._HPSlider:setValue(self:getCurrentHPValue())
end 
function StatusBar:CreateHPLabel()
    self._HPLabel = cc.LabelTTF:create("100", "Arial",30)
    self._HPLabel:setName("HPLabel")
    self._HPLabel:setColor(cc.c3b(255,0,0))
    self:addChild(self._HPLabel)
    self._HPLabel:setScale( 0.4)
    --self._HPLabel:setContentSize(300,0)
    self:setLabelHPValue(self:getTotolHPValue())
    self._HPLabel:setColor(cc.c3b(0,0,0))
    self._HPLabel:setPosition(cc.p(-70,0))
end
return StatusBar