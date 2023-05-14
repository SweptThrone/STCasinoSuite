include('shared.lua')

local LOAD = Material( "icon16/arrow_refresh.png" )
local BROKE = Material( "icon16/cancel.png" )
local HEART = Material( "icon16/heart.png" )
local BELLS = Material( "icon16/bell.png" )
local MONEY = Material( "icon16/money.png" )
local DRIVE = Material( "icon16/drive.png" )
local CLOCK = Material( "icon16/clock.png" )
local AUTOM = Material( "icon16/car.png" )
local COLOR = Material( "icon16/color_wheel.png" )
local RUBIE = Material( "icon16/ruby.png" )

local SPINS = { BROKE, HEART, BELLS, MONEY, DRIVE, CLOCK, AUTOM, COLOR, RUBIE, LOAD }
local results = {LOAD, LOAD, LOAD}

function ENT:Initialize()
	self:SetNWInt("slot1", 10)
	self:SetNWInt("slot2", 10)
	self:SetNWInt("slot3", 10)
end

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
		
	local txt = "Raging Rubies"
	
	surface.SetFont("Trebuchet18") --i know
	local TextWidth = surface.GetTextSize(txt)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
	
	local slot1 = self:GetNWInt("slot1")
	local slot2 = self:GetNWInt("slot2")
	local slot3 = self:GetNWInt("slot3")
		
	cam.Start3D2D(Pos + Ang:Up() * 13 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth + 32.33, -76, txt, "CloseCaption_Normal", Color(0, 0, 0, 0), Color(255,128,128,255))
	cam.End3D2D()
	
	cam.Start3D2D(Pos + Ang:Up() * 13.25 - Ang:Right() * 15, Ang, 0.16)
		--SLOT 1
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot1] )
		surface.DrawTexturedRect( -6.5, 78, 24, 24 )
		--SLOT 2
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot2] )
		surface.DrawTexturedRect( 26, 78, 24, 24 )
		--SLOT 3
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( SPINS[slot3] )
		surface.DrawTexturedRect( 59, 78, 24, 24 )
	cam.End3D2D()
end
