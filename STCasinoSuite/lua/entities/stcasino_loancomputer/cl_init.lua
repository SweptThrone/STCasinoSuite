include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	local Pos2 = Vector(Pos.x, Pos.y + 4, Pos.z+17)
		
	local txt = "Loans Database"
	
	surface.SetFont("Trebuchet18")
	local TextWidth = surface.GetTextSize(txt)
	
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)
		
	cam.Start3D2D(Pos + Ang:Up() - Ang:Right() * 15, Ang, 0.16)
		draw.WordBox(4, -TextWidth*0.5 -4, -90, txt, "Trebuchet18", Color(0, 0, 0, 100), Color(255,255,255,255))
	cam.End3D2D()
	
end

net.Receive("OpenSTLoanMonitor", function()

	local LMWindow = vgui.Create( "DFrame" )
	LMWindow:SetPos( 5, 5 )
	LMWindow:SetSize( ScrW() * 0.25, ScrH() * 0.25 )
	LMWindow:SetTitle( "Loan Menu" )
	LMWindow:SetVisible( true )
	LMWindow:SetDraggable( false )
	LMWindow:ShowCloseButton( true )
	LMWindow:MakePopup()
	LMWindow:Center()
	LMWindow:ShowCloseButton( true )
	LMWindow.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 44, 91, 51, 255 ) )
	end
	
    local LoanList = vgui.Create( "DListView", LMWindow )
	LoanList:Dock(FILL)
	LoanList:AddColumn("Name")
	LoanList:AddColumn("Loan")
	LoanList:SetMultiSelect( false )
	for k,v in pairs(player.GetAll()) do
		LoanList:AddLine( net.ReadEntity():Name(), net.ReadInt(32) )
	end
	
end)

function ENT:Think()
end