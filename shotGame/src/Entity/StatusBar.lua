local StatusBar = class("StatusBar",function()
    return cc.Sprite:create()
end)
local config = require("inc.readConfig")
function StatusBar:create()--x,y is the position
    local instance = self:new()
    return instance
end

function StatusBar:ctor()--x,y is the position
    self._currentHPValue = config["StatusBar"]["_currentHPValue"] --角色当前血量
    self._totolHPValue = config["StatusBar"]["_totolHPValue"]--角色总血量
    self._totolMosterAmount = config["StatusBar"]["_totolMosterAmount"]--总共需要击杀的怪物数
    self._initMonsterAmount = config["StatusBar"]["_initMonsterAmount"]
    self._totolTime = config["StatusBar"]["_totolTime"] -- 通关限时
    self._startTime = os.time() -- 游戏开始时间   
    self._diedMonsterAmount = 0--已经死亡的怪物数
    self._HPSlider = nil --血条
    self._HPLabel = nil --数字表示的血量
    self._monsterLabel = nil --表示怪物的数量
    self._timeLabel = nil --表示所用时间
end 

function StatusBar:init()--x,y is the position
    self:createHPLabel()
    self:createHPSlider()
    self:createMonsterLabel()
    self:createTimeLabel()
end 

function StatusBar: getCurrentHPValue ()
    return self._currentHPValue
end

function StatusBar:getTotolHPValue()
    return self._totolHPValue
end

function StatusBar: setCurrentHPValue (value)
    self._currentHPValue = value
    self._HPLabel:setString(value .. "/" .. self:getTotolHPValue())
    self._HPSlider:setValue(value)
end

function StatusBar:setTotolHPValue(value)
    self._totolHPValue = value
end

function StatusBar:createHPSlider()
    self._HPSlider = cc.ControlSlider:create(cc.Sprite:create("../res/backGround.png"),cc.Sprite:create("../res/progress.png"),cc.Sprite:create("../res/sliderThumb.png"))
    self:addChild(self._HPSlider)
    self._HPSlider:setName("HPSlider")
    self._HPSlider:setMaximumValue(self._totolHPValue)
    self._HPSlider:setScale(2)
    self._HPSlider:setTouchEnabled(false)
    self._HPSlider:setVisible(true)
    self._HPSlider:setPosition(cc.p(0,0))
    self._HPSlider:setContentSize(300,10)
    self._HPSlider:setValue(self:getCurrentHPValue())
end 
function StatusBar:createHPLabel()
    self._HPLabel = cc.LabelTTF:create("", "Arial",30)
    self._HPLabel:setName("HPLabel")
    self._HPLabel:setColor(cc.c3b(255,0,0))
    self:addChild(self._HPLabel)
    self._HPLabel:setScale( 0.4)
    self._HPLabel:setColor(cc.c3b(0,0,0))
    self._HPLabel:setPosition(cc.p(-70,0))
end

function StatusBar:createMonsterLabel()
    self._monsterLabel = cc.LabelTTF:create("已杀怪物数/总怪物数:".. self._diedMonsterAmount .. "/" .. self._totolMosterAmount, "Arial",40)
    self._monsterLabel:setName("monsterLabel")
    self._monsterLabel:setColor(cc.c3b(255,0,0))
    self:addChild(self._monsterLabel)
    self._monsterLabel:setScale( 0.4)
    self._monsterLabel:setColor(cc.c3b(0,0,0))
    self._monsterLabel:setPosition(cc.p(100,0))
end

function StatusBar:createTimeLabel()
    print(self._totolTime)
    self._timeLabel = cc.LabelTTF:create("剩余时间/时间:".. 0 .. "/" .. self._totolTime, "Arial",40)
    self._timeLabel:setName("timeLabel")
    self._timeLabel:setColor(cc.c3b(255,0,0))
    self:addChild(self._timeLabel)
    self._timeLabel:setScale( 0.4)
    self._timeLabel:setColor(cc.c3b(0,0,0))
    self._timeLabel:setPosition(cc.p(400,0))
end

function StatusBar:getDiedMonsterAmount()
    return self._diedMonsterAmount
end

function StatusBar:setDiedMonsterAmount(n)
    self._diedMonsterAmount = self._diedMonsterAmount + n
    self._monsterLabel:setString("已杀怪物数/总怪物数:".. self._diedMonsterAmount .. "/" .. self._totolMosterAmount)
end

function StatusBar:showUsedTime()
    self._usedTime = os.time() - self._startTime
    self._timeLabel:setString("剩余时间/时间:".. self._usedTime .. "/" .. self._totolTime)
end

function StatusBar:getUsedTime()
    return os.time() - self._startTime
end

function StatusBar:getTotolTime()
    return self._totolTime
end

function StatusBar:getInitMonsterAmount()
    return self._initMonsterAmount
end

function StatusBar:getTotolMosterAmount()
    return self._totolMosterAmount
end

return StatusBar