local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MINIMIZED_ICON_ID = "rbxassetid://120749806700474"
local CORRECT_KEY = "kki471111" 

-- 建立 ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomEatventureUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

----------------------------------------------------
-- 1. Key 驗證面板
----------------------------------------------------
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 320, 0, 180)
KeyFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyFrame.AnchorPoint = Vector2.new(0.5, 0.5)
KeyFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyFrame.BackgroundTransparency = 0.05
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 14)
KeyCorner.Parent = KeyFrame

local KeyStroke = Instance.new("UIStroke")
KeyStroke.Color = Color3.fromRGB(220, 220, 220)
KeyStroke.Thickness = 1.5
KeyStroke.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "請輸入驗證金鑰 (Key)"
KeyTitle.TextColor3 = Color3.fromRGB(20, 20, 20)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyTextBox.Position = UDim2.new(0.075, 0, 0, 60)
KeyTextBox.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
KeyTextBox.PlaceholderText = "在此輸入 Key..."
KeyTextBox.Text = ""
KeyTextBox.TextColor3 = Color3.fromRGB(20, 20, 20)
KeyTextBox.TextSize = 14
KeyTextBox.Font = Enum.Font.Gotham
KeyTextBox.ClearTextOnFocus = false
KeyTextBox.Parent = KeyFrame

local BoxCorner = Instance.new("UICorner")
BoxCorner.CornerRadius = UDim.new(0, 8)
BoxCorner.Parent = KeyTextBox

local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
SubmitBtn.Position = UDim2.new(0.075, 0, 0, 115)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SubmitBtn.Text = "驗證解鎖"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SubmitBtn

----------------------------------------------------
-- 2. 主面板 (Main Frame)
----------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 240)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BackgroundTransparency = 0.05 
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true 
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(220, 220, 220)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -50, 0, 40)
TitleLabel.Position = UDim2.new(0, 16, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "吃吃世界 | 定時掛機選單"
TitleLabel.TextColor3 = Color3.fromRGB(20, 20, 20)
TitleLabel.TextSize = 18
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -38, 0, 5)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(50, 50, 50)
MinimizeBtn.TextSize = 18
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = MainFrame

-- 縮小按鈕
local MiniIconBtn = Instance.new("ImageButton")
MiniIconBtn.Name = "MiniIconBtn"
MiniIconBtn.Size = UDim2.new(0, 0, 0, 0)
MiniIconBtn.Position = UDim2.new(0.08, 0, 0.2, 0)
MiniIconBtn.AnchorPoint = Vector2.new(0.5, 0.5)
MiniIconBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MiniIconBtn.Image = MINIMIZED_ICON_ID
MiniIconBtn.Visible = false
MiniIconBtn.Active = true
MiniIconBtn.Draggable = true
MiniIconBtn.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniIconBtn

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(200, 200, 200)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniIconBtn

----------------------------------------------------
-- 3. 「巨量自動掛機」開關與計時器顯示元件
----------------------------------------------------
local ToggleContainer = Instance.new("Frame")
ToggleContainer.Size = UDim2.new(0.88, 0, 0, 50)
ToggleContainer.Position = UDim2.new(0.06, 0, 0, 60)
ToggleContainer.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
ToggleContainer.Parent = MainFrame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleContainer

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
ToggleLabel.Position = UDim2.new(0.05, 0, 0, 0)
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.Text = "巨量自動掛機"
ToggleLabel.TextColor3 = Color3.fromRGB(40, 40, 40)
ToggleLabel.TextSize = 15
ToggleLabel.Font = Enum.Font.GothamBold
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.Parent = ToggleContainer

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 60, 0, 30)
ToggleBtn.Position = UDim2.new(1, -70, 0.5, -15)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
ToggleBtn.Text = "關閉"
ToggleBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
ToggleBtn.TextSize = 13
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = ToggleContainer

local BtnCorner2 = Instance.new("UICorner")
BtnCorner2.CornerRadius = UDim.new(0, 8)
BtnCorner2.Parent = ToggleBtn

-- 倒數計時器文字標籤
local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.88, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.06, 0, 0, 125)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "下一次自動出售倒數：10:00 (已暫停)"
TimerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
TimerLabel.TextSize = 13
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = MainFrame

----------------------------------------------------
-- 4. 核心邏輯：10 分鐘可暫停/恢復計時器與掛機迴圈
----------------------------------------------------
local autoFarmActive = false
local timeRemaining = 600 -- 10 分鐘 = 600 秒

-- 格式化秒數為 MM:SS 格式
local function formatTime(seconds)
	local mins = math.floor(seconds / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d", mins, secs)
end

-- 獨立的計時器服務 (每秒扣除 1 秒)
task.spawn(function()
	while true do
		if autoFarmActive then
			if timeRemaining > 0 then
				timeRemaining = timeRemaining - 1
				TimerLabel.Text = "下一次自動出售倒數：" .. formatTime(timeRemaining)
			else
				-- 倒數歸零，觸發出售！
				local character = LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
				local events = character and character:FindFirstChild("Events")
				local sellEvent = events and events:FindFirstChild("Sell")
				
				if sellEvent then
					pcall(function()
						print("[10分鐘時間到] 正在執行自動出售...")
						sellEvent:FireServer()
					end)
				end
				
				-- 重置為 10 分鐘
				timeRemaining = 600
				TimerLabel.Text = "下一次自動出售倒數：10:00"
			end
		end
		task.wait(1) -- 精確的 1 秒間隔
	end
end)

-- 開關點擊事件
ToggleBtn.MouseButton1Click:Connect(function()
	autoFarmActive = not autoFarmActive
	
	if autoFarmActive then
		ToggleBtn.Text = "開啟"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		TimerLabel.Text = "下一次自動出售倒數：" .. formatTime(timeRemaining)
		
		-- 啟動「抓跟吃」的循環任務
		task.spawn(function()
			while autoFarmActive do
				local character = LocalPlayer.Character or workspace:FindFirstChild(LocalPlayer.Name)
				local events = character and character:FindFirstChild("Events")
				
				if events then
					-- 1. 抓東西
					local grabEvent = events:FindFirstChild("Grab")
					if grabEvent then
						pcall(function() grabEvent:FireServer(false, false, false) end)
					end
					
					task.wait(0.1)
					
					-- 2. 吃東西
					local eatEvent = events:FindFirstChild("Eat")
					if eatEvent then
						pcall(function() eatEvent:FireServer() end)
					end
				end
				
				task.wait(0.2) -- 循環間隔時間
			end
		end)
	else
		ToggleBtn.Text = "關閉"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
		ToggleBtn.TextColor3 = Color3.fromRGB(100, 100, 100)
		TimerLabel.Text = "下一次自動出售倒數：" .. formatTime(timeRemaining) .. " (已暫停)"
	end
end)

-- Key 驗證邏輯
SubmitBtn.MouseButton1Click:Connect(function()
	if KeyTextBox.Text == CORRECT_KEY then
		SubmitBtn.Text = "驗證成功！"
		SubmitBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
		task.wait(0.8)
		KeyFrame:Destroy()
		MainFrame.Visible = true
	else
		SubmitBtn.Text = "Key 錯誤！"
		SubmitBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
		task.wait(1)
		SubmitBtn.Text = "驗證解鎖"
		SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end
end)

-- 縮小與展開主面板邏輯
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.InOut)

local function minimizeUI()
	local mainTween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
	mainTween:Play()
	mainTween.Completed:Connect(function()
		MainFrame.Visible = false
		MiniIconBtn.Visible = true
		local iconTween = TweenService:Create(MiniIconBtn, tweenInfo, {Size = UDim2.new(0, 48, 0, 48)})
		iconTween:Play()
	end)
end

local function restoreUI()
	local iconTween = TweenService:Create(MiniIconBtn, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
	iconTween:Play()
	iconTween.Completed:Connect(function()
		MiniIconBtn.Visible = false
		MainFrame.Visible = true
		local mainTween = TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 360, 0, 240)})
		mainTween:Play()
	end)
end

MinimizeBtn.MouseButton1Click:Connect(minimizeUI)
MiniIconBtn.MouseButton1Click:Connect(restoreUI)
