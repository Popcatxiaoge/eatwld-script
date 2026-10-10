-- 放在 StarterPlayer > StarterPlayerScripts 中的 LocalScript

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== 金鑰設定 ====================
local VALID_KEY = "kki471111"

-- ==================== 建立主 ScreenGui ====================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ==================== 金鑰介面 ====================
local keyFrame = Instance.new("Frame")
keyFrame.Name = "KeyFrame"
keyFrame.Size = UDim2.new(0, 350, 0, 220)
keyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
keyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = screenGui

local keyCorner = Instance.new("UICorner")
keyCorner.CornerRadius = UDim.new(0, 12)
keyCorner.Parent = keyFrame

local keyStroke = Instance.new("UIStroke")
keyStroke.Color = Color3.fromRGB(80, 150, 255)
keyStroke.Thickness = 2
keyStroke.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 50)
keyTitle.Position = UDim2.new(0, 0, 0, 15)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "🔑 請輸入金鑰"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.TextScaled = true
keyTitle.Font = Enum.Font.GothamBold
keyTitle.Parent = keyFrame

local keyInput = Instance.new("TextBox")
keyInput.Size = UDim2.new(0.8, 0, 0, 45)
keyInput.Position = UDim2.new(0.5, 0, 0.45, 0)
keyInput.AnchorPoint = Vector2.new(0.5, 0.5)
keyInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
keyInput.BorderSizePixel = 0
keyInput.Text = ""
keyInput.PlaceholderText = "輸入金鑰..."
keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
keyInput.TextScaled = true
keyInput.Font = Enum.Font.Gotham
keyInput.ClearTextOnFocus = false
keyInput.Parent = keyFrame

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInput

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0.8, 0, 0, 45)
submitBtn.Position = UDim2.new(0.5, 0, 0.8, 0)
submitBtn.AnchorPoint = Vector2.new(0.5, 0.5)
submitBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
submitBtn.BorderSizePixel = 0
submitBtn.Text = "確認"
submitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
submitBtn.TextScaled = true
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = keyFrame

local submitCorner = Instance.new("UICorner")
submitCorner.CornerRadius = UDim.new(0, 8)
submitCorner.Parent = submitBtn

-- ==================== 主介面 ====================
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 150, 255)
mainStroke.Thickness = 2
mainStroke.Parent = mainFrame

local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, 0, 0, 60)
mainTitle.Position = UDim2.new(0, 0, 0, 15)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "窮小子打工記"
mainTitle.TextColor3 = Color3.fromRGB(255, 220, 100)
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.GothamBold
mainTitle.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.7, 0, 0, 60)
toggleBtn.Position = UDim2.new(0.5, 0, 0.55, 0)
toggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
toggleBtn.BorderSizePixel = 0
toggleBtn.Text = "自動挖礦"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = mainFrame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleBtn

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0.85, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "狀態：關閉"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- ==================== 挖礦功能 ====================
local miningConnection = nil
local isMining = false

local function mineOnce()
    local ok, err = pcall(function()
        local Event = ReplicatedStorage.Packages.QuickNet.QuickNetRemote
        local bytes = { 1, 0, 1, 24, 228, 189, 160, 230, 140, 150, 229, 136, 176, 228, 186, 134, 230, 183, 177, 229, 177, 130, 233, 146, 187, 231, 159, 179, 34, 34 }

        local b = buffer.create(#bytes)
        for i = 1, #bytes do
            buffer.writeu8(b, i - 1, bytes[i])
        end

        firesignal(Event.OnClientEvent, b)
    end)
    if not ok then
        warn("[自動挖礦] 執行失敗: " .. tostring(err))
    end
end

local function startMining()
    if isMining then return end
    isMining = true
    toggleBtn.Text = "停止挖礦"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    statusLabel.Text = "狀態：挖礦中..."
    statusLabel.TextColor3 = Color3.fromRGB(100, 255, 150)

    miningConnection = task.spawn(function()
        while isMining do
            mineOnce()
            task.wait(0.1) -- 100 毫秒
        end
    end)
end

local function stopMining()
    isMining = false
    toggleBtn.Text = "自動挖礦"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
    statusLabel.Text = "狀態：關閉"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
end

toggleBtn.MouseButton1Click:Connect(function()
    if isMining then
        stopMining()
    else
        startMining()
    end
end)

-- ==================== 金鑰驗證 ====================
local function trySubmit()
    if keyInput.Text == VALID_KEY then
        keyFrame.Visible = false
        mainFrame.Visible = true
    else
        keyInput.Text = ""
        keyInput.PlaceholderText = "❌ 金鑰錯誤，請重試"
        -- 錯誤時紅色閃爍
        keyStroke.Color = Color3.fromRGB(255, 80, 80)
        task.wait(0.3)
        keyStroke.Color = Color3.fromRGB(80, 150, 255)
    end
end

submitBtn.MouseButton1Click:Connect(trySubmit)
keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        trySubmit()
    end
end)
