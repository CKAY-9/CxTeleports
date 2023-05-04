if SERVER then
    include("tp_config.lua")
    include("sv_teleport.lua")

    AddCSLuaFile("cl_teleport.lua")
    AddCSLuaFile("tp_config.lua")

    resource.AddFile("resources/fonts/OpenSans-ExtraBold.ttf")
    resource.AddFile("resources/fonts/OpenSans-Regular.ttf")
    resource.AddFile("resources/fonts/OpenSans-SemiBold.ttf")

    print("[CXTeleports] Started CxTeleport")
else
    include("tp_config.lua")
    include("cl_teleport.lua")
end