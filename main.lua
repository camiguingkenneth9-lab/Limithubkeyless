-- a tiny, self-contained UI (no key, no external libs)

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- make a minimal screen gui
local gui = Instance.new("ScreenGui")
gui.Name = "LimitHubLike"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = CoreGui

-- draggable header
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 180)
frame.Position = UDim2.new(0.5, -140, 0.4, -90)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.Parent = gui

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundTransparency = 0.2
header.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
header.Text = "LimitHub (Keyless Example)"
header.TextColor3 = Color3.fromRGB(235, 235, 235)
header.Font = Enum.Font.GothamBold
header.TextSize = 14
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

-- drag logic
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    header.InputEnded:Connect(function(input)
        if input.UserInputType.Name == "MouseButton1" then
            dragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType.Name == "MouseMovement" then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- container
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -20, 1, -50)
content.Position = UDim2.new(0, 10, 0, 40)
content.BackgroundTransparency = 1
content.Parent = frame

local list = Instance.new("UIListLayout", content)
list.Padding = UDim.new(0, 8)

local function makeButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(240, 240, 240)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.AutoButtonColor = true
    btn.Parent = content
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return btn
end

-- state
local wsBoost = false
local jumpBoost = false
local nightMode = false

-- WalkSpeed toggle
makeButton("Toggle WalkSpeed (16 ↔ 26)", function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        wsBoost = not wsBoost
        hum.WalkSpeed = wsBoost and 26 or 16
    end
end)

-- JumpPower toggle
makeButton("Toggle JumpPower (50 ↔ 75)", function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        jumpBoost = not jumpBoost
        hum.UseJumpPower = true
        hum.JumpPower = jumpBoost and 75 or 50
    end
end)

-- Night mode (screen tint)
local tint = Instance.new("Frame")
tint.Visible = false
tint.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
tint.BackgroundTransparency = 0.4
tint.BorderSizePixel = 0
tint.Size = UDim2.new(1, 0, 1, 0)
tint.Parent = gui

makeButton("Toggle Night Mode", function()
    nightMode = not nightMode
    tint.Visible = nightMode
end)

-- UI visibility
makeButton("Hide/Show UI (RightShift)", function()
    gui.Enabled = not gui.Enabled
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
