local DirectionController = class("DirectionController",function()
    return cc.Layer:create()
end)

local StatusBar = require("Entity.StatusBar")
local TMXLayer = require("Entity.TMXLayer")
local schduler = cc.Director:getInstance():getScheduler()

function DirectionController:create()
    local instance = self.new()
    return instance;
end 
function DirectionController:ctor()
    self._visibleSize = cc.Director:getInstance():getWinSize()
    self._scheduler = cc.Director:getInstance():getScheduler()
    self._player = nil
    self._statusBar = nil
    self._reliveCount = 0
end 
function DirectionController:init()
    self:addTMXLayer()
    self:addStatusBar()
    self:stopMapShaking()
    self:BindOnTouchesEvents()
    local function update()
        local moveDistance = 2
        local statusBar = self:getChildByName("statusBar")
        local player = self:getChildByName("map"):getChildByName("player")
        statusBar:setCurrentHPValue(player:getCurrentHPValue())
        statusBar:showUsedTime()
        if statusBar:getCurrentHPValue() <= 0 or statusBar:getUsedTime()>=statusBar:getTotolTime() then
            local LoseScene = require("Scene.LoseScene")
            local loseScene = LoseScene:create()
            loseScene:init()
            cc.Director:getInstance():pause()
            if cc.Director:getInstance():getRunningScene() then
                cc.Director:getInstance():replaceScene(loseScene)
            else
                cc.Director:getInstance():runWithScene(loseScene)
            end
        end
        print(statusBar:getDiedMonsterAmount(),statusBar:getTotolMosterAmount())
        if statusBar:getDiedMonsterAmount()>= statusBar:getTotolMosterAmount() then
            local WinScene = require("Scene.WinScene")
            local winScene = WinScene:create()
            winScene:init()
            cc.Director:getInstance():pause()
            if cc.Director:getInstance():getRunningScene() then
                cc.Director:getInstance():replaceScene(winScene)
            else
                cc.Director:getInstance():runWithScene(winScene)
            end
        end
        if statusBar:getDiedMonsterAmount() > 0  and statusBar:getDiedMonsterAmount()< statusBar:getTotolMosterAmount()and statusBar:getDiedMonsterAmount() % statusBar:getInitMonsterAmount()==0 then
            if self._reliveCount < statusBar:getDiedMonsterAmount() / statusBar:getInitMonsterAmount() then
                self._reliveCount = self._reliveCount + 1
                self._TMXLayer:reLiveALLMonster()
            end
        end
        
        
        math.randomseed(os.time())
        local playerPositionX,playerPositionY = self._TMXLayer:getChildByName("player"):getPosition()
        local children = self._TMXLayer:getChildren()
        for k,v in pairs(children) do
            if string.find(v:getName(),"monster") then
                local x , y = v:getPosition()
                local pos = cc.pAdd(cc.p(x,y),cc.p(math.random(-moveDistance,moveDistance),math.random(-moveDistance,moveDistance)))
                if pos.x < v:getContentSize().width then
                    pos.x = v:getContentSize().width
           
                end
                if pos.x > self:getChildByName("map"):getContentSize().width - v:getContentSize().width then
                    pos.x = self:getChildByName("map"):getContentSize().width - v:getContentSize().width
                end
                if pos.y < v:getContentSize().height then
                    pos.y = v:getContentSize().height
                   
                end
                if pos.y > self:getChildByName("map"):getContentSize().height - v:getContentSize().height then
                    pos.y = self:getChildByName("map"):getContentSize().height - v:getContentSize().height
                end
                v:setPosition(pos)
            end 
        end 
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

        local playerMoveTime = math.sqrt(math.pow((touchesRelativePosition.x- playerCurrentPositionX),2)+math.pow(touchesRelativePosition.y- playerCurrentPositionY,2)) /self:getChildByName("map"):getChildByName("player"):getMoveSpeed()
        local playerMove = cc.MoveTo:create(playerMoveTime,touchesRelativePosition)
        self._TMXLayer:getChildByName("player"):stopAllActions()
        self._TMXLayer:getChildByName("player"):runAction(playerMove)
        local mapMoveTime = math.sqrt(math.pow(mapLastPosition.x-mapCurrentPositionX,2)+math.pow(mapLastPosition.y-mapCurrentPositionY,2)) / self:getChildByName("map"):getChildByName("player"):getMoveSpeed()
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





function DirectionController:addStatusBar()
    self._statusBar = StatusBar:create()
    self._statusBar:setName("statusBar")
    self._statusBar:init()
    self._statusBar:setPosition(cc.p(300,cc.Director:getInstance():getWinSize().height-40))
    self:addChild(self._statusBar)
end


function DirectionController:addTMXLayer()
   self._TMXLayer  = TMXLayer:create()
   self._TMXLayer:init()
   self._TMXLayer:setName("map")
   self._TMXLayer:setPosition(cc.p(0,0))
   self:addChild(self._TMXLayer)
end

return DirectionController;