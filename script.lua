-- ============================================
-- 吃吃世界 自動腳本 v9（最終版）
-- Key: POPCAT_kki471111
-- 自動抓取 + 自動吃 + 自動售出
-- ============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ===== 金鑰驗證 =====
local VALID_KEY = "POPCAT_kki471111"
local isVerified = false

-- ===== 狀態 =====
local autoMode = false
local isBusy = false
local currentCount = 0
local maxCount = 0
local lastSellTime = 0
local SELL_COOLDOWN = 2

-- ===== 取得 ProgressText UI =====
local function getProgressText()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local screenGui = pg:FindFirstChild("ScreenGui")
    if not screenGui then return nil end
    local sell = screenGui:FindFirstChild("Sell")
    if not sell then return nil end
    return sell:FindFirstChild("ProgressText")
end

-- ===== 讀取目前數量 =====
local function updateCount()
    local pt = getProgressText()
    if pt and pt:IsA("TextLabel") then
        local n = tonumber(pt.Text)
        if n then
            currentCount = n
            return true
        end
    end
    return false
end

-- ===== 自動抓取 + 吃 =====
local function grabAndEat()
    if isBusy then return end
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

    task.wait(0.5)

    for i = 1, 3 do
        if not autoMode then break end
        if eat then
            pcall(function()
                eat:FireServer()
            end)
        end
        task.wait(0.3)
    end

    isBusy = false
end

-- ===== 自動售出 =====
local function autoSell()
    local now = tick()
    if now - lastSellTime < SELL_COOLDOWN then return end

    local char = LocalPlayer.Character
    if not char then return end
    local events = char:FindFirstChild("Events")
    if not events then return end
    local sell = events:FindFirstChild("Sell")
    if not sell then return end

    pcall(function()
        sell:FireServer()
    end)
    lastSellTime = now
    print("[吃吃世界] 💰 售出！賣出前數量：" .. currentCount)
    task.wait(0.8)
end

-- ===== 判斷是否滿了 =====
local lastCount = -1
local stuckTimes = 0
local STUCK_THRESHOLD = 4

local function isFull()
    updateCount()

    if maxCount > 0 and currentCount >= maxCount then
        return true
    end

    if currentCount == lastCount and currentCount > 0 then
        stuckTimes = stuckTimes + 1
    else
        stuckTimes = 0
    end
    lastCount = currentCount

    if stuckTimes >= STUCK_THRESHOLD then
        if currentCount > maxCount then
            maxCount = currentCount
            print("[吃吃世界] 偵測到上限：" .. maxCount)
        end
        stuckTimes = 0
        return true
    end

    return false
end

-- ===== 主循環 =====
local function mainLoop()
    lastCount = -1
    stuckTimes = 0

    while autoMode do
        grabAndEat()

        if isFull() then
            print("[吃吃世界] ⚠️ 滿了（數量：" .. currentCount .. "），自動售出！")
            autoSell()
            task.wait(1)
        end

        task.wait(0.3)
    end
end

-- ===== 建立 UI =====
local function createUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AutoEatWorldUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 260, 0, 300)
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

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(50, 100, 180)
    title.BorderSizePixel = 0
    title.Text = "🍽️ 吃吃世界 v9"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

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

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.9, 0, 0, 22)
    statusLabel.Position = UDim2.new(0.05, 0, 0, 115)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "狀態：未驗證"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.Parent = frame

    local countLabel = Instance.new("TextLabel")
    countLabel.Size = UDim2.new(0.9, 0, 0, 22)
    countLabel.Position = UDim2.new(0.05, 0, 0, 140)
    countLabel.BackgroundTransparency = 1
    countLabel.Text = "📦 數量：0"
    countLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    countLabel.TextScaled = true
    countLabel.Font = Enum.Font.GothamBold
    countLabel.Parent = frame

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(0.9, 0, 0, 42)
    startBtn.Position = UDim2.new(0.05, 0, 0, 170)
    startBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
    startBtn.Text = "▶ 開始自動模式"
    startBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    startBtn.TextScaled = true
    startBtn.Font = Enum.Font.GothamBold
    startBtn.Parent = frame

    local startCorner = Instance.new("UICorner")
    startCorner.CornerRadius = UDim.new(0, 6)
    startCorner.Parent = startBtn

    local sellBtn = Instance.new("TextButton")
    sellBtn.Size = UDim2.new(0.9, 0, 0, 30)
    sellBtn.Position = UDim2.new(0.05, 0, 0, 220)
    sellBtn.BackgroundColor3 = Color3.fromRGB(180, 130, 60)
    sellBtn.Text = "💰 手動售出"
    sellBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sellBtn.TextScaled = true
    sellBtn.Font = Enum.Font.GothamBold
    sellBtn.Parent = frame

    local sellCorner = Instance.new("UICorner")
    sellCorner.CornerRadius = UDim.new(0, 6)
    sellCorner.Parent = sellBtn

    local infoBtn = Instance.new("TextButton")
    infoBtn.Size = UDim2.new(0.9, 0, 0, 26)
    infoBtn.Position = UDim2.new(0.05, 0, 0, 256)
    infoBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 90)
    infoBtn.Text = "📊 檢查數量 UI"
    infoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    infoBtn.TextScaled = true
    infoBtn.Font = Enum.Font.Gotham
    infoBtn.Parent = frame

    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 6)
    infoCorner.Parent = infoBtn

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
        if not isVerified then
            statusLabel.Text = "狀態：⚠️ 請先驗證 Key"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
            return
        end

        autoMode = not autoMode

        if autoMode then
            startBtn.Text = "⏹ 停止自動模式"
            startBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            statusLabel.Text = "狀態：🟢 運行中..."
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.spawn(mainLoop)
        else
            startBtn.Text = "▶ 開始自動模式"
            startBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 90)
            statusLabel.Text = "狀態：已停止"
            statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
        end
    end)

    sellBtn.MouseButton1Click:Connect(function()
        autoSell()
    end)

    infoBtn.MouseButton1Click:Connect(function()
        local pt = getProgressText()
        if pt then
            print("[檢查] ProgressText 路徑：", pt:GetFullName())
            print("[檢查] 目前文字：", pt.Text)
        else
            print("[檢查] ❌ 找不到 ProgressText")
        end
    end)

    task.spawn(function()
        while screenGui.Parent do
            updateCount()
            countLabel.Text = "📦 數量：" .. currentCount .. (maxCount > 0 and (" / " .. maxCount) or "")
            task.wait(0.3)
        end
    end)
end

-- ===== 初始化 =====
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    isBusy = false
end)

createUI()
print("[吃吃世界] v9 已載入 ✅ Key: POPCAT_kki471111")
