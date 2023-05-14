AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	
	self:SetModel( "models/props_wasteland/gaspump001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:SetNWInt("curval", 0)
	self:SetNWInt("randval", math.random(1,100))
	self:SetNWEntity("curwin", Entity(-1))
	self.Entrants = {}
	self:SetNWInt("winnings", 0)
end


function ENT:Use(activator, caller)
	if !table.HasValue(self.Entrants, caller) then
		if caller:getDarkRPVar( "money" ) >= ST_CONFIGS[ "STCasinoSuite" ][ "GasCashCost" ] then
			table.insert(self.Entrants, caller)
			self:SetNWEntity("curwin", caller)
			self.plyRuns = self.totalRuns
			self:SetNWInt("winamt", self:GetNWInt("curval"))
			self:EmitSound("buttons/button17.wav")
			self:EmitSound("ambient/office/coinslot1.wav")
			caller:CasinoPayout( -ST_CONFIGS[ "STCasinoSuite" ][ "GasCashCost" ] )
			self:SetNWInt("winnings", ST_CONFIGS[ "STCasinoSuite" ][ "GasCashCost" ] * 2)
		else DarkRP.notify( caller, 1, 5, "You don't have enough money!" )
		end
	else
		self:EmitSound("buttons/button18.wav")
	end
end

function ENT:Think()
	self:SetNWInt("winnings", math.Clamp(self:GetNWInt("winnings") - ST_CONFIGS[ "STCasinoSuite" ][ "GasCashCost" ]/50, 0, ST_CONFIGS[ "STCasinoSuite" ][ "GasCashCost" ] * 2))
	if self:GetNWInt("curval") != self:GetNWInt("randval") then
		self:SetNWInt("curval", math.random(1,100))
	else
		if IsValid(self:GetNWEntity("curwin")) then
			self:GetNWEntity("curwin"):CasinoPayout(self:GetNWInt("winnings"))
		end
		self:SetNWInt("randval", math.random(1,100))
		self:EmitSound("buttons/button9.wav")
		self.Entrants = {}
		self:SetNWEntity("curwin", Entity(-1))
		self:SetNWInt("winnings", 0)
	end
	
	if self:GetNWInt("winnings") == 0 then
		self:SetNWEntity("curwin", Entity(-1))
		self.Entrants = {}
	end
end