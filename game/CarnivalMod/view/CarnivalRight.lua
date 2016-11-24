--[[
  File: CarnivalTab.lua
  Author: xingouy
  Date: 10/25/2016 8:56
]]

local CarnivalRight = Lplus.Extend(require "game/JOWBaseComponent","CarnivalRight")
local def = CarnivalRight.define

local topTilePath    = "biaoqianye:UIGrid"
local goalScrollPath = "huodejiangli"
local goalTilePath   = "huodejiangli:Scroll View:UIGridjiangli"

-- Left menu tile
def.field("userdata").topTile    = nil
def.field("userdata").goalScroll = nil
def.field("userdata").goalTile   = nil

local tabBtns = {}
local goalItems = {}

local currSubTabSn = nil
local currDefaultTab = {}

local onTabRedTipHandler = nil

def.override().OnInit = function (self)
    self.topTile    = self:MakeGameTile(topTilePath)
    self.goalScroll = self:MakeGameScrollView(goalScrollPath)
    self.goalTile   = self:MakeGameTile(goalTilePath)

    onTabRedTipHandler = handler(self, self.OnTabRedTipChanged)
    EventMgr.AddListener(CarnivalEvents.UpdateRedTips, onTabRedTipHandler)

    NetMgr:AddEvent(MsgID.SCActivityReward, "update_goals_status")

end

def.override("dynamic").OnShow = function (self,obj)

end

def.override().OnHide = function (self)

end

def.override().OnUpdate = function (self)

end

def.override().OnDispose = function (self)
    EventMgr.RemoveListener(CarnivalEvents.UpdateRedTips, onTabRedTipHandler)
    NetMgr:DeleteEvent(MsgID.SCActivityReward, "update_goals_status")
end

def.method("table").OnTabRedTipChanged = function (self, data)
    -- print (#data["redSubActivity"])
    for k,v in pairs(tabBtns) do
        -- print (k,v)
        if v then v:ShowSign(false, 0) end
    end

    for k,v in pairs(data["redSubActivity"]) do
        if v.sn and type(v.sn) == "number" and tabBtns[v.sn] then
            -- print ("v.sn: --- " .. v.sn)
            -- print (#v.canCollectedGoalSns)
            if #v.canCollectedGoalSns ~= 0 then tabBtns[v.sn]:ShowSign(true, 0) end
        end
    end
end

-- tabData:
--  sn, name
def.method("number", "table", "table").SetProperties = function (self, psn, subSns, goalStates)

    -- for k,v in pairs(goalStates) do
    --     print (v.sn)
    -- end

    local mod = require ("game/ActivitiesMod/ActivitiesMod")

    local count = 0
    for k,v in pairs(subSns) do
        if type(v) == "number" then
            count = count + 1
            -- print(" --- key: " .. k .. " sub sn: " .. v)
        end
    end

    self.topTile:Clear()
    self.topTile:LEnsureSize(count)
    self.topTile:Reposition()

    local tmplPrefix = topTilePath .. ":Template(Clone)_"

    -- Clear tabBtns
    for k,v in pairs(tabBtns) do tabBtns[k] = nil end

    local tmplIdx = 0
    for k,v in pairs(subSns) do
        if type(v) == "number" then
            local tabPath = tmplPrefix .. tmplIdx
            local btnTab  = self:MakeGameIndicateCheckBox(tabPath)
            local lbTab   = self:MakeGameLabel(tabPath .. ":Background:Label")
            local lbHlTab = self:MakeGameLabel(tabPath .. ":Background:Checkmark:Label")

            local conf   = mod.activities_general_datas.get(v)
            lbTab.Text   = conf.activeTitle
            lbHlTab.Text = conf.activeTitle

            local generalSn = v
            btnTab:RemoveAllClickCallBack()
            btnTab:AddClickCallBack(function (go)
                currSubTabSn = generalSn
                currDefaultTab[psn] = generalSn
                
                local status = nil
                for k,v in pairs(goalStates) do
                    if v.sn and v.sn == generalSn then
                        status = v or {}
                    end
                end

                self:SetGoalsProperties(generalSn, status)
                self.goalScroll:ScrllToTop()
            end)
            -- print (generalSn)
            tabBtns[generalSn] = btnTab
            tmplIdx = tmplIdx + 1
        end
    end

    -- Load default tab goals
    local gsn = currDefaultTab[psn] or subSns[1]
    currSubTabSn = gsn

    local status = nil
    for k,v in pairs(goalStates) do
        if v.sn and v.sn == gsn then
            status = v or {}
        end
    end

    for k,v in pairs(tabBtns) do v.Checked = false end
    if tabBtns[gsn] then tabBtns[gsn].Checked = true end

    if gsn then
        self:SetGoalsProperties(gsn, status)
        self.goalScroll:ScrllToTop()
    end
end

def.method("number", "table").SetGoalsProperties = function (self, generalSn, status)
    local mod = require ("game/ActivitiesMod/ActivitiesMod")
    local itemCreator = require ("game/CarnivalMod/view/CarnivalItem")

    local conf = mod.activities_general_datas.get(generalSn)

    local count = 0
    for k,v in pairs(conf.activegoal) do
        if v.sn and type(v.sn) == "number" then
            count = count + 1
        end
    end

    self.goalTile:Clear()
    self.goalTile:LEnsureSize(count)
    self.goalTile:Reposition()

    local goalPrefix = goalTilePath .. ":Template(Clone)_"

    -- Clear goalItems
    for k,v in pairs(conf.activegoal) do 
        if v.sn and type(v.sn) == "number" then
            goalItems[v.sn] = nil
        end
    end

    local goalIdx = 0
    for k,v in pairs(conf.activegoal) do
        if v.sn and type(v.sn) == "number" then
            local itemPath = goalPrefix .. goalIdx
            local item = self:MakeLuaComponent(itemCreator, itemPath)
            
            local state = 3
            if status and status.finishGoalSns then
                for k_s,v_s in pairs(status.finishGoalSns) do
                    if v_s == v.sn then
                        state = 1; break
                    end
                end
            end

            item:SetProperties(v, state)
            goalItems[v.sn] = item

            goalIdx = goalIdx + 1
        end
    end
end

function update_goals_status(proto)
    local msg_pb = require('protocol/activity_pb')
    local msg = msg_pb:SCActivityReward()
    msg:ParseFromString(proto)

    for k,v in pairs(msg.allActivityGoals) do
        if v.activityGoalSN and goalItems[v.activityGoalSN] then
            -- print (v.activityGoalSN .. " " .. v.status)
            goalItems[v.activityGoalSN]:UpdateButtonStatus(v.status)
        end
    end
end

CarnivalRight.Commit()
return CarnivalRight