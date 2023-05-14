AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

util.AddNetworkString("OpenSTLoanMenu")
util.AddNetworkString("STLoanToServer")

function ENT:Initialize()
	
	self:SetModel( "models/props_combine/breenconsole.mdl" )
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

	self:EmitSound("buttons/button3.wav")
	if caller:GetPData("st_loan") == nil then
		caller:SetPData("st_loan", 0)
	end

	net.Start( "OpenSTLoanMenu" )
		net.WriteInt( caller:GetPData("st_loan"), 32 )
	net.Send( caller )
end

net.Receive( "STLoanToServer", function(len, ply)
	local loanint = net.ReadInt(32)
	if loanint > 0 and ply:GetPData( "st_loan", 0 ) == "0" then
		if loanint > ST_CONFIGS[ "STCasinoSuite" ][ "LoanMax" ] then
			loanint = ST_CONFIGS[ "STCasinoSuite" ][ "LoanMax" ]
		end
		ply:addMoney( loanint )
		DarkRP.notify( ply, 1, 5, "Took out a loan of $" .. loanint .. "." )
		ply:SetPData( "st_loan", loanint )
	elseif loanint < 0 and ply:GetPData( "st_loan", 0 ) == "0"  then
		if loanint > ST_CONFIGS[ "STCasinoSuite" ][ "LoanMax" ] then
			loanint = ST_CONFIGS[ "STCasinoSuite" ][ "LoanMax" ]
		end
		ply:addMoney( 1 )
		DarkRP.notify( ply, 1, 5, "Took out a loan of $" .. 1 .. "." )
		ply:SetPData( "st_loan", "1" )
	elseif loanint == 0 and ply:GetPData( "st_loan", 0 ) != "0" then--if loan == 0 (should be pay back)
		if ply:getDarkRPVar("money") < tonumber(ply:GetPData("st_loan")) then return end
		ply:addMoney( -tonumber(ply:GetPData("st_loan")) )
		DarkRP.notify( ply, 1, 5, "Paid back your loan of $" .. ply:GetPData("st_loan") .. "." )
		ply:SetPData( "st_loan", loanint )
	else
		DarkRP.notify( ply, 1, 5, "An error occurred with STCC. Were you trying to exploit?" )
	end
end )