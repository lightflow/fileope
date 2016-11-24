--[[

--]]

RewardsView = Lplus.Extend(require "game/JOWBaseUI","RewardsView")
local def = RewardsView.define

local settings = require( 'game/ActivitiesMod/View/ActivitiesSettings' )

local tile = nil
local pnl_reward = nil
local logic = nil

local rewards = {}

local tile_path = "querenkuang:wupin:Scroll View:UIGridjiangli"

def.override("userdata").OnInit = function (self, LuaUILogic)

    logic = LuaUILogic
    tile  = LuaUILogic:LMakeGameUIContainer(tile_path)
    LuaUILogic:ResetCloseBtn("querenkuang:button-lingqu")
end


def.override("dynamic").OnShow = function (self)

    RewardsView.show_rewards(tile.LuaLogicHandler)
end

def.override().OnHide = function (self)

end

def.override().OnDispose = function (self)

end

def.override("=>","string").GetName = function (self)
  return "RewardsView"
end

RewardsView.set_rewards = function(new_rewards)
    -- clear old rewards
    for k, v in pairs(rewards) do rewards[k] = nil end

    for k, v in pairs(new_rewards) do
        rewards[k] = v
    end

end

RewardsView.show_rewards = function (ui_logic)

    local size = 0

    if rewards ~= nil then
        for k in pairs( rewards ) do
            size = size + 1
        end
    end

    tile:LEnsureSize(size)

    local grid_item_start = settings.grid_item_start

    local idx = 0
    for k, v in pairs( rewards ) do
        local item = ui_logic:LMakeGameUIComponent(tile_path .. ":" .. grid_item_start .. idx)
        local icon = item:LMakeGameImage("itemtubiao")
        local num  = item:LMakeGameLabel("num")

        -- print( k, v )

        if icon ~= nil then icon.Sprite = k else print( "icon is nil" ) end
        if num ~= nil then num.Text = v else print( "num is nil" ) end

        idx = idx + 1
    end
end

RewardsView.Commit()
return RewardsView