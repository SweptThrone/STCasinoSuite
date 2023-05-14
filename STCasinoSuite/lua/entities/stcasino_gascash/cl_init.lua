include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
		
	local txt = "Gas Money"
	local moneyDisp = self:GetNWInt("curval") .. " | " .. self:GetNWInt("randval")
	local winnerDisp = "None"
	if IsValid(self:GetNWEntity("curwin")) then
		winnerDisp = self:GetNWEntity("curwin"):Name()
	else
		winnerDisp = "None"
	end
	local winningsDisp = "$" .. self:GetNWInt("winnings")
	
	surface.SetFont("Trebuchet24")
	local TextWidth = surface.GetTextSize(txt)
	surface.SetFont("DermaLarge")
	local TextWidth2 = surface.GetTextSize(moneyDisp)
	surface.SetFont("Trebuchet24")
	local TextWidth5 = surface.GetTextSize(winnerDisp)
	local TextWidth6 = surface.GetTextSize(winningsDisp)
	surface.SetFont("CloseCaption_Normal")
	local TextWidth3 = surface.GetTextSize("GUESS | TARGET")
	local TextWidth4 = surface.GetTextSize("CURRENT WIN")
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 11 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth*0.5 -4, -110, txt, "Trebuchet24", Color(0, 0, 0, 100), Color(255,255,128,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 9.25 - Ang:Right() * 15, Ang, 0.16)
		surface.SetDrawColor(0,0,0,255)
		surface.DrawRect( -90, -270, 182, 150 )
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 9.5 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth2*0.5, -165, moneyDisp, "DermaLarge", Color(0, 0, 0, 0), Color(255,255,255,255))
		draw.WordBox(4, -TextWidth3*0.5 - 4, -190, "GUESS | TARGET", "CloseCaption_Normal", Color(0, 0, 0, 0), Color(255,255,255,255))
		
		draw.WordBox(4, -TextWidth5*0.5, -240, winnerDisp, "Trebuchet24", Color(0, 0, 0, 0), Color(255,255,255,255))
		draw.WordBox(4, -TextWidth6*0.5, -220, winningsDisp, "Trebuchet24", Color(0, 0, 0, 0), Color(255,255,255,255))
		draw.WordBox(4, -TextWidth4*0.5 - 4, -260, "CURRENT WIN", "CloseCaption_Normal", Color(0, 0, 0, 0), Color(255,255,255,255))
	cam.End3D2D()
end
