print("Codificación actual:", os.setlocale())

-- Función para tokenizar una expresión
function tokenizar(expresion)
    local tokens = {}
    local i = 1
    while i <= #expresion do
        local char = expresion:sub(i, i)
        if char:match("%s") then
            -- Ignorar espacios en blanco
            i = i + 1
        elseif char:match("[%d%.]") then
            -- Números (incluyendo decimales)
            local num = char
            i = i + 1
            while i <= #expresion and expresion:sub(i, i):match("[%d%.]") do
                num = num .. expresion:sub(i, i)
                i = i + 1
            end
            table.insert(tokens, num)
        elseif char:match("[%+%-%*/%^%(%)]") then
            -- Operadores y paréntesis
            table.insert(tokens, char)
            i = i + 1
        else
            error("Carácter inválido en la expresión: " .. char)
        end
    end
    return tokens
end

-- Función para convertir una expresión infija a notación postfija (RPN)
function infixToRPN(tokens)
    local precedence = {["+"] = 1, ["-"] = 1, ["*"] = 2, ["/"] = 2, ["^"] = 3}
    local associativity = {["+"] = "L", ["-"] = "L", ["*"] = "L", ["/"] = "L", ["^"] = "R"}
    local output = {}
    local operators = {}

    for _, token in ipairs(tokens) do
        if tonumber(token) then
            table.insert(output, token)
        elseif token == "(" then
            table.insert(operators, token)
        elseif token == ")" then
            while operators[#operators] and operators[#operators] ~= "(" do
                table.insert(output, table.remove(operators))
            end
            table.remove(operators) -- Eliminar el '('
        else
            while operators[#operators] and precedence[operators[#operators]] and
                  ((associativity[token] == "L" and precedence[token] <= precedence[operators[#operators]]) or
                   (associativity[token] == "R" and precedence[token] < precedence[operators[#operators]])) do
                table.insert(output, table.remove(operators))
            end
            table.insert(operators, token)
        end
    end

    while operators[#operators] do
        table.insert(output, table.remove(operators))
    end

    return output
end

-- Función para evaluar una expresión en notación postfija (RPN)
function evaluateRPN(rpn)
    local stack = {}

    for _, token in ipairs(rpn) do
        if tonumber(token) then
            table.insert(stack, tonumber(token))
        else
            local b = table.remove(stack)
            local a = table.remove(stack)
            if not a or not b then
                print("Error: Operando faltante para el operador", token)
                return nil
            end
            if token == "+" then
                table.insert(stack, a + b)
            elseif token == "-" then
                table.insert(stack, a - b)
            elseif token == "*" then
                table.insert(stack, a * b)
            elseif token == "/" then
                table.insert(stack, a / b)
            elseif token == "^" then
                table.insert(stack, a ^ b)
            end
        end
    end

    return stack[1]
end

-- Función principal para evaluar una expresión
function evaluarExpresion(expresion)
    local tokens = tokenizar(expresion)
    local rpn = infixToRPN(tokens)
    return evaluateRPN(rpn)
end

-- Ejemplo de uso
entrada = "=3 + 5 * (2 - 1)"
if entrada:sub(1, 1) == "=" then
    local resultado = evaluarExpresion(entrada:sub(2))
    print("Resultado:", resultado)
else
    print("No es una fórmula")
end

-- Pruebas de diferentes expresiones
pruebas = {
    "=3 + 5 * (2 - 1)",  -- Debería dar 8
    "=10 / 2 + 3",       -- Debería dar 8
    "=(4 + 2) * 3",      -- Debería dar 18
    "=2 ^ 3 + 1",        -- Debería dar 9
    "=7 - 3 * 2",        -- Debería dar 1
    "=(36^(1/2))/3"      -- Debería ser 2
}

for _, prueba in ipairs(pruebas) do
    if prueba:sub(1, 1) == "=" then
        local resultado = evaluarExpresion(prueba:sub(2))
        print("Expresión:", prueba, "Resultado:", resultado)
    else
        print("No es una fórmula")
    end
end