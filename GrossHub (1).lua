local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.Theme = {
    Main = Color3.fromRGB(15, 15, 15),
    Secondary = Color3.fromRGB(30, 30, 30),
    Accent = Color3.fromRGB(0, 170, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(45, 45, 45),
    Sidebar = Color3.fromRGB(25, 25, 25)
}

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library:Create(hubName, gameName)
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GrossHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = PlayerGui

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 480, 0, 320)
    Main.Position = UDim2.new(0.5, -240, 0.5, -160)
    Main.BackgroundColor3 = self.Theme.Main
    Main.BackgroundTransparency = 0.05
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = self.Theme.Border
    Stroke.Thickness = 1.2

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 35)
    Header.BackgroundTransparency = 1
    Header.Parent = Main

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -60, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = hubName:upper() .. " | " .. gameName
    Title.TextColor3 = self.Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local CloseBtn = Instance.new("ImageButton")
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = "rbxassetid://10152135063"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.Parent = Header
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main, Header)

    local SidebarBG = Instance.new("Frame")
    SidebarBG.Size = UDim2.new(0, 125, 1, -35)
    SidebarBG.Position = UDim2.new(0, 0, 0, 35)
    SidebarBG.BackgroundColor3 = self.Theme.Sidebar
    SidebarBG.BackgroundTransparency = 0.4
    SidebarBG.Parent = Main
    Instance.new("UICorner", SidebarBG).CornerRadius = UDim.new(0, 8)

    local Sidebar = Instance.new("ScrollingFrame")
    Sidebar.Size = UDim2.new(1, -10, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    Sidebar.Parent = SidebarBG

    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 4)

    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -145, 1, -45)
    Container.Position = UDim2.new(0, 135, 0, 40)
    Container.BackgroundTransparency = 1
    Container.Parent = Main

    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "MobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
    ToggleBtn.BackgroundColor3 = self.Theme.Main
    ToggleBtn.BackgroundTransparency = 0.2
    ToggleBtn.Image = "rbxassetid://120694317945692"
    ToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = self.Theme.Accent
    BtnStroke.Thickness = 1.5

    MakeDraggable(ToggleBtn)

    local isVisible = true
    local function ToggleHub()
        isVisible = not isVisible
        local targetSize = isVisible and UDim2.new(0, 480, 0, 320) or UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
        task.wait(0.1)
        Main.Visible = isVisible
    end
    ToggleBtn.MouseButton1Click:Connect(ToggleHub)

    local currentKeybind = Enum.KeyCode.RightControl
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == currentKeybind then ToggleHub() end
    end)

    local Window = {}
    local firstTab = true

    function Window:Tab(name, visible)
        local TabBtn = Instance.new("TextButton")
        TabBtn.Size = UDim2.new(1, 0, 0, 30)
        TabBtn.BackgroundColor3 = firstTab and Library.Theme.Accent or Library.Theme.Secondary
        TabBtn.BackgroundTransparency = firstTab and 0 or 0.3
        TabBtn.Text = name
        TabBtn.TextColor3 = firstTab and Library.Theme.Text or Library.Theme.TextDark
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.Parent = Sidebar
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local SectionFrame = Instance.new("ScrollingFrame")
        SectionFrame.Size = UDim2.new(1, 0, 1, 0)
        SectionFrame.BackgroundTransparency = 1
        SectionFrame.ScrollBarThickness = 2
        SectionFrame.ScrollBarImageColor3 = Library.Theme.Accent
        SectionFrame.Visible = firstTab
        SectionFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionFrame.Parent = Container

        local SectionLayout = Instance.new("UIListLayout", SectionFrame)
        SectionLayout.Padding = UDim.new(0, 6)
        SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionFrame.CanvasSize = UDim2.new(0, 0, 0, SectionLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Library.Theme.Secondary, BackgroundTransparency = 0.3, TextColor3 = Library.Theme.TextDark}):Play()
                end
            end
            SectionFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0, TextColor3 = Library.Theme.Text}):Play()
        end)

        firstTab = false
        local Tab = {}

        function Tab:Label(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(0.98, 0, 0, 25)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Parent = SectionFrame
            local Lbl = Instance.new("TextLabel")
            Lbl.Size = UDim2.new(1, 0, 1, 0)
            Lbl.BackgroundTransparency = 1
            Lbl.Text = text
            Lbl.TextColor3 = Library.Theme.Text
            Lbl.TextSize = 13
            Lbl.Font = Enum.Font.GothamMedium
            Lbl.TextXAlignment = Enum.TextXAlignment.Left
            Lbl.Parent = LabelFrame
        end

        function Tab:Button(text, callback)
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(0.98, 0, 0, 35)
            ButtonFrame.BackgroundColor3 = Library.Theme.Secondary
            ButtonFrame.BackgroundTransparency = 0.2
            ButtonFrame.Parent = SectionFrame
            Instance.new("UICorner", ButtonFrame).CornerRadius = UDim.new(0, 4)
            local MainBtn = Instance.new("TextButton")
            MainBtn.Size = UDim2.new(1, 0, 1, 0)
            MainBtn.BackgroundTransparency = 1
            MainBtn.Text = text
            MainBtn.TextColor3 = Library.Theme.TextDark
            MainBtn.Font = Enum.Font.GothamMedium
            MainBtn.TextSize = 13
            MainBtn.Parent = ButtonFrame
            MainBtn.MouseButton1Click:Connect(function()
                TweenService:Create(ButtonFrame, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0}):Play()
                callback()
                task.wait(0.1)
                TweenService:Create(ButtonFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Secondary, BackgroundTransparency = 0.2}):Play()
            end)
        end

        function Tab:Toggle(text, callback)
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(0.98, 0, 0, 35)
            ToggleFrame.BackgroundColor3 = Library.Theme.Secondary
            ToggleFrame.BackgroundTransparency = 0.2
            ToggleFrame.Parent = SectionFrame
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -120, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = ToggleFrame
            local KeybindBtn = Instance.new("ImageButton")
            KeybindBtn.Size = UDim2.new(0, 18, 0, 18)
            KeybindBtn.Position = UDim2.new(1, -70, 0.5, -9)
            KeybindBtn.BackgroundTransparency = 1
            KeybindBtn.Image = "rbxassetid://121332782788896"
            KeybindBtn.ImageColor3 = Library.Theme.TextDark
            KeybindBtn.Parent = ToggleFrame
            local KeyLabel = Instance.new("TextLabel")
            KeyLabel.Size = UDim2.new(0, 50, 0, 20)
            KeyLabel.Position = UDim2.new(1, -70, 0.5, -10)
            KeyLabel.BackgroundTransparency = 1
            KeyLabel.Text = ""
            KeyLabel.TextColor3 = Library.Theme.Accent
            KeyLabel.TextSize = 10
            KeyLabel.Font = Enum.Font.GothamBold
            KeyLabel.TextXAlignment = Enum.TextXAlignment.Right
            KeyLabel.Visible = false
            KeyLabel.Parent = ToggleFrame
            local Switch = Instance.new("TextButton")
            Switch.Size = UDim2.new(0, 36, 0, 18)
            Switch.Position = UDim2.new(1, -46, 0.5, -9)
            Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            Switch.Text = ""
            Switch.Parent = ToggleFrame
            Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)
            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 14, 0, 14)
            Circle.Position = UDim2.new(0, 2, 0.5, -7)
            Circle.BackgroundColor3 = Color3.new(1, 1, 1)
            Circle.Parent = Switch
            Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)
            local toggled = false
            local function Fire()
                toggled = not toggled
                local targetPos = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                local targetColor = toggled and Library.Theme.Accent or Color3.fromRGB(50, 50, 50)
                TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
                TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
                callback(toggled)
            end
            Switch.MouseButton1Click:Connect(Fire)
            local currentToggleKey = nil
            KeybindBtn.MouseButton1Click:Connect(function()
                KeyLabel.Visible = true
                KeyLabel.Text = "..."
                KeyLabel.Position = UDim2.new(1, -70, 0.5, -10)
                TweenService:Create(KeyLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -125, 0.5, -10)}):Play()
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentToggleKey = input.KeyCode
                        KeyLabel.Text = "[" .. input.KeyCode.Name .. "]"
                        KeybindBtn.ImageColor3 = Library.Theme.Accent
                        connection:Disconnect()
                    end
                end)
            end)
            UserInputService.InputBegan:Connect(function(input, gpe)
                if not gpe and currentToggleKey and input.KeyCode == currentToggleKey then Fire() end
            end)
        end

        function Tab:Slider(text, min, max, callback)
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(0.98, 0, 0, 45)
            SliderFrame.BackgroundColor3 = Library.Theme.Secondary
            SliderFrame.BackgroundTransparency = 0.2
            SliderFrame.Parent = SectionFrame
            Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -10, 0, 20)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = text .. ": " .. min
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = SliderFrame
            local Bar = Instance.new("Frame")
            Bar.Size = UDim2.new(0.9, 0, 0, 4)
            Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
            Bar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            Bar.Parent = SliderFrame
            Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new(0, 0, 1, 0)
            Fill.BackgroundColor3 = Library.Theme.Accent
            Fill.Parent = Bar
            Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
            local Thumb = Instance.new("Frame")
            Thumb.Size = UDim2.new(0, 12, 0, 12)
            Thumb.Position = UDim2.new(0, -6, 0.5, -6)
            Thumb.BackgroundColor3 = Color3.new(1, 1, 1)
            Thumb.Parent = Bar
            Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)
            Instance.new("UIStroke", Thumb).Color = Library.Theme.Accent
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                local value = math.floor(min + (max - min) * pos)
                Fill.Size = UDim2.new(pos, 0, 1, 0)
                Thumb.Position = UDim2.new(pos, -6, 0.5, -6)
                Label.Text = text .. ": " .. value
                callback(value)
            end
            local dragging = false
            SliderFrame.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                    UpdateSlider(input)
                end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
            end)
        end

        function Tab:Dropdown(text, options, callback)
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(0.98, 0, 0, 35)
            DropdownFrame.BackgroundColor3 = Library.Theme.Secondary
            DropdownFrame.BackgroundTransparency = 0.2
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = SectionFrame
            Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 4)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 35)
            Button.BackgroundTransparency = 1
            Button.Text = text .. " ➔"
            Button.TextColor3 = Library.Theme.TextDark
            Button.Font = Enum.Font.Gotham
            Button.TextSize = 13
            Button.Parent = DropdownFrame
            local OptionList = Instance.new("Frame")
            OptionList.Size = UDim2.new(1, 0, 0, #options * 25)
            OptionList.Position = UDim2.new(0, 0, 0, 35)
            OptionList.BackgroundTransparency = 1
            OptionList.Parent = DropdownFrame
            Instance.new("UIListLayout", OptionList)
            local open = false
            Button.MouseButton1Click:Connect(function()
                open = not open
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = open and UDim2.new(0.98, 0, 0, 35 + (#options * 25)) or UDim2.new(0.98, 0, 0, 35)}):Play()
                Button.Text = open and text .. " ⬇" or text .. " ➔"
            end)
            for _, opt in pairs(options) do
                local OptBtn = Instance.new("TextButton")
                OptBtn.Size = UDim2.new(1, 0, 0, 25)
                OptBtn.BackgroundColor3 = Library.Theme.Main
                OptBtn.BackgroundTransparency = 0.5
                OptBtn.Text = opt
                OptBtn.TextColor3 = Library.Theme.TextDark
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.BorderSizePixel = 0
                OptBtn.Parent = OptionList
                OptBtn.MouseButton1Click:Connect(function()
                    Button.Text = text .. " (" .. opt .. ") ➔"
                    open = false
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.98, 0, 0, 35)}):Play()
                    callback(opt)
                end)
            end
        end

        function Tab:Keybind(text, default, callback)
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Size = UDim2.new(0.98, 0, 0, 35)
            KeybindFrame.BackgroundColor3 = Library.Theme.Secondary
            KeybindFrame.BackgroundTransparency = 0.2
            KeybindFrame.Parent = SectionFrame
            Instance.new("UICorner", KeybindFrame).CornerRadius = UDim.new(0, 4)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -90, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = KeybindFrame
            local BindBtn = Instance.new("TextButton")
            BindBtn.Size = UDim2.new(0, 70, 0, 20)
            BindBtn.Position = UDim2.new(1, -80, 0.5, -10)
            BindBtn.BackgroundColor3 = Library.Theme.Main
            BindBtn.Text = default.Name
            BindBtn.TextColor3 = Library.Theme.Accent
            BindBtn.Font = Enum.Font.GothamBold
            BindBtn.TextSize = 11
            BindBtn.Parent = KeybindFrame
            Instance.new("UICorner", BindBtn).CornerRadius = UDim.new(0, 4)
            BindBtn.MouseButton1Click:Connect(function()
                BindBtn.Text = "..."
                local connection
                connection = UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        BindBtn.Text = input.KeyCode.Name
                        callback(input.KeyCode)
                        connection:Disconnect()
                    end
                end)
            end)
        end

        function Tab:Textbox(name, placeholder, callback)
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(0.98, 0, 0, 35)
            TextboxFrame.BackgroundColor3 = Library.Theme.Secondary
            TextboxFrame.BackgroundTransparency = 0.2
            TextboxFrame.Parent = SectionFrame
            Instance.new("UICorner", TextboxFrame).CornerRadius = UDim.new(0, 4)
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(0.4, 0, 1, 0)
            Label.Position = UDim2.new(0, 10, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = name
            Label.TextColor3 = Library.Theme.TextDark
            Label.TextSize = 13
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = TextboxFrame
            local Input = Instance.new("TextBox")
            Input.Size = UDim2.new(0.55, 0, 0, 25)
            Input.Position = UDim2.new(0.4, 0, 0.5, -12)
            Input.BackgroundColor3 = Library.Theme.Main
            Input.Text = ""
            Input.PlaceholderText = placeholder
            Input.TextColor3 = Library.Theme.Text
            Input.Font = Enum.Font.Gotham
            Input.TextSize = 12
            Input.Parent = TextboxFrame
            Instance.new("UICorner", Input).CornerRadius = UDim.new(0, 4)
            Input.FocusLost:Connect(function(enterPressed)
                if enterPressed then callback(Input.Text) end
            end)
        end

        return Tab
    end
    return Window
end

return Library
