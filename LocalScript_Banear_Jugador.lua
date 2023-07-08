local Screen = script.Parent.Parent

local Servicios = {
	--TweenService = game:GetService("TweenService")
}

local Eventos_Remotos = {
	Evento_GUI_Baneos = game:GetService("ReplicatedStorage").EventosRemotos.player.UI.GUI_Baneos;
	Evento_Nombre_Enviado = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar;
	Evento_Expulsar_Jugador = game:GetService("ReplicatedStorage").EventosRemotos.Servidor.Expulsion.Expulsar_Jugador
}

local Frames = {
	Frame_Nombres = Screen.Nombres;
	Frame_Votacion = Screen.Votacion
}

local Elementos = {
	Frame_Nombres = {
		Caja_De_Texto = Frames.Frame_Nombres:FindFirstChildOfClass("TextBox");
		Boton_Enviar = Frames.Frame_Nombres:FindFirstChildOfClass("TextButton");
		Boton_Ojito = Frames.Frame_Nombres:FindFirstChildOfClass("ImageButton")
	};
	Frame_Votacion = {
		Boton_Si = Frames.Frame_Votacion.Si;
		Boton_No = Frames.Frame_Votacion.No;
		Titulo = Frames.Frame_Votacion.Adornos.Titulo;
		Valor_Nombre_Jugador = Frames.Frame_Votacion:FindFirstChildOfClass("StringValue")
	}
}
--
Texto_Nombre_Usuario = ""
Bool = false

local function sacar_Esconder_Frame_Nombres(bool)
	--
	local Position_Normal = UDim2.new(0.747, 0,0.354, 0)
	local Position_Final = UDim2.new(1, 0,0.354, 0)
	
	if bool == true then
		Screen.Nombres:TweenPosition(
			Position_Normal, Enum.EasingDirection.InOut, Enum.EasingStyle.Elastic, 0.5
		)
	elseif bool == false then
		Screen.Nombres:TweenPosition(
			Position_Final, Enum.EasingDirection.InOut, Enum.EasingStyle.Elastic, 0.5
		)
	end
	--
end 

Elementos.Frame_Nombres.Boton_Ojito.MouseButton1Click:Connect(function()
	task.wait(0.2)
	Bool = not Bool
	sacar_Esconder_Frame_Nombres(Bool)
end)

Elementos.Frame_Nombres.Boton_Enviar.MouseButton1Click:Connect(function()
	Eventos_Remotos.Evento_Nombre_Enviado:FireServer(Texto_Nombre_Usuario)
	--
	Bool = not Bool
	sacar_Esconder_Frame_Nombres(Bool)
	--
end)

Eventos_Remotos.Evento_GUI_Baneos.OnClientEvent:Connect(function(cadena)
	local Texto_Titulo = '¿Deseas votar a favor de la expulsión de: ' .. tostring(cadena) .. '?'
	Elementos.Frame_Votacion.Titulo.Text = Texto_Titulo
	Elementos.Frame_Votacion.Valor_Nombre_Jugador.Value = cadena
	
	Frames.Frame_Votacion.Visible = true
	Frames.Frame_Nombres.Visible = false
end)

Elementos.Frame_Votacion.Boton_No.MouseButton1Click:Connect(function()
	Eventos_Remotos.Evento_Expulsar_Jugador:FireServer(0, 1, Elementos.Frame_Votacion.Valor_Nombre_Jugador.Value, nil)
	Frames.Frame_Votacion.Visible = false
	Frames.Frame_Nombres.Visible = true
end)

Elementos.Frame_Votacion.Boton_Si.MouseButton1Click:Connect(function()
	Eventos_Remotos.Evento_Expulsar_Jugador:FireServer(1, 0, Elementos.Frame_Votacion.Valor_Nombre_Jugador.Value, nil)
	Frames.Frame_Votacion.Visible = false
	Frames.Frame_Nombres.Visible = true
end)

--
Elementos.Frame_Nombres.Caja_De_Texto:GetPropertyChangedSignal("Text"):Connect(function()
	Texto_Nombre_Usuario = tostring(Elementos.Frame_Nombres.Caja_De_Texto.Text)
end)