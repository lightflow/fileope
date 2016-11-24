SceneMod = Lplus.Extend(require("game/JOWModle"),"SceneMod")
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
return SceneMod