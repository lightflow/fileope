--[[
  File: WelfareTabView.lua
  Author: xingouy
  Date: 10/17/2016 13:55
]]--

local WelfareTabView = Lplus.Extend(require "game/JOWBaseComponent","WelfareTabView")
local def = WelfareTabView.define

def.field("number").fundSn = 0

def.field("userdata").lbTotalBuy  = nil
def.field("userdata").btnBuy      = nil
def.field("userdata").tileRewards = nil

local fundGoals = {}

local is_fund_items_inited = false
local fundGoalHandler = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)

    self.lbTotalBuy  = self:MakeGameLabel("Label-yilingqunum")
    self.btnBuy      = self:MakeGameButton("button-woyaogoumai")
    self.tileRewards = self:MakeGameTile("Scroll View:UIGridjiangli")

    fundGoalHandler   = handler(self, self.UpdateGoal)
    EventMgr.AddListener(ActivitiesEvents.UpdateFundGoal, fundGoalHandler)
end

def.override().OnHide = function(self)
end

def.override().OnUpdate = function(self)
end

def.override().OnDispose = function(self)
    EventMgr.RemoveListener(ActivitiesEvents.UpdateFundGoal, fundGoalHandler)
end

def.method("number").ShowView = function(self, n)
    print ("WelfareTabView" .. n)
end

-- data: total num, rewards
def.method("table", "function").SetProperties = function(self, welfareData, btnCallback)

    print ("WelfareTabView SetProperties")
    self.fundSn = welfareData.sn

    local mod         = require ("game/ActivitiesMod/ActivitiesMod")
    local confFund    = mod.conf_fund.get(self.fundSn)
    local msg_pb      = require('protocol/activity_pb')

    self.lbTotalBuy.Text = welfareData.num
    self.btnBuy:RemoveAllClickCallBack()
    self.btnBuy:AddClickCallBack(btnCallback)

    print ("welfare sn: " .. welfareData.sn .. " num: " .. welfareData.num)

    local count = 0
    for k,v in pairs(confFund.ServiceBuy) do
        if type(v) == "number" then count = count + 1 end
    end

    -- if not is_fund_items_inited then
        self.tileRewards:Clear()
        self.tileRewards:LEnsureSize(count)
        self.tileRewards:Reposition()

        local fundGoalItem = require ('game/ActivitiesMod/OpeningFundComponents/FundGoalView')

        for i = 1, count do
            local idx = i - 1
            local itemName = "Scroll View:UIGridjiangli:Template(Clone)_" .. idx
            local item = self:MakeLuaComponent(fundGoalItem, itemName)

            local fsn = self.fundSn
            local gsn = confFund.ServiceBuy[i]
            local status = 3
            if welfareData.goals[gsn] ~= nil then
                status = welfareData.goals[gsn]
            end

            print ("fsn: " .. fsn .. " gsn: " .. gsn .. " status: " .. status)
            item:SetProperties(fsn, gsn, status)

            fundGoals[i] = item
        end

        is_fund_items_inited = true
    -- end

        -- update button status
    -- if is_fund_items_inited then
    --     for k,v in pairs(fundGoals) do
    --         local status = fundData.goals[v.goalSn] or 3
    --         v:UpdateBtnState(status)
    --     end
    -- end
end

def.method("table").UpdateGoal = function (self, goal)

    for k,v in pairs(fundGoals) do
        if goal.fsn == self.fundSn and goal.gsn == v.goalSn then
            v:UpdateBtnState(goal.status)
        end
    end
end

def.override("=>","string").GetName = function (self)
    return "WelfareTabView"
end

WelfareTabView.Commit()
return WelfareTabView