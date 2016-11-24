local JOWBaseUI = Lplus.Extend(require "game/JOWUIFun","JOWBaseUI")
local def = JOWBaseUI.define

def.method("userdata").OnBeforeInit = function (self,uilogic)
    self.LuaUILogic = uilogic
end

def.virtual().OnInit = function (self)
end


def.virtual("dynamic").OnShow = function (self,obj)
end

def.virtual().OnHide = function(self)
end

def.virtual().OnBack = function(self)
end

def.virtual().OnDispose = function(self)
end

def.method("string").ResetCloseBtn = function (self, path)
    self.LuaUILogic:ResetCloseBtn(path)
end

def.override("=>","string").GetName = function (self)
  return "JOWBaseUI"
end

JOWBaseUI.Commit()
return JOWBaseUI