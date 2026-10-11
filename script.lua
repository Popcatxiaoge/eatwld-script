-- ============================================
-- 吃吃世界 自動腳本 v15
-- Key: POPCAT_kki471111
-- 自動抓取 + 自動吃 + 縮小 + 關閉
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== 金鑰驗證 =====
local VALID_KEY = "POPCAT_kki471111"
local isVerified = false

-- ===== 狀態 =====
local autoMode = false
local isBusy = false
local isShutdown = false

-- ===== 速度設定（改這裡就好）=====
local GRAB_INTERVAL = 0.05   -- 抓取間隔
local EAT_INTERVAL  = 0.05   -- 吃的間隔
local EAT_TIMES     = 3      -- 抓一次吃幾次

-- ===== 自動抓取 + 吃 =====
local function grabAndEat()
    if isBusy or isShutdown then return end
    isBusy = true

    local char = LocalPlayer.Character
    if not char then isBusy = false; return end
    local events = char:FindFirstChild("Events")
    if not events then isBusy = false; return end

    local grab = events:FindFirstChild("Grab")
    local eat = events:FindFirstChild("Eat")

    if grab then
        pcall(function()
            grab:FireServer(false, false, false)
        end)
    end

    task.wait(GRAB_INTERVAL)

    for i = 1, EAT_TIMES do
        if not autoMode or isShutdown then break end
        if eat then
            pcall(function()
                eat:FireServer()
            end)
        end
        task.wait(EAT_INTERVAL)
    end

    isBusy = false
end

-- ===== 主循環 =====
local function mainLoop()
    while autoMode and not isShutdown do
        grabAndEat()
        task.wait(GRAB_INTERVAL)
    end
end

-- ===== UI =====
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoEatWorldUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 230)
    frame.Position = UDim2.new(0.05, 0, 0.3, 0)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Draggable = true
    frame.Parent = screenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 200, 255)
    stroke.Thickness = 2
    stroke.Parent = frame

    -- 縮小圖示
    local miniBtn = Instance.new("TextButton")
    miniBtn.Size = UDim2.new(0, 50, 0, 50)
    miniBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
    miniBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
    miniBtn.Text = "🍽️"
    miniBtn.TextScaled = true
    miniBtn.Font = Enum.Font.GothamBold
    miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniBtn.Visible = false
    miniBtn.Active = true
    miniBtn.Draggable = true
    miniBtn.Parent = screenGui

    local miniCorner = Instance.new("UICorner")
    miniCorner.CornerRadius = UDim.new(1, 0)
    miniCorner.Parent = miniBtn

    local miniStroke = Instance.new("UIStroke")
    miniStroke.Color = Color3.fromRGB(100, 200, 255)
    miniStroke.Thickness = 2
    miniStroke.Parent = miniBtn

    -- 標題
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
    title.BorderSizePixel = 0
    title.Text = "🍽️ 吃吃世界 v15"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    -- 縮小
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    minimizeBtn.Position = UDim2.new(1, -60, 0, 4)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(200, 160, 60)
    minimizeBtn.Text = "－"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = frame

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minimizeBtn

    -- 關閉
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 26, 0, 26)
    closeBtn.Position = UDim2.new(1, -30, 0, 4)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = frame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    -- Key 輸入
    local keyBox = Instance.new("TextBox")
    keyBox.Size = UDim2.new(0.9, 0, 0, 32)
    keyBox.Position = UDim2.new(0.05, 0, 0, 45)
    keyBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    keyBox.PlaceholderText = "輸入 Key..."
    keyBox.Text = ""
    keyBox.TextScaled = true
    keyBox.Font = Enum.Font.Gotham
    keyBox.Parent = frame

    local keyCorner = Instance.new("UICorner")
    keyCorner.CornerRadius = UDim.new(0, 6)
    keyCorner.Parent = keyBox

    -- 驗證
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(0.9, 0, 0, 30)
    verifyBtn.Position = UDim2.new(0.05, 0, 0, 82)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    verifyBtn.Text = "驗證 Key"
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.TextScaled = true
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.Parent = frame

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 6)
    verifyCorner.Parent = verifyBtn

    -- 狀態
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 115)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "狀態：未驗證"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = frame

    -- 開始
    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.9, 0, 0, 42)
    startBtn.Position = UDim2.new(0.05, 0, 0, 145)
    startBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
    startBtn.Text = "▶ 開始自動模式"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.TextScaled = true
    startBtn.Font = Enum.Font.GothamBold
    startBtn.Parent = frame

    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 6)
    startCorner.Parent = startBtn

    -- 手動抓
    local manualBtn = Instance.new("TextButton")
    manualBtn.Size = UDim2.new(0.9, 0, 0, 26)
    manualBtn.Position = UDim2.new(0.05, 0, 0, 195)
    manualBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    manualBtn.Text = "🖐 手動抓一次"
    manualBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    manualBtn.TextScaled = true
    manualBtn.Font = Enum.Font.Gotham
    manualBtn.Parent = frame

    local manualCorner = Instance.new("UICorner")
    manualCorner.CornerRadius = UDim.new(0, 6)
    manualCorner.Parent = manualBtn

    -- ===== 綁定 =====
    minimizeBtn.MouseButton1Click:Connect(function()
        frame.Visible = false
        miniBtn.Visible = true
    end)

    miniBtn.MouseButton1Click:Connect(function()
        frame.Visible = true
        miniBtn.Visible = false
    end)

    closeBtn.MouseButton1Click:Connect(function()
        isShutdown = true
        autoMode = false
        isBusy = false
        screenGui:Destroy()
        print("[吃吃世界] ❌ 腳本已關閉")
    end)

    verifyBtn.MouseButton1Click:Connect(function()
        if keyBox.Text == VALID_KEY then
            isVerified = true
            statusLabel.Text = "狀態：✅ 驗證成功"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            verifyBtn.BackgroundColor3 = Color3.fromRGB(40, 140, 70)
        else
            isVerified = false
            statusLabel.Text = "狀態：❌ Key 錯誤"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)

    startBtn.MouseButton1Click:Connect(function()
        if isShutdown then return end
        if not isVerified then
            statusLabel.Text = "狀態：⚠️ 請先驗證 Key"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            return
        end

        autoMode = not autoMode

        if autoMode then
            startBtn.Text = "⏹ 停止自動模式"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            statusLabel.Text = "狀態：🟢 運行中 (0.05s)..."
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.spawn(mainLoop)
        else
            startBtn.Text = "▶ 開始自動模式"
            startBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
            statusLabel.Text = "狀態：已停止"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
    end)

    manualBtn.MouseButton1Click:Connect(function()
        if isShutdown then return end
        task.spawn(grabAndEat)
    end)
end

-- ===== 初始化 =====
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    isBusy = false
end)

createUI()
print("[吃吃世界] v15 已載入 ✅ Key: POPCAT_kki471111")
print("[吃吃世界] 速度：抓 0.05s / 吃 0.05s")
