local GrossHub = require(game:GetService("ReplicatedStorage"):WaitForChild("GrossHub"))

local Window = GrossHub:CreateWindow("GrossHub Premium")

local MainTab = Window:CreateTab("Principal")

MainTab:AddButton("Resetar Personagem", function()
    local player = game.Players.LocalPlayer
    if player.Character then
        player.Character:BreakJoints()
    end
end)

MainTab:AddToggle("Auto Farm", false, function(state)
    -- Lógica do Toggle aqui
end)

MainTab:AddSlider("Velocidade", 16, 100, 16, function(value)
    local character = game.Players.LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = value
    end
end)

MainTab:AddDropdown("Selecionar Mapa", {"Floresta", "Deserto", "Arena"}, "Floresta", function(selected)
    -- Lógica do Dropdown aqui
end)

local SettingsTab = Window:CreateTab("Settings")

SettingsTab:AddKeybind("Toggle Interface", Enum.KeyCode.RightControl, function(key)
    -- A keybind principal já é tratada pela library, 
    -- mas você pode adicionar lógica extra aqui.
end)

SettingsTab:AddToggle("Botão Mobile", true, function(state)
    local hub = game.Players.LocalPlayer.PlayerGui:FindFirstChild("GrossHub")
    if hub and hub:FindFirstChild("MobileToggle") then
        hub.MobileToggle.Visible = state
    end
end)
