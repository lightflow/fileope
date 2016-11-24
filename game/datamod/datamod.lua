local JOWModle = require("game/JOWModle")
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
