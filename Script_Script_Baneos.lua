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

local Servicios = {
	Players = game:GetService("Players")
}

local Eventos_Remotos = {
	Evento_GUI_Baneos = game:GetService("ReplicatedStorage").EventosRemotos.player.UI.GUI_Baneos;
	Evento_Nombre_Enviado = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar;
	Evento_Expulsar_Jugador = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar_Jugador
}

local Modulo_G = require(script.Parent.Parent.Modulos.Banear_Expulsar)

Eventos_Remotos.Evento_Nombre_Enviado.OnServerEvent:Connect(function(player, cadena)
	Modulo_G.baneo(cadena)
end)

Eventos_Remotos.Evento_Expulsar_Jugador.OnServerEvent:Connect(function(player, numero, numero_Negativo, nombre_Jugador, El_Nil)
	Modulo_G.decisionfinal(player.Name, numero, numero_Negativo, nombre_Jugador, El_Nil)
end)


Servicios.Players.PlayerRemoving:Connect(function(player)
	Modulo_G.decisionfinal(nil, nil, nil, nil, player.Name)
end)