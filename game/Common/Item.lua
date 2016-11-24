--[[
  File: Item.lua
  Author: xingouy
  Date: 9/26/2016 19:31
]]

local item_fact = {}

item_fact.create_item = function(
    icon_path, num_path
    )
    
    if type(icon_path) ~= "string" then
        print ("icon path is not string")
        return nil
    end

    if type(num_path) ~= "string" then
        print ("num path is not string")
        return nil
    end

    local item = {}

    return item
end

return item_fact