AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	
	self:SetModel( "models/props_wasteland/laundry_dryer001.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	self:SetUseType(SIMPLE_USE)
	
	self:SetNWInt("slot1", 10)
	self:SetNWInt("slot2", 10)
	self:SetNWInt("slot3", 10)
	timer.Simple(0.5, function()
		self:SetNWInt("jackpot", tonumber(file.Read( "stcasino/jacks_jackpot.txt", "DATA" )))
	end)
	self.active = false
end

function ENT:Use(activator, caller)

	if caller:getDarkRPVar( "money" ) >= ST_CONFIGS[ "STCasinoSuite" ][ "JacksPotCost" ] then
		local payout = 0
		
		if self.active == false then
			self.active = true
			self:EmitSound("buttons/lever7.wav")
			
			self:SetNWInt("slot1", 10)
			self:SetNWInt("slot2", 10)
			self:SetNWInt("slot3", 10)

			caller:CasinoPayout( -ST_CONFIGS[ "STCasinoSuite" ][ "JacksPotCost" ] )
			file.Write("stcasino/jacks_jackpot.txt", tostring(tonumber(self:GetNWInt("jackpot")) + ST_CONFIGS[ "STCasinoSuite" ][ "JackPotAdd" ]))
			for k,v in pairs(ents.GetAll()) do
				if v:GetClass() == "stcasino_jackspot" then
					v:SetNWInt("jackpot", tonumber(file.Read( "stcasino/jacks_jackpot.txt", "DATA" )))
				end
			end
			--self:SetNWInt("jackpot", tonumber(file.Read( "stcasino/jacks_jackpot.txt", "DATA" )))
			self:EmitSound("ambient/office/coinslot1.wav")
			
			for i=1, 3 do
				timer.Simple(1 * i, function()
					self:EmitSound("buttons/blip1.wav", 75, 50 + (25 * (i-1)))
					self:SetNWInt("slot" .. i, math.random(1,9))
				end)
			end
			
			timer.Simple(3.1, function()
				local payouts = {0, ST_CONFIGS[ "STCasinoSuite" ][ "JPRibbonsPayout" ], 
									ST_CONFIGS[ "STCasinoSuite" ][ "JPCoinsPayout" ], 
									ST_CONFIGS[ "STCasinoSuite" ][ "JPCashPayoutEach" ], 
									ST_CONFIGS[ "STCasinoSuite" ][ "JPLightningsPayout" ],
									ST_CONFIGS[ "STCasinoSuite" ][ "JPMusicsPayout" ], 
									ST_CONFIGS[ "STCasinoSuite" ][ "JP8BallsPayout" ], 
									3000, 
									ST_CONFIGS[ "STCasinoSuite" ][ "JPStarsPayout" ] }
				--TRIPLE ITEM--
				if self:GetNWInt("slot1") == self:GetNWInt("slot2") and self:GetNWInt("slot2") == self:GetNWInt("slot3") then
					local anySlot = self:GetNWInt("slot1")
					self:EmitSound("items/gift_drop.wav")
					
					if anySlot == 2 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JPRibbonsPayout" ]
					elseif anySlot == 3 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JPCoinsPayout" ]
					elseif anySlot == 5 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JPLightningsPayout" ]
					elseif anySlot == 6 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JPMusicsPayout" ]
					elseif anySlot == 7 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JP8BallsPayout" ]
					elseif anySlot == 8 then
						payout = self:GetNWInt("jackpot")
						self:EmitSound("ui/achievement_earned.wav")
					elseif anySlot == 9 then
						payout = ST_CONFIGS[ "STCasinoSuite" ][ "JPStarsPayout" ]
					end
				end
				
				local s1, s2, s3 = self:GetNWInt("slot1"), self:GetNWInt("slot2"), self:GetNWInt("slot3")
				
				if s1 != 1 and s2 != 1 and s3 != 1 then
					if s1 == 4 then
						payout = payout + ST_CONFIGS[ "STCasinoSuite" ][ "JPCashPayoutEach" ]
						self:EmitSound("ui/hint.wav")
					end
					if s2 == 4 then
						payout = payout + ST_CONFIGS[ "STCasinoSuite" ][ "JPCashPayoutEach" ]
						self:EmitSound("ui/hint.wav")
					end
					if s3 == 4 then
						payout = payout + ST_CONFIGS[ "STCasinoSuite" ][ "JPCashPayoutEach" ]
						self:EmitSound("ui/hint.wav")
					end
				end
				
				if s1 != 4 and s2 != 4 and s3 != 4 then
					if (s1 == s2 and s3 == 8) or (s1 == s3 and s2 == 8) or (s2 == 8 and s3 == 8) then
						payout = payouts[s1]
						self:EmitSound("items/gift_drop.wav")
					elseif (s2 == s3 and s1 == 8) or (s1 == 8 and s3 == 8) then
						payout = payouts[s2]
						self:EmitSound("items/gift_drop.wav")
					elseif (s1 == 8 and s2 == 8) then
						payout = payouts[s3]
						self:EmitSound("items/gift_drop.wav")
					end
				end
				
				if s1 == 8 and s2 == 8 and s3 == 8 then
					payout = self:GetNWInt("jackpot")
					self:EmitSound("ui/achievement_earned.wav")
					PrintMessage( HUD_PRINTCENTER, caller:Name() .. " just won Jack’s Pot, a total of $" .. payout .. "!" )
					file.Write("stcasino/jacks_jackpot.txt", "0")
					self:SetNWInt("jackpot", 0)
					for j,p in pairs(ents.GetAll()) do
						if p:GetClass() == "stcasino_jackspot" then
							p:SetNWInt("jackpot", 0)
						end
					end
				end
				
				if s1 == 1 or s2 == 1 or s3 == 1 then
					payout = 0
					self:EmitSound("buttons/weapon_cant_buy.wav")
				end
				
				self.active = false
				caller:CasinoPayout( payout )
			end)
		end
	else DarkRP.notify( caller, 1, 5, "You don't have enough money!" )
	end
	
end

function ENT:Think()
	--self:SetNWInt("jackpot", tonumber(file.Read( "stcasino/jacks_jackpot.txt", "DATA" )))
end