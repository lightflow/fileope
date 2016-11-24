--[[
  File: ActivityCarnivalView.lua
  Author: xingouy
  Date: 9/21/2016 20:11
]]

CarnivalView = Lplus.Extend(require "game/JOWBaseUI","CarnivalView")
local def = CarnivalView.define

local msg_pb = load_pack('protocol/activity_pb')

-- openbox
local progress_value  = {0, 0.07, 0.16, 0.37, 0.60, 1.0 }

local carnivalTabCreator   = load_pack ("game/CarnivalMod/view/CarnivalTab")
local carnivalRightCreator = load_pack ("game/CarnivalMod/view/CarnivalRight")
local carnivalBoxCreator   = load_pack ("game/CarnivalMod/view/CarnivalOpenbox")

local tabMgr   = nil
local rightMgr = nil
local boxMgr   = nil

-- event handler
local onCarnivalDataHandler = nil
local onRightDataHandler    = nil
local onBoxesDataHandler    = nil
-- end event handler

def.override().OnInit = function (self)

    tabMgr   = self:MakeLuaComponent(carnivalTabCreator, "bottom:huodonglist")
    rightMgr = self:MakeLuaComponent(carnivalRightCreator, "bottom:huodonginfo")
    boxMgr   = self:MakeLuaComponent(carnivalBoxCreator, "bottom:Jiangli")
    self:ResetCloseBtn("bottom:guanbi")

    onCarnivalDataHandler = handler(self, self.OnCarnivalDataChanged)
    onRightDataHandler    = handler(self, self.OnRightDataChanged)
    onBoxesDataHandler    = handler(self, self.OnBoxesDataHandler)

    EventMgr.AddListener(CarnivalEvents.UpdateCarnivalDatas, onCarnivalDataHandler)
    EventMgr.AddListener(CarnivalEvents.UpdateRightDatas, onRightDataHandler)
    EventMgr.AddListener(CarnivalEvents.UpdateOpenBoxes, onBoxesDataHandler)

    NetMgr:AddEvent(MsgID.SCActivityReward, "show_rewards")
end

def.override("dynamic").OnShow = function (self,obj)

    send_CSOpenServerActivity()
end

def.override().OnHide = function(self)
end

def.override().OnDispose = function(self)

    EventMgr.RemoveListener(CarnivalEvents.UpdateCarnivalDatas, onCarnivalDataHandler)
    EventMgr.RemoveListener(CarnivalEvents.UpdateRightDatas, onRightDataHandler)
    EventMgr.RemoveListener(CarnivalEvents.UpdateOpenBoxes, onBoxesDataHandler)

    NetMgr:DeleteEvent(MsgID.SCActivityReward, "show_rewards")
end

def.override("=>","string").GetName = function (self)
  return "CarnivalView"
end

def.method("table").OnCarnivalDataChanged = function (self, carnivalData)
    tabMgr:SetProperties(carnivalData)
end

def.method("number", "table", "table").OnRightDataChanged = function (self, psn, subSns, goalsStatus)
    rightMgr:SetProperties(psn, subSns, goalsStatus)
end

def.method("table").OnBoxesDataHandler = function (self, carnivalData)
    boxMgr:SetProperties(carnivalData)
end


function send_CSOpenServerActivity()
    local msg = msg_pb.CSOpenServerActivity()
    local data = msg:SerializeToString()
    NetMgr:SendMessage(msg.protocid, data)

    print("Send CSOpenServerActivity")
end

function show_rewards(proto)

    local msg = msg_pb.SCActivityReward()
    msg:ParseFromString(proto)

    local sns = {}
    local nums = {}
    for k,v in pairs(msg.produce) do
        if v.sn and type(v.sn) == "number" then
            -- print (v.sn .. " -- " .. v.num)
            table.insert(sns, v.sn)
            table.insert(nums, v.num)
        end
    end
    -- print ("sns: " .. #sns .. " nums: " .. #nums)
    CommonRewardUILogic.LShowRewardUI(sns, nums)
end

CarnivalView.Commit()
return CarnivalView
