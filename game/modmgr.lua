-- region *.lua
-- Date
-- 此文件由[BabeLua]插件自动生成
require("game/JOWModle")
ModMgr = { }
local mods = { }
local adding = {}
local removing = {}
function ModMgr.InitMods()
    mods[#mods + 1] = require("game/datamod/datamod")();
    -- mods[#mods + 1] = require("game/testmod/testmod")();
    mods[#mods + 1] = require("game/ActivitiesMod/ActivitiesMod")();
    mods[#mods + 1] = require("game/CarnivalMod/CarnivalMod")();
    -- mods[#mods + 1] = require("game/MainUIMod/MainUIMod")();
    -- mods[#mods + 1] = require("game/EmbattleUI/EmbattleUIMod");
end
function ModMgr.Start()
     for i = 1, #mods do
        mods[i]:Start()
    end
end

local bupdate = false;
function ModMgr.Update()
    bupdate = true;
    for i = 1, #mods do
       if mods[i]:GetEnable() then
          mods[i]:Update()
       end
    end

    bupdate = false;
    for i = 1, #removing do 
        ModMgr.RemoveMod(removing[i])
    end
    removing = {}

    for i = 1, #adding do 
        mods[#mods + 1] = adding[i]
    end
    adding = {}

end

function ModMgr.AddMod(modstr)
    if bupdate then
        adding[#adding + 1] = modstr
    else
        mods[#mods + 1] = modstr
    end
end

function ModMgr.RemoveMod(mod)
    if bupdate then
        removing[#removing + 1] = mods
    else
        for i = 1, #mods do
            if mods[i] == mod then
                table.remove(mods, i)
                mod:Dispose()
                break
            end
        end
    end
end

function ModMgr.DisposeMods()
    for i = 1, #mods do
        mods[i]:Dispose()
    end
    mods = {}
end

ModMgr.Modules = mods
return ModMgr
-- endregion
