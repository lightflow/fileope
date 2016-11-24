--[[
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
return OpeningFundRewardItem