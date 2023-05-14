AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

util.AddNetworkString("OpenSTLoanMonitor")

function ENT:Initialize()
	
	self:SetModel( "models/props/cs_office/computer.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
end


function ENT:Use(activator, caller)
	self:EmitSound("ambient/machines/keyboard" .. math.random(1,6) .. "_clicks.wav")
	net.Start( "OpenSTLoanMonitor" )
		for k,v in pairs(player.GetAll()) do
			net.WriteEntity( v )
			if v:GetPData("st_loan") == nil then
				v:SetPData("st_loan", 0)
			end
			net.WriteInt( v:GetPData("st_loan"), 32 )
		end
	net.Send( caller )
end