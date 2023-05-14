include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
		
	local txt = "Wild Call"
	
	surface.SetFont("DebugFixed") --i know
	local TextWidth = surface.GetTextSize(txt)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() * -3 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth * 0.5 - 5, -108, txt, "DebugFixed", Color(0, 0, 0, 255), Color(128,128,255,255))
	cam.End3D2D()
end

net.Receive("OpenSTCasinoMenu5", function()

	local randNum = tostring( math.random(0,9) .. math.random(0,9) )
	local ent = net.ReadEntity()

	local CasinoWindow = vgui.Create( "DFrame" )
	CasinoWindow:SetPos( 5, 5 )
	CasinoWindow:SetSize( 300, 500 )
	CasinoWindow:SetTitle( "Wild Call - Guess the Two-Digit Number" )
	CasinoWindow:SetVisible( true )
	CasinoWindow:SetDraggable( false )
	CasinoWindow:ShowCloseButton( true )
	CasinoWindow:MakePopup()
	CasinoWindow:Center()
	CasinoWindow:ShowCloseButton( false )
	CasinoWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 51, 91, 255 ) )
	end
	
	local NumDisp1 = Label("_", CasinoWindow)
	surface.SetFont( "DermaLarge" )
	local wid1 = surface.GetTextSize( NumDisp1:GetText() )
	NumDisp1:SetPos( 135 - (wid1 / 2), 75 )
	NumDisp1:SetSize( 100, 30 )
	NumDisp1:SetFont( "DermaLarge" )
	
	local NumDisp2 = Label("_", CasinoWindow)
	surface.SetFont( "DermaLarge" )
	local wid2 = surface.GetTextSize( NumDisp2:GetText() )
	NumDisp2:SetPos( 165 - (wid2 / 2), 75 )
	NumDisp2:SetSize( 100, 30 )
	NumDisp2:SetFont( "DermaLarge" )
	
	local function ChangeText( t )
		if NumDisp1:GetText() == "_" and NumDisp2:GetText() == "_" then
			NumDisp1:SetText( t )
			surface.PlaySound( "buttons/blip1.wav" )
		elseif NumDisp1:GetText() != "_" and NumDisp2:GetText() == "_" then
			NumDisp2:SetText( t )
			surface.PlaySound( "buttons/blip1.wav" )
		else
			surface.PlaySound( "buttons/button16.wav" )
		end
	end
	
	local function SendInfo( r )
		net.Start("SendSTCasinoMoney")
			net.WriteString( r )
			net.WriteEntity( ent )
		net.SendToServer()
	end
	
	local function FinishGame()
		local result = NumDisp1:GetText() .. NumDisp2:GetText()
		if NumDisp1:GetText() == "_" or NumDisp2:GetText() == "_" then
			surface.PlaySound( "buttons/button16.wav" )
		else
			if result == randNum then --got both numbers
				surface.PlaySound("buttons/button14.wav")
				SendInfo( "double" )
				CasinoWindow:Close()
			elseif result[1] == randNum[1] or result[2] == randNum[2] then --got one number
				surface.PlaySound("buttons/button15.wav")
				SendInfo( "single" )
				CasinoWindow:Close()
			else --got no numbers
				surface.PlaySound("buttons/button10.wav")
				SendInfo( "loser" )
				CasinoWindow:Close()
			end
		end
	end
	
	local Button1 = vgui.Create( "DButton", CasinoWindow )
	Button1:SetText( "1" )
	Button1:SetPos( 25, 150 )
	Button1:SetSize( 75, 75 )
	Button1:SetFont("DermaLarge")
	Button1.DoClick = function()
		ChangeText("1")
	end
	
	local Button2 = vgui.Create( "DButton", CasinoWindow )
	Button2:SetText( "2" )
	Button2:SetPos( 112, 150 )
	Button2:SetSize( 75, 75 )
	Button2:SetFont("DermaLarge")
	Button2.DoClick = function()
		ChangeText("2")
	end
	
	local Button3 = vgui.Create( "DButton", CasinoWindow )
	Button3:SetText( "3" )
	Button3:SetPos( 200, 150 )
	Button3:SetSize( 75, 75 )
	Button3:SetFont("DermaLarge")
	Button3.DoClick = function()
		ChangeText("3")
	end
	
	local Button4 = vgui.Create( "DButton", CasinoWindow )
	Button4:SetText( "4" )
	Button4:SetPos( 25, 235 )
	Button4:SetSize( 75, 75 )
	Button4:SetFont("DermaLarge")
	Button4.DoClick = function()
		ChangeText("4")
	end
	
	local Button5 = vgui.Create( "DButton", CasinoWindow )
	Button5:SetText( "5" )
	Button5:SetPos( 112, 235 )
	Button5:SetSize( 75, 75 )
	Button5:SetFont("DermaLarge")
	Button5.DoClick = function()
		ChangeText("5")
	end
	
	local Button6 = vgui.Create( "DButton", CasinoWindow )
	Button6:SetText( "6" )
	Button6:SetPos( 200, 235 )
	Button6:SetSize( 75, 75 )
	Button6:SetFont("DermaLarge")
	Button6.DoClick = function()
		ChangeText("6")
	end
	
	local Button7 = vgui.Create( "DButton", CasinoWindow )
	Button7:SetText( "7" )
	Button7:SetPos( 25, 320 )
	Button7:SetSize( 75, 75 )
	Button7:SetFont("DermaLarge")
	Button7.DoClick = function()
		ChangeText("7")
	end
	
	local Button8 = vgui.Create( "DButton", CasinoWindow )
	Button8:SetText( "8" )
	Button8:SetPos( 112, 320 )
	Button8:SetSize( 75, 75 )
	Button8:SetFont("DermaLarge")
	Button8.DoClick = function()
		ChangeText("8")
	end
	
	local Button9 = vgui.Create( "DButton", CasinoWindow )
	Button9:SetText( "9" )
	Button9:SetPos( 200, 320 )
	Button9:SetSize( 75, 75 )
	Button9:SetFont("DermaLarge")
	Button9.DoClick = function()
		ChangeText("9")
	end
	
	local Button0 = vgui.Create( "DButton", CasinoWindow )
	Button0:SetText( "0" )
	Button0:SetPos( 112, 405 )
	Button0:SetSize( 75, 75 )
	Button0:SetFont("DermaLarge")
	Button0.DoClick = function()
		ChangeText("0")
	end
	
	local CallButton = vgui.Create( "DButton", CasinoWindow )
	CallButton:SetText( "CALL" )
	CallButton:SetPos( 200, 405 )
	CallButton:SetSize( 75, 75 )
	CallButton:SetFont("DermaLarge")
	CallButton.DoClick = function()
		FinishGame()
	end
	CallButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 255, 128, 255 ) )
	end
	
	local CloseButton = vgui.Create( "DButton", CasinoWindow )
	CloseButton:SetText( "QUIT" )
	CloseButton:SetPos( 25, 405 )
	CloseButton:SetSize( 75, 75 )
	CloseButton:SetFont("DermaLarge")
	CloseButton.DoClick = function()
		surface.PlaySound("buttons/button10.wav")
		SendInfo( "loser" )
		CasinoWindow:Close()
	end
	CloseButton.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 255, 128, 128, 255 ) )
	end
	
end)

function ENT:Think()
end