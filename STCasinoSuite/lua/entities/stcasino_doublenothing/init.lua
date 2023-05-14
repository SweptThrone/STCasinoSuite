AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include('shared.lua')

function ENT:Initialize()
	
	self:SetModel( "models/props_wasteland/laundry_dryer002.mdl" )
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
	self:SetNWEntity("mach_player", Entity(-1))
end

function ENT:Use(activator, caller)

	if self:GetNWEntity("mach_player") != caller and self:GetNWEntity("mach_player") != Entity(-1) then 
		DarkRP.notify( caller, 1, 5, "This machine is already in use!" )
	else
		if caller:getDarkRPVar( "money" ) >= ST_CONFIGS[ "STCasinoSuite" ][ "DoubleOrNothingCost" ] then
			self:SetNWEntity("mach_player", caller)
			timer.Remove("don" .. caller:Name() .. self:EntIndex())
			timer.Create("don" .. caller:Name() .. self:EntIndex(), 30, 1, function()
				if !IsValid(self) then return end
				self:SetNWEntity("mach_player", Entity(-1))
				self:SetNWInt("multiplication", 1)
				self:SetNWInt("dispred", 0)
				self:SetNWInt("dispgrn", 0)
				self:EmitSound("buttons/button11.wav")
			end)
		end
		if self:GetNWBool("button") and self:GetNWInt("multiplication") != 1 then
			self:GetNWEntity("mach_player"):CasinoPayout( ST_CONFIGS[ "STCasinoSuite" ][ "DoubleOrNothingCost" ] * self:GetNWInt("multiplication") )
			self:SetNWEntity("mach_player", Entity(-1))
			self:EmitSound("buttons/bell1.wav")
			self:SetNWInt("multiplication", 1)
			self:SetNWInt("dispred", 0)
			self:SetNWInt("dispgrn", 0)
			timer.Remove("don" .. caller:Name() .. self:EntIndex())
		else
			if caller:getDarkRPVar( "money" ) >= (100) then
				if self:GetNWInt("multiplication") == 1 then
					self:EmitSound("ambient/office/coinslot1.wav")
					self:GetNWEntity("mach_player"):CasinoPayout( -ST_CONFIGS[ "STCasinoSuite" ][ "DoubleOrNothingCost" ] )
				end
				if math.random(1,100) > 50 then --first time luck
					self:SetNWInt("multiplication", self:GetNWInt("multiplication") * 2)
					self:SetNWInt("dispred", 0)
					self:SetNWInt("dispgrn", 128)
					self:EmitSound("garrysmod/content_downloaded.wav")
				else
					self:SetNWInt("multiplication", 1)
					self:SetNWInt("dispred", 128)
					self:SetNWInt("dispgrn", 0)
					self:EmitSound("garrysmod/balloon_pop_cute.wav")
				end
			else DarkRP.notify( caller, 1, 5, "You don't have enough money!" )
			end
		end
	end

end

function ENT:Think()
	if IsValid(self:GetNWEntity("mach_player")) and IsValid(self) then
		local tr = self:GetNWEntity("mach_player"):GetEyeTrace()
		local Pos = self:GetPos()
		if tr.Entity == self then
			if tr.HitPos.z < Pos.z - 20 and tr.HitPos.z > Pos.z - 50 then
				self:SetNWBool("button", true)
			else
				self:SetNWBool("button", false)
			end
		end
	else
		self:SetNWBool("button", false)
	end
end