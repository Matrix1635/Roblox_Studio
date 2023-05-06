--[[
        ___       ___       _______    ____________   ______        ___ ___      ___                                                   
       /   \    _/  /     _/  __   /  /____   ____/  /  __  -_     /  / \  \    /  /                                                            
      /    \  _/   /    _/  _/ /_  /      /  /      /  /__l  l    /  /   \  \  /  /       _____                                               
     /     \_/ _  /   _/  _/____/  /     /  /      /  _    _/    /  /     \  \/  /      _l     \                                       
    /  /\    _/  /  _/  ________   /    /  /      /  / \  \     /  /      /  _  /      <_ 1635 l                                               
   /  /  \__//  / _/  _/       /   /   /  /      /  /   \  \   /  /      /  / \  \       l_____/                                     
  /__/      /__/ /___/        /___/   /__/      /__/     \__\ /__/      /__/   \__\
___________________________________________________________________________________
∟__________________________________________________________________________________l
--]]
local Camara = game:GetService("Workspace").CurrentCamera --Se referencia el objeto a mover, en este caso es Camara
local TeweenS = game:GetService("TweenService") --Servicio "TweenService"
--
local info = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut) --La información para el "TeweenS"

local CFrame_Movido --Una Variable In-definida
local Orientacion --Una Variable In-definida
--
--
function convertir_A_Radianes(a, b, c) --Esta función convierte los ángulos de la orientación de Grados a Radianes
	Orientacion = CFrame.Angles(math.rad(a), math.rad(b), math.rad(c))
	task.wait()
	return Orientacion
end
--
function animarMovimientos(V) --Esta función ejecuta la animación de cada movmiento
	local movimiento = TeweenS:Create(Camara, info, V)
	movimiento:Play()
	task.wait(6.05)
end
--
function calcular_CFrame_Movido(a, b, c) --Esta función calcula el CFrame al que se moverá el objeto "CFrame.new(a, b, c) * Orientacion"
	task.wait()
	CFrame_Movido = CFrame.new(a, b, c) * Orientacion
	return CFrame_Movido
end
--
function animarCamara() --Esta función guarda y establece los diferentes movimientos que se harán
	--Camara.CameraType = Enum.CameraType.Scriptable --Primero, hay que establecer la camara al Scriptable para poderla animar
	--
	--      Aquí le estableceremos el punto inicial, el punto de Partida      --
	--                                              --
	convertir_A_Radianes(0, 180, 0)
	calcular_CFrame_Movido(-38.986, 10.862, 99.182)
	local movimiento_inicial = {CFrame = CFrame_Movido}
	
	animarMovimientos(movimiento_inicial)
	task.wait()
	--
	--      Ahora identificaremos los movimientos que querramos hacer         --
	--                                               --
	convertir_A_Radianes(0, 45, 0)
	calcular_CFrame_Movido(184.895, 22.206, 125.918)
	local movimiento_01 = {CFrame = CFrame_Movido}
	
	animarMovimientos(movimiento_01)
	--
	--
	convertir_A_Radianes(0, 135, 0)
	calcular_CFrame_Movido(176.044, 22.216, -117.908)
	local movimiento_02 = {CFrame = CFrame_Movido}
	
	animarMovimientos(movimiento_02)
	--
	--
	convertir_A_Radianes(0, 180, 0)
	calcular_CFrame_Movido(-21.137, 10.85, -147.634)
	local movimiento_03 = {CFrame = CFrame_Movido}
	
	animarMovimientos(movimiento_03)
	--
	--
	convertir_A_Radianes(0, -135, 0)
	calcular_CFrame_Movido(-93.054, 5.96, -89.289)
	local movimiento_04 = {CFrame = CFrame_Movido}
	
	animarMovimientos(movimiento_04)
	--
	--
	convertir_A_Radianes(0, 135, 0)
	calcular_CFrame_Movido(-71.34, 20.058, 68.354)
	local movimiento_05 = {CFrame = CFrame_Movido}

	animarMovimientos(movimiento_05)
	--
	--
	convertir_A_Radianes(0, 180, 0)
	calcular_CFrame_Movido(-38.986, 10.862, 99.182)
	local movimiento_inicial = {CFrame = CFrame_Movido}

	animarMovimientos(movimiento_inicial)
	--
	--
	--[[task.wait(2) --Hacemos si queremos, una espera de "X" tiempo
	Camara.CameraType = Enum.CameraType.Custom --Regresamos la cámara a como estaba
	print("Ha terminado la animación")--]] --Imprimimos un mensaje para corroborar que la funci´no terminó de forma exitosa
end
--
Camara.CameraType = Enum.CameraType.Scriptable
while wait() and script.Parent.Parent.Enabled == true do
	animarCamara()
end