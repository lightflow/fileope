--[[
  File: CarnivalItem.lua
  Author: xingouy
  Date: 10/25/2016 8:56
]]

local CarnivalItem = Lplus.Extend(require "game/JOWBaseComponent","CarnivalItem")
local def = CarnivalItem.define

def.field("userdata").title = nil
def.field("userdata").tile  = nil
def.field("userdata").btn   = nil

local bInited = false

def.override().OnInit = function (self)
    self.title = self:MakeGameLabel("jiangli:biaoti")
    self.btn   = self:MakeGameButton("jiangli:button-lingqu")
    self.tile  = self:MakeGameTile("jiangli:tItem")
end

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnHide = function (self)

end

def.override().OnUpdate = function (self)

end

def.override().OnDispose = function (self)

end

-- goal: 00000_00000_def.proto - DActiveGoalForConf
-- status: -- 1:已领取 2 ：可领取 3 ：不可领取
def.method("table", "number").SetProperties = function (self, goal, status)
    local msg_pb = require('protocol/activity_pb')

    self:FormatTitle(goal)
    self:UpdateButtonStatus(status)

    self.btn:RemoveAllClickCallBack()
    self.btn:AddClickCallBack(function(go)
        local msg = msg_pb.CSActivityReward()
        msg.activityGoalSN = goal.sn
        msg.activitySN = goal.activeSN

        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end)

    local count = 0
    for k,v in pairs(goal.items) do
        if v.sn and type(v.sn) == "number" then
            count = count + 1
        end
    end

    self.tile:Clear()
    self.tile:LEnsureSize(count)
    self.tile:Reposition()

    local rewardPrefix = "jiangli:tItem" .. ":Template(Clone)_"

    local rewardIdx = 0
    for k,v in pairs(goal.items) do
        if v.sn and type(v.sn) == "number" then
            local icon = self:MakeGameImage(rewardPrefix .. rewardIdx .. ":itemtubiao")
            local num  = self:MakeGameLabel(rewardPrefix .. rewardIdx .. ":num")

            local item = ConfItem.Get(v.sn)

            icon.Sprite = item.iconId
            num.Text    = v.num

            rewardIdx = rewardIdx + 1
        end
    end
end

def.method("table").FormatTitle = function (self, goal)
    local t1 = tonumber(goal.target1)
    local t2 = tonumber(goal.target2)

    if goal.activeSN == 1000 then
        local title = System.String.Format(" ({0}/{1})", PlayerMgr.HeroInfo.level, t1)
        self.title.Text = System.String.Format(goal.activeGoalContent, "", title)
    else
        self.title.Text = System.String.Format(goal.activeGoalContent, "", "", "")
    end
end

-- 1:已领取 2 ：可领取 3 ：不可领取
def.method("number").UpdateButtonStatus = function (self, status)
    if status == 2 or status == 3 then
        self.btn.Visible    = true
        self.btn.Enable     = true
        self.btn.ShowEnable = true
    else
        self.btn.Visible    = false
    end
end

CarnivalItem.Commit()
return CarnivalItem