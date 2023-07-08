game.AddParticles("particles/vortigaunt_fx.pcf")
PrecacheParticleSystem("vortigaunt_charge_token_b")

local scrw, scrh = ScrW(), ScrH()
local pw, ph = scrw * 0.35, scrh * 0.65
local transparent = Color(0, 0, 0, 0)

surface.CreateFont("CxTP.Small", {
    font = "Inter Regular",
    extended = false,
    size = ScrW() * 0.008,
    antialias = true
})

surface.CreateFont("CxTP.Regular", {
    font = "Inter Regular",
    extended = false,
    size = ScrW() * 0.014,
    antialias = true
})

surface.CreateFont("CxTP.Med", {
    font = "Inter Bold",
    extended = false,
    size = ScrW() * 0.014,
    antialias = true
})

surface.CreateFont("CxTP.Bold", {
    font = "Inter Black",
    extended = false,
    size = ScrW() * 0.014,
    antialias = true
})

CXTP.OpenAdmin = function()
    local tps = net.ReadTable()
    local ply = LocalPlayer()

    if (not ply:IsAdmin()) then
        if (IsValid(CXTP.Menu)) then
            CXTP.Menu:Remove()
        end
        return
    end

    if (IsValid(CXTP.Menu)) then
        CXTP.Menu:Remove()
    end

    CXTP.Menu = vgui.Create("DFrame")
    CXTP.Menu:SetSize(pw, ph)
    CXTP.Menu:MakePopup(true)
    CXTP.Menu:Center()
    CXTP.Menu:SetTitle("")
    CXTP.Menu:SetDraggable(false)
    CXTP.Menu:ShowCloseButton(false)

    CXTP.Menu.Paint = function(self, w, h)
        draw.RoundedBox(15, 0, 0, w, h, CXTP.Theme.background)
    end

    CXTP.Header = vgui.Create("DPanel", CXTP.Menu)
    CXTP.Header:SetPos(0, 0)
    CXTP.Header:SetSize(pw, ph * 0.075)

    CXTP.Header.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, CXTP.Theme.foreground)
        draw.SimpleText("CxTeleports Admin Menu", "CxTP.Bold", w * 0.025, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    CXTP.Close = vgui.Create("DButton", CXTP.Header)
    CXTP.Close:Dock(RIGHT)
    CXTP.Close:SetSize(pw * 0.1, ph * 0.075)
    CXTP.Close:SetText("")

    CXTP.Close.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, 0, 0, transparent)
        draw.SimpleText("X", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CXTP.Close.DoClick = function()
        if (IsValid(CXTP.Menu)) then
            CXTP.Menu:Remove()
        end
    end

    CXTP.OpenMenu = vgui.Create("DButton", CXTP.Header)
    CXTP.OpenMenu:Dock(RIGHT)
    CXTP.OpenMenu:DockMargin(0, 0, 10, 0)
    CXTP.OpenMenu:SetSize(pw * 0.2, ph * 0.075)
    CXTP.OpenMenu:SetText("")

    CXTP.OpenMenu.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, CXTP.Theme.accent)
        draw.SimpleText("Back", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CXTP.OpenMenu.DoClick = function()
        net.Start("openCxTeleports")
        net.WriteEntity(ply)
        net.SendToServer()
    end

    if (table.Count(tps) <= 0) then
        CXTP.NoTPs = vgui.Create("DPanel", CXTP.Menu)
        CXTP.NoTPs:SetSize(pw * 0.7, ph * 0.1)
        CXTP.NoTPs:Dock(TOP)
        CXTP.NoTPs:DockMargin(pw * 0.15, 10, pw * 0.15, 10)

        CXTP.NoTPs.Paint = function(self, w, h)
            draw.SimpleText("There are no TP locations set!", "CxTP.Med", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    else
        CXTP.ExistingLocationsLabel = vgui.Create("DPanel", CXTP.Menu)
        CXTP.ExistingLocationsLabel:SetSize(pw * 0.7, ph * 0.05)
        CXTP.ExistingLocationsLabel:Dock(TOP)
        CXTP.ExistingLocationsLabel:DockMargin(pw * 0.15, ph * 0.05, pw * 0.15, 10)

        CXTP.ExistingLocationsLabel.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, 0, 0, transparent)
            draw.SimpleText("Click to delete teleport", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        CXTP.TeleportsList = vgui.Create("DScrollPanel", CXTP.Menu)
        CXTP.TeleportsList:SetSize(pw * 0.7, ph * 0.3)
        CXTP.TeleportsList:Dock(TOP)
        CXTP.TeleportsList:DockMargin(pw * 0.15, 10, pw * 0.15, 10)

        CXTP.TeleportsList.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, CXTP.Theme.foreground)
        end

        for k, v in pairs(tps) do
            local TPLocation = vgui.Create("DButton", CXTP.TeleportsList)
            TPLocation:Dock(TOP)
            TPLocation:SetText("")
            TPLocation:DockMargin(10, 10, 10, 10)
            TPLocation:SetSize(pw * 0.65, ph * 0.15)

            TPLocation.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, CXTP.Theme.accent)
                draw.SimpleText(v["name"], "CxTP.Regular", w * 0.5, h * 0.25, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(v["desc"], "CxTP.Regular", w * 0.5, h * 0.50, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                if (ply.isArrested ~= nil and v["cost"] > 0) then
                    draw.SimpleText("Cost: $" .. v["cost"], "CxTP.Regular", w * 0.5, h * 0.75, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            TPLocation.DoClick = function()
                if (not ply:IsAdmin()) then return end

                net.Start("deleteTeleport")
                net.WriteString(k)
                net.WriteEntity(ply)
                net.SendToServer()
            end
        end
    end

    -- New Location
    CXTP.NewLocationLabel = vgui.Create("DPanel", CXTP.Menu)
    CXTP.NewLocationLabel:SetSize(pw * 0.7, ph * 0.1)
    CXTP.NewLocationLabel:Dock(TOP)
    CXTP.NewLocationLabel:DockMargin(pw * 0.05, 10, pw * 0.05, 5)

    CXTP.NewLocationLabel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, 0, 0, transparent)
        draw.SimpleText("New TP Location", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CXTP.NewLocationCreation = vgui.Create("DScrollPanel", CXTP.Menu)
    CXTP.NewLocationCreation:Dock(FILL)
    CXTP.NewLocationCreation:DockMargin(pw * 0.15, 0, pw * 0.15, 10)

    CXTP.NewLocationCreation.Paint = function(self, w, h)
        draw.RoundedBox(10, 0, 0, w, h, CXTP.Theme.foreground)
    end

    -- Location name
    CXTP.NewNameLabel = vgui.Create("DLabel", CXTP.NewLocationCreation)
    CXTP.NewNameLabel:SetText("Location Name")
    CXTP.NewNameLabel:SetFont("CxTP.Small")
    CXTP.NewNameLabel:SetColor(CXTP.Theme.text)
    CXTP.NewNameLabel:Dock(TOP)
    CXTP.NewNameLabel:DockMargin(10, 5, 10, 0)

    CXTP.LocationName = ""
    CXTP.NewLocationName = vgui.Create("DTextEntry", CXTP.NewLocationCreation)
    CXTP.NewLocationName:Dock(TOP)
    CXTP.NewLocationName:SetPlaceholderText("Location Name")
    CXTP.NewLocationName:DockMargin(10, 5, 10, 0)
    CXTP.NewLocationName.OnTextChanged = function(self)
        CXTP.LocationName = self:GetValue()
    end

    -- Description
    CXTP.NewDescLabel = vgui.Create("DLabel", CXTP.NewLocationCreation)
    CXTP.NewDescLabel:SetText("Location Description")
    CXTP.NewDescLabel:SetFont("CxTP.Small")
    CXTP.NewDescLabel:SetColor(CXTP.Theme.text)
    CXTP.NewDescLabel:Dock(TOP)
    CXTP.NewDescLabel:DockMargin(10, 5, 10, 0)

    CXTP.Description = ""
    CXTP.NewDesc = vgui.Create("DTextEntry", CXTP.NewLocationCreation)
    CXTP.NewDesc:Dock(TOP)
    CXTP.NewDesc:SetPlaceholderText("Location Description")
    CXTP.NewDesc:DockMargin(10, 5, 10, 0)
    CXTP.NewDesc.OnTextChanged = function(self)
        CXTP.Description = self:GetValue()
    end

    -- Coords
    CXTP.CoordsLabel = vgui.Create("DLabel", CXTP.NewLocationCreation)
    CXTP.CoordsLabel:SetText("Location Coordinates (To manually enter coords, do getpos in console)")
    CXTP.CoordsLabel:SetFont("CxTP.Small")
    CXTP.CoordsLabel:SetColor(CXTP.Theme.text)
    CXTP.CoordsLabel:Dock(TOP)
    CXTP.CoordsLabel:DockMargin(10, 5, 10, 0)

    CXTP.CoordsPanel = vgui.Create("DPanel", CXTP.NewLocationCreation)
    CXTP.CoordsPanel:Dock(TOP)
    CXTP.CoordsPanel:DockMargin(10, 5, 10, 0)

    CXTP.CoordsPanel.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, 0, 0, transparent)
    end

    CXTP.CoordX = nil
    CXTP.CoordY = nil
    CXTP.CoordZ = nil
    CXTP.Location = {0, 0, 0}

    CXTP.CoordsAutoGet = vgui.Create("DButton", CXTP.CoordsPanel)
    CXTP.CoordsAutoGet:SetText("Get Current")
    CXTP.CoordsAutoGet:Dock(LEFT)
    CXTP.CoordsAutoGet:DockMargin(10, 5, 10, 5)

    CXTP.CoordsAutoGet.DoClick = function()
        CXTP.Location = {ply:GetPos()[1], ply:GetPos()[2], ply:GetPos()[3]}
        CXTP.CoordX:SetValue(CXTP.Location[1])
        CXTP.CoordY:SetValue(CXTP.Location[2])
        CXTP.CoordZ:SetValue(CXTP.Location[3])
    end

    CXTP.CoordX = vgui.Create("DNumberWang", CXTP.CoordsPanel)
    CXTP.CoordX:Dock(LEFT)
    CXTP.CoordX:DockMargin(10, 5, 10, 5)
    CXTP.CoordX:SetMin(-2147483648)
    CXTP.CoordX:SetMax(2147483647)
    CXTP.CoordX.OnValueChanged = function(self)
        CXTP.Location[1] = self:GetValue()
    end

    CXTP.CoordY = vgui.Create("DNumberWang", CXTP.CoordsPanel)
    CXTP.CoordY:Dock(LEFT)
    CXTP.CoordY:DockMargin(10, 5, 10, 5)
    CXTP.CoordY:SetMin(-2147483648)
    CXTP.CoordY:SetMax(2147483647)
    CXTP.CoordY.OnValueChanged = function(self)
        CXTP.Location[2] = self:GetValue()
    end

    CXTP.CoordZ = vgui.Create("DNumberWang", CXTP.CoordsPanel)
    CXTP.CoordZ:Dock(LEFT)
    CXTP.CoordZ:DockMargin(10, 5, 10, 5)
    CXTP.CoordZ:SetMin(-2147483648)
    CXTP.CoordZ:SetMax(2147483647)

    CXTP.CoordZ.OnValueChanged = function(self)
        CXTP.Location[3] = self:GetValue()
    end

    -- DarkRP implementation
    CXTP.MoneyAmount = 0
    if (ply.isArrested ~= nil) then
        CXTP.MoneyAmountLabel = vgui.Create("DLabel", CXTP.NewLocationCreation)
        CXTP.MoneyAmountLabel:SetText("DarkRP Cost")
        CXTP.MoneyAmountLabel:SetFont("CxTP.Small")
        CXTP.MoneyAmountLabel:SetColor(CXTP.Theme.text)
        CXTP.MoneyAmountLabel:Dock(TOP)
        CXTP.MoneyAmountLabel:DockMargin(10, 5, 10, 0)

        CXTP.MoneyAmountInput = vgui.Create("DNumberWang", CXTP.NewLocationCreation)
        CXTP.MoneyAmountInput:Dock(TOP)
        CXTP.MoneyAmountInput:SetPlaceholderText("")
        CXTP.MoneyAmountInput:DockMargin(10, 5, 10, 5)
        CXTP.MoneyAmountInput:SetMin(0)
        CXTP.MoneyAmountInput:SetMax(2147483647)
        CXTP.MoneyAmountInput.OnValueChanged = function(self)
            CXTP.MoneyAmount = self:GetValue()
        end
    end

    CXTP.CreateNewButton = vgui.Create("DButton", CXTP.NewLocationCreation)
    CXTP.CreateNewButton:Dock(TOP)
    CXTP.CreateNewButton:DockMargin(10, 15, 10, 15)
    CXTP.CreateNewButton:SetText("")

    CXTP.CreateNewButton.Paint = function(self, w, h)
        draw.SimpleText("Create", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CXTP.CreateNewButton.DoClick = function()
        if (not ply:IsAdmin()) then return end

        if (string.len(CXTP.LocationName) <= 0) then
            notification.AddLegacy("Location Name Not Set!", NOTIFY_ERROR, 1)
            surface.PlaySound( "buttons/button10.wav" )
            return
        end

        net.Start("createNewLocation")
        net.WriteEntity(ply)
        net.WriteTable(CXTP.Location)
        net.WriteString(CXTP.LocationName)
        net.WriteString(CXTP.Description)
        net.WriteInt(CXTP.MoneyAmount, 32)
        net.SendToServer()
    end
end

CXTP.OpenTPs = function()
    local tps = net.ReadTable()
    local ply = LocalPlayer()

    if (IsValid(CXTP.Menu)) then
        CXTP.Menu:Remove()
    end

    CXTP.Menu = vgui.Create("DFrame")
    CXTP.Menu:SetSize(pw, ph)
    CXTP.Menu:MakePopup(true)
    CXTP.Menu:Center()
    CXTP.Menu:SetTitle("")
    CXTP.Menu:SetDraggable(false)
    CXTP.Menu:ShowCloseButton(false)

    CXTP.Menu.Paint = function(self, w, h)
        draw.RoundedBox(15, 0, 0, w, h, CXTP.Theme.background)
    end

    CXTP.Header = vgui.Create("DPanel", CXTP.Menu)
    CXTP.Header:SetPos(0, 0)
    CXTP.Header:SetSize(pw, ph * 0.075)

    CXTP.Header.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, w, h, CXTP.Theme.foreground)
        draw.SimpleText("Teleporter", "CxTP.Bold", w * 0.025, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end

    CXTP.Close = vgui.Create("DButton", CXTP.Header)
    CXTP.Close:Dock(RIGHT)
    CXTP.Close:SetSize(pw * 0.1, ph * 0.075)
    CXTP.Close:SetText("")

    CXTP.Close.Paint = function(self, w, h)
        draw.RoundedBox(0, 0, 0, 0, 0, transparent)
        draw.SimpleText("X", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end

    CXTP.Close.DoClick = function()
        if (IsValid(CXTP.Menu)) then
            CXTP.Menu:Remove()
        end
    end

    if (ply:IsAdmin()) then
        CXTP.OpenAdmin = vgui.Create("DButton", CXTP.Header)
        CXTP.OpenAdmin:Dock(RIGHT)
        CXTP.OpenAdmin:DockMargin(0, 0, 10, 0)
        CXTP.OpenAdmin:SetSize(pw * 0.2, ph * 0.075)
        CXTP.OpenAdmin:SetText("")

        CXTP.OpenAdmin.Paint = function(self, w, h)
            draw.RoundedBox(0, 0, 0, w, h, CXTP.Theme.accent)
            draw.SimpleText("Admin", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        CXTP.OpenAdmin.DoClick = function()
            net.Start("openAdmin")
            net.WriteEntity(ply)
            net.SendToServer()
        end
    end

    if (table.Count(tps) <= 0) then
        CXTP.NoTPs = vgui.Create("DPanel", CXTP.Menu)
        CXTP.NoTPs:SetSize(pw * 0.7, ph * 0.2)
        CXTP.NoTPs:Dock(FILL)
        CXTP.NoTPs:DockMargin(pw * 0.15, 0, pw * 0.15, 10)

        CXTP.NoTPs.Paint = function(self, w, h)
            draw.SimpleText("There are no TP locations set!", "CxTP.Med", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end
    else
        CXTP.Title = vgui.Create("DPanel", CXTP.Menu)
        CXTP.Title:SetSize(pw * 0.7, ph * 0.05)
        CXTP.Title:Dock(TOP)
        CXTP.Title:DockMargin(pw * 0.15, ph * 0.05, pw * 0.15, 10)

        CXTP.Title.Paint = function(self, w, h)
            draw.SimpleText("Teleport Locations", "CxTP.Bold", w * 0.5, h * 0.5, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        end

        CXTP.TeleportsList = vgui.Create("DScrollPanel", CXTP.Menu)
        CXTP.TeleportsList:Dock(FILL)
        CXTP.TeleportsList:DockMargin(pw * 0.15, 10, pw * 0.15, 10)

        CXTP.TeleportsList.Paint = function(self, w, h)
            draw.RoundedBox(10, 0, 0, w, h, CXTP.Theme.foreground)
        end

        for k, v in pairs(tps) do
            local TPLocation = vgui.Create("DButton", CXTP.TeleportsList)
            TPLocation:Dock(TOP)
            TPLocation:SetText("")
            TPLocation:DockMargin(10, 10, 10, 10)
            TPLocation:SetSize(pw * 0.65, ph * 0.15)

            TPLocation.Paint = function(self, w, h)
                draw.RoundedBox(10, 0, 0, w, h, CXTP.Theme.accent)
                draw.SimpleText(v["name"], "CxTP.Regular", w * 0.5, h * 0.25, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(v["desc"], "CxTP.Regular", w * 0.5, h * 0.50, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                if (ply.isArrested ~= nil and v["cost"] > 0) then
                    draw.SimpleText("Cost: $" .. v["cost"], "CxTP.Regular", w * 0.5, h * 0.75, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                end
            end

            TPLocation.DoClick = function()
                if (ply.isArrested ~= nil and ply:getDarkRPVar("money") < v["cost"]) then
                    notification.AddLegacy("You can't afford this teleport!", NOTIFY_ERROR, 1)
                    surface.PlaySound( "buttons/button10.wav" )
                    return
                end

                net.Start("teleportPlayer")
                net.WriteEntity(ply)
                net.WriteString(k)
                net.SendToServer()
            end
        end
    end

end

net.Receive("openCxTeleports", CXTP.OpenTPs)
net.Receive("openAdmin", CXTP.OpenAdmin)
net.Receive("closeTeleports", function()
    if (IsValid(CXTP.Menu)) then
        CXTP.Menu:Remove()
    end
end)