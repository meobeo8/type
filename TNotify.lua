local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Players = cloneref(game:GetService("Players"))
local plr = Players.LocalPlayer
local PlayerGUI = plr:FindFirstChildOfClass("PlayerGui")
local tNotify = {}
local Actives = {}

function tNotify:Send(titleText, description, duration)
    duration = duration or 5

    local gui = Instance.new("ScreenGui")
    gui.Parent = PlayerGUI

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 100)
    frame.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.AnchorPoint = Vector2.new(1, 0)
    frame.Position = UDim2.new(1, 350, 0, 20)
    frame.BackgroundTransparency = 1
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -30, 0, 30)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = titleText or "haha"
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Parent = frame

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -30, 0, 0)
    desc.AutomaticSize = Enum.AutomaticSize.Y
    desc.Position = UDim2.new(0, 10, 0, 35)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = description or "hihi"
    desc.TextWrapped = true
    desc.TextSize = 15
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextColor3 = Color3.fromRGB(220, 220, 220)
    desc.Parent = frame


    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 20, 0, 20)
    close.Position = UDim2.new(1, -25, 0, 5)
    close.BackgroundTransparency = 1
    close.Text = "×"
    close.Font = Enum.Font.GothamBold
    close.TextSize = 18
    close.TextColor3 = Color3.fromRGB(200, 200, 200)
    close.Parent = frame

    table.insert(Actives, frame)
    self:Update()

    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -20, frame.Position.Y.Scale, frame.Position.Y.Offset),
        BackgroundTransparency = 0
    }):Play()

    close.MouseButton1Click:Connect(function()
        self:Remove(frame)
    end)

    task.delay(duration, function()
        if frame.Parent then
            self:Remove(frame)
        end
    end)
end

function tNotify:Update()
    for i, notify in ipairs(Actives) do
        TweenService:Create(notify, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -20, 0, 20 + (i - 1) * (100 + 10))
        }):Play()
    end
end

function tNotify:Remove(frame)
    local index = table.find(Actives, frame)
    if index then
        table.remove(Actives, index)

        local tween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = frame.Position + UDim2.new(0, 350, 0, 0),
            BackgroundTransparency = 1
        })
        tween:Play()
        tween.Completed:Wait()
        frame.Parent:Destroy()
        self:Update()
    end
end

return tNotify
