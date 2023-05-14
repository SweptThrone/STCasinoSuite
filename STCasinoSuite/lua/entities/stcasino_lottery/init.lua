AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("STOpenATMMenu")
util.AddNetworkString("STCloseATMMenu")
util.AddNetworkString("STATMMoneyDeal")

function ENT:Initialize()
	
	self:SetModel( "models/props_combine/combine_interface001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWInt("currentlotto", cookie.GetNumber( "STLottery" ))
	self:SetNWInt("lottoprice", ST_CONFIGS[ "STCasinoSuite" ][ "LottoTicketPrice" ] )
end

function ENT:Use(activator, caller)

	if caller:getDarkRPVar("money") < ST_CONFIGS[ "STCasinoSuite" ][ "LottoTicketPrice" ] then
		DarkRP.notify( caller, 1, 5, "You don't have enough money!" )
	else
		if STC_LOTTERYPLY[1] == "none" then
			table.remove( STC_LOTTERYPLY, 1 )
		end
		caller:addMoney( -ST_CONFIGS[ "STCasinoSuite" ][ "LottoTicketPrice" ] )
		table.insert( STC_LOTTERYPLY, caller:SteamID() )
		local plyTab = util.TableToJSON( STC_LOTTERYPLY )
		file.Write( "stcasino/lotterytab.txt", plyTab )
		print("Entered the lottery")
		self:EmitSound("ambient/levels/labs/coinslot1.wav")
		cookie.Set( "STLottery", tostring( cookie.GetNumber( "STLottery" ) + ST_CONFIGS[ "STCasinoSuite" ][ "LottoTicketPrice" ] ) )
	end
end

function ENT:Think()

	self:SetNWInt("currentlotto", cookie.GetNumber( "STLottery" ))

end

function ENT:OnRemove()
end