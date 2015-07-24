
local TMXLayer = class("TMXLayer",function()
    return cc.TMXTiledMap:create("../res/map/TileMap.tmx")
end)
local Monster = require("Entity.Monster")
local Player = require("Entity.Player")
function TMXLayer:create()
    local instance = self.new();
    instance:setName("map")
    return instance
end
function TMXLayer:ctor()
    self._visibleSize = cc.Director:getInstance():getWinSize()
    self._player = nil
    self._monsters = {}
    self._player = nil
    self:addPlayer()
    self:generatorMonster()
end
function TMXLayer:generatorMonster()
    local monsterCount = 20
    math.randomseed( os.time() )
    for i = 1, monsterCount do
        self._monsters[i] = Monster:create("monster" .. i,math.random(self._visibleSize.width),math.random(self._visibleSize.height))
        self:addChild(self._monsters[i])
    end 
    
end
function TMXLayer:addPlayer()
    self._player = Player:create()
    self._player:setPosition(cc.p(self._visibleSize.width/2,self._visibleSize.height/2))
    self:addChild(self._player)
end
return TMXLayer
