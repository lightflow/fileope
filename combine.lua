--所有ui组件的基类
local JOWBaseComponent = Lplus.Extend(require "game/JOWUIFun","JOWBaseComponent")
local def = JOWBaseComponent.define

def.method("userdata").OnBeforeInit = function (self,component)
    self.LuaComponent = component
    self.LuaUILogic = component.LuaLogicHandler
end

def.virtual("dynamic").OnShow = function (self,obj)
end

def.method("boolean").SetVisible = function (self,b)
    if self.LuaComponent ~= nil then
        self.LuaComponent:SetVisible(b)
    else
        print("err LuaComponent")
    end
end

def.method("=>","boolean").GetVisible = function (self)
    if self.LuaComponent ~= nil then
        return self.LuaComponent:GetVisible()
    end
    print("err LuaComponent")
end

--def.method("function","string","=>","table").MakeLuaComponent = function (self,tableFun,path)
--    if self.LuaUILogic ~= nil and tableFun ~= nil then
--       tableComponet = tableFun()
--       local component = self.LuaUILogic:LMakeLuaComponent(tableComponet,path)
--       if component ~= nil then
--         return tableComponet
--       end
--    end
--    return nil
--end


--def.method("string","string","=>","userdata").MakeComponet = function (self,cname,path)
--    if self.LuaUILogic ~= nil and tableFun ~= nil then
--       component = self.LuaUILogic:LMake(cname,path)
--       if component ~= nil then
--         return component
--       end
--    end
--    return nil
--end

def.virtual().OnInit = function (self)
end

def.virtual().OnHide = function(self)
end

def.virtual().OnUpdate = function(self)
end

def.virtual().OnDispose = function(self)
end


def.override("=>","string").GetName = function (self)
  return "JOWBaseComponent"
end

JOWBaseComponent.Commit()
return JOWBaseComponentlocal JOWBaseUI = Lplus.Extend(require "game/JOWUIFun","JOWBaseUI")
local def = JOWBaseUI.define

def.method("userdata").OnBeforeInit = function (self,uilogic)
    self.LuaUILogic = uilogic
end

def.virtual().OnInit = function (self)
end


def.virtual("dynamic").OnShow = function (self,obj)
end

def.virtual().OnHide = function(self)
end

def.virtual().OnBack = function(self)
end

def.virtual().OnDispose = function(self)
end

def.method("string").ResetCloseBtn = function (self, path)
    self.LuaUILogic:ResetCloseBtn(path)
end

def.override("=>","string").GetName = function (self)
  return "JOWBaseUI"
end

JOWBaseUI.Commit()
return JOWBaseUIlocal JOWModle = Lplus.Class("JOWModle")
local def = JOWModle.define
local _enable = true;

def.virtual().Start = function (self)
end

def.virtual().Dispose = function (self)
end

def.virtual().OnStateChange = function(self)
end

def.virtual().Update = function(self)
end

def.virtual("=>","boolean").GetEnable = function(self)
    return _enable
end

def.virtual("boolean").SetEnable = function(self,b)
    _enable = b
end

def.virtual("=>","string").GetName=function (self)
  return "JOWModle"
end

JOWModle.Commit()
return JOWModle--region *.lua
--Date
local JOWUIFun = Lplus.Class("JOWUIFun")
local def = JOWUIFun.define
def.field("userdata").LuaUILogic = nil
def.field("userdata").LuaComponent = nil

-- 获取自定义的lua控件
-- 参数：继承JowBaseComponet空间 控件路径
 def.method("table","string","=>","table").MakeLuaComponent = function (self,tableFun,path)
    if self.LuaUILogic ~= nil and tableFun ~= nil then
       local tableComponet = tableFun()
       local component = nil
       if self.LuaComponent ~= nil then
         component = self.LuaComponent:LMakeLuaComponent(tableComponet,path)
       else 
         component = self.LuaUILogic:LMakeLuaComponent(tableComponet,path)
       end
       if component ~= nil then
          return tableComponet
       end
    end
    return nil
end



-- 获取C#实现的控件
def.method("string","string","=>","userdata").MakeComponent = function (self,cname,path)
    if self.LuaUILogic ~= nil then
       local component = nil
       if self.LuaComponent ~= nil then
           component = self.LuaComponent:LMake(cname,path)
       else
           component = self.LuaUILogic:LMake(cname,path)
       end
       if component ~= nil then
         return component
       end
    end
    return nil
end

def.method("string","=>","userdata").MakeGameUIComponent = function (self,path)
   return self:MakeComponent("GameUIComponent",path)
end

def.method("string","=>","userdata").MakeGameLabel = function (self,path)
   return self:MakeComponent("GameLabel",path)
end

def.method("string","=>","userdata").MakeGameInputField = function (self,path)
   return self:MakeComponent("GameInputField",path)
end


def.method("string","=>","userdata").MakeGameButton = function (self,path)
   return self:MakeComponent("GameButton",path)
end

def.method("string","=>","userdata").MakeGameImage = function (self,path)
   return self:MakeComponent("GameImage",path)
end

def.method("string","=>","userdata").MakeGameUIContainer = function (self,path)
   return self:MakeComponent("GameUIContainer",path)
end

def.method("string","=>","userdata").MakeGameTextComponent = function (self,path)
   return self:MakeComponent("GameTextComponent",path)
end

def.method("string","=>","userdata").MakeGameRichText = function (self,path)
   return self:MakeComponent("GameRichText",path)
end

def.method("string","=>","userdata").MakeGameCheckBox = function (self,path)
   return self:MakeComponent("GameCheckBox",path)
end

def.method("string","=>","userdata").MakeGameTile = function (self,path)
   return self:MakeComponent("GameTile",path)
end

def.method("string","=>","userdata").MakeGameUIEffect = function (self,path)
   return self:MakeComponent("GameUIEffect",path)
end

def.method("string","=>","userdata").MakeGameProgressBar = function (self,path)
   return self:MakeComponent("GameProgressBar",path)
end

def.method("string","=>","userdata").MakeGameScrollView = function (self,path)
   return self:MakeComponent("GameScrollView",path)
end

def.method("string","=>","userdata").MakeGameActorAvatar = function (self,path)
   return self:MakeComponent("GameActorAvatar",path)
end

def.method("string", "=>", "userdata").MakeGameIndicateButton = function (self, path)
    return self:MakeComponent("GameIndicateButton", path)
end

def.method("string", "=>", "userdata").MakeGameIndicateCheckBox = function (self, path)
    return self:MakeComponent("GameIndicateCheckBox", path)
end

def.virtual("=>","string").GetName = function (self)
  return "JOWUIFun"
end
JOWUIFun.Commit()
return JOWUIFun
--endregion
-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
require("game/JOWModle")
ModMgr = { }
local mods = { }
local adding = {}
local removing = {}
function ModMgr.InitMods()
    mods[#mods + 1] = require("game/datamod/datamod")();
    -- mods[#mods + 1] = require("game/testmod/testmod")();
    mods[#mods + 1] = require("game/ActivitiesMod/ActivitiesMod")();
    mods[#mods + 1] = require("game/CarnivalMod/CarnivalMod")();
    -- mods[#mods + 1] = require("game/MainUIMod/MainUIMod")();
    -- mods[#mods + 1] = require("game/EmbattleUI/EmbattleUIMod");
end
function ModMgr.Start()
     for i = 1, #mods do
        mods[i]:Start()
    end
end

local bupdate = false;
function ModMgr.Update()
    bupdate = true;
    for i = 1, #mods do
       if mods[i]:GetEnable() then
          mods[i]:Update()
       end
    end

    bupdate = false;
    for i = 1, #removing do 
        ModMgr.RemoveMod(removing[i])
    end
    removing = {}

    for i = 1, #adding do 
        mods[#mods + 1] = adding[i]
    end
    adding = {}

end

function ModMgr.AddMod(modstr)
    if bupdate then
        adding[#adding + 1] = modstr
    else
        mods[#mods + 1] = modstr
    end
end

function ModMgr.RemoveMod(mod)
    if bupdate then
        removing[#removing + 1] = mods
    else
        for i = 1, #mods do
            if mods[i] == mod then
                table.remove(mods, i)
                mod:Dispose()
                break
            end
        end
    end
end

function ModMgr.DisposeMods()
    for i = 1, #mods do
        mods[i]:Dispose()
    end
    mods = {}
end

ModMgr.Modules = mods
return ModMgr
-- endregion
--[[
  File: ActivitiesMod.lua
  Author: xingouy
  Date: 9/21/2016 20:11
]]

local ActivitiesMod = Lplus.Extend(require "game/JOWModle","ActivitiesMod")
local def = ActivitiesMod.define

local view = require(UINames.UI_Activities._logic)
local msg_pb = require('protocol/activity_pb')
local activities_settings = require('game/ActivitiesMod/View/ActivitiesSettings')

-- datas

-- 通用创建初始化活动数据的函数, 活动数据不读表, 从服务器读取
ActivitiesMod.create_activity_datas = function()

    local activity = {}

    activity.values = {}
    
    activity.clear = function()
        for k, v in activity.values do activity.values[k] = nil end
    end

    activity.update = function(datas)
        if datas ~= nil then
            for k,v in pairs(datas) do
                -- print (v.sn)
                if v.sn ~= nil then
                    activity.values[v.sn] = v
                end
            end
        end
    end

    activity.get = function(sn)
        if activity.values[sn] ~= nil then
            return activity.values[sn]
        end
    end

    activity.count = function()
        local num = 0
        for k, v in pairs(activity.values) do
            num = num + 1
        end
        return num
    end

    return activity
end

-- 开服嘉年华配置
ActivitiesMod.carnival_datas           = ActivitiesMod.create_activity_datas()
ActivitiesMod.activities_general_datas = ActivitiesMod.create_activity_datas()

-- 开服嘉年华宝箱配置, 参考宝箱配置表(ActivityFinalReward)
ActivitiesMod.conf_boxes  = ActivitiesMod.create_activity_datas()
--

-- 开服基金配置
ActivitiesMod.conf_fund      = ActivitiesMod.create_activity_datas()
ActivitiesMod.conf_fund_goal = ActivitiesMod.create_activity_datas()
-- ActivitiesMod.opening_fund_data = activities_settings.create_opening_fund_data()
ActivitiesMod.opening_fund_data = {}
ActivitiesMod.callback_fund = {}
ActivitiesMod.callback_fund_goal = {}
--

-- signed up
local total_login_days   = 0
local total_signed_days  = 0

-- Signed up rewards
local is_signed_up_rewards_init = false
local signed_up_rewards = {
    values = {},
    init = function(self, rewards)
        for k, v in pairs(rewards) do
            if v ~= nil and v.day ~= nil then
                self.values[v.day] = v
            end
        end
    end,
    clear = function(self)
        for k, v in pairs(self.values) do self.values[k] = nil end
    end,
    get = function(self, key)
        if self.values[key] ~= nil then
            return self.values[key]
        end
        return nil
    end
}

def.override().Start = function(self)
    NetMgr:AddEvent(MsgID.SCLoginActivityInfo, "set_total_days")
    NetMgr:AddEvent(MsgID.SCActivityRelativeConf, "init_activities_datas")
    NetMgr:AddEvent(MsgID.SCReturnOpenActivities, "init_activities_general_datas")
    NetMgr:AddEvent(MsgID.SCReturnOpenActivityChange, "update_activities_general_datas")
end

def.override().Dispose = function(self)
    NetMgr:DeleteEvent(MsgID.SCLoginActivityInfo, "set_total_days")
    NetMgr:DeleteEvent(MsgID.SCActivityRelativeConf, "init_activities_datas")
    NetMgr:DeleteEvent(MsgID.SCReturnOpenActivities, "init_activities_general_datas")
    NetMgr:DeleteEvent(MsgID.SCReturnOpenActivityChange, "update_activities_general_datas")
end

def.method("=>", "number").get_total_days = function(self)

    return total_login_days
end

def.static("=>", "number").get_total_signed_days = function(self)

    return total_signed_days
end

def.static("number").set_total_signed_days = function(self, signed_day)

    total_signed_days = signed_day
end

def.static("=>", "boolean").get_current_day_signed = function(self)

    return current_day_signed
end

def.static("boolean").set_current_day_signed = function (self, is_signed)

    current_day_signed = is_signed
end

def.static("=>", "table").get_signed_up_rewards = function(self)

    return signed_up_rewards
end

def.static("=>", "table").get_activities_datas = function(self)

    return activities_datas 
end

function set_total_days(proto)

    local msg = msg_pb.SCLoginActivityInfo()
    msg:ParseFromString(proto)

    print( "---------- login day: " .. msg.loginPriceReceiveDay .. "----- today is signed: " .. string.format("%s", msg.isLoginPriceReceived) .. "----" )

    total_signed_days  = msg.loginPriceReceiveDay
    current_day_signed = msg.isLoginPriceReceived
    -- current day is signed

    -- clear rewards
    if not is_signed_up_rewards_init then
        signed_up_rewards:clear()
        signed_up_rewards:init(msg.prices)
        is_signed_up_rewards_init = true
    end
end

function init_activities_datas (proto)

    local msg = msg_pb.SCActivityRelativeConf()
    msg:ParseFromString(proto)

    ActivitiesMod.carnival_datas.update(msg.activityOpenServer)
    ActivitiesMod.conf_fund.update(msg.fund)
    ActivitiesMod.conf_fund_goal.update(msg.fundGoal)

    ActivitiesMod.conf_boxes.update(msg.activityFinalReward)
end

function init_activities_general_datas (proto)
    local msg = msg_pb.SCReturnOpenActivities()
    msg:ParseFromString(proto)

    ActivitiesMod.activities_general_datas.update(msg.activityGenerals)
    -- print ("activities general size: " .. #msg.activityGenerals)
end

function update_activities_general_datas (proto)

    local msg = msg_pb.SCReturnOpenActivityChange()
    msg:ParseFromString(proto)

    for k,v in pairs(msg.activityGenerals) do
        print(k,v)
    end
end

ActivitiesMod.Commit()
return ActivitiesMod

--endregion
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
return FundGoalView--[[
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
return FundTabView--[[
  File: OpeningFundRewardItem.lua
  Author: xingouy
  Date: 10/17/2016 11:55
]]--

local OpeningFundRewardItem = Lplus.Extend(require "game/JOWBaseComponent","OpeningFundRewardItem")
local def = OpeningFundRewardItem.define


local fundSn    = 0
local itemSn    = 0

local imgIcon = nil
local lbTitle = nil
local lbCond  = nil
local btnGet  = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)

    imgIcon = self:MakeGameImage("jiangli:tItem:Template:itemtubiao")
    lbTitle = self:MakeGameLabel("jiangli:tItem:Template:Label-wupinshuliang")
    lbCond  = self:MakeGameLabel("jiangli:tItem:Template:Label-tiaojian")
    btnGet  = self:MakeGameButton("jiangli:button-lingqu")
end

def.override().OnHide = function(self)

end

def.override().OnUpdate = function(self)

end

def.override().OnDispose = function(self)

end

-- table data must include: fund_sn, item_sn, icon, title( name * num ), cond
def.method("table").SetProperties = function (self, data)
    fundSn  = data.fundSn
    itemSn  = data.itemSn
    imgIcon = data.icon
    lbTitle = data.title
    lbCond  = data.cond

    btnGet:RemoveAllClickCallBack()
    btnGet:AddClickCallBack(function(go)
        local msg  = msg_pb.CSGetFund()
        msg.fundSn = fundSn
        msg.sn     = itemSn

        print ("fsn: " .. fundSn .. " gsn: " .. itemSn)

        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end)
end

def.method().UpdateBtnState = function(self)

end


def.override("=>","string").GetName = function (self)
  return "OpeningFundRewardItem"
end

OpeningFundRewardItem.Commit()
return OpeningFundRewardItem--[[
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
return WelfareTabView--[[
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
return ActivitiesOpeningFundView--[[
  File: ActivitiesSettings.lua
  Author: xingouy
  Date: 9/19/2016 13:55
  Desc: 活动用到的基本数据结构, 一些路径设置
]]

local activities_settings = {}

activities_settings.activities_name = {
    ["signup"] = "每日签到",
    ["opening_fund"] = "开服基金",
}

activities_settings.create_signup_btn_data = function()
    local data = {
        day    = 1,
        enable = false, -- enable the button click and effect.
        is_vip = false,
        vip_x  = 0,
        icon   = "tianheshentie",
        num    = 1,
        signed = false
    }

    return data
end

activities_settings.create_opening_fund_data = function()
    local data = {
        sn               = 0,
        is_buy           = false,
        num              = 0,
        can_receive      = 0,
        already_received = 0,
        goals            = {}
    }

    return data
end
activities_settings.create_opening_fund_item_data = function()
    local data = {
        sn     = 0,
        icon   = "yuanbao",
        amount = "",
        cond   = "达到1级可以领取",
        status = 3,
    }

    return data
end

activities_settings.tab_common_path = "bottom:huodong:huodonglist:xiangxixinxi:buttonlist"
activities_settings.pnl_common_path = "bottom:huodong:huodonginfo:tongyong"
activities_settings.grid_item_start = "Template(Clone)_" -- no colon at start.



return activities_settings--[[
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
return ActivitiesTabView--region ActivityView.lua
--Date 9/9/2016 10:35AM
--此文件由[BabeLua]插件自动生成

ActivitiesView = Lplus.Extend(require "game/JOWBaseUI","ActivitiesView")
local def = ActivitiesView.define

local mod -- init mod in method OnInit
local msg_pb   = load_pack( 'protocol/activity_pb' )
local settings = load_pack( 'game/ActivitiesMod/View/ActivitiesSettings' )

-- Variables

local tab_common_path = "bottom:huodong:huodonglist:xiangxixinxi:buttonlist"
local pnl_common_path = "bottom:huodong:huodonginfo:tongyong"
local grid_item_start = settings.grid_item_start
local tab_tile_path   = tab_common_path .. ":Scroll View:UIGrid"
local currentMgr = nil

local tabTile    = nil

-- End Variables

local openFundCreator = load_pack ("game/ActivitiesMod/View/ActivitiesOpeningFundView")
local signedUpCreator = load_pack ("game/ActivitiesMod/View/ActivitySignedupView")

local signedUpMgr     = nil
local openingFundMgr  = nil

def.override().OnInit = function (self)

  -- force to disable useless panel
    local pnl_huodejiangli = self:MakeGameUIComponent(pnl_common_path .. ":huodejiangli")
    pnl_huodejiangli.Visible = false

    mod = load_pack ("game/ActivitiesMod/ActivitiesMod")

    tabTile         = self:MakeGameTile(tab_tile_path)

    openingFundMgr  = self:MakeLuaComponent(openFundCreator, pnl_common_path .. ":huodong-kaifujijin")
    signedUpMgr     = self:MakeLuaComponent(signedUpCreator, pnl_common_path .. ":qiandao")

    currentMgr = signedUpMgr

    self:ResetCloseBtn("Button-Back")

    NetMgr:AddEvent(MsgID.SCActivitiesList, "setTabs")

end

def.override().OnDispose = function (self)

    NetMgr:DeleteEvent(MsgID.SCActivitiesList, "setTabs")
end

def.override("dynamic").OnShow = function (self, obj)

    self:SendCSActivitiesList()
end

def.override().OnHide = function (self)

end

def.override("=>","string").GetName = function (self)
    return "ActivitiesView"
end

def.method().SendCSActivitiesList = function (self)
    local msg  = msg_pb.CSActivitiesList()
    local data = msg:SerializeToString()
    NetMgr:SendMessage(msg.protocid, data)
end

function setTabs(proto)
    local msg = msg_pb.SCActivitiesList()
    msg:ParseFromString(proto)

    print (#msg.infos)

    EventMgr.Brocast(ActivitiesEvents.InitActivitiesTab, msg.infos)
end

function initTabs(tabInfos)

    local count = 0
    for k,v in pairs(tabInfos) do
        if type(v.sn) == "number" then count = count + 1 end
    end

    count = count + 1 -- 每日签到

    local extraCount = count

    tabTile:Clear()
    tabTile:LEnsureSize(count)

    local tabSignedUpPath = tab_tile_path .. ":Template(Clone)_0"
    local tabSignedUpName = "每日签到"
    -- local tabSignedUp     = 

end

-- signed up callback 
function update_signedup(proto)

    local msg = msg_pb.SCActitivyLoginPriceResult()
    msg:ParseFromString(proto)
    -- msg convert
    pnl_signup.btn_signed_today.effect:SetVisible(false)
    pnl_signup.btn_signed_today.btn.Enable = false
    pnl_signup.btn_signed_today.signed:SetVisible(true)

    -- print( "now signed days: " .. msg.loginPriceReceiveDay )

    mod.set_total_signed_days(msg.loginPriceReceiveDay)
    mod.set_current_day_signed(true)

    local rewards = {}

    local conf_activities = require('conf/ConfActivity')
    local conf_items      = require('conf/ConfItem')

    local conf_activity   = conf_activities.Get(msg.loginPriceReceiveDay)
    local conf_item       = conf_items.Get(conf_activity.ItemSN)

    local item_icon       = conf_item.iconId
    local item_num        = conf_activity.ItemNum

    -- print( "icon: " .. item_icon .. " num: " .. item_num )

    rewards[item_icon] = item_num

    print( #rewards )

    local rewards_view = require(UINames.UI_Rewards._logic)
    rewards_view.set_rewards(rewards)

    OpenUIFrame(UINames.UI_Rewards._name)
end

ActivitiesView.Commit()
return ActivitiesView

--endregion
--[[
  File: ActivitiesSignedupView.lua
  Author: xingouy
  Date: 9/19/2016 13:55
  Desc: 签到管理
]]--

local ActivitiesSignedupView = Lplus.Extend(require "game/JOWBaseComponent","ActivitiesSignedupView")
local def = ActivitiesSignedupView.define

def.field("userdata").tile = nil

def.override("dynamic").OnShow = function (self,obj)
end

def.override().OnInit = function (self)
    self.tile = self:MakeGameTile("Scroll View:UIGridjiangli")
end

def.override().OnHide = function (self)

end

def.override().OnUpdate = function (self)

end

def.override().OnDispose = function (self)

end

ActivitiesSignedupView.Commit()
return ActivitiesSignedupView

--[[
local settings = require( 'game/ActivitiesMod/View/ActivitiesSettings' )
local msg_pb = require( 'protocol/activity_pb' )

activity_signup_view = function(LuaUILogic)

    local ActivitiesMod   = require("game/ActivitiesMod/ActivitiesMod")

    local pnl_common_path = settings.pnl_common_path
    local grid_item_start = settings.grid_item_start

    local mgr = {}

    mgr.__index = mgr

    mgr.logic      = LuaUILogic

    mgr.path       = pnl_common_path .. ":qiandao"
    mgr.tab_name   = "每日签到"
    mgr.panel      = nil
    mgr.tile       = nil
    mgr.time_label = nil
    mgr.btns       = {}

    mgr.total_signed_days = 0
    mgr.is_signed_today   = false
    mgr.btn_signed_today  = nil -- today's button

    mgr.first_init        = false

    mgr.init = function(days)

        mgr.panel      = mgr.logic:LMakeGameUIComponent(mgr.path)
        mgr.tile       = mgr.logic:LMakeGameUIContainer(mgr.path .. ":Scroll View:UIGridjiangli")
        mgr.time_label = mgr.logic:LMakeGameLabel(mgr.path .. ":Label-qiandao")

        mgr.tile:LEnsureSize(30)
        mgr.init_all_btns()
    end

    mgr.show = function()

        if mgr.panel ~= nil then mgr.panel:SetVisible(true) end

        local days = ActivitiesMod.get_total_signed_days()
        mgr.is_signed_today = ActivitiesMod.get_current_day_signed()

        if not mgr.first_init or not mgr.is_signed_today then
            mgr.update_datas(days)
            mgr.first_init = true
        end
    end

    mgr.hide = function()
        mgr.panel.Visible = false
    end

    mgr.dispose = function()
        for k,v in pairs(mgr) do
            mgr[k] = nil
        end
    end

    -- init all days buttons
    mgr.init_all_btns = function()

        for k, v in pairs( mgr.btns ) do mgr.btns[k] = nil end

        local btn_common_path = mgr.path .. ":Scroll View:UIGridjiangli"

        for day_idx = 1, 30 do
            local idx = day_idx - 1
            local btn_signup = mgr.create_signup_btn(mgr.tile.LuaLogicHandler, btn_common_path, idx)
            btn_signup.btn:AddClickCallBack(mgr.send_signed_msg)
            table.insert( mgr.btns, btn_signup )
        end
    end

    -- init all buttons' datas
    mgr.update_datas = function(days)

        mgr.total_signed_days = days
        mgr.set_accumulated_signup_times(days)

        mgr.is_signed_today = ActivitiesMod.get_current_day_signed()

        local rewards         = ActivitiesMod.get_signed_up_rewards()
        local conf_items      = require('conf/ConfItem')

        local btn_common_path = mgr.path .. ":Scroll View:UIGridjiangli"
        local coeffient       = math.floor( mgr.total_signed_days / 30 )
        local sign_day        = 0

        if mgr.is_signed_today then
            sign_day = mgr.total_signed_days
        else
            sign_day = mgr.total_signed_days + 1
        end

        for day_idx = 1, 30 do
            local idx        = day_idx - 1
            -- local btn_signup = mgr.create_signup_btn(mgr.tile.LuaLogicHandler, btn_common_path, idx)

            -- init data
            local data       = settings.create_signup_btn_data()
            data.day         = day_idx + coeffient * 30
            data.enable      = data.day == sign_day and not mgr.is_signed_today

            if data.day == sign_day then
                mgr.btn_signed_today = mgr.btns[day_idx]
            end

            local conf_activity = rewards:get(coeffient * 30 + day_idx)
            local conf_item = nil
            if conf_activity ~= nil then
                conf_item   = conf_items.Get(conf_activity.itemSn)
                data.num    = conf_activity.itemNum
                data.is_vip = conf_activity.vipLimit ~= 0
                data.vip_x  = conf_activity.mulpliper
            else
                conf_item = conf_items.Get(2) -- use default item
            end

            if conf_item ~= nil then
                data.icon = conf_item.iconId
            end

            mgr.btns[day_idx].set(data, sign_day)
        end
    end

    mgr.create_signup_btn = function(ui_logic, btn_common_path, idx)

        local _signup_btn =  {}

        _signup_btn.btn    = nil
        _signup_btn.effect = nil
        _signup_btn.vip    = nil
        _signup_btn.vipx   = nil
        _signup_btn.signed = nil
        _signup_btn.icon   = nil

        local _common_path = btn_common_path .. ":" .. grid_item_start

        _signup_btn.root = ui_logic:LMakeGameButton(_common_path .. idx)

        if _signup_btn.root ~= nil then
            _signup_btn.btn    = _signup_btn.root:LMakeGameButton("tItem:Template")
            _signup_btn.effect = _signup_btn.root:LMakeGameUIComponent("tItem:Template:Guangquan")
            _signup_btn.vip    = _signup_btn.root:LMakeGameUIComponent("tItem:Template:Image-vip")
            _signup_btn.vipx   = _signup_btn.root:LMakeGameLabel("tItem:Template:Image-vip:Label-fanbei")
            _signup_btn.signed = _signup_btn.root:LMakeGameUIComponent("tItem:Template:yilingqu")
            _signup_btn.icon   = _signup_btn.root:LMakeGameImage("tItem:Template:itemtubiao")

            _signup_btn.btn.Enable     = false
            _signup_btn.effect:SetVisible(false)
            _signup_btn.vip:SetVisible(false)
            _signup_btn.signed:SetVisible(false)
        else
            print( "error: mgr.btn is nil." )
        end

        _signup_btn.set = function(data, current) -- signup_btn_data
        
            _signup_btn.btn.Enable     = data.enable
            _signup_btn.effect:SetVisible(data.enable)
            _signup_btn.vip:SetVisible(data.is_vip)
            _signup_btn.icon.Sprite    = data.icon

            if data.is_vip then
                _signup_btn.vipx.Text = data.vip_x .. "倍"
            end

            if data.day < current or ( data.day == current and mgr.is_signed_today ) then
                _signup_btn.signed.Visible = true
            end
        end

        return _signup_btn
    end

    mgr.set_accumulated_signup_times = function(val)

        if mgr.time_label ~= nil then
            local content = "累计签到次数：" .. val
            mgr.time_label.Text = content
        end
    end

    mgr.send_signed_msg = function(gameObject)

        local msg  = msg_pb.CSActivityLoginPrice()
        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end

    mgr.show_rewards_pnl = function ()

    end

    return mgr
end

return activity_signup_view
]]--[[
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
return CarnivalItem--[[
  File: CarnivalOpenbox.lua
  Author: xingouy
  Date: 10/25/2016 8:56
]]

local CarnivalOpenbox = Lplus.Extend(require "game/JOWBaseComponent","CarnivalOpenbox")
local def = CarnivalOpenbox.define

local msg_pb = load_pack('protocol/activity_pb')

-- -300, 300
local progress_value  = {0, 0.07, 0.16, 0.37, 0.60, 1.0 }

local progbar = nil
local boxes = {}
local totalValue = 0

local currentBoxSn = 0

def.override().OnInit = function (self)
    progbar = self:MakeGameProgressBar("jindutiao:jindu")
    progbar.Value = 0.0

    for i = 1, 5 do
        local box_path = "baoxiang" .. i
        -- print (box_path)
        local box = {}
        box.sn = 0
        box.btn = self:MakeGameButton(box_path)
        box.close = self:MakeGameUIComponent(box_path .. ":baoxiangguanbi")
        box.lbReceived = self:MakeGameUIComponent(box_path .. ":yilingqu")
        box.received = self:MakeGameUIComponent(box_path .. ":baoxiangkaiqi")
        box.lbCanReceive = self:MakeGameUIComponent(box_path .. ":kelingqu")
        box.lbNum = self:MakeGameLabel(box_path .. ":xingxingshuliang")
        box.posCoeff = 0.0

        table.insert( boxes, box )
    end

    NetMgr:AddEvent(MsgID.SCOpenServerFinalReward, "update_all_boxes")
end

def.override("dynamic").OnShow = function (self,obj)

end

def.override().OnHide = function (self)

end

def.override().OnUpdate = function (self)

end

def.override().OnDispose = function (self)
    NetMgr:DeleteEvent(MsgID.SCOpenServerFinalReward, "update_all_boxes")
end

def.method("table").SetProperties = function (self, data)
    local currentValue = data["currentValue"]

    -- print ("currentValue: " .. currentValue)

    local idx = 1
    for k,v in pairs(data["boxs"]) do
        -- print (k, v)
        if v.sn and type(v.sn) == "number" then
            -- print (v.sn .. " ::::: " .. v.target)
            -- boxes[idx].received.Visible = true
            init_box_state(boxes[idx], v)
            update_box_state(boxes[idx], v, currentValue)

            if v.target > totalValue then totalValue = v.target end
            idx = idx + 1
        end
    end

    -- update box position
    idx = 1
    for k,v in pairs(data["boxs"]) do
        if v.sn and type(v.sn) == "number" then
            local coeff = v.target / totalValue
            update_box_position(boxes[idx], coeff)

            idx = idx + 1
        end
    end

    print ("currentVal: " .. currentValue .. " totalValue: " .. totalValue)
    progbar.Value = currentValue / totalValue
end

function init_box_state(box, dOpenServerBox)

    print (dOpenServerBox.sn .. " --- " .. dOpenServerBox.target)

    box.sn = dOpenServerBox.sn
    box.lbNum.Text = dOpenServerBox.target

    box.btn:RemoveAllClickCallBack()
    box.btn:AddClickCallBack(function(go)
        local msg = msg_pb.CSOpenServerFinalReward()
        msg.sn = dOpenServerBox.sn
        currentBoxSn = dOpenServerBox.sn
        local data = msg:SerializeToString()
        NetMgr:SendMessage(msg.protocid, data)
    end)
end

-- 1:　已领取, 2: 可领取, 3: 不能领取 
function update_box_state(box, v, currentVal)

    print (box.sn .. " " .. tostring(v.state))

    local status = 3
    if currentVal >= v.target then
        status = 2
    end

    if v.state then status = 1 end

    print (status)

    box.btn.Enable = true;
    box.btn.ShowEnable = true;

    box.close.Visible = true
    box.lbReceived.Visible = false
    box.received.Visible = false
    box.lbCanReceive.Visible = false

    local bReceived = false
    if status == 1 then bReceived = true end
    box.close.Visible = not bReceived
    box.lbNum.Visible = not bReceived
    box.lbReceived.Visible = bReceived
    box.received.Visible = bReceived

    if status == 2 then
        box.lbCanReceive.Visible = true
    end
end

function update_box_position(box, coeff)
    box.coeff = coeff
    box.btn.X = -300 + 600 * coeff
end

function update_all_boxes(proto)

    local msg = msg_pb.SCOpenServerFinalReward()
    msg:ParseFromString(proto)

    local currentValue = msg.currentValue
    for k,v in pairs(msg.boxs) do
        if v.sn and type(v.sn) == "number" then
            for k1,v1 in pairs(boxes) do -- box
                if v1.sn and type(v1.sn) == "number" and v.sn == v1.sn then
                    print (v.sn .. " --- " .. v1.sn)
                    init_box_state(v1, v)
                    update_box_state(v1, v, currentValue)
                end
            end
        end
    end

    local mod = load_pack("game/ActivitiesMod/ActivitiesMod")
    local confBox = mod.conf_boxes.get(currentBoxSn)

    local sns = {}
    local nums = {}
            -- print (v.sn .. " -- " .. v.num)
    table.insert(sns, confBox.item.sn)
    table.insert(nums, confBox.item.num)
    -- print ("sns: " .. #sns .. " nums: " .. #nums)
    CommonRewardUILogic.LShowRewardUI(sns, nums)
end

CarnivalOpenbox.Commit()
return CarnivalOpenbox--[[
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
return CarnivalRight--[[
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
return CarnivalTab--[[
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
--[[
  File: Item.lua
  Author: xingouy
  Date: 9/26/2016 19:31
]]

local item_fact = {}

item_fact.create_item = function(
    icon_path, num_path
    )
    
    if type(icon_path) ~= "string" then
        print ("icon path is not string")
        return nil
    end

    if type(num_path) ~= "string" then
        print ("num path is not string")
        return nil
    end

    local item = {}

    return item
end

return item_factlocal JOWModle = require("game/JOWModle")
local DataMod = Lplus.Extend(JOWModle,"DataMod")
local def = DataMod.define
local common_pb = require "protocol/common_pb"

HeroData = {}
StageInfo = {}
--���ǳ������� SceneMod.Hero.PlayerData
--�������� ʵʱ����
def.override().Start = function(self)
    NetMgr:AddEvent(MsgID.SCInitData,"OnSCInitData")
    NetMgr:AddEvent(MsgID.SCHumanInfoChange,"OnSCHumanInfoChange")
end

function OnSCInitData(proto)
    local dataProtocol= common_pb.SCInitData()
  	dataProtocol:ParseFromString(proto)
    HeroData = dataProtocol.human
    StageInfo = dataProtocol.stage
   
end


function OnSCHumanInfoChange(proto)
    local dataProtocol= common_pb.SCHumanInfoChange()
  	dataProtocol:ParseFromString(proto)
    UpdateProtoData(HeroData,dataProtocol.human)
    -- EventMgr.Brocast(HumanEvent.HumanDataInfo)
end

def.override().Dispose = function(self)
    NetMgr:DeleteEvent(MsgID.SCInitData,"OnSCInitData")
    NetMgr:DeleteEvent(MsgID.SCHumanInfoChange,"OnSCHumanInfoChange")
end

def.override().Update = function(self)
end

DataMod.Commit()
return DataMod
--endregion
--[[

--]]

RewardsView = Lplus.Extend(require "game/JOWBaseUI","RewardsView")
local def = RewardsView.define

local settings = require( 'game/ActivitiesMod/View/ActivitiesSettings' )

local tile = nil
local pnl_reward = nil
local logic = nil

local rewards = {}

local tile_path = "querenkuang:wupin:Scroll View:UIGridjiangli"

def.override("userdata").OnInit = function (self, LuaUILogic)

    logic = LuaUILogic
    tile  = LuaUILogic:LMakeGameUIContainer(tile_path)
    LuaUILogic:ResetCloseBtn("querenkuang:button-lingqu")
end


def.override("dynamic").OnShow = function (self)

    RewardsView.show_rewards(tile.LuaLogicHandler)
end

def.override().OnHide = function (self)

end

def.override().OnDispose = function (self)

end

def.override("=>","string").GetName = function (self)
  return "RewardsView"
end

RewardsView.set_rewards = function(new_rewards)
    -- clear old rewards
    for k, v in pairs(rewards) do rewards[k] = nil end

    for k, v in pairs(new_rewards) do
        rewards[k] = v
    end

end

RewardsView.show_rewards = function (ui_logic)

    local size = 0

    if rewards ~= nil then
        for k in pairs( rewards ) do
            size = size + 1
        end
    end

    tile:LEnsureSize(size)

    local grid_item_start = settings.grid_item_start

    local idx = 0
    for k, v in pairs( rewards ) do
        local item = ui_logic:LMakeGameUIComponent(tile_path .. ":" .. grid_item_start .. idx)
        local icon = item:LMakeGameImage("itemtubiao")
        local num  = item:LMakeGameLabel("num")

        -- print( k, v )

        if icon ~= nil then icon.Sprite = k else print( "icon is nil" ) end
        if num ~= nil then num.Text = v else print( "num is nil" ) end

        idx = idx + 1
    end
end

RewardsView.Commit()
return RewardsViewSceneMod = Lplus.Extend(require("game/JOWModle"),"SceneMod")
local def = SceneMod.define
local common_pb = require "protocol/common_pb"
local stage_pb = require "protocol/stage_pb"

 StageType = 
    {
        MainCity = 0,
        Common   = 1, --普通
        Rep      = 2, --副本
        Tower    = 3,  --爬塔
        Arena    = 4, --竞技场
        Album, --将星录
        Home, --家园
        HomeNew,--资源抢矿
        pvp,
        PvPCommon,
        baoZang,
        UnionCommon,--联盟地图
        Iron,--远征
        UnionWarCommon,--帮战地图
        UnionWarBattle,--帮战战斗地图
        LadderArena, --天梯竞技场
        WorldBossCommon,
        WorldBossBattle,
        FightLastCommon,--血战到底
        FightLastPvp,
        GuardCityCommon,
        GuardCityPvp,
        WeddingCommon,
        CrossBloodCommon,
        CrossBloodBattle,
        UnionBossCommon,
        XialuBattle,        --狭路相逢
    }
def.override().Start = function(self)
    NetMgr:AddEvent(MsgID.SCStageSwitch,"OnSwitchStage")
end

def.override().Dispose = function(self)
    NetMgr:DeleteEvent(MsgID.SCStageSwitch,"OnSwitchStage")
end

--切换场景
function OnSwitchStage(proto)
    local dataProtocol= stage_pb.SCStageSwitch()
  	dataProtocol:ParseFromString(proto)
    StageInfo.posNow.x = dataProtocol.pos.x
    StageInfo.posNow.y = dataProtocol.pos.y
    StageInfo.sn = dataProtocol.stageSn
    StageInfo.id = dataProtocol.stageId
    SceneMod.LoadStage(StageInfo.sn)
end

local _currentStage = nil
local CurStageType
function SceneMod.LoadStage(sn)
    UIMgr:HideAllFrames()
    require "conf/ConfMap"
    _currentStage = ConfMap.Get(sn)
    if _currentStage ~= nil then
        CurStageType = _currentStge.ctype
    end
end


SceneMod.Commit()
return SceneModlocal testmod = Lplus.Extend(require "game/JOWModle","testmod")
local def = testmod.define
local _enable = true;

-- local view = require(UINames.UI_YaoQianShu._logic)

--handle
local humanHandle

def.override().Start = function (self)

--    NetMgr:AddEvent(MsgID.SCOpenRideCollection, "OnSCOpenRideCollection")
    -- humanHandle = handler(self,self.OnInfoChange)
    -- EventMgr.AddListener(HumanEvent.HumanDataInfo,humanHandle)
end

def.method("string").OnInfoChange = function (self,info)
    print(info)
end

def.override().Dispose = function (self)

    -- EventMgr.RemoveListener(HumanEvent.HumanDataInfo,humanHandle)

end

def.override().OnStateChange = function(self)
end

def.override().Update = function(self)
    -- local test =  require (UINames.UI_YaoQianShu._logic)()
    -- test:OnHide()
--    EventMgr.Brocast(HumanEvent.HumanDataInfo,"test111111-------------------------11")
end

def.override("=>","string").GetName=function (self)
  return "testmod"
end

testmod.Commit()
return testmodlocal TestView = Lplus.Extend(require "game/JOWBaseUI","TestView")
local JOWBaseUI = require "game/JOWBaseUI"
local def = TestView.define

local yaoBtn
local Black_GameImage
def.override().OnInit = function (self)
   yaoBtn = self:MakeGameButton("Yaoqianshu:button-yao")
   yaoBtn:AddClickCallBack(TestView.testClick)
   self.LuaUILogic:ResetCloseBtn("guanbi");
   self.LuaUILogic:ResetCloseBtn("button-close");
end

function TestView.testClick(obj)
   print("testClick--------------------")
   local conf = require ("conf/ConfBuff")
  local item = conf.Get(1006040201)
  print( "confbuff 1006040201" .. item.name)
end

def.override("dynamic").OnShow = function (self,obj)
    print("OnShow--------------------")
end

def.override().OnHide = function(self)
    print ("OnHide-------------------")
    if not UIMgr:IsVisible("UI-MainCityUI.prefab") then
        print ("Show the visible MainCityUI.")
        UIMgr:ShowFrame("UI-MainCityUI.prefab", nil, false, nil, nil)
        -- UIMgr:LuaShowFrame("UI-MainCityUI.prefab", UINames.UI_YaoQianShu._logic)
    else
        print ("MainCityUI is not visible.")
    end

    print ("OnHide End---------------")
end

def.override().OnDispose = function(self)
end


def.override("=>","string").GetName=function (self)
  return "TestView"
end

TestView.Commit()
return TestView
--[[
  File: UserBackMod.lua
  Author: xingouy
  Date: 9/27/2016 16:42
]]

local UserBackMod = Lplus.Extend(require "game/JOWModle","UserBackMod")
local def = UserBackMod.define
local msg_pb = require('protocol/activity_pb')

local ActivitiesMod = require("game/ActivitiesMod/ActivitiesMod")

-- 已经开服的活动
UserBackMod.open_sn = {}
UserBackMod.achieved_goals = {}
UserBackMod.update = {}
UserBackMod.datas = {
    current_target = 1, -- 当前任务进度
}

UserBackMod.boxes = {}
-- empty params
UserBackMod.callback_boxes_update = {}
-- param: box sn
UserBackMod.show_box_reward_callback = {}

UserBackModEvent = {
    ShowBoxReward = "show_box_reward_callback",
}

-- 左侧tab红点提示
local left_tab_states = {}
-- 右上tab红点提示
local right_tab_states = {}
-- 红点提示回调
-- local red_tips_callback = {}

def.override().Start = function (self)

    NetMgr:AddEvent(MsgID.SCOpenServerActivity, "set_UserBack_data")
    NetMgr:AddEvent(MsgID.SCOpenServerFinalReward, "UserBack_boxes_callback")
    NetMgr:AddEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Dispose = function (self)

    NetMgr:DeleteEvent(MsgID.SCOpenServerActivity, "set_UserBack_data")
    NetMgr:DeleteEvent(MsgID.SCOpenServerFinalReward, "UserBack_boxes_callback")
    NetMgr:DeleteEvent(MsgID.SCOpenServerRredActivity, "update_red_tips")
end

def.override().Update = function (self)

end

def.override("=>","string").GetName = function (self)
    return "UserBackMod"
end

UserBackMod.update_red_tips_base = function (left_datas, right_datas)

    if left_datas ~= nil then
        for k,v in pairs(left_datas) do
            if type(v) == "number" then
                left_tab_states[v] = true
            end
        end
    else
        print ("redActivity is nil")
    end

    if right_datas ~= nil then
        for k,v in pairs(right_datas) do
            if v.sn ~= nil and type(v.sn) == "number" then
                right_tab_states[v.sn] = true
                -- 更新ActiveGoal.
                if v.canCollectedGoalSns ~= nil then
                    for k,v in pairs(v.canCollectedGoalSns) do
                        UserBackMod.achieved_goals[v] = true
                    end
                end

                if v.finishGoalSns ~= nil then
                    for k,v in pairs(v.finishGoalSns) do
                        UserBackMod.achieved_goals[v] = false
                    end
                end
            end
        end
    else
        print ("redSubActivity is nil")
    end
end

UserBackMod.update_callback = function()
    for k, v in pairs(UserBackMod.update) do
        if type(v) == "function" then
            UserBackMod.update[k]()
        end
    end
end

-- tbl is repeated DOpenServerBox
UserBackMod.update_boxes = function(tbl)
    for k,v in pairs(tbl) do
        if v.sn ~= nil and type(v.sn) == "number" then
            -- print ("box " .. v.sn .. " receive state: " .. tostring(v.state))
            if UserBackMod.boxes[v.sn] == nil then
                UserBackMod.boxes[v.sn] = {}
            end

            UserBackMod.boxes[v.sn].target = v.target
            UserBackMod.boxes[v.sn].state = v.state
            UserBackMod.boxes[v.sn].rewards = v.reward
        end
    end
end

function set_UserBack_data(proto)

    local msg = msg_pb.SCOpenServerActivity()
    msg:ParseFromString(proto)

    print ( "endTime: " .. msg.endTime)
    print ( "current Value: " .. msg.currentValue .. " type: " .. type(msg.currentValue) )

    UserBackMod.datas.current_target = msg.currentValue

    UserBackMod.update_red_tips_base(msg.redActivity, msg.redSubActivity)

    UserBackMod.update_boxes(msg.boxs)

    for k, v in pairs(msg.openSn) do
        -- print ("open left sn: ", v)
        UserBackMod.open_sn[k] = v
    end

    -- callback after UserBack data update.
    for k, v in pairs(UserBackMod.update) do
        if type(v) == "function" then
            UserBackMod.update[k]()
        end
    end
end

-- 点击开箱之后返回消息
function UserBack_boxes_callback(proto)

    local msg = msg_pb.SCOpenServerFinalReward()
    msg:ParseFromString(proto)

    -- 更新宝箱数据之前比较哪个箱子发生了变化(被打开了), 这里给一个回调用于显示宝箱奖励
    for k,v in pairs(msg.boxs) do
        if v.sn ~= nil and type(v.sn) == "number" then
            if UserBackMod.boxes[v.sn].state ~= v.state and v.state == 4 then
                EventMgr.Brocast(UserBackModEvent.ShowBoxReward, v.reward)
            end
        end
    end

    UserBackMod.datas.current_target = msg.currentValue
    UserBackMod.update_boxes(msg.boxs)

    for k,v in pairs(UserBackMod.callback_boxes_update) do
        if type(v) == "function" then
            UserBackMod.callback_boxes_update[k]()
        end
    end
end

function update_red_tips(proto)

    print ("--- UserBackMod update red tips ---")


    local msg = msg_pb.SCOpenServerRredActivity()
    msg:ParseFromString(proto)
    UserBackMod.update_red_tips_base( msg.redActivity, msg.redSubActivity )

    if red_tips_callback ~= nil then
        for k,v in pairs(red_tips_callback) do
            if type(v) == "function" then
                red_tips_callback[k](msg.redActivity, msg.redSubActivity)
            end
        end
    end

    if UserBackMod.update ~= nil then
        for k, v in pairs(UserBackMod.update) do
            if type(v) == "function" then
                UserBackMod.update[k]()
            end
        end
    end
end

UserBackMod.Commit()
return UserBackMod

UserBackView = Lplus.Extend(require "game/JOWBaseUI","UserBackView")
local def = UserBackView.define

local msg_pb = require('protocol/activity_pb')
local ActivitiesMod = require("game/ActivitiesMod/ActivitiesMod")
local UserBackMod = require ("game/UserBackMod/UserBackMod") 

-- Common Variables
local tab_tile_path    = "bottom:huodonglist:xiangxixinxi:buttonlist:Scroll View:UIGrid"
local subtab_tile_path = "bottom:huodonginfo:biaoqianye:UIGrid"
local item_tile_path   = "bottom:huodonginfo:huodejiangli:Scroll View:UIGridjiangli"
local grid_item_start  = "Template(Clone)_"

-- Deprecated: Do not load config file from local.
-- require('conf/ConfActivityOpenServer')
-- require('conf/ConfActiveGeneral')
-- require('conf/ConfActiveGoal')
--

-- 

-- openbox
local progress_value  = {0, 0.07, 0.16, 0.37, 0.60, 1.0 }
local openbox_mgr = nil
--

local tile        = nil
local subtab_tile = nil
local item_tile   = nil

-- 左侧tab集合
local tabs        = nil

local logic       = nil
local first_show  = true

local prev_tab_idx = 1
local prev_subtab_idx = {}

-- index: indicator, visible

function create_indicator_mgr()
    
    local t = {}
    t.indicators = {}

    t.add_indicator = function(sn, go)
        if t.indicators[sn] == nil then
            t.indicators[sn] = {}
        end
        
        if not t.indicators[sn].visible then
            t.indicators[sn].visible = false
        end

        t.update_indicator(sn, go)
    end

    t.clear = function()
        for k,v in pairs(t.indicators) do
            t.indicators[k] = nil
        end
    end

    t.update_indicator = function(sn, go)
        if t.check_sn(sn) then
            t.indicators[sn].go = go

            if tile.Visible then
                t.indicators[sn].go.Visible = t.indicators[sn].visible
            end
        end
    end

    t.set_visible = function(sn, v)
        if t.check_sn(sn) then
            t.indicators[sn].visible = v
            t.indicators[sn].go.Visible = v
        end
    end

    t.show = function ()
        for k,v in pairs(t.indicators) do
            if t.check_sn(k) then
                t.indicators[k].go.Visible = t.indicators[k].visible
            end
        end
    end

    t.check_sn = function(sn)
        if t.indicators[sn] then
            return true
        else
            print ("sn " .. sn .. " not added.")
            return false
        end
    end

    return t
end

local left_indicators         = create_indicator_mgr()
local right_top_indicators    = create_indicator_mgr()
--

def.override().OnInit = function (self)

    tile        = self.LuaUILogic:LMakeGameTile(tab_tile_path)
    subtab_tile = self.LuaUILogic:LMakeGameTile(subtab_tile_path)
    item_tile   = self.LuaUILogic:LMakeGameTile(item_tile_path)

    logic = self.LuaUILogic
    
    self.LuaUILogic:ResetCloseBtn("bottom:guanbi")

    table.insert( UserBackMod.update, update_current_tabs )
    table.insert( UserBackMod.callback_boxes_update, update_openbox )

    EventMgr.AddListener(UserBackModEvent.ShowBoxReward, show_rewards_panel)
    
    NetMgr:AddEvent(MsgID.SCActivityReward, "show_rewards")
    NetMgr:AddEvent(MsgID.SCOpenServerRredActivity, "view_update_red_tips")
end

def.override("dynamic").OnShow = function (self,obj)

    send_CSOpenServerActivity()

    if tabs ~= nil then
        for k, v in pairs(tabs) do tabs[k] = nil end
    end
end

def.override().OnHide = function(self)
end

def.override().OnDispose = function(self)

    EventMgr.RemoveListener(UserBackModEvent.ShowBoxReward, show_rewards_panel)

    NetMgr:DeleteEvent(MsgID.SCActivityReward, "show_rewards")
    NetMgr:DeleteEvent(MsgID.SCOpenServerRredActivity, "view_view_update_red_tips")
end

def.override("=>","string").GetName=function (self)

  return "UserBackView"
end

-- 初始化开箱
function init_openbox(ui_logic)

    local openbox = {}

    local openbox_size = 5

    openbox.progress_bar = ui_logic:LMakeGameProgressBar("bottom:Jiangli:jindutiao:jindu")
    openbox.boxes = {}

    openbox.init = function(conf)
        local i = 1
        for k,v in pairs(conf) do
            if v.sn ~= nil and type(v.sn) == "number" and i <= openbox_size then
                local box = {}

                local box_path = "bottom:Jiangli:baoxiang" .. i

                -- init ui
                box.btn                  = ui_logic:LMakeGameButton(box_path)
                box.img_receive          = ui_logic:LMakeGameImage(box_path .. ":baoxiangguanbi")
                box.img_already_received = ui_logic:LMakeGameImage(box_path .. ":baoxiangkaiqi")
                box.lb_num               = ui_logic:LMakeGameLabel(box_path .. ":xingxingshuliang")
                box.lb_receive           = ui_logic:LMakeGameLabel(box_path .. ":kelingqu")
                box.lb_already_received  = ui_logic:LMakeGameLabel(box_path .. ":yilingqu")

                -- init ui state
                box.btn.Visible          = true
                box.btn.Enable           = true
                box.btn.ShowEnable       = true
                box.img_receive.Visible  = true
                box.img_already_received.Visible = false
                box.lb_num.Visible       = true
                box.lb_receive.Visible   = false
                box.lb_already_received.Visible = false

                box.lb_num.Text = tostring(v.finishNum)

                -- init receive button
                local tsn = v.sn
                box.btn:RemoveAllClickCallBack()
                box.btn:AddClickCallBack(function(gameObject)
                    local msg = msg_pb.CSOpenServerFinalReward()
                    msg.sn = tsn
                    local data = msg:SerializeToString()
                    NetMgr:SendMessage(msg.protocid, data)
                end)

                openbox.boxes[v.sn] = box
                
                i = i + 1
            end
        end
    end
    
    openbox.update = function(tbl)

        local progress = 1 -- #tbl
        -- if progress > #openbox.boxes then
        --     progress = #openbox.boxes
        -- end
        
        -- k: sn, v: other values
        for k,v in pairs(tbl) do
            -- print ("current: " .. UserBackMod.datas.current_target .. " target: " .. v.target )
            local box_enable = v.target < UserBackMod.datas.current_target
            
            if box_enable then progress = progress + 1 end

            -- 如果目标达成则允许点击宝箱
            -- openbox.boxes[k].btn.Enable = box_enable

            -- 可领取但是未领
            if box_enable and not v.state then
                openbox.boxes[k].lb_receive.Visible = true
            end

            -- 已领取
            if v.state then  -- already received
                print ("already received.")
                openbox.boxes[k].btn.Enable = false
                openbox.boxes[k].lb_num.Visible = false
                openbox.boxes[k].img_receive.Visible = false
                openbox.boxes[k].img_already_received.Visible = true
                openbox.boxes[k].lb_already_received.Visible = true
            end
        end

        print ("old progress value  " .. openbox.progress_bar.Value .. "\t new value: " .. progress_value[progress])
        -- TODO: it seems the property Value cannot set progress bar.
        openbox.progress_bar.Vaule = progress_value[progress]
    end
    
    return openbox
end

function update_openbox()
    openbox_mgr = init_openbox(logic)
    openbox_mgr.init(ActivitiesMod.conf_boxes)
    openbox_mgr.update(UserBackMod.boxes)


end

function init(ui_logic)

    local tabs = {}

    local open_sn = UserBackMod.open_sn
    local openserver = {}

    -- local tab_size = ConfActivityOpenServer.GetCount()
    local tab_size = #open_sn

    for k, v in pairs(open_sn) do
        if ActivitiesMod.UserBack_datas.values[v] ~= nil then
            openserver[v] = ActivitiesMod.UserBack_datas.values[v]
        end
    end

    tile:LEnsureSize(tab_size)
    tile:Reposition()

    -- clear left_indicators
    -- left_indicators.clear()

    local idx = 0
    for k, v in pairs(openserver) do
        local tab = ui_logic:LMakeGameCheckBox(tab_tile_path .. ":" .. grid_item_start .. idx)
        if (tab ~= nil) then
            tab.sn   = v.sn
            tab.name = tab:LMakeGameLabel("putong:Background:Label")

            local indicator = tab:LMakeGameUIComponent("putong:numkuang")
            left_indicators.add_indicator(tab.sn, indicator)

            if (tab.name ~= nil)  then tab.name.Text = v.text    end
            if (indicator ~= nil) then indicator.Visible = false end

            tab:RemoveAllClickCallBack()
            local t_idx = idx + 1
            tab:AddClickCallBack(function(gameObject)
                local activiteis = v.subActivitySn
                left_indicators.set_visible(tab.sn, false)
                prev_tab_idx = t_idx
                tabs.update_subtabs(activiteis, t_idx)
            end)

            table.insert(tabs, tab)
        end

        idx = idx + 1
    end

    tabs.update_subtabs = function(activiteis, tab_idx)

        local subtabs = {}

        if type(activiteis) ~= "table" then
            print ("parameter is not a table.")
        else
            for k, v in pairs(subtabs)do
                for ki, vi in pairs(subtabs[k]) do
                    subtabs[k][ki] = nil
                end
            end

            local size = #activiteis
            -- filter activities size
            for k,v in pairs(activiteis) do
                if ActivitiesMod.activities_general_datas.get(v) == nil then
                    size = size - 1
                end
            end

            -- There are extra 2 pairs.
            size = size + 2

            subtab_tile:Clear()
            subtab_tile:LEnsureSize(size)
            subtab_tile:Reposition()

            -- clear right_top_indicators
            right_top_indicators.clear()

            if size ~= 0 then
                local idx = 0
                for k, v in pairs(activiteis) do
                    if type(v) == "number" then
                        local conf = ActivitiesMod.activities_general_datas.get(v)
                        if conf ~= nil then
                            local subtab_path = subtab_tile_path .. ":" .. grid_item_start .. idx
                            local subtab      = {}
                            subtab.checkbox   = ui_logic:LMakeGameCheckBox(subtab_path)
                            subtab.checkbox.Checked = false
                            if subtab ~= nil then
                                subtab.sn   = v
                                subtab.name = subtab.checkbox:LMakeGameLabel("Background:Label")
                                
                                local indicator = subtab.checkbox:LMakeGameUIComponent("numkuang")
                                right_top_indicators.add_indicator(subtab.sn, indicator)

                                if subtab.name ~= nil then subtab.name.Text = conf.activeTitle end
                                if indicator   ~= nil then indicator.Visible = false end

                                local label = subtab.checkbox:LMakeGameLabel("Background:Checkmark:Label")
                                if label ~= nil then label.Text = conf.activeTitle end

                                local t_idx = idx + 1
                                local t_v = v
                                subtab.checkbox:RemoveAllClickCallBack()
                                subtab.checkbox:AddClickCallBack(function(gameObject)
                                    if prev_subtab_idx[tab_idx] ~= t_idx then
                                        prev_subtab_idx[tab_idx] = t_idx
                                        right_top_indicators.set_visible(subtab.sn, false)
                                        local goals = ActivitiesMod.activities_general_datas.get(t_v).activegoal
                                        tabs.update_items(goals)
                                    end
                                end)

                                table.insert( subtabs, subtab )

                                idx = idx + 1
                            else
                                print ("total size: " .. #activiteis .. "subtab: " .. conf.activeTitle .. " is null")
                            end
                        else
                            print (v .. "Conf ActiveGeneral is null")
                        end
                    end

                end

                if prev_subtab_idx[tab_idx] == nil then
                    prev_subtab_idx[tab_idx] = 1
                end

                -- Display the first subtab after init.
                subtabs[prev_subtab_idx[tab_idx]].checkbox.Checked = true
                local goals = ActivitiesMod.activities_general_datas.get(subtabs[prev_subtab_idx[tab_idx]].sn).activegoal
                tabs.update_items(goals)
            end
        end
    end

    tabs.update_items = function(goals)

        if type(goals) ~= "table" then
            print ("goals is not table.")
        else
            item_tile:Clear()
            item_tile:LEnsureSize(#goals)

            local idx = 0
            for k, v in pairs(goals) do
                -- local conf_goal = ConfActiveGoal.Get(v)
                if v.sn ~= nil and type(v.sn) == "number" then
                    local item_path = item_tile_path .. ":" .. grid_item_start .. idx
                    local container = ui_logic:LMakeGameUIComponent(item_path)
                    
                    local is_get  = false --是否领取, 已领取按钮不可见, 未领取可见不可按
                    local can_get = false --是否可领取
                    if container ~= nil then
                        if UserBackMod.achieved_goals[v.sn] ~= nil then
                            if UserBackMod.achieved_goals[v.sn] then
                                is_get = false
                                can_get = true
                            else
                                is_get = true
                            end
                        end

                        local item = tabs.create_item(item_path, v)
                        item.update_btn(is_get, can_get)
                        idx = idx + 1
                    end
                end
            end
        end
    end

    tabs.create_item = function(root_path, data)

        local item = {}

        item.title   = logic:LMakeGameLabel(root_path .. ":jiangli:biaoti")
        item.rewards = logic:LMakeGameTile(root_path .. ":jiangli:tItem")
        item.get     = logic:LMakeGameButton(root_path .. ":jiangli:button-lingqu")

        item.rewards:Clear()

        if data.items ~= nil then
            item.rewards:LEnsureSize(#data.items)
            item.rewards:Reposition()

            local idx = 0
            for k,v in pairs(data.items) do
                if v.sn ~= nil and type(v.sn) == "number" then
                    local reward_path = root_path .. ":jiangli:tItem:" .. grid_item_start .. idx
                    local conf_item = ConfItem.Get(v.sn)

                    if conf_item ~= nil then
                        local reward_item = tabs.create_reward_item(logic, reward_path, ConfItem.Get(v.sn), v.num)
                        reward_item.set_visible(true)

                        idx = idx + 1
                    end
                end
            end
        end

        -- add click callback
        item.get:RemoveAllClickCallBack()
        item.get:AddClickCallBack( function(gameObject)
            local msg = msg_pb.CSActivityReward()
            msg.activityGoalSN = data.sn
            msg.activitySN = data.activeSN

            local data = msg:SerializeToString()
            NetMgr:SendMessage(msg.protocid, data)
        end)

        item.update_btn = function( ig, cg )
            item.get.Visible = not ig
            item.get.Enable = cg
            item.get.ShowEnable = cg
        end

        -- title handler

        local t1 = tonumber(data.target1)
        local t2 = tonumber(data.target2)

        if data.activeSN == 1000 then
            local title = System.String.Format(" ({0}/{1})", PlayerMgr.HeroInfo.level, t1)
            item.title.Text = System.String.Format(data.activeGoalContent, "", title)
        -- elseif add other sn.
        else
            item.title.Text = System.String.Format(data.activeGoalContent, "", "", "")
        end
        -- end title handler

        return item
    end

    tabs.create_reward_item = function(logic, item_path, data, num)

        local reward_item = {}

        reward_item.go   = logic:LMakeGameUIComponent(item_path)
        reward_item.icon = logic:LMakeGameImage(item_path .. ":itemtubiao")
        reward_item.num  = logic:LMakeGameLabel(item_path .. ":num")

        -- reward_item.voitem = GOEGame.VOItem.New(data, num)

        reward_item.icon.Sprite   = data.iconId
        reward_item.num.Text      = num

        reward_item.set_visible = function(val)
            reward_item.go.Visible = val
        end

        return reward_item
    end

    return tabs
end

function view_update_red_tips(proto)

    print ("--- UserBackView update red tips ---")

    local msg = msg_pb.SCOpenServerRredActivity()
    msg:ParseFromString(proto)

    print ("red size: " .. #msg.redActivity .. " redsub size: " .. #msg.redSubActivity)

    UserBackMod.update_red_tips_base(msg.redActivity, msg.redSubActivity)

    for k,v in pairs(msg.redActivity) do
        if type(v) == "number" then
            left_indicators.set_visible(v, true)
        end
    end

    for k,v in pairs(msg.redSubActivity) do
        if v.sn ~= nil and type(v.sn) == "number" then
            print ("right_top_indicators k: " .. v.sn )
            right_top_indicators.set_visible(v.sn, true)
        end
    end

    UserBackMod.update_callback()
end

function update_tips()

    left_indicators.show()
    right_top_indicators.show()
end

function update_current_tabs()

    tabs = init(logic)
    if #tabs ~= 0 then
        -- local activiteis = ConfActivityOpenServer.Get(tabs[prev_tab_idx].sn).subActivitySn
        local activiteis = ActivitiesMod.UserBack_datas.get(tabs[prev_tab_idx].sn).subActivitySn
        tabs.update_subtabs(activiteis, prev_tab_idx)
        update_tips()
    end
    
    update_openbox()
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
    show_rewards_panel(msg.produce)
end

function show_rewards_panel(reward_datas)

    local rewards = {}

    local datas = nil

    if type(reward_datas) ~= "table" then
        datas = {}
        table.insert(datas, reward_datas) 
    else
        datas = reward_datas
        for k,v in pairs(datas) do
            local item = ConfItem.Get(v.sn)
            if item ~= nil then
                rewards[item.iconId] = v.num
            end
        end
    end

    print("rewards size: " .. #rewards )

    local rewards_view = require(UINames.UI_Rewards._logic)
    rewards_view.set_rewards(rewards)

    OpenUIFrame(UINames.UI_Rewards._name)
end

UserBackView.Commit()
return UserBackView
