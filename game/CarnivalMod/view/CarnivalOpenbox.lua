--[[
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
return CarnivalOpenbox