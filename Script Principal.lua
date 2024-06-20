local Evento = game:GetService("ReplicatedStorage").EventosRemotos.player.Camara

Tool = script.Parent
Handle = Tool:WaitForChild("Handle")

function Create(ty)
	return function(info)
		local obj = Instance.new(ty)
		for k, v in pairs(info) do
			if type(k) == 'number' then
				v.Parent = obj
			else
				obj[k] = v
			end
		end
		return obj
	end
end

local BaseUrl = "rbxassetid://"

Players = game:GetService("Players")
Debris = game:GetService("Debris")
RunService = game:GetService("RunService")

valores_Ataque = {
	default = 5,
	ataquesonidoAtaque_01 = 10,
	estocada = 30
}

animacion_Iations = {
	R15sonidoAtaque_01 = 13207451943,
	R15sonido_estocada = 13207474925
}

Ataque = valores_Ataque.default

Palancas = {
	Accion = CFrame.new(0, 0, -1.70000005, 0, 0, 1, 1, 0, 0, 0, 1, 0),
	Salida = CFrame.new(0, 0, -1.70000005, 0, 1, 0, 1, -0, 0, 0, 0, -1)
}

sonidos = {
	sonidoAtaque_01 = Handle:WaitForChild("SwordsonidoAtaque_01"),
	sonido_estocada = Handle:WaitForChild("Swordsonido_estocada"),
	despliege = Handle:WaitForChild("despliege")
}

EspadaEquipadaBool = false

for i, v in pairs(Handle:GetChildren()) do
	if v:IsA("ParticleEmitter") then
		v.Rate = 20
	end
end

Tool.Grip = Palancas.Accion
Tool.Enabled = true

function accion(Hit)
	if not Hit or not Hit.Parent or not checkSiVive() or not EspadaEquipadaBool then
		return
	end
	local RightArm = Character:FindFirstChild("Right Arm") or Character:FindFirstChild("RightHand")
	if not RightArm then
		return
	end
	local RightGrip = RightArm:FindFirstChild("RightGrip")
	if not RightGrip or (RightGrip.Part0 ~= Handle and RightGrip.Part1 ~= Handle) then
		return
	end
	local character = Hit.Parent
	if character == Character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health == 0 then
		return
	end
	humanoid:TakeAtaque(Ataque)	
end


function Atacar(Humanoid)
	Ataque = valores_Ataque.ataquesonidoAtaque_01
	sonidos.sonidoAtaque_01:Play()

	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			local animacion_I = Instance.new("StringValue")
			animacion_I.Name = "toolanimacion_I"
			animacion_I.Value = "sonidoAtaque_01"
			animacion_I.Parent = Tool
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
			local animar = Humanoid:LoadAnimation(Tool.R15Slash); animar.Looped = false; animar:Play()
		end
	end	
end

function sonido_estocada(Humanoid)
	Ataque = valores_Ataque.estocada

	sonidos.sonido_estocada:Play()
	
	if Humanoid then
		if Humanoid.RigType == Enum.HumanoidRigType.R6 then
			local animacion_I = Instance.new("StringValue")
			animacion_I.Name = "toolanimacion_I"
			animacion_I.Value = "sonido_estocada"
			animacion_I.Parent = Tool
		elseif Humanoid.RigType == Enum.HumanoidRigType.R15 then
			Evento:FireAllClients("Estocada")
			local animar = Humanoid:LoadAnimation(Tool.R15Lunge); animar.Looped = false; animar:Play()
		end
	end	
	
	wait(0.2)
	wait(0.6)

	Ataque = valores_Ataque.ataquesonidoAtaque_01
end

Tool.Enabled = true
LastAtacar = 0

function activada()
	if not Tool.Enabled or not EspadaEquipadaBool or not checkSiVive() then
		return
	end
	Tool.Enabled = false
	
	local Jugador = game:GetService("Players"):GetPlayerFromCharacter(Tool.Parent)
	local Humanoid = Jugador.Character:FindFirstChildOfClass("Humanoid") repeat wait() until Humanoid ~= nil
	
	local Tick = RunService.Stepped:wait()
	if (Tick - LastAtacar < 0.2) then
		sonido_estocada(Humanoid)
	else
		Atacar(Humanoid)
	end
	LastAtacar = Tick
	Ataque = valores_Ataque.default
	Tool.Enabled = true
end

function checkSiVive()
	return (((Player and Player.Parent and Character and Character.Parent and Humanoid and Humanoid.Parent and Humanoid.Health > 0 and Torso and Torso.Parent) and true) or false)
end

function equipada()
	Character = Tool.Parent
	
	if Character:FindFirstChildOfClass("StringValue") then
		if Character:FindFirstChildOfClass("StringValue").Value == "MatrizaNebet" then
			--
		elseif Character:FindFirstChildOfClass("StringValue").Value == "MatrizaEriz" then
			Tool:Remove()
			Players:GetPlayerFromCharacter(Character):FindFirstChild(Tool.Name):Remove()
		end
	end
	
	Player = Players:GetPlayerFromCharacter(Character)
	Humanoid = Character:FindFirstChildOfClass("Humanoid")
	Torso = Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart")
	Character:FindFirstChild("EspadaAccessory"):FindFirstChildOfClass("Part").Transparency = 1
	if not checkSiVive() then
		return
	end
	EspadaEquipadaBool = true
	sonidos.despliege:Play()
end

function desequipada()
	Tool.Grip = Palancas.Accion
	EspadaEquipadaBool = false
	wait()
	local nombreDelJugador = Tool.Parent.Parent.Name
	local Character = game:GetService("Workspace"):FindFirstChild(nombreDelJugador) repeat wait() until Character
	Character:FindFirstChild("EspadaAccessory"):FindFirstChildOfClass("Part").Transparency = 0
end

Tool.Activated:Connect(activada)
Tool.Equipped:Connect(equipada)
Tool.Unequipped:Connect(desequipada)

Coneccion = Handle.Touched:Connect(accion)
