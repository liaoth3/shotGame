
local TMXLayer = class("TMXLayer",function()
    return cc.TMXTiledMap:create("../res/map/TileMap.tmx")
end)
local Monster = require("Entity.Monster")
local Player = require("Entity.Player")
function TMXLayer:create()
    local instance = self.new();
    return instance
end
function TMXLayer:ctor()
    self._visibleSize = cc.Director:getInstance():getWinSize()
    self._player = nil
    self._monsterAmount = 20
end

function TMXLayer:init()
    self:addPlayer()
    self:generatorMonster()
end

function TMXLayer:generatorMonster()
    math.randomseed( os.time() )
    for i = 1, self._monsterAmount do
        local monster = Monster:create("monster" .. i,math.random(self._visibleSize.width),math.random(self._visibleSize.height))
        self:addChild(monster)
        monster:init()
        
    end 
    
end
function TMXLayer:addPlayer()
    self._player = Player:create()
    self._player:setPosition(cc.p(self._visibleSize.width/2,self._visibleSize.height/2))
    self._player:setName("player")
    self:addChild(self._player)
    self._player:init()
end
return TMXLayer
