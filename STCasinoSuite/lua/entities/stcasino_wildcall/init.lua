AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

util.AddNetworkString("OpenSTCasinoMenu5")
util.AddNetworkString("SendSTCasinoMoney")

ENT.useCall = nil

function ENT:Initialize()
	
	self:SetModel( "models/props_trainstation/payphone001a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:SetNWEntity("claimer", nil)
end


function ENT:Use(activator, caller)
	if caller:getDarkRPVar( "money" ) >= ST_CONFIGS[ "STCasinoSuite" ][ "WildCallCost" ] and self.useCall == nil then	
		self.useCall = caller
		self:EmitSound("ambient/office/coinslot1.wav")
		caller:CasinoPayout( -ST_CONFIGS[ "STCasinoSuite" ][ "WildCallCost" ] )

		net.Start("OpenSTCasinoMenu5")	
			net.WriteEntity( self )
		net.Send(caller)
	else
		if caller:getDarkRPVar( "money" ) < ST_CONFIGS[ "STCasinoSuite" ][ "WildCallCost" ] then
			DarkRP.notify( caller, 4, 1, "You don't have enough money!" )
		else
			DarkRP.notify( caller, 4, 1, "Someone else is using this!" )
		end
	end
end

net.Receive( "SendSTCasinoMoney", function(len, ply)

	local result = net.ReadString()
	local ent = net.ReadEntity()
	if ply == ent.useCall then
		if result == "double" then
			ply:CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "WildCallDouble" ] )
		elseif result == "single" then
			ply:CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "WildCallSingle" ] )
		else
			ply:CasinoPayout( 0 )
		end
		ent.useCall = nil
	end

end )