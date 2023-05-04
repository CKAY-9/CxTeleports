if SERVER then
    include("tp_config.lua")
    include("sv_teleport.lua")

    AddCSLuaFile("cl_teleport.lua")
    AddCSLuaFile("tp_config.lua")

    print("[CXTeleports] Started CxTeleport")
    resource.AddFile("resource/fonts/Inter-Regular.ttf")
    resource.AddFile("resource/fonts/Inter-Bold.ttf")
    resource.AddFile("resource/fonts/Inter-Black.ttf")
else
    include("tp_config.lua")
    include("cl_teleport.lua")
end