local Evento = script.Parent:FindFirstChildOfClass("RemoteEvent") or script.Parent:WaitForChild("Camara")
local TweenService = game:GetService("TweenService")

local Camara = game:GetService("Workspace").CurrentCamera

local TweenInfo_01 = TweenInfo.new(3.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut, 0, true, 0.35)
local TweenCamera_Movimiento = TweenService:Create(Camara, TweenInfo_01, {FieldOfView = 80})

Camara.FieldOfView = 50--                                                       ,-''`-.
--                                                                             /       `._
Evento.OnClientEvent:Connect(function()--                                __,-'/       _.  `--.
	Camara.FieldOfView = 50--                                          ,'   ,'      ,'  ,--.  )
	Camara.CameraType = Enum.CameraType.Scriptable--                 ,'   ,'       /  ,(  ,/)/
	TweenCamera_Movimiento:Play()--                                 /           ,',;-,-),;('
	wait()--                                                       /      __.-',--'  ,,|/  `-.__
	Camara.CameraType = Enum.CameraType.Custom--                  /  ,      ),',;;  (O)(        `--.
end)--                                                  ,.----.__/_,'      // /O)\  `.  \--'`-.     )
--[[                                                  ,' __         _,.-'  ,/,-     c.' /  `.  `  ,/   .-.
                                                     / ,'         ,'  _,-' (,,-\  -==*'/     )   (      ) \
                                                    ','      ,  ,'  ,'     ,'--`\-.___/.    ,   ( `-..-'   )
                                                    |      ,'   |          ``'\  \ ,    `.       `.      ,'
                                                    | /   /      \        ,' \ )- )      |            --' )
                                                     ||  | .      .      (   //  /       |   ---._      ,'
                                                      `. '. `-.          |  //  |        |   ,--' `-.-.'
                                                        `--:._ `-.._     | //   |     Y  | ,'
                                                                    `'-- )'/    |   ,'  /-'
                                                                        / /     | ,'   /
                                                                       ( (      ,'    '
                                                                       ` `.__ ,'      (
                                                                        `.__,\      ,'"\
                                                                           ,- \ .  /\  ,\
                                                                          '    \  /  )/  `.
                                                                          `.    )/  //     `.
                                                                           Guap@ el que lo lea--]]