--region *.lua
--Date
local JOWUIFun = Lplus.Class("JOWUIFun")
local def = JOWUIFun.define
def.field("userdata").LuaUILogic = nil
def.field("userdata").LuaComponent = nil

-- 获取自定义的lua控件
-- 参数：继承JowBaseComponet空间 控件路径
 def.method("table","string","=>","table").MakeLuaComponent = function (self,tableFun,path)
    if self.LuaUILogic ~= nil and tableFun ~= nil then
       local tableComponet = tableFun()
       local component = nil
       if self.LuaComponent ~= nil then
         component = self.LuaComponent:LMakeLuaComponent(tableComponet,path)
       else 
         component = self.LuaUILogic:LMakeLuaComponent(tableComponet,path)
       end
       if component ~= nil then
          return tableComponet
       end
    end
    return nil
end



-- 获取C#实现的控件
def.method("string","string","=>","userdata").MakeComponent = function (self,cname,path)
    if self.LuaUILogic ~= nil then
       local component = nil
       if self.LuaComponent ~= nil then
           component = self.LuaComponent:LMake(cname,path)
       else
           component = self.LuaUILogic:LMake(cname,path)
       end
       if component ~= nil then
         return component
       end
    end
    return nil
end

def.method("string","=>","userdata").MakeGameUIComponent = function (self,path)
   return self:MakeComponent("GameUIComponent",path)
end

def.method("string","=>","userdata").MakeGameLabel = function (self,path)
   return self:MakeComponent("GameLabel",path)
end

def.method("string","=>","userdata").MakeGameInputField = function (self,path)
   return self:MakeComponent("GameInputField",path)
end


def.method("string","=>","userdata").MakeGameButton = function (self,path)
   return self:MakeComponent("GameButton",path)
end

def.method("string","=>","userdata").MakeGameImage = function (self,path)
   return self:MakeComponent("GameImage",path)
end

def.method("string","=>","userdata").MakeGameUIContainer = function (self,path)
   return self:MakeComponent("GameUIContainer",path)
end

def.method("string","=>","userdata").MakeGameTextComponent = function (self,path)
   return self:MakeComponent("GameTextComponent",path)
end

def.method("string","=>","userdata").MakeGameRichText = function (self,path)
   return self:MakeComponent("GameRichText",path)
end

def.method("string","=>","userdata").MakeGameCheckBox = function (self,path)
   return self:MakeComponent("GameCheckBox",path)
end

def.method("string","=>","userdata").MakeGameTile = function (self,path)
   return self:MakeComponent("GameTile",path)
end

def.method("string","=>","userdata").MakeGameUIEffect = function (self,path)
   return self:MakeComponent("GameUIEffect",path)
end

def.method("string","=>","userdata").MakeGameProgressBar = function (self,path)
   return self:MakeComponent("GameProgressBar",path)
end

def.method("string","=>","userdata").MakeGameScrollView = function (self,path)
   return self:MakeComponent("GameScrollView",path)
end

def.method("string","=>","userdata").MakeGameActorAvatar = function (self,path)
   return self:MakeComponent("GameActorAvatar",path)
end

def.method("string", "=>", "userdata").MakeGameIndicateButton = function (self, path)
    return self:MakeComponent("GameIndicateButton", path)
end

def.method("string", "=>", "userdata").MakeGameIndicateCheckBox = function (self, path)
    return self:MakeComponent("GameIndicateCheckBox", path)
end

def.virtual("=>","string").GetName = function (self)
  return "JOWUIFun"
end
JOWUIFun.Commit()
return JOWUIFun
--endregion
