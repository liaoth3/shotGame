
local Player = class("Player",function()
    return cc.Sprite:create("../res/shizi.jpg")
end)
function Player:create()
    local sprite = self.new()
    sprite:setName("player")
    sprite:setScale(0.15)
    return sprite
end

return Player
