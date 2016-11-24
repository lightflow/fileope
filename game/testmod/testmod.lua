local testmod = Lplus.Extend(require "game/JOWModle","testmod")
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
return testmod