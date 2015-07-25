local DirectionController = class("DirectionController",function()
    return cc.Layer:create()
end)

local StatusBar = require("Entity.StatusBar")
local TMXLayer = require("Layer.TMXLayer")
local schduler = cc.Director:getInstance():getScheduler()

function DirectionController:create()
    local instance = self.new()
    instance:setName("directionControler")
    return instance;
end 

function DirectionController:init()
    self:stopMapShaking()
    self:BindOnTouchesEvents()
    local function update()
        local moveDistance = 2
        math.randomseed(os.time())
        local playerPositionX,playerPositionY = self._TMXLayer:getChildByName("player"):getPosition()
        local children = self._TMXLayer:getChildren()
        for k,v in pairs(children) do
            if string.find(v:getName(),"monster") then
                local x , y = v:getPosition()
                v:setPosition(cc.pAdd(cc.p(x,y),cc.p(math.random(-moveDistance,moveDistance),math.random(-moveDistance,moveDistance))))
            end 
        end 
        --print(playerPositionX,playerPositionY)
    end
   schduler:scheduleScriptFunc(update,1/60,false)
end
function DirectionController:stopMapShaking()
	local tileTable = self._TMXLayer:getChildren()
	for k,v in pairs(tileTable) do
	   if v then
	       v:getTexture():setAntiAliasTexParameters()
	   end 
	end 
end

function DirectionController:BindOnTouchesEvents()
    
    local function onTouchesBegan(touches, event )
        local touchesPosition = touches[1]:getLocation()
        local mapCurrentPositionX, mapCurrentPositionY= self._TMXLayer:getPosition()
        local visibleSize = cc.Director:getInstance():getWinSize()
        local touchesRelativePosition = cc.pSub(touchesPosition,cc.p(mapCurrentPositionX,mapCurrentPositionY))
        local playerCurrentPositionX,playerCurrentPositionY = self._TMXLayer:getChildByName("player"):getPosition()
        local centerPosition = cc.p(visibleSize.width/2,visibleSize.height/2)
        local mapLastPosition = cc.pSub(cc.p(centerPosition),touchesRelativePosition)
        if mapLastPosition.x < 0-(self._TMXLayer:getContentSize().width-visibleSize.width) then
            mapLastPosition.x = 0-(self._TMXLayer:getContentSize().width-visibleSize.width)
        elseif mapLastPosition.x > 0 then
            mapLastPosition.x = 0
        end
        if mapLastPosition.y < 0-(self._TMXLayer:getContentSize().height-visibleSize.height) then
            mapLastPosition.y = 0-(self._TMXLayer:getContentSize().height-visibleSize.height)
        elseif mapLastPosition.y > 0 then
            mapLastPosition.y = 0
        end

        local playerMoveTime = math.sqrt(math.pow((touchesRelativePosition.x- playerCurrentPositionX),2)+math.pow(touchesRelativePosition.y- playerCurrentPositionY,2)) /self:getSpeed()
        local playerMove = cc.MoveTo:create(playerMoveTime,touchesRelativePosition)
        self._TMXLayer:getChildByName("player"):stopAllActions()
        self._TMXLayer:getChildByName("player"):runAction(playerMove)
        local mapMoveTime = math.sqrt(math.pow(mapLastPosition.x-mapCurrentPositionX,2)+math.pow(mapLastPosition.y-mapCurrentPositionY,2)) / self:getSpeed()
        local mapMove = cc.MoveTo:create(mapMoveTime,mapLastPosition)
        self._TMXLayer:stopAllActions()
        self._TMXLayer:runAction(mapMove)
        --TMXMove(self._TMXLayer,mapMoveTime,cc.p(mapCurrentPositionX,mapCurrentPositionY),mapLastPosition)
    
    end
    local listener = cc.EventListenerTouchAllAtOnce:create()
    listener:registerScriptHandler(onTouchesBegan,cc.Handler.EVENT_TOUCHES_BEGAN )--register TOUCHES_MOVED event
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)
end

function DirectionController:ctor()
    self._visibleSize = cc.Director:getInstance():getWinSize()
    self._scheduler = cc.Director:getInstance():getScheduler()
    self._speed = 200 -- per second
    self._player = nil
    --self._TMXLayer = nil
    self._statusBar = nil
    self:addTMXLayer()
    self:addStatusBar()
end 



function DirectionController:addStatusBar()
    self._statusBar = StatusBar:create()
    self._statusBar:setName("statusBar")
    self._statusBar:setPosition(cc.p(300,cc.Director:getInstance():getWinSize().height-40))
    self:addChild(self._statusBar)
end


function DirectionController:addTMXLayer()
   self._TMXLayer  = TMXLayer:create()
   self._TMXLayer:setPosition(cc.p(0,0))
   self:addChild(self._TMXLayer)
end

function DirectionController:setSpeed(speed)
    self._speed = speed
end 

function DirectionController:getSpeed()
    return self._speed 
end

return DirectionController;