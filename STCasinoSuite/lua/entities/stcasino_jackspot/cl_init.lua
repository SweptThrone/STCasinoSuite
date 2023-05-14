include('shared.lua')
local LOAD = Material( "icon16/bullet_go.png" )
local BROKE = Material( "icon16/circlecross.png" )
local HEART = Material( "icon16/rosette.png" ) --icon16/rosette.png
local BELLS = Material( "icon16/coins.png" ) --icon16/coins.png
local MONEY = Material( "icon16/money_dollar.png" )
local DRIVE = Material( "icon16/lightning.png" ) --icon16/lightning.png
local CLOCK = Material( "icon16/music.png" ) --icon16/music.png
local AUTOM = Material( "icon16/sport_8ball.png" ) --icon16/sport_8ball.png
local COLOR = Material( "icon16/rainbow.png" ) --icon16/rainbow.png
local RUBIE = Material( "icon16/star.png" ) --icon16/star.png

local SPINS = { BROKE, HEART, BELLS, MONEY, DRIVE, CLOCK, AUTOM, COLOR, RUBIE, LOAD }
local results = {LOAD, LOAD, LOAD}

surface.CreateFont( "JackpotFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 48,
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

function ENT:Initialize()
	self:SetNWInt("slot1", 10)
	self:SetNWInt("slot2", 10)
	self:SetNWInt("slot3", 10)
end

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
		
	local txt = "Jack's Pot"
	local jpot = "$" .. self:GetNWInt("jackpot")
	
	surface.SetFont("DermaLarge")
	local TextWidth = surface.GetTextSize(txt)
	surface.SetFont("JackpotFont")
	local JackWidth = surface.GetTextSize(self:GetNWInt("jackpot"))
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 25 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth*0.5, -260, txt, "DermaLarge", Color(0, 0, 0, 255), Color(128,255,128,255))
	cam.End3D2D()
	
	local slot1 = self:GetNWInt("slot1")
	local slot2 = self:GetNWInt("slot2")
	local slot3 = self:GetNWInt("slot3")
	
	cam.Start3D2D(Pos + Ang:Up() * 29 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -JackWidth*0.5-16, -130, jpot, "JackpotFont", Color(0, 0, 0, 255), Color(255,255,255,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 26 - Ang:Right() * 15, Ang, 0.16)
		draw.RoundedBox( 8, -100, 235, 216, 52, Color(0, 0, 0, 255) )
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 27 - Ang:Right() * 15, Ang, 0.16)
		--SLOT 1
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot1] )
		surface.DrawTexturedRect( -91, 235, 48, 48 )
		--SLOT 2
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot2] )
		surface.DrawTexturedRect( -16, 235, 48, 48 )
		--SLOT 3
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot3] )
		surface.DrawTexturedRect( 59, 235, 48, 48 )
	cam.End3D2D()
end
