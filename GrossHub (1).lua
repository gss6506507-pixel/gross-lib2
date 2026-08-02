local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.Themes = {
    Default = {Main = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(0, 170, 255), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(160, 160, 160), Border = Color3.fromRGB(45, 45, 45), Sidebar = Color3.fromRGB(25, 25, 25)},
    Dark = {Main = Color3.fromRGB(10, 10, 10), Secondary = Color3.fromRGB(20, 20, 20), Accent = Color3.fromRGB(100, 100, 100), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(150, 150, 150), Border = Color3.fromRGB(30, 30, 30), Sidebar = Color3.fromRGB(15, 15, 15)},
    Lemon = {Main = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(255, 255, 0), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(200, 200, 100), Border = Color3.fromRGB(45, 45, 45), Sidebar = Color3.fromRGB(25, 25, 25)},
    Rose = {Main = Color3.fromRGB(15, 15, 15), Secondary = Color3.fromRGB(30, 30, 30), Accent = Color3.fromRGB(255, 0, 127), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(200, 100, 150), Border = Color3.fromRGB(45, 45, 45), Sidebar = Color3.fromRGB(25, 25, 25)},
    Ocean = {Main = Color3.fromRGB(10, 20, 30), Secondary = Color3.fromRGB(20, 40, 60), Accent = Color3.fromRGB(0, 255, 255), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(100, 200, 200), Border = Color3.fromRGB(40, 80, 120), Sidebar = Color3.fromRGB(15, 30, 45)},
    Purple = {Main = Color3.fromRGB(15, 10, 20), Secondary = Color3.fromRGB(30, 20, 40), Accent = Color3.fromRGB(170, 0, 255), Text = Color3.fromRGB(255, 255, 255), TextDark = Color3.fromRGB(160, 100, 200), Border = Color3.fromRGB(45, 30, 60), Sidebar = Color3.fromRGB(25, 15, 35)}
}
Library.Theme = Library.Themes.Default

local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    dragHandle = dragHandle or frame
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

function Library.CreateWindow(title, logoId)
    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "GrossHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame", ScreenGui)
    Main.Name = "Main"
    Main.Size = UDim2.new(0, 500, 0, 350)
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Library.Theme.Main
    Main.BackgroundTransparency = 0.05
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Library.Theme.Border
    MainStroke.Thickness = 1.2

    local Header = Instance.new("Frame", Main)
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 40)
    Header.BackgroundTransparency = 1
    
    local HeaderLogo = Instance.new("ImageLabel", Header)
    HeaderLogo.Size = UDim2.new(0, 24, 0, 24)
    HeaderLogo.Position = UDim2.new(0, 10, 0.5, -12)
    HeaderLogo.BackgroundTransparency = 1
    HeaderLogo.Image = logoId or ""
    
    local Title = Instance.new("TextLabel", Header)
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 40, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = title:upper()
    Title.TextColor3 = Library.Theme.Text
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local CloseBtn = Instance.new("ImageButton", Header)
    CloseBtn.Size = UDim2.new(0, 20, 0, 20)
    CloseBtn.Position = UDim2.new(1, -30, 0.5, -10)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Image = "rbxassetid://10152135063"
    CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    MakeDraggable(Main, Header)

    local SidebarBG = Instance.new("Frame", Main)
    SidebarBG.Size = UDim2.new(0, 130, 1, -40)
    SidebarBG.Position = UDim2.new(0, 0, 0, 40)
    SidebarBG.BackgroundColor3 = Library.Theme.Sidebar
    SidebarBG.BackgroundTransparency = 0.4
    Instance.new("UICorner", SidebarBG).CornerRadius = UDim.new(0, 8)

    local Sidebar = Instance.new("ScrollingFrame", SidebarBG)
    Sidebar.Size = UDim2.new(1, -10, 1, -10)
    Sidebar.Position = UDim2.new(0, 5, 0, 5)
    Sidebar.BackgroundTransparency = 1
    Sidebar.ScrollBarThickness = 0
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
    local SidebarLayout = Instance.new("UIListLayout", Sidebar)
    SidebarLayout.Padding = UDim.new(0, 5)

    local Container = Instance.new("Frame", Main)
    Container.Size = UDim2.new(1, -145, 1, -50)
    Container.Position = UDim2.new(0, 140, 0, 45)
    Container.BackgroundTransparency = 1

    local ToggleBtn = Instance.new("ImageButton", ScreenGui)
    ToggleBtn.Name = "MobileToggle"
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
    ToggleBtn.Position = UDim2.new(0, 20, 0, 20)
    ToggleBtn.BackgroundColor3 = Library.Theme.Main
    ToggleBtn.BackgroundTransparency = 0.2
    ToggleBtn.Image = logoId or "rbxassetid://120694317945692"
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Library.Theme.Accent
    BtnStroke.Thickness = 2
    MakeDraggable(ToggleBtn)

    local isVisible = true
    local function ToggleHub()
        isVisible = not isVisible
        local targetSize = isVisible and UDim2.new(0, 500, 0, 350) or UDim2.new(0, 0, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = targetSize}):Play()
        task.wait(0.1)
        Main.Visible = isVisible
    end
    ToggleBtn.MouseButton1Click:Connect(ToggleHub)

    local Window = {SelectedPlayer = nil}
    local firstTab = true

    function Window:CreateTab(name, iconId)
        local TabBtn = Instance.new("TextButton", Sidebar)
        TabBtn.Size = UDim2.new(1, 0, 0, 32)
        TabBtn.BackgroundColor3 = firstTab and Library.Theme.Accent or Library.Theme.Secondary
        TabBtn.BackgroundTransparency = firstTab and 0.2 or 0.5
        TabBtn.Text = "      " .. name
        TabBtn.TextColor3 = firstTab and Library.Theme.Text or Library.Theme.TextDark
        TabBtn.Font = Enum.Font.GothamMedium
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)
        
        local TabIcon = Instance.new("ImageLabel", TabBtn)
        TabIcon.Size = UDim2.new(0, 18, 0, 18)
        TabIcon.Position = UDim2.new(0, 8, 0.5, -9)
        TabIcon.BackgroundTransparency = 1
        TabIcon.Image = iconId or ""
        TabIcon.ImageColor3 = firstTab and Library.Theme.Text or Library.Theme.TextDark

        local TabFrame = Instance.new("ScrollingFrame", Container)
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.Visible = firstTab
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Library.Theme.Accent
        local TabLayout = Instance.new("UIListLayout", TabFrame)
        TabLayout.Padding = UDim.new(0, 8)
        TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabFrame.CanvasSize = UDim2.new(0, 0, 0, TabLayout.AbsoluteContentSize.Y + 10)
        end)

        TabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(Container:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            for _, v in pairs(Sidebar:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = Library.Theme.Secondary, BackgroundTransparency = 0.5, TextColor3 = Library.Theme.TextDark}):Play()
                    if v:FindFirstChild("ImageLabel") then v.ImageLabel.ImageColor3 = Library.Theme.TextDark end
                end
            end
            TabFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Library.Theme.Accent, BackgroundTransparency = 0.2, TextColor3 = Library.Theme.Text}):Play()
            TabIcon.ImageColor3 = Library.Theme.Text
        end)

        firstTab = false
        local Tab = {}

        function Tab:CreateSection(sectionName)
            local SectionFrame = Instance.new("Frame", TabFrame)
            SectionFrame.Size = UDim2.new(0.98, 0, 0, 30)
            SectionFrame.BackgroundTransparency = 1
            local SectionLayout = Instance.new("UIListLayout", SectionFrame)
            SectionLayout.Padding = UDim.new(0, 6)
            SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            
            local SectionTitle = Instance.new("TextLabel", SectionFrame)
            SectionTitle.Size = UDim2.new(1, 0, 0, 20)
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Text = sectionName:upper()
            SectionTitle.TextColor3 = Library.Theme.Accent
            SectionTitle.TextSize = 12
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            SectionLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                SectionFrame.Size = UDim2.new(0.98, 0, 0, SectionLayout.AbsoluteContentSize.Y)
            end)

            local Section = {}

            function Section:CreateButton(text, callback)
                local BtnFrame = Instance.new("Frame", SectionFrame)
                BtnFrame.Size = UDim2.new(1, 0, 0, 35)
                BtnFrame.BackgroundColor3 = Library.Theme.Secondary
                BtnFrame.BackgroundTransparency = 0.3
                Instance.new("UICorner", BtnFrame).CornerRadius = UDim.new(0, 6)
                local B = Instance.new("TextButton", BtnFrame)
                B.Size = UDim2.new(1, 0, 1, 0)
                B.BackgroundTransparency = 1
                B.Text = text
                B.TextColor3 = Library.Theme.Text
                B.Font = Enum.Font.GothamMedium
                B.TextSize = 13
                B.MouseButton1Click:Connect(function()
                    TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Library.Theme.Accent}):Play()
                    callback()
                    task.wait(0.1)
                    TweenService:Create(BtnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Library.Theme.Secondary}):Play()
                end)
            end

            function Section:CreateToggle(text, default, callback)
                local TglFrame = Instance.new("Frame", SectionFrame)
                TglFrame.Size = UDim2.new(1, 0, 0, 35)
                TglFrame.BackgroundColor3 = Library.Theme.Secondary
                TglFrame.BackgroundTransparency = 0.3
                Instance.new("UICorner", TglFrame).CornerRadius = UDim.new(0, 6)
                local Lbl = Instance.new("TextLabel", TglFrame)
                Lbl.Size = UDim2.new(1, -50, 1, 0)
                Lbl.Position = UDim2.new(0, 10, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text
                Lbl.TextColor3 = Library.Theme.TextDark
                Lbl.TextSize = 13
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                local Swt = Instance.new("TextButton", TglFrame)
                Swt.Size = UDim2.new(0, 36, 0, 18)
                Swt.Position = UDim2.new(1, -46, 0.5, -9)
                Swt.BackgroundColor3 = default and Library.Theme.Accent or Color3.fromRGB(60, 60, 60)
                Swt.Text = ""
                Instance.new("UICorner", Swt).CornerRadius = UDim.new(1, 0)
                local Circ = Instance.new("Frame", Swt)
                Circ.Size = UDim2.new(0, 14, 0, 14)
                Circ.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                Circ.BackgroundColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", Circ).CornerRadius = UDim.new(1, 0)
                local toggled = default
                Swt.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    TweenService:Create(Circ, TweenInfo.new(0.2), {Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                    TweenService:Create(Swt, TweenInfo.new(0.2), {BackgroundColor3 = toggled and Library.Theme.Accent or Color3.fromRGB(60, 60, 60)}):Play()
                    callback(toggled)
                end)
            end

            function Section:CreateSlider(text, min, max, default, callback)
                local SldFrame = Instance.new("Frame", SectionFrame)
                SldFrame.Size = UDim2.new(1, 0, 0, 45)
                SldFrame.BackgroundColor3 = Library.Theme.Secondary
                SldFrame.BackgroundTransparency = 0.3
                Instance.new("UICorner", SldFrame).CornerRadius = UDim.new(0, 6)
                local Lbl = Instance.new("TextLabel", SldFrame)
                Lbl.Size = UDim2.new(1, -20, 0, 20)
                Lbl.Position = UDim2.new(0, 10, 0, 5)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = text .. ": " .. default
                Lbl.TextColor3 = Library.Theme.TextDark
                Lbl.TextSize = 12
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                local Bar = Instance.new("Frame", SldFrame)
                Bar.Size = UDim2.new(0.9, 0, 0, 4)
                Bar.Position = UDim2.new(0.05, 0, 0.75, 0)
                Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)
                local Fill = Instance.new("Frame", Bar)
                Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                Fill.BackgroundColor3 = Library.Theme.Accent
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
                local Thumb = Instance.new("Frame", Bar)
                Thumb.Size = UDim2.new(0, 12, 0, 12)
                Thumb.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6)
                Thumb.BackgroundColor3 = Color3.new(1, 1, 1)
                Instance.new("UICorner", Thumb).CornerRadius = UDim.new(1, 0)
                Instance.new("UIStroke", Thumb).Color = Library.Theme.Accent
                local function Update(input)
                    local p = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max - min) * p)
                    Fill.Size = UDim2.new(p, 0, 1, 0)
                    Thumb.Position = UDim2.new(p, -6, 0.5, -6)
                    Lbl.Text = text .. ": " .. v
                    callback(v)
                end
                local drag = false
                SldFrame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = true Update(input) end end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end end)
                UserInputService.InputChanged:Connect(function(input) if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end end)
            end

            function Section:CreateTextBox(name, placeholder, callback)
                local BoxFrame = Instance.new("Frame", SectionFrame)
                BoxFrame.Size = UDim2.new(1, 0, 0, 35)
                BoxFrame.BackgroundColor3 = Library.Theme.Secondary
                BoxFrame.BackgroundTransparency = 0.3
                Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 6)
                local Lbl = Instance.new("TextLabel", BoxFrame)
                Lbl.Size = UDim2.new(0.4, 0, 1, 0)
                Lbl.Position = UDim2.new(0, 10, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.TextDark
                Lbl.TextSize = 13
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                local Inp = Instance.new("TextBox", BoxFrame)
                Inp.Size = UDim2.new(0.5, 0, 0, 24)
                Inp.Position = UDim2.new(0.45, 0, 0.5, -12)
                Inp.BackgroundColor3 = Library.Theme.Main
                Inp.Text = ""
                Inp.PlaceholderText = placeholder
                Inp.TextColor3 = Library.Theme.Text
                Inp.Font = Enum.Font.Gotham
                Inp.TextSize = 12
                Instance.new("UICorner", Inp).CornerRadius = UDim.new(0, 4)
                Inp.FocusLost:Connect(function(e) if e then callback(Inp.Text) end end)
            end

            function Section:CreateKeybind(name, default, callback)
                local BindFrame = Instance.new("Frame", SectionFrame)
                BindFrame.Size = UDim2.new(1, 0, 0, 35)
                BindFrame.BackgroundColor3 = Library.Theme.Secondary
                BindFrame.BackgroundTransparency = 0.3
                Instance.new("UICorner", BindFrame).CornerRadius = UDim.new(0, 6)
                local Lbl = Instance.new("TextLabel", BindFrame)
                Lbl.Size = UDim2.new(1, -70, 1, 0)
                Lbl.Position = UDim2.new(0, 10, 0, 0)
                Lbl.BackgroundTransparency = 1
                Lbl.Text = name
                Lbl.TextColor3 = Library.Theme.TextDark
                Lbl.TextSize = 13
                Lbl.Font = Enum.Font.Gotham
                Lbl.TextXAlignment = Enum.TextXAlignment.Left
                local B = Instance.new("TextButton", BindFrame)
                B.Size = UDim2.new(0, 60, 0, 22)
                B.Position = UDim2.new(1, -70, 0.5, -11)
                B.BackgroundColor3 = Library.Theme.Main
                B.Text = tostring(default)
                B.TextColor3 = Library.Theme.Accent
                B.Font = Enum.Font.GothamBold
                B.TextSize = 11
                Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
                B.MouseButton1Click:Connect(function()
                    B.Text = "..."
                    local c; c = UserInputService.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.Keyboard then
                            B.Text = i.KeyCode.Name
                            callback(i.KeyCode.Name)
                            c:Disconnect()
                        end
                    end)
                end)
            end

            function Section:CreateDropdown(name, options, default, callback)
                local DpFrame = Instance.new("Frame", SectionFrame)
                DpFrame.Size = UDim2.new(1, 0, 0, 35)
                DpFrame.BackgroundColor3 = Library.Theme.Secondary
                DpFrame.BackgroundTransparency = 0.3
                DpFrame.ClipsDescendants = true
                Instance.new("UICorner", DpFrame).CornerRadius = UDim.new(0, 6)
                local B = Instance.new("TextButton", DpFrame)
                B.Size = UDim2.new(1, 0, 0, 35)
                B.BackgroundTransparency = 1
                B.Text = name .. " (" .. default .. ") ➔"
                B.TextColor3 = Library.Theme.TextDark
                B.Font = Enum.Font.Gotham
                B.TextSize = 13
                local List = Instance.new("Frame", DpFrame)
                List.Size = UDim2.new(1, 0, 0, #options * 25)
                List.Position = UDim2.new(0, 0, 0, 35)
                List.BackgroundTransparency = 1
                Instance.new("UIListLayout", List)
                local open = false
                B.MouseButton1Click:Connect(function()
                    open = not open
                    TweenService:Create(DpFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = open and UDim2.new(1, 0, 0, 35 + (#options * 25)) or UDim2.new(1, 0, 0, 35)}):Play()
                    B.Text = open and name .. " ⬇" or name .. " (" .. default .. ") ➔"
                end)
                for _, o in pairs(options) do
                    local Ob = Instance.new("TextButton", List)
                    Ob.Size = UDim2.new(1, 0, 0, 25)
                    Ob.BackgroundTransparency = 0.8
                    Ob.BackgroundColor3 = Library.Theme.Main
                    Ob.Text = o
                    Ob.TextColor3 = Library.Theme.TextDark
                    Ob.Font = Enum.Font.Gotham
                    Ob.TextSize = 12
                    Ob.MouseButton1Click:Connect(function()
                        B.Text = name .. " (" .. o .. ") ➔"
                        open = false
                        TweenService:Create(DpFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        callback(o)
                    end)
                end
            end

            return Section
        end
        return Tab
    end

    function Window.Destroy() ScreenGui:Destroy() end
    function Window.UpdateTheme(t)
        if Library.Themes[t] then
            Library.Theme = Library.Themes[t]
            Main.BackgroundColor3 = Library.Theme.Main
            MainStroke.Color = Library.Theme.Border
            BtnStroke.Color = Library.Theme.Accent
            Title.TextColor3 = Library.Theme.Text
            SidebarBG.BackgroundColor3 = Library.Theme.Sidebar
        end
    end
    function Window.GetSelectedPlayer() return Window.SelectedPlayer end

    return Window
end

return Library
