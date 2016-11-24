--[[
  File: ActivitiesOpeningFundView.lua
  Author: xingouy
  Date: 9/19/2016 13:55
  Desc: 开服基金
]]--

local ActivitiesOpeningFundView = Lplus.Extend(require "game/JOWBaseComponent","ActivitiesOpeningFundView")
local def = ActivitiesOpeningFundView.define

local FundTabView    = load_pack ("game/ActivitiesMod/OpeningFundComponents/FundTabView")
local WelfareTabView = load_pack ("game/ActivitiesMod/OpeningFundComponents/WelfareTabView")
local msg_pb         = load_pack ('protocol/activity_pb')

local pnlFund    = nil
local pnlWelfare = nil

local btnFund    = nil
local tabFund    = nil
local btnWelfare = nil
local tabWelfare = nil


-- fund data
-- 每次进入开服基金界面, 通过发送 CSFundInfo 刷新该次基金的最新内容
local currentFundData = nil
---

-- event handler

local fundDataHandler    = nil
local welfareDataHandler = nil
local fundGoalHandler    = nil

-- end event handler

ActivitiesOpeningFundView.CurrentFundSn = 1

def.override().OnInit = function (self)

    pnlFund    = self:MakeGameUIComponent("kaifujijin")
    pnlWelfare = self:MakeGameUIComponent("quanminfuli")

    btnFund    = self:MakeGameIndicateCheckBox("tabsobject:Grid:tab1")
    tabFund    = self:MakeLuaComponent(FundTabView, "kaifujijin:quanminfuli")
    btnWelfare = self:MakeGameIndicateCheckBox("tabsobject:Grid:tab2")
    tabWelfare = self:MakeLuaComponent(WelfareTabView, "quanminfuli:quanminfuli")

    tabFund:SetVisible(true)
    tabWelfare:SetVisible(true)

    btnFund:AddClickCallBack(switchToPnlFund)
    btnWelfare:AddClickCallBack(switchToPnlWelfare)

    fundDataHandler    = handler(self, self.OnFundDataChanged)
    welfareDataHandler = handler(self, self.OnWelfareDataChanged)
    -- fundGoalHandler    = handler(self, self.OnFundGoalChanged)

    EventMgr.AddListener(ActivitiesEvents.UpdateFund, fundDataHandler)
    EventMgr.AddListener(ActivitiesEvents.UpdateWelfare, welfareDataHandler)
    -- EventMgr.AddListener(ActivitiesEvents.UpdateFundGoal, fundGoalHandler)

    NetMgr:AddEvent(MsgID.SCFundInfo, "getFundData")
    NetMgr:AddEvent(MsgID.SCGetFund, "updateFundGoalData")
end

def.override("dynamic").OnShow = function (self,obj)
    print ("---- onshow ----")
end

def.override().OnHide = function(self)
end

def.override().OnUpdate = function(self)
end

def.override().OnDispose = function(self)

    NetMgr:DeleteEvent(MsgID.SCFundInfo, "getFundData")
    NetMgr:DeleteEvent(MsgID.SCGetFund, "updateFundGoalData")
    
    EventMgr.RemoveListener(ActivitiesEvents.UpdateFund, fundDataHandler)
    EventMgr.RemoveListener(ActivitiesEvents.UpdateWelfare, welfareDataHandler)
    -- EventMgr.RemoveListener(ActivitiesEvents.UpdateFundGoal, fundGoalHandler)
end

def.method("number").ShowView = function (self, fundSn)
    self:SendCSFundInfo(fundSn)
    self:SetVisible(true)
end

def.override("=>","string").GetName = function (self)
    return "ActivitiesOpeningFundView"
end

def.method("table").OnFundDataChanged = function (self, data)
    if pnlFund:GetVisible() then
        -- print ("OnFundDataChanged")
        tabFund:SetProperties(data)
    end
end

def.method("table").OnWelfareDataChanged = function (self, data)
    if pnlWelfare:GetVisible() then
        -- print ("OnWelfareDataChanged")
        tabWelfare:SetProperties(data, switchToPnlFund)
    end
end

def.method("table").OnFundGoalChanged = function (self, goal)

end

def.method("number").SendCSFundInfo = function (self, fundSn)
    local msg = msg_pb.CSFundInfo()
    msg.sn = fundSn
    local data = msg:SerializeToString()
    NetMgr:SendMessage(msg.protocid, data)
end

function switchToPnlFund(go) 
    btnFund.Checked = true
    btnWelfare.Checked = false
    pnlFund:SetVisible(true)
    pnlWelfare:SetVisible(false)

    EventMgr.Brocast(ActivitiesEvents.UpdateFund, currentFundData)
end

function switchToPnlWelfare(go) 
    btnFund.Checked = false
    btnWelfare.Checked = true
    pnlFund:SetVisible(false)
    pnlWelfare:SetVisible(true)

    EventMgr.Brocast(ActivitiesEvents.UpdateWelfare, currentFundData)
end

-- SCFundInfo
function getFundData(proto)

    print ("-- getFundData --")
    
    local msg = msg_pb.SCFundInfo()
    msg:ParseFromString(proto)

    local mod = require ("game/ActivitiesMod/ActivitiesMod")
    local settings = require("game/ActivitiesMod/View/ActivitiesSettings")

    if currentFundData == nil then
        currentFundData = settings.create_opening_fund_data()
    end

    -- 具体含义参考协议 SCFuncInfo
    currentFundData.sn               = msg.sn
    currentFundData.is_buy           = msg.isBuy
    currentFundData.num              = msg.num

    currentFundData.already_received = 0 and msg.receive or 0
    currentFundData.can_receive      = 0 and msg.canReceive or 0

    if not currentFundData.goals then
        currentFundData.goals = {}
    end

    local confFund = mod.conf_fund.get(msg.sn)

    if confFund then
        for k,v in pairs(confFund.LevelGoal) do
            if type(v) == "number" then currentFundData.goals[v] = 3 end
        end

        for k,v in pairs(confFund.ServiceBuy) do
            if type(v) == "number" then currentFundData.goals[v] = 3 end
        end
    end

    for k,v in pairs(msg.goals) do
        if v.fundGoalSN ~= nil then
            currentFundData.goals[v.fundGoalSN] = v.status
        end
    end

    EventMgr.Brocast(ActivitiesEvents.UpdateFund, currentFundData)
    EventMgr.Brocast(ActivitiesEvents.UpdateWelfare, currentFundData)
    -- EventMgr.Brocast(ActivitiesEvents.UpdateFundGoal, currentFundData.goals)
end

-- SCGetFund
function updateFundGoalData(proto)

    local msg = msg_pb.SCGetFund()
    msg:ParseFromString(proto)

    local gsn = msg.goal.fundGoalSN

    if currentFundData[gsn] then
        currentFundData[gsn] = msg.goal.status
    end

    local goal = { fsn = msg.fundSn, gsn = msg.goal.fundGoalSN, status = msg.goal.status }
    print ("fsn: " .. goal.fsn .. " gsn: " .. goal.gsn .. " status: " .. goal.status)

    EventMgr.Brocast(ActivitiesEvents.UpdateFundGoal, goal)
end

ActivitiesOpeningFundView.Commit()
return ActivitiesOpeningFundView