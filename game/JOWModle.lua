local JOWModle = Lplus.Class("JOWModle")
local def = JOWModle.define
local _enable = true;

def.virtual().Start = function (self)
end

def.virtual().Dispose = function (self)
end

def.virtual().OnStateChange = function(self)
end

def.virtual().Update = function(self)
end

def.virtual("=>","boolean").GetEnable = function(self)
    return _enable
end

def.virtual("boolean").SetEnable = function(self,b)
    _enable = b
end

def.virtual("=>","string").GetName=function (self)
  return "JOWModle"
end

JOWModle.Commit()
return JOWModle