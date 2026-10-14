local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local MINIMIZED_ICON_ID = "rbxassetid://123060704186856"
local CORRECT_KEY = "kki471111" 

-- 開發者專屬名稱白名單
local DEVELOPER_NAME = "Popcat_xiaoge"

-- 有效 Key 資料庫表格 (格式: {["Key名稱"] = {isInfinite = bool, expireTime = 數字}})
local activeKeys = {
	["kki471111"] = {isInfinite = true, expireTime = 0} -- 預設包含你本來的 Key
}

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
KeyFrame.Size = UDim2.new(0, 320, 0, 220)
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

-- 標題
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 40)
KeyTitle.Position = UDim2.new(0, 0, 0, 10)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "請輸入驗證金鑰 (Key)"
KeyTitle.TextColor3 = Color3.fromRGB(20, 20, 20)
KeyTitle.TextSize = 16
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.Parent = KeyFrame

-- 輸入框 (TextBox)
local KeyTextBox = Instance.new("TextBox")
KeyTextBox.Size = UDim2.new(0.85, 0, 0, 40)
KeyTextBox.Position = UDim2.new(0.075, 0, 0, 55)
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

-- 紅色錯誤提示字
local ErrorLabel = Instance.new("TextLabel")
ErrorLabel.Size = UDim2.new(0.85, 0, 0, 20)
ErrorLabel.Position = UDim2.new(0.075, 0, 0, 100)
ErrorLabel.BackgroundTransparency = 1
ErrorLabel.Text = ""
ErrorLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
ErrorLabel.TextSize = 12
ErrorLabel.Font = Enum.Font.GothamBold
ErrorLabel.TextXAlignment = Enum.TextXAlignment.Left
ErrorLabel.Parent = KeyFrame

-- 確認按鈕
local SubmitBtn = Instance.new("TextButton")
SubmitBtn.Size = UDim2.new(0.85, 0, 0, 38)
SubmitBtn.Position = UDim2.new(0.075, 0, 0, 125)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SubmitBtn.Text = "驗證解鎖"
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitBtn.TextSize = 14
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.Parent = KeyFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = SubmitBtn

-- 開發者按鈕容器（建立 Key 按鈕 + 所有 Key 按鈕）
local DevBtnContainer = Instance.new("Frame")
DevBtnContainer.Size = UDim2.new(0.85, 0, 0, 30)
DevBtnContainer.Position = UDim2.new(0.075, 0, 0, 175)
DevBtnContainer.BackgroundTransparency = 1
DevBtnContainer.Visible = false
DevBtnContainer.Parent = KeyFrame

-- 建立新 Key 按鈕
local DevCreateBtn = Instance.new("TextButton")
DevCreateBtn.Size = UDim2.new(0.48, 0, 1, 0)
DevCreateBtn.Position = UDim2.new(0, 0, 0, 0)
DevCreateBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
DevCreateBtn.Text = "⚙️ 建立新 Key"
DevCreateBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DevCreateBtn.TextSize = 11
DevCreateBtn.Font = Enum.Font.GothamBold
DevCreateBtn.Parent = DevBtnContainer

local DCB_Corner = Instance.new("UICorner")
DCB_Corner.CornerRadius = UDim.new(0, 8)
DCB_Corner.Parent = DevCreateBtn

-- 所有 Key 管理按鈕
local DevListBtn = Instance.new("TextButton")
DevListBtn.Size = UDim2.new(0.48, 0, 1, 0)
DevListBtn.Position = UDim2.new(0.52, 0, 0, 0)
DevListBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
DevListBtn.Text = "📋 所有 Key"
DevListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
DevListBtn.TextSize = 11
DevListBtn.Font = Enum.Font.GothamBold
DevListBtn.Parent = DevBtnContainer

local DLB_Corner = Instance.new("UICorner")
DLB_Corner.CornerRadius = UDim.new(0, 8)
DLB_Corner.Parent = DevListBtn

----------------------------------------------------
-- 1.2 開發者面板：建立 Key
----------------------------------------------------
local DevPanel = Instance.new("Frame")
DevPanel.Name = "DevPanel"
DevPanel.Size = UDim2.new(0, 360, 0, 320)
DevPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
DevPanel.AnchorPoint = Vector2.new(0.5, 0.5)
DevPanel.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
DevPanel.BackgroundTransparency = 0.05
DevPanel.Visible = false
DevPanel.Active = true
DevPanel.Draggable = true
DevPanel.Parent = ScreenGui

local DevPanelCorner = Instance.new("UICorner")
DevPanelCorner.CornerRadius = UDim.new(0, 14)
DevPanelCorner.Parent = DevPanel

local DevPanelStroke = Instance.new("UIStroke")
DevPanelStroke.Color = Color3.fromRGB(52, 152, 219)
DevPanelStroke.Thickness = 2
DevPanelStroke.Parent = DevPanel

local DevPanelTitle = Instance.new("TextLabel")
DevPanelTitle.Size = UDim2.new(1, 0, 0, 40)
DevPanelTitle.Position = UDim2.new(0, 0, 0, 10)
DevPanelTitle.BackgroundTransparency = 1
DevPanelTitle.Text = "🛠️ 開發者專屬：建立金鑰面板"
DevPanelTitle.TextColor3 = Color3.fromRGB(40, 40, 40)
DevPanelTitle.TextSize = 16
DevPanelTitle.Font = Enum.Font.GothamBold
DevPanelTitle.Parent = DevPanel

local NewKeyBox = Instance.new("TextBox")
NewKeyBox.Size = UDim2.new(0.85, 0, 0, 35)
NewKeyBox.Position = UDim2.new(0.075, 0, 0, 55)
NewKeyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
NewKeyBox.PlaceholderText = "輸入要建立的 Key 名稱..."
NewKeyBox.Text = ""
NewKeyBox.TextColor3 = Color3.fromRGB(20, 20, 20)
NewKeyBox.TextSize = 13
NewKeyBox.Font = Enum.Font.Gotham
NewKeyBox.Parent = DevPanel

local NewKeyCorner = Instance.new("UICorner")
NewKeyCorner.CornerRadius = UDim.new(0, 6)
NewKeyCorner.Parent = NewKeyBox

local timeInputs = {}
local labels = {"年", "月", "日", "時", "秒"}
for i, labelText in ipairs(labels) do
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0.15, 0, 0, 35)
	box.Position = UDim2.new(0.075 + (i-1)*0.17, 0, 0, 105)
	box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderText = labelText
	box.Text = "0"
	box.TextColor3 = Color3.fromRGB(20, 20, 20)
	box.TextSize = 13
	box.Font = Enum.Font.Gotham
	box.Parent = DevPanel
	
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = box
	timeInputs[labelText] = box
end

local InfiniteContainer = Instance.new("Frame")
InfiniteContainer.Size = UDim2.new(0.85, 0, 0, 30)
InfiniteContainer.Position = UDim2.new(0.075, 0, 0, 155)
InfiniteContainer.BackgroundTransparency = 1
InfiniteContainer.Parent = DevPanel

local CheckBoxBtn = Instance.new("TextButton")
CheckBoxBtn.Size = UDim2.new(0, 24, 0, 24)
CheckBoxBtn.Position = UDim2.new(0, 0, 0.5, -12)
CheckBoxBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CheckBoxBtn.Text = ""
CheckBoxBtn.Parent = InfiniteContainer

local CheckBoxCorner = Instance.new("UICorner")
CheckBoxCorner.CornerRadius = UDim.new(0, 4)
CheckBoxCorner.Parent = CheckBoxBtn

local CheckBoxText = Instance.new("TextLabel")
CheckBoxText.Size = UDim2.new(1, -35, 1, 0)
CheckBoxText.Position = UDim2.new(0, 32, 0, 0)
CheckBoxText.BackgroundTransparency = 1
CheckBoxText.Text = "無限時間 (永久有效)"
CheckBoxText.TextColor3 = Color3.fromRGB(50, 50, 50)
CheckBoxText.TextSize = 13
CheckBoxText.Font = Enum.Font.GothamBold
CheckBoxText.TextXAlignment = Enum.TextXAlignment.Left
CheckBoxText.Parent = InfiniteContainer

local isInfinite = false
CheckBoxBtn.MouseButton1Click:Connect(function()
	isInfinite = not isInfinite
	if isInfinite then
		CheckBoxBtn.Text = "✔"
		CheckBoxBtn.TextColor3 = Color3.fromRGB(46, 204, 113)
	else
		CheckBoxBtn.Text = ""
	end
end)

local CreateConfirmBtn = Instance.new("TextButton")
CreateConfirmBtn.Size = UDim2.new(0.4, 0, 0, 35)
CreateConfirmBtn.Position = UDim2.new(0.075, 0, 0, 210)
CreateConfirmBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
CreateConfirmBtn.Text = "確認創建"
CreateConfirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CreateConfirmBtn.TextSize = 13
CreateConfirmBtn.Font = Enum.Font.GothamBold
CreateConfirmBtn.Parent = DevPanel

local CCB_Corner = Instance.new("UICorner")
CCB_Corner.CornerRadius = UDim.new(0, 6)
CCB_Corner.Parent = CreateConfirmBtn

local CloseDevBtn = Instance.new("TextButton")
CloseDevBtn.Size = UDim2.new(0.4, 0, 0, 35)
CloseDevBtn.Position = UDim2.new(0.525, 0, 0, 210)
CloseDevBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
CloseDevBtn.Text = "返回驗證"
CloseDevBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseDevBtn.TextSize = 13
CloseDevBtn.Font = Enum.Font.GothamBold
CloseDevBtn.Parent = DevPanel

local CDB_Corner = Instance.new("UICorner")
CDB_Corner.CornerRadius = UDim.new(0, 6)
CDB_Corner.Parent = CloseDevBtn

local DevStatusLabel = Instance.new("TextLabel")
DevStatusLabel.Size = UDim2.new(0.85, 0, 0, 30)
DevStatusLabel.Position = UDim2.new(0.075, 0, 0, 260)
DevStatusLabel.BackgroundTransparency = 1
DevStatusLabel.Text = ""
DevStatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
DevStatusLabel.TextSize = 12
DevStatusLabel.Font = Enum.Font.GothamBold
DevStatusLabel.Parent = DevPanel

----------------------------------------------------
-- 1.3 開發者面板：所有 Key 管理清單 (List Panel)
----------------------------------------------------
local ListPanel = Instance.new("Frame")
ListPanel.Name = "ListPanel"
ListPanel.Size = UDim2.new(0, 360, 0, 320)
ListPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
ListPanel.AnchorPoint = Vector2.new(0.5, 0.5)
ListPanel.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
ListPanel.BackgroundTransparency = 0.05
ListPanel.Visible = false
ListPanel.Active = true
ListPanel.Draggable = true
ListPanel.Parent = ScreenGui

local ListPanelCorner = Instance.new("UICorner")
ListPanelCorner.CornerRadius = UDim.new(0, 14)
ListPanelCorner.Parent = ListPanel

local ListPanelStroke = Instance.new("UIStroke")
ListPanelStroke.Color = Color3.fromRGB(155, 89, 182)
ListPanelStroke.Thickness = 2
ListPanelStroke.Parent = ListPanel

local ListTitle = Instance.new("TextLabel")
ListTitle.Size = UDim2.new(1, 0, 0, 40)
ListTitle.Position = UDim2.new(0, 0, 0, 10)
ListTitle.BackgroundTransparency = 1
ListTitle.Text = "📋 所有生效中的 Key 清單"
ListTitle.TextColor3 = Color3.fromRGB(40, 40, 40)
ListTitle.TextSize = 16
ListTitle.Font = Enum.Font.GothamBold
ListTitle.Parent = ListPanel

-- 捲動清單容器 (ScrollingFrame)
local KeyScrollingFrame = Instance.new("ScrollingFrame")
KeyScrollingFrame.Size = UDim2.new(0.85, 0, 0, 200)
KeyScrollingFrame.Position = UDim2.new(0.075, 0, 0, 55)
KeyScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyScrollingFrame.BorderSizePixel = 0
KeyScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
KeyScrollingFrame.Parent = ListPanel

local KS_Corner = Instance.new("UICorner")
KS_Corner.CornerRadius = UDim.new(0, 8)
KS_Corner.Parent = KeyScrollingFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = KeyScrollingFrame

local CloseListBtn = Instance.new("TextButton")
CloseListBtn.Size = UDim2.new(0.85, 0, 0, 35)
CloseListBtn.Position = UDim2.new(0.075, 0, 0, 265)
CloseListBtn.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
CloseListBtn.Text = "返回驗證"
CloseListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseListBtn.TextSize = 13
CloseListBtn.Font = Enum.Font.GothamBold
CloseListBtn.Parent = ListPanel

local CLB_Corner = Instance.new("UICorner")
CLB_Corner.CornerRadius = UDim.new(0, 6)
CLB_Corner.Parent = CloseListBtn

-- 更新並刷新 Key 清單的函數
local function refreshKeyList()
	-- 清除舊的清單項目
	for _, child in pairs(KeyScrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	
	local count = 0
	for kVal, data in pairs(activeKeys) do
		count = count + 1
		local itemFrame = Instance.new("Frame")
		itemFrame.Size = UDim2.new(1, -10, 0, 35)
		itemFrame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
		itemFrame.Parent = KeyScrollingFrame
		
		local ifCorner = Instance.new("UICorner")
		ifCorner.CornerRadius = UDim.new(0, 6)
		ifCorner.Parent = itemFrame
		
		local keyText = Instance.new("TextLabel")
		keyText.Size = UDim2.new(0.65, 0, 1, 0)
		keyText.Position = UDim2.new(0.05, 0, 0, 0)
		keyText.BackgroundTransparency = 1
		keyText.Text = kVal .. (data.isInfinite and " (永久)" : " (限時)")
		keyText.TextColor3 = Color3.fromRGB(40, 40, 40)
		keyText.TextSize = 12
		keyText.Font = Enum.Font.GothamBold
		keyText.TextXAlignment = Enum.TextXAlignment.Left
		keyText.Parent = itemFrame
		
		-- 紅色刪除/停止按鈕 (⛔)
		local deleteBtn = Instance.new("TextButton")
		deleteBtn.Size = UDim2.new(0, 50, 0, 26)
		deleteBtn.Position = UDim2.new(1, -55, 0.5, -13)
		deleteBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
		deleteBtn.Text = "⛔ 停用"
		deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		deleteBtn.TextSize = 11
		deleteBtn.Font = Enum.Font.GothamBold
		deleteBtn.Parent = itemFrame
		
		local dbCorner = Instance.new("UICorner")
		dbCorner.CornerRadius = UDim.new(0, 4)
		dbCorner.Parent = deleteBtn
		
		-- 點擊停止按鍵，直接刪除該 Key
		deleteBtn.MouseButton1Click:Connect(function()
			activeKeys[kVal] = nil
			refreshKeyList()
			print("【開發者後台】已將 Key: " . kVal . " 停用並刪除！")
		end)
	end
	
	KeyScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, count * 40)
end

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
TitleLabel.Text = "吃吃世界 | 5分鐘定時掛機"
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
-- 3. 自動掛機介面與計時器
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

local TimerLabel = Instance.new("TextLabel")
TimerLabel.Size = UDim2.new(0.88, 0, 0, 30)
TimerLabel.Position = UDim2.new(0.06, 0, 0, 125)
TimerLabel.BackgroundTransparency = 1
TimerLabel.Text = "下一次自動出售倒數：05:00 (已暫停)"
TimerLabel.TextColor3 = Color3.fromRGB(100, 100, 100)
TimerLabel.TextSize = 13
TimerLabel.Font = Enum.Font.Gotham
TimerLabel.TextXAlignment = Enum.TextXAlignment.Left
TimerLabel.Parent = MainFrame

----------------------------------------------------
-- 4. 核心邏輯：權限、驗證、建立與管理 Key
----------------------------------------------------

if LocalPlayer.Name == DEVELOPER_NAME then
	KeyFrame.Size = UDim2.new(0, 320, 0, 250)
	DevBtnContainer.Visible = true
end

DevCreateBtn.MouseButton1Click:Connect(function()
	KeyFrame.Visible = false
	DevPanel.Visible = true
end)

DevListBtn.MouseButton1Click:Connect(function()
	KeyFrame.Visible = false
	refreshKeyList()
	ListPanel.Visible = true
end)

CloseDevBtn.MouseButton1Click:Connect(function()
	DevPanel.Visible = false
	KeyFrame.Visible = true
end)

CloseListBtn.MouseButton1Click:Connect(function()
	ListPanel.Visible = false
	KeyFrame.Visible = true
end)

CreateConfirmBtn.MouseButton1Click:Connect(function()
	local keyName = NewKeyBox.Text
	if keyName == "" then
		DevStatusLabel.TextColor3 = Color3.fromRGB(231, 76, 60)
		DevStatusLabel.Text = "錯誤：Key 名稱不能為空！"
		return
	end
	
	-- 登記到 activeKeys 表格中
	activeKeys[keyName] = {
		isInfinite = isInfinite,
		expireTime = os.time() + 86400 -- 範例預設值
	}
	
	DevStatusLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
	DevStatusLabel.Text = "成功創建 Key: " .. keyName
	print("【開發者後台】成功建立並生效新 Key: " .. keyName)
end)

