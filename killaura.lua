-- Autor: beabadoobee 💀
-- Atualizado em: Maio de 2025
-- Discord: github.com/beabadoobee

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")
local range = 25 -- Distância para atacar inimigos
local damage = 50 -- Dano por ataque
local delay = 0.25 -- Tempo entre os ataques
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

-- Função de ataque
local function attack()
    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
            local hrp = mob.HumanoidRootPart
            if (HRP.Position - hrp.Position).Magnitude <= range and mob ~= char then
                mob.Humanoid:TakeDamage(damage)
            end
        end
    end
end

-- Loop de KillAura
task.spawn(function()
    while true do
        task.wait(delay)
        if enabled then
            pcall(attack)
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
