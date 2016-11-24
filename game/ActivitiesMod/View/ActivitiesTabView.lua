--[[
  File: ActivitiesTabView.lua
  Author: xingouy
  Date: 9/19/2016 13:55
  Desc: 活动左侧tab栏管理
  Modified: 10/21 重写
  Note: 每日签到按照策划需求是必须要显示的(即使是已经全部签到结束), 由客户端本地加上 10/21
]]--

local ActivitiesTabView = Lplus.Extend(require "game/JOWBaseComponent","ActivitiesTabView")
local def = ActivitiesTabView.define

def.field("userdata").tile = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)
    self.tile = self:MakeGameTile("Scroll View:UIGrid")
end

def.override().OnHide = function(self)
end

def.override().OnUpdate = function(self)
end

def.override().OnDispose = function(self)
end

def.method("table").SetProperties = function (self, tabs)

    local view = load_pack("game/ActivitiesMod/View/ActivitiesView")
    local mod = load_pack("game/ActivitiesMod/ActivitiesMod")
    
    local count = 0
    for k,v in pairs(tabs) do
        if type(v.sn) == "number" then count = count + 1 end
    end

    count = count + 1 -- 每日签到

    local extraCount = count

    self.tile:Clear()
    self.tile:LEnsureSize(count)
    self.tile:Reposition()

    -- init signed up tab.
    local tabSignedUpPath = "Scroll View:UIGrid:Template(Clone)_0"
    local tabSignedUpName = "每日签到"
    local tabSignedUp     = self:MakeGameIndicateCheckBox(tabSignedUpPath)
    local lbSignedUp      = self:MakeGameLabel(tabSignedUpPath .. ":ditu:Label-huodongming")
    lbSignedUp.Text       = tabSignedUpName

    tabSignedUp:RemoveAllClickCallBack()
    tabSignedUp:AddClickCallBack(function(go)
        view.HidePrevMgr(view.getSignedUpView(), true)
    end)
    -- end signed up tab.

    extraCount = extraCount - 1

    local view = load_pack("game/ActivitiesMod/View/ActivitiesView")

    -- init other tab
    for i = 1, extraCount do
        if type(tabs[i].sn) == "number" and type(tabs[i].type) == "number" then
            if tabs[i].type == 1 then -- 开服基金
                local confOpeningFund = mod.conf_fund.get(tabs[i].sn)

                if confOpeningFund ~= nil then
                    local tabOpeningFundPath = "Scroll View:UIGrid:Template(Clone)_" .. i
                    local tabOpeningFund     = self:MakeGameIndicateCheckBox(tabOpeningFundPath)
                    local lbOpeningFund      = self:MakeGameLabel(tabOpeningFundPath .. ":ditu:Label-huodongming")
                    lbOpeningFund.Text = "开服基金"

                    local fundSn = tabs[i].sn
                    tabOpeningFund:RemoveAllClickCallBack()
                    tabOpeningFund:AddClickCallBack(function(go)
                        view.HidePrevMgr(view, false)
                        view.getOpeningFundView():ShowView(fundSn)
                    end)
                end 
            end
        end
    end

end

ActivitiesTabView.Commit()
return ActivitiesTabView