include("shared.lua")

local yAddition = 0
local yPositive = true

function ENT:Draw()
    self:DrawModel()

    if (yPositive) then
        yAddition = Lerp(2 * FrameTime(), yAddition, -11)
        if (yAddition <= -10) then
            yPositive = false
        end
    else
        yAddition = Lerp(2 * FrameTime(), yAddition, 1)
        if (yAddition >= 0) then
            yPositive = true
        end
    end

    local ang = self:GetAngles()
    ang:RotateAroundAxis(self:GetAngles():Right(), 270)
    ang:RotateAroundAxis(self:GetAngles():Forward(), 90)

    local pos = self:GetPos()

    cam.Start3D2D(pos, ang, 0.25)

    draw.RoundedBox(0, -75, -265 + yAddition, 150, 50, Color(CXTP.Theme.background.r, CXTP.Theme.background.g, CXTP.Theme.background.b, 200))
    draw.DrawText("TELEPORTER", "CxTP.Bold", 0, -250 + yAddition, CXTP.Theme.text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    cam.End3D2D()
end