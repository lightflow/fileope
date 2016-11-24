--[[
  File: CarnivalTab.lua
  Author: xingouy
  Date: 10/25/2016 8:56
]]

local CarnivalTab = Lplus.Extend(require "game/JOWBaseComponent","CarnivalTab")
local def = CarnivalTab.define

local path = "xiangxixinxi:buttonlist:Scroll View:UIGrid"

-- Left menu tile
def.field("userdata").tile    = nil

local tabBtns = {}
local currTabSn = nil

local onTabRedTipHandler = nil

def.override().OnInit = function (self)
    self.tile = self:MakeGameTile(path)

    onTabRedTipHandler = handler(self, self.OnTabRedTipChanged)
    EventMgr.AddListener(CarnivalEvents.UpdateRedTips, onTabRedTipHandler)
end

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnHide = function (self)

end

def.override().OnUpdate = function (self)

end

def.override().OnDispose = function (self)
    EventMgr.RemoveListener(CarnivalEvents.UpdateRedTips, onTabRedTipHandler)
end

def.method("table").OnTabRedTipChanged = function (self, data)
    -- print ("CarnivalTab -- OnTabRedTipChanged")
    for k,v in pairs(tabBtns) do
        if v then v:ShowSign(false, 0) end
    end

    for k,v in pairs(data["redActivity"]) do
        if type(v) == "number" and tabBtns[v] and tabBtns[v]:GetVisible() then
            tabBtns[v]:ShowSign(true, 0)
        end
    end
end

-- tabData:
--  sn, name
def.method("table").SetProperties = function (self, data)
    local mod = require ("game/ActivitiesMod/ActivitiesMod")

    local count = 0
    for k,v in pairs(data["openSn"]) do
        if type(v) == "number" then
            count = count + 1
            -- print(" --- key: " .. k .. " sn: " .. v)
        end
    end

    self.tile:Clear()
    self.tile:LEnsureSize(count)
    self.tile:Reposition()

    local tmplPrefix = path .. ":Template(Clone)_"

    local tmplIdx = 0
    for k,v in pairs(data["openSn"]) do
        if type(v) == "number" then
            local tabPath = tmplPrefix .. tmplIdx
            local btnTab  = self:MakeGameIndicateButton(tabPath)
            local lbTab   = self:MakeGameLabel(tabPath .. ":putong:Background:Label")

            local confCarnival = mod.carnival_datas.get(v)
            lbTab.Text = confCarnival.text

            local currentSn = v
            btnTab:RemoveAllClickCallBack()
            btnTab:AddClickCallBack(function (go)
                currTabSn = currentSn

                EventMgr.Brocast(CarnivalEvents.UpdateRightDatas,
                    currentSn,
                    confCarnival.subActivitySn,
                    data["redSubActivity"])
                
                EventMgr.Brocast(CarnivalEvents.UpdateRedTips, data)
            end)

            tabBtns[currentSn] = btnTab
            tmplIdx = tmplIdx + 1
        end
    end

    -- Load previous tab
    local tsn = currTabSn or 1
    currTabSn = tsn

    for k,v in pairs(tabBtns) do v.Checked = false end
    if tabBtns[currTabSn] then tabBtns[currTabSn].Checked = true end
    
    local confCarnival = mod.carnival_datas.get(tsn)
    EventMgr.Brocast(CarnivalEvents.UpdateRightDatas,
        tsn,
        confCarnival.subActivitySn,
        data["redSubActivity"])

    EventMgr.Brocast(CarnivalEvents.UpdateRedTips, data)
    
end

CarnivalTab.Commit()
return CarnivalTab