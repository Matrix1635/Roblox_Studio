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

local module = {}

local Servicios = {
	Players = game:GetService("Players")
}

local Eventos_Remotos = {
	Evento_GUI_Baneos = game:GetService("ReplicatedStorage").EventosRemotos.player.UI.GUI_Baneos;
	Evento_Nombre_Enviado = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar;
	Evento_Expulsar_Jugador = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar_Jugador
}

local conteo = 0
local conteo_Favor_A_No = 0

local Tabla_Nombres = {}

function module.baneo(cadena)
	--
	local Tabla_nombres_Jugadores = {}
	
	function Tabla_nombres_Jugadores:FindString(Str_cadena)
		for _, nombre in pairs(Tabla_nombres_Jugadores) do
			if nombre == Str_cadena then
				return true
			end
		end
		return false
	end
	--
	for _, jugador in pairs(Servicios.Players:GetChildren()) do
		table.insert(Tabla_nombres_Jugadores, jugador.Name)
	end
	--
	if Tabla_nombres_Jugadores:FindString(cadena) then
		--Devolvieron true
		Eventos_Remotos.Evento_GUI_Baneos:FireAllClients(cadena)
	else
		--Devolvieron false
	end
	
	--
end

function module.decisionfinal(Nombrejugador, numero, numero_Negativo, nombre_Jugador, jugadorSalido)
	print(Nombrejugador, numero, numero_Negativo, nombre_Jugador, jugadorSalido, conteo, conteo_Favor_A_No)
	--
	if jugadorSalido ~= nil then
		--
		print("Un jugador ha salido, es: ".. jugadorSalido)
		--
		for _, nombre in pairs(Tabla_Nombres) do
			--
			if nombre == jugadorSalido then
				--
				conteo = 0
				conteo_Favor_A_No = 0
				Tabla_Nombres = {}
				--
				for indice, valor in ipairs(Tabla_Nombres) do
					--
					if valor == jugadorSalido then
						table.remove(Tabla_Nombres, indice)
						break
					end
					--
				end
				--
			end
			--
		end
		--
	elseif jugadorSalido == nil then
		--
		print("Ningún jugador ha salido")
		--
		local Numero_jugadores = Servicios.Players:GetChildren()
		print("Hay: " .. tostring(#Numero_jugadores) .. " jugadores en el servidor")

		if Servicios.Players:FindFirstChild(Nombrejugador) then
			--
			print("El jugador: " .. Nombrejugador .. " si existe")
			--
			if table.find(Tabla_Nombres, Nombrejugador) then
				print("Ya se registró tu respuesta anteriormente")
			else
				table.insert(Tabla_Nombres, Nombrejugador)
				print("El jugador que votó ha sido añadido a la tabla")
				conteo = conteo + numero
				conteo_Favor_A_No = conteo_Favor_A_No + numero_Negativo
			end

			--
			print(conteo, conteo_Favor_A_No)
			--
		else
			--
			print("El jugador: " .. Nombrejugador .. " no fue encontrado")
			--
		end
		--
		print("Contando:")
		--
		if conteo >= ((#Numero_jugadores)/2) --[[ and conteo > conteo_Favor_A_No --]] then
			--
			print("El conteo positivo es de: " .. conteo .. " y es mayor a: " .. tostring(((#Numero_jugadores)/2)))
			--
			conteo = 0
			--
			if Servicios.Players:FindFirstChild(nombre_Jugador) then
				print("Expulsión del jugador: " .. nombre_Jugador)
				Servicios.Players:FindFirstChild(nombre_Jugador):Kick("Has sido expulsado por votación, por violar las reglas del juego")
			end
			--
			print(conteo)
			--
			--[[elseif conteo < ((#Numero_jugadores)/2) and conteo <= conteo_Favor_A_No then--]]
		elseif conteo_Favor_A_No >= ((#Numero_jugadores)/2) then
			--
			print("El conteo a favor a No es: " .. conteo_Favor_A_No .. " y el numero de jugadores es: " .. tostring(((#Numero_jugadores)/2)))
			--
			conteo = 0
			conteo_Favor_A_No = 0
			Tabla_Nombres = {}
			--
			--end
		end
		--
		--
	end
end


return module