AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	
	self:SetModel( "models/props_wasteland/kitchen_stove002a.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	self:SetNWInt("multiplication", 1)
	self:SetNWBool("button", false)
	self:SetNWEntity("playerone", Entity(-1))
	self:SetNWEntity("playertwo", Entity(-1))
	self:SetNWInt("botred", 0)
	self:SetNWInt("botgrn", 0)
	self:SetNWInt("topred", 0)
	self:SetNWInt("topgrn", 0)
end

function ENT:Use(activator, caller)
	
	if timer.Exists( "timeout" .. self:EntIndex() ) then 
		DarkRP.notify( caller, 1, 5, "This machine is in use!" )
	return end
	if self:GetNWEntity("playerone") == caller and !timer.Exists("coin" .. self:EntIndex()) then
		self:GetNWEntity("playerone"):CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ] )
		self:SetNWEntity("playerone", Entity(-1))
		self:SetNWEntity("playertwo", Entity(-1))
		self:SetNWInt("botred", 0)
		self:SetNWInt("botgrn", 0)
		self:SetNWInt("topred", 0)
		self:SetNWInt("topgrn", 0)
	elseif caller:getDarkRPVar("money") >= ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ] then
		if self:GetNWEntity("playerone") == Entity(-1) then
			caller:CasinoPayout(-ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ])
			self:SetNWEntity("playerone", caller)
			self:EmitSound("ambient/office/coinslot1.wav")
			self:SetNWInt("botred", 128)
			self:SetNWInt("botgrn", 128)
		elseif self:GetNWEntity("playerone") != Entity(-1) and self:GetNWEntity("playertwo") == Entity(-1) then
			caller:CasinoPayout(-ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ])
			self:SetNWEntity("playertwo", caller)
			self:EmitSound("ambient/office/coinslot1.wav")
			self:SetNWInt("topred", 128)
			self:SetNWInt("topgrn", 128)
			self:EmitSound("ui/freeze_cam.wav")
			timer.Create("coin" .. self:EntIndex(), 5, 1, function()
				if math.random(1,2) == 1 then
					self:SetNWInt("topred", 128)
					self:SetNWInt("topgrn", 0)
					self:SetNWInt("botred", 0)
					self:SetNWInt("botgrn", 128)
					self:EmitSound("buttons/button24.wav")
					if !IsValid(self:GetNWEntity("playerone")) then return end
					self:GetNWEntity("playerone"):CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ] * 2 )
				else
					self:SetNWInt("topred", 0)
					self:SetNWInt("topgrn", 128)
					self:SetNWInt("botred", 128)
					self:SetNWInt("botgrn", 0)
					self:EmitSound("buttons/button24.wav")
					if !IsValid(self:GetNWEntity("playertwo")) then return end
					self:GetNWEntity("playertwo"):CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "CoinFlipCost" ] * 2 )
				end
				timer.Create("timeout" .. self:EntIndex(), 2, 1, function()
					self:SetNWEntity("playerone", Entity(-1))
					self:SetNWEntity("playertwo", Entity(-1))
					self:SetNWInt("botred", 0)
					self:SetNWInt("botgrn", 0)
					self:SetNWInt("topred", 0)
					self:SetNWInt("topgrn", 0)
				end)
			end )
		else
			DarkRP.notify( caller, 1, 5, "This machine is in use!" )
		end
	else
		DarkRP.notify( caller, 1, 5, "You don't have enough money!" )
	end
	
end

function ENT:Think()

end