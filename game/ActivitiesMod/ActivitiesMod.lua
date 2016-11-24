--[[
  File: ActivitiesMod.lua
  Author: xingouy
  Date: 9/21/2016 20:11
]]

local ActivitiesMod = Lplus.Extend(require "game/JOWModle","ActivitiesMod")
local def = ActivitiesMod.define

local view = require(UINames.UI_Activities._logic)
local msg_pb = require('protocol/activity_pb')
local activities_settings = require('game/ActivitiesMod/View/ActivitiesSettings')

-- datas

-- 通用创建初始化活动数据的函数, 活动数据不读表, 从服务器读取
ActivitiesMod.create_activity_datas = function()

    local activity = {}

    activity.values = {}
    
    activity.clear = function()
        for k, v in activity.values do activity.values[k] = nil end
    end

    activity.update = function(datas)
        if datas ~= nil then
            for k,v in pairs(datas) do
                -- print (v.sn)
                if v.sn ~= nil then
                    activity.values[v.sn] = v
                end
            end
        end
    end

    activity.get = function(sn)
        if activity.values[sn] ~= nil then
            return activity.values[sn]
        end
    end

    activity.count = function()
        local num = 0
        for k, v in pairs(activity.values) do
            num = num + 1
        end
        return num
    end

    return activity
end

-- 开服嘉年华配置
ActivitiesMod.carnival_datas           = ActivitiesMod.create_activity_datas()
ActivitiesMod.activities_general_datas = ActivitiesMod.create_activity_datas()

-- 开服嘉年华宝箱配置, 参考宝箱配置表(ActivityFinalReward)
ActivitiesMod.conf_boxes  = ActivitiesMod.create_activity_datas()
--

-- 开服基金配置
ActivitiesMod.conf_fund      = ActivitiesMod.create_activity_datas()
ActivitiesMod.conf_fund_goal = ActivitiesMod.create_activity_datas()
-- ActivitiesMod.opening_fund_data = activities_settings.create_opening_fund_data()
ActivitiesMod.opening_fund_data = {}
ActivitiesMod.callback_fund = {}
ActivitiesMod.callback_fund_goal = {}
--

-- signed up
local total_login_days   = 0
local total_signed_days  = 0

-- Signed up rewards
local is_signed_up_rewards_init = false
local signed_up_rewards = {
    values = {},
    init = function(self, rewards)
        for k, v in pairs(rewards) do
            if v ~= nil and v.day ~= nil then
                self.values[v.day] = v
            end
        end
    end,
    clear = function(self)
        for k, v in pairs(self.values) do self.values[k] = nil end
    end,
    get = function(self, key)
        if self.values[key] ~= nil then
            return self.values[key]
        end
        return nil
    end
}

def.override().Start = function(self)
    NetMgr:AddEvent(MsgID.SCLoginActivityInfo, "set_total_days")
    NetMgr:AddEvent(MsgID.SCActivityRelativeConf, "init_activities_datas")
    NetMgr:AddEvent(MsgID.SCReturnOpenActivities, "init_activities_general_datas")
    NetMgr:AddEvent(MsgID.SCReturnOpenActivityChange, "update_activities_general_datas")
end

def.override().Dispose = function(self)
    NetMgr:DeleteEvent(MsgID.SCLoginActivityInfo, "set_total_days")
    NetMgr:DeleteEvent(MsgID.SCActivityRelativeConf, "init_activities_datas")
    NetMgr:DeleteEvent(MsgID.SCReturnOpenActivities, "init_activities_general_datas")
    NetMgr:DeleteEvent(MsgID.SCReturnOpenActivityChange, "update_activities_general_datas")
end

def.method("=>", "number").get_total_days = function(self)

    return total_login_days
end

def.static("=>", "number").get_total_signed_days = function(self)

    return total_signed_days
end

def.static("number").set_total_signed_days = function(self, signed_day)

    total_signed_days = signed_day
end

def.static("=>", "boolean").get_current_day_signed = function(self)

    return current_day_signed
end

def.static("boolean").set_current_day_signed = function (self, is_signed)

    current_day_signed = is_signed
end

def.static("=>", "table").get_signed_up_rewards = function(self)

    return signed_up_rewards
end

def.static("=>", "table").get_activities_datas = function(self)

    return activities_datas 
end

function set_total_days(proto)

    local msg = msg_pb.SCLoginActivityInfo()
    msg:ParseFromString(proto)

    print( "---------- login day: " .. msg.loginPriceReceiveDay .. "----- today is signed: " .. string.format("%s", msg.isLoginPriceReceived) .. "----" )

    total_signed_days  = msg.loginPriceReceiveDay
    current_day_signed = msg.isLoginPriceReceived
    -- current day is signed

    -- clear rewards
    if not is_signed_up_rewards_init then
        signed_up_rewards:clear()
        signed_up_rewards:init(msg.prices)
        is_signed_up_rewards_init = true
    end
end

function init_activities_datas (proto)

    local msg = msg_pb.SCActivityRelativeConf()
    msg:ParseFromString(proto)

    ActivitiesMod.carnival_datas.update(msg.activityOpenServer)
    ActivitiesMod.conf_fund.update(msg.fund)
    ActivitiesMod.conf_fund_goal.update(msg.fundGoal)

    ActivitiesMod.conf_boxes.update(msg.activityFinalReward)
end

function init_activities_general_datas (proto)
    local msg = msg_pb.SCReturnOpenActivities()
    msg:ParseFromString(proto)

    ActivitiesMod.activities_general_datas.update(msg.activityGenerals)
    -- print ("activities general size: " .. #msg.activityGenerals)
end

function update_activities_general_datas (proto)

    local msg = msg_pb.SCReturnOpenActivityChange()
    msg:ParseFromString(proto)

    for k,v in pairs(msg.activityGenerals) do
        print(k,v)
    end
end

ActivitiesMod.Commit()
return ActivitiesMod

--endregion
