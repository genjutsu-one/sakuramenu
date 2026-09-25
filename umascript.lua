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

elseif kind == "home" then  
    newFrame({
        Size = UDim2.fromOffset(size * 0.48, 2),
        Position = UDim2.fromScale(0.35, 0.34),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = -45,
        BackgroundColor3 = W,
    }, holder)

    newFrame({
        Size = UDim2.fromOffset(size * 0.48, 2),
        Position = UDim2.fromScale(0.65, 0.34),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = 45,
        BackgroundColor3 = W,
    }, holder)

    corner(2, newFrame({  
        Size = UDim2.fromOffset(size * 0.58, size * 0.4),
        Position = UDim2.fromScale(0.5, 0.63),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = W,  
    }, holder))  

    corner(2, newFrame({  
        Size = UDim2.fromOffset(size * 0.15, size * 0.22),
        Position = UDim2.new(0.5, 0, 1, 0),  
        AnchorPoint = Vector2.new(0.5, 1),  
        BackgroundColor3 = CONFIG.BgColor,  
    }, holder))  

elseif kind == "teleport" then  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.6, size * 0.6),  
        Position = UDim2.new(0.5, 0, 0.36, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        BackgroundColor3 = W,  
    }, holder))  

    corner(3, newFrame({  
        Size = UDim2.fromOffset(size * 0.34, size * 0.34),  
        Position = UDim2.new(0.5, 0, 0.62, 0),  
        AnchorPoint = Vector2.new(0.5, 0.5),  
        Rotation = 45,  
        BackgroundColor3 = W,  
    }, holder))  

    corner(size, newFrame({  
        Size = UDim2.fromOffset(size * 0.24, size * 0.24),  
        Position = UDim2.new(0.5, 0, 0.36, 0),  
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

local function drawChevronRight(parent, size, color)
local holder = iconHolder(parent, size)

corner(size, newFrame({  
    Size = UDim2.fromOffset(size * 0.55, size * 0.16),  
    Position = UDim2.new(0.5, 0, 0.5, -size * 0.18),  
    AnchorPoint = Vector2.new(0.5, 0.5),  
    Rotation = 45,  
    BackgroundColor3 = color,  
}, holder))  

corner(size, newFrame({  
    Size = UDim2.fromOffset(size * 0.55, size * 0.16),  
    Position = UDim2.new(0.5, 0, 0.5, size * 0.18),  
    AnchorPoint = Vector2.new(0.5, 0.5),  
    Rotation = -45,  
    BackgroundColor3 = color,  
}, holder))  

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
    Position = UDim2.new(0, 14, 0, 16),  
    Size = UDim2.new(1, -72, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
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

-- ============================================================
-- ACTION CARD (плашка-кнопка со стрелочкой, без тумблера)
-- ============================================================
local function createActionCard(parent, title, desc, onClick)
local card = newFrame({
Name = "ActionCard",
Size = UDim2.new(1, 0, 0, CARD_H),
BackgroundColor3 = CONFIG.CardColor,
}, parent)
corner(8, card)
stroke(card, CONFIG.AccentColor, 0.9, 1)

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 16),  
    Size = UDim2.new(1, -48, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

local chevronHold = newFrame({  
    Size = UDim2.fromOffset(18, 18),  
    Position = UDim2.new(1, -14, 0.5, 0),  
    AnchorPoint = Vector2.new(1, 0.5),  
    BackgroundTransparency = 1,  
}, card)  
drawChevronRight(chevronHold, 14, CONFIG.MutedTextColor)  

local hit = newButton({ Size = UDim2.fromScale(1, 1), ZIndex = 5 }, card)  
hit.MouseButton1Click:Connect(function()  
    if onClick then onClick() end  
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
-- общая логика применения музыки (id -> rbxassetid://, замена всех
-- играющих звуков), используется и Set Music, и Find Music
local function applyMusicId(rawId)
local id = tostring(rawId):match("rbxassetid://(%d+)") or tostring(rawId):match("(%d+)")
if not id then
    print("[Sakura] Set Music: некорректный ID")
    return nil, 0
end
id = "rbxassetid://" .. id

local applied = 0
for _, s in ipairs(game:GetService("SoundService"):GetDescendants()) do
if s:IsA("Sound") and s.Playing then
s.SoundId = id
s:Play()
applied = applied + 1
end
end

if applied == 0 then
for _, s in ipairs(workspace:GetDescendants()) do
if s:IsA("Sound") and s.Playing then
s.SoundId = id
s:Play()
applied = applied + 1
end
end
end

print(("[Sakura] Set Music: %s (заменено звуков: %d)"):format(id, applied))
return id, applied
end

local function createMusicCard(parent, title, desc, key)
local saved = SavedState.controls[key] or {}

local card = newFrame({
Name = "MusicCard",
Size = UDim2.new(1, 0, 0, CARD_H),
BackgroundColor3 = CONFIG.CardColor,
}, parent)
corner(8, card)
stroke(card, CONFIG.AccentColor, 0.9, 1)

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 0),  
    Size = UDim2.new(1, -164, 1, 0),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

local box = Instance.new("TextBox")  
box.Name = "MusicId"  
box.Size = UDim2.fromOffset(64, 26)  
box.Position = UDim2.new(1, -76, 0.5, 0)  
box.AnchorPoint = Vector2.new(1, 0.5)  
box.BackgroundColor3 = CONFIG.BgColor  
box.TextColor3 = CONFIG.AccentColor  
box.PlaceholderText = "ID"  
box.PlaceholderColor3 = CONFIG.MutedTextColor  
box.Font = Enum.Font.GothamMedium  
box.TextSize = 13  
box.ClearTextOnFocus = false  
box.Text = tostring(saved.text or ""):match("(%d+)") or ""  
box.Parent = card  
corner(6, box)  
stroke(box, CONFIG.AccentColor, 0.85, 1)  

local setButton = newButton({
    Name = "ApplyMusic",
    Size = UDim2.fromOffset(54, 26),
    Position = UDim2.new(1, -14, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = CONFIG.OffColor,
}, card)
corner(6, setButton)
newLabel({ Text = "Set", Size = UDim2.fromScale(1, 1), TextSize = 12 }, setButton)
setButton.MouseButton1Click:Connect(function()
    local digits = box.Text:match("(%d+)")
    if not digits then return end
    local id = applyMusicId(digits)
    if id then
        box.Text = digits
        saveField(key, "text", digits)
    end
end)

return card

end

-- ============================================================
-- MUSIC SEARCH (поиск по названию через Creator Store API Roblox)
-- ============================================================
local function createMusicSearchCard(parent, title, desc, key)
return createCard(parent, title, desc, key, {
expandedH = 260,

build = function(panel, saved)  
        local box = Instance.new("TextBox")  
        box.Name = "Query"  
        box.Size = UDim2.new(1, 0, 0, 30)  
        box.BackgroundColor3 = CONFIG.BgColor  
        box.TextColor3 = CONFIG.AccentColor  
        box.PlaceholderText = "Название трека..."  
        box.PlaceholderColor3 = CONFIG.MutedTextColor  
        box.Font = Enum.Font.GothamMedium  
        box.TextSize = 13  
        box.ClearTextOnFocus = false  
        box.Parent = panel  
        corner(6, box)  
        stroke(box, CONFIG.AccentColor, 0.85, 1)  

        local status = newLabel({  
            Text = "",  
            Position = UDim2.new(0, 0, 0, 34),  
            Size = UDim2.new(1, 0, 0, 14),  
            TextColor3 = CONFIG.MutedTextColor,  
            TextXAlignment = Enum.TextXAlignment.Left,  
            TextSize = 11,  
        }, panel)  

        local results = Instance.new("ScrollingFrame")  
        results.Name = "Results"  
        results.Position = UDim2.new(0, 0, 0, 52)  
        results.Size = UDim2.new(1, 0, 1, -52)  
        results.BackgroundTransparency = 1  
        results.BorderSizePixel = 0  
        results.ScrollBarThickness = 3  
        results.ScrollBarImageColor3 = CONFIG.AccentColor  
        results.CanvasSize = UDim2.new(0, 0, 0, 0)  
        results.AutomaticCanvasSize = Enum.AutomaticSize.Y  
        results.Parent = panel  

        local layout = Instance.new("UIListLayout")  
        layout.Padding = UDim.new(0, 6)  
        layout.Parent = results  

        local function clearResults()  
            for _, c in ipairs(results:GetChildren()) do  
                if c:IsA("GuiObject") then c:Destroy() end  
            end  
        end  

        local function addResult(name, id)  
            local row = newFrame({  
                Size = UDim2.new(1, 0, 0, 34),  
                BackgroundColor3 = CONFIG.BgColor,  
            }, results)  
            corner(6, row)  

            newLabel({  
                Text = name,  
                Position = UDim2.new(0, 8, 0, 0),  
                Size = UDim2.new(1, -80, 1, 0),  
                TextXAlignment = Enum.TextXAlignment.Left,  
                TextSize = 12,  
                TextTruncate = Enum.TextTruncate.AtEnd,  
            }, row)  

            local setBtn = newButton({  
                Size = UDim2.fromOffset(64, 26),  
                Position = UDim2.new(1, -6, 0.5, 0),  
                AnchorPoint = Vector2.new(1, 0.5),  
                BackgroundColor3 = CONFIG.OffColor,  
            }, row)  
            corner(6, setBtn)  
            newLabel({  
                Text = "Set",  
                Size = UDim2.fromScale(1, 1),  
                Font = Enum.Font.GothamBold,  
                TextSize = 12,  
            }, setBtn)  

            setBtn.MouseButton1Click:Connect(function()  
                applyMusicId(tostring(id))  
                status.Text = "Включено: " .. name  
            end)  
        end  

        local function search()  
            local query = box.Text  
            if query == "" then return end  
            clearResults()  
            status.Text = "Поиск..."  

            task.spawn(function()  
                local url = "https://apis.roblox.com/toolbox-service/v1/marketplace/3?keyword="
                    .. HttpService:UrlEncode(query) .. "&limit=10"  

                local function getBody(targetUrl)
                    if request then  
                        local res = request({ Url = targetUrl, Method = "GET" })
                        return res.Body  
                    elseif http_request then  
                        local res = http_request({ Url = targetUrl, Method = "GET" })
                        return res.Body  
                    else  
                        return game:HttpGet(targetUrl)
                    end  
                end

                local ok, body = pcall(function()
                    return getBody(url)
                end)  

                if not ok then  
                    status.Text = "Ошибка запроса (нет request/HttpGet?)"  
                    return  
                end  

                local ok2, data = pcall(function() return HttpService:JSONDecode(body) end)  
                local list = ok2 and (data.data or data.Data or data.items or data.Items)

                if not (ok2 and type(list) == "table") then  
                    status.Text = "Не удалось разобрать ответ API"  
                    return  
                end  

                if #list == 0 then  
                    status.Text = "Ничего не найдено"  
                    return  
                end  

                local ids = {}
                for _, item in ipairs(list) do  
                    local id = item.id or item.Id or item.assetId or item.assetID
                    if id then table.insert(ids, tostring(id)) end
                end
                if #ids == 0 then
                    status.Text = "Ничего не найдено"
                    return
                end

                local detailsUrl = "https://apis.roblox.com/toolbox-service/v1/items/details?assetIds="
                    .. table.concat(ids, ",")
                local detailsOk, detailsBody = pcall(function()
                    return getBody(detailsUrl)
                end)
                local detailsData
                if detailsOk then
                    local decoded, result = pcall(function()
                        return HttpService:JSONDecode(detailsBody)
                    end)
                    if decoded then detailsData = result end
                end
                local detailedItems = detailsData and (detailsData.data or detailsData.Data)
                if type(detailedItems) ~= "table" then
                    status.Text = "Не удалось получить названия"
                    return
                end

                local shown = 0
                for _, item in ipairs(detailedItems) do
                    local asset = item.asset or item.Asset or item
                    local audio = asset.audioDetails or asset.AudioDetails or {}
                    local id = asset.id or asset.Id or asset.assetId
                    local name = audio.title or audio.Title or asset.name or asset.Name
                    local artist = audio.artist or audio.Artist
                    if id and name and tostring(name) ~= "" then
                        addResult(artist and (tostring(name) .. " - " .. tostring(artist)) or tostring(name), id)
                        shown = shown + 1
                    end
                end
                if shown == 0 then
                    status.Text = "Ничего не найдено"
                else
                    status.Text = ("Найдено: %d"):format(shown)
                end  
            end)  
        end  

        box.FocusLost:Connect(function(enterPressed)  
            if enterPressed then search() end  
        end)  
    end,  
})

end

-- ============================================================
-- AMOUNT INPUT (число + разовое применение по уходу фокуса, без тумблера)
-- ============================================================
local function createAmountCard(parent, title, desc, key, onApply)
local saved = SavedState.controls[key] or {}

local card = newFrame({
Name = "AmountCard",
Size = UDim2.new(1, 0, 0, CARD_H),
BackgroundColor3 = CONFIG.CardColor,
}, parent)
corner(8, card)
stroke(card, CONFIG.AccentColor, 0.9, 1)

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 0),  
    Size = UDim2.new(1, -114, 1, 0),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

local box = Instance.new("TextBox")  
box.Name = "Amount"  
box.Size = UDim2.fromOffset(64, 26)
box.Position = UDim2.new(1, -14, 0.5, 0)  
box.AnchorPoint = Vector2.new(1, 0.5)  
box.BackgroundColor3 = CONFIG.BgColor  
box.TextColor3 = CONFIG.AccentColor  
box.PlaceholderText = "0"  
box.PlaceholderColor3 = CONFIG.MutedTextColor  
box.Font = Enum.Font.GothamMedium  
box.TextSize = 13  
box.ClearTextOnFocus = false  
box.Text = saved.text or ""  
box.Parent = card  
corner(6, box)  
stroke(box, CONFIG.AccentColor, 0.85, 1)  

box.FocusLost:Connect(function()  
    local cleaned = string.gsub(box.Text, "%D", "")  
    box.Text = cleaned  
    if cleaned == "" then return end  

    saveField(key, "text", cleaned)  

    local n = tonumber(cleaned)  
    if n and onApply then onApply(n) end  
end)  

return card

end

-- ============================================================
-- STEPPER
-- ============================================================
local function createPercentRow(parent, title, options, default, onSelect)
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
    Text = options[index] .. "%",  
    Position = UDim2.new(0, 30, 0, 0),  
    Size = UDim2.fromOffset(52, 26),  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
    TextXAlignment = Enum.TextXAlignment.Center,  
}, stepper)  

local btnPlus = stepButton(86, "+")  

local function apply()  
    valueLabel.Text = options[index] .. "%"  

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

-- то же самое, но без знака "%" и с произвольным набором значений —
-- для выбора количества (сумма апгрейда и т.п.)
local function createNumberStepper(parent, title, options, default, onSelect)
local row = newFrame({
Name = "NumberStepperRow",
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
    if v == default then index = i end  
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
    Text = tostring(options[index]),  
    Position = UDim2.new(0, 30, 0, 0),  
    Size = UDim2.fromOffset(52, 26),  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
    TextXAlignment = Enum.TextXAlignment.Center,  
}, stepper)  

local btnPlus = stepButton(86, "+")  

local function apply()  
    valueLabel.Text = tostring(options[index])  
    if onSelect then onSelect(options[index]) end  
end  

btnMinus.MouseButton1Click:Connect(function()  
    if index > 1 then index = index - 1 apply() end  
end)  

btnPlus.MouseButton1Click:Connect(function()  
    if index < #options then index = index + 1 apply() end  
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
-- JUMP (слайдер 1-100, как Speed)
-- ============================================================
local JUMP_SCALE = 2 -- слайдер 1-100 даёт JumpPower до 200

local savedJump = SavedState.controls["player_1"] or {}
local Jump = {
    enabled = savedJump.on or false,
    value = savedJump.value or 50,
    original = 50,
}

bind(RunService.Heartbeat, function()
    if not Jump.enabled then return end
    local hum = getHumanoid()
    if not hum then return end
    hum.UseJumpPower = true
    local target = Jump.value * JUMP_SCALE
    if hum.JumpPower ~= target then
        hum.JumpPower = target
    end
end)

local JumpHandlers = {
    onChange = function(v)
        Jump.value = v
    end,

    onToggle = function(state)
        local hum = getHumanoid()
        if state then
            if hum then Jump.original = hum.JumpPower end
            Jump.enabled = true
        else
            Jump.enabled = false
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = Jump.original
            end
        end
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

    local function startKick(id)
        if not isActive(id) or not ready() then return false end
        local character = lp.Character
        local humanoid, root = getParts()
        if not (character and humanoid and root and character.PrimaryPart) then return false end

        local rep = game:GetService("ReplicatedStorage")
        local okController, kickController = pcall(function()
            return require(rep.Modules.ControllerLoader.KickController)
        end)
        local okNetwork, networkApi = pcall(function()
            return require(rep.Shared.Packages.Network)
        end)
        if not (okController and okNetwork) then return false end

        lp:SetAttribute("LocalKickBusy", true)
        humanoid:UnequipTools()
        root.Anchored = true

        local okKick, kick = pcall(function()
            return kickController:PerformKick(character)
        end)
        if not okKick or not kick then
            root.Anchored = false
            lp:SetAttribute("LocalKickBusy", false)
            return false
        end

        local ratio
        local deadline = os.clock() + 8
        while isActive(id) and kickController.InMinigame and os.clock() < deadline do
            local scale = kickController.DisplayedScale or kickController.Scale
            if scale and scale >= 0.985 then
                local okFire, value = pcall(function() return kick:Fire() end)
                if okFire then ratio = value end
                break
            end
            RunService.Heartbeat:Wait()
        end

        if ratio == nil then
            pcall(function() kick:Destroy() end)
            root.Anchored = false
            lp:SetAttribute("LocalKickBusy", false)
            return false
        end

        local sent = pcall(function()
            networkApi.FireServer("KickEvent", ratio)
        end)
        root.Anchored = false
        if not sent then
            lp:SetAttribute("LocalKickBusy", false)
            return false
        end

        local gameHandler
        pcall(function()
            gameHandler = require(rep.Modules.HandlerLoader.GameHandler)
        end)
        local started = waitFor(id, function()
            return gameHandler and gameHandler.InGame == true
        end, 3)
        if not started then
            lp:SetAttribute("LocalKickBusy", false)
            return false
        end
        return true
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
                if not startKick(id) then
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

local SLOT_POSITIONS = {
    ["Plot1"] = {
        Vector3.new(767.294, 3.163, 41.157),
        Vector3.new(767.294, 3.163, 50.177),
        Vector3.new(767.294, 3.163, 59.197),
        Vector3.new(767.294, 3.163, 68.217),
        Vector3.new(767.294, 3.163, 77.237),
        Vector3.new(810.294, 3.163, 77.237),
        Vector3.new(810.294, 3.163, 68.217),
        Vector3.new(810.294, 3.163, 59.197),
        Vector3.new(810.294, 3.163, 50.177),
        Vector3.new(810.294, 3.163, 41.157),
        Vector3.new(767.294, 20.737, 41.157),
        Vector3.new(767.294, 20.737, 50.177),
        Vector3.new(767.294, 20.737, 59.197),
        Vector3.new(767.294, 20.737, 68.217),
        Vector3.new(767.294, 20.737, 77.237),
        Vector3.new(810.294, 20.737, 77.237),
        Vector3.new(810.294, 20.737, 68.217),
        Vector3.new(810.294, 20.737, 59.197),
        Vector3.new(810.294, 20.737, 50.177),
        Vector3.new(810.294, 20.737, 41.157),
        Vector3.new(767.294, 41.737, 41.157),
        Vector3.new(767.294, 41.737, 50.177),
        Vector3.new(767.294, 41.737, 59.197),
        Vector3.new(767.294, 41.737, 68.217),
        Vector3.new(767.294, 41.737, 77.237),
        Vector3.new(810.294, 41.737, 77.237),
        Vector3.new(810.294, 41.737, 68.217),
        Vector3.new(810.294, 41.737, 59.197),
        Vector3.new(810.294, 41.737, 50.177),
        Vector3.new(810.294, 41.737, 41.157),
    },
    ["Plot2"] = {
        Vector3.new(963.254, 3.250, 308.352),
        Vector3.new(955.442, 3.250, 303.842),
        Vector3.new(947.630, 3.250, 299.332),
        Vector3.new(939.819, 3.250, 294.822),
        Vector3.new(932.008, 3.250, 290.312),
        Vector3.new(910.508, 3.250, 327.551),
        Vector3.new(918.319, 3.250, 332.061),
        Vector3.new(926.130, 3.250, 336.571),
        Vector3.new(933.942, 3.250, 341.081),
        Vector3.new(941.754, 3.250, 345.591),
        Vector3.new(963.254, 20.824, 308.352),
        Vector3.new(955.442, 20.824, 303.842),
        Vector3.new(947.630, 20.824, 299.332),
        Vector3.new(939.819, 20.824, 294.822),
        Vector3.new(932.008, 20.824, 290.312),
        Vector3.new(910.508, 20.824, 327.551),
        Vector3.new(918.319, 20.824, 332.061),
        Vector3.new(926.130, 20.824, 336.571),
        Vector3.new(933.942, 20.824, 341.081),
        Vector3.new(941.754, 20.824, 345.591),
        Vector3.new(963.254, 41.824, 308.352),
        Vector3.new(955.442, 41.824, 303.842),
        Vector3.new(947.630, 41.824, 299.332),
        Vector3.new(939.819, 41.824, 294.822),
        Vector3.new(932.008, 41.824, 290.312),
        Vector3.new(910.508, 41.824, 327.551),
        Vector3.new(918.319, 41.824, 332.061),
        Vector3.new(926.130, 41.824, 336.571),
        Vector3.new(933.942, 41.824, 341.081),
        Vector3.new(941.754, 41.824, 345.591),
    },
    ["Plot3"] = {
        Vector3.new(941.754, 3.250, 116.809),
        Vector3.new(933.942, 3.250, 121.319),
        Vector3.new(926.130, 3.250, 125.829),
        Vector3.new(918.319, 3.250, 130.339),
        Vector3.new(910.508, 3.250, 134.849),
        Vector3.new(932.008, 3.250, 172.088),
        Vector3.new(939.819, 3.250, 167.578),
        Vector3.new(947.630, 3.250, 163.068),
        Vector3.new(955.442, 3.250, 158.558),
        Vector3.new(963.254, 3.250, 154.048),
        Vector3.new(941.754, 20.824, 116.809),
        Vector3.new(933.942, 20.824, 121.319),
        Vector3.new(926.130, 20.824, 125.829),
        Vector3.new(918.319, 20.824, 130.339),
        Vector3.new(910.508, 20.824, 134.849),
        Vector3.new(932.008, 20.824, 172.088),
        Vector3.new(939.819, 20.824, 167.578),
        Vector3.new(947.630, 20.824, 163.068),
        Vector3.new(955.442, 20.824, 158.558),
        Vector3.new(963.254, 20.824, 154.048),
        Vector3.new(941.754, 41.824, 116.809),
        Vector3.new(933.942, 41.824, 121.319),
        Vector3.new(926.130, 41.824, 125.829),
        Vector3.new(918.319, 41.824, 130.339),
        Vector3.new(910.508, 41.824, 134.849),
        Vector3.new(932.008, 41.824, 172.088),
        Vector3.new(939.819, 41.824, 167.578),
        Vector3.new(947.630, 41.824, 163.068),
    },
    ["Plot4"] = {
        Vector3.new(906.381, 3.250, 384.037),
        Vector3.new(901.208, 3.250, 376.648),
        Vector3.new(896.034, 3.250, 369.259),
        Vector3.new(890.860, 3.250, 361.870),
        Vector3.new(885.687, 3.250, 354.482),
        Vector3.new(850.463, 3.250, 379.146),
        Vector3.new(855.637, 3.250, 386.534),
        Vector3.new(860.810, 3.250, 393.923),
        Vector3.new(865.984, 3.250, 401.312),
        Vector3.new(871.158, 3.250, 408.700),
        Vector3.new(906.381, 20.824, 384.037),
        Vector3.new(901.208, 20.824, 376.648),
        Vector3.new(896.034, 20.824, 369.259),
        Vector3.new(890.860, 20.824, 361.870),
        Vector3.new(885.687, 20.824, 354.482),
        Vector3.new(850.463, 20.824, 379.146),
        Vector3.new(855.637, 20.824, 386.534),
        Vector3.new(860.810, 20.824, 393.923),
        Vector3.new(865.984, 20.824, 401.312),
        Vector3.new(871.158, 20.824, 408.700),
        Vector3.new(906.381, 41.824, 384.037),
        Vector3.new(901.208, 41.824, 376.648),
        Vector3.new(896.034, 41.824, 369.259),
        Vector3.new(890.860, 41.824, 361.870),
        Vector3.new(885.687, 41.824, 354.482),
        Vector3.new(850.463, 41.824, 379.146),
        Vector3.new(855.637, 41.824, 386.534),
        Vector3.new(860.810, 41.824, 393.923),
        Vector3.new(865.984, 41.824, 401.312),
        Vector3.new(871.158, 41.824, 408.700),
    },
    ["Plot5"] = {
        Vector3.new(866.946, 4.300, 53.240),
        Vector3.new(862.436, 4.300, 61.052),
        Vector3.new(857.926, 4.300, 68.864),
        Vector3.new(853.416, 4.300, 76.675),
        Vector3.new(848.906, 4.300, 84.487),
        Vector3.new(886.146, 4.300, 105.987),
        Vector3.new(890.656, 4.300, 98.175),
        Vector3.new(895.166, 4.300, 90.364),
        Vector3.new(899.676, 4.300, 82.552),
        Vector3.new(904.185, 4.300, 74.740),
        Vector3.new(866.946, 21.874, 53.240),
        Vector3.new(862.436, 21.874, 61.052),
        Vector3.new(857.926, 21.874, 68.864),
        Vector3.new(853.416, 21.874, 76.675),
        Vector3.new(848.906, 21.874, 84.487),
        Vector3.new(886.146, 21.874, 105.987),
        Vector3.new(890.656, 21.874, 98.175),
        Vector3.new(895.166, 21.874, 90.364),
        Vector3.new(899.676, 21.874, 82.552),
        Vector3.new(904.185, 21.874, 74.740),
        Vector3.new(866.946, 41.824, 53.240),
        Vector3.new(862.436, 41.824, 61.052),
        Vector3.new(857.926, 41.824, 68.864),
        Vector3.new(853.416, 41.824, 76.675),
        Vector3.new(848.906, 41.824, 84.487),
        Vector3.new(886.146, 41.824, 105.987),
        Vector3.new(890.656, 41.824, 98.175),
        Vector3.new(895.166, 41.824, 90.364),
        Vector3.new(899.676, 41.824, 82.552),
        Vector3.new(904.185, 41.824, 74.740),
    },
    ["Plot6"] = {
        Vector3.new(975.337, 3.300, 209.700),
        Vector3.new(966.317, 3.300, 209.700),
        Vector3.new(957.297, 3.300, 209.700),
        Vector3.new(948.277, 3.300, 209.700),
        Vector3.new(939.257, 3.300, 209.700),
        Vector3.new(939.257, 3.300, 252.700),
        Vector3.new(948.277, 3.300, 252.700),
        Vector3.new(957.297, 3.300, 252.700),
        Vector3.new(966.317, 3.300, 252.700),
        Vector3.new(975.337, 3.300, 252.700),
    },
    ["Plot7"] = {
        Vector3.new(810.294, 4.300, 421.993),
        Vector3.new(810.294, 4.300, 412.973),
        Vector3.new(810.294, 4.300, 403.953),
        Vector3.new(810.294, 4.300, 394.933),
        Vector3.new(810.294, 4.300, 385.913),
        Vector3.new(767.294, 4.300, 385.913),
        Vector3.new(767.294, 4.300, 394.933),
        Vector3.new(767.294, 4.300, 403.953),
        Vector3.new(767.294, 4.300, 412.973),
        Vector3.new(767.294, 4.300, 421.993),
    },
}

local BASE_POSITIONS = {
    ["Plot1"] = Vector3.new(788.794, 2.063, 59.200),
    ["Plot2"] = Vector3.new(936.878, 2.150, 317.950),
    ["Plot3"] = Vector3.new(936.878, 2.150, 144.450),
    ["Plot4"] = Vector3.new(878.420, 2.150, 381.588),
    ["Plot5"] = Vector3.new(876.544, 3.200, 79.616),
    ["Plot6"] = Vector3.new(957.294, 2.200, 231.200),
    ["Plot7"] = Vector3.new(788.794, 3.200, 403.950),
}

-- имя своего плота ("Plot1".."Plot7") через официальный клиентский сервис
-- игры, а не через угадывание атрибутов — так надёжнее
local function getOwnPlotName()
    local ok, service = pcall(function()
        return require(
            game:GetService("ReplicatedStorage").Modules.ServicesLoader.ClientPlotService
        )
    end)
    if ok and service then
        if not service.Model and service.ModelAdded then
            pcall(function() service.ModelAdded:Wait() end)
        end
        if service.Model then return service.Model.Name end
    end
    return nil
end

local function getOwnPlotModel()
    local ok, service = pcall(function()
        return require(
            game:GetService("ReplicatedStorage").Modules.ServicesLoader.ClientPlotService
        )
    end)
    if not ok or not service then return nil end
    if not service.Model and service.ModelAdded then
        pcall(function() service.ModelAdded:Wait() end)
    end
    return service.Model
end

local function findFirst(root, ...)
    local names = { ... }
    local current = root
    for _, name in ipairs(names) do
        current = current and current:FindFirstChild(name)
    end
    return current
end

-- ============================================================
-- ФЕРМА: DAILY QUEST / AUTO COLLECT / AUTO UPGRADE
-- ============================================================
local Network

local function getNetwork()
    if Network then return Network end
    local ok, network = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Shared", 5)
            :WaitForChild("Packages", 5)
            :WaitForChild("Network", 5)
    end)
    if ok then Network = network end
    return Network
end

local function makeLoopToggle(label, action, interval)
    local active, token = false, 0
    return {
        onToggle = function(state)
            active = state
            token = token + 1
            local id = token
            if not state then return end
            task.spawn(function()
                while active and token == id do
                    local ok, err = pcall(action)
                    if not ok then
                        print("[Sakura] " .. label .. " error: " .. tostring(err))
                    end
                    task.wait(interval)
                end
            end)
        end,
    }
end

local dailyQuestPacket
local dailyQuestListenerAttached = false

local function getAvailableKicksQuest()
    local quests = dailyQuestPacket and dailyQuestPacket.Quests
    if type(quests) ~= "table" then return nil end
    for _, quest in pairs(quests) do
        local id = tostring(quest.Id or quest.Key or "")
        local current = tonumber(quest.Current) or 0
        local target = tonumber(quest.Target) or math.huge
        if string.lower(id) == "kicks" and current >= target and not quest.Claimed then
            return quest.Id or quest.Key
        end
    end
end

local DailyQuestHandlers = makeLoopToggle("Auto Collect Quest", function()
    local net = getNetwork()
    if not net then return end
    if not dailyQuestListenerAttached then
        dailyQuestListenerAttached = true
        net:WaitForChild("rev_DailyQuests_Update", 5).OnClientEvent:Connect(function(packet)
            dailyQuestPacket = packet
        end)
    end
    net:WaitForChild("rev_DailyQuests_Request", 5):FireServer()
    local started = os.clock()
    while os.clock() - started < 2 do
        if getAvailableKicksQuest() then break end
        task.wait(0.1)
    end
    local questId = getAvailableKicksQuest()
    if questId then
        net:WaitForChild("rev_DailyQuests_Claim", 5):FireServer(questId)
    end
end, 15)

local function teleportToOwnPlot()
    local plot = getOwnPlotModel()
    local char = Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (plot and root) then return false end
    root.CFrame = plot:GetPivot() + Vector3.new(0, 4, 0)
    return true
end

local function getAllPlotSlotRecords()
    local plot = getOwnPlotModel()
    local slotsFolder = plot and plot:FindFirstChild("Slots")
    local buttons = plot and plot:FindFirstChild("Buttons")
    if not (slotsFolder and buttons) then return {} end

    local slots = {}
    for _, slot in ipairs(slotsFolder:GetChildren()) do
        local index = tonumber(string.match(slot.Name, "%d+"))
        if index then
            table.insert(slots, {
                index = index,
                slot = slot,
                uma = slot:FindFirstChildOfClass("Part"),
                button = buttons:FindFirstChild("Slot" .. index),
            })
        end
    end
    table.sort(slots, function(a, b) return a.index < b.index end)
    return slots
end

local function getOccupiedPlotSlots()
    local occupied = {}
    for _, slot in ipairs(getAllPlotSlotRecords()) do
        if slot.uma then table.insert(occupied, slot) end
    end
    return occupied
end

local function hasCashToCollect(uma)
    local function hasAmount(instance)
        return (tonumber(instance:GetAttribute("Coins")) or 0) > 0
            or (tonumber(instance:GetAttribute("OfflineCoins")) or 0) > 0
    end
    if hasAmount(uma) then return true end
    for _, descendant in ipairs(uma:GetDescendants()) do
        if hasAmount(descendant) then return true end
    end
    return false
end

local function forEachOccupiedSlot(label, callback)
    local slots = getOccupiedPlotSlots()
    if #slots == 0 then
        print("[Sakura] " .. label .. ": занятые слоты не найдены")
        return
    end
    for _, slot in ipairs(slots) do
        callback(slot.index, slot.uma, slot.button)
        task.wait(0.05)
    end
end

local AutoCollectHandlers = makeLoopToggle("Auto Collect Cash", function()
    local net = getNetwork()
    if not net then return end
    local ev = net:WaitForChild("rev_B_Collect", 5)
    forEachOccupiedSlot("Auto Collect Cash", function(i, uma, button)
        if not button or not hasCashToCollect(uma) then return end
        local char = Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            root.CFrame = button.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)
        end
        ev:FireServer(i)
    end)
end, 3)

-- значение для "Select Speed Upgrade Amount" в Player (разовый апгрейд)
local savedAmounts = SavedState.controls["upgrade_amounts"] or {}
local SpeedUpgradeAmount = { value = savedAmounts.speed or 1 }

-- деньги игрока (leaderstats.Cash) — нужно, чтобы понимать, когда апгрейды
-- перестали быть по карману
local function getMaxAffordableSpeedUpgrades()
    local okBalance, balanceService = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ServicesLoader.ClientBalanceService)
    end)
    local okSpeed, speedService = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ServicesLoader.SpeedServiceClient)
    end)
    local okData, speedData = pcall(function()
        return require(game:GetService("ReplicatedStorage").Shared.Data.SpeedData)
    end)
    local okMath, infiniteMath = pcall(function()
        return require(game:GetService("ReplicatedStorage").Shared.Utility.InfiniteMath)
    end)
    if not (okBalance and okSpeed and okData and okMath) then return 0 end

    local count = 0
    local spent = infiniteMath.new(0)
    while count < 1000 do
        local cost = speedData:GetCostForLevel(speedService.Level + count + 1)
        if not cost or balanceService.Balance < spent + cost then break end
        spent = spent + cost
        count = count + 1
    end
    return count
end

-- один проход по всем занятым слотам плота с апгрейдом каждой Uma
local function runUmaUpgradePass()
    local net = getNetwork()
    if not net then return end
    local ev = net:WaitForChild("rev_B_Upgrade", 5)
    forEachOccupiedSlot("Auto Upgrade Umas", function(i)
        ev:FireServer(i)
    end)
end

-- по очереди прокачивает каждую доступную Uma (слоты 1-30, пропуская пустые)
local AutoUpgradeState = { enabled = false }
local AutoSpeedState = { enabled = false }
local AutoUpgradeHandlers
do
    local active, token = false, 0
    AutoUpgradeHandlers = {
        onToggle = function(state)
            AutoUpgradeState.enabled = state
            active = state
            token = token + 1
            local id = token
            if not state then return end

            task.spawn(function()
                while active and token == id do
                    if not AutoSpeedState.enabled then
                        local ok, err = pcall(runUmaUpgradePass)
                        if not ok then
                            print("[Sakura] Auto Upgrade Umas error: " .. tostring(err))
                        end
                    end
                    task.wait(3)
                end
            end)
        end,
    }
end

-- спускает все деньги на апгрейд скорости; если включён Auto Upgrade Umas,
-- перед этим один раз прокачивает каждую доступную Uma
local SpeedUpgradeHandlers
do
    local active, token = false, 0
    SpeedUpgradeHandlers = {
        onToggle = function(state)
            active = state
            AutoSpeedState.enabled = state
            token = token + 1
            local id = token
            if not state then return end

            task.spawn(function()
                local net = getNetwork()
                if not net then return end
                while active and token == id do
                    if AutoUpgradeState.enabled then
                        pcall(runUmaUpgradePass)
                    end
                    local amount = getMaxAffordableSpeedUpgrades()
                    if amount > 0 then
                        net:WaitForChild("rev_SPEED_UPGRADE", 5):FireServer(amount)
                    end
                    task.wait(2)
                end
            end)
        end,
    }
end

local function isUmaTool(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local ok, entities = pcall(function()
        return require(game:GetService("ReplicatedStorage").Shared.Data.EntitiesData)
    end)
    return ok and entities.Brainrots[tool.Name] ~= nil
end

local function getEquippedWeightTool()
    local lp = Players.LocalPlayer
    local ok, weightService = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ServicesLoader.WeightServiceClient)
    end)
    if not ok or not weightService then return nil end

    local equippedName = weightService.Equipped
    if type(equippedName) ~= "string" then return nil end

    local char = lp.Character
    local equipped = char and char:FindFirstChild(equippedName)
    if equipped and equipped:IsA("Tool") then return equipped end

    local backpack = lp:FindFirstChild("Backpack")
    local tool = backpack and backpack:FindFirstChild(equippedName)
    return tool and tool:IsA("Tool") and tool or nil
end

local AutoTrainingHandlers
do
    local active, token = false, 0
    local bonusConnection
    AutoTrainingHandlers = {
        onToggle = function(state)
            active = state
            token = token + 1
            local id = token
            if bonusConnection then
                bonusConnection:Disconnect()
                bonusConnection = nil
            end
            if not state then return end

            task.spawn(function()
                local net = getNetwork()
                if not net then return end
                local bonusEvent = net:WaitForChild("rev_TaviMishkal", 5)
                bonusConnection = bonusEvent.OnClientEvent:Connect(function(multiplier)
                    if not active or token ~= id then return end
                    if multiplier ~= 2 and multiplier ~= 5 and multiplier ~= 10 then return end
                    task.delay(0.15, function()
                        if active and token == id then
                            pcall(function() bonusEvent:FireServer() end)
                        end
                    end)
                end)

                while active and token == id do
                    local tool = getEquippedWeightTool()
                    local hum = getHumanoid()
                    local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
                    if tool and hum and tool.Parent == backpack
                        and Players.LocalPlayer:GetAttribute("LocalKickBusy") ~= true then
                        hum:EquipTool(tool)
                    end
                    task.wait(2)
                end
            end)
        end,
    }
end

-- продаёт каждую Uma через тот же запрос, что и продажа удерживаемой Uma
local SellAllHandlers = makeLoopToggle("Sell All Umas", function()
    local net = getNetwork()
    if not net then return end
    local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
    local hum = getHumanoid()
    if not (backpack and hum) then return end

    local tools = {}
    for _, child in ipairs(backpack:GetChildren()) do
        if isUmaTool(child) then table.insert(tools, child) end
    end
    local character = Players.LocalPlayer.Character
    local heldTool = character and character:FindFirstChildOfClass("Tool")
    if isUmaTool(heldTool) then table.insert(tools, heldTool) end
    local sell = net:WaitForChild("ref_B_Sell", 5)
    for _, tool in ipairs(tools) do
        if not tool.Parent then continue end
        hum:EquipTool(tool)
        task.wait(0.2)
        local ok, err = pcall(function() sell:InvokeServer() end)
        if not ok then
            print("[Sakura] Sell All Umas error: " .. tostring(err))
            return
        end
        task.wait(0.35)
    end
end, 5)

-- продаёт Uma, которую держит игрок
local function sellHeldUma()
    local net = getNetwork()
    if not net then return end
    local char = Players.LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")
    if not isUmaTool(tool) then
        print("[Sakura] Sell Uma: Uma не экипирована")
        return
    end

    local ok, err = pcall(function()
        net:WaitForChild("ref_B_Sell", 5):InvokeServer()
    end)
    if not ok then
        print("[Sakura] Sell Uma: " .. tostring(err))
    end
end

-- ============================================================
-- AUTO PLAY
-- ============================================================
local AutoPlayHandlers
do
    local active, token = false, 0
    local kickRunning = false

    local function setKick(state)
        if state == kickRunning then return end
        kickRunning = state
        KickHandlers.onToggle(state)
    end

    local function countHeldUmas()
        local count = 0
        local lp = Players.LocalPlayer
        for _, container in ipairs({ lp:FindFirstChild("Backpack"), lp.Character }) do
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    if isUmaTool(tool) then count = count + 1 end
                end
            end
        end
        return count
    end

    local function getUmaTools()
        local tools = {}
        local lp = Players.LocalPlayer
        for _, container in ipairs({ lp:FindFirstChild("Backpack"), lp.Character }) do
            if container then
                for _, tool in ipairs(container:GetChildren()) do
                    if isUmaTool(tool) then table.insert(tools, tool) end
                end
            end
        end
        return tools
    end

    local function interact(slotIndex)
        local net = getNetwork()
        if not net then return false end
        return pcall(function()
            net:WaitForChild("rev_S_Interact", 5):FireServer(slotIndex)
        end)
    end

    local function getUmaIncome(uma)
        local entityData
        pcall(function()
            entityData = require(game:GetService("ReplicatedStorage").Shared.Data.EntitiesData)
        end)
        local function numeric(value)
            if type(value) == "number" then return value end
            if type(value) == "table" then
                if type(value.toNumber) == "function" then
                    local ok, result = pcall(function() return value:toNumber() end)
                    if ok and tonumber(result) then return tonumber(result) end
                end
                local first = tonumber(value.first)
                local second = tonumber(value.second) or 0
                if first then return first * (10 ^ second) end
                return tonumber(value.value) or tonumber(value[1])
            end
            return tonumber(value)
        end

        local score = tonumber(uma:GetAttribute("CoinsPerSecond"))
            or tonumber(uma:GetAttribute("CPS"))
            or tonumber(uma:GetAttribute("Income"))
        local level = tonumber(uma:GetAttribute("Level")) or 1
        if entityData then
            for _, descendant in ipairs(uma:GetDescendants()) do
                local data = entityData.Brainrots[descendant.Name]
                if data then
                    score = score or numeric(data.CPS)
                    level = tonumber(descendant:GetAttribute("Level")) or level
                    break
                end
            end
        end
        return (score or 0) * (1.25 ^ math.max(0, level - 1))
    end

    local function moveToSlot(slot)
        local char = Players.LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and slot.slot:IsA("BasePart") then
            root.CFrame = slot.slot.CFrame + Vector3.new(0, 3, 0)
        end
        task.wait(0.2)
    end

    local function sortPlotSlots()
        local slots = getAllPlotSlotRecords()
        for index = 1, #slots do
            local best = nil
            for candidate = index, #slots do
                local slot = slots[candidate]
                if slot.uma and (not best or getUmaIncome(slot.uma) > getUmaIncome(slots[best].uma)) then
                    best = candidate
                end
            end

            if best and best ~= index then
                if slots[index].uma then
                    moveToSlot(slots[index])
                    if not interact(slots[index].index) then return false end
                    task.wait(0.35)
                end
                moveToSlot(slots[best])
                if not interact(slots[best].index) then return false end
                task.wait(0.35)
                moveToSlot(slots[index])
                if not interact(slots[index].index) then return false end
                task.wait(0.35)
                slots[index], slots[best] = slots[best], slots[index]
            end
        end
        return true
    end

    local function replaceLowestIncomeUma(newTool)
        local slots = getAllPlotSlotRecords()
        local target
        for _, slot in ipairs(slots) do
            if not slot.uma then target = slot break end
        end
        if not target then
            for _, slot in ipairs(slots) do
                if slot.uma and (not target or getUmaIncome(slot.uma) < getUmaIncome(target.uma)) then
                    target = slot
                end
            end
        end
        if not target then return false end
        if target.uma and getUmaIncome(newTool) <= getUmaIncome(target.uma) then
            return false
        end

        moveToSlot(target)
        if target.uma then
            if not interact(target.index) then return false end
            task.wait(0.35)
        end

        local hum = getHumanoid()
        local char = Players.LocalPlayer.Character
        local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
        if not (hum and char and backpack and (newTool.Parent == backpack or newTool.Parent == char)) then
            return false
        end
        if newTool.Parent == backpack then hum:EquipTool(newTool) end
        task.wait(0.2)
        local placed = interact(target.index)
        task.wait(0.35)
        if placed then sortPlotSlots() end
        return placed
    end

    local function startRebirthWatch(id)
        local ok, rebirthSvc = pcall(function()
            return require(
                game:GetService("ReplicatedStorage").Modules.ServicesLoader.RebirthServiceClient
            )
        end)
        if not ok then
            return
        end

        local net = getNetwork()
        if not net then return end
        local storageEv = net:WaitForChild("ref_UmaStorage_Request", 10)
        local rebirthData
        local kickService
        pcall(function()
            local rep = game:GetService("ReplicatedStorage")
            rebirthData = require(rep.Shared.Data.RebirthData)
            kickService = require(rep.Modules.ServicesLoader.KickServiceClient)
        end)
        if not (rebirthData and kickService) then return end

        local storedItems = {}
        local function storageRequest(action, value)
            local callOk, accepted, message, response, payload = pcall(function()
                return storageEv:InvokeServer(action, value)
            end)
            if not callOk or accepted == false then return false, nil end
            local data = type(payload) == "table" and payload
                or type(response) == "table" and response
                or type(accepted) == "table" and accepted
                or nil
            return true, data
        end

        local function getStorageList()
            local okList, data = storageRequest("List", nil)
            return okList and data and data.Items and data or nil
        end

        local function storeTopUmas()
            local data = getStorageList()
            if not data then return false end
            local items = data.Items
            local capacity = tonumber(data.Capacity) or #items
            local room = math.max(0, capacity - #items)
            if room == 0 then return false end

            local candidates = getOccupiedPlotSlots()
            table.sort(candidates, function(a, b)
                return getUmaIncome(a.uma) > getUmaIncome(b.uma)
            end)
            local known = {}
            for _, item in ipairs(items) do known[item.UID] = true end

            for _, candidate in ipairs(candidates) do
                if room <= 0 or #storedItems >= 2 then break end
                local okPick = interact(candidate.index)
                if okPick then
                    task.wait(0.35)
                    local char = Players.LocalPlayer.Character
                    local held = char and char:FindFirstChildOfClass("Tool")
                    if isUmaTool(held) then
                        local okStore = storageRequest("StoreHeld", nil)
                        task.wait(0.25)
                        local updated = getStorageList()
                        if okStore and updated then
                            for _, item in ipairs(updated.Items) do
                                if item.UID and not known[item.UID] then
                                    known[item.UID] = true
                                    table.insert(storedItems, {
                                        uid = item.UID,
                                        slot = candidate.index,
                                    })
                                    room = room - 1
                                    break
                                end
                            end
                        end
                    end
                end
            end
            return #storedItems > 0
        end

        local function restoreStoredUmas()
            if #storedItems == 0 then return end
            AutoTrainingHandlers.onToggle(false)
            for _, item in ipairs(storedItems) do
                local known = {}
                for _, tool in ipairs(getUmaTools()) do known[tool] = true end
                local okWithdraw = storageRequest("Withdraw", item.uid)
                if okWithdraw then
                    local tool
                    for _ = 1, 10 do
                        task.wait(0.25)
                        for _, candidate in ipairs(getUmaTools()) do
                            if not known[candidate] then
                                tool = candidate
                                break
                            end
                        end
                        if tool then break end
                    end

                    if tool then
                        local slots = getAllPlotSlotRecords()
                        local target
                        for _, slot in ipairs(slots) do
                            if slot.index == item.slot then target = slot break end
                        end
                        if not target then
                            for _, slot in ipairs(slots) do
                                if not slot.uma then target = slot break end
                            end
                        end
                        if target then
                            if target.uma then
                                interact(target.index)
                                task.wait(0.35)
                            end
                            local hum = getHumanoid()
                            local backpack = Players.LocalPlayer:FindFirstChild("Backpack")
                            if hum and backpack and tool.Parent == backpack then
                                hum:EquipTool(tool)
                                task.wait(0.2)
                                interact(target.index)
                                task.wait(0.35)
                            end
                        end
                    end
                end
            end
            table.clear(storedItems)
            AutoTrainingHandlers.onToggle(true)
        end

        local observedLevel = rebirthSvc.RebirthLevel
        local rebirthConnection = rebirthSvc.RebirthChanged:Connect(function(level)
            if not (active and token == id) then return end
            if level > observedLevel then
                observedLevel = level
                task.delay(1, restoreStoredUmas)
            end
        end)

        task.spawn(function()
            local prepared = false
            while active and token == id do
                local requirement = rebirthData:GetKickRequirement(rebirthSvc.RebirthLevel + 1)
                if not prepared and kickService.Level >= requirement * 0.9 then
                    AutoTrainingHandlers.onToggle(false)
                    prepared = storeTopUmas()
                    AutoTrainingHandlers.onToggle(true)
                end
                task.wait(2)
            end
            rebirthConnection:Disconnect()
        end)
    end

    local function loop(id)
        startRebirthWatch(id)
        KickHandlers.onToggle(false)
        AutoTrainingHandlers.onToggle(false)
        sortPlotSlots()
        setKick(true)
        AutoTrainingHandlers.onToggle(true)
        local knownTools = {}
        for _, tool in ipairs(getUmaTools()) do knownTools[tool] = true end

        while active and token == id do
            local n = countHeldUmas()
            setKick(n < 24)
            local newTool
            for _, tool in ipairs(getUmaTools()) do
                if not knownTools[tool] then
                    newTool = tool
                    break
                end
            end
            if newTool then
                task.wait(0.3)
                replaceLowestIncomeUma(newTool)
                knownTools = {}
                for _, tool in ipairs(getUmaTools()) do knownTools[tool] = true end
            else
                for _, tool in ipairs(getUmaTools()) do knownTools[tool] = true end
            end

            pcall(runUmaUpgradePass)

            local net = getNetwork()
            if net then
                local ok, ev = pcall(function() return net:WaitForChild("rev_B_Collect", 5) end)
                if ok then
                    forEachOccupiedSlot("Auto Play", function(i) ev:FireServer(i) end)
                end
            end

            task.wait(2)
        end

        setKick(false)
        AutoTrainingHandlers.onToggle(false)
    end

    AutoPlayHandlers = {
        onToggle = function(state)
            active = state
            token = token + 1
            local id = token
            if state then task.spawn(loop, id) end
        end,
    }
end

-- ============================================================
-- ТЕЛЕПОРТЫ (для вкладки Teleport)
-- ============================================================
-- ищет инстанс по цепочке имён-кандидатов (первый найденный вариант)
local function teleportRootTo(part, yOffset)
    local char = Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (part and root) then return false end
    root.CFrame = part.CFrame + Vector3.new(0, yOffset or 4, 0)
    return true
end

local function teleportToSell()
    local part = findFirst(workspace, "NPCs", "SellUma", "ProximityPart")
        or findFirst(workspace, "NPCs", "SellUma")
    if part and not part:IsA("BasePart") then
        part = part:FindFirstChildWhichIsA("BasePart")
    end
    if not teleportRootTo(part) then
        print("[Sakura] Teleport to Sell: NPC не найден (workspace.NPCs.SellUma)")
    end
end

local function teleportToShop()
    local part = findFirst(workspace, "NPCs", "Shop Guy")
        or findFirst(workspace, "NPCs", "ShopGuy")
        or findFirst(workspace, "NPCs", "Shop")
    if part and not part:IsA("BasePart") then
        part = part.PrimaryPart or part:FindFirstChildWhichIsA("BasePart")
    end
    if not teleportRootTo(part) then
        print("[Sakura] Teleport to Shop: NPC не найден — пришли точный путь, если не сработает")
    end
end

-- ============================================================
-- ТАБЫ
-- ============================================================
local TABS = {
{
id = "home",
name = "Home",
funcs = {}
},

{
id = "player",
name = "Player",
funcs = {
{
title = "Jump",
type = "slider",
handlers = JumpHandlers
},
{
title = "Fly",
handlers = FlyHandlers
},
{
title = "Speed",
type = "slider",
handlers = SpeedHandlers
},
{
title = "Select Speed Upgrade Amount",
type = "amount",
onApply = function(value)
    SpeedUpgradeAmount.value = value
    saveField("upgrade_amounts", "speed", value)
    local net = getNetwork()
    if net then
        local ok, err = pcall(function()
            net:WaitForChild("rev_SPEED_UPGRADE", 5):FireServer(value)
        end)
        if not ok then
            print("[Sakura] Speed Upgrade Amount error: " .. tostring(err))
        end
    end
end,
},
{
title = "Sell Uma",
type = "action",
onClick = sellHeldUma,
},
}
},

{  
    id = "farm",  
    name = "Auto Features",  
    funcs = {  
        {  
            title = "Auto Kick",  
            handlers = KickHandlers  
        },  
        {  
            title = "Auto Collect Quest",  
            handlers = DailyQuestHandlers  
        },  
        {  
            title = "Auto Collect Cash",  
            handlers = AutoCollectHandlers  
        },  
        {  
            title = "Auto Upgrade Umas",  
            handlers = AutoUpgradeHandlers  
        },  
        {
            title = "Auto Upgrade Speed",
            handlers = SpeedUpgradeHandlers
        },
        {
            title = "Auto Training Weight",
            handlers = AutoTrainingHandlers
        },
        {
            title = "Sell All Umas",
            handlers = SellAllHandlers
        },
        {
            title = "Auto Play",
            handlers = AutoPlayHandlers
        },
    },
},
{
    id = "misc",
    name = "Misc",
    funcs = {
        { title = "Set Music", type = "music" },
        { title = "Find Music", type = "musicsearch" },
    },
},
{
    id = "teleport",
    name = "Teleport",
    funcs = {
        {
            title = "Teleport To Base",
            type = "action",
            onClick = function()
                if not teleportToOwnPlot() then
                    print("[Sakura] Teleport To Base: свой плот не найден")
                end
            end,
        },
        { title = "Teleport to Sell", type = "action", onClick = teleportToSell },
        {
            title = "Teleport to Kick Station",
            type = "action",
            onClick = function()
                if not teleportToKick() then
                    print("[Sakura] Teleport to Kick Station: зона не найдена")
                end
            end,
        },
        { title = "Teleport to Shop", type = "action", onClick = teleportToShop },
    },
},
{
    id = "settings",
    name = "Settings",
    funcs = {},
},
}

local pages = {}
local tabButtons = {}
local sidebarCollapsed = false
local activeTab = TABS[1].id

if PlayerGui:FindFirstChild("SakuraMenu") then
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

local LiquidGlass = { enabled = SavedState.controls["settings_liquidglass"] and SavedState.controls["settings_liquidglass"].on or false }
local legacyBlur = game:GetService("Lighting"):FindFirstChild("SakuraGlassBlur")
if legacyBlur then legacyBlur:Destroy() end
local glassSurface = newFrame({
    Name = "GlassSurface",
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Color3.fromRGB(196, 218, 222),
    BackgroundTransparency = 0.88,
    Visible = LiquidGlass.enabled,
    ZIndex = 1,
}, MainFrame)
corner(16, glassSurface)
local glassGradient = Instance.new("UIGradient")
glassGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(236, 247, 248)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(153, 190, 198)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(222, 236, 236)),
})
glassGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.18),
    NumberSequenceKeypoint.new(0.52, 0.62),
    NumberSequenceKeypoint.new(1, 0.28),
})
glassGradient.Rotation = 35
glassGradient.Parent = glassSurface
stroke(glassSurface, Color3.fromRGB(239, 250, 250), 0.52, 1)

local function refreshBlur()
    glassSurface.Visible = LiquidGlass.enabled
    MainFrame.BackgroundColor3 = LiquidGlass.enabled
        and Color3.fromRGB(31, 42, 46)
        or CONFIG.BgColor
    MainFrame.BackgroundTransparency = LiquidGlass.enabled
        and 0.34
        or CONFIG.Transparency
end

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

local logoIcon = drawIcon("logo", logoHolder, 26)
for _, part in ipairs(logoIcon:GetChildren()) do
    if part:IsA("Frame") then
        attachShimmer(part, Color3.fromRGB(190, 190, 198), Color3.fromRGB(255, 255, 255), 2.2)
    end
end
bind(RunService.RenderStepped, function(dt)
    logoIcon.Rotation = (logoIcon.Rotation + dt * 14) % 360
end)

local titleLabel = newLabel({
    Text = "Sakura",
    Position = UDim2.new(0, 52, 0, 0),
    Size = UDim2.new(0, 150, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = CONFIG.SakuraPink,
}, TopBar)
attachShimmer(titleLabel, Color3.fromRGB(190, 45, 95), CONFIG.SakuraPink, 2.6)

local btnClose = newButton({
    Name = "CloseBtn",
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -16, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = CONFIG.CardColor,
}, TopBar)
corner(8, btnClose)
drawCross(btnClose, 12, CONFIG.CloseColor, 45, -45)

local btnMinimize = newButton({
    Name = "MinimizeBtn",
    Size = UDim2.fromOffset(30, 30),
    Position = UDim2.new(1, -54, 0.5, 0),
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundColor3 = CONFIG.CardColor,
}, TopBar)
corner(8, btnMinimize)
drawCross(btnMinimize, 12, CONFIG.AccentColor, 0, nil)

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
local tabBuilt, tabError = pcall(function()

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

    createFunctionCard(
        page,
        "Liquid Glass",
        "",
        "Settings",
        "settings_liquidglass",
        {
            onToggle = function(state)
                LiquidGlass.enabled = state
                refreshBlur()
            end,
        }
    ).LayoutOrder = 3

elseif tab.id == "home" then

    -- ===== HOME: аватар, ник, голая статистика =====
    local header = newFrame({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, 64),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
    }, page)

    local avatarHold = newFrame({
        Size = UDim2.fromOffset(64, 64),
        BackgroundColor3 = CONFIG.CardColor,
    }, header)
    corner(32, avatarHold)
    stroke(avatarHold, CONFIG.AccentColor, 0.85, 1)

    local avatarImg = Instance.new("ImageLabel")
    avatarImg.Size = UDim2.fromScale(1, 1)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = ""
    avatarImg.Parent = avatarHold
    corner(32, avatarImg)

    task.spawn(function()
        local ok, img = pcall(function()
            return Players:GetUserThumbnailAsync(
                Players.LocalPlayer.UserId,
                Enum.ThumbnailType.HeadShot,
                Enum.ThumbnailSize.Size100x100
            )
        end)
        if ok then avatarImg.Image = img end
    end)

    newLabel({
        Text = Players.LocalPlayer.DisplayName,
        Position = UDim2.new(0, 76, 0, 12),
        Size = UDim2.new(1, -76, 0, 22),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
    }, header)

    newLabel({
        Text = "@" .. Players.LocalPlayer.Name,
        Position = UDim2.new(0, 76, 0, 36),
        Size = UDim2.new(1, -76, 0, 16),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextColor3 = CONFIG.MutedTextColor,
        TextSize = 12,
    }, header)

    local statsBox = newFrame({
        Name = "Stats",
        Size = UDim2.new(1, 0, 0, 130),
        BackgroundColor3 = CONFIG.CardColor,
        LayoutOrder = 2,
    }, page)
    corner(8, statsBox)
    stroke(statsBox, CONFIG.AccentColor, 0.9, 1)

    local statLabels = {}
    local statOrder = { "Cash", "Kick Power", "Speed", "Rebirths" }
    for i, name in ipairs(statOrder) do
        statLabels[name] = newLabel({
            Text = name .. ": —",
            Position = UDim2.new(0, 14, 0, 8 + (i - 1) * 28),
            Size = UDim2.new(1, -28, 0, 22),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 13,
        }, statsBox)
    end

    local function fmt(n)
        if type(n) ~= "number" then return tostring(n) end
        local units = { "", "K", "M", "B", "T", "Qa", "Qi" }
        local i = 1
        while math.abs(n) >= 1000 and i < #units do
            n = n / 1000
            i = i + 1
        end
        return string.format("%.2f%s", n, units[i])
    end

    local speedService
    local function getSpeedValue()
        if speedService == nil then
            local ok, svc = pcall(function()
                return require(
                    game:GetService("ReplicatedStorage").Modules.ServicesLoader.SpeedServiceClient
                )
            end)
            speedService = ok and svc or false
        end

        if speedService and speedService.DidInit then
            return speedService.MaxSpeed or speedService.CurrentSpeed
        end

        local lp = Players.LocalPlayer
        local ls = lp:FindFirstChild("leaderstats")
        local speedStat = ls and ls:FindFirstChild("Speed")
        if speedStat then return speedStat.Value end

        local attr = lp:GetAttribute("Speed") or lp:GetAttribute("SpeedLevel")
        if attr then return attr end

        return nil
    end

    local function refreshStats()
        local lp = Players.LocalPlayer
        local ls = lp:FindFirstChild("leaderstats")

        local cash = ls and ls:FindFirstChild("Cash")
        statLabels["Cash"].Text = "Cash: " .. (cash and fmt(cash.Value) or "—")

        local kp = lp:GetAttribute("SelectedKickPower")
        statLabels["Kick Power"].Text = "Kick Power: " .. (kp and fmt(kp) or "—")

        local speedVal = getSpeedValue()
        statLabels["Speed"].Text = "Speed: " .. (speedVal and fmt(speedVal) or "—")

        local reb = ls and ls:FindFirstChild("Rebirths")
        statLabels["Rebirths"].Text = "Rebirths: " .. (reb and tostring(reb.Value) or "—")

    end

    refreshStats()
    task.spawn(function()
        while statsBox.Parent do
            refreshStats()
            task.wait(0.5)
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

        elseif f.type == "music" then

            card = createMusicCard(page, f.title, f.desc, key)

        elseif f.type == "musicsearch" then

            card = createMusicSearchCard(page, f.title, f.desc, key)

        elseif f.type == "action" then

            card = createActionCard(page, f.title, f.desc, f.onClick)

        elseif f.type == "stepper" then

            card = createNumberStepper(page, f.title, f.options, f.default, f.onSelect)

        elseif f.type == "amount" then

            card = createAmountCard(page, f.title, f.desc, key, f.onApply)

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

end)

if not tabBuilt then
    warn("[Sakura] Failed to build tab " .. tostring(tab.id) .. ": " .. tostring(tabError))
    local errorPanel = newFrame({
        Name = "TabBuildError",
        Size = UDim2.new(1, -32, 0, 88),
        Position = UDim2.new(0, 16, 0, 16),
        BackgroundColor3 = Color3.fromRGB(112, 35, 42),
        ZIndex = 50,
    }, ContentArea)
    corner(8, errorPanel)
    newLabel({
        Text = "UI error in " .. tostring(tab.id) .. ":\n" .. tostring(tabError),
        Size = UDim2.new(1, -20, 1, -16),
        Position = UDim2.new(0, 10, 0, 8),
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextColor3 = Color3.fromRGB(255, 235, 235),
        TextSize = 13,
        ZIndex = 51,
    }, errorPanel)
end

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
        refreshBlur()  

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
            refreshBlur()  
        end  
    )  
end

)

btnClose.MouseButton1Click:Connect(
function()

SpeedHandlers.onToggle(false)  
    KickHandlers.onToggle(false)

    do
        local lighting = game:GetService("Lighting")
        local blur = lighting:FindFirstChild("SakuraGlassBlur")
        if blur then blur:Destroy() end
    end

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

refreshBlur()
