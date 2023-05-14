-- ### Begin STSettings v2 code ###
ST_CONFIGS = ST_CONFIGS or {}
local this_addon = "STCasinoSuite"
local this_defaults = [[CoinFlipCost=500
DoubleOrNothingCost=100
GasCashCost=250
JacksPotCost=175
JPRibbonsPayout=450
JPCoinsPayout=750
JPCashPayoutEach=75
JPLightningsPayout=375
JPMusicsPayout=300
JP8BallsPayout=1125
JPStarsPayout=1500
JackPotAdd=175
LoanMax=20000
RagingRubiesCost=100
RRHeartsPayout=600
RRBellsPayout=1000
RRCashPayoutEach=100
RRDrivesPayout=500
RRClocksPayout=400
RRCarsPayout=1500
RRColorsPayout=4000
RRRubiesPayout=2000
WildCallCost=100
WildCallSingle=1000
WildCallDouble=10000
LottoTicketPrice=100]]
ST_CONFIGS[ this_addon ] = ST_CONFIGS[ this_addon ] or {}

local function ParseSTSettings( str )
    local boolishValues = {
        [ "true" ] = { true },
        [ "false" ] = { false },
        [ "t" ] = { true },
        [ "f" ] = { false },
        [ "yes" ] = { true },
        [ "no" ] = { false },
        [ "y" ] = { true },
        [ "n" ] = { false },
        [ "on" ] = { true },
        [ "off" ] = { false }
    }

    str = str:Trim()
    str = str .. "\n"

    local startPos = 1

    repeat
        local splitPos = str:find( "=", startPos, true )
        local settingName = str:sub( startPos, splitPos - 1 )
        local settingValue = str:sub( splitPos + 1, str:find( "\n", splitPos, true ) - 1 )
        startPos = str:find( "\n", splitPos, true ) + 1

        -- type guess
        local commaTrimmedValue = settingValue:Replace( ",", "" )
        commaTrimmedValue = commaTrimmedValue:Replace( "'", "" )
        commaTrimmedValue = commaTrimmedValue:Replace( "_", "" )
        if type( tonumber( commaTrimmedValue ) ) == "number" then -- numbers
            settingValue = tonumber( commaTrimmedValue )
        elseif boolishValues[ settingValue:lower() ] then -- booleans
            settingValue = boolishValues[ settingValue:lower() ][ 1 ]
        end
        -- i don't use any other types

        ST_CONFIGS[ this_addon ][ settingName ] = settingValue
    until not str:find( "\n", startPos, true )
end

hook.Add( "Initialize", "STSettings." .. this_addon, function()

    local this_addon = this_addon:lower()
    file.CreateDir( "sweptthrone_addons" )
    -- find old files from throneco_addons
    if file.Exists( "throneco_addons/" .. this_addon .. ".txt", "DATA" ) then
        -- write them to sweptthrone_addons
        file.Write( "sweptthrone_addons/" .. this_addon .. ".txt", file.Read( "throneco_addons/" .. this_addon .. ".txt", "DATA" ) )
        -- delete the old file
        file.Delete( "throneco_addons/" .. this_addon .. ".txt" )
        -- if the folder is empty, delete it too
        -- wiki says it will only delete an EMPTY folder
        file.Delete( "throneco_addons" )
    else
        if !file.Exists( "sweptthrone_addons/" .. this_addon .. ".txt", "DATA") then
            file.Write( "sweptthrone_addons/" .. this_addon .. ".txt", this_defaults )
        end
    end
    -- parse the new file to a table
    local settingsStr = file.Read( "sweptthrone_addons/" .. this_addon .. ".txt", "DATA" )

    ParseSTSettings( settingsStr )

end )
-- ### End STSettings v2 code ###

hook.Add("Initialize", "SetUpSTJackPot", function()
	STC_LOTTERYPLY = {}

	file.CreateDir("stcasino")

    if !file.Exists("stcasino/jacks_jackpot.txt", "DATA") then
        
        file.Write("stcasino/jacks_jackpot.txt", "0")
		file.Write("stcasino/lotterytab.txt", "[\"none\"]")
    end
	
	if cookie.GetNumber( "STLottery" ) == nil then
		cookie.Set( "STLottery", "0" )
	end
	
	local lottoTab = util.JSONToTable( file.Read( "stcasino/lotterytab.txt" ) )
	STC_LOTTERYPLY = lottoTab
end)

--convienience function
local meta = FindMetaTable( "Player" )

function meta:CasinoPayout( m )

	if m < 0 then
		DarkRP.notify( self, 0, 5, "Spent $" .. -1 * m .. "." )
	elseif m > 0 then
		DarkRP.notify( self, 0, 5, "Gained $" .. m .. "." )
	else
		DarkRP.notify( self, 1, 5, "Gained no money." )
	end
	self:addMoney( m )

end

hook.Add( "PlayerSay", "STRunTheLotto", function(ply, txt)

	if (txt == ".lottery" or txt == ".lotto") and (ply:IsAdmin() or ply:IsSuperAdmin()) then
		STC_LOTTERYPLY = util.JSONToTable( file.Read( "stcasino/lotterytab.txt" ) )
		local randNum = math.random( 1, #STC_LOTTERYPLY )

		local ingame = false
		for k,v in pairs(player.GetAll()) do
			if v:SteamID() == STC_LOTTERYPLY[randNum] then
				PrintMessage( HUD_PRINTCENTER, v:Name() .. " just won the lottery with ticket #" .. randNum .. ", a total of $" .. cookie.GetNumber( "STLottery" ) .. "!" )
				v:addMoney( cookie.GetNumber( "STLottery" ) )
				DarkRP.notify( v, 0, 5, "You have won the lottery and gained $" .. cookie.GetNumber( "STLottery" ) )
				ingame = true
			end
		end
		if ingame == false then
			PrintMessage( HUD_PRINTCENTER, "An offline player just won the lottery with ticket #" .. randNum .. ", a total of $" .. cookie.GetNumber( "STLottery" ) .. "!" )
			util.SetPData( STC_LOTTERYPLY[randNum], "LotteryWinnings", cookie.GetNumber( "STLottery" ) )
		end
		
		STC_LOTTERYPLY = {}
		file.Write("stcasino/lotterytab.txt", "[\"none\"]")
		cookie.Set( "STLottery", "0" )
	end

end )

hook.Add( "KeyPress", "STPayOutOfflinePlayers", function( ply, key )
	if ( key == IN_FORWARD or key == IN_BACK or key == IN_RIGHT or key == IN_LEFT ) then
		if ply:GetPData( "LotteryWinnings" ) != "0" and ply:GetPData( "LotteryWinnings" ) != nil then
			ply:addMoney( tonumber(ply:GetPData( "LotteryWinnings" ) ) )
			DarkRP.notify( ply, 0, 5, "You won the lottery while offline. You won $" .. ply:GetPData( "LotteryWinnings" ) )
			ply:SetPData( "LotteryWinnings", 0 )
		end
	end
end )

MsgC( Color(0,255,0), "STCasino set up successfully!\n" )
MsgC( Color( 255, 0, 0 ), "If you get an error about a nil value after this line, you can safely ignore it.\n" )
MsgC( Color(0,255,0), "Jack's Pot currently has $" .. file.Read( "stcasino/jacks_jackpot.txt", "DATA" ) .. " in it.\n" )