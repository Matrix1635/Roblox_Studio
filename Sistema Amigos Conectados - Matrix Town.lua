local Players = game:GetService("Players")
local ScrollingFrame_Amigos = script.Parent.Parent.Frame.ScrollingFrame
local HijosScrillong = ScrollingFrame_Amigos:GetChildren()
--
local BotonCerrarFrameAmigos = script.Parent.Parent.Frame.Cerrar

local BotonMirarAmigosConectados_De_Config = BotonCerrarFrameAmigos.Parent.Parent.Parent.FrameConfig.MirarAmigosConectados

local FrameConfig = BotonCerrarFrameAmigos.Parent.Parent.Parent.FrameConfig

local SonidoClickCerrar = BotonCerrarFrameAmigos:FindFirstChildOfClass("Sound")

local Sonido_MirarAmigosConectados = BotonMirarAmigosConectados_De_Config:FindFirstChildOfClass("Sound")

local Frame_Amigo = script:WaitForChild("FrameJugador")

local ImagenJugando = "rbxasset://textures/AudioDiscovery/done.png"
local ImagenConectado = "rbxasset://textures/AudioDiscovery/ok.png"

function borrarCuenta()
	ScrollingFrame_Amigos:ClearAllChildren()
	wait()
	script.UIPadding:Clone(1) .Parent = ScrollingFrame_Amigos
	script.UIGridLayout:Clone(1) .Parent = ScrollingFrame_Amigos
end

function aparecerDatosNuevos()
	local player = Players.LocalPlayer repeat wait() until player ~= nil
	local amigos = player:GetFriendsOnline(30)
	
	for i, v in ipairs(amigos) do
		local Frame_Amigo_Clonado = Frame_Amigo:Clone()
		local JugandoFrameClonado = Frame_Amigo_Clonado.jugando

		if ScrollingFrame_Amigos:FindFirstChild(v.UserName) ~= nil then
			--Nada
		elseif ScrollingFrame_Amigos:FindFirstChild(v.UserName) == nil then
			Frame_Amigo_Clonado.NombreJugador.Text = tostring(v.UserName)

			if v.LastLocation == "Website" then
				JugandoFrameClonado["Label de Juego"].Visible = false
				JugandoFrameClonado.NombreJuego.Visible = false
				Frame_Amigo_Clonado.Unirse.Visible = false
				Frame_Amigo_Clonado.Conectado.Text = "Conectado"
				Frame_Amigo_Clonado.Estado.Image = ImagenConectado
			elseif v.LastLocation ~= "Website" then
				Frame_Amigo_Clonado.Conectado.Text = "Jugando"
				Frame_Amigo_Clonado.Estado.Image = ImagenJugando
			end

			JugandoFrameClonado.NombreJuego.Text = tostring(v.LastLocation)
			Frame_Amigo_Clonado.Mascara.Text = tostring(v.GameId)
			Frame_Amigo_Clonado.Mascara:FindFirstChildOfClass("IntValue").Value = v.PlaceId
			Frame_Amigo_Clonado.ImagenCara.Image = "https://www.roblox.com/Thumbs/Avatar.ashx?x=450&y=450&Format=Png&username="..v.UserName
			Frame_Amigo_Clonado.Name = tostring(v.UserName)
			Frame_Amigo_Clonado.Parent = ScrollingFrame_Amigos
		end
	end
end

BotonCerrarFrameAmigos.MouseButton1Click:Connect(function()
	BotonCerrarFrameAmigos.Parent.Visible = false
	SonidoClickCerrar:Play()
	borrarCuenta()
end)

BotonMirarAmigosConectados_De_Config.MouseButton1Click:Connect(function()
	FrameConfig.Visible = false
	script.Parent.Parent.Frame.Visible = true
	Sonido_MirarAmigosConectados:Play()
	aparecerDatosNuevos()
end)