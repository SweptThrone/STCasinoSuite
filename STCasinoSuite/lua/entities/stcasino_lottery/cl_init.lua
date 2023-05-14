include('shared.lua')

function ENT:Initialize()

end

function ENT:Draw()
	
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
	
	local txt = "Lottery Machine | $" .. self:GetNWInt("lottoprice")
	surface.SetFont("Trebuchet24") --i know
	local TextWidth = surface.GetTextSize(txt)
	local lottery = "$" .. self:GetNWInt("currentlotto")
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 33.25 - Ang:Right() * 15, Angle(Ang.p, Ang.y, Ang.r - 47), 0.16)
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( -62, -305, 98, 50 ) --covers bottom panel
		draw.SimpleText(lottery, "Trebuchet18", -55, -287)
	cam.End3D2D()

	cam.Start3D2D(Pos + Ang:Up() * -3 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth * 0.5, -260, txt, "Trebuchet24", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
end
