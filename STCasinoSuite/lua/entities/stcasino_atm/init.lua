AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("STOpenATMMenu")
util.AddNetworkString("STCloseATMMenu")
util.AddNetworkString("STATMMoneyDeal")

function ENT:Initialize()
	
	self:SetModel( "models/props/cs_assault/TicketMachine.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWEntity("curruser", nil)
end

function ENT:Use(activator, caller)
	if caller:GetPData("statmmoney") == nil then
		caller:SetPData("statmmoney", 0)
	end

	if self:GetNWEntity("curruser") == nil or !IsValid(self:GetNWEntity("curruser")) then
		self:SetNWEntity("curruser", caller)
		net.Start("STOpenATMMenu")
			net.WriteInt(self:EntIndex(), 32)
			net.WriteInt( tonumber(caller:GetPData("statmmoney")), 32) 
		net.Send(caller)
	else
		print("Someone is already using this ATM")
	end
end

function ENT:Think()
end

net.Receive("STCloseATMMenu", function(len, ply)
	local me = net.ReadInt(32)
	Entity(me):SetNWEntity("curruser", nil)
end)

net.Receive("STATMMoneyDeal", function(len, ply)
	--withdraw is negative
	local money = net.ReadInt(32)
	if money > 0 then --deposit (subtract from wallet, add to PData)
		if ply:getDarkRPVar( "money" ) < money then
			DarkRP.notify( ply, 1, 5, "You don't have enough money!" )
		else
			ply:CasinoPayout( -money )
			ply:SetPData( "statmmoney", tonumber(ply:GetPData("statmmoney")) + money )
		end
	else --withdrawal (add to wallet, subtract from PData)
		if tonumber(ply:GetPData("statmmoney")) < -money then
			DarkRP.notify( ply, 1, 5, "Your account doesn't have enough money!" )
		else
			ply:CasinoPayout( -money )
			ply:SetPData( "statmmoney", ply:GetPData("statmmoney") + money )
		end
	end
end)

function ENT:OnRemove()
	self:SetNWEntity("curruser", nil)
end