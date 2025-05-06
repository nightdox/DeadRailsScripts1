-- Autor: beabadoobee 💀
-- Atualizado: Maio de 2025

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local HRP = char:WaitForChild("HumanoidRootPart")
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local tool = char:FindFirstChildOfClass("Tool") -- Ferramenta do personagem

local range = 50 -- Distância máxima para detectar inimigos
local enabled = false
local autoReloadEnabled = true -- Controle do auto-reload
local movementSpeed = 1 -- Controle da velocidade de movimento (100% inicial)
local reloadEvent = ReplicatedStorage:WaitForChild("ReloadEvent") -- Evento de recarga (ajustar conforme necessário)

-- Interface do botão
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KillAuraGUI_by_beabadoobee"
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo decorado do painel
local panelBackground = Instance.new("Frame", gui)
panelBackground.Name = "PanelBackground"
panelBackground.Size = UDim2.new(0, 200, 0, 460)
panelBackground.Position = UDim2.new(0, 15, 0, 100)
panelBackground.BackgroundColor3 = Color3.fromRGB(26, 35, 45) -- Cor escura
panelBackground.BorderColor3 = Color3.fromRGB(0, 128, 0) -- Cor do ChatGPT (verde suave)
panelBackground.BorderSizePixel = 5
panelBackground.BackgroundTransparency = 0.2
panelBackground.ClipsDescendants = true
panelBackground.AnchorPoint = Vector2.new(0, 0)

-- Título com o nome
local title = Instance.new("TextLabel", panelBackground)
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(0, 128, 0) -- Verde suave (ChatGPT)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = "KillAura\nby beabadoobee 💀"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextWrapped = true
title.TextYAlignment = Enum.TextYAlignment.Center

-- Botão Hide Script
local toggleHideScriptButton = Instance.new("TextButton", panelBackground)
toggleHideScriptButton.Name = "HideScriptButton"
toggleHideScriptButton.Size = UDim2.new(0, 180, 0, 40)
toggleHideScriptButton.Position = UDim2.new(0.5, -90, 0, 40)
toggleHideScriptButton.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
toggleHideScriptButton.TextColor3 = Color3.new(1, 1, 1)
toggleHideScriptButton.Text = "Hide Script"
toggleHideScriptButton.Font = Enum.Font.SourceSansBold
toggleHideScriptButton.TextSize = 18

-- Botão KillAura
local toggleKillAura = Instance.new("TextButton", panelBackground)
toggleKillAura.Name = "ToggleKillAura"
toggleKillAura.Size = UDim2.new(0, 140, 0, 40)
toggleKillAura.Position = UDim2.new(0.5, -70, 0, 90)
toggleKillAura.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggleKillAura.TextColor3 = Color3.new(1, 1, 1)
toggleKillAura.Text = "KillAura: OFF"
toggleKillAura.Font = Enum.Font.SourceSansBold
toggleKillAura.TextSize = 18

-- Botão Auto-Reload
local toggleAutoReload = Instance.new("TextButton", panelBackground)
toggleAutoReload.Name = "ToggleAutoReload"
toggleAutoReload.Size = UDim2.new(0, 140, 0, 40)
toggleAutoReload.Position = UDim2.new(0.5, -70, 0, 140)
toggleAutoReload.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
toggleAutoReload.TextColor3 = Color3.new(1, 1, 1)
toggleAutoReload.Text = "AutoReload: ON"
toggleAutoReload.Font = Enum.Font.SourceSansBold
toggleAutoReload.TextSize = 18

-- Controle de velocidade de movimento (Mov Speed)
local speedControl = Instance.new("Frame", panelBackground)
speedControl.Name = "SpeedControl"
speedControl.Size = UDim2.new(0, 180, 0, 40)
speedControl.Position = UDim2.new(0.5, -90, 0, 190)
speedControl.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedControl.BorderColor3 = Color3.fromRGB(0, 128, 0)
speedControl.BorderSizePixel = 2

local speedLabel = Instance.new("TextLabel", speedControl)
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(0, 40, 1, 0)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundColor3 = Color3.fromRGB(0, 128, 0)
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.Text = "Speed"
speedLabel.Font = Enum.Font.SourceSansBold
speedLabel.TextSize = 18
speedLabel.TextXAlignment = Enum.TextXAlignment.Center
speedLabel.TextYAlignment = Enum.TextYAlignment.Center

local speedSlider = Instance.new("Slider", speedControl)
speedSlider.Size = UDim2.new(0, 140, 0, 5)
speedSlider.Position = UDim2.new(0, 40, 0, 18)
speedSlider.BackgroundColor3 = Color3.fromRGB(0, 128, 0)

-- Função para alterar a velocidade do movimento
local function setMovementSpeed(speed)
    movementSpeed = speed / 100
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16 * movementSpeed -- Ajusta a velocidade do personagem
    end
end

-- Atualiza a velocidade de movimento com o controle deslizante
speedSlider.Changed:Connect(function()
    setMovementSpeed(speedSlider.Value)
end)

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
    if tool and tool:FindFirstChild("Handle") then
        local fireEvent = tool:FindFirstChild("Fire") or tool:FindFirstChild("RemoteEvent")
        if fireEvent and fireEvent:IsA("RemoteEvent") then
            -- Aciona o disparo no servidor com a posição do inimigo
            fireEvent:FireServer(target.HumanoidRootPart.Position)
        end
    end
end

-- Função para recarregar a arma
local function reloadWeapon()
    if reloadEvent then
        reloadEvent:FireServer() -- Usa o evento de recarga do servidor
    end
end

-- Função de disparo automático
local function autoShoot()
    while enabled do
        wait(0.1)
        local target = getClosestEnemy()
        if target then
            shootAt(target)
            -- Verifica se a munição acabou e recarrega se o auto-reload estiver ativado
            if autoReloadEnabled then
                local tool = char:FindFirstChildOfClass("Tool")
                if tool and tool:FindFirstChild("Ammo") and tool.Ammo.Value == 0 then
                    reloadWeapon()
                end
            end
        end
    end
end

-- Alternar KillAura
toggleKillAura.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleKillAura.Text = enabled and "KillAura: ON" or "KillAura: OFF"
    toggleKillAura.BackgroundColor3 = enabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)

    if enabled then
        -- Iniciar o disparo automático
        spawn(autoShoot)
    end
end)

-- Alternar Auto-Reload
toggleAutoReload.MouseButton1Click:Connect(function()
    autoReloadEnabled = not autoReloadEnabled
    toggleAutoReload.Text = autoReloadEnabled and "AutoReload: ON" or "AutoReload: OFF"
    toggleAutoReload.BackgroundColor3 = autoReloadEnabled and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(100, 0, 0)
end)

-- Função para destruir a GUI
local function destroyGUI()
    gui:Destroy()
end

-- Botão para destruir a GUI
local destroyButton = Instance.new("TextButton", panelBackground)
destroyButton.Name = "DestroyButton"
destroyButton.Size = UDim2.new(0, 140, 0, 40)
destroyButton.Position = UDim2.new(0.5, -70, 0, 370)
destroyButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
destroyButton.TextColor3 = Color3.new(1, 1, 1)
destroyButton.Text = "Destroy GUI"
destroyButton.Font = Enum.Font.SourceSansBold
destroyButton.TextSize = 18

destroyButton.MouseButton1Click:Connect(destroyGUI)

-- Função para esconder ou mostrar a GUI
local function toggleHideScript()
    gui.Enabled = not gui.Enabled
end

-- Detecta pressionamento do "Control Esquerdo" para esconder/exibir o script
UIS.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.LeftControl then
            toggleHideScript()
        end
    end
end)

print("[KillAura] Script ativado com sucesso - feito por beabadoobee 💀")
