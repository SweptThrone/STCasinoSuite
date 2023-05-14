include('shared.lua')

ENT.fontBlue = 128

surface.CreateFont( "NameFont", {
	font = "HudHintTextSmall", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 12,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function ENT:Draw()

	self:DrawModel()
	--print(self:GetNWInt("multiplication"))
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
		
	local txt = "Coin Flips Sim"
	local firstname = "None"
	local seconname = "None"
	if IsValid(self:GetNWEntity("playerone")) then
		firstname = self:GetNWEntity("playerone"):Name()
	end
	if IsValid(self:GetNWEntity("playertwo")) then
		seconname = self:GetNWEntity("playertwo"):Name()
	end
	
	surface.SetFont("DermaLarge")
	local TextWidth = surface.GetTextSize(txt)
	surface.SetFont("NameFont")
	local FNWid = surface.GetTextSize(firstname)
	local SNWid = surface.GetTextSize(seconname)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 17 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(8, -TextWidth*0.5 - 8, -435, txt, "DermaLarge", Color(0, 0, 0, 200), Color(255,128,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 16 - Ang:Right() * 15, Ang, 0.16)
		draw.RoundedBox(0, -50, -360, 95, 40, Color( self:GetNWInt("topred"),self:GetNWInt("topgrn"),0,255 ) )
		draw.RoundedBox(0, -50, -155, 95, 50, Color( self:GetNWInt("botred"),self:GetNWInt("botgrn"),0,255 ) )
		
		draw.WordBox(0, -SNWid*0.5 - 4, -345, seconname, "NameFont", Color(0, 0, 0, 200), Color(255,255,255,255))
		draw.WordBox(0, -FNWid*0.5 - 4, -135, firstname, "NameFont", Color(0, 0, 0, 200), Color(255,255,255,255))
	cam.End3D2D()

end

function ENT:Think()

	local ply = LocalPlayer()
	local tr = ply:GetEyeTrace()

	local Pos = self:GetPos()
	if ply == self:GetNWEntity("mach_player") then
		if tr.Entity == self then
			if tr.HitPos.z < Pos.z - 20 and tr.HitPos.z > Pos.z - 50 then
				self.fontBlue = 255
				self:SetNWBool("button", true)
			else
				self.fontBlue = 128
				self:SetNWBool("button", false)
			end
		end
	else
		self.fontBlue = 128
	end
	--print(self:GetNWBool("button"))
end
