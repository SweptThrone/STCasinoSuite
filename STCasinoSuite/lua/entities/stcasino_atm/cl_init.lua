include('shared.lua')

surface.CreateFont( "ATMFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 48,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
} )

surface.CreateFont( "STDollarFont", {
	font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
	extended = false,
	size = 72,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
} )

function ENT:Initialize()

end

function ENT:Draw()
	
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * 15.25 - Ang:Right() * 15, Ang, 0.16)
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( -120, -27, 242, 60 ) --covers bottom panel
		draw.SimpleText("TCash", "ATMFont", -60, -20)
		surface.DrawRect( -125, -492, 245, 60 ) --covers top panel
		draw.SimpleText("ATM", "ATMFont", -49, -485)
		surface.DrawRect( 10, -400, 90, 125 ) --covers map
		draw.SimpleText("$", "STDollarFont", 35, -375, Color(0,255,0))
	cam.End3D2D()

end

net.Receive("STOpenATMMenu", function(len, ply)
	local mein = net.ReadInt(32)
	local acc = net.ReadInt(32)
	--[[ DEPOSIT WINDOW ]]--
	local DepositSub = vgui.Create( "DFrame" )
	DepositSub:SetPos( 5, 5 )
	DepositSub:SetSize( 300, 120 )
	DepositSub:SetTitle( "TCash: Deposit" )
	DepositSub:SetDraggable( false )
	DepositSub:ShowCloseButton( false )
	DepositSub:SetVisible( false )
	DepositSub:Center()
	DepositSub.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
	end
	
	local BalanceDisp = vgui.Create( "DLabel", DepositSub )
	BalanceDisp:SetPos( 25, 50 )
	BalanceDisp:SetSize( 350, 24 )
	BalanceDisp:SetText( "Your balance: $" .. acc )
	BalanceDisp:Dock(TOP)
	BalanceDisp:SetContentAlignment(5)
	
	local DeEntry = vgui.Create( "DTextEntry", DepositSub )
	DeEntry:SetPos( 25, 50 )
	DeEntry:SetSize( 350, 24 )
	DeEntry:SetText( "Enter deposit amount here" )
	DeEntry:Dock(TOP)
	DeEntry.OnEnter = function( self )
		if type(tonumber(self:GetValue())) != "number" then
			self:SetText( "Enter a NUMBER!" )
			surface.PlaySound("buttons/button8.wav")
		else
			if tonumber(self:GetValue()) < 1 then self:SetValue( "1" ) end
			net.Start( "STATMMoneyDeal" )
				net.WriteInt( tonumber(self:GetValue()), 32 )
			net.SendToServer()
			net.Start("STCloseATMMenu")
				net.WriteInt(mein, 32)
			net.SendToServer()
			surface.PlaySound("buttons/button6.wav")
			DepositSub:Close()
		end
	end
	
	local ConfirmBut = vgui.Create( "DButton", DepositSub )
	ConfirmBut:SetPos( 25, 50 )
	ConfirmBut:SetSize( 350, 24 )
	ConfirmBut:SetText( "Deposit" )
	ConfirmBut:Dock(BOTTOM)
	ConfirmBut.DoClick = function( self )
		if type(tonumber(DeEntry:GetValue())) != "number" then
			DeEntry:SetText( "Enter a NUMBER!" )
			surface.PlaySound("buttons/button8.wav")
		else
			if tonumber(DeEntry:GetValue()) < 1 then DeEntry:SetValue( "1" ) end
			net.Start( "STATMMoneyDeal" )
				net.WriteInt( tonumber(DeEntry:GetValue()), 32 )
			net.SendToServer()
			net.Start("STCloseATMMenu")
				net.WriteInt(mein, 32)
			net.SendToServer()
			surface.PlaySound("buttons/button6.wav")
			DepositSub:Close()
		end
	end
	ConfirmBut.Paint = function( self, w, h )
		if ConfirmBut:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 0, 255 ) )
			ConfirmBut:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 255, 128, 255 ) )
			ConfirmBut:SetTextColor(Color(0,0,0))
		end
	end
	
	local CloseButton = vgui.Create( "DButton", DepositSub )
	CloseButton:SetPos( 275, 0 )
	CloseButton:SetSize( 25, 20 )
	CloseButton:SetText( "X" )
	CloseButton.DoClick = function( self )
		DepositSub:Close()
		surface.PlaySound("ui/buttonclick.wav")
		net.Start("STCloseATMMenu")
			net.WriteInt(mein, 32)
		net.SendToServer()
	end
	CloseButton.Paint = function( self, w, h )
		if CloseButton:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 0, 0, 255 ) )
			CloseButton:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 128, 128, 255 ) )
			CloseButton:SetTextColor(Color(0,0,0))
		end
	end
	
		--[[ WITHDRAW WINDOW ]]--
	local WithdrawSub = vgui.Create( "DFrame" )
	WithdrawSub:SetPos( 5, 5 )
	WithdrawSub:SetSize( 300, 120 )
	WithdrawSub:SetTitle( "TCash: Withdraw" )
	WithdrawSub:SetDraggable( false )
	WithdrawSub:ShowCloseButton( false )
	WithdrawSub:SetVisible( false )
	WithdrawSub:Center()
	WithdrawSub.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
	end
	
	local BalanceDisp = vgui.Create( "DLabel", WithdrawSub )
	BalanceDisp:SetPos( 25, 50 )
	BalanceDisp:SetSize( 350, 24 )
	BalanceDisp:SetText( "Your balance: $" .. acc )
	BalanceDisp:Dock(TOP)
	BalanceDisp:SetContentAlignment(5)
	
	local WDEntry = vgui.Create( "DTextEntry", WithdrawSub )
	WDEntry:SetPos( 25, 50 )
	WDEntry:SetSize( 350, 24 )
	WDEntry:SetText( "Enter withdrawal amount here" )
	WDEntry:Dock(TOP)
	WDEntry.OnEnter = function( self )
		if type(tonumber(self:GetValue())) != "number" then
			self:SetText( "Enter a NUMBER!" )
			surface.PlaySound("buttons/button8.wav")
		else
			if tonumber(self:GetValue()) < 1 then self:SetValue( "1" ) end
			net.Start( "STATMMoneyDeal" )
				net.WriteInt( -1 * tonumber(self:GetValue()), 32 )
			net.SendToServer()
			net.Start("STCloseATMMenu")
				net.WriteInt(mein, 32)
			net.SendToServer()
			surface.PlaySound("buttons/button6.wav")
			WithdrawSub:Close()
		end
	end
	
	local ConfirmBut = vgui.Create( "DButton", WithdrawSub )
	ConfirmBut:SetPos( 25, 50 )
	ConfirmBut:SetSize( 350, 24 )
	ConfirmBut:SetText( "Withdraw" )
	ConfirmBut:Dock(BOTTOM)
	ConfirmBut.DoClick = function( self )
		if type(tonumber(WDEntry:GetValue())) != "number" then
			WDEntry:SetText( "Enter a NUMBER!" )
			surface.PlaySound("buttons/button8.wav")
		else
			if tonumber(WDEntry:GetValue()) < 1 then WDEntry:SetValue( "1" ) end
			net.Start( "STATMMoneyDeal" )
				net.WriteInt( -1 * tonumber(WDEntry:GetValue()), 32 )
			net.SendToServer()
			net.Start("STCloseATMMenu")
				net.WriteInt(mein, 32)
			net.SendToServer()
			surface.PlaySound("buttons/button6.wav")
			WithdrawSub:Close()
		end
	end
	ConfirmBut.Paint = function( self, w, h )
		if ConfirmBut:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 0, 255 ) )
			ConfirmBut:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 255, 128, 255 ) )
			ConfirmBut:SetTextColor(Color(0,0,0))
		end
	end
	
	local CloseButton = vgui.Create( "DButton", WithdrawSub )
	CloseButton:SetPos( 275, 0 )
	CloseButton:SetSize( 25, 20 )
	CloseButton:SetText( "X" )
	CloseButton.DoClick = function( self )
		WithdrawSub:Close()
		surface.PlaySound("ui/buttonclick.wav")
		net.Start("STCloseATMMenu")
			net.WriteInt(mein, 32)
		net.SendToServer()
	end
	CloseButton.Paint = function( self, w, h )
		if CloseButton:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 0, 0, 255 ) )
			CloseButton:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 128, 128, 255 ) )
			CloseButton:SetTextColor(Color(0,0,0))
		end
	end

	--[[ END WINDOWS ]]--
	
	surface.PlaySound("garrysmod/ui_return.wav")
	local ATMWindow = vgui.Create( "DFrame" )
	ATMWindow:SetPos( 5, 5 )
	ATMWindow:SetSize( 450, 150 )
	ATMWindow:SetTitle( "TCash ATM | Your balance: $" .. acc )
	ATMWindow:SetVisible( true )
	ATMWindow:SetDraggable( false )
	ATMWindow:ShowCloseButton( false )
	ATMWindow:MakePopup()
	ATMWindow:Center()
	ATMWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
	end

	local CloseButton = vgui.Create( "DButton", ATMWindow )
	CloseButton:SetPos( 25, 50 )
	CloseButton:SetSize( 350, 24 )
	CloseButton:SetText( "CANCEL" )
	CloseButton:Dock(BOTTOM)
	CloseButton.DoClick = function( self )
		ATMWindow:Close()
		surface.PlaySound("ui/buttonclick.wav")
		net.Start("STCloseATMMenu")
			net.WriteInt(mein, 32)
		net.SendToServer()
	end
	CloseButton.Paint = function( self, w, h )
		if CloseButton:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 0, 0, 255 ) )
			CloseButton:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 128, 128, 255 ) )
			CloseButton:SetTextColor(Color(0,0,0))
		end
	end
	
	local WithdrawButton = vgui.Create( "DButton", ATMWindow )
	WithdrawButton:SetPos( 25, 50 )
	WithdrawButton:SetSize( 220, 24 )
	WithdrawButton:SetText( "WITHDRAW" )
	WithdrawButton:Dock(LEFT)
	WithdrawButton:SetFont("DermaLarge")
	WithdrawButton.DoClick = function( self )
		ATMWindow:Close()
		surface.PlaySound("ui/buttonclickrelease.wav")
		WithdrawSub:SetVisible( true )
		WithdrawSub:MakePopup()
	end
	WithdrawButton.Paint = function( self, w, h )
		if WithdrawButton:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 128, 255 ) )
			WithdrawButton:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 255, 255 ) )
			WithdrawButton:SetTextColor(Color(0,0,0))
		end
	end
	
	local DepositButton = vgui.Create( "DButton", ATMWindow )
	DepositButton:SetPos( 25, 50 )
	DepositButton:SetSize( 220, 24 )
	DepositButton:SetText( "DEPOSIT" )
	DepositButton:Dock(RIGHT)
	DepositButton:SetFont("DermaLarge")
	DepositButton.DoClick = function( self )
		ATMWindow:Close()
		surface.PlaySound("ui/buttonclickrelease.wav")
		DepositSub:SetVisible( true )
		DepositSub:MakePopup()
	end
	DepositButton.Paint = function( self, w, h )
		if DepositButton:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 128, 255 ) )
			DepositButton:SetTextColor(Color(255,255,255))
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 128, 255, 255 ) )
			DepositButton:SetTextColor(Color(0,0,0))
		end
	end
	
end)
