
local Player = class("Player",function()
    return cc.Sprite:create("../res/shizi.jpg")
end)
function Player:create()
    local instance = self.new()
    instance:setName("player")
    instance:setScale(0.15)
    return instance
end

return Player
