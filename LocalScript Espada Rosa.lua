local Evento = game:GetService("ReplicatedStorage").EventosRemotos.player.Camara
local TweenService = game:GetService("TweenService")

local Camara = game:GetService("Workspace").CurrentCamera

local TweenInfo_01 = TweenInfo.new(3.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, true, 0.35)
local TweenCamera_Movimiento = TweenService:Create(Camara, TweenInfo_01, {FieldOfView = 80})

Camara.FieldOfView = 50

Evento.OnClientEvent:Connect(function(V)
	if V == "Estocada" then
		Camara.FieldOfView = 50
		Camara.CameraType = Enum.CameraType.Scriptable
		TweenCamera_Movimiento:Play()
		wait()
		TweenCamera_Movimiento.Completed:Connect(function()
			Camara.CameraType = Enum.CameraType.Custom
		end)
	end
end)
