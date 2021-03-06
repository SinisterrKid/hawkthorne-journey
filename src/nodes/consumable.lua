-----------------------------------------------
-- consumable.lua
-- Represents a consumable when it is in the world
-- Created by Nicko21
-----------------------------------------------

local controls = require 'controls'
local Item = require 'items/item'

local Consumable = {}
Consumable.__index = Consumable
Consumable.isConsumable = true

---
-- Creates a new consumable object
-- @return the consumable object created
function Consumable.new(node, collider)
    local consumable = {}
    setmetatable(consumable, Consumable)
    consumable.name = node.name
    consumable.type = 'consumable'
    consumable.image = love.graphics.newImage('images/consumables/'..node.name..'.png')
    consumable.image_q = love.graphics.newQuad( 0, 0, 24, 24, consumable.image:getWidth(),consumable.image:getHeight() )
    consumable.foreground = node.properties.foreground
    consumable.collider = collider
    consumable.bb = collider:addRectangle(node.x, node.y, node.width, node.height)
    consumable.bb.node = consumable
    collider:setPassive(consumable.bb)

    consumable.position = {x = node.x, y = node.y}
    consumable.width = node.width
    consumable.height = node.height

    consumable.touchedPlayer = nil
    consumable.exists = true

    return consumable
end

---
-- Draws the consumable to the screen
-- @return nil
function Consumable:draw()
    if not self.exists then
        return
    end
    love.graphics.drawq(self.image, self.image_q, self.position.x, self.position.y)
end


function Consumable:keypressed( button, player )
    if button ~= 'INTERACT' then return end

    local itemNode = require( 'items/consumables/' .. self.name )
    itemNode.type = 'consumable'
    local item = Item.new(itemNode)
    if player.inventory:addItem(item) then
        self.exists = false
        self.containerLevel:removeNode(self)
        self.collider:remove(self.bb)
    end
end

---
-- Called when the consumable begins colliding with another node
-- @return nil
function Consumable:collide(node, dt, mtv_x, mtv_y)
    if node and node.character then
        self.touchedPlayer = node
    end
end

---
-- Called when the consumable finishes colliding with another node
-- @return nil
function Consumable:collide_end(node, dt)
    if node and node.character then
        self.touchedPlayer = nil
    end
end

---
-- Updates the consumable and allows the player to pick it up.
function Consumable:update()
    if not self.exists then
        return
    end
end

return Consumable
