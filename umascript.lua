--[[ Sakura Menu v1.3
Конфиг: <Workspace экзекьютора>/SakuraMenu/config.json
]]

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- ============================================================
-- КОНФИГ
-- ============================================================
local CONFIG = {
WidthScale       = 0.8,
HeightScale      = 0.75,
Transparency     = 0.5,

BgColor          = Color3.fromRGB(15, 15, 17),  
CardColor        = Color3.fromRGB(24, 24, 27),  
AccentColor      = Color3.fromRGB(255, 255, 255),  
MutedTextColor   = Color3.fromRGB(160, 160, 165),  
OnColor          = Color3.fromRGB(255, 255, 255),  
OffColor         = Color3.fromRGB(55, 55, 58),  
SakuraPink       = Color3.fromRGB(255, 158, 190),  
CloseColor       = Color3.fromRGB(255, 80, 80),  

SidebarExpanded  = 170,  
SidebarCollapsed = 56,  

AnimTime         = 0.45,  
ExpandTime       = 0.4,

}

local BASE_WIDTH_SCALE  = CONFIG.WidthScale
local BASE_HEIGHT_SCALE = CONFIG.HeightScale
local CARD_H = 48

-- глобальные подключения
local connections = {}

local function bind(signal, fn)
local c = signal:Connect(fn)
table.insert(connections, c)
return c
end

-- ============================================================
-- СОХРАНЕНИЕ
-- ============================================================
local CONFIG_FOLDER = "SakuraMenu"
local CONFIG_FILE   = CONFIG_FOLDER .. "/config.json"

local SavedState = { controls = {} }

local function LoadConfig()
local ok, decoded = pcall(function()
if isfile and isfile(CONFIG_FILE) then
return HttpService:JSONDecode(readfile(CONFIG_FILE))
end
end)

if ok and type(decoded) == "table" then  
    SavedState = decoded  
end  

SavedState.controls = SavedState.controls or {}

end

local function SaveConfig()
if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
pcall(makefolder, CONFIG_FOLDER)
end

if writefile then  
    pcall(function()  
        writefile(CONFIG_FILE, HttpService:JSONEncode(SavedState))  
    end)  
end

end

local function saveField(key, field, value)
SavedState.controls[key] = SavedState.controls[key] or {}
SavedState.controls[key][field] = value
SaveConfig()
end

LoadConfig()

do
local t = SavedState.controls["settings_transparency"]
local s = SavedState.controls["settings_size"]

if t and t.value then  
    CONFIG.Transparency = 1 - (t.value / 100)  
end  

if s and s.value then  
    CONFIG.WidthScale  = BASE_WIDTH_SCALE  * (s.value / 100)  
    CONFIG.HeightScale = BASE_HEIGHT_SCALE * (s.value / 100)  
end

end

-- ============================================================
-- УТИЛИТЫ
-- ============================================================
local function corner(radius, parent)
local c = Instance.new("UICorner")
c.CornerRadius = UDim.new(0, radius)
c.Parent = parent
return c
end

local function stroke(parent, color, transparency, thickness)
local s = Instance.new("UIStroke")
s.Color = color or CONFIG.AccentColor
s.Transparency = transparency or 0.85
s.Thickness = thickness or 1
s.Parent = parent
return s
end

local function tween(obj, time, props, style, dir)
local info = TweenInfo.new(
time,
style or Enum.EasingStyle.Quint,
dir or Enum.EasingDirection.Out
)

local t = TweenService:Create(obj, info, props)  
t:Play()  
return t

end

local function newFrame(props, parent)
local f = Instance.new("Frame")
f.BackgroundColor3 = CONFIG.BgColor
f.BorderSizePixel = 0

for k, v in pairs(props) do  
    f[k] = v  
end  

f.Parent = parent  
return f

end

local function newLabel(props, parent)
local l = Instance.new("TextLabel")
l.BackgroundTransparency = 1
l.Font = Enum.Font.GothamMedium
l.TextColor3 = CONFIG.AccentColor
l.TextSize = 15

for k, v in pairs(props) do  
    l[k] = v  
end  

l.Parent = parent  
return l

end

local function newButton(props, parent)
local b = Instance.new("TextButton")
b.BackgroundTransparency = 1
b.AutoButtonColor = false
b.Text = ""

for k, v in pairs(props) do  
    b[k] = v  
end  

b.Parent = parent  
return b

end

-- ============================================================
-- ИКОНКИ
-- ============================================================
local ICONS = {
custom = {}
}

local function iconHolder(parent, size)
return newFrame({
Name = "IconHolder",
Size = UDim2.fromOffset(size or 18, size or 18),
BackgroundTransparency = 1,
}, parent)
end

local function drawIcon(kind, parent, size)
size = size or 18

if ICONS.custom[kind] then  
    local img = Instance.new("ImageLabel")  
    img.Size = UDim2.fromOffset(size, size)  
    img.BackgroundTransparency = 1  
    img.Image = ICONS.custom[kind]  
    img.ImageColor3 = CONFIG.AccentColor  
    img.Parent = parent  
    return img  
end  

local holder = iconHolder(parent, size)  
local W = CONFIG.AccentColor  

if kind == "player" then  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.42, size * 0.42),  
        Position = UDim2.new(0.5, 0, 0.18, 0),  
        AnchorPoint = Vector2.new(0.5, 0),  
        BackgroundColor3 = W,  
    }, holder))  

    corner(6, newFrame({  
        Size = UDim2.fromOffset(size * 0.75, size * 0.4),  
        Position = UDim2.new(0.5, 0, 1, 0),  
        AnchorPoint = Vector2.new(0.5, 1),  
        BackgroundColor3 = W,  
    }, holder))  

elseif kind == "home" then
    local roof = newFrame({
        Size = UDim2.fromOffset(size * 0.7, size * 0.45),
        Position = UDim2.new(0.5, 0, 0.27, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = 45,
        BackgroundColor3 = W,
    }, holder)
    corner(2, roof)
    newFrame({
        Size = UDim2.fromOffset(size * 0.62, size * 0.5),
        Position = UDim2.new(0.5, 0, 0.65, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = W,
    }, holder)
    newFrame({
        Size = UDim2.fromOffset(size * 0.16, size * 0.28),
        Position = UDim2.new(0.5, 0, 0.72, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = CONFIG.BgColor,
    }, holder)

elseif kind == "teleport" then
    local arrow = newFrame({
        Size = UDim2.fromOffset(size * 0.58, size * 0.16),
        Position = UDim2.new(0.35, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = W,
    }, holder)
    corner(2, arrow)
    for _, rotation in ipairs({45, -45}) do
        corner(2, newFrame({
            Size = UDim2.fromOffset(size * 0.38, size * 0.16),
            Position = UDim2.new(0.7, 0, 0.5, rotation == 45 and -size * 0.12 or size * 0.12),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = rotation,
            BackgroundColor3 = W,
        }, holder))
    end

elseif kind == "farm" then  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.5, size * 0.17),  
        Position = UDim2.new(0.5, size * 0.02, 0.34, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = -28,  
        BackgroundColor3 = W,  
    }, holder))  

    corner(3, newFrame({  
        Size = UDim2.fromOffset(size * 0.16, size * 0.16),  
        Position = UDim2.fromScale(0.5, 0.5),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = 45,  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.5, size * 0.17),  
        Position = UDim2.new(0.5, -size * 0.02, 0.66, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = -28,  
        BackgroundColor3 = W,  
    }, holder))  

elseif kind == "misc" then  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.8, size * 0.36),  
        Position = UDim2.new(0.5, 0, 0.62, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.38, size * 0.38),  
        Position = UDim2.new(0.34, 0, 0.42, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.48, size * 0.48),  
        Position = UDim2.new(0.62, 0, 0.36, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = W,  
    }, holder))  

elseif kind == "settings" then  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.62, size * 0.62),  
        Position = UDim2.fromScale(0.5, 0.5),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = W,  
        ZIndex = 1,  
    }, holder))  

    local teeth = 8  

    for i = 1, teeth do  
        local angle = (360 / teeth) * i  
        local rad = math.rad(angle)  

        corner(2, newFrame({  
            Size = UDim2.fromOffset(size * 0.2, size * 0.22),  
            Position = UDim2.new(  
                0.5,  
                math.sin(rad) * size * 0.34,  
                0.5,  
                -math.cos(rad) * size * 0.34  
            ),  
            AnchorPoint = Vector2.new(0.5, 0.5),  
            Rotation = angle,  
            BackgroundColor3 = W,  
            ZIndex = 1,  
        }, holder))  
    end  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.24, size * 0.24),  
        Position = UDim2.fromScale(0.5, 0.5),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = CONFIG.BgColor,  
        ZIndex = 2,  
    }, holder))  

elseif kind == "collapse" then  

    corner(2, newFrame({  
        Size = UDim2.fromOffset(3, size),  
        Position = UDim2.fromScale(0, 0.5),  
        AnchorPoint = Vector2.new(0, 0.5),  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.42, size * 0.14),  
        Position = UDim2.new(0.62, 0, 0.5, -size * 0.15),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = 45,  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.42, size * 0.14),  
        Position = UDim2.new(0.62, 0, 0.5, size * 0.15),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = -45,  
        BackgroundColor3 = W,  
    }, holder))  

elseif kind == "logo" then  

    local petals = 5  

    for i = 1, petals do  
        local angle = (360 / petals) * i  
        local rad = math.rad(angle)  

        corner(size, newFrame({  
            Size = UDim2.fromOffset(size * 0.32, size * 0.5),  
            Position = UDim2.new(  
                0.5,  
                math.sin(rad) * size * 0.22,  
                0.5,  
                -math.cos(rad) * size * 0.22  
            ),  
            AnchorPoint = Vector2.new(0.5, 0.5),  
            Rotation = angle,  
            BackgroundColor3 = W,  
        }, holder))  
    end  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.22, size * 0.22),  
        Position = UDim2.fromScale(0.5, 0.5),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = CONFIG.BgColor,  
        ZIndex = 2,  
    }, holder))  
end  

return holder

end

local function drawCross(parent, size, color, rot1, rot2)
local holder = iconHolder(parent, size)

local function bar(rot)  
    corner(2, newFrame({  
        Size = UDim2.fromOffset(size, 3),  
        Position = UDim2.fromScale(0.5, 0.5),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = rot,  
        BackgroundColor3 = color,  
    }, holder))  
end  

bar(rot1)  

if rot2 then  
    bar(rot2)  
end  

return holder

end

-- ============================================================
-- SHIMMER
-- ============================================================
local shimmers = {}

local function attachShimmer(guiObject, colorA, colorB, period)
local grad = Instance.new("UIGradient")

grad.Color = ColorSequence.new({  
    ColorSequenceKeypoint.new(0, colorA),  
    ColorSequenceKeypoint.new(0.5, colorB),  
    ColorSequenceKeypoint.new(1, colorA),  
})  

grad.Parent = guiObject  

table.insert(shimmers, {  
    grad = grad,  
    period = period  
})  

return grad

end

bind(RunService.RenderStepped, function(dt)
for _, s in ipairs(shimmers) do
s.grad.Rotation =
(s.grad.Rotation + dt * (360 / s.period)) % 360
end
end)

-- ============================================================
-- ТУМБЛЕР
-- ============================================================
local function createToggle(parent, default, onChanged)
local state = default or false

local track = newFrame({  
    Name = "Toggle",  
    Size = UDim2.fromOffset(42, 24),  
    BackgroundColor3 = state and CONFIG.OnColor or CONFIG.OffColor,  
}, parent)  

corner(12, track)  

local knob = newFrame({  
    Size = UDim2.fromOffset(18, 18),  
    Position = state  
        and UDim2.new(1, -21, 0.5, 0)  
        or UDim2.new(0, 3, 0.5, 0),  
    AnchorPoint = Vector2.new(0, 0.5),  
    BackgroundColor3 = Color3.fromRGB(15, 15, 17),  
}, track)  

corner(9, knob)  

local hit = newButton({  
    Size = UDim2.fromScale(1, 1),  
    ZIndex = 5  
}, track)  

hit.MouseButton1Click:Connect(function()  
    state = not state  

    tween(track, 0.18, {  
        BackgroundColor3 =  
            state and CONFIG.OnColor or CONFIG.OffColor  
    })  

    tween(knob, 0.18, {  
        Position = state  
            and UDim2.new(1, -21, 0.5, 0)  
            or UDim2.new(0, 3, 0.5, 0),  
    })  

    if onChanged then  
        onChanged(state)  
    end  
end)  

return track

end

-- ============================================================
-- КАРТОЧКИ
-- ============================================================
local function createCard(parent, title, desc, key, opts)
opts = opts or {}

local saved = SavedState.controls[key] or {}  
local on = saved.on or false  
local expandedH = opts.expandedH  

local card = newFrame({  
    Name = "Card",  
    Size = UDim2.new(  
        1,  
        0,  
        0,  
        (expandedH and on) and expandedH or CARD_H  
    ),  
    BackgroundColor3 = CONFIG.CardColor,  
    ClipsDescendants = true,  
}, parent)  

corner(8, card)  
stroke(card, CONFIG.AccentColor, 0.9, 1)  

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 6),  
    Size = UDim2.new(1, -72, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

newLabel({  
    Text = desc,  
    Position = UDim2.new(0, 14, 0, 24),  
    Size = UDim2.new(1, -72, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    TextColor3 = CONFIG.MutedTextColor,  
    TextSize = 11,  
}, card)  

local toggleHolder = newFrame({  
    Size = UDim2.fromOffset(42, 24),  
    Position = UDim2.new(1, -14, 0, 12),  
    AnchorPoint = Vector2.new(1, 0),  
    BackgroundTransparency = 1,  
}, card)  

if opts.build then  
    local panel = newFrame({  
        Name = "Panel",  
        Position = UDim2.new(0, 14, 0, CARD_H),  
        Size = UDim2.new(  
            1,  
            -28,  
            0,  
            expandedH - CARD_H - 8  
        ),  
        BackgroundTransparency = 1,  
    }, card)  

    opts.build(panel, saved)  
end  

createToggle(toggleHolder, on, function(state)  
    on = state  
    saveField(key, "on", state)  

    if expandedH then  
        tween(card, CONFIG.ExpandTime, {  
            Size = UDim2.new(  
                1,  
                0,  
                0,  
                on and expandedH or CARD_H  
            ),  
        }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)  
    end  

    if opts.onToggle then  
        opts.onToggle(state)  
    end  
end)  

return card

end

local function createFunctionCard(parent, title, desc, tabName, key, handlers)
return createCard(parent, title, desc, key, {
onToggle = function(state)
print((
"[Sakura] %s -> %s: %s"
):format(
tabName,
title,
tostring(state)
))

if handlers and handlers.onToggle then  
            handlers.onToggle(state)  
        end  
    end,  
})

end

local function createActionCard(parent, title, desc, key, action)
    local card = newFrame({
        Name = "ActionCard",
        Size = UDim2.new(1, 0, 0, CARD_H),
        BackgroundColor3 = CONFIG.CardColor,
    }, parent)
    corner(8, card)
    stroke(card, CONFIG.AccentColor, 0.9, 1)
    newLabel({
        Text = title,
        Position = UDim2.new(0, 14, 0, 6),
        Size = UDim2.new(1, -72, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
    }, card)
    newLabel({
        Text = desc,
        Position = UDim2.new(0, 14, 0, 24),
        Size = UDim2.new(1, -72, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = CONFIG.MutedTextColor,
        TextSize = 11,
    }, card)
    newLabel({
        Text = ">",
        Position = UDim2.new(1, -42, 0, 0),
        Size = UDim2.fromOffset(28, CARD_H),
        TextXAlignment = Enum.TextXAlignment.Center,
        Font = Enum.Font.GothamBold,
        TextSize = 22,
    }, card)
    local hit = newButton({
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
    }, card)
    hit.MouseButton1Click:Connect(function()
        if action then action() end
    end)
    return card
end

-- ============================================================
-- SLIDER
-- ============================================================
local function createSliderCard(parent, title, desc, key, handlers)
handlers = handlers or {}

return createCard(parent, title, desc, key, {  
    expandedH = 100,  
    onToggle = handlers.onToggle,  

    build = function(panel, saved)  
        local value = saved.value or 50  

        local valueLabel = newLabel({  
            Text = tostring(value),  
            Size = UDim2.new(1, 0, 0, 18),  
            Font = Enum.Font.GothamBold,  
            TextSize = 14,  
            TextXAlignment = Enum.TextXAlignment.Center,  
        }, panel)  

        local hit = newFrame({  
            Name = "Hit",  
            Position = UDim2.new(0, 0, 0, 20),  
            Size = UDim2.new(1, 0, 0, 24),  
            BackgroundTransparency = 1,  
            Active = true,  
        }, panel)  

        local track = newFrame({  
            Name = "Track",  
            Size = UDim2.new(1, 0, 0, 10),  
            Position = UDim2.new(0, 0, 0.5, 0),  
            AnchorPoint = Vector2.new(0, 0.5),  
            BackgroundColor3 = CONFIG.OffColor,  
        }, hit)  

        corner(5, track)  

        local fill = newFrame({  
            Name = "Fill",  
            Size = UDim2.new(value / 100, 0, 1, 0),  
            BackgroundColor3 = CONFIG.OnColor,  
        }, track)  

        corner(5, fill)  

        local handle = newFrame({  
            Name = "Handle",  
            Size = UDim2.fromOffset(16, 16),  
            Position = UDim2.new(value / 100, 0, 0.5, 0),  
            AnchorPoint = Vector2.new(0.5, 0.5),  
            BackgroundColor3 = CONFIG.AccentColor,  
        }, track)  

        corner(8, handle)  

        local function setValue(v)  
            v = math.clamp(  
                math.floor(v + 0.5),  
                1,  
                100  
            )  

            value = v  

            fill.Size = UDim2.new(  
                v / 100,  
                0,  
                1,  
                0  
            )  

            handle.Position = UDim2.new(  
                v / 100,  
                0,  
                0.5,  
                0  
            )  

            valueLabel.Text = tostring(v)  

            if handlers.onChange then  
                handlers.onChange(v)  
            end  
        end  

        local function isPointer(input)  
            return input.UserInputType ==  
                Enum.UserInputType.MouseButton1  
                or input.UserInputType ==  
                Enum.UserInputType.Touch  
        end  

        local scroller =  
            panel:FindFirstAncestorOfClass("ScrollingFrame")  

        local dragging = false  

        local function updateFromInput(pos)  
            setValue(  
                ((pos.X - track.AbsolutePosition.X) /  
                track.AbsoluteSize.X) * 100  
            )  
        end  

        hit.InputBegan:Connect(function(input)  
            if isPointer(input) then  
                dragging = true  

                if scroller then  
                    scroller.ScrollingEnabled = false  
                end  

                updateFromInput(input.Position)  
            end  
        end)  

        bind(UserInputService.InputChanged, function(input)  
            if dragging and (  
                input.UserInputType ==  
                    Enum.UserInputType.MouseMovement  
                or input.UserInputType ==  
                    Enum.UserInputType.Touch  
            ) then  
                updateFromInput(input.Position)  
            end  
        end)  

        bind(UserInputService.InputEnded, function(input)  
            if dragging and isPointer(input) then  
                dragging = false  

                if scroller then  
                    scroller.ScrollingEnabled = true  
                end  

                saveField(key, "value", value)  

                print(  
                    ("[Sakura] %s = %d"):format(  
                        title,  
                        value  
                    )  
                )  
            end  
        end)  
    end,  
})

end

-- ============================================================
-- INPUT
-- ============================================================
local function createInputCard(parent, title, desc, key)
return createCard(parent, title, desc, key, {
expandedH = 88,

build = function(panel, saved)  
        newLabel({  
            Text = "Описание",  
            Size = UDim2.new(1, -100, 0, 30),  
            TextXAlignment = Enum.TextXAlignment.Left,  
            TextColor3 = CONFIG.MutedTextColor,  
            TextSize = 12,  
        }, panel)  

        local box = Instance.new("TextBox")  

        box.Name = "Input"  
        box.Size = UDim2.fromOffset(90, 30)  
        box.Position = UDim2.new(1, 0, 0, 0)  
        box.AnchorPoint = Vector2.new(1, 0)  
        box.BackgroundColor3 = CONFIG.BgColor  
        box.TextColor3 = CONFIG.AccentColor  
        box.PlaceholderText = "0"  
        box.PlaceholderColor3 = CONFIG.MutedTextColor  
        box.Font = Enum.Font.GothamMedium  
        box.TextSize = 13  
        box.ClearTextOnFocus = false  
        box.Text = saved.text or ""  
        box.Parent = panel  

        corner(6, box)  
        stroke(box, CONFIG.AccentColor, 0.85, 1)  

        box.FocusLost:Connect(function()  
            local cleaned = box.Text:gsub("%D", "")  

            box.Text = cleaned  

            saveField(  
                key,  
                "text",  
                cleaned  
            )  

            print(  
                ("[Sakura] %s = %s"):format(  
                    title,  
                    cleaned  
                )  
            )  
        end)  
    end,  
})

end

local function createTextInputCard(parent, title, desc, key, placeholder, onSave)
    return createCard(parent, title, desc, key, {
        expandedH = 88,
        build = function(panel, saved)
            local box = Instance.new("TextBox")
            box.Name = "Input"
            box.Size = UDim2.fromOffset(180, 30)
            box.Position = UDim2.new(1, 0, 0, 0)
            box.AnchorPoint = Vector2.new(1, 0)
            box.BackgroundColor3 = CONFIG.BgColor
            box.TextColor3 = CONFIG.AccentColor
            box.PlaceholderText = placeholder or ""
            box.PlaceholderColor3 = CONFIG.MutedTextColor
            box.Font = Enum.Font.GothamMedium
            box.TextSize = 12
            box.ClearTextOnFocus = false
            box.Text = saved.text or ""
            box.Parent = panel
            corner(6, box)
            stroke(box, CONFIG.AccentColor, 0.85, 1)
            box.FocusLost:Connect(function()
                saveField(key, "text", box.Text)
                if onSave then onSave(box.Text) end
            end)
        end,
    })
end

-- ============================================================
-- STEPPER
-- ============================================================
local function createPercentRow(parent, title, options, default, onSelect, suffix)
local row = newFrame({
Name = "StepperRow",
Size = UDim2.new(1, 0, 0, 44),
BackgroundColor3 = CONFIG.CardColor,
}, parent)

corner(8, row)  
stroke(row, CONFIG.AccentColor, 0.9, 1)  

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 0),  
    Size = UDim2.new(1, -134, 1, 0),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, row)  

local index = 1  

for i, v in ipairs(options) do  
    if v == default then  
        index = i  
    end  
end  

local stepper = newFrame({  
    Size = UDim2.fromOffset(112, 26),  
    Position = UDim2.new(1, -12, 0.5, 0),  
    AnchorPoint = Vector2.new(1, 0.5),  
    BackgroundTransparency = 1,  
}, row)  

local function stepButton(x, text)  
    local b = newButton({  
        Size = UDim2.fromOffset(26, 26),  
        Position = UDim2.new(0, x, 0, 0),  
        BackgroundColor3 = CONFIG.OffColor,  
    }, stepper)  

    corner(6, b)  

    newLabel({  
        Text = text,  
        Size = UDim2.fromScale(1, 1),  
        Font = Enum.Font.GothamBold,  
        TextSize = 16,  
    }, b)  

    return b  
end  

local btnMinus = stepButton(0, "-")  

local valueLabel = newLabel({  
    Text = options[index] .. (suffix or "%"),  
    Position = UDim2.new(0, 30, 0, 0),  
    Size = UDim2.fromOffset(52, 26),  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
    TextXAlignment = Enum.TextXAlignment.Center,  
}, stepper)  

local btnPlus = stepButton(86, "+")  

local function apply()  
    valueLabel.Text = options[index] .. (suffix or "%")  

    if onSelect then  
        onSelect(options[index])  
    end  
end  

btnMinus.MouseButton1Click:Connect(function()  
    if index > 1 then  
        index -= 1  
        apply()  
    end  
end)  

btnPlus.MouseButton1Click:Connect(function()  
    if index < #options then  
        index += 1  
        apply()  
    end  
end)  

return row

end

-- ============================================================
-- SPEED
-- ============================================================
local savedSpeed = SavedState.controls["player_3"] or {}

local SPEED_SCALE = 4 -- слайдер 1-100 даёт WalkSpeed до 400 вместо 100

local Speed = {
enabled = savedSpeed.on or false,
value = savedSpeed.value or 50,
original = 16,
}

local function getHumanoid()
local char = Players.LocalPlayer.Character
return char and char:FindFirstChildOfClass("Humanoid")
end

do
local hum = getHumanoid()

if hum then  
    Speed.original = hum.WalkSpeed  
end

end

local function enforceSpeed()
if not Speed.enabled then
return
end

local hum = getHumanoid()  

local target = Speed.value * SPEED_SCALE

if hum and hum.WalkSpeed ~= target then  
    hum.WalkSpeed = target  
end

end

bind(RunService.Stepped, enforceSpeed)
bind(RunService.RenderStepped, enforceSpeed)
bind(RunService.Heartbeat, enforceSpeed)

bind(RunService.Heartbeat, function(dt)
if not Speed.enabled then
return
end

local hum = getHumanoid()  
local root = hum and hum.RootPart  

if not root then  
    return  
end  

local dir = hum.MoveDirection  

if dir.Magnitude < 0.1 then  
    return  
end  

local v = root.AssemblyLinearVelocity  
local current =  
    Vector3.new(v.X, 0, v.Z).Magnitude  

local extra = (Speed.value * SPEED_SCALE) - current  

if extra > 0 then  
    root.CFrame =  
        root.CFrame +  
        dir.Unit * extra * dt  
end

end)

local SpeedHandlers = {
onChange = function(v)
Speed.value = v
end,

onToggle = function(state)  
    local hum = getHumanoid()  

    print((  
        "[Sakura] Speed %s | humanoid: %s | WalkSpeed: %s"  
    ):format(  
        tostring(state),  
        tostring(hum ~= nil),  
        hum and tostring(hum.WalkSpeed) or "-"  
    ))  

    if state then  
        if hum then  
            Speed.original = hum.WalkSpeed  
        end  

        Speed.enabled = true  
    else  
        Speed.enabled = false  

        if hum then  
            hum.WalkSpeed = Speed.original  
        end  
    end  
end,

}

-- ============================================================
-- JUMP
-- ============================================================
local savedJump = SavedState.controls["player_1"] or {}
local Jump = {
    enabled = savedJump.on or false,
    value = savedJump.value or 50,
    original = 50,
}

local function applyJump()
    local hum = getHumanoid()
    if not hum then return end
    hum.UseJumpPower = true
    hum.JumpPower = Jump.enabled and Jump.value * 2 or Jump.original
end

bind(RunService.Heartbeat, applyJump)

local JumpHandlers = {
    onChange = function(value)
        Jump.value = value
        applyJump()
    end,
    onToggle = function(state)
        local hum = getHumanoid()
        if state then
            if hum then Jump.original = hum.JumpPower end
            Jump.enabled = true
        else
            Jump.enabled = false
        end
        applyJump()
    end,
}

-- ============================================================
-- FLY
-- ============================================================
local FLY_SPEED = 80

local Fly = { enabled = false }

local function stopFly()
    Fly.enabled = false
    local hum = getHumanoid()
    if hum then hum.PlatformStand = false end
end

bind(Players.LocalPlayer.CharacterAdded, function()
    Fly.enabled = false
end)

bind(RunService.Heartbeat, function()
    if not Fly.enabled then return end

    local hum = getHumanoid()
    local root = hum and hum.RootPart
    if not (hum and root) then
        stopFly()
        return
    end

    hum.PlatformStand = true

    local cam = workspace.CurrentCamera
    local look = cam.CFrame.LookVector
    local move = hum.MoveDirection -- плоское направление со стика, уже относительно камеры

    if move.Magnitude > 0.05 then
        local horiz = move.Unit * FLY_SPEED
        local vert = look.Y * FLY_SPEED
        root.AssemblyLinearVelocity = Vector3.new(horiz.X, vert, horiz.Z)
    else
        root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

local FlyHandlers = {
    onToggle = function(state)
        if state then
            Fly.enabled = true
        else
            stopFly()
        end
    end,
}

-- ============================================================
-- KICK COMBO
-- ============================================================
local function teleportToKick()
    local areas = workspace:FindFirstChild("Areas")
    local zone = areas and areas:FindFirstChild("KickReady")
    local char = Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    if not (zone and root) then
        print("[Sakura] KickReady или HumanoidRootPart не найдены")
        return false
    end

    root.CFrame = zone.CFrame + Vector3.new(0, 3, 0)
    return true
end

local KickHandlers
do
    local lp = Players.LocalPlayer
    local active, token = false, 0

    local function isActive(id) return active and token == id end
    local function status(text) print("[Sakura] Kick: " .. text) end

    local function waitFor(id, cond, timeout)
        local t0 = os.clock()
        while isActive(id) do
            if cond() then return true end
            if timeout and os.clock() - t0 > timeout then return false end
            RunService.Heartbeat:Wait()
        end
        return false
    end

    local function getBtn()
        local hud = PlayerGui:FindFirstChild("HUD")
        return hud and hud:FindFirstChild("KickButton")
    end

    local function busy()
        return lp:GetAttribute("LocalKickBusy") == true or lp:GetAttribute("IsKicking") == true
    end

    local function ready()
        local b = getBtn()
        return b ~= nil and b.Visible and not busy()
    end

    local function getParts()
        local char = lp.Character
        return char and char:FindFirstChildOfClass("Humanoid"),
            char and char:FindFirstChild("HumanoidRootPart")
    end

    local function nearZone()
        local _, root = getParts()
        local areas = workspace:FindFirstChild("Areas")
        local zone = areas and areas:FindFirstChild("KickReady")
        return not (zone and root) or (root.Position - zone.Position).Magnitude <= 20
    end

    local function cameraFree()
        local hum = getParts()
        local cam = workspace.CurrentCamera
        return hum ~= nil and cam.CameraSubject == hum and cam.CameraType == Enum.CameraType.Custom
    end

    -- ---------- старт удара: прямой вызов rev_KickEvent с результатом Perfect ----------
    -- сервер сам принимает исход удара от клиента — это ремоут, не тап,
    -- никакого VirtualInputManager/сигналов тут нет вообще
    local KickEvent
    local function getKickEvent()
        if KickEvent then return KickEvent end
        local ok, ev = pcall(function()
            return game:GetService("ReplicatedStorage")
                :WaitForChild("Shared", 5)
                :WaitForChild("Packages", 5)
                :WaitForChild("Network", 5)
                :WaitForChild("rev_KickEvent", 5)
        end)
        if ok then KickEvent = ev end
        return KickEvent
    end

    local function startKick(id, gui)
        local ev = getKickEvent()
        if not ev then
            status("rev_KickEvent не найден")
            return false
        end

        local function started() return busy() or gui.Enabled end
        if not isActive(id) or not ready() then return started() end

        local ok = pcall(function() ev:FireServer(1) end)
        local began = waitFor(id, started, 1.5)
        status(string.format("старт: pcall=%s started=%s", tostring(ok), tostring(began)))
        return began
    end

    -- ---------- ожидание конца цикла и возврат после гачи ----------
    local function waitCycle(id)
        local t0 = os.clock()
        local locked, returned = false, false

        while isActive(id) and busy() do
            local _, root = getParts()
            if root then
                if root.Anchored then locked = true end

                if not returned then
                    local released = locked and not root.Anchored and cameraFree()
                    local timedOut = os.clock() - t0 > 45
                    if released or timedOut then
                        status(released and "гача закончилась, ТП в зону" or "таймаут цикла, ТП в зону")
                        task.wait(0.4)
                        teleportToKick()
                        returned = true
                    end
                end
            end
            RunService.Heartbeat:Wait()
        end
    end

    local function loop(id)
        local gui = PlayerGui:WaitForChild("KickMinigame")

        while isActive(id) do
            if busy() then
                waitCycle(id)
            elseif not nearZone() then
                status("ТП в зону")
                teleportToKick()
                waitFor(id, ready, 3)
            elseif ready() then
                -- удар по полоске (ради Perfect) делай вручную — авто-тап убран,
                -- он и вызывал вылеты игры
                if not startKick(id, gui) then
                    status("не удалось начать удар")
                    waitFor(id, function() return false end, 1)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
    end

    KickHandlers = {
        onToggle = function(state)
            active = state
            token += 1
            if state then
                task.spawn(loop, token)
            end
        end,
    }
end

-- ============================================================
-- ФЕРМА: DAILY QUEST / AUTO COLLECT / AUTO UPGRADE
-- ============================================================
local Network

local function getNetwork()
    if Network then return Network end
    local ok, n = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Shared", 5)
            :WaitForChild("Packages", 5)
            :WaitForChild("Network", 5)
    end)
    if ok then Network = n end
    return Network
end

-- общий каркас для тумблеров вида "пока включено — повторять действие"
local function makeLoopToggle(label, action, interval)
    local active, token = false, 0
    return {
        onToggle = function(state)
            active = state
            token = token + 1
            local id = token
            if state then
                task.spawn(function()
                    while active and token == id do
                        local ok, err = pcall(action)
                        if not ok then
                            print("[Sakura] " .. label .. " error: " .. tostring(err))
                        end
                        task.wait(interval)
                    end
                end)
            end
        end,
    }
end

-- открывает и пытается забрать ежедневный квест. Известен только один
-- вариант награды ("Lifts") — если квестов несколько разных, пришли их
-- названия, добавлю перебор по списку
local DailyQuestHandlers = makeLoopToggle("Auto Collect Quest", function()
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_DailyQuests_Request", 5):FireServer()
    task.wait(0.3)
    net:WaitForChild("rev_DailyQuests_Claim", 5):FireServer("Lifts")
end, 30)

-- перебирает слоты сбора 1-30
local findOwnedPlot
local teleportToOwnedPlot

local AutoCollectHandlers = makeLoopToggle("Auto Collect Cash", function()
    local net = getNetwork()
    if not net then return end
    teleportToOwnedPlot()
    task.wait(0.2)
    local ev = net:WaitForChild("rev_B_Collect", 5)
    local plot = findOwnedPlot()
    local plotName = plot and string.match(plot.Name, "%d+")
    if plotName then ev:FireServer(tonumber(plotName)) end
end, 3)

-- повторяет апгрейд с аргументом 8 (тем же, что был в примере)
local AutoUpgradeHandlers = makeLoopToggle("Auto Upgrade", function()
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_B_Upgrade", 5):FireServer(8)
end, 1)

local AutoTrainingHandlers = makeLoopToggle("Auto Training Weight", function()
    local player = Players.LocalPlayer
    local inventory = player:FindFirstChild("Inventory") or player:FindFirstChild("Backpack")
    local firstItem = inventory and inventory:GetChildren()[1]
    if firstItem and player.Character then
        firstItem.Parent = player.Character
    end
    local net = getNetwork()
    if net then net:WaitForChild("rev_TaviMishkal", 5):FireServer() end
    Players.LocalPlayer:WaitForChild("ClientLoader")
end, 1)

local SpeedUpgradeAmount = 1

local SpeedUpgradeHandlers = makeLoopToggle("Speed Upgrade", function()
    local net = getNetwork()
    if net then net:WaitForChild("rev_SPEED_UPGRADE", 5):FireServer(SpeedUpgradeAmount) end
    Players.LocalPlayer:WaitForChild("ClientLoader")
end, 1)

local SellAllHandlers = makeLoopToggle("Sell All Umas", function()
    local net = getNetwork()
    if net then net:WaitForChild("ref_B_SellAll", 5):InvokeServer() end
    local prompt = workspace:WaitForChild("NPCs", 5)
        :WaitForChild("SellUma", 5)
        :WaitForChild("ProximityPart", 5)
        :WaitForChild("ProximityPrompt", 5)
        :WaitForChild("Script", 5)
end, 2)

local OfflineClaimHandlers = makeLoopToggle("Auto Offline Claim", function()
    local net = getNetwork()
    if net then net:WaitForChild("rev_Offline_Claim", 5):FireServer() end
    Players.LocalPlayer:WaitForChild("ClientLoader")
end, 5)

local function getPlayerRoot()
    local char = Players.LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function teleportToCFrame(cframe)
    local root = getPlayerRoot()
    if root then root.CFrame = cframe + Vector3.new(0, 3, 0) end
end

findOwnedPlot = function()
    local player = Players.LocalPlayer
    for index = 1, 30 do
        local plot = workspace:FindFirstChild("plot" .. index, true)
        if plot then
            for _, object in ipairs(plot:GetDescendants()) do
                if object:IsA("ObjectValue") and object.Value == player then return plot end
                if object:IsA("StringValue") and object.Value == player.Name then return plot end
            end
            if plot:GetAttribute("Owner") == player.Name or plot:GetAttribute("OwnerUserId") == player.UserId then
                return plot
            end
        end
    end
end

teleportToOwnedPlot = function()
    local plot = findOwnedPlot()
    if plot then teleportToCFrame(plot:GetPivot()) end
end

local function teleportToNamedObject(names)
    for _, name in ipairs(names) do
        local object = workspace:FindFirstChild(name, true)
        if object then
            teleportToCFrame(object:IsA("BasePart") and object.CFrame or object:GetPivot())
            return
        end
    end
end

local function sellHeldUma()
    local net = getNetwork()
    if net then
        pcall(function() net:WaitForChild("ref_B_SellUma", 5):InvokeServer() end)
    end
end

local PowerUpgradeAmount = 1

local function applyMusic(assetId)
    if not assetId or assetId == "" then return end
    for _, object in ipairs(game:GetDescendants()) do
        if object:IsA("Sound") then object.SoundId = assetId end
    end
end

-- ============================================================
-- ТАБЫ
-- ============================================================
local TABS = {
{
id = "home",
name = "Home",
funcs = {
{ type = "stats" },
}
},
{
id = "player",
name = "Player",
funcs = {
{
title = "Jump",
desc = "Сила прыжка 1-100",
type = "slider",
handlers = JumpHandlers
},
{
title = "Fly",
desc = "Полёт по направлению камеры",
handlers = FlyHandlers
},
{
title = "Speed",
desc = "Скорость передвижения 1-100",
type = "slider",
handlers = SpeedHandlers
},
{
title = "Число",
desc = "Ввод значения",
type = "input"
},
{
title = "Select Speed Upgrade Amount",
desc = "Количество улучшений",
type = "select",
options = {1, 2, 3, 4, 5, 10},
default = 1,
onSelect = function(value) SpeedUpgradeAmount = value end,
},
{
title = "Select Power Upgrade Amount",
desc = "Количество улучшений",
type = "select",
options = {1, 2, 3, 4, 5, 10},
default = 1,
onSelect = function(value) PowerUpgradeAmount = value end,
},
{
title = "Sell Uma",
desc = "Продать уму в руках",
type = "action",
action = sellHeldUma,
},
}
},

{  
    id = "farm",  
    name = "Auto Features",  
    funcs = {  
        {  
            title = "Auto Kick",  
            desc = "ТП в зону Kick, затем авто-удар",  
            handlers = KickHandlers  
        },  
        {  
            title = "Auto Collect Quest",  
            desc = "Открыть и забрать ежедневный квест",  
            handlers = DailyQuestHandlers  
        },  
        {  
            title = "Auto Collect Cash",  
            desc = "Сбор слотов 1-30 по кругу",  
            handlers = AutoCollectHandlers  
        },  
        {  
            title = "Auto Training Weight",  
            desc = "Автоматическая тренировка веса",  
            handlers = AutoTrainingHandlers  
        },
        {
            title = "Speed Upgrade",
            desc = "Автоматическое улучшение скорости",
            handlers = SpeedUpgradeHandlers
        },
        {
            title = "Sell All Umas",
            desc = "Продать всех ум",
            handlers = SellAllHandlers
        },
        {
            title = "Auto Offline Claim",
            desc = "Забрать офлайн-награду",
            handlers = OfflineClaimHandlers
        },  
    }  
},  

{  
    id = "misc",  
    name = "Misc",  
    funcs = {  
        {  
            title = "Set Music",
            desc = "Заменить музыку",
            type = "textInput",
            placeholder = "rbxassetid://107406485711525",
            onSave = applyMusic,
        },  
    }  
},  

{
    id = "teleport",
    name = "Teleport",
    funcs = {
        { title = "Teleport To Base", desc = "", type = "action", action = teleportToOwnedPlot },
        { title = "Teleport to Sell", desc = "", type = "action", action = function()
            teleportToNamedObject({"SellUma", "Seller", "Sell"})
        end },
        { title = "Teleport to Kick Station", desc = "", type = "action", action = teleportToKick },
        { title = "Teleport to Shop", desc = "", type = "action", action = function()
            teleportToNamedObject({"Shop", "ShopGuy", "Shop Guy"})
        end },
    },
},

{  
    id = "settings",  
    name = "Settings",  
    funcs = {}  
},

}

local pages = {}
local tabButtons = {}

local sidebarCollapsed = false
local activeTab = TABS[1].id

if PlayerGui:FindFirstChild(
"SakuraMenu"
) then
PlayerGui.SakuraMenu:Destroy()
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "SakuraMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior =
Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

local MainFrame = newFrame({
Name = "MainFrame",

AnchorPoint =  
    Vector2.new(0.5, 0.5),  

Position =  
    UDim2.fromScale(0.5, 0.5),  

Size =  
    UDim2.fromScale(  
        CONFIG.WidthScale,  
        CONFIG.HeightScale  
    ),  

BackgroundColor3 =  
    CONFIG.BgColor,  

BackgroundTransparency =  
    CONFIG.Transparency,  

ClipsDescendants = true,

}, ScreenGui)

corner(16, MainFrame)

stroke(
MainFrame,
CONFIG.AccentColor,
0.88,
1
)

-- ============================================================
-- TOP BAR
-- ============================================================
local TopBar = newFrame({
Name = "TopBar",
Size = UDim2.new(1, 0, 0, 52),
BackgroundTransparency = 1,
}, MainFrame)

local logoHolder = newFrame({
Size = UDim2.fromOffset(26, 26),
Position = UDim2.new(0, 16, 0.5, 0),
AnchorPoint = Vector2.new(0, 0.5),
BackgroundTransparency = 1,
}, TopBar)

local logoIcon =
drawIcon(
"logo",
logoHolder,
26
)

for _, part in ipairs(
logoIcon:GetChildren()
) do

if part:IsA("Frame") then  
    attachShimmer(  
        part,  
        Color3.fromRGB(190, 190, 198),  
        Color3.fromRGB(255, 255, 255),  
        2.2  
    )  
end

end

bind(
RunService.RenderStepped,
function(dt)
logoIcon.Rotation =
(logoIcon.Rotation +
dt * 14) % 360
end
)

local sakuraLabel = newLabel({
Text = "Sakura",
Position = UDim2.new(0, 52, 0, 0),
Size = UDim2.new(0, 150, 1, 0),
TextXAlignment = Enum.TextXAlignment.Left,
Font = Enum.Font.GothamBold,
TextSize = 18,
TextColor3 = CONFIG.SakuraPink,
}, TopBar)

attachShimmer(
sakuraLabel,
CONFIG.SakuraPink,
Color3.fromRGB(190, 45, 95),
2.6
)

local btnClose = newButton({
Name = "CloseBtn",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -16, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = CONFIG.CardColor,
}, TopBar)

corner(8, btnClose)

drawCross(
btnClose,
12,
CONFIG.CloseColor,
45,
-45
)

local btnMinimize = newButton({
Name = "MinimizeBtn",
Size = UDim2.fromOffset(30, 30),
Position = UDim2.new(1, -54, 0.5, 0),
AnchorPoint = Vector2.new(1, 0.5),
BackgroundColor3 = CONFIG.CardColor,
}, TopBar)

corner(8, btnMinimize)

drawCross(
btnMinimize,
12,
CONFIG.AccentColor,
0,
nil
)

newFrame({
Size = UDim2.new(1, 0, 0, 1),
Position = UDim2.new(0, 0, 1, 0),
BackgroundColor3 = CONFIG.AccentColor,
BackgroundTransparency = 0.9,
}, TopBar)

-- ============================================================
-- ПЕРЕТАСКИВАНИЕ
-- ============================================================
do
local dragging = false
local dragStart
local startPos

TopBar.Active = true  

TopBar.InputBegan:Connect(  
    function(input)  

        if input.UserInputType ==  
            Enum.UserInputType.MouseButton1  
            or input.UserInputType ==  
            Enum.UserInputType.Touch then  

            dragging = true  
            dragStart = input.Position  
            startPos = MainFrame.Position  
        end  
    end  
)  

bind(  
    UserInputService.InputChanged,  
    function(input)  

        if dragging and (  
            input.UserInputType ==  
                Enum.UserInputType.MouseMovement  
            or input.UserInputType ==  
                Enum.UserInputType.Touch  
        ) then  

            local delta =  
                input.Position -  
                dragStart  

            MainFrame.Position =  
                UDim2.new(  
                    startPos.X.Scale,  
                    startPos.X.Offset +  
                        delta.X,  

                    startPos.Y.Scale,  
                    startPos.Y.Offset +  
                        delta.Y  
                )  
        end  
    end  
)  

bind(  
    UserInputService.InputEnded,  
    function(input)  

        if input.UserInputType ==  
            Enum.UserInputType.MouseButton1  
            or input.UserInputType ==  
            Enum.UserInputType.Touch then  

            dragging = false  
        end  
    end  
)

end

-- ============================================================
-- BODY
-- ============================================================
local Body = newFrame({
Name = "Body",
Size = UDim2.new(1, 0, 1, -52),
Position = UDim2.new(0, 0, 0, 52),
BackgroundTransparency = 1,
}, MainFrame)

local Sidebar = newFrame({
Name = "Sidebar",
Size = UDim2.new(
0,
CONFIG.SidebarExpanded,
1,
0
),
BackgroundTransparency = 1,
}, Body)

newFrame({
Size = UDim2.new(0, 1, 1, 0),
Position = UDim2.new(1, 0, 0, 0),
BackgroundColor3 = CONFIG.AccentColor,
BackgroundTransparency = 0.9,
}, Sidebar)

local TAB_ROW_H = 40
local TAB_GAP = 4
local FOOTER_H = 48

local tabListHeight =
(#TABS * TAB_ROW_H) +
((#TABS - 1) * TAB_GAP)

local TabScroll =
Instance.new("ScrollingFrame")

TabScroll.Name = "TabScroll"

TabScroll.Size =
UDim2.new(
1,
0,
1,
-FOOTER_H
)

TabScroll.BackgroundTransparency = 1
TabScroll.BorderSizePixel = 0
TabScroll.ScrollBarThickness = 3
TabScroll.ScrollBarImageColor3 =
CONFIG.AccentColor
TabScroll.ScrollBarImageTransparency = 0.6

TabScroll.CanvasSize =
UDim2.new(
0,
0,
0,
tabListHeight + 16
)

TabScroll.Parent = Sidebar

local TabList = newFrame({
Name = "TabList",

Size =  
    UDim2.new(  
        1,  
        -8,  
        0,  
        tabListHeight  
    ),  

Position =  
    UDim2.new(0, 4, 0, 8),  

BackgroundTransparency = 1,

}, TabScroll)

local Selector = newFrame({
Name = "Selector",
Size = UDim2.new(1, 0, 0, TAB_ROW_H),
BackgroundColor3 = CONFIG.CardColor,
ZIndex = 0,
}, TabList)

corner(8, Selector)

local SidebarFooter = newFrame({
Name = "SidebarFooter",

Size =  
    UDim2.new(  
        1,  
        0,  
        0,  
        FOOTER_H  
    ),  

Position =  
    UDim2.new(  
        0,  
        0,  
        1,  
        0  
    ),  

AnchorPoint =  
    Vector2.new(0, 1),  

BackgroundTransparency = 1,

}, Sidebar)

newFrame({
Size = UDim2.new(1, 0, 0, 1),
BackgroundColor3 = CONFIG.AccentColor,
BackgroundTransparency = 0.9,
}, SidebarFooter)

local ContentArea = newFrame({
Name = "ContentArea",

Size =  
    UDim2.new(  
        1,  
        -CONFIG.SidebarExpanded,  
        1,  
        0  
    ),  

Position =  
    UDim2.new(  
        0,  
        CONFIG.SidebarExpanded,  
        0,  
        0  
    ),  

BackgroundTransparency = 1,

}, Body)

-- ============================================================
-- TABS
-- ============================================================
for i, tab in ipairs(TABS) do

local yPos =  
    (i - 1) *  
    (TAB_ROW_H + TAB_GAP)  

local btn = newButton({  
    Name = tab.id,  

    Size =  
        UDim2.new(  
            1,  
            0,  
            0,  
            TAB_ROW_H  
        ),  

    Position =  
        UDim2.new(  
            0,  
            0,  
            0,  
            yPos  
        ),  

    ZIndex = 2,  
}, TabList)  

local iconHold = newFrame({  
    Size = UDim2.fromOffset(18, 18),  

    Position =  
        UDim2.new(  
            0,  
            14,  
            0.5,  
            0  
        ),  

    AnchorPoint =  
        Vector2.new(0, 0.5),  

    BackgroundTransparency = 1,  
}, btn)  

drawIcon(  
    tab.id,  
    iconHold,  
    18  
)  

local label = newLabel({  
    Name = "Label",  
    Text = tab.name,  

    Position =  
        UDim2.new(  
            0,  
            42,  
            0,  
            0  
        ),  

    Size =  
        UDim2.new(  
            1,  
            -50,  
            1,  
            0  
        ),  

    TextXAlignment =  
        Enum.TextXAlignment.Left,  

    TextSize = 14,  
}, btn)  

tabButtons[tab.id] = {  
    button = btn,  
    label = label  
}  

local page =  
    Instance.new("ScrollingFrame")  

page.Name =  
    tab.id .. "Page"  

page.Size =  
    UDim2.new(  
        1,  
        -32,  
        1,  
        -24  
    )  

page.Position =  
    UDim2.new(  
        0,  
        16,  
        0,  
        16  
    )  

page.BackgroundTransparency = 1  
page.BorderSizePixel = 0  
page.ScrollBarThickness = 3  
page.ScrollBarImageColor3 =  
    CONFIG.AccentColor  
page.ScrollBarImageTransparency = 0.6  
page.CanvasSize =  
    UDim2.new(0, 0, 0, 0)  
page.AutomaticCanvasSize =  
    Enum.AutomaticSize.Y  
page.Visible =  
    (tab.id == activeTab)  

page.Parent = ContentArea  

local pageLayout =  
    Instance.new("UIListLayout")  

pageLayout.Padding =  
    UDim.new(0, 8)  

pageLayout.SortOrder =  
    Enum.SortOrder.LayoutOrder  

pageLayout.Parent = page  

local pagePad =  
    Instance.new("UIPadding")  

pagePad.PaddingLeft =  
    UDim.new(0, 2)  

pagePad.PaddingRight =  
    UDim.new(0, 8)  

pagePad.PaddingTop =  
    UDim.new(0, 2)  

pagePad.PaddingBottom =  
    UDim.new(0, 4)  

pagePad.Parent = page  

newLabel({  
    Text = tab.name,  
    Size = UDim2.new(1, 0, 0, 26),  
    TextXAlignment =  
        Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 20,  
    LayoutOrder = 0,  
}, page)  

if tab.id == "settings" then  

    local sT =  
        SavedState.controls[  
            "settings_transparency"  
        ]  

    local sS =  
        SavedState.controls[  
            "settings_size"  
        ]  

    createPercentRow(  
        page,  
        "Прозрачность",  
        {50, 60, 70, 80, 90, 100},  
        (sT and sT.value) or 50,  
        function(val)  

            CONFIG.Transparency =  
                1 - (val / 100)  

            MainFrame.BackgroundTransparency =  
                CONFIG.Transparency  

            SavedState.controls[  
                "settings_transparency"  
            ] = {  
                value = val  
            }  

            SaveConfig()  
        end  
    ).LayoutOrder = 1  

    createPercentRow(  
        page,  
        "Размер окна",  
        {50, 60, 70, 80, 90, 100},  
        (sS and sS.value) or 100,  
        function(val)  

            CONFIG.WidthScale =  
                BASE_WIDTH_SCALE *  
                (val / 100)  

            CONFIG.HeightScale =  
                BASE_HEIGHT_SCALE *  
                (val / 100)  

            tween(  
                MainFrame,  
                0.2,  
                {  
                    Size =  
                        UDim2.fromScale(  
                            CONFIG.WidthScale,  
                            CONFIG.HeightScale  
                        ),  
                }  
            )  

            SavedState.controls[  
                "settings_size"  
            ] = {  
                value = val  
            }  

            SaveConfig()  
        end  
    ).LayoutOrder = 2  

elseif tab.id == "home" then
    local player = Players.LocalPlayer
    local stats = newFrame({
        Size = UDim2.new(1, 0, 0, 210),
        BackgroundColor3 = CONFIG.CardColor,
    }, page)
    corner(8, stats)
    stroke(stats, CONFIG.AccentColor, 0.9, 1)
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(64, 64)
    avatar.Position = UDim2.fromOffset(18, 18)
    avatar.BackgroundTransparency = 1
    avatar.Parent = stats
    corner(32, avatar)
    task.spawn(function()
        local ok, image = pcall(function()
            return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok then avatar.Image = image end
    end)
    newLabel({
        Text = player.DisplayName,
        Position = UDim2.fromOffset(96, 22),
        Size = UDim2.new(1, -112, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
    }, stats)
    local username = newLabel({
        Text = "@" .. player.Name,
        Position = UDim2.fromOffset(96, 48),
        Size = UDim2.new(1, -112, 0, 18),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = CONFIG.MutedTextColor,
        TextSize = 12,
    }, stats)
    local values = {}
    for index, name in ipairs({"Cash", "Kick Power", "Speed", "Jump", "Rebirths"}) do
        values[name] = newLabel({
            Text = name .. ": -",
            Position = UDim2.new(0, 18, 0, 92 + (index - 1) * 21),
            Size = UDim2.new(1, -36, 0, 18),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 12,
        }, stats)
    end
    local function readValue(name)
        local leaderstats = player:FindFirstChild("leaderstats")
        local value = leaderstats and leaderstats:FindFirstChild(name)
        return value and value.Value or player:GetAttribute(name) or "-"
    end
    local function updateStats()
        for name, label in pairs(values) do
            label.Text = name .. ": " .. tostring(readValue(name))
        end
    end
    updateStats()
    task.spawn(function()
        while stats.Parent do
            updateStats()
            task.wait(1)
        end
    end)

else  

    for fIndex, f in ipairs(  
        tab.funcs  
    ) do  

        local key =  
            tab.id .. "_" ..  
            fIndex  

        local card  

        if f.type == "slider" then  

            card =  
                createSliderCard(  
                    page,  
                    f.title,  
                    f.desc,  
                    key,  
                    f.handlers  
                )  

        elseif f.type == "input" then  

            card =  
                createInputCard(  
                    page,  
                    f.title,  
                    f.desc,  
                    key  
                )  

        elseif f.type == "textInput" then
            card = createTextInputCard(page, f.title, f.desc, key, f.placeholder, f.onSave)
        elseif f.type == "select" then
            card = newFrame({
                Size = UDim2.new(1, 0, 0, 44),
                BackgroundTransparency = 1,
            }, page)
            createPercentRow(card, f.title, f.options, f.default, f.onSelect, "")
        elseif f.type == "action" then
            card = createActionCard(page, f.title, f.desc, key, f.action)
        else  

            card =  
                createFunctionCard(  
                    page,  
                    f.title,  
                    f.desc,  
                    tab.name,  
                    key,  
                    f.handlers  
                )  
        end  

        card.LayoutOrder =  
            fIndex  
    end  
end  

pages[tab.id] = page  

btn.MouseButton1Click:Connect(  
    function()  

        if activeTab == tab.id then  
            return  
        end  

        activeTab = tab.id  

        for id, p in pairs(pages) do  
            p.Visible =  
                (id == activeTab)  
        end  

        tween(  
            Selector,  
            0.22,  
            {  
                Position =  
                    UDim2.new(  
                        0,  
                        0,  
                        0,  
                        yPos  
                    )  
            }  
        )  
    end  
)

end

-- ============================================================
-- СВОРАЧИВАНИЕ SIDEBAR
-- ============================================================
local collapseBtn = newButton({
Size =
UDim2.new(
1,
-8,
1,
-8
),

Position =  
    UDim2.new(  
        0,  
        4,  
        0,  
        4  
    ),  

BackgroundColor3 =  
    CONFIG.CardColor,

}, SidebarFooter)

corner(8, collapseBtn)

local collapseIconHold = newFrame({
Size = UDim2.fromOffset(20, 20),

Position =  
    UDim2.fromScale(  
        0.5,  
        0.5  
    ),  

AnchorPoint =  
    Vector2.new(0.5, 0.5),  

BackgroundTransparency = 1,

}, collapseBtn)

local collapseIcon =
drawIcon(
"collapse",
collapseIconHold,
20
)

collapseBtn.MouseButton1Click:Connect(
function()

sidebarCollapsed =  
        not sidebarCollapsed  

    local w =  
        sidebarCollapsed  
        and CONFIG.SidebarCollapsed  
        or CONFIG.SidebarExpanded  

    tween(  
        Sidebar,  
        CONFIG.AnimTime,  
        {  
            Size =  
                UDim2.new(  
                    0,  
                    w,  
                    1,  
                    0  
                )  
        }  
    )  

    tween(  
        ContentArea,  
        CONFIG.AnimTime,  
        {  
            Size =  
                UDim2.new(  
                    1,  
                    -w,  
                    1,  
                    0  
                ),  

            Position =  
                UDim2.new(  
                    0,  
                    w,  
                    0,  
                    0  
                ),  
        }  
    )  

    for _, entry in pairs(  
        tabButtons  
    ) do  

        tween(  
            entry.label,  
            CONFIG.AnimTime,  
            {  
                TextTransparency =  
                    sidebarCollapsed  
                    and 1  
                    or 0  
            }  
        )  
    end  

    tween(  
        collapseIcon,  
        CONFIG.AnimTime,  
        {  
            Rotation =  
                sidebarCollapsed  
                and 180  
                or 0  
        }  
    )  
end

)

-- ============================================================
-- FLOATING BUTTON
-- ============================================================
local FLOAT_SIZE = 46

local FloatBtn = newButton({
Name = "FloatButton",

AnchorPoint =  
    Vector2.new(0.5, 0.5),  

Size =  
    UDim2.fromOffset(  
        FLOAT_SIZE,  
        FLOAT_SIZE  
    ),  

Position =  
    UDim2.fromOffset(  
        70,  
        230  
    ),  

BackgroundColor3 =  
    Color3.fromRGB(8, 8, 10),  

BackgroundTransparency = 0,  

Visible = false,  

ZIndex = 2,

}, ScreenGui)

corner(
FLOAT_SIZE,
FloatBtn
)

stroke(
FloatBtn,
CONFIG.SakuraPink,
0.35,
2
)

newLabel({
Text = "S",
Size = UDim2.fromScale(1, 1),
Font = Enum.Font.GothamBlack,
TextSize = 20,
TextColor3 = CONFIG.SakuraPink,
ZIndex = 3,
}, FloatBtn)

do
local dragging = false
local moved = false
local dragStart
local startPos

FloatBtn.InputBegan:Connect(  
    function(input)  

        if input.UserInputType ==  
            Enum.UserInputType.MouseButton1  
            or input.UserInputType ==  
            Enum.UserInputType.Touch then  

            dragging = true  
            moved = false  
            dragStart = input.Position  
            startPos = FloatBtn.Position  
        end  
    end  
)  

bind(  
    UserInputService.InputChanged,  
    function(input)  

        if dragging and (  
            input.UserInputType ==  
                Enum.UserInputType.MouseMovement  
            or input.UserInputType ==  
                Enum.UserInputType.Touch  
        ) then  

            local delta =  
                input.Position -  
                dragStart  

            if delta.Magnitude > 4 then  
                moved = true  
            end  

            FloatBtn.Position =  
                UDim2.new(  
                    startPos.X.Scale,  
                    startPos.X.Offset +  
                        delta.X,  

                    startPos.Y.Scale,  
                    startPos.Y.Offset +  
                        delta.Y  
                )  
        end  
    end  
)  

bind(  
    UserInputService.InputEnded,  
    function(input)  

        if input.UserInputType ==  
            Enum.UserInputType.MouseButton1  
            or input.UserInputType ==  
            Enum.UserInputType.Touch then  

            dragging = false  
        end  
    end  
)  

FloatBtn.MouseButton1Click:Connect(  
    function()  

        if moved then  
            return  
        end  

        FloatBtn.Visible = false  
        MainFrame.Visible = true  

        MainFrame.Size =  
            UDim2.fromScale(0, 0)  

        MainFrame.BackgroundTransparency = 1  

        tween(  
            MainFrame,  
            CONFIG.AnimTime,  
            {  
                Size =  
                    UDim2.fromScale(  
                        CONFIG.WidthScale,  
                        CONFIG.HeightScale  
                    ),  

                BackgroundTransparency =  
                    CONFIG.Transparency,  
            },  
            Enum.EasingStyle.Back  
        )  
    end  
)

end

-- ============================================================
-- MINIMIZE / CLOSE
-- ============================================================
btnMinimize.MouseButton1Click:Connect(
function()

local t =  
        tween(  
            MainFrame,  
            CONFIG.AnimTime,  
            {  
                Size =  
                    UDim2.fromScale(  
                        0,  
                        0  
                    ),  

                BackgroundTransparency = 1,  
            },  
            Enum.EasingStyle.Back,  
            Enum.EasingDirection.In  
        )  

    t.Completed:Connect(  
        function()  

            MainFrame.Visible = false  
            FloatBtn.Visible = true  
        end  
    )  
end

)

btnClose.MouseButton1Click:Connect(
function()

SpeedHandlers.onToggle(false)  
    KickHandlers.onToggle(false)

    for _, c in ipairs(  
        connections  
    ) do  
        c:Disconnect()  
    end  

    table.clear(connections)  

    ScreenGui:Destroy()  
end

)

-- ============================================================
-- ЗАПУСК
-- ============================================================
MainFrame.Size =
UDim2.fromScale(0, 0)

MainFrame.BackgroundTransparency = 1

tween(
MainFrame,
CONFIG.AnimTime,
{
Size =
UDim2.fromScale(
CONFIG.WidthScale,
CONFIG.HeightScale
),

BackgroundTransparency =  
        CONFIG.Transparency,  
},  
Enum.EasingStyle.Back

)
