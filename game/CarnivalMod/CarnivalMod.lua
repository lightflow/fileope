--[[
  File: CarnivalMod.lua
  Author: xingouy
  Date: 9/27/2016 16:42
]]

local CarnivalMod = Lplus.Extend(require "game/JOWModle","CarnivalMod")
local def = CarnivalMod.define
local msg_pb = require('protocol/activity_pb')

local ActivitiesMod = require("game/ActivitiesMod/ActivitiesMod")


local currentCarnivalData = {}
local currentRedTipsData  = {}

local currentTasksNum = 0

def.override().Start = function (self)

    NetMgr:AddEvent(MsgID.SCOpenServerActivity, "set_carnival_data")
    NetMgr:AddEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Dispose = function (self)

    NetMgr:DeleteEvent(MsgID.SCOpenServerActivity, "set_carnival_data")
    NetMgr:DeleteEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Update = function (self)

end

def.override("=>","string").GetName = function (self)
    return "CarnivalMod"
end

function set_carnival_data(proto)
    local msg = msg_pb.SCOpenServerActivity()
    msg:ParseFromString(proto)

    print ( "endTime: " .. msg.endTime)
    print ( "current Value: " .. msg.currentValue .. " type: " .. type(msg.currentValue) )

    currentCarnivalData["endTime"] = msg.endTime
    currentCarnivalData["redActivity"] = msg.redActivity
    currentCarnivalData["redSubActivity"] = msg.redSubActivity
    currentCarnivalData["openSn"] = msg.openSn
    currentCarnivalData["currentValue"] = msg.currentValue
    currentCarnivalData["boxs"] = msg.boxs

    for k,v in pairs(msg.redActivity) do
        if type(v) == "number" then print(k,v) end
    end

    for k,v in pairs(msg.redSubActivity) do
        if type(v.sn) == "number" then print(k,v.sn) end
    end

    EventMgr.Brocast(CarnivalEvents.UpdateCarnivalDatas, currentCarnivalData)
    EventMgr.Brocast(CarnivalEvents.UpdateOpenBoxes, currentCarnivalData)
end

function update_red_tips(proto)

    local msg = msg_pb.SCOpenServerRredActivity()
    msg:ParseFromString(proto)

    currentCarnivalData["redActivity"] = msg.redActivity
    currentCarnivalData["redSubActivity"] = msg.redSubActivity
    currentCarnivalData["currentValue"] = msg.currentValue

    EventMgr.Brocast(CarnivalEvents.UpdateOpenBoxes, currentCarnivalData)
    EventMgr.Brocast(CarnivalEvents.UpdateRedTips, currentCarnivalData)
end

CarnivalMod.Commit()
return CarnivalMod
