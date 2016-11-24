
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
