-- Definición de la red neuronal para operaciones matemáticas
local RedNeuronalOperaciones = {}
RedNeuronalOperaciones.__index = RedNeuronalOperaciones

function RedNeuronalOperaciones.new()
	local self = setmetatable({}, RedNeuronalOperaciones)
	-- Pesos y bias para suma
	self.peso1_suma = math.random()
	self.peso2_suma = math.random()
	self.bias_suma = math.random()
	-- Pesos y bias para multiplicación
	self.peso1_mult = math.random()
	self.peso2_mult = math.random()
	self.bias_mult = math.random()
	-- Pesos y bias para división
	self.peso1_div = math.random()
	self.peso2_div = math.random()
	self.bias_div = math.random()
	return self
end

function RedNeuronalOperaciones:forward(x1, x2)
	-- Suma
	local suma = x1 * self.peso1_suma + x2 * self.peso2_suma + self.bias_suma
	-- Multiplicación
	local mult = x1 * self.peso1_mult * x2 * self.peso2_mult + self.bias_mult
	-- División (evitando división por cero)
	local epsilon = 0.0001
	local div = (x1 * self.peso1_div) / (x2 * self.peso2_div + epsilon) + self.bias_div
	return suma, mult, div
end

function RedNeuronalOperaciones:entrenar(datos, etiquetas_suma, etiquetas_mult, etiquetas_div, epochs, lr)
	for i = 1, epochs do
		for j = 1, #datos do
			-- Forward pass
			local suma_pred, mult_pred, div_pred = self:forward(datos[j][1], datos[j][2])
			-- Calcular errores
			local error_suma = etiquetas_suma[j] - suma_pred
			local error_mult = etiquetas_mult[j] - mult_pred
			local error_div = etiquetas_div[j] - div_pred
			-- Actualizar pesos y bias para suma
			self.peso1_suma = self.peso1_suma + error_suma * datos[j][1] * lr
			self.peso2_suma = self.peso2_suma + error_suma * datos[j][2] * lr
			self.bias_suma = self.bias_suma + error_suma * lr
			-- Actualizar pesos y bias para multiplicación
			self.peso1_mult = self.peso1_mult + error_mult * datos[j][1] * lr
			self.peso2_mult = self.peso2_mult + error_mult * datos[j][2] * lr
			self.bias_mult = self.bias_mult + error_mult * lr
			-- Actualizar pesos y bias para división
			self.peso1_div = self.peso1_div + error_div * datos[j][1] * lr
			self.peso2_div = self.peso2_div + error_div * datos[j][2] * lr
			self.bias_div = self.bias_div + error_div * lr
		end
	end
end

-- Datos de entrenamiento para las tres operaciones
local datosOperaciones = {
	{12, 21}, {2, 2}, {3, 3}, {4, 4}, {5, 5}, {6, 6}, {7, 7}, {8, 8}, {9, 9}, {10, 10}, {5.5, 5.5}, {20, 20}, {35, 35},
	{57, 54}, {11,11}, {12,12}, {13,13}, {14, 14}, {15, 15}, {16, 16}
}

-- Etiquetas para las operaciones de suma
local etiquetasSuma = {33, 4, 6, 8, 10, 12, 14, 16, 18, 20, 11, 40, 70, 111, 22, 24, 26, 28, 30, 32}
-- Etiquetas para las operaciones de multiplicación
local etiquetasMult = {252, 4, 9, 16, 25, 36, 49, 64, 81, 100, 30.25, 400, 1225, 3078, 121, 144, 169, 196, 225, 256}
-- Etiquetas para las operaciones de división
local etiquetasDiv = {0.5714, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1.05, 1, 1, 1, 1, 1, 1}

-- Crear y entrenar la red neuronal para las tres operaciones
local redOperaciones = RedNeuronalOperaciones.new()
redOperaciones:entrenar(datosOperaciones, etiquetasSuma, etiquetasMult, etiquetasDiv, 270000, 0.000001)

-- Probar la red neuronal para las tres operaciones
local suma_pred, mult_pred, div_pred = redOperaciones:forward(6, 4)
print("Suma predicha: " .. suma_pred)
print("Multiplicación predicha: " .. mult_pred)
print("División predicha: " .. div_pred)
