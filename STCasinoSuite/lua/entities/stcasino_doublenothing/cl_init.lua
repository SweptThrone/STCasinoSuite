include('shared.lua')

ENT.fontBlue = 128

surface.CreateFont( "MultiplyFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 72,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

function ENT:Draw()

	self:DrawModel()
	--print(self:GetNWInt("multiplication"))
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
		
	local txt = "Double or Nothing"
	local mult = self:GetNWInt("multiplication")
	
	surface.SetFont("DermaLarge")
	local TextWidth = surface.GetTextSize(txt)
	local TextWidth2 = surface.GetTextSize("TAKE IT!")
	surface.SetFont("MultiplyFont")
	local MultWidth = surface.GetTextSize(mult .. "x")
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 20 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth*0.5, -180, txt, "DermaLarge", Color(0, 0, 0, 100), Color(128,255,255,255))
		draw.WordBox(4, -TextWidth2*0.5, 290, "TAKE IT!", "DermaLarge", Color(0, 0, 0, 100), Color(self.fontBlue,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 23 - Ang:Right() * 15, Ang, 0.16)
		surface.SetDrawColor( self:GetNWInt("dispred"),self:GetNWInt("dispgrn"),0,255 )
		--draw.Circle( 0, 60, 120, 24 )
		draw.RoundedBox(128, -120, -60, 240, 240, Color( self:GetNWInt("dispred"),self:GetNWInt("dispgrn"),0,255 ) )
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 24 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -MultWidth*0.5, 20, mult .. "x", "MultiplyFont", Color(0, 0, 0, 0), Color(255,255,255,255))
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
