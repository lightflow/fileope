--[[
  File: FundGoalView.lua
  Author: xingouy
  Date: 10/17/2016 11:55
]]--

local FundGoalView = Lplus.Extend(require "game/JOWBaseComponent","FundGoalView")
local def = FundGoalView.define


def.field("number").fundSn    = 0
def.field("number").goalSn    = 0

def.field("userdata").imgIcon = nil
def.field("userdata").lbTitle = nil
def.field("userdata").lbCond  = nil
def.field("userdata").btnGet  = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)
    self.imgIcon = self:MakeGameImage("jiangli:tItem:Template:itemtubiao")
    self.lbTitle = self:MakeGameLabel("jiangli:tItem:Template:Label-wupinshuliang")
    self.lbCond  = self:MakeGameLabel("jiangli:tItem:Template:Label-tiaojian")
    self.btnGet  = self:MakeGameButton("jiangli:button-lingqu")
end

def.override().OnHide = function(self)

end

def.override().OnUpdate = function(self)

end

def.override().OnDispose = function(self)

end

-- table data must include: fund_sn, item_sn, icon, title( name * num ), cond
def.method("number", "number", "number").SetProperties = function (self, fsn, gsn, status)

    print (fsn .. " ==== " .. gsn)

    local mod = require ("game/ActivitiesMod/ActivitiesMod")
    local confFundGoal = mod.conf_fund_goal.get(gsn)
    local firstReward = ConfItem.Get(confFundGoal.item[1].sn)

    self.fundSn  = fsn
    self.goalSn  = gsn

    local title = firstReward.name .. " x " .. confFundGoal.item[1].num

    self.imgIcon.Sprite = firstReward.iconId
    self.lbTitle.Text   = title
    self.lbCond.Text    = confFundGoal.Content

    self:UpdateBtnState(status)

    local msg_pb = require('protocol/activity_pb')
    self.btnGet:RemoveAllClickCallBack()
    self.btnGet:AddClickCallBack(function(go)
        local msg  = msg_pb.CSGetFund()
        msg.fundSn = self.fundSn
        msg.sn     = self.goalSn

        print ("fsn: " .. self.fundSn .. " gsn: " .. self.goalSn)

        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end)
end

-- 1:已领取 2 ：可领取 3 ：不可领取
def.method("number").UpdateBtnState = function(self, status)

    if status == 1 then
        self.btnGet:SetVisible(false)
    elseif status == 2 then
        self.btnGet:SetVisible(true)
        self.btnGet.Enable = true
        self.btnGet.ShowEnable = true
    else
        self.btnGet:SetVisible(true)
        self.btnGet.Enable = false
        self.btnGet.ShowEnable = false
    end
end

def.override("=>","string").GetName = function (self)
  return "FundGoalView"
end

FundGoalView.Commit()
return FundGoalView