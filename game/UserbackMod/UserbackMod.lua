--[[
  File: UserBackMod.lua
  Author: xingouy
  Date: 9/27/2016 16:42
]]

local UserBackMod = Lplus.Extend(require "game/JOWModle","UserBackMod")
local def = UserBackMod.define
local msg_pb = require('protocol/activity_pb')

local ActivitiesMod = require("game/ActivitiesMod/ActivitiesMod")

-- 已经开服的活动
UserBackMod.open_sn = {}
UserBackMod.achieved_goals = {}
UserBackMod.update = {}
UserBackMod.datas = {
    current_target = 1, -- 当前任务进度
}

UserBackMod.boxes = {}
-- empty params
UserBackMod.callback_boxes_update = {}
-- param: box sn
UserBackMod.show_box_reward_callback = {}

UserBackModEvent = {
    ShowBoxReward = "show_box_reward_callback",
}

-- 左侧tab红点提示
local left_tab_states = {}
-- 右上tab红点提示
local right_tab_states = {}
-- 红点提示回调
-- local red_tips_callback = {}

def.override().Start = function (self)

    NetMgr:AddEvent(MsgID.SCOpenServerActivity, "set_UserBack_data")
    NetMgr:AddEvent(MsgID.SCOpenServerFinalReward, "UserBack_boxes_callback")
    NetMgr:AddEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Dispose = function (self)

    NetMgr:DeleteEvent(MsgID.SCOpenServerActivity, "set_UserBack_data")
    NetMgr:DeleteEvent(MsgID.SCOpenServerFinalReward, "UserBack_boxes_callback")
    NetMgr:DeleteEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Update = function (self)

end

def.override("=>","string").GetName = function (self)
    return "UserBackMod"
end

UserBackMod.update_red_tips_base = function (left_datas, right_datas)

    if left_datas ~= nil then
        for k,v in pairs(left_datas) do
            if type(v) == "number" then
                left_tab_states[v] = true
            end
        end
    else
        print ("redActivity is nil")
    end

    if right_datas ~= nil then
        for k,v in pairs(right_datas) do
            if v.sn ~= nil and type(v.sn) == "number" then
                right_tab_states[v.sn] = true
                -- 更新ActiveGoal.
                if v.canCollectedGoalSns ~= nil then
                    for k,v in pairs(v.canCollectedGoalSns) do
                        UserBackMod.achieved_goals[v] = true
                    end
                end

                if v.finishGoalSns ~= nil then
                    for k,v in pairs(v.finishGoalSns) do
                        UserBackMod.achieved_goals[v] = false
                    end
                end
            end
        end
    else
        print ("redSubActivity is nil")
    end
end

UserBackMod.update_callback = function()
    for k, v in pairs(UserBackMod.update) do
        if type(v) == "function" then
            UserBackMod.update[k]()
        end
    end
end

-- tbl is repeated DOpenServerBox
UserBackMod.update_boxes = function(tbl)
    for k,v in pairs(tbl) do
        if v.sn ~= nil and type(v.sn) == "number" then
            -- print ("box " .. v.sn .. " receive state: " .. tostring(v.state))
            if UserBackMod.boxes[v.sn] == nil then
                UserBackMod.boxes[v.sn] = {}
            end

            UserBackMod.boxes[v.sn].target = v.target
            UserBackMod.boxes[v.sn].state = v.state
            UserBackMod.boxes[v.sn].rewards = v.reward
        end
    end
end

function set_UserBack_data(proto)

    local msg = msg_pb.SCOpenServerActivity()
    msg:ParseFromString(proto)

    print ( "endTime: " .. msg.endTime)
    print ( "current Value: " .. msg.currentValue .. " type: " .. type(msg.currentValue) )

    UserBackMod.datas.current_target = msg.currentValue

    UserBackMod.update_red_tips_base(msg.redActivity, msg.redSubActivity)

    UserBackMod.update_boxes(msg.boxs)

    for k, v in pairs(msg.openSn) do
        -- print ("open left sn: ", v)
        UserBackMod.open_sn[k] = v
    end

    -- callback after UserBack data update.
    for k, v in pairs(UserBackMod.update) do
        if type(v) == "function" then
            UserBackMod.update[k]()
        end
    end
end

-- 点击开箱之后返回消息
function UserBack_boxes_callback(proto)

    local msg = msg_pb.SCOpenServerFinalReward()
    msg:ParseFromString(proto)

    -- 更新宝箱数据之前比较哪个箱子发生了变化(被打开了), 这里给一个回调用于显示宝箱奖励
    for k,v in pairs(msg.boxs) do
        if v.sn ~= nil and type(v.sn) == "number" then
            if UserBackMod.boxes[v.sn].state ~= v.state and v.state == 4 then
                EventMgr.Brocast(UserBackModEvent.ShowBoxReward, v.reward)
            end
        end
    end

    UserBackMod.datas.current_target = msg.currentValue
    UserBackMod.update_boxes(msg.boxs)

    for k,v in pairs(UserBackMod.callback_boxes_update) do
        if type(v) == "function" then
            UserBackMod.callback_boxes_update[k]()
        end
    end
end

function update_red_tips(proto)

    print ("--- UserBackMod update red tips ---")


    local msg = msg_pb.SCOpenServerRredActivity()
    msg:ParseFromString(proto)
    UserBackMod.update_red_tips_base( msg.redActivity, msg.redSubActivity )

    if red_tips_callback ~= nil then
        for k,v in pairs(red_tips_callback) do
            if type(v) == "function" then
                red_tips_callback[k](msg.redActivity, msg.redSubActivity)
            end
        end
    end

    if UserBackMod.update ~= nil then
        for k, v in pairs(UserBackMod.update) do
            if type(v) == "function" then
                UserBackMod.update[k]()
            end
        end
    end
end

UserBackMod.Commit()
return UserBackMod
