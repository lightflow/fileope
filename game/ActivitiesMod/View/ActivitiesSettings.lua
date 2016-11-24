--[[
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



return activities_settings