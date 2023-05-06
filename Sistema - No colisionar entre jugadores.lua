local module = {}

local PhysService = game:GetService("PhysicsService")
local PlayerGroup = PhysService:CreateCollisionGroup("p")
PhysService:CollisionGroupSetCollidable("p","p",false)

function NoCollide(model)
	for k,v in pairs (model:GetChildren()) do
		if v:IsA"BasePart" then
			PhysService:SetPartCollisionGroup(v,"p")
		end
	end
end

function module.noColisionarEntrejUgadores(player, character)
	character:WaitForChild("HumanoidRootPart") repeat wait() until character ~= nil and character:WaitForChild("HumanoidRootPart") or character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart ~= nil
	character:WaitForChild("Head") repeat wait() until character ~= nil and character:WaitForChild("Head") or character.Head or character:FindFirstChild("Head") ~= nil
	character:WaitForChild("Humanoid") repeat wait() until character and character ~= nil and character:WaitForChild("Humanoid") or character:FindFirstChildOfClass("Humanoid") or character.Humanoid ~= nil
	wait(0.1)
	NoCollide(character)

	if character then
		NoCollide(character)
	end
end

return module