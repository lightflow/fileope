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
]]