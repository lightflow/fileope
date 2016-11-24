--region ActivityView.lua
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
