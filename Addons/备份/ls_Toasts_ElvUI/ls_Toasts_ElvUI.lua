if not IsAddOnLoaded 'ls_Toasts' then return end

local LST = unpack(ls_Toasts)

function LST:SkinToast(toast, toastType)
	toast.Border:SetAlpha(1)
	toast.TextBG:SetAlpha(1)
	toast.BG:SetAlpha(1)
	toast.Border:SetTexture([[Interface\AddOns\ls_Toasts_ElvUI\media\toast-border.tga]])
	toast.Icon:SetTexCoord(.08, .92, .08, .92)
	toast.Title:SetFont([[Interface\AddOns\ls_Toasts_ElvUI\media\PT_Sans_Narrow.ttf]], 16)
	toast.Title:SetPoint("TOPLEFT", 55, -12)
	
	if toast.IconBorder then
		local r, g, b = toast.IconBorder:GetVertexColor()
		if r > 0.99 and g > 0.99 and b > 0.99 then
			toast.IconBorder:SetVertexColor(0, 0, 0, 1)
		end
		toast.IconBorder:SetTexture([[Interface\AddOns\ls_Toasts_ElvUI\media\icon-border.tga]])
		toast.IconBorder:SetTexCoord(0, 1, 0, 1)
	end
end
