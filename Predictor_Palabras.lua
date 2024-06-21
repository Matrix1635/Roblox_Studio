-- Valor String
valor_string = script:WaitForChild('Value')

-- Lectura de Datos
modulo = require(script.ModuleScript)
texto = modulo.texto

-- Procesamiento de Texto
palabras = {}
for palabra in texto:gmatch("%S+") do
	table.insert(palabras, palabra:lower())
end

-- Entrenamiento del Modelo con Trigramas
frecuencias = {}
palabra_mas_comun = nil
max_frecuencia_global = 0
for i = 1, #palabras - 2 do
	local palabra_actual = palabras[i] .. " " .. palabras[i + 1]
	local palabra_siguiente = palabras[i + 2]
	frecuencias[palabra_actual] = frecuencias[palabra_actual] or {}
	frecuencias[palabra_actual][palabra_siguiente] = (frecuencias[palabra_actual][palabra_siguiente] or 0) + 1
	if frecuencias[palabra_actual][palabra_siguiente] > max_frecuencia_global then
		palabra_mas_comun = palabra_siguiente
		max_frecuencia_global = frecuencias[palabra_actual][palabra_siguiente]
	end
end

-- Predicción de Palabras usando Trigramas
function predecir_siguiente(palabra1, palabra2)
	local clave = palabra1 .. " " .. palabra2
	local opciones = frecuencias[clave]
	if not opciones then
		return palabra_mas_comun
	end
	local max_frecuencia = -1
	local prediccion = nil
	for siguiente, frecuencia in pairs(opciones) do
		if frecuencia > max_frecuencia then
			max_frecuencia = frecuencia
			prediccion = siguiente
		end
	end
	return prediccion
end

-- Solicitar entrada del usuario para una nueva palabra
function solicitar_palabra_nueva(palabra)
	io.write("Veo que me acabas de proporcionar una palabra nueva: '" .. palabra .. "'. ¿Podrías decirme cuál palabra es la más próxima? ")
	local nueva_palabra = io.read()
	return nueva_palabra
end

-- Actualizar la tabla de frecuencias con una nueva palabra
function actualizar_frecuencias(palabra1, palabra2, palabra_siguiente)
	local clave = palabra1 .. " " .. palabra2
	frecuencias[clave] = frecuencias[clave] or {}
	frecuencias[clave][palabra_siguiente] = (frecuencias[clave][palabra_siguiente] or 0) + 1
end

-- Generar una oración completa basada en una palabra inicial
function generar_oracion(palabra1, palabra2, longitud_maxima)
	local oracion = {palabra1, palabra2}
	local palabra_actual1, palabra_actual2 = palabra1, palabra2
	for _ = 1, longitud_maxima - 2 do
		local siguiente_palabra = predecir_siguiente(palabra_actual1, palabra_actual2)
		if not siguiente_palabra or siguiente_palabra == palabra_actual2 then
			break
		end
		table.insert(oracion, siguiente_palabra)
		palabra_actual1, palabra_actual2 = palabra_actual2, siguiente_palabra
	end
	return table.concat(oracion, " ")
end

-- Ejemplo de Uso
local palabra_inicial1 = "hola"
local palabra_inicial2 = "cómo"
local longitud_maxima = 10
local oracion_generada = generar_oracion(palabra_inicial1, palabra_inicial2, longitud_maxima)
print("Oración generada: " .. oracion_generada)

valor_string:GetPropertyChangedSignal('Value'):Connect(function()
	local palabras_iniciales = valor_string.Value:split(" ")
	if #palabras_iniciales >= 2 then
		palabra_inicial1 = palabras_iniciales[1]
		palabra_inicial2 = palabras_iniciales[2]
	else
		palabra_inicial1 = palabras_iniciales[1] or "hola"
		palabra_inicial2 = "cómo"
	end
	oracion_generada = generar_oracion(palabra_inicial1, palabra_inicial2, longitud_maxima)
	print("Oración generada: " .. oracion_generada)
end)
