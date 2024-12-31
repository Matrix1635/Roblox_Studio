local module = {}

-- Función auxiliar para formatear fecha
local function formatearFechaHora()
	local tiempo = os.date("*t")  -- Obtiene tabla con fecha y hora
	return string.format("%02d/%02d/%02d %02d:%02d", 
		tiempo.day,      -- Día
		tiempo.month,    -- Mes 
		tiempo.year % 100,  -- Año (últimos dos dígitos)
		tiempo.hour,     -- Hora
		tiempo.min       -- Minutos
	)
end

-- Helper function to convert column letter to number
local function columnaToNumero(col)
	local numero = 0
	for i = 1, #col do
		numero = numero * 26 + (col:byte(i) - 64)
	end
	return numero
end

-- Helper function to convert number back to column letter
local function numeroToColumna(num)
	local col = ""
	while num > 0 do
		local rem = (num - 1) % 26
		col = string.char(65 + rem) .. col
		num = math.floor((num - rem) / 26)
	end
	return col
end

-- Function to generate range of cells
local function generarRango(inicio, fin)
	local rango = {}
	local inicioColumna = inicio:match("%a+")
	local finColumna = fin:match("%a+")
	local inicioFila = tonumber(inicio:match("%d+"))
	local finFila = tonumber(fin:match("%d+"))

	if inicioColumna == finColumna then
		-- Vertical range (same column)
		for i = inicioFila, finFila do
			table.insert(rango, inicioColumna .. i)
		end
	else
		-- Horizontal range (same row)
		local inicioColumnaNum = columnaToNumero(inicioColumna)
		local finColumnaNum = columnaToNumero(finColumna)
		for i = inicioColumnaNum, finColumnaNum do
			table.insert(rango, numeroToColumna(i) .. inicioFila)
		end
	end

	return rango
end

-- Updated tokenization to handle complex expressions
function module.tokenizar(expresion)
	local tokens = {}
	local i = 1
	while i <= #expresion do
		local char = expresion:sub(i, i)
		if char:match("%s") then
			i = i + 1
		elseif char:match("[%d%.]") then
			local num = char
			i = i + 1
			while i <= #expresion and expresion:sub(i, i):match("[%d%.]") do
				num = num .. expresion:sub(i, i)
				i = i + 1
			end
			table.insert(tokens, {type = "number", value = tonumber(num)})
		elseif char:match("[A-Z]") then
			local ref = char
			i = i + 1
			while i <= #expresion and expresion:sub(i, i):match("[A-Z0-9:]") do
				ref = ref .. expresion:sub(i, i)
				i = i + 1
			end
			-- Check if it's a function or cell reference
			if expresion:sub(i, i) == '(' then
				table.insert(tokens, {type = "function", value = ref})
			else
				table.insert(tokens, {type = "identifier", value = ref})
			end
		elseif char:match("[%+%-%*/%^%(%):,]") then
			table.insert(tokens, {type = "operator", value = char})
			i = i + 1
		else
			error("Carácter inválido en la expresión: " .. char)
		end
	end
	return tokens
end

-- Parse function arguments
local function parsearArgumentosFuncion(tokens, indiceInicio)
	local argumentos = {}
	local nivelParentesis = 0
	local argumentoActual = {}

	for i = indiceInicio + 2, #tokens do  -- Skip function name and opening parenthesis
		local token = tokens[i]

		if token.type == "operator" and token.value == '(' then
			nivelParentesis = nivelParentesis + 1
		elseif token.type == "operator" and token.value == ')' then
			nivelParentesis = nivelParentesis - 1

			-- Procesar último argumento si existe
			if #argumentoActual > 0 then
				table.insert(argumentos, argumentoActual)
			end

			if nivelParentesis < 0 then
				return argumentos, i
			end
		elseif token.type == "operator" and token.value == ',' and nivelParentesis == 0 then
			-- Separador de argumentos al nivel de función
			table.insert(argumentos, argumentoActual)
			argumentoActual = {}
		else
			table.insert(argumentoActual, token)
		end
	end

	return argumentos, #tokens
end

-- Obtener precedencia de operadores
local function obtenerPrecedencia(operador)
	if operador == "^" then return 4
	elseif operador == "*" or operador == "/" then return 3
	elseif operador == "+" or operador == "-" then return 2
	elseif operador == "(" then return 1
	else return 0 end
end

-- Convertir a notación postfija (Shunting Yard)
function module.convertirAPostfija(tokens)
	local salida = {}
	local operadores = {}
	local i = 1

	while i <= #tokens do
		local token = tokens[i]

		if token.type == "number" or token.type == "identifier" then
			table.insert(salida, token)
		elseif token.type == "function" then
			-- Parsear argumentos de la función
			local argumentos, nuevoIndice = parsearArgumentosFuncion(tokens, i)

			-- Convertir cada argumento a postfija
			local argumentosPostfija = {}
			for _, argTokens in ipairs(argumentos) do
				local argPostfija = module.convertirAPostfija(argTokens)
				table.insert(argumentosPostfija, argPostfija)
			end

			-- Agregar token de función con sus argumentos
			table.insert(salida, {
				type = "function",
				value = token.value,
				argumentos = argumentosPostfija
			})

			i = nuevoIndice
		elseif token.type == "operator" and token.value == "(" then
			table.insert(operadores, token)
		elseif token.type == "operator" and token.value == ")" then
			while #operadores > 0 and operadores[#operadores].value ~= "(" do
				table.insert(salida, table.remove(operadores))
			end
			if #operadores > 0 and operadores[#operadores].value == "(" then
				table.remove(operadores)
			end
		elseif token.type == "operator" then
			while #operadores > 0 and 
				operadores[#operadores].value ~= "(" and 
				obtenerPrecedencia(operadores[#operadores].value) >= obtenerPrecedencia(token.value) do
				table.insert(salida, table.remove(operadores))
			end
			table.insert(operadores, token)
		end

		i = i + 1
	end

	while #operadores > 0 do
		table.insert(salida, table.remove(operadores))
	end

	return salida
end

-- Evaluar expresión en notación postfija
function module.evaluarPostfija(postfija, obtenerValorCelda)
	local pila = {}
	for _, token in ipairs(postfija) do
		if token.type == "number" then
			table.insert(pila, token.value)
		elseif token.type == "identifier" then
			local valor = obtenerValorCelda(token.value)
			table.insert(pila, valor)
		elseif token.type == "function" then
			local argumentosEvaluados = {}
			-- Evaluar argumentos
			for _, argPostfija in ipairs(token.argumentos) do
				local valorArg = module.evaluarPostfija(argPostfija, obtenerValorCelda)
				table.insert(argumentosEvaluados, valorArg)
			end
			-- Ejecutar función de SUMA
			if token.value == "SUMA" then
				local suma = 0
				for _, arg in ipairs(argumentosEvaluados) do
					if token.argumentos[1][1].type == "identifier" and 
						token.argumentos[1][1].value:find(":") then
						-- Es un rango de celdas, genera rango primero
						local inicio, fin = token.argumentos[1][1].value:match("([^:]+):([^:]+)")
						local rango = generarRango(inicio, fin)
						for _, celda in ipairs(rango) do
							local valorCelda = obtenerValorCelda(celda)
							suma = suma + (type(valorCelda) == "number" and valorCelda or 0)
						end
					else
						-- Argumentos normales
						if type(arg) == "table" then
							for _, val in ipairs(arg) do
								suma = suma + (type(val) == "number" and val or 0)
							end
						else
							suma = suma + (type(arg) == "number" and arg or 0)
						end
					end
				end
				table.insert(pila, suma)
			elseif token.value == "PROMEDIO" then
    			local suma = 0
   				local contador = 0
    			for _, arg in ipairs(argumentosEvaluados) do
        			if token.argumentos[1][1].type == "identifier" and 
            			token.argumentos[1][1].value:find(":") then
            			-- Es un rango de celdas, genera rango primero
            			local inicio, fin = token.argumentos[1][1].value:match("([^:]+):([^:]+)")
           				local rango = generarRango(inicio, fin)
            			for _, celda in ipairs(rango) do
                			local valorCelda = obtenerValorCelda(celda)
                			if type(valorCelda) == "number" then
                    			suma = suma + valorCelda
                    			contador = contador + 1
                			end
            			end
        			else
           				 -- Argumentos normales
            			if type(arg) == "table" then
                		for _, val in ipairs(arg) do
                    		if type(val) == "number" then
                        		suma = suma + val
                        		contador = contador + 1
                    		end
                		end
            			else
                			if type(arg) == "number" then
                    			suma = suma + arg
                    			contador = contador + 1
                			end
            			end
        			end
    			end
    
    			-- Evitar división por cero
    			if contador > 0 then
        			table.insert(pila, suma / contador)
    			else
        			table.insert(pila, 0)
				end
				-- En la función evaluarPostfija, añadir el manejo de la función AHORA
			elseif token.value == "AHORA" then
				-- Verificar que no tenga argumentos
				if #argumentosEvaluados > 0 then
					error("AHORA() no acepta argumentos")
				end
				-- Insertar fecha y hora formateada
				table.insert(pila, formatearFechaHora())
				-- Nueva función CONTAR()
			elseif token.value == "CONTAR" then
				local contador = 0
				for _, arg in ipairs(argumentosEvaluados) do
					if token.argumentos[1][1].type == "identifier" and 
						token.argumentos[1][1].value:find(":") then
						-- Es un rango de celdas
						local inicio, fin = token.argumentos[1][1].value:match("([^:]+):([^:]+)")
						local rango = generarRango(inicio, fin)
						for _, celda in ipairs(rango) do
							-- Contar solo celdas con números
							if tonumber(script.CasillasCeldas.Value:WaitForChild('Contenedor')[celda].Text) ~= nil then
								contador = contador +1
							end
						end
					end
				end
				table.insert(pila, contador)

				-- Nueva función CONTAR.BLANCO()
			elseif token.value == "CONTARBLANCO" then
				local contador = 0
				for _, arg in ipairs(argumentosEvaluados) do
					if token.argumentos[1][1].type == "identifier" and 
						token.argumentos[1][1].value:find(":") then
						-- Es un rango de celdas
						local inicio, fin = token.argumentos[1][1].value:match("([^:]+):([^:]+)")
						local rango = generarRango(inicio, fin)
						for _, celda in ipairs(rango) do
							local valorCelda = obtenerValorCelda(celda, true)
							if valorCelda == nil or valorCelda == "" or valorCelda == 0 then
								contador = contador + 1
							end
						end
					end
				end
				table.insert(pila, contador)

				-- Nueva función CONTARA()
			elseif token.value == "CONTARA" then
				local contador = 0
				for _, arg in ipairs(argumentosEvaluados) do
					if token.argumentos[1][1].type == "identifier" and 
						token.argumentos[1][1].value:find(":") then
						-- Es un rango de celdas
						local inicio, fin = token.argumentos[1][1].value:match("([^:]+):([^:]+)")
						local rango = generarRango(inicio, fin)
						for _, celda in ipairs(rango) do
							local valorCelda = obtenerValorCelda(celda, true)
							-- Contar celdas que no están vacías o son cero
							if valorCelda ~= nil and valorCelda ~= "" then
								contador = contador + 1
							end
						end
					end
				end
				table.insert(pila, contador)
			else
				error("Función no soportada: " .. token.value)
			end
		elseif token.type == "operator" then
			if #pila < 2 and token.value ~= "-" then
				error("Expresión inválida: operandos insuficientes")
			end
			local b = table.remove(pila)
			local a = table.remove(pila)
			local resultado
			if token.value == "+" then resultado = a + b
			elseif token.value == "-" then
				if a == nil then
					resultado = -b  -- Manejar operador unario
				else
					resultado = a - b
				end
			elseif token.value == "*" then resultado = a * b
			elseif token.value == "/" then resultado = a / b
			elseif token.value == "^" then resultado = a ^ b
			end
			table.insert(pila, resultado)
		end
	end
	if #pila ~= 1 then
		error("Expresión inválida")
	end
	return pila[1]
end

-- Función principal para evaluar expresiones
function module.evaluarExpresion(expresion, obtenerValorCelda)
	-- Remover el signo '=' inicial si está presente
	if expresion:sub(1, 1) == "=" then
		expresion = expresion:sub(2)
	end

	-- Validar que los rangos de celdas estén dentro de una función con paréntesis
	if expresion:find("%a%d+:%a%d+") and not expresion:find("%b()") then
		return "#SINTAXIS!"
	end

	-- Manejar el caso de un número negativo precedido por un signo igual
	if expresion:match("^%-?%d+$") then
		return tonumber(expresion)
	end

	local tokens = module.tokenizar(expresion)
	local postfija = module.convertirAPostfija(tokens)
	return module.evaluarPostfija(postfija, obtenerValorCelda)
end

return module