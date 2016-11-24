--所有ui组件的基类
local JOWBaseComponent = Lplus.Extend(require "game/JOWUIFun","JOWBaseComponent")
local def = JOWBaseComponent.define

def.method("userdata").OnBeforeInit = function (self,component)
    self.LuaComponent = component
    self.LuaUILogic = component.LuaLogicHandler
end

def.virtual("dynamic").OnShow = function (self,obj)
end

def.method("boolean").SetVisible = function (self,b)
    if self.LuaComponent ~= nil then
        self.LuaComponent:SetVisible(b)
    else
        print("err LuaComponent")
    end
end

def.method("=>","boolean").GetVisible = function (self)
    if self.LuaComponent ~= nil then
        return self.LuaComponent:GetVisible()
    end
    print("err LuaComponent")
end

--def.method("function","string","=>","table").MakeLuaComponent = function (self,tableFun,path)
--    if self.LuaUILogic ~= nil and tableFun ~= nil then
--       tableComponet = tableFun()
--       local component = self.LuaUILogic:LMakeLuaComponent(tableComponet,path)
--       if component ~= nil then
--         return tableComponet
--       end
--    end
--    return nil
--end


--def.method("string","string","=>","userdata").MakeComponet = function (self,cname,path)
--    if self.LuaUILogic ~= nil and tableFun ~= nil then
--       component = self.LuaUILogic:LMake(cname,path)
--       if component ~= nil then
--         return component
--       end
--    end
--    return nil
--end

def.virtual().OnInit = function (self)
end

def.virtual().OnHide = function(self)
end

def.virtual().OnUpdate = function(self)
end

def.virtual().OnDispose = function(self)
end


def.override("=>","string").GetName = function (self)
  return "JOWBaseComponent"
end

JOWBaseComponent.Commit()
return JOWBaseComponent