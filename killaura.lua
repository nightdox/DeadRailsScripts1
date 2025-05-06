-- Autor: beabadoobee 💀
-- Atualizado: Maio de 2025

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")

local range = 50 -- Distância máxima para detectar inimigos
local enabled = false

-- Interface do botão
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KillAuraGUI_by_beabadoobee"

local toggle = Instance.new("TextButton", gui)
toggle.Name = "ToggleKillAura"
toggle.Size = UDim2.new(0, 140, 0, 40)
toggle.Position = UDim2.new(0, 15, 0, 100)
toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Text = "KillAura: OFF"
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 18

-- Função para encontrar o inimigo mais próximo
local function getClosestEnemy()
    local closestEnemy = nil
    local shortestDistance = range

    for _, enemy in pairs(workspace:GetDescendants()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy ~= char then
            local distance = (HRP.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance and enemy.Humanoid.Health > 0 then
                shortestDistance = distance
                closestEnemy = enemy
            end
        end
    end

    return closestEnemy
end

-- Função para atirar no inimigo
local function shootAt(target)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("RemoteEvent")
        if fireEvent and fireEvent:IsA("RemoteEvent") then
            fireEvent:FireServer(target.HumanoidRootPart.Position)
        end
    end
end

-- Função para recarregar a arma
local function reloadWeapon()
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Reload") then
        tool.Reload:FireServer()
    end
end

-- Loop principal
spawn(function()
    while true do
        wait(0.1)
        if enabled then
            local target = getClosestEnemy()
            if target then
                shootAt(target)
                -- Verifica se a munição acabou e recarrega
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Ammo") and tool.Ammo.Value == 0 then
                    reloadWeapon()
                end
            end
        end
    end
end)

-- Alternar KillAura
toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggle.Text = enabled and "KillAura: ON" or "KillAura: OFF"
    toggle.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

print("[KillAura] Script ativado com sucesso - feito por beabadoobee 💀")
