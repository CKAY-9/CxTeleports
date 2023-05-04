CXTP.Teleports = {}

game.AddParticles("particles/vortigaunt_fx.pcf")
PrecacheParticleSystem("vortigaunt_charge_token_b")

-- Networking]
util.AddNetworkString("openCxTeleports")
util.AddNetworkString("openAdmin")
util.AddNetworkString("createNewLocation")
util.AddNetworkString("teleportPlayer")
util.AddNetworkString("closeTeleports")
util.AddNetworkString("deleteTeleport")

net.Receive("deleteTeleport", function()
    local key = net.ReadString()
    local ply = net.ReadEntity()

    if (CXTP.Teleports[key] == nil) then
        return
    end
    if (not ply:IsAdmin()) then
        print("[CXTeleports] " .. ply:GetName() .. " attemped to delete location without admin permissions!")
        return
    end

    CXTP.Teleports[key] = nil
    net.Start("openAdmin")
    if (CXTP.Teleports == nil) then
        CXTP.Teleports = {}
    end
    net.WriteTable(CXTP.Teleports)
    net.Send(ply)
end)

net.Receive("createNewLocation", function()
    local ply = net.ReadEntity()
    local location = net.ReadTable()
    local name = net.ReadString()
    local desc = net.ReadString()
    local cost = net.ReadInt(32)

    if (not ply:IsAdmin()) then
        print("[CXTeleports] " .. ply:GetName() .. " attemped to create location without admin permissions!")
        return
    end

    CXTP.Teleports[name] = {
        name = name,
        location = location,
        desc = desc,
        cost = cost,
    }

    file.Write("cxtp/teleports.json", util.TableToJSON(CXTP.Teleports))

    net.Start("openAdmin")
    if (CXTP.Teleports == nil) then
        CXTP.Teleports = {}
    end
    net.WriteTable(CXTP.Teleports)
    net.Send(ply)
end)

net.Receive("teleportPlayer", function()
    local ply = net.ReadEntity()
    local key = net.ReadString()

    if (key == nil or CXTP.Teleports[key] == nil) then
        return
    end

    local tp = CXTP.Teleports[key]

    if (ply:getDarkRPVar("money") < tp["cost"]) then
        return
    end

    ply:Freeze(true)
    ply:addMoney(-tp["cost"])

    net.Start("closeTeleports")
    net.Send(ply)

    hook.Add("Think", "CxTP.TrackPlayerParticle", function()
        ParticleEffect("vortigaunt_charge_token_b", ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Spine")), Angle( 0, 0, 0 ), ply)
    end)

    timer.Simple(3.4, function()
        ply:EmitSound("beams/beamstart5.wav")
        hook.Remove("Think", "CxTP.TrackPlayerParticle")
    end)

    timer.Simple(3.5, function()
        ply:Freeze(false)
        ply:SetPos(Vector(tp["location"][1], tp["location"][2], tp["location"][3]))
        ply:StopParticles()
    end)
end)

net.Receive("openAdmin", function()
    local ply = net.ReadEntity()
    if (not ply:IsAdmin()) then
        print("[CXTeleports] " .. ply:GetName() .. " attemped to open admin panel without admin permissions!")
        return
    end

    net.Start("openAdmin")
    if (CXTP.Teleports == nil) then
        CXTP.Teleports = {}
    end
    net.WriteTable(CXTP.Teleports)
    net.Send(ply)
end)

net.Receive("openCxTeleports", function()
    local ply = net.ReadEntity()

    net.Start("openCxTeleports")
    if (CXTP.Teleports == nil) then
        CXTP.Teleports = {}
    end
    net.WriteTable(CXTP.Teleports)
    net.Send(ply)
end)

-- Data
if (not file.Exists("cxtp/teleports.json", "DATA")) then
    file.CreateDir("cxtp")
    file.Write("cxtp/teleports.json", util.TableToJSON({}, true))
    print("[CXTeleports] Created CXTeleports data files!")
end

CXTP.FileData = file.Read("cxtp/teleports.json", "DATA")
CXTP.Teleports = util.JSONToTable(CXTP.FileData)