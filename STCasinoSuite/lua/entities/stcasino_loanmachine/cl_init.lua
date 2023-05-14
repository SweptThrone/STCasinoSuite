include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
		
	local txt = "Loan Machine"
	
	surface.SetFont("Trebuchet24") --i know
	local TextWidth = surface.GetTextSize(txt)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 0)
		
	cam.Start3D2D(Pos + Ang:Up() * -3 - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth * 0.5 + 20, -260, txt, "Trebuchet24", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
end

net.Receive("OpenSTLoanMenu", function()

	local loan = net.ReadInt( 32 )
	--PAY LOANS
	if loan != 0 then
		local PayWindow = vgui.Create( "DFrame" )
		PayWindow:SetPos( 5, 5 )
		PayWindow:SetSize( 300, 100 )
		PayWindow:SetTitle( "Loan Payment" )
		PayWindow:SetVisible( true )
		PayWindow:SetDraggable( false )
		PayWindow:ShowCloseButton( false )
		PayWindow:MakePopup()
		PayWindow:Center()
		PayWindow.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
		end
		
		local PayDisplay = vgui.Create( "DLabel", PayWindow )
		PayDisplay:SetPos( 25, 50 )
		PayDisplay:SetSize( 350, 24 )
		PayDisplay:SetText( "Your loan: $" .. loan )
		PayDisplay:Dock(TOP)
		PayDisplay:SetContentAlignment(5)
		
		local LendButton = vgui.Create( "DButton", PayWindow )
		LendButton:SetPos( 25, 50 )
		LendButton:SetSize( 350, 24 )
		LendButton:SetText( "Pay it!" )
		LendButton:Dock(BOTTOM)
		LendButton.DoClick = function( self )
			if LocalPlayer():getDarkRPVar("money") < loan then
				surface.PlaySound("buttons/button8.wav")
			else
				net.Start( "STLoanToServer" )
					net.WriteInt( 0, 32 )
				net.SendToServer()
				surface.PlaySound("buttons/button6.wav")
			end
			PayWindow:Close()
		end
		
		local CloseButton = vgui.Create( "DButton", PayWindow )
		CloseButton:SetPos( 275, 0 )
		CloseButton:SetSize( 25, 20 )
		CloseButton:SetText( "X" )
		CloseButton.DoClick = function( self )
			PayWindow:Close()
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
		
	else
		--BUY LOANS
		local LoanWindow = vgui.Create( "DFrame" )
		LoanWindow:SetPos( 5, 5 )
		LoanWindow:SetSize( 300, 100 )
		LoanWindow:SetTitle( "Loan Menu" )
		LoanWindow:SetVisible( true )
		LoanWindow:SetDraggable( false )
		LoanWindow:ShowCloseButton( false )
		LoanWindow:MakePopup()
		LoanWindow:Center()
		LoanWindow.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
		end
		
		local LoanEntry = vgui.Create( "DTextEntry", LoanWindow )
		LoanEntry:SetPos( 25, 50 )
		LoanEntry:SetSize( 350, 24 )
		LoanEntry:SetText( "Enter loan amount here" )
		LoanEntry:Dock(TOP)
		LoanEntry.OnEnter = function( self )
			if type(tonumber(self:GetValue())) != "number" then
				self:SetText( "Enter a NUMBER!" )
				surface.PlaySound("buttons/button8.wav")
			else
				if tonumber(self:GetValue()) < 1 then self:SetValue( "1" ) end
				if tonumber(self:GetValue()) > 100000000 then self:SetValue( "100000000" ) end
				net.Start( "STLoanToServer" )
					net.WriteInt( tonumber(self:GetValue()), 32 )
				net.SendToServer()
				surface.PlaySound("buttons/button6.wav")
				LoanWindow:Close()
			end
		end
		
		local LendButton = vgui.Create( "DButton", LoanWindow )
		LendButton:SetPos( 25, 50 )
		LendButton:SetSize( 350, 24 )
		LendButton:SetText( "Get loan!" )
		LendButton:Dock(BOTTOM)
		LendButton.DoClick = function( self )
			if type(tonumber(LoanEntry:GetValue())) != "number" then
				LoanEntry:SetText( "Enter a NUMBER!" )
				surface.PlaySound("buttons/button8.wav")
			else
				if tonumber(LoanEntry:GetValue()) < 1 then LoanEntry:SetValue( "1" ) end
				net.Start( "STLoanToServer" )
					net.WriteInt( tonumber(LoanEntry:GetValue()), 32 )
				net.SendToServer()
				surface.PlaySound("buttons/button6.wav")
				LoanWindow:Close()
			end
		end
		
		local CloseButton = vgui.Create( "DButton", LoanWindow )
		CloseButton:SetPos( 275, 0 )
		CloseButton:SetSize( 25, 20 )
		CloseButton:SetText( "X" )
		CloseButton.DoClick = function( self )
			LoanWindow:Close()
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
	end
end)

function ENT:Think()
end