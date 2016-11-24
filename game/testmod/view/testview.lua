local TestView = Lplus.Extend(require "game/JOWBaseUI","TestView")
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
