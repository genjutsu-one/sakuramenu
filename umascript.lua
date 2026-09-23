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

    local body = newFrame({
        Size = UDim2.fromOffset(size * 0.62, size * 0.46),
        Position = UDim2.new(0.5, 0, 0.62, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = W,
    }, holder)
    corner(2, body)

    corner(2, newFrame({
        Size = UDim2.fromOffset(size * 0.52, size * 0.16),
        Position = UDim2.new(0.5, 0, 0.31, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = 34,
        BackgroundColor3 = W,
    }, holder))

    corner(2, newFrame({
        Size = UDim2.fromOffset(size * 0.52, size * 0.16),
        Position = UDim2.new(0.5, 0, 0.31, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Rotation = -34,
        BackgroundColor3 = W,
    }, holder))

    corner(2, newFrame({  
        Size = UDim2.fromOffset(size * 0.16, size * 0.27),  
        Position = UDim2.new(0.5, 0, 1, 0),  
        AnchorPoint = Vector2.new(0.5, 1),  
        BackgroundColor3 = CONFIG.BgColor,  
        ZIndex = 2,  
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
    Position = UDim2.new(0, 14, 0, 6),  
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
    Position = UDim2.new(0, 14, 0, 6),  
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
local function createInputCard(parent, title, desc, key)
return createCard(parent, title, desc, key, {
    expandedH = 72,

build = function(panel, saved)  
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

-- ============================================================
-- MUSIC INPUT (без тумблера — просто поле и применение по Enter/уходу фокуса)
-- ============================================================
local function createMusicCard(parent, title, desc, key)
local saved = SavedState.controls[key] or {}

local card = newFrame({
Name = "MusicCard",
    Size = UDim2.new(1, 0, 0, 210),
BackgroundColor3 = CONFIG.CardColor,
}, parent)
corner(8, card)
stroke(card, CONFIG.AccentColor, 0.9, 1)

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 6),  
    Size = UDim2.new(1, -28, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

local box = Instance.new("TextBox")  
box.Name = "MusicId"  
box.Size = UDim2.fromOffset(150, 30)  
box.Position = UDim2.new(1, -14, 0, 28)  
box.AnchorPoint = Vector2.new(1, 0)  
box.BackgroundColor3 = CONFIG.BgColor  
box.TextColor3 = CONFIG.AccentColor  
box.PlaceholderText = "ID музыки"  
box.PlaceholderColor3 = CONFIG.MutedTextColor  
box.Font = Enum.Font.GothamMedium  
box.TextSize = 13  
box.ClearTextOnFocus = false  
box.Text = saved.text or ""  
box.Parent = card  
corner(6, box)  
stroke(box, CONFIG.AccentColor, 0.85, 1)  

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -100, 0, 30)
searchBox.Position = UDim2.new(0, 14, 0, 68)
searchBox.BackgroundColor3 = CONFIG.BgColor
searchBox.TextColor3 = CONFIG.AccentColor
searchBox.PlaceholderText = "Поиск по названию"
searchBox.PlaceholderColor3 = CONFIG.MutedTextColor
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 13
searchBox.ClearTextOnFocus = false
searchBox.Parent = card
corner(6, searchBox)
stroke(searchBox, CONFIG.AccentColor, 0.85, 1)

local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.fromOffset(70, 30)
searchButton.Position = UDim2.new(1, -14, 0, 68)
searchButton.AnchorPoint = Vector2.new(1, 0)
searchButton.BackgroundColor3 = CONFIG.AccentColor
searchButton.TextColor3 = CONFIG.BgColor
searchButton.Text = "Искать"
searchButton.Font = Enum.Font.GothamBold
searchButton.TextSize = 12
searchButton.AutoButtonColor = true
searchButton.Parent = card
corner(6, searchButton)

local results = newFrame({
    Name = "MusicResults",
    Position = UDim2.new(0, 14, 0, 106),
    Size = UDim2.new(1, -28, 0, 90),
    BackgroundTransparency = 1,
}, card)
local resultsLayout = Instance.new("UIListLayout")
resultsLayout.Padding = UDim.new(0, 4)
resultsLayout.Parent = results

local function apply()  
    local id = box.Text:gsub("%s+", "")  
    if id == "" then return end  

    id = "rbxassetid://" .. id:gsub("rbxassetid://", ""):gsub("%D", "")
    if id == "rbxassetid://" then return end
    box.Text = id  

    saveField(key, "text", id)  

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
end  

box.FocusLost:Connect(apply)  

local function httpGet(url)
    local fn = request or http_request or (syn and syn.request)
    if fn then
        local response = fn({ Url = url, Method = "GET" })
        return response and response.Body
    end
    return HttpService:GetAsync(url)
end

local function searchMusic()
    for _, child in ipairs(results:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local keyword = searchBox.Text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if keyword == "" then return end
    local encoded = HttpService:UrlEncode(keyword)
    local ok, body = pcall(httpGet, "https://catalog.roblox.com/v1/search/items/details?Category=3&Subcategory=3&SortType=0&Keyword=" .. encoded .. "&Limit=10")
    if not ok or not body then return end
    local parsedOk, data = pcall(HttpService.JSONDecode, HttpService, body)
    if not parsedOk or type(data) ~= "table" then return end
    for _, item in ipairs(data.data or {}) do
        local result = Instance.new("TextButton")
        result.Size = UDim2.new(1, 0, 0, 24)
        result.BackgroundColor3 = CONFIG.BgColor
        result.TextColor3 = CONFIG.AccentColor
        result.TextXAlignment = Enum.TextXAlignment.Left
        result.Text = "  " .. tostring(item.name or item.id)
        result.Font = Enum.Font.GothamMedium
        result.TextSize = 11
        result.AutoButtonColor = true
        result.Parent = results
        corner(4, result)
        result.Activated:Connect(function()
            box.Text = tostring(item.id)
            apply()
        end)
    end
end

searchButton.Activated:Connect(searchMusic)
searchBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then searchMusic() end
end)

return card

end

-- ============================================================
-- AMOUNT INPUT (число + разовое применение по уходу фокуса, без тумблера)
-- ============================================================
local function createAmountCard(parent, title, desc, key, onApply)
local saved = SavedState.controls[key] or {}

local card = newFrame({
Name = "AmountCard",
    Size = UDim2.new(1, 0, 0, 70),
BackgroundColor3 = CONFIG.CardColor,
}, parent)
corner(8, card)
stroke(card, CONFIG.AccentColor, 0.9, 1)

newLabel({  
    Text = title,  
    Position = UDim2.new(0, 14, 0, 6),  
    Size = UDim2.new(1, -28, 0, 16),  
    TextXAlignment = Enum.TextXAlignment.Left,  
    Font = Enum.Font.GothamBold,  
    TextSize = 13,  
}, card)  

local box = Instance.new("TextBox")  
box.Name = "Amount"  
box.Size = UDim2.fromOffset(150, 30)  
box.Position = UDim2.new(1, -14, 0, 28)  
box.AnchorPoint = Vector2.new(1, 0)  
box.BackgroundColor3 = CONFIG.BgColor  
box.TextColor3 = CONFIG.AccentColor  
box.PlaceholderText = "Введите число..."  
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
    return ok and service and service.Model or nil
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
local dailyQuestPacket
local dailyQuestListenerAttached = false

local function getAvailableKicksQuest()
    local quests = dailyQuestPacket and dailyQuestPacket.Quests
    if type(quests) ~= "table" then return nil end
    for _, quest in pairs(quests) do
        local id = tostring(quest.Id or quest.Key or "")
        local title = string.lower(tostring(quest.Title or ""))
        if id == "Kicks" or string.find(string.lower(id), "kick", 1, true)
            or string.find(title, "kick", 1, true) then
            local current = tonumber(quest.Current) or 0
            local target = tonumber(quest.Target) or math.huge
            if current >= target and not quest.Claimed then
                return quest.Id or quest.Key or "Kicks"
            end
        end
    end
end

local DailyQuestHandlers = makeLoopToggle("Daily Quest", function()
    local net = getNetwork()
    if not net then return end
    if not dailyQuestListenerAttached then
        dailyQuestListenerAttached = true
        pcall(function()
            net:WaitForChild("rev_DailyQuests_Update", 5).OnClientEvent:Connect(function(packet)
                dailyQuestPacket = packet
            end)
        end)
    end
    net:WaitForChild("rev_DailyQuests_Request", 5):FireServer()
    task.wait(0.3)
    local questId = getAvailableKicksQuest()
    if questId then
        net:WaitForChild("rev_DailyQuests_Claim", 5):FireServer(questId)
    end
end, 30)

-- определяет свой плот через ClientPlotService и телепортирует к его двери
-- (координата из BASE_POSITIONS)
local function teleportToOwnPlot()
    local name = getOwnPlotName()
    local pos = name and BASE_POSITIONS[name]
    local char = Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (pos and root) then return false end

    root.CFrame = CFrame.new(pos) + Vector3.new(0, 4, 0)
    return true
end

local AutoCollectHandlers = makeLoopToggle("Auto Collect Cash", function()
    local net = getNetwork()
    if not net then return end

    local plot = getOwnPlotModel()
    local slotsFolder = plot and plot:FindFirstChild("Slots")
    local buttons = plot and plot:FindFirstChild("Buttons")
    if not (slotsFolder and buttons) then
        print("[Sakura] Auto Collect Cash: свой плот не определён")
        return
    end

    local ev = net:WaitForChild("rev_B_Collect", 5)
    for _, slot in ipairs(slotsFolder:GetChildren()) do
        local slotId = tonumber(string.match(slot.Name, "%d+"))
        local coins = tonumber(slot:GetAttribute("Coins")) or 0
        local offline = tonumber(slot:GetAttribute("OfflineCoins")) or 0
        for _, placed in ipairs(slot:GetDescendants()) do
            coins = math.max(coins, tonumber(placed:GetAttribute("Coins")) or 0)
            offline = math.max(offline, tonumber(placed:GetAttribute("OfflineCoins")) or 0)
        end
        if slotId and (coins > 0 or offline > 0) then
            local button = buttons:FindFirstChild("Slot" .. slotId)
            if button then
                local char = Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then root.CFrame = button.CFrame + Vector3.new(0, 3, 0) end
                task.wait(0.08)
                ev:FireServer(slotId)
                task.wait(0.05)
            end
        end
    end
end, 3)

-- Количество speed-апгрейдов вычисляется по текущему балансу перед каждым циклом.
local savedAmounts = SavedState.controls["upgrade_amounts"] or {}
local SpeedUpgradeAmount = { value = savedAmounts.speed or 1 }
local AutoUpgradeActive = false

local function upgradeEachUmaOnce()
    local net = getNetwork()
    if not net then return end
    local plot = getOwnPlotModel()
    local slotsFolder = plot and plot:FindFirstChild("Slots")
    if not slotsFolder then return end
    local ev = net:WaitForChild("rev_B_Upgrade", 5)
    for _, slot in ipairs(slotsFolder:GetChildren()) do
        local slotId = tonumber(string.match(slot.Name, "%d+"))
        if slotId and slot:FindFirstChildWhichIsA("BasePart", true) then
            ev:FireServer(slotId)
            task.wait(0.08)
        end
    end
end

local AutoUpgradeHandlers = {
    onToggle = function(state)
        AutoUpgradeActive = state
        if state then
            task.spawn(function()
                while AutoUpgradeActive do
                    upgradeEachUmaOnce()
                    task.wait(1)
                end
            end)
        end
    end,
}

-- повторяет апгрейд скорости с выбранным количеством (по умолчанию 1, как в примере)
local function getMaxAffordableSpeedUpgrades()
    local ok, balanceService = pcall(function()
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
    if not (ok and okSpeed and okData and okMath and balanceService and speedService and speedData and infiniteMath) then return 1 end
    local count = 0
    local spent = infiniteMath.new(0)
    while count < 1000 do
        local cost = speedData:GetCostForLevel(speedService.Level + count + 1)
        if balanceService.Balance < spent + cost then break end
        spent = spent + cost
        count = count + 1
    end
    return math.max(count, 1)
end

local SpeedUpgradeHandlers = makeLoopToggle("Speed Upgrade", function()
    if AutoUpgradeActive then upgradeEachUmaOnce() end
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_SPEED_UPGRADE", 5):FireServer(getMaxAffordableSpeedUpgrades())
end, 1)

-- берёт первый предмет инвентаря (Tool в Backpack) и жмёт тренировку веса
local function getFirstInventoryTool()
    local lp = Players.LocalPlayer
    local backpack = lp:FindFirstChild("Backpack")
    if backpack then
        local tool = backpack:FindFirstChildOfClass("Tool")
        if tool then return tool end
    end
    local char = lp.Character
    return char and char:FindFirstChildOfClass("Tool")
end

-- берёт первый предмет один раз при включении, дальше только жмёт тренировку
local AutoTrainingHandlers
do
    local active, token = false, 0
    AutoTrainingHandlers = {
        onToggle = function(state)
            active = state
            token = token + 1
            local id = token
            if not state then return end

            task.spawn(function()
                local net = getNetwork()
                if not net then return end

                local tool = getFirstInventoryTool()
                local hum = getHumanoid()
                if tool and hum then
                    hum:EquipTool(tool)
                    task.wait(0.2)
                end

                local ev = net:WaitForChild("rev_TaviMishkal", 5)
                while active and token == id do
                    local ok, err = pcall(function() ev:FireServer() end)
                    if not ok then
                        print("[Sakura] Auto Training Weight error: " .. tostring(err))
                    end
                    task.wait(1)
                end
            end)
        end,
    }
end

-- продаёт всех Um одним вызовом (InvokeServer, не FireServer)
local SellAllHandlers = makeLoopToggle("Sell All Umas", function()
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("ref_B_SellAll", 5):InvokeServer()
end, 5)

-- забирает офлайн-накопление
local AutoOfflineClaimHandlers = makeLoopToggle("Auto Offline Claim", function()
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_Offline_Claim", 5):FireServer()
end, 60)

local function sellHeldUma()
    local net = getNetwork()
    if not net then return end
    local char = Players.LocalPlayer.Character
    local tool = char and char:FindFirstChildOfClass("Tool")

    local ok, err = pcall(function()
        local ev = net:WaitForChild("ref_B_Sell", 5)
        ev:InvokeServer()
    end)
    if not ok then
        print("[Sakura] Sell Uma: " .. tostring(err))
    end
end

-- ============================================================
-- ТЕЛЕПОРТЫ (для вкладки Teleport)
-- ============================================================
-- ищет инстанс по цепочке имён-кандидатов (первый найденный вариант)
local function findFirst(root, ...)
    local names = { ... }
    local cur = root
    for _, name in ipairs(names) do
        cur = cur and cur:FindFirstChild(name)
    end
    return cur
end

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
desc = "Ввести число — прокачает разово",
type = "amount",
onApply = function(v)
    SpeedUpgradeAmount.value = v
    saveField("upgrade_amounts", "speed", v)
    local net = getNetwork()
    if not net then return end
    local ok, err = pcall(function()
        net:WaitForChild("rev_SPEED_UPGRADE", 5):FireServer(v)
    end)
    if not ok then print("[Sakura] Speed Upgrade Amount error: " .. tostring(err)) end
end,
},
{
title = "Sell Uma",
desc = "Продать Uma в руках (проверь вызов)",
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
            desc = "ТП в зону Kick, затем авто-удар",  
            handlers = KickHandlers  
        },  
        {  
            title = "Auto Claim Quest",
            desc = "Открыть и забрать ежедневный квест",  
            handlers = DailyQuestHandlers  
        },  
        {  
            title = "Auto Collect Cash",  
            desc = "Сбор слотов 1-30 по кругу",  
            handlers = AutoCollectHandlers  
        },  
        {  
            title = "Auto Upgrade Umas",
            desc = "Повтор апгрейда Umas",  
            handlers = AutoUpgradeHandlers  
        },  
        {
            title = "Speed Upgrade",
            desc = "Повтор апгрейда скорости",
            handlers = SpeedUpgradeHandlers
        },
        {
            title = "Auto Training Weight",
            desc = "Первый предмет инвентаря + тренировка",
            handlers = AutoTrainingHandlers
        },
        {
            title = "Sell All Umas",
            desc = "Продать всех Umas",
            handlers = SellAllHandlers
        },
        {
            title = "Auto Offline Claim",
            desc = "Забрать офлайн-накопление",
            handlers = AutoOfflineClaimHandlers
        },
    }  
},  

{  
    id = "misc",  
    name = "Misc",  
    funcs = {  
        {
            title = "Set Music",
            desc = "rbxassetid:// ссылка на музыку",
            type = "music"
        },
    }  
},  

{
    id = "teleport",
    name = "Teleport",
    funcs = {
        {
            title = "Teleport To Base",
            desc = "На свой плот",
            type = "action",
            onClick = function()
                if not teleportToOwnPlot() then
                    print("[Sakura] Teleport To Base: свой плот не найден")
                end
            end,
        },
        {
            title = "Teleport to Sell",
            desc = "К NPC продажи",
            type = "action",
            onClick = teleportToSell,
        },
        {
            title = "Teleport to Kick Station",
            desc = "В зону удара",
            type = "action",
            onClick = function()
                if not teleportToKick() then
                    print("[Sakura] Teleport to Kick Station: зона не найдена")
                end
            end,
        },
        {
            title = "Teleport to Shop",
            desc = "К магазину",
            type = "action",
            onClick = teleportToShop,
        },
    }
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
    local function getSpeedLevel()
        if speedService == nil then
            local ok, svc = pcall(function()
                return require(
                    game:GetService("ReplicatedStorage").Modules.ServicesLoader.SpeedServiceClient
                )
            end)
            speedService = ok and svc or false
        end
        return speedService and speedService.Level
    end

    local function refreshStats()
        local lp = Players.LocalPlayer
        local ls = lp:FindFirstChild("leaderstats")

        local cash = ls and ls:FindFirstChild("Cash")
        statLabels["Cash"].Text = "Cash: " .. (cash and fmt(cash.Value) or "—")

        local kp = lp:GetAttribute("SelectedKickPower")
        statLabels["Kick Power"].Text = "Kick Power: " .. (kp and fmt(kp) or "—")

        local speedLvl = getSpeedLevel()
        statLabels["Speed"].Text = "Speed: " .. (speedLvl and tostring(speedLvl) or "—")

        local reb = ls and ls:FindFirstChild("Rebirths")
        statLabels["Rebirths"].Text = "Rebirths: " .. (reb and tostring(reb.Value) or "—")
    end

    refreshStats()
    bind(RunService.Heartbeat, function()
        if page.Visible then refreshStats() end
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

        elseif f.type == "music" then

            card = createMusicCard(page, f.title, f.desc, key)

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
