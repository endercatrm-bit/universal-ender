--[[
    ENDER MENU v7.0 - ULTIMATE EDITION
    25 categories, 80+ features
    Improved UI, popup windows, config save/load
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- CONNECTION MANAGER
local CM = {}
CM._c = {}
CM._l = {}

function CM:Add(n, c)
    if self._c[n] then pcall(function() self._c[n]:Disconnect() end) end
    self._c[n] = c
end
function CM:Rem(n)
    if self._c[n] then pcall(function() self._c[n]:Disconnect() end); self._c[n] = nil end
end
function CM:Loop(n, f, d)
    self._l[n] = nil
    self._l[n] = true
    task.spawn(function()
        while self._l[n] do f(); task.wait(d or 0.1) end
    end)
end
function CM:Stop(n) self._l[n] = nil end
function CM:All()
    for _, c in pairs(self._c) do pcall(function() c:Disconnect() end) end
    self._c = {}
    for n in pairs(self._l) do self._l[n] = nil end
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "EnderMenu"
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- SOUNDS
local Snd = {}
Snd._ = {}

local SndIds = {
    Click  = "rbxassetid://139719503904449",
    Toggle = "rbxassetid://2707021263",
    Swoosh = "rbxassetid://2235655773",
    Bell   = "rbxassetid://131573697",
    Pop    = "rbxassetid://4590662766",
    Error  = "rbxassetid://9120389897",
    Success = "rbxassetid://6042053626",
    FlingSuc = "rbxassetid://9120389897",
}

function Snd:Play(name)
    local s = self._[name]
    if s then pcall(function() s:Stop(); s:Play() end) end
end

for name, id in pairs(SndIds) do
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = 0.35
    s.Parent = gui
    Snd._[name] = s
end

-- NOTIFICATIONS
local notifFolder = Instance.new("Folder")
notifFolder.Name = "Notifs"
notifFolder.Parent = gui

local function Notify(text, color, icon)
    task.spawn(function()
        Snd:Play("Bell")
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 0, 0, 40)
        f.Position = UDim2.new(0.5, 0, 1, -70)
        f.AnchorPoint = Vector2.new(0.5, 0)
        f.BackgroundColor3 = color or Color3.fromRGB(25, 0, 50)
        f.BackgroundTransparency = 0.05
        f.BorderSizePixel = 0
        f.Parent = notifFolder
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        local st = Instance.new("UIStroke", f)
        st.Color = Color3.fromRGB(140, 60, 255)
        st.Thickness = 1
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -16, 1, 0)
        l.Position = UDim2.new(0, 8, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = (icon or ">") .. " " .. text
        l.TextColor3 = Color3.new(1, 1, 1)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Center
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 300, 0, 40)}):Play()
        task.wait(2)
        TweenService:Create(f, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 40), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        f:Destroy()
    end)
end

-- POPUP WINDOW SYSTEM
local function CreatePopup(title, sizeX, sizeY)
    local popup = Instance.new("Frame")
    popup.Size = UDim2.new(0, sizeX or 300, 0, sizeY or 200)
    popup.Position = UDim2.new(0.5, -(sizeX or 300)/2, 0.5, -(sizeY or 200)/2)
    popup.BackgroundColor3 = Color3.fromRGB(20, 0, 40)
    popup.BorderSizePixel = 0
    popup.ZIndex = 100
    popup.Parent = gui
    Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 12)
    local stk = Instance.new("UIStroke", popup)
    stk.Color = Color3.fromRGB(140, 60, 255)
    stk.Thickness = 2

    local tb = Instance.new("Frame")
    tb.Size = UDim2.new(1, 0, 0, 28)
    tb.BackgroundColor3 = Color3.fromRGB(60, 0, 110)
    tb.BorderSizePixel = 0
    tb.ZIndex = 101
    tb.Parent = popup
    Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 12)

    local tt = Instance.new("TextLabel", tb)
    tt.Text = title
    tt.Size = UDim2.new(1, -30, 1, 0)
    tt.Position = UDim2.new(0, 10, 0, 0)
    tt.BackgroundTransparency = 1
    tt.TextColor3 = Color3.new(1,1,1)
    tt.Font = Enum.Font.GothamBold
    tt.TextSize = 14
    tt.TextXAlignment = Enum.TextXAlignment.Left
    tt.ZIndex = 102

    local cb = Instance.new("TextButton", tb)
    cb.Size = UDim2.new(0, 24, 0, 24)
    cb.Position = UDim2.new(1, -26, 0, 2)
    cb.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cb.Text = "X"
    cb.TextColor3 = Color3.new(1,1,1)
    cb.Font = Enum.Font.GothamBold
    cb.TextSize = 14
    cb.ZIndex = 102
    cb.BorderSizePixel = 0
    Instance.new("UICorner", cb).CornerRadius = UDim.new(1, 0)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -34)
    content.Position = UDim2.new(0, 5, 0, 30)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ZIndex = 101
    content.Parent = popup

    cb.MouseButton1Click:Connect(function()
        Snd:Play("Click")
        popup:Destroy()
    end)

    local dragging, ds, sp = false, nil, nil
    tb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; ds = i.Position; sp = popup.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local d = i.Position - ds
            popup.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
        end
    end)

    popup.Size = UDim2.new(0, 0, 0, 0)
    popup.ClipsDescendants = true
    TweenService:Create(popup, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Size = UDim2.new(0, sizeX or 300, 0, sizeY or 200)}):Play()

    return content
end
-- MAIN UI
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.new(0,0,0)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Visible = false
overlay.Parent = gui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 750, 0, 580)
main.Position = UDim2.new(0.5, -375, 0.5, -290)
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

local mg = Instance.new("UIGradient")
mg.Rotation = 45
mg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 30)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 0, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 30))
})
mg.Parent = main
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(140, 60, 255)
stroke.Thickness = 2
stroke.Transparency = 0.25

-- Particles
for i = 1, 30 do
    local p = Instance.new("Frame")
    p.BackgroundColor3 = Color3.fromRGB(math.random(100,255), math.random(50,150), math.random(200,255))
    p.Size = UDim2.new(0, math.random(2,5), 0, math.random(2,5))
    p.BorderSizePixel = 0
    p.BackgroundTransparency = 0.7
    p.Parent = main
    Instance.new("UICorner", p).CornerRadius = UDim.new(1,0)
    p.Position = UDim2.new(math.random(),0,math.random(),0)
    task.spawn(function()
        while p and p.Parent do
            TweenService:Create(p, TweenInfo.new(math.random(4,8), Enum.EasingStyle.Linear), {Position = UDim2.new(math.random(),0,math.random(),0)}):Play()
            task.wait(math.random(4,8))
        end
    end)
end

-- Title bar
local tb = Instance.new("Frame")
tb.Size = UDim2.new(1,0,0,34)
tb.BackgroundColor3 = Color3.fromRGB(45, 0, 95)
tb.BorderSizePixel = 0
tb.Parent = main
Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 16)

local tgrad = Instance.new("UIGradient", tb)
tgrad.Rotation = 0
tgrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 0, 150)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 0, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 150))
})

local ttl = Instance.new("TextLabel", tb)
ttl.Text = " ENDER MENU v7.0"
ttl.Size = UDim2.new(1,-70,1,0)
ttl.Position = UDim2.new(0,12,0,0)
ttl.BackgroundTransparency = 1
ttl.TextColor3 = Color3.new(1,1,1)
ttl.Font = Enum.Font.GothamBold
ttl.TextSize = 16
ttl.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", tb)
minBtn.Size = UDim2.new(0,26,0,26)
minBtn.Position = UDim2.new(1,-56,0,4)
minBtn.BackgroundColor3 = Color3.fromRGB(100,100,30)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 16
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(1,0)

local cb2 = Instance.new("TextButton", tb)
cb2.Size = UDim2.new(0,26,0,26)
cb2.Position = UDim2.new(1,-28,0,4)
cb2.BackgroundColor3 = Color3.fromRGB(200,50,50)
cb2.Text = "X"
cb2.TextColor3 = Color3.new(1,1,1)
cb2.Font = Enum.Font.GothamBold
cb2.TextSize = 16
cb2.BorderSizePixel = 0
Instance.new("UICorner", cb2).CornerRadius = UDim.new(1,0)

-- Drag
local dragging, ds, sp = false, nil, nil
local vx, vy = 0, 0
tb.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; ds = i.Position; sp = main.Position
    end
end)
UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        sp = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
    end
end)
RunService.RenderStepped:Connect(function()
    if dragging then
        local dx = sp.X.Offset - main.Position.X.Offset
        local dy = sp.Y.Offset - main.Position.Y.Offset
        vx = (vx + dx * 0.2) * 0.85
        vy = (vy + dy * 0.2) * 0.85
    else
        vx = vx * 0.8
        vy = vy * 0.8
    end
    if math.abs(vx) > 0.1 or math.abs(vy) > 0.1 then
        main.Position = UDim2.new(main.Position.X.Scale, main.Position.X.Offset + vx, main.Position.Y.Scale, main.Position.Y.Offset + vy)
    end
end)

-- Rainbow BG
task.spawn(function()
    while gui and gui.Parent do
        local h = tick() * 0.1 % 1
        mg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h, 0.8, 0.12)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV((h+0.3)%1, 0.8, 0.30)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((h+0.6)%1, 0.8, 0.12))
        })
        tgrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(h, 0.7, 0.35)),
            ColorSequenceKeypoint.new(0.5, Color3.fromHSV((h+0.3)%1, 0.9, 0.55)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV((h+0.6)%1, 0.7, 0.35))
        })
        stroke.Color = Color3.fromHSV(h, 0.7, 0.7)
        task.wait(0.05)
    end
end)

-- Menu open/close
local menuVis = false
local animating = false
local minimized = false
local prevSize = nil

local function OpenMenu()
    if menuVis or animating then return end
    animating = true; menuVis = true
    overlay.Visible = true; main.Visible = true
    main.Size = UDim2.new(0,0,0,0)
    Snd:Play("Swoosh")
    TweenService:Create(overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.45}):Play()
    local t = TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = UDim2.new(0, 750, 0, 580)})
    t:Play()
    t.Completed:Connect(function() animating = false end)
end

local function CloseMenu()
    if not menuVis or animating then return end
    animating = true
    Snd:Play("Swoosh")
    TweenService:Create(overlay, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
    local t = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0)})
    t:Play()
    t.Completed:Connect(function()
        main.Visible = false; overlay.Visible = false
        menuVis = false; animating = false
        main.Size = UDim2.new(0, 750, 0, 580)
    end)
end

cb2.MouseButton1Click:Connect(function() Snd:Play("Click"); CloseMenu() end)
minBtn.MouseButton1Click:Connect(function()
    Snd:Play("Click")
    if not minimized then
        prevSize = main.Size
        TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 160, 0, 34)}):Play()
        minimized = true
    else
        local t = TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = prevSize or UDim2.new(0, 750, 0, 580)})
        t:Play()
        minimized = false
    end
end)

UserInputService.InputBegan:Connect(function(i, gpe)
    if gpe then return end
    if i.KeyCode == Enum.KeyCode.K then
        if minimized then minimized = false; main.Size = prevSize or UDim2.new(0, 750, 0, 580) end
        if menuVis then CloseMenu() else OpenMenu() end
    end
end)

-- LEFT PANEL
local lp = Instance.new("ScrollingFrame")
lp.Size = UDim2.new(0, 140, 1, -34)
lp.Position = UDim2.new(0, 0, 0, 34)
lp.BackgroundColor3 = Color3.fromRGB(18, 0, 38)
lp.BorderSizePixel = 0
lp.CanvasSize = UDim2.new(0, 0, 0, 0)
lp.ScrollBarThickness = 3
lp.Parent = main
Instance.new("UICorner", lp).CornerRadius = UDim.new(0, 16)

local cf = Instance.new("ScrollingFrame")
cf.Size = UDim2.new(1, -140, 1, -34)
cf.Position = UDim2.new(0, 140, 0, 34)
cf.BackgroundColor3 = Color3.fromRGB(25, 0, 48)
cf.BorderSizePixel = 0
cf.CanvasSize = UDim2.new(0,0,0,0)
cf.ScrollBarThickness = 5
cf.Parent = main
Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 16)

local cats = {
    "1.Movement","2.ESP","3.Misc","4.Visual","5.Aimbot",
    "6.Teleports","7.Combat","8.Animations","9.Fun","10.Player",
    "11.World","12.Settings","13.Chat","14.Items","15.Effects",
    "16.Sound","17.Keybinds","18.Server","19.Bypass","20.Admin",
    "21.Building","22.Doors","23.Safety","24.Skins","25.About","26.Extra"
}

local catBtns = {}
local catCons = {}
local curCat

local function UpdCanvas()
    if not curCat or not catCons[curCat] then return end
    local mx = 0
    for _, c in ipairs(catCons[curCat]:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextButton") or c:IsA("TextBox") or c:IsA("ScrollingFrame") then
            local b = c.Position.Y.Offset + c.Size.Y.Offset
            if b > mx then mx = b end
        end
    end
    cf.CanvasSize = UDim2.new(0,0,0, mx + 30)
end

local function MkCatBtn(name, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 28)
    b.Position = UDim2.new(0, 3, 0, 4 + (order-1)*30)
    b.BackgroundColor3 = Color3.fromRGB(55, 0, 100)
    b.Text = name
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.Parent = lp
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseEnter:Connect(function()
        if not (curCat and catBtns[curCat] == b) then
            b.BackgroundColor3 = Color3.fromRGB(90, 25, 160)
        end
    end)
    b.MouseLeave:Connect(function()
        b.BackgroundColor3 = (curCat and catBtns[curCat] == b) and Color3.fromRGB(100,0,170) or Color3.fromRGB(55, 0, 100)
    end)
    return b
end

for i, cn in ipairs(cats) do
    local b = MkCatBtn(cn, i)
    catBtns[i] = b
    local con = Instance.new("Frame")
    con.Size = UDim2.new(1, -8, 0, 0)
    con.Position = UDim2.new(0, 4, 0, 4)
    con.BackgroundTransparency = 1
    con.Visible = false
    con.Parent = cf
    catCons[i] = con
    b.MouseButton1Click:Connect(function()
        Snd:Play("Click")
        if curCat and catCons[curCat] then catCons[curCat].Visible = false end
        curCat = i; con.Visible = true
        for j, bb in ipairs(catBtns) do
            bb.BackgroundColor3 = j == i and Color3.fromRGB(100,0,170) or Color3.fromRGB(55, 0, 100)
        end
        UpdCanvas()
    end)
end
catCons[1].Visible = true; curCat = 1; catBtns[1].BackgroundColor3 = Color3.fromRGB(100,0,170)
lp.CanvasSize = UDim2.new(0,0,0, #cats * 30 + 20)
-- WIDGETS
local function Slider(par, y, name, mn, mx, def, cb)
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(1,-16,0,38)
    fr.Position = UDim2.new(0,8,0,y)
    fr.BackgroundTransparency = 1
    fr.Parent = par
    local lb = Instance.new("TextLabel", fr)
    lb.Size = UDim2.new(0,85,0,18)
    lb.BackgroundTransparency = 1
    lb.Text = name
    lb.TextColor3 = Color3.new(1,1,1)
    lb.Font = Enum.Font.Gotham
    lb.TextSize = 13
    lb.TextXAlignment = Enum.TextXAlignment.Left
    local tr = Instance.new("Frame", fr)
    tr.Size = UDim2.new(1,-130,0,5)
    tr.Position = UDim2.new(0,90,0,8)
    tr.BackgroundColor3 = Color3.fromRGB(80,80,80)
    tr.BorderSizePixel = 0
    Instance.new("UICorner", tr).CornerRadius = UDim.new(1,0)
    local fl = Instance.new("Frame", tr)
    fl.Size = UDim2.new(0,0,1,0)
    fl.BackgroundColor3 = Color3.fromRGB(100,200,255)
    fl.BorderSizePixel = 0
    Instance.new("UICorner", fl).CornerRadius = UDim.new(1,0)
    local bt = Instance.new("TextButton", tr)
    bt.Size = UDim2.new(0,14,0,14)
    bt.Position = UDim2.new(0,0,0.5,-7)
    bt.BackgroundColor3 = Color3.new(1,1,1)
    bt.Text = ""
    bt.BorderSizePixel = 0
    Instance.new("UICorner", bt).CornerRadius = UDim.new(1,0)
    local vl = Instance.new("TextLabel", fr)
    vl.Size = UDim2.new(0,40,0,18)
    vl.Position = UDim2.new(1,-42,0,0)
    vl.BackgroundTransparency = 1
    vl.TextColor3 = Color3.new(1,1,1)
    vl.Font = Enum.Font.Gotham
    vl.TextSize = 13
    vl.Text = tostring(def)
    vl.TextXAlignment = Enum.TextXAlignment.Right
    local val = def
    local ds = false
    local function set(p)
        p = math.clamp(p,0,1)
        val = mn + (mx-mn)*p
        val = math.floor(val*10+0.5)/10
        vl.Text = tostring(val)
        fl.Size = UDim2.new(p,0,1,0)
        bt.Position = UDim2.new(p,-7,0.5,-7)
        cb(val)
    end
    local function upd()
        local mp = UserInputService:GetMouseLocation()
        set((mp.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X)
    end
    bt.MouseButton1Down:Connect(function() ds = true; Snd:Play("Click"); upd() end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then ds = false end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if ds and i.UserInputType == Enum.UserInputType.MouseMovement then upd() end
    end)
    set((def-mn)/(mx-mn))
end

local function Toggle(par, y, text, cb)
    local fr = Instance.new("Frame")
    fr.Size = UDim2.new(1,-16,0,28)
    fr.Position = UDim2.new(0,8,0,y)
    fr.BackgroundTransparency = 1
    fr.Parent = par
    local lb = Instance.new("TextLabel", fr)
    lb.Size = UDim2.new(0.7,0,1,0)
    lb.BackgroundTransparency = 1
    lb.Text = text
    lb.TextColor3 = Color3.new(1,1,1)
    lb.Font = Enum.Font.Gotham
    lb.TextSize = 13
    lb.TextXAlignment = Enum.TextXAlignment.Left
    local bt = Instance.new("TextButton", fr)
    bt.Size = UDim2.new(0,44,0,20)
    bt.Position = UDim2.new(1,-48,0,4)
    bt.Text = ""
    bt.BorderSizePixel = 0
    Instance.new("UICorner", bt).CornerRadius = UDim.new(1,0)
    local on = false
    local function vis()
        bt.BackgroundColor3 = on and Color3.fromRGB(0,160,60) or Color3.fromRGB(160,30,30)
        bt.Text = on and "ON" or "OFF"
        bt.TextColor3 = Color3.new(1,1,1)
        bt.Font = Enum.Font.GothamBold
        bt.TextSize = 11
    end
    vis()
    bt.MouseEnter:Connect(function() bt.BackgroundColor3 = on and Color3.fromRGB(0,190,70) or Color3.fromRGB(190,40,40) end)
    bt.MouseLeave:Connect(function() vis() end)
    bt.MouseButton1Click:Connect(function() on = not on; vis(); Snd:Play("Toggle"); cb(on) end)
    return {Set = function(_,s) on = s; vis(); cb(on) end, Get = function() return on end}
end

local function Button(par, y, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-16,0,28)
    b.Position = UDim2.new(0,8,0,y)
    b.BackgroundColor3 = Color3.fromRGB(75, 0, 140)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.BorderSizePixel = 0
    b.Parent = par
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseEnter:Connect(function() b.BackgroundColor3 = Color3.fromRGB(110, 20, 190) end)
    b.MouseLeave:Connect(function() b.BackgroundColor3 = Color3.fromRGB(75, 0, 140) end)
    b.MouseButton1Click:Connect(function() Snd:Play("Click"); cb() end)
end

local function TBox(par, y, placeholder, txt)
    local ti = Instance.new("TextBox")
    ti.Size = UDim2.new(1, -16, 0, 28)
    ti.Position = UDim2.new(0, 8, 0, y)
    ti.PlaceholderText = placeholder
    ti.Text = txt or ""
    ti.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ti.TextColor3 = Color3.new(1,1,1)
    ti.Font = Enum.Font.Gotham
    ti.TextSize = 13
    ti.BorderSizePixel = 0
    ti.Parent = par
    Instance.new("UICorner", ti).CornerRadius = UDim.new(0, 6)
    return ti
end

-- CONFIG SAVE/LOAD
local function SaveCfg()
    pcall(function()
        if not writefile then Notify("Save unsupported", Color3.fromRGB(200,100,0), "!") return end
        local d = {ws=wsVal, jp=jpVal, ss=ssVal, sm=sMul, fs=flySpd, fp=flingPow, fov=70, gr=normGrav, vol=0.35}
        writefile("ENDER_v7_cfg.txt", HttpService:JSONEncode(d))
        Notify("Config saved!", Color3.fromRGB(0,150,0), "V")
    end)
end

local function LoadCfg()
    pcall(function()
        if not readfile then Notify("Load unsupported", Color3.fromRGB(200,100,0), "!") return end
        local d = HttpService:JSONDecode(readfile("ENDER_v7_cfg.txt"))
        if d then
            wsVal = d.ws or 16; jpVal = d.jp or 50; ssVal = d.ss or 16; sMul = d.sm or 1
            flySpd = d.fs or 50; flingPow = d.fp or 10000; normGrav = d.gr or 196
            ApplyMove()
            Notify("Config loaded!", Color3.fromRGB(0,150,0), "V")
        end
    end)
end

-- GLOBALS
local wsVal, jpVal, ssVal, sMul = 16, 50, 16, 1
local flyOn, ncOn, flySpd, flyAcc = false, false, 50, 0
local flyGyro, flyVel, gravOn = nil, nil, false
local flyAnim = nil
local normGrav = Workspace.Gravity
local returnPos = nil
local flingOn, flingKeyOn, flingPow = false, false, 10000
local flingTargets = {}
local flingListOn = false
local flingingNow = false
local infJmp = false
local espHL, espBX, espNM, espDS, espTracers, espChams = false, false, false, false, false, false
local eR, eG, eB = 255, 0, 0
local espC = Color3.fromRGB(255,0,0)
local aimOn, aimKey, aimFOV, aimSm, aimMd, aimTeamCheck = false, "E", 100, 1, "mouse", false
local dFE = Lighting.FogEnd or 1000
local curAnim, animSpd = nil, 1
local savedPos = nil
local keybinds = {}

local function ApplyMove()
    local c = player.Character; if not c then return end
    local h = c:FindFirstChild("Humanoid"); if not h then return end
    h.WalkSpeed = wsVal * sMul; h.JumpPower = jpVal
    pcall(function() h.SwimSpeed = ssVal end)
end
local function EnableFly()
    local c = player.Character
    if not c or not c:FindFirstChild("HumanoidRootPart") then return end
    local r = c.HumanoidRootPart; local h = c.Humanoid
    for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do pcall(function() h:SetStateEnabled(s, false) end) end
    h:ChangeState(Enum.HumanoidStateType.Swimming)
    flyGyro = Instance.new("BodyGyro"); flyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9); flyGyro.P = 9e4; flyGyro.CFrame = r.CFrame; flyGyro.Parent = r
    flyVel = Instance.new("BodyVelocity"); flyVel.MaxForce = Vector3.new(9e9,9e9,9e9); flyVel.Velocity = Vector3.new(0,0.1,0); flyVel.Parent = r
    pcall(function()
        if flyAnim then flyAnim:Stop(); flyAnim = nil end
        local animator = h:FindFirstChildOfClass("Animator")
        if not animator then animator = Instance.new("Animator"); animator.Parent = h end
        local a = Instance.new("Animation"); a.AnimationId = "rbxassetid://61610350"
        flyAnim = animator:LoadAnimation(a)
        flyAnim.Priority = Enum.AnimationPriority.Core
        flyAnim:Play(math.huge)
    end)
    CM:Add("Fly", RunService.RenderStepped:Connect(function()
        if not flyOn or not r or not r.Parent then return end
        local cf = {f=UserInputService:IsKeyDown(Enum.KeyCode.W) and 1 or 0, b=UserInputService:IsKeyDown(Enum.KeyCode.S) and -1 or 0, l=UserInputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0, r=UserInputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0}
        local md = cf.f+cf.b+cf.l+cf.r
        flyAcc = (md ~= 0) and math.min(flyAcc + 0.5 + flyAcc/flySpd, flySpd) or math.max(flyAcc - 1, 0)
        local cam = Workspace.CurrentCamera
        if cam then
            local lk = cam.CFrame.LookVector; local rt = cam.CFrame.RightVector
            local mv = lk*(cf.f+cf.b)+rt*(cf.l+cf.r)
            if mv.Magnitude > 0 then mv = mv.Unit end
            flyVel.Velocity = mv*flyAcc + Vector3.new(0, (UserInputService:IsKeyDown(Enum.KeyCode.Space) and flySpd/2 or 0)+(UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and -flySpd/2 or 0), 0)
            if mv.Magnitude > 0 then
                flyGyro.CFrame = CFrame.lookAt(rp.Position, rp.Position + mv)
            end
        end
    end))
end

local function DisableFly()
    CM:Rem("Fly")
    if flyGyro then flyGyro:Destroy(); flyGyro = nil end
    if flyVel then flyVel:Destroy(); flyVel = nil end
    local c = player.Character
    if c then local h = c:FindFirstChild("Humanoid"); if h then for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do pcall(function() h:SetStateEnabled(s, true) end) end end end
    if flyAnim then pcall(function() flyAnim:Stop() end); flyAnim = nil end
end

local function SkidFling(tp, duration, flingPowVal)
    local c = player.Character
    if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid")
    local rp = h and h.RootPart
    if not rp then return end
    local tc = tp.Character
    if not tc then return end
    local trp = tc:FindFirstChild("HumanoidRootPart") or tc:FindFirstChild("Head")
    if not trp then return end
    local savedPos = rp.CFrame
    returnPos = savedPos
    local savedFPDH = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = 0/0
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9); bv.Parent = rp
    local bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9); bg.CFrame = CFrame.Angles(math.random(),math.random(),math.random())
    bg.Parent = rp
    pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Seated, false) end)
    local ang = 0; local st = tick()
    local pow = flingPowVal or 9e7
    while tick() - st < (duration or 1.5) do
        if not rp or not rp.Parent or not trp or not trp.Parent then break end
        ang = ang + 100
        local pos = CFrame.new(trp.Position)
        rp.CFrame = pos * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(ang), 0, 0)
        c:SetPrimaryPartCFrame(rp.CFrame)
        rp.Velocity = Vector3.new(pow, pow*10, pow)
        rp.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        bv.Velocity = rp.Velocity
        task.wait()
        if not rp or not rp.Parent or not trp or not trp.Parent then break end
        rp.CFrame = pos * CFrame.new(0, -1.5, 0) * CFrame.Angles(math.rad(ang), 0, 0)
        c:SetPrimaryPartCFrame(rp.CFrame)
        rp.Velocity = Vector3.new(pow, pow*10, pow)
        bv.Velocity = rp.Velocity
        task.wait()
    end
    bv:Destroy(); bg:Destroy()
    pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Seated, true) end)
    if savedPos and rp and rp.Parent then
        local returnTarget = savedPos + Vector3.new(0, 1, 0)
        rp.Velocity = Vector3.new(); rp.RotVelocity = Vector3.new()
        rp.AssemblyLinearVelocity = Vector3.new(); rp.AssemblyAngularVelocity = Vector3.new()
        local bvRet = Instance.new("BodyVelocity")
        bvRet.MaxForce = Vector3.new(9e9, 9e9, 9e9); bvRet.Parent = rp
        local bg2 = Instance.new("BodyGyro")
        bg2.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bg2.CFrame = CFrame.new(); bg2.Parent = rp
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        local st = tick()
        while tick() - st < 3 do
            local dist = (rp.Position - returnTarget.Position).Magnitude
            if dist < 0.5 then break end
            local dir = (returnTarget.Position - rp.Position).Unit
            local spd = math.max(dist * 3, 0.3)
            if dist < 5 then spd = math.min(spd, dist * 0.6) end
            bvRet.Velocity = dir * spd
            bg2.CFrame = returnTarget
            task.wait()
        end
        rp.Velocity = Vector3.new(); rp.RotVelocity = Vector3.new()
        rp.CFrame = returnTarget; c:SetPrimaryPartCFrame(returnTarget)
        bvRet:Destroy(); bg2:Destroy()
        if not ncOn then
            for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end
        end
    end
    returnPos = nil
    workspace.FallenPartsDestroyHeight = savedFPDH
end

local function DoFling()
    task.spawn(function()
        if flingingNow then return end
        flingingNow = true
        local c = player.Character
        if not c then flingingNow = false; return end
        local rp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
        if not rp then flingingNow = false; return end
        local nearest, nd = nil, 9e9
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= player and pl.Character then
                local trp = pl.Character:FindFirstChild("HumanoidRootPart") or pl.Character:FindFirstChild("Head")
                if trp then
                    local d = (rp.Position - trp.Position).Magnitude
                    if d < nd then nd = d; nearest = pl end
                end
            end
        end
        if not nearest then flingingNow = false; return end
        SkidFling(nearest, 1.5, flingPow)
        Notify("[" .. nearest.Name .. "] fling success", Color3.fromRGB(0, 200, 80), ">")
        Snd:Play("FlingSuc")
        flingingNow = false
    end)
end

local function SkidFlingTarget(tp)
    task.spawn(function()
        if flingingNow then return end
        flingingNow = true
        if not tp or not tp.Character then flingingNow = false; return end
        SkidFling(tp, 1.5, flingPow)
        Notify("[" .. tp.Name .. "] fling success", Color3.fromRGB(0, 200, 80), ">")
        Snd:Play("FlingSuc")
        flingingNow = false
    end)
end

local flingGunOn = false
local flingGunDot, flingGunBeam, flingGunUpd = nil, nil, nil
local function FlingGunOff()
    flingGunOn = false
    if flingGunUpd then flingGunUpd:Disconnect(); flingGunUpd = nil end
    if flingGunDot then flingGunDot:Destroy(); flingGunDot = nil end
    if flingGunBeam then flingGunBeam:Destroy(); flingGunBeam = nil end
    CM:Rem("FlingGunRMB"); CM:Rem("FlingGunRMBUp"); CM:Rem("FlingGunLMB"); CM:Rem("FlingGunLMBUp")
    Notify("Fling Gun OFF", Color3.fromRGB(200,0,0), "X")
end
local function FlingGunOn()
    flingGunOn = true
    flingGunDot = Instance.new("Part"); flingGunDot.Size = Vector3.new(0.6,0.6,0.6); flingGunDot.Shape = Enum.PartType.Ball; flingGunDot.Anchored = true; flingGunDot.CanCollide = false; flingGunDot.Material = Enum.Material.Neon; flingGunDot.Color = Color3.fromRGB(180, 0, 255); flingGunDot.Transparency = 0.2
    flingGunBeam = Instance.new("Part"); flingGunBeam.Size = Vector3.new(0.2,0.2,1); flingGunBeam.Anchored = true; flingGunBeam.CanCollide = false; flingGunBeam.Material = Enum.Material.Neon; flingGunBeam.Color = Color3.fromRGB(140, 0, 255); flingGunBeam.Transparency = 0.3
    local function GetOrigin()
        local c = player.Character
        if c then
            local rp = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
            if rp then return rp.Position end
        end
        local cam = workspace.CurrentCamera
        return cam and cam.CFrame.Position or Vector3.new()
    end
    local function ShowBeam(from, to)
        if not flingGunDot or not flingGunBeam then return end
        flingGunDot.Parent = workspace.CurrentCamera; flingGunBeam.Parent = workspace.CurrentCamera
        flingGunDot.Position = to
        local mid = (from + to) / 2; local dist = (from - to).Magnitude
        if dist > 0.5 then
            flingGunBeam.CFrame = CFrame.lookAt(mid, to); flingGunBeam.Size = Vector3.new(0.2, 0.2, dist)
        end
    end
    local function HideBeam()
        if flingGunDot then flingGunDot.Parent = nil end
        if flingGunBeam then flingGunBeam.Parent = nil end
    end
    local function TryGetTarget()
        local m = UserInputService:GetMouseLocation()
        local ok, uray = pcall(function() return workspace.CurrentCamera:ViewportPointToRay(m.X, m.Y) end)
        if ok and uray then
            local ok2, hit = pcall(function() return workspace:FindPartOnRay(Ray.new(uray.Origin, uray.Direction * 9999)) end)
            if ok2 and hit then return hit end
        end
        return nil
    end
    local function TryGetPos()
        local m = UserInputService:GetMouseLocation()
        local ok, uray = pcall(function() return workspace.CurrentCamera:ViewportPointToRay(m.X, m.Y) end)
        if ok and uray then
            local ok2, hit, pos = pcall(function() return workspace:FindPartOnRay(Ray.new(uray.Origin, uray.Direction * 9999)) end)
            if ok2 and hit then return pos end
            return uray.Origin + uray.Direction * 500
        end
        return Vector3.new()
    end
    CM:Add("FlingGunRMB", UserInputService.InputBegan:Connect(function(i, gpe)
        if gpe or not flingGunOn then return end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then
            if flingGunUpd then flingGunUpd:Disconnect() end
            flingGunUpd = RunService.RenderStepped:Connect(function()
                local pos = TryGetPos()
                local origin = GetOrigin()
                ShowBeam(origin, pos)
            end)
        end
    end))
    CM:Add("FlingGunRMBUp", UserInputService.InputEnded:Connect(function(i, gpe)
        if gpe or not flingGunOn then return end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then HideBeam() end
    end))
    CM:Add("FlingGunLMB", UserInputService.InputBegan:Connect(function(i, gpe)
        if gpe or not flingGunOn then return end
        if i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        local hit = TryGetTarget()
        if not hit then Notify("No target detected", Color3.fromRGB(200,0,0), "X"); return end
        local targetChar = hit:FindFirstAncestorWhichIsA("Model")
        if not targetChar or not targetChar:FindFirstChild("Humanoid") then return end
        local targetPl = Players:GetPlayerFromCharacter(targetChar)
        if not targetPl or targetPl == player then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player and pl.Character == targetChar then targetPl = pl; break end
            end
            if not targetPl then return end
        end
        local c = player.Character; local rp = c and c:FindFirstChild("HumanoidRootPart")
        if not rp then return end
        if flingGunUpd then flingGunUpd:Disconnect(); flingGunUpd = nil end
        HideBeam()
        flingingNow = true
        local ok = pcall(function() SkidFling(targetPl, 1.5, flingPow) end)
        flingingNow = false
        if ok then
            Notify("[" .. targetPl.Name .. "] fling success", Color3.fromRGB(0, 200, 80), ">")
            Snd:Play("FlingSuc")
        else
            Notify("[" .. targetPl.Name .. "] fling failed", Color3.fromRGB(200, 0, 0), "X")
        end
    end))
    CM:Add("FlingGunLMBUp", UserInputService.InputEnded:Connect(function(i, gpe)
        if gpe or not flingGunOn then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 then HideBeam() end
    end))
    Notify("Fling Gun ON - RMB to aim, LMB to fling", Color3.fromRGB(160, 0, 255), ">")
end
local function ToggleFlingGun()
    if flingGunOn then FlingGunOff() else FlingGunOn() end
end
-- ESP
local function MkESP(pl)
    if pl == player then return end
    local c = pl.Character; if not c then return end
    for _, n in ipairs({"ESP_HL","ESP_BX","ESP_NM","ESP_DS","ESP_TR","ESP_CH"}) do local o = c:FindFirstChild(n); if o then o:Destroy() end end
    if not (espHL or espBX or espNM or espDS or espTracers or espChams) then return end
    local hd = c:WaitForChild("Head", 2); if not hd then return end
    if espHL then local h = Instance.new("Highlight"); h.Name="ESP_HL"; h.FillTransparency=1; h.OutlineColor=espC; h.Parent=c end
    if espBX then local bb=Instance.new("BillboardGui"); bb.Name="ESP_BX"; bb.Size=UDim2.new(0,4,0,6); bb.AlwaysOnTop=true; bb.Adornee=hd; bb.Parent=c; local f=Instance.new("Frame",bb); f.Size=UDim2.new(1,0,1,0); f.BackgroundTransparency=1; f.BorderSizePixel=2; f.BorderColor3=espC end
    if espNM then local bb=Instance.new("BillboardGui"); bb.Name="ESP_NM"; bb.Size=UDim2.new(0,100,0,20); bb.StudsOffset=Vector3.new(0,2,0); bb.AlwaysOnTop=true; bb.Adornee=hd; bb.Parent=c; local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=pl.Name; l.TextColor3=espC; l.Font=Enum.Font.GothamBold; l.TextSize=14; l.TextStrokeTransparency=0.5 end
    if espDS then local bb=Instance.new("BillboardGui"); bb.Name="ESP_DS"; bb.Size=UDim2.new(0,100,0,16); bb.StudsOffset=Vector3.new(0,-1,0); bb.AlwaysOnTop=true; bb.Adornee=hd; bb.Parent=c; local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=""; l.TextColor3=espC; l.Font=Enum.Font.Gotham; l.TextSize=11; l.TextStrokeTransparency=0.5 end
    if espTracers then local bb=Instance.new("BillboardGui"); bb.Name="ESP_TR"; bb.Size=UDim2.new(0,3,0,3); bb.AlwaysOnTop=true; bb.Adornee=hd; bb.Parent=c; local f=Instance.new("Frame",bb); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=espC; f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(1,0) end
    if espChams then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = 0.5 end end end
end

local function RefESP() for _, o in ipairs(Players:GetPlayers()) do if o ~= player then MkESP(o) end end end
local function UpdEspC() espC = Color3.fromRGB(eR,eG,eB); RefESP() end

CM:Add("ESP_Join", Players.PlayerAdded:Connect(function(o) o.CharacterAdded:Connect(function() task.wait(0.5); MkESP(o) end); if o.Character then MkESP(o) end end))
CM:Loop("ESP_Dist", function() if espDS then RefESP() end end, 0.3)

-- CHAT HELPER
local function SendChatMsg(msg)
    pcall(function()
        local tcs = game:GetService("TextChatService")
        local tc = tcs:FindFirstChild("TextChannels")
        if tc then
            local ch = tc:FindFirstChild("RBXGeneral") or tc:FindFirstChild("General") or tc:FindFirstChild("Lobby") or tc:FindFirstChild("All")
            if ch then ch:SendAsync(msg); return end
            for _, c in ipairs(tc:GetChildren()) do
                if c:IsA("TextChannel") then c:SendAsync(msg); return end
            end
        end
    end)
    pcall(function()
        local rs = ReplicatedStorage
        for _, path in ipairs({
            {"DefaultSystemChatChatEvents","SayMessageRequest"},
            {"DefaultChatSystemChatEvents","SayMessageRequest"},
            {"Chat","SayMessageRequest"},
        }) do
            local obj = rs
            for _, name in ipairs(path) do
                if not obj then break end
                obj = obj:FindFirstChild(name)
            end
            if obj and (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) then
                obj:FireServer(msg)
                task.wait()
                obj:FireServer(msg, "All")
                return
            end
        end
    end)
    pcall(function() game:GetService("VirtualUser"):Chat(msg) end)
end

-- CATEGORY 1: MOVEMENT
local mc = catCons[1]
Toggle(mc, 6, "Fly", function(s) flyOn = s; if s then EnableFly() else DisableFly() end; Notify("Fly: "..(s and "ON" or "OFF")) end)
Slider(mc, 42, "Fly Speed", 20, 200, 50, function(v) flySpd = v end)
Toggle(mc, 84, "NoClip", function(s)
    ncOn = s
    if s then CM:Loop("NoClip", function() local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end, 0.05) else CM:Stop("NoClip") end
    Notify("NoClip: "..(s and "ON" or "OFF"))
end)
Slider(mc, 120, "Speed Multi", 1, 10, 1, function(v) sMul = v; ApplyMove() end)
Slider(mc, 160, "WalkSpeed", 16, 300, 16, function(v) wsVal = v; ApplyMove() end)
Slider(mc, 200, "JumpPower", 50, 300, 50, function(v) jpVal = v; ApplyMove() end)
Slider(mc, 240, "SwimSpeed", 16, 200, 16, function(v) ssVal = v; ApplyMove() end)
Toggle(mc, 280, "Zero Gravity", function(s)
    gravOn = s
    if s then
        Workspace.Gravity = 0
        local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then h.Sit = true; task.wait(0.1); if h.RootPart then h.RootPart.CFrame = h.RootPart.CFrame * CFrame.Angles(math.pi*0.5,0,0) end; for _, t in ipairs(h:GetPlayingAnimationTracks()) do t:Stop() end end end
        CM:Add("ZeroGrav", UserInputService.JumpRequest:Connect(function() if gravOn then gravOn = false; Workspace.Gravity = normGrav end end))
    else CM:Rem("ZeroGrav"); Workspace.Gravity = normGrav end
    Notify("Zero Gravity: "..(s and "ON" or "OFF"))
end)
local bhopHud = Instance.new("TextLabel")
bhopHud.Size = UDim2.new(0, 160, 0, 32)
bhopHud.Position = UDim2.new(0.5, -80, 1, -120)
bhopHud.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bhopHud.BackgroundTransparency = 0.25
bhopHud.TextColor3 = Color3.new(0, 1, 1)
bhopHud.Font = Enum.Font.GothamBold
bhopHud.TextSize = 18
bhopHud.Text = "Speed: 0"
bhopHud.BorderSizePixel = 0
bhopHud.ZIndex = 100
bhopHud.Visible = false
bhopHud.Parent = gui
Instance.new("UICorner", bhopHud).CornerRadius = UDim.new(0, 10)

local prevLook = nil
Toggle(mc, 316, "BunnyHop", function(s)
    bhopHud.Visible = s
    if s then
        prevLook = nil
        CM:Add("Bhop", RunService.RenderStepped:Connect(function()
            local c = player.Character; if not c then return end
            local rp = c:FindFirstChild("HumanoidRootPart"); if not rp then return end
            local h = c:FindFirstChild("Humanoid"); if not h then return end
            local onGround = h.FloorMaterial ~= Enum.Material.Air
            local cam = Workspace.CurrentCamera
            if not onGround and cam then
                local fwd = cam.CFrame.LookVector
                local flat = Vector3.new(fwd.X, 0, fwd.Z).Unit
                local right = cam.CFrame.RightVector
                if prevLook then
                    local prevFlat = Vector3.new(prevLook.X, 0, prevLook.Z).Unit
                    local cross = prevFlat:Cross(flat)
                    local turnSpd = -cross.Y
                    if math.abs(turnSpd) > 0.001 then
                        local add = turnSpd * 60
                        local fwdAdd = math.abs(turnSpd) * 25
                        rp.Velocity = rp.Velocity + Vector3.new(right.X * add + flat.X * fwdAdd, 0, right.Z * add + flat.Z * fwdAdd)
                    end
                end
                prevLook = fwd
                rp.CFrame = CFrame.lookAt(rp.Position, rp.Position + flat)
            end
            local spd = Vector3.new(rp.Velocity.X, 0, rp.Velocity.Z).Magnitude
            bhopHud.Text = string.format("Speed: %.0f", spd)
        end))
    else
        CM:Rem("Bhop")
        prevLook = nil
    end
    Notify("BunnyHop: "..(s and "ON" or "OFF"))
end)
Toggle(mc, 352, "Sprint (Shift)", function(s)
    if s then
        local baseWs = wsVal * sMul
        CM:Add("Sprint", UserInputService.InputBegan:Connect(function(i, gpe)
            if gpe then return end
            if i.KeyCode == Enum.KeyCode.LeftShift then
                local c = player.Character
                if c and c:FindFirstChild("Humanoid") then
                    c.Humanoid.WalkSpeed = baseWs * 3
                end
            end
        end))
        CM:Add("SprintEnd", UserInputService.InputEnded:Connect(function(i, gpe)
            if gpe then return end
            if i.KeyCode == Enum.KeyCode.LeftShift then
                local c = player.Character
                if c and c:FindFirstChild("Humanoid") then
                    c.Humanoid.WalkSpeed = baseWs
                end
            end
        end))
    else
        CM:Rem("Sprint"); CM:Rem("SprintEnd")
        local c = player.Character
        if c and c:FindFirstChild("Humanoid") then
            c.Humanoid.WalkSpeed = wsVal * sMul
        end
    end
    Notify("Sprint: "..(s and "ON" or "OFF"))
end)
Slider(mc, 388, "Fling Power", 100, 100000, 10000, function(v) flingPow = v end)
Toggle(mc, 424, "Fling (Auto)", function(s) flingOn = s; if s then CM:Loop("Fling", function() if flingOn then DoFling() end end, 0.15) else CM:Stop("Fling") end; Notify("Auto Fling: "..(s and "ON" or "OFF")) end)
Toggle(mc, 460, "Fling (Key E)", function(s) flingKeyOn = s; if s then CM:Add("FlingKey", UserInputService.InputBegan:Connect(function(i,gpe) if gpe then return end; if i.KeyCode == Enum.KeyCode.E then DoFling() end end)) else CM:Rem("FlingKey") end; Notify("Fling (Key): "..(s and "ON" or "OFF")) end)
Toggle(mc, 496, "Float", function(s) if s then CM:Loop("Float", function() local c = player.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.Velocity = Vector3.new(c.HumanoidRootPart.Velocity.X, 0.5, c.HumanoidRootPart.Velocity.Z) end end, 0) else CM:Stop("Float") end end)
Toggle(mc, 532, "Spin Bot", function(s) if s then CM:Loop("Spin", function() local c = player.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0) end end, 0) else CM:Stop("Spin") end; Notify("Spin Bot: "..(s and "ON" or "OFF")) end)
Button(mc, 566, "Save Position", function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then savedPos = player.Character.HumanoidRootPart.Position; Notify("Pos saved!", Color3.fromRGB(0,150,0), "V") end end)
Button(mc, 600, "Load Position", function() if savedPos and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(savedPos); Notify("TP to saved pos", nil, ">") end end)
Button(mc, 634, "Fling List (Multi)", function()
    local pp = CreatePopup("Fling List", 300, 350)
    local sel = {}
    local sc = Instance.new("ScrollingFrame", pp); sc.Size=UDim2.new(1,-16,1,-90); sc.Position=UDim2.new(0,8,0,4); sc.BackgroundTransparency=1; sc.ScrollBarThickness=4; sc.CanvasSize=UDim2.new(0,0,0,0); Instance.new("UIListLayout",sc).Padding=UDim.new(0,3)
    local function RefFL()
        for _, c in ipairs(sc:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
        for _, o in ipairs(Players:GetPlayers()) do if o~=player then
            local f=Instance.new("Frame",sc); f.Size=UDim2.new(1,0,0,28); f.BackgroundColor3=Color3.fromRGB(40,40,50); f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
            local lb=Instance.new("TextLabel",f); lb.Size=UDim2.new(1,-40,1,0); lb.Position=UDim2.new(0,8,0,0); lb.BackgroundTransparency=1; lb.Text=o.Name; lb.TextColor3=Color3.new(1,1,1); lb.Font=Enum.Font.Gotham; lb.TextSize=13; lb.TextXAlignment=Enum.TextXAlignment.Left
            local ck=Instance.new("TextButton",f); ck.Size=UDim2.new(0,22,0,22); ck.Position=UDim2.new(1,-28,0,3); ck.Text=""; ck.BackgroundColor3=Color3.fromRGB(60,60,70); ck.BorderSizePixel=0; Instance.new("UICorner",ck).CornerRadius=UDim.new(1,0)
            local cm=Instance.new("TextLabel",ck); cm.Size=UDim2.new(1,0,1,0); cm.BackgroundTransparency=1; cm.Text=""; cm.TextColor3=Color3.fromRGB(0,255,0); cm.Font=Enum.Font.GothamBold; cm.TextSize=14
            ck.MouseButton1Click:Connect(function()
                if sel[o.Name] then sel[o.Name]=nil; cm.Text="" else sel[o.Name]=o; cm.Text="V" end
            end)
        end end
        sc.CanvasSize = UDim2.new(0,0,0,(#Players:GetPlayers()-1)*33)
    end
    RefFL()
    local function FlingSelected()
        flingListOn = true
        task.spawn(function()
            while flingListOn do
                for _, tp in pairs(sel) do
                    if flingListOn and tp and tp.Parent then
                        SkidFlingTarget(tp)
                        task.wait(0.1)
                    end
                end
                task.wait(0.3)
            end
        end)
    end
    local stBtn=Instance.new("TextButton",pp); stBtn.Size=UDim2.new(0.5,-12,0,32); stBtn.Position=UDim2.new(0,8,0,300); stBtn.Text="START"; stBtn.BackgroundColor3=Color3.fromRGB(0,160,0); stBtn.TextColor3=Color3.new(1,1,1); stBtn.Font=Enum.Font.GothamBold; stBtn.TextSize=14; stBtn.BorderSizePixel=0; Instance.new("UICorner",stBtn).CornerRadius=UDim.new(0,6)
    stBtn.MouseButton1Click:Connect(function() if not flingListOn then FlingSelected(); Notify("Fling list started", Color3.fromRGB(0,150,0), ">") end end)
    local spBtn=Instance.new("TextButton",pp); spBtn.Size=UDim2.new(0.5,-12,0,32); spBtn.Position=UDim2.new(0.5,4,0,300); spBtn.Text="STOP"; spBtn.BackgroundColor3=Color3.fromRGB(160,0,0); spBtn.TextColor3=Color3.new(1,1,1); spBtn.Font=Enum.Font.GothamBold; spBtn.TextSize=14; spBtn.BorderSizePixel=0; Instance.new("UICorner",spBtn).CornerRadius=UDim.new(0,6)
    spBtn.MouseButton1Click:Connect(function() flingListOn = false; Notify("Fling list stopped", nil, "X") end)
end)
Toggle(mc, 634, "Fling Gun", function(s) if s then ToggleFlingGun() else ToggleFlingGun() end end)

-- CATEGORY 2: ESP
local ec = catCons[2]
Toggle(ec, 6, "Highlight", function(s) espHL = s; RefESP() end)
Toggle(ec, 38, "ESP Box", function(s) espBX = s; RefESP() end)
Toggle(ec, 70, "ESP Name", function(s) espNM = s; RefESP() end)
Toggle(ec, 102, "ESP Distance", function(s) espDS = s; RefESP() end)
Toggle(ec, 134, "Tracers", function(s) espTracers = s; RefESP() end)
Toggle(ec, 166, "Chams", function(s) espChams = s; RefESP() end)
Slider(ec, 202, "R", 0, 255, 255, function(v) eR = v; UpdEspC() end)
Slider(ec, 240, "G", 0, 255, 0, function(v) eG = v; UpdEspC() end)
Slider(ec, 278, "B", 0, 255, 0, function(v) eB = v; UpdEspC() end)
local cp = Instance.new("Frame"); cp.Size=UDim2.new(0,30,0,30); cp.Position=UDim2.new(0,8,0,320); cp.BackgroundColor3=espC; cp.BorderSizePixel=0; cp.Parent=ec; Instance.new("UICorner",cp).CornerRadius=UDim.new(0,6)
task.spawn(function() while gui and gui.Parent do cp.BackgroundColor3 = espC; task.wait(0.2) end end)

-- CATEGORY 3: MISC
local mx = catCons[3]
CM:Add("InfJmp", UserInputService.JumpRequest:Connect(function() if infJmp and player.Character then local h = player.Character:FindFirstChild("Humanoid"); if h and h:GetState() == Enum.HumanoidStateType.Freefall then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end))
Toggle(mx, 6, "Infinite Jump", function(s) infJmp = s; Notify("Inf Jump: "..(s and "ON" or "OFF")) end)
Toggle(mx, 38, "FullBright", function(s) Lighting.Brightness=s and 2 or 1; Lighting.ClockTime=s and 14 or 12; Lighting.FogEnd=s and 9999 or 1000; Notify("FullBright: "..(s and "ON" or "OFF")) end)
Toggle(mx, 70, "Anti-AFK", function(s) if s then CM:Add("AntiAFK", RunService.Idle:Connect(function() pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end)) else CM:Rem("AntiAFK") end; Notify("Anti-AFK: "..(s and "ON" or "OFF")) end)
Toggle(mx, 102, "Third Person", function(s) player.CameraMode = s and Enum.CameraMode.Classic or Enum.CameraMode.LockFirstPerson; if s then player.CameraMaxZoomDistance = 20 end end)
Slider(mx, 138, "FOV", 30, 120, 70, function(v) if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = v end end)
Toggle(mx, 178, "Auto Clicker", function(s) if s then CM:Loop("AutoClick", function() if mouse1click then mouse1click() end end, 0.05) else CM:Stop("AutoClick") end; Notify("Auto Clicker: "..(s and "ON" or "OFF")) end)
Toggle(mx, 210, "God Mode", function(s) if s then CM:Loop("GodMode", function() local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then h.MaxHealth = 9e9; h.Health = 9e9 end end end, 0.1) else CM:Stop("GodMode") end; Notify("God Mode: "..(s and "ON" or "OFF")) end)
Toggle(mx, 242, "Anti-Fling", function(s)
    if s then
        local safe = nil
        CM:Add("AntiFling", RunService.Stepped:Connect(function()
            if flingingNow then return end
            if not player.Character then return end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            pcall(function() hrp:SetNetworkOwner(player) end)
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0); hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
            if safe then if (hrp.Position-safe).Magnitude > 4 then hrp.CFrame = CFrame.new(safe) else safe = hrp.Position end else safe = hrp.Position end
        end))
    else CM:Rem("AntiFling") end
    Notify("Anti-Fling: "..(s and "ON" or "OFF"))
end)
Toggle(mx, 274, "No Fall Damage", function(s) local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then h.UseJumpPower = not s end end end)
Button(mx, 306, "Rejoin Server", function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end) end)
Button(mx, 340, "FPS Boost", function()
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() Lighting.FogEnd = 999999 end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function() for _, v in ipairs(Workspace:GetDescendants()) do if v:IsA("BasePart") then v.Material = Enum.Material.Plastic end end end)
    Notify("FPS Boost applied!", nil, "V")
end)
-- CATEGORY 4: VISUAL
local vc = catCons[4]
Toggle(vc, 6, "X-Ray", function(s) for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) then o.LocalTransparencyModifier = s and 0.5 or 0 end end end)
Toggle(vc, 38, "Wireframe", function(s) for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") then o.Wireframe = s end end end)
Toggle(vc, 70, "No Fog", function(s) Lighting.FogEnd = s and 0 or dFE end)
Toggle(vc, 102, "Remove Shadows", function(s) Lighting.GlobalShadows = not s end)
Toggle(vc, 134, "Night Mode", function(s) Lighting.ClockTime = s and 0 or 14; Lighting.Brightness = s and 0.5 or 2 end)
local fovCirc = nil
Toggle(vc, 166, "FOV Circle", function(s)
    if s then
        if not fovCirc then fovCirc = Instance.new("Frame", gui); fovCirc.Size = UDim2.new(0,200,0,200); fovCirc.Position = UDim2.new(0.5,-100,0.5,-100); fovCirc.BackgroundTransparency = 1; fovCirc.BorderSizePixel = 2; fovCirc.BorderColor3 = Color3.fromRGB(255,0,0); fovCirc.ZIndex = 10; Instance.new("UICorner", fovCirc).CornerRadius = UDim.new(1,0) end
        fovCirc.Visible = true
    else if fovCirc then fovCirc.Visible = false end end
end)
Toggle(vc, 198, "Crosshair", function(s)
    if s then
        Instance.new("Frame", gui).Name="Crosshair"; Instance.new("Frame", gui).Name="Crosshair2"
        local ch = gui:FindFirstChild("Crosshair"); if ch then ch.Size=UDim2.new(0,20,0,2); ch.Position=UDim2.new(0.5,-10,0.5,-1); ch.BackgroundColor3=Color3.new(1,1,1); ch.BorderSizePixel=0; ch.ZIndex=10 end
        local ch2 = gui:FindFirstChild("Crosshair2"); if ch2 then ch2.Size=UDim2.new(0,2,0,20); ch2.Position=UDim2.new(0.5,-1,0.5,-10); ch2.BackgroundColor3=Color3.new(1,1,1); ch2.BorderSizePixel=0; ch2.ZIndex=10 end
    else
        local a = gui:FindFirstChild("Crosshair"); if a then a:Destroy() end
        local b = gui:FindFirstChild("Crosshair2"); if b then b:Destroy() end
    end
end)
Toggle(vc, 230, "Watermark", function(s)
    if s then
        local w = Instance.new("TextLabel", gui); w.Name="Watermark"; w.Size=UDim2.new(0,240,0,24); w.Position=UDim2.new(0,10,0,10); w.BackgroundColor3=Color3.fromRGB(25,0,48); w.BackgroundTransparency=0.1; w.TextColor3=Color3.new(1,1,1); w.Font=Enum.Font.GothamBold; w.TextSize=12;         w.Text="ENDER v7.0 | FPS: --"; w.ZIndex=50; w.BorderSizePixel=0; Instance.new("UICorner",w).CornerRadius=UDim.new(0,8)
        CM:Loop("Watermark", function()         w.Text = string.format("ENDER v7.0 | FPS: %.0f | Players: %d", workspace:GetRealPhysicsFPS(), #Players:GetPlayers()) end, 0.5)
    else CM:Stop("Watermark"); local a = gui:FindFirstChild("Watermark"); if a then a:Destroy() end end
end)
Toggle(vc, 262, "Mouse Highlight", function(s)
    if s then
        CM:Loop("MouseHL", function()
            local mh = gui:FindFirstChild("MouseHL")
            if not mh then mh = Instance.new("Frame", gui); mh.Name="MouseHL"; mh.Size=UDim2.new(0,20,0,20); mh.AnchorPoint=Vector2.new(0.5,0.5); mh.BackgroundTransparency=0.5; mh.BackgroundColor3=Color3.fromRGB(255,50,50); mh.BorderSizePixel=0; mh.ZIndex=10; Instance.new("UICorner",mh).CornerRadius=UDim.new(1,0) end
            local mp = UserInputService:GetMouseLocation(); mh.Position = UDim2.new(0, mp.X, 0, mp.Y)
        end, 0)
    else CM:Stop("MouseHL"); local a = gui:FindFirstChild("MouseHL"); if a then a:Destroy() end end
end)
Toggle(vc, 294, "Item ESP", function(s)
    if s then
        CM:Loop("ItemESP", function()
            local kw = {"Coin","Gem","Chest","Loot","Present","Key","Artifact","Crystal","Orb","Star","Token","Sword","Gun"}
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and not o:FindFirstChild("ESP_Item") then
                    local nm = o.Name:lower()
                    for _, k in ipairs(kw) do if nm:find(k:lower()) then
                        local bb=Instance.new("BillboardGui"); bb.Name="ESP_Item"; bb.Size=UDim2.new(0,60,0,16); bb.StudsOffset=Vector3.new(0,2,0); bb.AlwaysOnTop=true; bb.Adornee=o; bb.Parent=o
                        local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=o.Name; l.TextColor3=Color3.fromRGB(255,255,0); l.Font=Enum.Font.Gotham; l.TextSize=10; break
                    end end
                end
            end
        end, 2)
    else CM:Stop("ItemESP"); for _, o in ipairs(Workspace:GetDescendants()) do local l=o:FindFirstChild("ESP_Item"); if l then l:Destroy() end end end
end)

-- CATEGORY 5: AIMBOT
local ac = catCons[5]
local function ClosestFOV()
    local cam = Workspace.CurrentCamera; if not cam then return nil end
    local c = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    local cl, md = nil, aimFOV
    for _, o in ipairs(Players:GetPlayers()) do
        if o ~= player and o.Character and o.Character:FindFirstChild("Head") then
            if aimTeamCheck and o.Team == player.Team then continue end
            local p, on = cam:WorldToScreenPoint(o.Character.Head.Position)
            if on then local d = (Vector2.new(p.X,p.Y)-c).Magnitude; if d < md then md = d; cl = o end end
        end
    end
    return cl
end
Toggle(ac, 6, "Aimbot", function(s)
    aimOn = s
    if s then CM:Add("Aim", RunService.RenderStepped:Connect(function()
        if not aimOn then return end
        if aimKey ~= "" and not UserInputService:IsKeyDown(Enum.KeyCode[aimKey]) then return end
        local t = ClosestFOV()
        if t and t.Character then local hd = t.Character:FindFirstChild("Head"); if hd then
            if aimMd == "mouse" then local tp = Workspace.CurrentCamera:WorldToScreenPoint(hd.Position); local m = UserInputService:GetMouseLocation(); mousemoverel((tp.X-m.X)/aimSm, (tp.Y-m.Y)/aimSm)
            else Workspace.CurrentCamera.CFrame = CFrame.new(Workspace.CurrentCamera.CFrame.Position, hd.Position) end
        end end
    end)) else CM:Rem("Aim") end
    Notify("Aimbot: "..(s and "ON" or "OFF"))
end)
Toggle(ac, 38, "Mode (Mouse/Cam)", function() aimMd = aimMd == "mouse" and "camera" or "mouse"; Notify("Aim: "..aimMd) end)
Toggle(ac, 70, "Team Check", function(s) aimTeamCheck = s end)
Slider(ac, 102, "FOV Radius", 30, 500, 100, function(v) aimFOV = v end)
Slider(ac, 140, "Smoothness", 1, 20, 1, function(v) aimSm = v end)
Toggle(ac, 182, "Trigger Bot", function(s)
    if s then CM:Loop("Trigger", function()
        local t = ClosestFOV()
        if t and t.Character then
            if aimTeamCheck and t.Team == player.Team then return end
            local l = t.Character:FindFirstChild("Head")
            if l and (l.Position - (Workspace.CurrentCamera and Workspace.CurrentCamera.CFrame.Position or Vector3.new())).Magnitude < 20 then
                if mouse1click then mouse1click() end
            end
        end
    end, 0.05) else CM:Stop("Trigger") end
end)

-- CATEGORY 6: TELEPORTS
local tc = catCons[6]
local pScr = Instance.new("ScrollingFrame"); pScr.Size=UDim2.new(1,-16,0,130); pScr.Position=UDim2.new(0,8,0,6); pScr.BackgroundColor3=Color3.fromRGB(30,30,35); pScr.BorderSizePixel=0; pScr.CanvasSize=UDim2.new(0,0,0,0); pScr.ScrollBarThickness=4; pScr.Parent=tc; Instance.new("UICorner",pScr).CornerRadius=UDim.new(0,8); Instance.new("UIListLayout",pScr).Padding=UDim.new(0,3)
local function RefPList()
    for _, c in ipairs(pScr:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local n = 0
    for _, o in ipairs(Players:GetPlayers()) do if o ~= player then n=n+1
        local b=Instance.new("TextButton"); b.Size=UDim2.new(1,-8,0,26); b.Text=o.Name; b.BackgroundColor3=Color3.fromRGB(45,45,55); b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamSemibold; b.TextSize=12; b.BorderSizePixel=0; b.Parent=pScr
        Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
        b.MouseEnter:Connect(function() b.BackgroundColor3=Color3.fromRGB(70,70,80) end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=Color3.fromRGB(45,45,55) end)
        b.MouseButton1Click:Connect(function() Snd:Play("Click"); if o.Character and o.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(o.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)); Notify("TP to "..o.Name, nil, ">") end end)
    end end
    pScr.CanvasSize = UDim2.new(0,0,0, n*29)
end
RefPList(); CM:Add("TP_Join", Players.PlayerAdded:Connect(RefPList)); CM:Add("TP_Leave", Players.PlayerRemoving:Connect(function() task.wait(0.1); RefPList() end))
Button(tc, 144, "TP to Spawn", function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(0,100,0); Notify("TP to Spawn", nil, ">") end end)
Button(tc, 178, "TP to Sky", function() if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(0,1000,0); Notify("TP to Sky", nil, ">") end end)
Button(tc, 212, "TP to Mouse (T)", function()
    CM:Add("ClickTP", UserInputService.InputBegan:Connect(function(i,gpe) if gpe then return end; if i.KeyCode == Enum.KeyCode.T then
        local ray = Workspace.CurrentCamera:ViewportPointToRay(mouse.X, mouse.Y)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(ray.Origin + ray.Direction * 100); Notify("Click TP", nil, ">") end
    end end)); Notify("Click TP enabled (press T)")
end)

-- CATEGORY 7: COMBAT
local cc = catCons[7]
Slider(cc, 6, "Reach", 5, 20, 8, function(v) for _, t in ipairs(player.Character and player.Character:GetChildren() or {}) do if t:IsA("Tool") then t.GripForward = Vector3.new(0,0,-v/10) end end end)
Toggle(cc, 50, "Kill Aura", function(s)
    if s then
        CM:Add("KillAura", RunService.Stepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                for _, o in ipairs(Players:GetPlayers()) do
                    if o ~= player and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
                        if (player.Character.HumanoidRootPart.Position - o.Character.HumanoidRootPart.Position).Magnitude <= 15 then o.Character:BreakJoints() end
                    end
                end
            end
        end))
    else CM:Rem("KillAura") end
    Notify("Kill Aura: "..(s and "ON" or "OFF"))
end)
Toggle(cc, 82, "Auto Parry", function(s)
    if s then
        CM:Add("AutoParry", RunService.Stepped:Connect(function()
            local c = player.Character
            if c then
                for _, t in ipairs(c:GetChildren()) do
                    if t:IsA("Tool") and t:FindFirstChild("Handle") then
                        for _, o in ipairs(Players:GetPlayers()) do
                            if o ~= player and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
                                if (t.Handle.Position - o.Character.HumanoidRootPart.Position).Magnitude < 15 then
                                    pcall(function() t:Activate() end)
                                end
                            end
                        end
                    end
                end
            end
        end))
    else CM:Rem("AutoParry") end
    Notify("Auto Parry: "..(s and "ON" or "OFF"))
end)
Toggle(cc, 114, "Speed Hit", function(s)
    if s then CM:Add("SpeedHit", RunService.Stepped:Connect(function() local c = player.Character; if c and c:FindFirstChild("HumanoidRootPart") then c.HumanoidRootPart.Velocity = c.HumanoidRootPart.CFrame.LookVector * 80 end end)) else CM:Rem("SpeedHit") end end)
-- CATEGORY 8: ANIMATIONS
local an = catCons[8]

local animIdBox = TBox(an, 6, "Animation ID...", "33796059")
local loopOn = false

local function PlayID(id)
    local c = player.Character; if not c then return end
    local h = c:FindFirstChild("Humanoid"); if not h then return end
    if curAnim then curAnim:Stop() end
    local a = Instance.new("Animation")
    a.AnimationId = "rbxassetid://"..id
    local anim = h:FindFirstChildOfClass("Animator")
    if not anim then anim = Instance.new("Animator", h) end
    local ok, tr = pcall(function() return anim:LoadAnimation(a) end)
    if ok and tr then
        curAnim = tr
        tr.Looped = loopOn
        tr:AdjustSpeed(animSpd)
        tr:Play()
        Notify("Playing "..id, nil, ">")
    else
        Notify("ID "..id.." failed", Color3.fromRGB(200,50,50), "X")
    end
end

local function StopAnim()
    if curAnim then curAnim:Stop(); curAnim = nil end
    Notify("Stopped", nil, "X")
end

Button(an, 40, "Play", function() PlayID(animIdBox.Text) end)
Button(an, 74, "Stop", StopAnim)

Slider(an, 110, "Speed", 0.1, 5, 1, function(v) animSpd = v; if curAnim then curAnim:AdjustSpeed(v) end end)

Toggle(an, 150, "Loop", function(s) loopOn = s; if curAnim then curAnim.Looped = s end end)

local ids = {
    {"Breakdance","33796059"},{"Wave","33461633"},{"Floss","59116292"},
    {"Robot","59116266"},{"Macarena","33891334"},{"Disco","33353366"},
    {"Moonwalk","33796064"},{"T-Pose","58701680"},{"Crank","692937610"},
    {"Zombie","61610350"},{"Sit","178127224"},{"Lay","178127259"},
    {"Clap","178127347"},{"Kick","7087831628"},{"Punch","7087832803"},
}

for i, d in ipairs(ids) do
    local y = 190 + (i-1) * 30
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 26)
    b.Position = UDim2.new(0, 8, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(65, 0, 120)
    b.Text = d[1]
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.BorderSizePixel = 0
    b.Parent = an
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    b.MouseButton1Click:Connect(function() Snd:Play("Click"); animIdBox.Text = d[2]; PlayID(d[2]) end)
end

-- CATEGORY 9: FUN
local fc = catCons[9]
Toggle(fc, 6, "Invisible (Local)", function(s) local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.LocalTransparencyModifier = s and 1 or 0 end end end end)
Toggle(fc, 38, "Rainbow Character", function(s)
    if s then CM:Loop("Rainbow", function() local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color = Color3.fromHSV(tick()*0.5%1, 1, 1) end end end end, 0.1) else CM:Stop("Rainbow"); local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color = Color3.new(1,1,1) end end end end end)
Toggle(fc, 70, "Giant Mode", function(s) local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then if s then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Size = p.Size * 3 end end; h.HipHeight = h.HipHeight * 3 else for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Size = p.Size / 3 end end; h.HipHeight = h.HipHeight / 3 end end end end)
Toggle(fc, 102, "Tiny Mode", function(s) local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then if s then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Size = p.Size * 0.3 end end; h.HipHeight = h.HipHeight * 0.3 else for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Size = p.Size / 0.3 end end; h.HipHeight = h.HipHeight / 0.3 end end end end)
Toggle(fc, 134, "Headless", function(s) local c = player.Character; if c then local hd = c:FindFirstChild("Head"); if hd then hd.Transparency = s and 1 or 0 end end end)
Toggle(fc, 166, "Force Sit", function(s) local c = player.Character; if c then local h = c:FindFirstChild("Humanoid"); if h then h.Sit = s end end end)
Button(fc, 198, "Custom Spam Chat", function()
    local pp = CreatePopup("Spam Chat", 300, 120)
    local ti = Instance.new("TextBox", pp); ti.Size=UDim2.new(1,-16,0,28); ti.Position=UDim2.new(0,8,0,8); ti.PlaceholderText="Message..."; ti.Text="ENDER v7.0 on top!"; ti.BackgroundColor3=Color3.fromRGB(40,40,50); ti.TextColor3=Color3.new(1,1,1); ti.Font=Enum.Font.Gotham; ti.TextSize=13; ti.BorderSizePixel=0; Instance.new("UICorner",ti).CornerRadius=UDim.new(0,6)
    local running = false
    local spBtn = Instance.new("TextButton", pp); spBtn.Size=UDim2.new(1,-16,0,28); spBtn.Position=UDim2.new(0,8,0,44); spBtn.Text="Start Spam"; spBtn.BackgroundColor3=Color3.fromRGB(60,60,80); spBtn.TextColor3=Color3.new(1,1,1); spBtn.Font=Enum.Font.GothamSemibold; spBtn.TextSize=12; spBtn.BorderSizePixel=0; Instance.new("UICorner",spBtn).CornerRadius=UDim.new(0,6)
    spBtn.MouseButton1Click:Connect(function() running = not running; spBtn.Text = running and "Stop Spam" or "Start Spam"; if running then CM:Loop("SpamChat", function() SendChatMsg(ti.Text) end, 2) else CM:Stop("SpamChat") end end)
end)
Button(fc, 234, "All Rainbow", function()
    if CM._l["AllRainbow"] then CM:Stop("AllRainbow"); Notify("All Rainbow OFF", Color3.fromRGB(200,50,50), "X") return end
    CM:Loop("AllRainbow", function()
        local h = tick()*0.3%1
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character then
                for _, p in ipairs(pl.Character:GetDescendants()) do
                    if p:IsA("BasePart") then p.Color = Color3.fromHSV(h, 1, 1) end
                end
            end
        end
    end, 0.1)
    Notify("All Rainbow ON", Color3.fromRGB(0,200,80), ">")
end)
Button(fc, 268, "All Explode", function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            local e = Instance.new("Explosion")
            e.Position = pl.Character.HumanoidRootPart.Position
            e.BlastRadius = 15
            e.BlastPressure = 0
            e.Parent = Workspace
        end
    end
    Notify("All exploded!", nil, ">")
end)
Button(fc, 302, "All To Sky", function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
            pl.Character.HumanoidRootPart.CFrame = CFrame.new(0, 500, 0)
        end
    end
    Notify("All sent to sky!", nil, ">")
end)
Button(fc, 336, "All Freeze/Unfreeze", function()
    local frozen = false
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            for _, p in ipairs(pl.Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    if p.Anchored then frozen = true end
                    p.Anchored = not p.Anchored
                end
            end
        end
    end
    Notify(frozen and "All Unfrozen" or "All Frozen", nil, frozen and "X" or ">")
end)
Button(fc, 370, "All Spin", function()
    if CM._l["AllSpin"] then CM:Stop("AllSpin"); Notify("All Spin OFF", Color3.fromRGB(200,50,50), "X") return end
    CM:Loop("AllSpin", function()
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                pl.Character.HumanoidRootPart.CFrame = pl.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(15), 0)
            end
        end
    end, 0)
    Notify("All Spin ON", Color3.fromRGB(0,200,80), ">")
end)
Button(fc, 404, "All Sit", function()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            local h = pl.Character:FindFirstChild("Humanoid")
            if h then h.Sit = true end
        end
    end
    Notify("All sitting!", nil, ">")
end)
Toggle(fc, 438, "AI Auto Player", function(s)
    if s then
        CM._l["AutoPlayer"] = true
        local dances = {"33796059","33461633","59116292","59116266","33891334","33353366","33796064","692937610","61610350","178127224","178127259","178127347"}
        local lastMsg, lastMsgFrom, curTr, rpPart = "", nil, nil, nil
        local moveDir, smoothVel = Vector3.new(), Vector3.new()
        local aiOk = false

        local function ollama(prompt)
            local ok, res = pcall(function()
                local data = game:GetService("HttpService"):JSONEncode({model="llama3.2", prompt=prompt, stream=false, options={num_predict=80}})
                if syn and syn.request then
                    local r = syn.request({Url="http://localhost:11434/api/generate", Method="POST", Headers={["Content-Type"]="application/json"}, Body=data})
                    if r and r.StatusCode == 200 then return game:GetService("HttpService"):JSONDecode(r.Body).response end
                else
                    local r = game:GetService("HttpService"):PostAsync("http://localhost:11434/api/generate", data, Enum.HttpContentType.ApplicationJson)
                    if r then return game:GetService("HttpService"):JSONDecode(r).response end
                end
            end)
            return ok and res or nil
        end

        local function askAI()
            local c = player.Character; if not c then return "wander" end
            local rp = c:FindFirstChild("HumanoidRootPart"); if not rp then return "wander" end
            local nearby = {}
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (rp.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                    if d < 150 then table.insert(nearby, pl.Name.."("..math.floor(d).."m)") end
                end
            end
            local state = "Ты дружелюбный игрок в Roblox. Общайся, подходи к людям, веди себя хорошо. Текущее состояние:\n"
            if #nearby > 0 then state = state.."- Игроки рядом: "..table.concat(nearby, ", ").."\n- Если кто-то близко (<30м), подойди и поздоровайся\n" else state = state.."- Никого нет, гуляй\n" end
            if lastMsgFrom and lastMsg ~= "" then state = state.."- "..lastMsgFrom.Name.." сказал: \""..lastMsg.."\"\n- Ответь ему!\n" end
            state = state.."\nОтветь ОДНИМ действием на русском:\n"
            state = state.."- approach PLAYERNAME\n- walk DIRECTION (N/S/E/W/NE/NW/SE/SW)\n- stop\n- jump\n- dance\n- chat \"текст\"\n- look PLAYERNAME\n- wander\n\nДействие:"
            local res = ollama(state)
            lastMsg = ""; lastMsgFrom = nil
            return (res and #res>0) and res or "wander"
        end

        pcall(function()
            local test = ollama("Ответь одним словом: ананас")
            if test then aiOk = true end
        end)
        Notify("Ollama: "..(aiOk and "AI ON" or "AI OFF (fallback)"), aiOk and Color3.fromRGB(0,200,80) or Color3.fromRGB(200,100,0))

        pcall(function() local tcs=game:GetService("TextChatService"); local tc=tcs:FindFirstChild("TextChannels"); if tc then local ch=tc:FindFirstChild("RBXGeneral") or tc:FindFirstChild("General") or tc:FindFirstChild("Lobby"); if ch then ch.MessageReceived:Connect(function(d) if d and d.Text then local src=d.TextSource; if src and src~=player then lastMsg=d.Text; lastMsgFrom=src end end end) end end end)
        pcall(function() for _,pl in ipairs(Players:GetPlayers()) do if pl~=player then pl.Chatted:Connect(function(m) lastMsg=m; lastMsgFrom=pl end) end end end)
        Players.PlayerAdded:Connect(function(pl) task.wait(2); pl.Chatted:Connect(function(m) lastMsg=m; lastMsgFrom=pl end) end)

        local function lookAt(p) pcall(function() local c=Workspace.CurrentCamera; if not c then return end; local s,o=c:WorldToScreenPoint(p); if o then mousemoveabs(s.X,s.Y) end end) end
        local function playAnim(id) local c=player.Character; if not c then return end; local h=c:FindFirstChild("Humanoid"); if not h then return end; local a=Instance.new("Animation"); a.AnimationId="rbxassetid://"..id; local an=h:FindFirstChildOfClass("Animator") or Instance.new("Animator",h); local o,t=pcall(function() return an:LoadAnimation(a) end); if o and t then t.Priority=Enum.AnimationPriority.Action; t:Play() return t end end
        local function getTarget(name)
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    if pl.Name:lower():find(name:lower()) then return pl end
                end
            end
            return nil
        end
        local function isBlocked(pos, dir, dist)
            local ok, hit = pcall(function()
                local params = RaycastParams.new()
                params.FilterType = Enum.RaycastFilterType.Blacklist
                params.FilterDescendantsInstances = {player.Character, Workspace.CurrentCamera}
                return Workspace:Raycast(pos + Vector3.new(0,2,0), dir.Unit * dist, params)
            end)
            if not ok then
                local p = Workspace:FindPartOnRay(Ray.new(pos + Vector3.new(0,2,0), dir.Unit * dist), player.Character)
                return p ~= nil
            end
            return hit ~= nil
        end
        local function randomDir() return Vector3.new(math.random(-100,100),0,math.random(-100,100)).Unit end
        local function avoidWalls(fwd, pos)
            if isBlocked(pos, fwd, 14) then
                local tries = 0
                while tries < 8 do
                    local nd = randomDir()
                    if not isBlocked(pos, nd, 12) then return nd end
                    tries = tries + 1
                end
                return nil
            end
            return fwd
        end

        local tick, walkTimer, stuckPos, stuckTime = 0, 0, nil, 0

        CM:Add("AutoPlayerMove", RunService.RenderStepped:Connect(function(dt)
            local c=player.Character; if not c then return end
            rpPart=c:FindFirstChild("HumanoidRootPart"); local h=c:FindFirstChild("Humanoid")
            if not rpPart then return end
            tick=tick+dt

            if moveDir.Magnitude>1 then
                local fwd = moveDir.Unit
                local dir = avoidWalls(fwd, rpPart.Position)
                if dir then
                    local wobble = math.sin(tick*3.7)*0.015 + math.cos(tick*1.3)*0.01
                    local right = rpPart.CFrame.RightVector
                    moveDir = (dir + right*wobble) * moveDir.Magnitude
                    rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + dir)
                else
                    moveDir = Vector3.new()
                end
            end

            smoothVel = smoothVel:Lerp(moveDir, 0.06)
            if smoothVel.Magnitude>0.5 then
                rpPart.Velocity = smoothVel
                if h then h.WalkSpeed=math.clamp(smoothVel.Magnitude,0,100); h.AutoRotate=false end
            else rpPart.Velocity=Vector3.new() end

            if math.random()<0.002 then
                local p = Vector3.new(math.random(-30,30),0,math.random(-30,30))
                lookAt(rpPart.Position + p)
            end
        end))

        task.spawn(function()
            while CM._l["AutoPlayer"] do task.wait(4)
                if rpPart and stuckPos then
                    if (rpPart.Position - stuckPos).Magnitude < 1.5 then
                        stuckTime = stuckTime + 4
                        if stuckTime > 8 then
                            moveDir = randomDir() * 50
                            local h = player.Character and player.Character:FindFirstChild("Humanoid")
                            if h then h.Jump=true end
                            stuckTime = 0
                        end
                    else stuckTime = 0 end
                end
                stuckPos = rpPart and rpPart.Position or nil
            end
        end)

        task.spawn(function()
            local greeted = {}
            local lastChatTime = 0
            Players.PlayerRemoving:Connect(function(pl) greeted[pl] = nil end)
            while CM._l["AutoPlayer"] do task.wait(4)
                local c = player.Character; if not c then return end
                local rp = c:FindFirstChild("HumanoidRootPart"); if not rp then return end
                local now = tick()
                local canChat = now - lastChatTime > 15
                local closest, closestD = nil, 999
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                        local d = (rp.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                        if d < 80 then
                            lookAt(pl.Character.HumanoidRootPart.Position)
                            if not greeted[pl] and canChat then
                                greeted[pl] = true
                                if math.random()<0.5 then
                                    local msgs = {"привет "..pl.Name, "здарова "..pl.Name, "ку "..pl.Name, "хелло "..pl.Name, "здравствуй "..pl.Name}
                                    SendChatMsg(msgs[math.random(#msgs)])
                                    lastChatTime = now
                                end
                            end
                        end
                        if d < closestD then closest = pl; closestD = d end
                    end
                end
                if closest and closestD < 60 then
                    local dir = (closest.Character.HumanoidRootPart.Position - rp.Position).Unit
                    moveDir = dir * (14 + math.random()*6)
                    rpPart.CFrame = CFrame.lookAt(rp.Position, rp.Position + dir)
                end
                if lastMsgFrom and lastMsg ~= "" and canChat then
                    local who = lastMsgFrom.Name
                    local what = lastMsg
                    lastMsg = ""
                    lastMsgFrom = nil
                    if aiOk then
                        local prompt = "Ты игрок "..player.Name.." в Roblox. "..who.." сказал: \""..what.."\". Ответь по-русски коротко (1 предложение), как живой игрок. Ответ:"
                        local reply = ollama(prompt)
                        if reply and #reply > 2 then
                            local clean = reply:gsub('^["%s]+', ''):gsub('["%s]+$', '')
                            if #clean > 1 then
                                SendChatMsg(clean)
                                lastChatTime = now
                            end
                        end
                    else
                        local replies = {"привет", "да", "кек", "ок", "бывает", "ну", "ладно", "согласен"}
                        SendChatMsg(replies[math.random(#replies)])
                        lastChatTime = now
                    end
                end
            end
        end)

        task.spawn(function()
            local voiceConnOk = false
            while CM._l["AutoPlayer"] do task.wait(1)
                local ok, cmd = pcall(function()
                    if syn and syn.request then
                        local r = syn.request({Url="http://127.0.0.1:11435/command", Method="GET", Timeout=2})
                        if r then
                            if not voiceConnOk then voiceConnOk = true; Notify("Voice server connected", Color3.fromRGB(0,200,80)) end
                            if r.StatusCode == 200 and r.Body then return r.Body end
                        end
                    end
                end)
                if voiceConnOk and not ok then voiceConnOk = false; Notify("Voice server lost", Color3.fromRGB(200,50,50)) end
                if ok and cmd and #cmd > 1 then
                    local c = player.Character
                    local rp = c and c:FindFirstChild("HumanoidRootPart")
                    if not c or not rp then task.wait(0.5) else
                    local al = cmd:lower()
                    Notify("Voice: "..cmd, Color3.fromRGB(100,200,255))
                    if al:find("approach") or al:find("follow") then
                        local name = cmd:match("%S+%s+(.+)")
                        if name then
                            for _, pl in ipairs(Players:GetPlayers()) do
                                if pl ~= player and pl.Name:lower():find(name:lower()) then
                                    moveDir = Vector3.new()
                                    local dir = (pl.Character.HumanoidRootPart.Position - rp.Position).Unit
                                    moveDir = dir * 20
                                    rp.CFrame = CFrame.lookAt(rp.Position, rp.Position + dir)
                                    break
                                end
                            end
                        end
                    elseif al:find("walk") then
                        local d = cmd:match("walk%s+(%S+)")
                        local dMap = {n=Vector3.new(0,0,-1), s=Vector3.new(0,0,1), e=Vector3.new(1,0,0), w=Vector3.new(-1,0,0), ne=Vector3.new(1,0,-1), nw=Vector3.new(-1,0,-1), se=Vector3.new(1,0,1), sw=Vector3.new(-1,0,1)}
                        local dir = d and dMap[d:lower()] or Vector3.new(math.random(-100,100),0,math.random(-100,100)).Unit
                        moveDir = dir * 18
                        rp.CFrame = CFrame.lookAt(rp.Position, rp.Position + dir)
                    elseif al:find("stop") then
                        moveDir = Vector3.new()
                    elseif al:find("jump") then
                        local h = c:FindFirstChild("Humanoid")
                        if h then h.Jump = true end
                        task.wait(0.3)
                    elseif al:find("dance") then
                        moveDir = Vector3.new()
                        if curTr and curTr.IsPlaying then curTr:Stop() end
                        curTr = playAnim(dances[math.random(#dances)])
                    elseif al:find("chat") then
                        local msg = cmd:match('chat%s+"([^"]+)"') or cmd:match("chat%s+(.+)")
                        if msg then SendChatMsg(msg) end
                    elseif al:find("look") then
                        local name = cmd:match("look%s+(%S+)")
                        if name then
                            for _, pl in ipairs(Players:GetPlayers()) do
                                if pl ~= player and pl.Name:lower():find(name:lower()) and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                                    rp.CFrame = CFrame.lookAt(rp.Position, pl.Character.HumanoidRootPart.Position)
                                    break
                                end
                            end
                        end
                    elseif al:find("wander") then
                    end
                    end
                end
            end
        end)

        local function doIdle(c)
            local act = math.random()
            if act<0.2 then
                pcall(function() local h=c:FindFirstChild("Humanoid"); if h then h.Jump=true end end)
                task.wait(0.3+math.random()*0.5)
            elseif act<0.4 then
                if curTr and curTr.IsPlaying then curTr:Stop() end
                curTr = playAnim(dances[math.random(#dances)])
                if curTr then curTr:AdjustSpeed(0.8+math.random()*0.4) end
                task.wait(1+math.random()*2)
            elseif act<0.75 then
                lookAt(rpPart.Position + Vector3.new(math.random(-40,40),0,math.random(-40,40)))
                task.wait(0.5+math.random())
            else
                local dir = randomDir()
                rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + dir)
                task.wait(0.3+math.random()*0.5)
            end
        end

        task.spawn(function()
            while CM._l["AutoPlayer"] do
                local c=player.Character; if not c then moveDir=Vector3.new(); task.wait(0.5) else
                rpPart=c:FindFirstChild("HumanoidRootPart"); if not rpPart then moveDir=Vector3.new(); task.wait(0.5) else
                local action = aiOk and askAI() or "wander"
                local al = action:lower()

                if al:find("approach") then
                    local name = action:match("approach%s+(%S+)")
                    local t = name and getTarget(name)
                    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                        local tp = t.Character.HumanoidRootPart.Position
                        local dir = (tp - rpPart.Position).Unit
                        moveDir = dir * (16 + math.random()*8)
                        rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + dir)
                        task.wait(0.8+math.random()*0.8)
                        if (rpPart.Position - tp).Magnitude < 12 then
                            moveDir = Vector3.new()
                            if math.random()<0.4 then doIdle(c) end
                            task.wait(0.5+math.random()*1.5)
                        end
                    else moveDir = Vector3.new(); task.wait(1.5+math.random()) end
                elseif al:find("walk") then
                    local d = action:match("walk%s+(%S+)")
                    local dMap = {n=Vector3.new(0,0,-1), s=Vector3.new(0,0,1), e=Vector3.new(1,0,0), w=Vector3.new(-1,0,0), ne=Vector3.new(1,0,-1), nw=Vector3.new(-1,0,-1), se=Vector3.new(1,0,1), sw=Vector3.new(-1,0,1)}
                    local dir = d and dMap[d:lower()] or randomDir()
                    moveDir = dir * (14 + math.random()*10)
                    rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + dir)
                    if math.random()<0.06 then pcall(function() local h=c:FindFirstChild("Humanoid"); if h then h.Jump=true end end) end
                    walkTimer = 0
                    while walkTimer < 10 + math.random()*8 and CM._l["AutoPlayer"] do
                        if walkTimer > 3 and math.random()<0.005 then
                            moveDir = Vector3.new()
                            doIdle(c)
                            local d2 = randomDir()
                            moveDir = d2 * (14 + math.random()*10)
                            rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + d2)
                            walkTimer = walkTimer + 1
                        end
                        task.wait(1); walkTimer = walkTimer + 1
                    end
                elseif al:find("jump") then
                    pcall(function() local h=c:FindFirstChild("Humanoid"); if h then h.Jump=true end end)
                    if math.random()<0.3 then moveDir = randomDir() * 18 end
                    task.wait(0.3+math.random()*0.5)
                elseif al:find("dance") then
                    moveDir = Vector3.new()
                    if curTr and curTr.IsPlaying then curTr:Stop() end
                    curTr = playAnim(dances[math.random(#dances)])
                    if curTr then curTr:AdjustSpeed(0.6+math.random()*0.4) end
                    task.wait(2+math.random()*3)
                elseif al:find("chat") then
                    local msg = action:match('chat%s+"([^"]+)"')
                    if msg then SendChatMsg(msg) end
                    moveDir = Vector3.new()
                    if math.random()<0.4 then doIdle(c) end
                    task.wait(0.8+math.random()*1.5)
                elseif al:find("look") then
                    local name = action:match("look%s+(%S+)")
                    local t = name and getTarget(name)
                    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
                        rpPart.CFrame = CFrame.lookAt(rpPart.Position, t.Character.HumanoidRootPart.Position)
                        lookAt(t.Character.HumanoidRootPart.Position)
                    end
                    moveDir = Vector3.new()
                    task.wait(0.5+math.random()*1)
                elseif al:find("stop") then
                    moveDir = Vector3.new()
                    if math.random()<0.4 then doIdle(c) end
                    task.wait(1+math.random()*3)
                else
                    moveDir = Vector3.new()
                    doIdle(c)
                    local dir = randomDir()
                    moveDir = dir * (14 + math.random()*10)
                    rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + dir)
                    walkTimer = 0
                    while walkTimer < 8 + math.random()*6 and CM._l["AutoPlayer"] do
                        if math.random()<0.005 then
                            moveDir = Vector3.new()
                            doIdle(c)
                            local d2 = randomDir()
                            moveDir = d2 * (14 + math.random()*10)
                            rpPart.CFrame = CFrame.lookAt(rpPart.Position, rpPart.Position + d2)
                            walkTimer = walkTimer + 1
                        end
                        task.wait(1); walkTimer = walkTimer + 1
                    end
                end
                end end
            end
            moveDir=Vector3.new(); CM:Rem("AutoPlayerMove")
            if curTr then curTr:Stop() end
        end)
    else
        CM._l["AutoPlayer"]=nil; CM:Rem("AutoPlayerMove"); moveDir=Vector3.new()
    end
    Notify("AI Player: "..(s and "ON" or "OFF"))
end)

Toggle(fc, 466, "Follow Player", function(s)
    if s then
        CM._l["FollowPlayer"] = true
        local conn = RunService.RenderStepped:Connect(function()
            local c = player.Character; if not c then return end
            local rp = c:FindFirstChild("HumanoidRootPart"); if not rp then return end
            local h = c:FindFirstChild("Humanoid"); if not h then return end
            local closest, closestD = nil, 999
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= player and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (rp.Position - pl.Character.HumanoidRootPart.Position).Magnitude
                    if d < closestD then closest = pl; closestD = d end
                end
            end
            if closest then
                local tp = closest.Character.HumanoidRootPart.Position
                local dir = (tp - rp.Position).Unit
                rp.Velocity = dir * h.WalkSpeed
                rp.CFrame = CFrame.lookAt(rp.Position, Vector3.new(tp.X, rp.Position.Y, tp.Z))
            end
        end)
        CM:Add("FollowMove", conn)
    else
        CM._l["FollowPlayer"] = nil
        CM:Rem("FollowMove")
    end
    Notify("Follow Player: "..(s and "ON" or "OFF"))
end)

Toggle(fc, 495, "Voice Control", function(s)
    if s then
        CM._l["VoiceControl"] = true
        local vcRp, vcHum, vcMove, vcSmooth = nil, nil, Vector3.new(), Vector3.new()
        local vcConnOk, vcLastCmd = false, ""
        local dancesVC = {"33796059","33461633","59116292","59116266","33891334","33353366","33796064","692937610","61610350","178127224","178127259","178127347"}
        CM:Add("VoiceMove", RunService.RenderStepped:Connect(function()
            local c = player.Character; if not c then return end
            vcRp = c:FindFirstChild("HumanoidRootPart"); vcHum = c:FindFirstChild("Humanoid")
            if not vcRp then return end
            vcSmooth = vcSmooth:Lerp(vcMove, 0.08)
            if vcSmooth.Magnitude > 0.5 then
                vcRp.Velocity = vcSmooth
                if vcHum then vcHum.WalkSpeed = math.clamp(vcSmooth.Magnitude, 0, 100); vcHum.AutoRotate = false end
            else vcRp.Velocity = Vector3.new() end
        end))
        task.spawn(function()
            local http = game:GetService("HttpService")
            pcall(function() http.HttpEnabled = true end)
            while CM._l["VoiceControl"] do task.wait(0.5)
                local cmd = ""
                pcall(function()
                    local r = http:GetAsync("http://127.0.0.1:11435/command", true)
                    if r and #r > 1 then cmd = r end
                end)
                if #cmd < 1 then
                    local ok, r = pcall(function()
                        if syn and syn.request then
                            return syn.request({Url="http://127.0.0.1:11435/command", Method="GET", Timeout=2})
                        end
                    end)
                    if ok and r and r.StatusCode == 200 and r.Body and #r.Body > 1 then cmd = r.Body end
                end
                if cmd and #cmd > 1 then
                    if not vcConnOk then vcConnOk = true; Notify("Voice OK", Color3.fromRGB(0,200,80)) end
                    local c = player.Character; local rp = c and c:FindFirstChild("HumanoidRootPart")
                    if not c or not rp then task.wait(0.5) else
                    local al = cmd:lower()
                    Notify("Voice: "..cmd, Color3.fromRGB(100,200,255))
                    if al:find("approach") or al:find("follow") then
                        local name = cmd:match("%S+%s+(.+)")
                        if name then
                            for _, pl in ipairs(Players:GetPlayers()) do
                                if pl ~= player and pl.Name:lower():find(name:lower()) then
                                    local dir = (pl.Character.HumanoidRootPart.Position - rp.Position).Unit
                                    vcMove = dir * 20
                                    rp.CFrame = CFrame.lookAt(rp.Position, rp.Position + dir)
                                    break
                                end
                            end
                        end
                    elseif al:find("walk") then
                        local d = cmd:match("walk%s+(%S+)")
                        local dMap = {n=Vector3.new(0,0,-1), s=Vector3.new(0,0,1), e=Vector3.new(1,0,0), w=Vector3.new(-1,0,0), ne=Vector3.new(1,0,-1), nw=Vector3.new(-1,0,-1), se=Vector3.new(1,0,1), sw=Vector3.new(-1,0,1)}
                        local dir = d and dMap[d:lower()] or Vector3.new(math.random(-100,100),0,math.random(-100,100)).Unit
                        vcMove = dir * 18
                        rp.CFrame = CFrame.lookAt(rp.Position, rp.Position + dir)
                    elseif al:find("stop") then
                        vcMove = Vector3.new()
                    elseif al:find("jump") then
                        if vcHum then vcHum.Jump = true end
                        task.wait(0.3)
                    elseif al:find("dance") then
                        vcMove = Vector3.new()
                        local h = c:FindFirstChild("Humanoid"); if h then
                            local a = Instance.new("Animation"); a.AnimationId="rbxassetid://"..dancesVC[math.random(#dancesVC)]
                            local an = h:FindFirstChildOfClass("Animator") or Instance.new("Animator",h)
                            local o,t = pcall(function() return an:LoadAnimation(a) end)
                            if o and t then t.Priority=Enum.AnimationPriority.Action; t:Play() end
                        end
                    elseif al:find("chat") then
                        local msg = cmd:match('chat%s+"([^"]+)"') or cmd:match("chat%s+(.+)")
                        if msg then SendChatMsg(msg) end
                    elseif al:find("look") then
                        local name = cmd:match("look%s+(%S+)")
                        if name then
                            for _, pl in ipairs(Players:GetPlayers()) do
                                if pl ~= player and pl.Name:lower():find(name:lower()) and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
                                    rp.CFrame = CFrame.lookAt(rp.Position, pl.Character.HumanoidRootPart.Position)
                                    break
                                end
                            end
                        end
                    end
                    end
                end
            end
            vcMove = Vector3.new(); CM:Rem("VoiceMove")
        end)
    else
        CM._l["VoiceControl"] = nil; CM:Rem("VoiceMove"); vcMove = Vector3.new()
    end
    Notify("Voice Control: "..(s and "ON" or "OFF"))
end)

-- CATEGORY 10: PLAYER
local pc = catCons[10]
Button(pc, 6, "Spectate Player", function()
    local pp = CreatePopup("Spectate", 280, 250)
    local sc = Instance.new("ScrollingFrame", pp); sc.Size=UDim2.new(1,-16,1,-10); sc.Position=UDim2.new(0,8,0,4); sc.BackgroundTransparency=1; sc.ScrollBarThickness=4; sc.CanvasSize=UDim2.new(0,0,0,0); Instance.new("UIListLayout",sc).Padding=UDim.new(0,3)
    local function RefSpec() for _, c in ipairs(sc:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end; local n=0; for _, o in ipairs(Players:GetPlayers()) do if o~=player then n=n+1; local b=Instance.new("TextButton",sc); b.Size=UDim2.new(1,0,0,26); b.Text=o.Name; b.BackgroundColor3=Color3.fromRGB(50,50,60); b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamSemibold; b.TextSize=12; b.BorderSizePixel=0; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6); b.MouseButton1Click:Connect(function() Snd:Play("Click"); if o.Character and o.Character:FindFirstChild("Humanoid") then Workspace.CurrentCamera.CameraSubject = o.Character.Humanoid; Notify("Spectating: "..o.Name) end end) end end; sc.CanvasSize = UDim2.new(0,0,0,n*29) end
    RefSpec()
    Button(pp, 0, "Stop Spectate", function() if player.Character and player.Character:FindFirstChild("Humanoid") then Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid; Notify("Stopped spectating") end end)
end)
Button(pc, 40, "Teleport to Player", function()
    local pp = CreatePopup("Teleport To", 280, 250)
    local sc = Instance.new("ScrollingFrame", pp); sc.Size=UDim2.new(1,-16,1,-10); sc.Position=UDim2.new(0,8,0,4); sc.BackgroundTransparency=1; sc.ScrollBarThickness=4; sc.CanvasSize=UDim2.new(0,0,0,0); Instance.new("UIListLayout",sc).Padding=UDim.new(0,3)
    for _, o in ipairs(Players:GetPlayers()) do if o~=player then local b=Instance.new("TextButton",sc); b.Size=UDim2.new(1,0,0,26); b.Text=o.Name; b.BackgroundColor3=Color3.fromRGB(50,50,60); b.TextColor3=Color3.new(1,1,1); b.Font=Enum.Font.GothamSemibold; b.TextSize=12; b.BorderSizePixel=0; Instance.new("UICorner",b).CornerRadius=UDim.new(0,6); b.MouseButton1Click:Connect(function() Snd:Play("Click"); if o.Character and o.Character:FindFirstChild("HumanoidRootPart") and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(o.Character.HumanoidRootPart.Position + Vector3.new(0,3,0)); Notify("TP to "..o.Name, nil, ">") end end) end end; sc.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*29)
end)
Button(pc, 74, "Player List", function()
    local pp = CreatePopup("All Players", 300, 300)
    local sc = Instance.new("ScrollingFrame", pp); sc.Size=UDim2.new(1,-16,1,-10); sc.Position=UDim2.new(0,8,0,4); sc.BackgroundTransparency=1; sc.ScrollBarThickness=4; sc.CanvasSize=UDim2.new(0,0,0,0); Instance.new("UIListLayout",sc).Padding=UDim.new(0,3)
    for _, o in ipairs(Players:GetPlayers()) do
        local f=Instance.new("Frame",sc); f.Size=UDim2.new(1,0,0,50); f.BackgroundColor3=Color3.fromRGB(35,35,40); f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
        local l=Instance.new("TextLabel",f); l.Size=UDim2.new(1,-10,0,22); l.Position=UDim2.new(0,10,0,4); l.BackgroundTransparency=1; l.Text=o.Name; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.GothamBold; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left
        local l2=Instance.new("TextLabel",f); l2.Size=UDim2.new(1,-10,0,18); l2.Position=UDim2.new(0,10,0,26); l2.BackgroundTransparency=1; l2.Text="ID: "..o.UserId; l2.TextColor3=Color3.fromRGB(150,150,150); l2.Font=Enum.Font.Gotham; l2.TextSize=11; l2.TextXAlignment=Enum.TextXAlignment.Left
    end; sc.CanvasSize = UDim2.new(0,0,0,#Players:GetPlayers()*56)
end)

-- CATEGORY 11: WORLD
local wc = catCons[11]
Slider(wc, 6, "Gravity", 0, 500, 196, function(v) Workspace.Gravity = v end)
Toggle(wc, 48, "No Atmosphere", function(s) for _, o in ipairs(Lighting:GetDescendants()) do if o:IsA("Atmosphere") or o:IsA("Sky") or o:IsA("Clouds") then o.Enabled = not s end end end)
Button(wc, 80, "Destroy All Parts", function() for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) then pcall(function() o:Destroy() end) end end; Notify("Parts destroyed", nil, ">") end)
Button(wc, 112, "Remove All Sounds", function() for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("Sound") then o:Stop(); o.Volume = 0 end end; Notify("All sounds muted", nil, "X") end)
Toggle(wc, 144, "Explosion FX", function(s) if s then CM:Loop("ExpFX", function() local c = player.Character; if c and c:FindFirstChild("HumanoidRootPart") then local e = Instance.new("Explosion"); e.Position = c.HumanoidRootPart.Position + Vector3.new(math.random(-20,20), 0, math.random(-20,20)); e.BlastPressure = 0; e.BlastRadius = 10; e.Parent = Workspace; Debris:AddItem(e, 2) end end, 1) else CM:Stop("ExpFX") end end)
Toggle(wc, 176, "Clear Fog", function(s) Lighting.FogEnd = s and 999999 or dFE end)
Button(wc, 208, "Server Info", function()
    local pp = CreatePopup("Server Info", 280, 160)
    local info = string.format("Players: %d/%d\nServer ID: %s\nPlace ID: %d\nFPS: %.0f", #Players:GetPlayers(), Players.MaxPlayers, game.JobId:sub(1,8), game.PlaceId, workspace:GetRealPhysicsFPS())
    local l = Instance.new("TextLabel", pp); l.Size=UDim2.new(1,-16,1,-8); l.Position=UDim2.new(0,8,0,4); l.BackgroundTransparency=1; l.Text=info; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.Gotham; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextYAlignment=Enum.TextYAlignment.Top
end)
-- CATEGORY 12: SETTINGS
local st = catCons[12]
Button(st, 6, "Destroy UI", function() CM:All(); gui:Destroy() end)
Button(st, 40, "Reset All", function()
    CM:All(); flyOn=false; ncOn=false; gravOn=false; flingOn=false; flingKeyOn=false; flingListOn=false; infJmp=false; aimOn=false; espHL=false; espBX=false; espNM=false; espDS=false; espTracers=false; espChams=false
    Workspace.Gravity = normGrav
    Lighting.Brightness=1; Lighting.ClockTime=12; Lighting.FogEnd=dFE; Lighting.GlobalShadows=true
    if flyGyro then flyGyro:Destroy(); flyGyro=nil end; if flyVel then flyVel:Destroy(); flyVel=nil end
    if fovCirc then fovCirc:Destroy(); fovCirc=nil end; if curAnim then curAnim:Stop(); curAnim=nil end
    if player.Character and player.Character:FindFirstChild("Humanoid") then local h = player.Character.Humanoid; h.WalkSpeed=16; h.JumpPower=50; h.MaxHealth=100; h.Health=100; for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do pcall(function() h:SetStateEnabled(s,true) end) end end
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=70 end
    for _, c in ipairs(gui:GetChildren()) do if c.Name ~= "Notifs" and c ~= main and c ~= overlay then c:Destroy() end end
    Notify("All reset!", Color3.fromRGB(200,50,50), "X")
end)
Button(st, 74, "Save Config", SaveCfg)
Button(st, 108, "Load Config", LoadCfg)
Button(st, 142, "Toggle Sound", function() for _, s in pairs(Snd._) do s.Volume = s.Volume > 0 and 0 or 0.35 end; Notify("Sound toggled") end)
Button(st, 176, "Keybind Help", function()
    local pp = CreatePopup("Keybinds", 250, 140)
    local l = Instance.new("TextLabel", pp); l.Size=UDim2.new(1,-16,1,-8); l.Position=UDim2.new(0,8,0,4); l.BackgroundTransparency=1; l.Text="K - Open/Close Menu\nE - Fling (if enabled)\nT - Click TP (if enabled)\nSpace - Cancel Zero Grav"; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.Gotham; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextYAlignment=Enum.TextYAlignment.Top
end)

-- CATEGORY 13: CHAT
local chc = catCons[13]
local chatMsg = TBox(chc, 6, "Message...", "ENDER v7.0 on top!")
local chatSpd = 3
local chatOn = false
Toggle(chc, 40, "Auto Spam", function(s) chatOn = s; if s then CM:Loop("ChatSpam", function() SendChatMsg(chatMsg.Text) end, chatSpd) else CM:Stop("ChatSpam") end end)
Slider(chc, 76, "Spam Speed (s)", 0.5, 10, 3, function(v) chatSpd = v end)
Button(chc, 114, "Send Message", function() SendChatMsg(chatMsg.Text) end)
Button(chc, 148, "Clear Chat", function() pcall(function() StarterGui:SetCore("ChatMakeSystemMessage", {Text = string.rep(" ", 50), Color = Color3.new(1,1,1)}) end); Notify("Chat cleared (local)", nil, ">") end)

-- CATEGORY 14: ITEMS
local ic = catCons[14]
Toggle(ic, 6, "Item ESP", function(s)
    if s then CM:Loop("ItemESP2", function()
        local kw = {"Coin","Gem","Chest","Loot","Present","Key","Artifact","Crystal","Orb","Star","Token","Sword","Gun","Ammo","Health","Shield"}
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and not o:FindFirstChild("ESP_Item") then
                local nm = o.Name:lower()
                for _, k in ipairs(kw) do if nm:find(k:lower()) then
                    local bb=Instance.new("BillboardGui"); bb.Name="ESP_Item"; bb.Size=UDim2.new(0,60,0,16); bb.StudsOffset=Vector3.new(0,2,0); bb.AlwaysOnTop=true; bb.Adornee=o; bb.Parent=o
                    local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=o.Name; l.TextColor3=Color3.fromRGB(255,255,0); l.Font=Enum.Font.Gotham; l.TextSize=10; break
                end end
            end
        end
    end, 2) else CM:Stop("ItemESP2"); for _, o in ipairs(Workspace:GetDescendants()) do local l=o:FindFirstChild("ESP_Item"); if l then l:Destroy() end end end
end)
Toggle(ic, 38, "Glow Items", function(s)
    if s then CM:Loop("GlowItems", function()
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and not o:FindFirstChild("GlowFX") then
                local kw = {"Coin","Gem","Chest","Loot","Present","Key","Artifact","Crystal","Orb","Star","Token","Sword","Gun"}
                local nm = o.Name:lower()
                for _, k in ipairs(kw) do if nm:find(k:lower()) then
                    local fx = Instance.new("SelectionBox"); fx.Name="GlowFX"; fx.Adornee=o; fx.Color3=Color3.fromRGB(255,200,0); fx.LineThickness=0.1; fx.Parent=o; break
                end end
            end
        end
    end, 3) else CM:Stop("GlowItems"); for _, o in ipairs(Workspace:GetDescendants()) do local l=o:FindFirstChild("GlowFX"); if l then l:Destroy() end end end
end)
Button(ic, 70, "Collect Items (Auto)", function()
    CM:Loop("CollectItems", function()
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and o:FindFirstChild("TouchInterest") then
                local kw = {"Coin","Gem","Chest","Loot","Present","Key","Artifact","Crystal","Orb","Star","Token","Sword","Gun","Ammo","Health","Shield"}
                local nm = o.Name:lower()
                for _, k in ipairs(kw) do if nm:find(k:lower()) then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        o.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3)
                    end
                    break
                end end
            end
        end
    end, 0.5)
    Notify("Auto collect started", nil, ">")
end)

-- CATEGORY 15: EFFECTS
local efc = catCons[15]
Toggle(efc, 6, "Trail", function(s)
    local c = player.Character; if not c then return end
    if s then
        local tr = Instance.new("Trail"); tr.Name="AuraTrail"; tr.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,60,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,150))}); tr.Transparency=NumberSequence.new(0.5); tr.LightEmission=1; tr.Lifetime=0.5; tr.Parent = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c
    else
        for _, o in ipairs((c:FindFirstChild("HumanoidRootPart") or c):GetChildren()) do if o:IsA("Trail") and o.Name=="AuraTrail" then o:Destroy() end end
    end
end)
Toggle(efc, 38, "Particle Aura", function(s)
    local c = player.Character; if not c then return end
    if s then
        local p = Instance.new("ParticleEmitter"); p.Name="AuraParticle"; p.Texture="rbxassetid://357767916"; p.Rate=50; p.Lifetime=NumberRange.new(1,2); p.Speed=NumberRange.new(2,5); p.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(140,60,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(255,0,150))}); p.LightEmission=1; p.Parent = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c
    else
        for _, o in ipairs((c:FindFirstChild("HumanoidRootPart") or c):GetChildren()) do if o:IsA("ParticleEmitter") and o.Name=="AuraParticle" then o:Destroy() end end
    end
end)
Toggle(efc, 70, "Fire Aura", function(s)
    local c = player.Character; if not c then return end
    if s then
        local f = Instance.new("Fire"); f.Name="AuraFire"; f.Heat=5; f.Size=10; f.Color=Color3.fromRGB(140,60,255); f.SecondaryColor=Color3.fromRGB(255,0,150); f.Parent = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c
    else
        for _, o in ipairs((c:FindFirstChild("HumanoidRootPart") or c):GetChildren()) do if o:IsA("Fire") and o.Name=="AuraFire" then o:Destroy() end end
    end
end)
Toggle(efc, 102, "Sparkles", function(s)
    local c = player.Character; if not c then return end
    if s then
        local sp = Instance.new("Sparkles"); sp.Name="AuraSparkles"; sp.SparkleColor=Color3.fromRGB(140,60,255); sp.Parent = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c
    else
        for _, o in ipairs((c:FindFirstChild("HumanoidRootPart") or c):GetChildren()) do if o:IsA("Sparkles") and o.Name=="AuraSparkles" then o:Destroy() end end
    end
end)
-- CATEGORY 16: SOUND
local soc = catCons[16]
local musicOn = false
Toggle(soc, 6, "Music Player", function(s)
    musicOn = s
    if s then
        local ms = Instance.new("Sound"); ms.Name="AuraMusic"; ms.SoundId="rbxassetid://1834078179"; ms.Looped=true; ms.Volume=0.3; ms.Parent=gui; ms:Play()
    else
        local ms = gui:FindFirstChild("AuraMusic"); if ms then ms:Stop(); ms:Destroy() end
    end
end)
local soundButtons = {
    {"Laser","rbxassetid://4523092734"}, {"Explosion","rbxassetid://138087313"}, {"Coin","rbxassetid://4590662766"},
    {"Bell","rbxassetid://131573697"}, {"Swoosh","rbxassetid://2235655773"}, {"Click","rbxassetid://139719503904449"}
}
local sbY = 46
for _, sb in ipairs(soundButtons) do
    Button(soc, sbY, "Play "..sb[1], function()
        local s = Instance.new("Sound"); s.SoundId=sb[2]; s.Volume=0.5; s.Parent=gui; s:Play()
        Debris:AddItem(s, 5)
    end)
    sbY = sbY + 34
end
Button(soc, sbY, "Mute Game Sounds", function()
    for _, o in ipairs(Workspace:GetDescendants()) do if o:IsA("Sound") then o.Volume = 0 end end
    Notify("Game sounds muted", nil, "X")
end)

-- CATEGORY 17: KEYBINDS
local kbc = catCons[17]
local function SetKey(name, defaultKey, action)
    if keybinds[name] then
        local old = keybinds[name]
        old:Disconnect()
        keybinds[name] = nil
    end
    local con = UserInputService.InputBegan:Connect(function(i, gpe)
        if gpe then return end
        if i.KeyCode == Enum.KeyCode[defaultKey] then
            action()
        end
    end)
    keybinds[name] = con
end
Button(kbc, 6, "Set Fling Key (F)", function() SetKey("fling", "F", DoFling); Notify("Fling bound to F", nil, ">") end)
Button(kbc, 40, "Set TP Key (G)", function()
    SetKey("clicktp", "G", function()
        local ray = Workspace.CurrentCamera:ViewportPointToRay(mouse.X, mouse.Y)
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(ray.Origin + ray.Direction * 100) end
    end)
    Notify("Click TP bound to G", nil, ">")
end)
Button(kbc, 74, "Set Spin Key (H)", function()
    SetKey("spin", "H", function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(180), 0) end
    end)
    Notify("180 spin bound to H", nil, ">")
end)
Button(kbc, 108, "Clear Keybinds", function() for _, c in pairs(keybinds) do pcall(function() c:Disconnect() end) end; keybinds = {}; Notify("Keybinds cleared", nil, "X") end)

-- CATEGORY 18: SERVER
local svc = catCons[18]
Button(svc, 6, "Server Info", function()
    local pp = CreatePopup("Server Info", 300, 200)
    local info = string.format("Server ID: %s\nPlace ID: %d\nPlayers: %d/%d\nFPS: %.0f\nPing: %dms\nTime: %.0fs", game.JobId, game.PlaceId, #Players:GetPlayers(), Players.MaxPlayers, workspace:GetRealPhysicsFPS(), player:GetNetworkPing()*1000, workspace.DistributedGameTime)
    local l = Instance.new("TextLabel", pp); l.Size=UDim2.new(1,-16,1,-8); l.Position=UDim2.new(0,8,0,4); l.BackgroundTransparency=1; l.Text=info; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.Gotham; l.TextSize=13; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextYAlignment=Enum.TextYAlignment.Top
end)
Button(svc, 40, "Rejoin Server", function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player) end) end)
Button(svc, 74, "Server Hop", function()
    pcall(function()
        local servers = {}
        local cursor = ""
        while true do
            local res = HttpService:JSONDecode(game:HttpGet(string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=100&cursor=%s", game.PlaceId, cursor)))
            for _, s in ipairs(res.data) do table.insert(servers, s.id) end
            if res.nextPageCursor then cursor = res.nextPageCursor else break end
        end
        for _, id in ipairs(servers) do
            if id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, id, player)
                break
            end
        end
    end)
end)
Toggle(svc, 108, "Server Lag", function(s)
    if s then CM:Loop("LagServer", function()
        local parts = Workspace:GetDescendants()
        for i = 1, 50 do
            local p = parts[math.random(#parts)]
            if p:IsA("BasePart") then p.Velocity = Vector3.new(math.random(-1000,1000), math.random(-1000,1000), math.random(-1000,1000)) end
        end
    end, 0.05) else CM:Stop("LagServer") end
end)

-- CATEGORY 19: BYPASS
local bpc = catCons[19]
Toggle(bpc, 6, "Chat Bypass", function(s)
    if s then CM:Loop("BypassChat", function()
        pcall(function()
            local plrName = player.Name
            local newName = plrName:sub(1,1)..string.char(226,130,172)..plrName:sub(2)
            for _, o in ipairs(Players:GetPlayers()) do
                if o ~= player then
                    local c = o.Character
                    if c and c:FindFirstChild("Head") then
                        local bb = c:FindFirstChild("Head"):FindFirstChild("BypassName")
                        if not bb then
                            bb = Instance.new("BillboardGui"); bb.Name="BypassName"; bb.Size=UDim2.new(0,100,0,20); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true; bb.Adornee=c.Head; bb.Parent=c.Head
                            local l = Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text=newName; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.GothamBold; l.TextSize=14
                        end
                    end
                end
            end
        end)
    end, 5) else CM:Stop("BypassChat"); for _, o in ipairs(Players:GetPlayers()) do if o ~= player and o.Character and o.Character:FindFirstChild("Head") then local bb = o.Character.Head:FindFirstChild("BypassName"); if bb then bb:Destroy() end end end end
end)

-- CATEGORY 20: ADMIN
local admc = catCons[20]
Button(admc, 6, "Fake Admin Badge", function()
    Notify("Admin badge equipped!", Color3.fromRGB(255,200,0), "*")
    local c = player.Character
    if c and c:FindFirstChild("Head") then
        local bb = Instance.new("BillboardGui"); bb.Name="AdminBadge"; bb.Size=UDim2.new(0,30,0,30); bb.StudsOffset=Vector3.new(0,3.5,0); bb.AlwaysOnTop=true; bb.Adornee=c.Head; bb.Parent=c.Head
        local f = Instance.new("Frame",bb); f.Size=UDim2.new(1,0,1,0); f.BackgroundColor3=Color3.fromRGB(255,200,0); f.BorderSizePixel=0; Instance.new("UICorner",f).CornerRadius=UDim.new(1,0)
        local l = Instance.new("TextLabel",f); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text="A"; l.TextColor3=Color3.new(1,1,1); l.Font=Enum.Font.GothamBold; l.TextSize=20
    end
end)
Button(admc, 40, "Fake Admin Chat", function()
    local msgs = {"[Server] "..player.Name.." has been promoted to Admin!", "[Server] Administrator commands enabled for "..player.Name, "[Server] "..player.Name.." is now a Server Moderator", "[Admin] "..player.Name.." :ban all"}
    local msg = msgs[math.random(#msgs)]
    pcall(function() StarterGui:SetCore("ChatMakeSystemMessage", {Text=msg, Color=Color3.fromRGB(255,100,0)}) end)
    Notify("Fake admin message sent", nil, ">")
end)
Button(admc, 74, "Announce Message", function()
    local msgs = {"ENDER v7.0 is running!", "ENDER Menu on top!", "This server has been compromised", "Check your inventory for free items!"}
    local msg = msgs[math.random(#msgs)]
    pcall(function() StarterGui:SetCore("ChatMakeSystemMessage", {Text="[ANNOUNCEMENT] "..msg, Color=Color3.fromRGB(0,200,255)}) end)
end)
-- CATEGORY 21: BUILDING
local blc = catCons[21]
local deleteToolOn = false
Toggle(blc, 6, "Delete Tool", function(s)
    deleteToolOn = s
    if s then
        local tool = Instance.new("Tool"); tool.Name="DeleteTool"; tool.RequiresHandle=false; tool.CanBeDropped=false; tool.Parent = player.Backpack
        tool.Activated:Connect(function()
            local t = mouse.Target
            if t and t:IsA("BasePart") and not t:IsDescendantOf(player.Character) then
                local p = t:FindFirstAncestorOfClass("Model")
                if p then p:Destroy() else t:Destroy() end
                Notify("Deleted "..t.Name, nil, "X")
            end
        end)
        tool.Equipped:Connect(function() Notify("Delete tool equipped", nil, ">") end)
    else
        local tool = player.Backpack:FindFirstChild("DeleteTool")
        if tool then tool:Destroy() end
        local c = player.Character
        if c then
            tool = c:FindFirstChild("DeleteTool")
            if tool then tool:Destroy() end
        end
    end
end)
Toggle(blc, 38, "NoCollide Tool", function(s)
    if s then
        local tool = Instance.new("Tool"); tool.Name="NoCollideTool"; tool.RequiresHandle=false; tool.CanBeDropped=false; tool.Parent = player.Backpack
        tool.Activated:Connect(function()
            local t = mouse.Target
            if t then t.CanCollide = false; Notify("NoCollide: "..t.Name, nil, ">") end
        end)
    else
        local tool = player.Backpack:FindFirstChild("NoCollideTool"); if tool then tool:Destroy() end
        local c = player.Character; if c then tool = c:FindFirstChild("NoCollideTool"); if tool then tool:Destroy() end end
    end
end)
Button(blc, 70, "Copy Part Tool", function()
    local tool = Instance.new("Tool"); tool.Name="CopyTool"; tool.RequiresHandle=false; tool.CanBeDropped=false; tool.Parent = player.Backpack
    tool.Activated:Connect(function()
        local t = mouse.Target
        if t and t:IsA("BasePart") then
            local clone = t:Clone()
            clone.Position = t.Position + Vector3.new(0,5,0)
            clone.Parent = Workspace
            Notify("Copied "..t.Name, nil, "V")
        end
    end)
    tool.Equipped:Connect(function() Notify("Copy tool equipped", nil, ">") end)
end)
Button(blc, 104, "Undo Last", function()
    local parts = Workspace:GetChildren()
    for i = #parts, 1, -1 do
        if parts[i]:IsA("BasePart") then parts[i]:Destroy(); Notify("Undone", nil, ">"); break end
    end
end)

-- CATEGORY 22: DOORS
local doc = catCons[22]
local doorKW = {"Door","Gate","Entrance","Exit","Portal","Barrier","Wall","Fence"}
Toggle(doc, 6, "ESP Doors", function(s)
    if s then CM:Loop("DoorESP", function()
        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) and not o:FindFirstChild("DoorESP") then
                local nm = o.Name:lower()
                for _, k in ipairs(doorKW) do if nm:find(k:lower()) then
                    local bb=Instance.new("BillboardGui"); bb.Name="DoorESP"; bb.Size=UDim2.new(0,40,0,12); bb.StudsOffset=Vector3.new(0,1,0); bb.AlwaysOnTop=true; bb.Adornee=o; bb.Parent=o
                    local l=Instance.new("TextLabel",bb); l.Size=UDim2.new(1,0,1,0); l.BackgroundTransparency=1; l.Text="DOOR"; l.TextColor3=Color3.fromRGB(0,200,255); l.Font=Enum.Font.GothamBold; l.TextSize=10; break
                end end
            end
        end
    end, 3) else CM:Stop("DoorESP"); for _, o in ipairs(Workspace:GetDescendants()) do local l=o:FindFirstChild("DoorESP"); if l then l:Destroy() end end end
end)
Button(doc, 38, "Unlock All Doors", function()
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) then
            pcall(function() o.CanCollide = false end)
        end
    end
    Notify("Doors unlocked (NoCollide)", nil, ">")
end)
Button(doc, 72, "Delete All Doors", function()
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") and not o:IsDescendantOf(player.Character) then
            local nm = o.Name:lower()
            for _, k in ipairs(doorKW) do if nm:find(k:lower()) then pcall(function() o:Destroy() end); break end end
        end
    end
    Notify("Doors deleted (local)", nil, "X")
end)
Toggle(doc, 104, "Auto Open", function(s)
    if s then CM:Loop("AutoOpen", function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            for _, o in ipairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and o.CanCollide and not o:IsDescendantOf(player.Character) then
                    if (o.Position - pos).Magnitude < 10 then
                        pcall(function() o.CanCollide = false; task.delay(0.5, function() if o and o.Parent then o.CanCollide = true end end) end)
                    end
                end
            end
        end
    end, 0.3) else CM:Stop("AutoOpen") end
end)

-- CATEGORY 23: SAFETY
local sfc = catCons[23]
Toggle(sfc, 6, "Anti-Fling", function(s)
    if s then
        local safe = nil
        CM:Add("AntiFling2", RunService.Stepped:Connect(function()
            if flingingNow then return end
            if not player.Character then return end
            local hrp = player.Character:FindFirstChild("HumanoidRootPart"); if not hrp then return end
            pcall(function() hrp:SetNetworkOwner(player) end)
            hrp.AssemblyLinearVelocity = Vector3.new(0,0,0); hrp.AssemblyAngularVelocity = Vector3.new(0,0,0)
            if safe then if (hrp.Position-safe).Magnitude > 4 then hrp.CFrame = CFrame.new(safe) else safe = hrp.Position end else safe = hrp.Position end
        end))
    else CM:Rem("AntiFling2") end
    Notify("Anti-Fling: "..(s and "ON" or "OFF"))
end)
Toggle(sfc, 38, "Anti-Fall", function(s)
    if s then CM:Loop("AntiFall", function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Character.HumanoidRootPart.Position.Y < -500 then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0,50,0)
            end
        end
    end, 0.5) else CM:Stop("AntiFall") end
end)
Toggle(sfc, 70, "Auto Respawn", function(s)
    if s then CM:Add("AutoRespawn", player.CharacterAdded:Connect(function() Notify("Respawn detected", nil, ">") end)) else CM:Rem("AutoRespawn") end
end)
Toggle(sfc, 102, "No Clip Damage", function(s)
    if s then CM:Add("NoClipDmg", RunService.Stepped:Connect(function()
        local c = player.Character; if not c then return end
        local h = c:FindFirstChild("Humanoid"); if not h then return end
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end)) else CM:Rem("NoClipDmg") end
end)

-- CATEGORY 24: SKINS
local skc = catCons[24]
local bodyColors = {
    {"Red", Color3.fromRGB(255,0,0)}, {"Blue", Color3.fromRGB(0,0,255)}, {"Green", Color3.fromRGB(0,255,0)},
    {"Yellow", Color3.fromRGB(255,255,0)}, {"Purple", Color3.fromRGB(150,0,255)}, {"Pink", Color3.fromRGB(255,100,200)},
    {"Orange", Color3.fromRGB(255,100,0)}, {"White", Color3.fromRGB(255,255,255)}, {"Black", Color3.fromRGB(0,0,0)}
}
local bcy = 6
for _, bc in ipairs(bodyColors) do
    Button(skc, bcy, bc[1], function()
        local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color = bc[2] end end end
        Notify("Color: "..bc[1], nil, "V")
    end)
    bcy = bcy + 30
end
Toggle(skc, bcy, "Rainbow Skin", function(s)
    if s then CM:Loop("RainbowSkin", function() local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color = Color3.fromHSV(tick()*0.3%1, 1, 1) end end end end, 0.1) else CM:Stop("RainbowSkin"); local c = player.Character; if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Color = Color3.new(1,1,1) end end end end
end)
-- CATEGORY 25: ABOUT
local abc = catCons[25]
local aboutText = Instance.new("TextLabel", abc)
aboutText.Size = UDim2.new(1, -16, 1, -60)
aboutText.Position = UDim2.new(0, 8, 0, 8)
aboutText.BackgroundTransparency = 1
aboutText.Text = [[ENDER MENU v7.0
Ultimate Edition

26 Categories | 110+ Features
Improved UI | Minimize | Drag
Config Save/Load | Popups

Keybinds:
 K - Toggle Menu
 E - Fling
 T - Click TP
 Space - Cancel Zero Grav

Created for educational purposes.]]
aboutText.TextColor3 = Color3.new(1,1,1)
aboutText.Font = Enum.Font.Gotham
aboutText.TextSize = 12
aboutText.TextXAlignment = Enum.TextXAlignment.Left
aboutText.TextYAlignment = Enum.TextYAlignment.Top
aboutText.RichText = true

Button(abc, 0, "Toggle Sound", function() for _, s in pairs(Snd._) do s.Volume = s.Volume > 0 and 0 or 0.35 end; Notify("Sound toggled") end)
Button(abc, 34, "VR Head+Hands", function()
    pcall(function()
        local vrService = game:GetService("VRService")
        local uis = game:GetService("UserInputService")
        local runSvc = game:GetService("RunService")
        if not uis.VREnabled then Notify("VR not detected", Color3.fromRGB(200,0,0), "X"); return end
        local c = player.Character
        if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart")
        local head = c:FindFirstChild("Head")
        if not hrp or not head then return end
        head.Transparency = 1
        local lhp = Instance.new("Part"); lhp.Name = "VR_LeftHand"; lhp.Size = Vector3.new(0.6,0.6,2); lhp.Shape = Enum.PartType.Block; lhp.Anchored = true; lhp.CanCollide = false; lhp.Material = Enum.Material.SmoothPlastic; lhp.Color = Color3.new(0,0,0); lhp.Parent = workspace
        local rhp = Instance.new("Part"); rhp.Name = "VR_RightHand"; rhp.Size = Vector3.new(0.6,0.6,2); rhp.Shape = Enum.PartType.Block; rhp.Anchored = true; rhp.CanCollide = false; rhp.Material = Enum.Material.SmoothPlastic; rhp.Color = Color3.new(0,0,0); rhp.Parent = workspace
        local hp = Instance.new("Part"); hp.Name = "VR_Head"; hp.Size = Vector3.new(1.2,1.2,1); hp.Shape = Enum.PartType.Ball; hp.Anchored = true; hp.CanCollide = false; hp.Material = Enum.Material.SmoothPlastic; hp.Color = Color3.fromRGB(255,200,150); hp.Transparency = 0.3; hp.Parent = workspace
        local cam = workspace.CurrentCamera
        local function HideChar(ch)
            if not ch then return end
            local h = ch:FindFirstChildOfClass("Humanoid")
            if h then
                h.BreakJointsOnDeath = false
                h.PlatformStand = true
                h.AutoRotate = false
            end
            for _, p in ipairs(ch:GetDescendants()) do
                if p:IsA("BasePart") then p.Transparency = 1; p.CanCollide = false; p.Anchored = true end
            end
        end
        HideChar(c)
        CM:Loop("VRFollow", function()
            local ch = player.Character
            if ch and hp and hp.Parent then
                local h = ch:FindFirstChildOfClass("Humanoid")
                if h then h.PlatformStand = true; h.AutoRotate = false end
                ch:SetPrimaryPartCFrame(CFrame.new(hp.Position))
                for _, p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false; p.Anchored = true end end
            end
        end, 0.1)
        player.CharacterAdded:Connect(function(nc)
            task.wait()
            HideChar(nc)
            if hp and hp.Parent then nc:SetPrimaryPartCFrame(CFrame.new(hp.Position)) end
        end)
        local function Aim(part, hrp)
            local dir = (part.Position - hrp.Position).Unit
            if dir.Magnitude > 0.1 then
                part.CFrame = CFrame.lookAt(part.Position, part.Position + dir)
            end
        end
        local con2 = runSvc.RenderStepped:Connect(function()
            local ch = player.Character
            if ch and ch:FindFirstChild("HumanoidRootPart") and hp then
                local hrp = ch.HumanoidRootPart
                if hp then
                    ch:SetPrimaryPartCFrame(CFrame.new(hp.Position))
                end
                Aim(lhp, hrp); Aim(rhp, hrp)
            end
        end)
        con2 = runSvc.RenderStepped:Connect(function()
            local ch = player.Character
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
            if ch.HumanoidRootPart and hp then
                ch.HumanoidRootPart.CFrame = CFrame.new(hp.Position) * CFrame.Angles(0, cam.CFrame.LookVector.X > 0 and math.pi or 0, 0)
            end
        end)
        Notify("VR Head+Hands active", Color3.fromRGB(0,200,80), ">")
        local function AttachAccessories()
            local ch = player.Character; if not ch then return end
            for _, v in ipairs(ch:GetDescendants()) do
                if v:IsA("Accessory") and v:FindFirstChild("Handle") and not v.Handle:FindFirstChild("VR_AlignP") then
                    local att0 = Instance.new("Attachment"); att0.Parent = v.Handle
                    local att1 = Instance.new("Attachment"); att1.Parent = hp
                    local ap = Instance.new("AlignPosition"); ap.Name = "VR_AlignP"; ap.Parent = v.Handle; ap.Attachment0 = att0; ap.Attachment1 = att1; ap.Responsiveness = 50; ap.MaxForce = 9e9
                    local ao = Instance.new("AlignOrientation"); ao.Name = "VR_AlignO"; ao.Parent = v.Handle; ao.Attachment0 = att0; ao.Attachment1 = att1; ap.Responsiveness = 50; ap.MaxTorque = 9e9
                end
            end
        end
        AttachAccessories()
        player.CharacterAdded:Connect(function() task.wait(1); AttachAccessories() end)
    end)
end)
Button(abc, 68, "Credits", function()
    Notify("ENDER v7.0 by night", Color3.fromRGB(140,60,255), "*")
end)

-- CATEGORY 26: EXTRA
local exc = catCons[26]
Toggle(exc, 6, "Infinite Jump", function(s)
    infJmp = s
    Notify("Inf Jump: "..(s and "ON" or "OFF"))
end)
Toggle(exc, 38, "Walk on Water", function(s)
    if s then CM:Loop("WalkWater", function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            if pos.Y < -2 then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(pos.X, 0.5, pos.Z)
                local hum = player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.PlatformStand = false end
            end
        end
    end, 0.05) else CM:Stop("WalkWater") end
end)
Toggle(exc, 70, "Fullbright", function(s)
    if s then
        Lighting.Ambient = Color3.new(1,1,1)
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.new(1,1,1)
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
    else
        Lighting.Ambient = Color3.new(0,0,0)
        Lighting.Brightness = 1
        Lighting.OutdoorAmbient = Color3.new(0.6,0.6,0.6)
        Lighting.GlobalShadows = true
        Lighting.FogEnd = 100000
    end
end)
Toggle(exc, 102, "No Fall Damage", function(s)
    if s then CM:Add("NoFallDmg", RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum:GetState() == Enum.HumanoidStateType.Freefall then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
            hum.UseHumanoid = false
            hum.UseHumanoid = true
        end
    end)) else CM:Rem("NoFallDmg") end
end)
Button(exc, 134, "Third Person", function()
    local cam = workspace.CurrentCamera
    cam.CameraType = cam.CameraType == Enum.CameraType.Fixed and Enum.CameraType.Custom or Enum.CameraType.Fixed
    local c = player.Character
    if c and c:FindFirstChild("Humanoid") then
        c.Humanoid.CameraOffset = cam.CameraType == Enum.CameraType.Fixed and Vector3.new(0, 5, 15) or Vector3.new(0, 0, 0)
    end
    Notify("Third Person: "..(cam.CameraType == Enum.CameraType.Fixed and "ON" or "OFF"))
end)
Button(exc, 168, "Godmode", function()
    local c = player.Character
    if c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
            hum.BreakJointsOnDeath = false
            Notify("Godmode activated (until respawn)", Color3.fromRGB(255,200,0), "*")
        end
    end
end)

-- STARTUP
if not player.Character then player.CharacterAdded:Wait() end
task.wait(0.5)

CM:Add("Respawn", player.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    ApplyMove()
    if flyOn then EnableFly() end
    if ncOn then CM:Loop("NoClip", function() local ch = player.Character; if ch then for _, p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end, 0.05) end
    if gravOn then Workspace.Gravity = 0 end
    if returnPos then
        local sav = returnPos; returnPos = nil
        task.wait(0.3)
        local rp = c:FindFirstChild("HumanoidRootPart")
        if rp then
            local target = sav + Vector3.new(0, 1, 0)
            rp.CFrame = target; c:SetPrimaryPartCFrame(target)
        end
    end
end))

OpenMenu()
