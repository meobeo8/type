local function RandomName(length)
    local text = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local key = ""
    for i = 1, length do
        local index = math.random(1, #text)
        key = key .. text:sub(index, index)
    end
    return key
end

if not getgenv().TNotify then
    getgenv().TNotify = {Actives = {}, Spacing = 10, NotifyHeight = 100, TweenTime = 0.25}

    local GUI = Instance.new("ScreenGui")
    GUI.Name = "TNotify"
    GUI.Parent = game:GetService("Players") and game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")
    getgenv().TNotify.ScreenGui = GUI

    local T = getgenv().TNotify

    function T:updatePositions()
        for i, frame in ipairs(self.Actives) do
            local targetY = 20 + (i - 1) * (self.NotifyHeight + self.Spacing)
            game:GetService("TweenService"):Create(frame, TweenInfo.new(self.TweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -20, 0, targetY)
            }):Play()
        end
    end

    function T:Send(titleText, description, duration)
        duration = duration or 5
        local frame = Instance.new("Frame")
        frame.Name = RandomName(20)
        frame.Size = UDim2.new(0, 350, 0, self.NotifyHeight)
        frame.Position = UDim2.new(1, 350, 0, 20 + #self.Actives * (self.NotifyHeight + self.Spacing))
        frame.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
        frame.BorderSizePixel = 0
        frame.ClipsDescendants = true
        frame.AnchorPoint = Vector2.new(1, 0)
        frame.BackgroundTransparency = 1
        frame.Parent = self.ScreenGui

        local corner = Instance.new("UICorner")
        corner.Name = RandomName(20)
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = frame

        local title = Instance.new("TextLabel")
        title.Name = RandomName(20)
        title.Size = UDim2.new(1, -30, 0, 30)
        title.Position = UDim2.new(0, 10, 0, 5)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBold
        title.Text = titleText or "Title"
        title.TextSize = 18
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Parent = frame

        local desc = Instance.new("TextLabel")
        desc.Name = RandomName(30)
        desc.Size = UDim2.new(1, -30, 0, 0)
        desc.AutomaticSize = Enum.AutomaticSize.Y
        desc.Position = UDim2.new(0, 10, 0, 35)
        desc.BackgroundTransparency = 1
        desc.Font = Enum.Font.Gotham
        desc.Text = description or "Description"
        desc.TextWrapped = true
        desc.TextSize = 15
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextColor3 = Color3.fromRGB(220, 220, 220)
        desc.Parent = frame

        local close = Instance.new("TextButton")
        close.Name = RandomName(20)
        close.Size = UDim2.new(0, 20, 0, 20)
        close.Position = UDim2.new(1, -25, 0, 5)
        close.BackgroundTransparency = 1
        close.Text = "X"
        close.Font = Enum.Font.GothamBold
        close.TextSize = 18
        close.TextColor3 = Color3.fromRGB(200, 200, 200)
        close.Parent = frame

        table.insert(self.Actives, frame)
        game:GetService("TweenService"):Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Position = UDim2.new(1, -20, 0, 20 + (#self.Actives - 1) * (self.NotifyHeight + self.Spacing)),
            BackgroundTransparency = 0
        }):Play()

        self:updatePositions()

        local function removeFrame()
            local index = table.find(self.Actives, frame)
            if index then
                table.remove(self.Actives, index)
                game:GetService("TweenService"):Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                    Position = UDim2.new(1, 350, 0, frame.Position.Y.Offset),
                    BackgroundTransparency = 1
                }):Play()
                task.delay(0.3, function()
                    frame:Destroy()
                    self:updatePositions()
                end)
            end
        end

        close.MouseButton1Click:Connect(removeFrame)
        task.delay(duration, function()
            if frame.Parent then
                removeFrame()
            end
        end)
    end
end

local TNotify = {}

function TNotify:Send(titleText, description, duration)
    getgenv().TNotify:Send(titleText, description, duration)
end

return TNotify
