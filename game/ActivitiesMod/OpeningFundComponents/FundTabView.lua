--[[
  File: FundTabView.lua
  Author: xingouy
  Date: 10/17/2016 13:55
]]--

local FundTabView = Lplus.Extend(require "game/JOWBaseComponent","FundTabView")
local def = FundTabView.define

def.field("number").fundSn = 0

def.field("userdata").lbPrice      = nil
def.field("userdata").lbTotal      = nil
def.field("userdata").lbAlreadyGet = nil
def.field("userdata").lbNotGet     = nil
def.field("userdata").imgVipIcon   = nil
def.field("userdata").lbLimitedVip = nil
def.field("userdata").btnBuy       = nil
def.field("userdata").tileReward   = nil

local is_fund_items_inited = false;

-- ui elemenents, not data.
local fundGoals = {}

local fundGoalHandler = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)

    self.lbPrice      = self:MakeGameLabel("Label-yiqianyuanbao")
    self.lbTotal      = self:MakeGameLabel("Label-huode")
    self.lbAlreadyGet = self:MakeGameLabel("Label-yilingqunum")
    self.lbNotGet     = self:MakeGameLabel("Label-hainenglingNum")
    self.imgVipIcon   = self:MakeGameImage("Label-wupinshuliang:Image1")
    self.lbLimitedVip = self:MakeGameLabel("Label-wupinshuliang:Label-san")
    self.btnBuy       = self:MakeGameButton("button-woyaogoumai")
    self.tileReward   = self:MakeGameTile("Scroll View:UIGridjiangli")

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

def.override("=>","string").GetName = function (self)
    return "FundTabView"
end

-- data includes: fundSn price, totalReceive, alreadyReceive, notReceive,
--                vipIcon, vipLimitedLevel, allfundGoals, rewards
def.method("table").SetProperties = function (self, fundData)

    print ("FundTabView SetProperties")
    self.fundSn = fundData.sn

    local mod          = require ("game/ActivitiesMod/ActivitiesMod")
    local confFund  = mod.conf_fund.get(self.fundSn)

    local total        = fundData.already_received + fundData.can_receive;
    local msg_pb       = require('protocol/activity_pb')

    self.lbPrice.Text      = string.format("[fdb212]%s元宝[-]购买开服基金", confFund.Cost)
    self.lbTotal.Text      = string.format("总计可获得[fdb212]%s元宝[-]", total)
    self.lbAlreadyGet.Text = fundData.already_received
    self.lbNotGet.Text     = fundData.can_receive
    self.imgVipIcon.Sprite = PlayerMgr:GetVipSprite(confFund.VipLimmit)
    self.lbLimitedVip.Text = PlayerMgr:GetVipNumStr(confFund.VipLimmit)

    local count = 0
    for k,v in pairs(confFund.LevelGoal) do
        if type(v) == "number" then count = count + 1 end
    end

    self.btnBuy:RemoveAllClickCallBack()
    self.btnBuy:AddClickCallBack(function(go)
        local msg = msg_pb.CSBuyFund()
        msg.sn = self.fundSn
        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end)

    -- Init items.
    -- if not is_fund_items_inited then
        self.tileReward:Clear()
        self.tileReward:LEnsureSize(count)
        self.tileReward:Reposition()

        local fundGoalItem = require ('game/ActivitiesMod/OpeningFundComponents/FundGoalView')

        for i = 1, count do
            local idx = i - 1
            local itemName = "Scroll View:UIGridjiangli:Template(Clone)_" .. idx

            print ("fund goal " .. itemName)

            local item = self:MakeLuaComponent(fundGoalItem, itemName)

            local fsn = self.fundSn
            local gsn = confFund.LevelGoal[i]
            local status = fundData.goals[gsn] or 3
            
            print ("fsn: " .. fsn .. " gsn: " .. gsn .. " status: " .. status)
            item:SetProperties(fsn, gsn, status)

            fundGoals[i] = item
        end

        is_fund_items_inited = true
    -- end

    -- -- update button status
    -- if is_fund_items_inited then
    --     for k,v in pairs(fundGoals) do
    --         local status = fundData.goals[v.goalSn] or 3
    --         v:UpdateBtnState(status)
    --     end
    -- end
end

-- dataRewards: the rewards
def.method("table").UpdateGoal = function (self, goal)

    for k,v in pairs(fundGoals) do
        if goal.fsn == self.fundSn and goal.gsn == v.goalSn then
            v:UpdateBtnState(goal.status)
        end
    end
end

FundTabView.Commit()
return FundTabView