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
SakuraPink       = Color3.fromRGB(255, 104, 156),  
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

local ICON_URLS = {
    home = "https://img.icons8.com/material-rounded/24/ffffff/home.png",
    player = "https://img.icons8.com/material-rounded/24/ffffff/user.png",
    farm = "https://img.icons8.com/material-rounded/24/ffffff/flash-on.png",
    misc = "https://img.icons8.com/material-rounded/24/ffffff/more.png",
    settings = "https://img.icons8.com/material-rounded/24/ffffff/settings.png",
    teleport = "https://img.icons8.com/material-rounded/24/ffffff/near-me.png",
    collapse = "https://img.icons8.com/material-rounded/24/ffffff/chevron-left.png",
    chevron_right = "https://img.icons8.com/material-rounded/24/ffffff/chevron-right.png",
    close = "https://img.icons8.com/material-rounded/24/ffffff/multiply.png",
    minimize = "https://img.icons8.com/material-rounded/24/ffffff/minus.png",
    brand_logo = "https://raw.githubusercontent.com/genjutsu-one/sakuramenu/main/file_000000001c7481f48fc3b980f109afe6.png",
    floating_button = "https://raw.githubusercontent.com/genjutsu-one/sakuramenu/main/file_0000000001308210b2a1abcfd640b720.png",
}

local assetCache = {}

local function getCachedAsset(name, url)
    local setter = getcustomasset or getsynasset
    if not setter or not writefile or not game.HttpGet then return nil end
    if assetCache[name] then return assetCache[name] end

    local folder = CONFIG_FOLDER .. "/assets"
    local path = folder .. "/" .. name .. ".png"
    pcall(function()
        if makefolder and isfolder and not isfolder(CONFIG_FOLDER) then
            makefolder(CONFIG_FOLDER)
        end
        if makefolder and isfolder and not isfolder(folder) then
            makefolder(folder)
        end
    end)

    local exists = false
    if isfile then
        local ok, result = pcall(isfile, path)
        exists = ok and result
    end
    if not exists then
        local ok, data = pcall(function() return game:HttpGet(url) end)
        if not ok or type(data) ~= "string" then return nil end
        local a, b, c, d = string.byte(data, 1, 4)
        if a ~= 137 or b ~= 80 or c ~= 78 or d ~= 71 then return nil end
        local written = pcall(writefile, path, data)
        if not written then return nil end
    end

    local ok, asset = pcall(setter, path)
    if ok then
        assetCache[name] = asset
        return asset
    end
    return nil
end

local function materialImage(kind, parent, size, tint)
    local url = ICON_URLS[kind]
    local image = url and getCachedAsset(kind .. "_white", url)
    if not image then return nil end

    local img = Instance.new("ImageLabel")
    img.Name = kind .. "Icon"
    img.Size = UDim2.fromOffset(size, size)
    img.BackgroundTransparency = 1
    img.Image = image
    img.ImageColor3 = tint or CONFIG.AccentColor
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = parent
    if kind == "brand_logo" then
        corner(math.max(3, math.floor(size * 0.18)), img)
    end
    return img
end

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

if kind ~= "home" then
    local imageIcon = materialImage(kind == "logo" and "brand_logo" or kind, parent, size, CONFIG.AccentColor)
    if imageIcon then return imageIcon end
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
    for i = 1, 3 do
        corner(size, newFrame({
            Size = UDim2.fromOffset(size * 0.18, size * 0.18),
            Position = UDim2.new((i - 1) * 0.32 + 0.18, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = W,
        }, holder))
    end

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
    local scale = size / 24
    local thickness = math.max(1.2, size * 2 / 24)

    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        local length = math.sqrt(dx * dx + dy * dy) * scale
        local segment = newFrame({
            Size = UDim2.fromOffset(length, thickness),
            Position = UDim2.new(
                0.5,
                ((x1 + x2) * 0.5 - 12) * scale,
                0.5,
                ((y1 + y2) * 0.5 - 12) * scale
            ),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)),
            BackgroundColor3 = W,
        }, holder)
        corner(thickness, segment)
    end

    line(3.7, 9.4, 10.7, 3.4)
    line(13.3, 3.4, 20.3, 9.4)
    line(3, 10, 3, 19)
    line(21, 10, 21, 19)
    line(5, 21, 19, 21)
    line(9, 13, 9, 20)
    line(9, 12, 14, 12)
    line(15, 13, 15, 20)

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

        local petal = corner(size, newFrame({
            Size = UDim2.fromOffset(size * 0.3, size * 0.46),
            Position = UDim2.new(
                0.5,
                math.sin(rad) * size * 0.19,
                0.5,
                -math.cos(rad) * size * 0.19
            ),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = angle,
            BackgroundColor3 = W,
        }, holder))

        local glow = Instance.new("UIStroke")
        glow.Color = W
        glow.Transparency = 0.35
        glow.Thickness = 1.2
        glow.Parent = petal
    end

    -- сердцевина
    corner(size, newFrame({
        Size = UDim2.fromOffset(size * 0.24, size * 0.24),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = W,
        ZIndex = 2,
    }, holder))

end  

return holder

end

local function drawCross(parent, size, color, rot1, rot2)
local holder = iconHolder(parent, size)

local imageIcon = materialImage(rot2 and "close" or "minimize", holder, size, color)
if imageIcon then return holder end

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

local imageIcon = materialImage("chevron_right", holder, size, CONFIG.AccentColor)
if imageIcon then return holder end

local iconColor = CONFIG.AccentColor

corner(size, newFrame({  
    Size = UDim2.fromOffset(size * 0.55, size * 0.16),  
    Position = UDim2.new(0.5, 0, 0.5, -size * 0.18),  
    AnchorPoint = Vector2.new(0.5, 0.5),  
    Rotation = 45,  
    BackgroundColor3 = iconColor,  
}, holder))  

corner(size, newFrame({  
    Size = UDim2.fromOffset(size * 0.55, size * 0.16),  
    Position = UDim2.new(0.5, 0, 0.5, size * 0.18),  
    AnchorPoint = Vector2.new(0.5, 0.5),  
    Rotation = -45,  
    BackgroundColor3 = iconColor,  
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
local EVENT_MUSIC = {
    { name = "Disco", source = "Disco" },
    { name = "TM Opera O", source = "TM Opera O" },
    { name = "Meni Shuki Rush", source = "Meni Shuki♡Rush-sh!" },
}

local function findEventMusic(track)
    local function findIn(root)
        if not root then return nil end
        if root:IsA("Sound") and root.SoundId ~= "" then return root end
        local sounds = {}
        for _, descendant in ipairs(root:GetDescendants()) do
            if descendant:IsA("Sound") and descendant.SoundId ~= "" then
                table.insert(sounds, descendant)
            end
        end
        table.sort(sounds, function(a, b)
            local aPreferred = string.find(string.lower(a.Name), "music", 1, true)
                or string.find(string.lower(a.Name), "song", 1, true)
            local bPreferred = string.find(string.lower(b.Name), "music", 1, true)
                or string.find(string.lower(b.Name), "song", 1, true)
            return aPreferred and not bPreferred
        end)
        return sounds[1]
    end

    local soundService = game:GetService("SoundService")
    local source = findIn(soundService:FindFirstChild(track.source))
    if source then return source end

    local replicatedStorage = game:GetService("ReplicatedStorage")
    return findIn(replicatedStorage:FindFirstChild(track.source, true))
end

local activeEventMusic
local activeEventMusicCleanup

local function playEventMusic(track)
    local source = findEventMusic(track)
    if not source then
        print("[FuckCM] Event music is not loaded: " .. track.name)
        return false
    end

    local okController, musicController = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ControllerLoader.MusicController)
    end)
    if not okController then
        print("[FuckCM] MusicController is unavailable")
        return false
    end

    if activeEventMusicCleanup then
        pcall(activeEventMusicCleanup)
        activeEventMusicCleanup = nil
    end
    if activeEventMusic then
        activeEventMusic:Stop()
        activeEventMusic:Destroy()
        activeEventMusic = nil
    end

    local originalPlaylist = game:GetService("SoundService"):FindFirstChild(track.source)
    if originalPlaylist then
        if originalPlaylist:IsA("Sound") then
            originalPlaylist:Stop()
        else
            for _, descendant in ipairs(originalPlaylist:GetDescendants()) do
                if descendant:IsA("Sound") then descendant:Stop() end
            end
        end
    end

    local okStart, startCustom, cleanup = pcall(function()
        return musicController:StartCustom()
    end)
    if not okStart or type(startCustom) ~= "function" then return false end

    local sound = source:Clone()
    sound.Name = "FuckCMEventMusic"
    sound.Looped = true
    sound.Parent = game:GetService("SoundService")
    local okPlay = pcall(startCustom, sound)
    if not okPlay then
        sound:Destroy()
        return false
    end

    activeEventMusic = sound
    activeEventMusicCleanup = cleanup
    print("[FuckCM] Music: " .. track.name)
    return true
end

local function stopEventMusic()
    if activeEventMusicCleanup then
        pcall(activeEventMusicCleanup)
        activeEventMusicCleanup = nil
    end
    if activeEventMusic then
        activeEventMusic:Stop()
        activeEventMusic:Destroy()
        activeEventMusic = nil
    end
end

local function createMusicCard(parent, title, desc, key)
    local saved = SavedState.controls[key] or {}
    local card = newFrame({
        Name = "MusicCard",
        Size = UDim2.new(1, 0, 0, CARD_H),
        BackgroundColor3 = CONFIG.CardColor,
        ClipsDescendants = true,
    }, parent)
    corner(8, card)
    stroke(card, CONFIG.AccentColor, 0.9, 1)

    newLabel({
        Text = title,
        Position = UDim2.new(0, 14, 0, 0),
        Size = UDim2.new(0.42, -14, 0, CARD_H),
        TextXAlignment = Enum.TextXAlignment.Left,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, card)

    local selectedName = saved.event or "Choose event track"
    local selector = newButton({
        Name = "MusicDropdown",
        Size = UDim2.new(0.54, -4, 0, 30),
        Position = UDim2.new(1, -10, 0, 9),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = CONFIG.BgColor,
        ZIndex = 2,
    }, card)
    corner(6, selector)
    stroke(selector, CONFIG.AccentColor, 0.85, 1)
    local selectedLabel = newLabel({
        Text = selectedName,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -34, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextSize = 12,
        TextTruncate = Enum.TextTruncate.AtEnd,
        ZIndex = 3,
    }, selector)
    local arrow = drawIcon("chevron_right", newFrame({
        Size = UDim2.fromOffset(16, 16),
        Position = UDim2.new(1, -22, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ZIndex = 3,
    }, selector), 16)

    local optionList = newFrame({
        Name = "MusicOptions",
        Size = UDim2.new(1, -20, 0, #EVENT_MUSIC * 34),
        Position = UDim2.new(0, 10, 0, CARD_H),
        BackgroundTransparency = 1,
    }, card)
    local expanded = false
    selector.MouseButton1Click:Connect(function()
        expanded = not expanded
        tween(card, 0.18, {
            Size = UDim2.new(1, 0, 0, expanded and CARD_H + #EVENT_MUSIC * 34 + 6 or CARD_H),
        })
        tween(arrow, 0.18, { Rotation = expanded and 90 or 0 })
    end)

    for index, track in ipairs(EVENT_MUSIC) do
        local option = newButton({
            Name = "TrackOption",
            Size = UDim2.new(1, 0, 0, 30),
            Position = UDim2.new(0, 0, 0, (index - 1) * 34),
            BackgroundColor3 = CONFIG.BgColor,
        }, optionList)
        corner(6, option)
        newLabel({
            Text = track.name,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextSize = 12,
            TextTruncate = Enum.TextTruncate.AtEnd,
        }, option)
        option.MouseButton1Click:Connect(function()
            if playEventMusic(track) then
                selectedLabel.Text = track.name
                saveField(key, "event", track.name)
                expanded = false
                tween(card, 0.18, { Size = UDim2.new(1, 0, 0, CARD_H) })
                tween(arrow, 0.18, { Rotation = 0 })
            end
        end)
    end

    return card
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
    local kickEvent

    local function isActive(id) return active and token == id end

    local function status(message)
        print("[FuckCM] Auto Kick: " .. message)
    end

    local function waitFor(id, condition, timeout)
        local started = os.clock()
        while isActive(id) do
            if condition() then return true end
            if timeout and os.clock() - started >= timeout then return false end
            RunService.Heartbeat:Wait()
        end
        return false
    end

    local function getKickEvent()
        if kickEvent then return kickEvent end
        local ok, result = pcall(function()
            return game:GetService("ReplicatedStorage")
                :WaitForChild("Shared", 5)
                :WaitForChild("Packages", 5)
                :WaitForChild("Network", 5)
                :WaitForChild("rev_KickEvent", 5)
        end)
        if ok and result and result:IsA("RemoteEvent") then
            kickEvent = result
        end
        return kickEvent
    end

    local function getKickButton()
        local hud = PlayerGui:FindFirstChild("HUD")
        return hud and hud:FindFirstChild("KickButton")
    end

    local function busy()
        return lp:GetAttribute("LocalKickBusy") == true
            or lp:GetAttribute("IsKicking") == true
    end

    local function ready()
        local button = getKickButton()
        return button ~= nil and button.Visible and not busy()
    end

    local function getCharacterParts()
        local character = lp.Character
        return character and character:FindFirstChildOfClass("Humanoid"),
            character and character:FindFirstChild("HumanoidRootPart")
    end

    local function nearKickZone()
        local _, root = getCharacterParts()
        local areas = workspace:FindFirstChild("Areas")
        local zone = areas and areas:FindFirstChild("KickReady")
        return not (zone and root) or (root.Position - zone.Position).Magnitude <= 20
    end

    local function cameraFree()
        local humanoid = getCharacterParts()
        local camera = workspace.CurrentCamera
        return humanoid ~= nil and camera.CameraSubject == humanoid
            and camera.CameraType == Enum.CameraType.Custom
    end

    local function startKick(id, kickGui)
        local event = getKickEvent()
        if not event then
            status("rev_KickEvent not found")
            return false
        end
        if not isActive(id) or not ready() then return busy() or kickGui.Enabled end

        local ok, err = pcall(function()
            event:FireServer(1)
        end)
        local started = waitFor(id, function()
            return busy() or kickGui.Enabled
        end, 1.5)
        if not ok then status(tostring(err)) end
        return started
    end

    local function waitKickCycle(id)
        local startedAt = os.clock()
        local sawAnchor = false
        local returnedToZone = false

        while isActive(id) and busy() do
            local _, root = getCharacterParts()
            if root then
                if root.Anchored then sawAnchor = true end
                local released = sawAnchor and not root.Anchored and cameraFree()
                local timedOut = os.clock() - startedAt > 45
                if not returnedToZone and (released or timedOut) then
                    status(released and "cycle complete, returning to station" or "cycle timeout, returning to station")
                    task.wait(0.4)
                    teleportToKick()
                    returnedToZone = true
                end
            end
            RunService.Heartbeat:Wait()
        end
    end

    local function loop(id)
        local kickGui = PlayerGui:WaitForChild("KickMinigame")
        if not getKickEvent() then
            status("rev_KickEvent not found")
            return
        end

        while isActive(id) do
            if busy() then
                waitKickCycle(id)
            elseif not nearKickZone() then
                status("teleporting to kick station")
                teleportToKick()
                waitFor(id, ready, 3)
            elseif ready() then
                if not startKick(id, kickGui) then
                    status("kick did not start")
                    waitFor(id, function() return false end, 1)
                else
                    waitKickCycle(id)
                end
            else
                RunService.Heartbeat:Wait()
            end
        end
    end

    KickHandlers = {
        onToggle = function(state)
            active = state
            token = token + 1
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

-- Visits slots 1-30 in order and upgrades each occupied slot once.
local function runUmaUpgradePass()
    local net = getNetwork()
    if not net then return end
    local plot = getOwnPlotModel()
    local slotsFolder = plot and plot:FindFirstChild("Slots")
    local buttons = plot and plot:FindFirstChild("Buttons")
    if not (slotsFolder and buttons) then return end
    local ev = net:WaitForChild("rev_B_Upgrade", 5)

    local lp = Players.LocalPlayer
    for i = 1, 30 do
        local slot = slotsFolder:FindFirstChild("Slot" .. i)
        local target = buttons:FindFirstChild("Slot" .. i) or slot
        local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if root and target and target:IsA("BasePart") then
            root.CFrame = target.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)
        end
        if slot and slot:FindFirstChildOfClass("Part") then
            ev:FireServer(i)
        end
        task.wait(0.1)
    end
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

local function teleportToWeightShop()
    local touchPart = findFirst(workspace, "Shops", "WeightShop", "TouchPart")
    if not (touchPart and touchPart:IsA("BasePart")) then
        touchPart = findFirst(workspace, "Shops", "WeightShop")
        if touchPart and not touchPart:IsA("BasePart") then
            touchPart = touchPart:FindFirstChildWhichIsA("BasePart", true)
        end
    end

    local root = Players.LocalPlayer.Character
        and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (touchPart and root) then
        print("[FuckCM] WeightShop.TouchPart not found")
        return false
    end

    root.CFrame = touchPart.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.25)
    local frames = PlayerGui:FindFirstChild("Frames")
    local weightUi = frames and frames:FindFirstChild("WeightUI")
    if weightUi then weightUi.Visible = true end
    return true
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

local AutoBuyWeightHandlers = makeLoopToggle("Auto Buy Silver Weight", function()
    local ok, weightService = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ServicesLoader.WeightServiceClient)
    end)
    if ok and type(weightService.Owned) == "table"
        and table.find(weightService.Owned, "Silver Weight") then
        return
    end

    if not teleportToWeightShop() then return end
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_Shop_Buy", 5):FireServer("WeightShop", "Silver Weight")
end, 8)

local AutoRebirthHandlers
do
    local lastRequestedLevel = -1
    local lastRequestAt = 0
    AutoRebirthHandlers = makeLoopToggle("Auto Rebirth", function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local okRebirth, rebirthService = pcall(function()
            return require(replicatedStorage.Modules.ServicesLoader.RebirthServiceClient)
        end)
        local okKick, kickService = pcall(function()
            return require(replicatedStorage.Modules.ServicesLoader.KickServiceClient)
        end)
        local okData, rebirthData = pcall(function()
            return require(replicatedStorage.Shared.Data.RebirthData)
        end)
        if not (okRebirth and okKick and okData) then return end

        local level = rebirthService.RebirthLevel or 0
        local requirement = rebirthData:GetKickRequirement(level + 1)
        if (tonumber(kickService.Level) or 0) < requirement then return end
        if level == lastRequestedLevel and os.clock() - lastRequestAt < 15 then return end

        local net = getNetwork()
        if not net then return end
        net:WaitForChild("rev_RebirthRequest", 5):FireServer()
        lastRequestedLevel = level
        lastRequestAt = os.clock()
    end, 2)
end

local AutoPlotUpgradeHandlers = makeLoopToggle("Auto Plot Upgrade", function()
    local ok, upgrades = pcall(function()
        return require(game:GetService("ReplicatedStorage").Modules.ServicesLoader.BaseUpgradesServiceClient)
    end)
    if not ok or upgrades.AddedSlots >= upgrades.MAX_SLOTS then return end

    local net = getNetwork()
    if not net then return end
    net:WaitForChild("rev_bs_upgrade", 5):FireServer()
end, 2)

-- продаёт всех Umas одним вызовом; телепортируется к NPC SellUma,
-- т.к. сервер может проверять близость к точке продажи
local SellAllHandlers = makeLoopToggle("Sell All Umas", function()
    local net = getNetwork()
    if not net then return end
    net:WaitForChild("ref_B_SellAll"):InvokeServer()
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
    teleportToWeightShop()
end

local function rejoinServer()
    local teleportService = game:GetService("TeleportService")
    local player = Players.LocalPlayer
    local ok, err = pcall(function()
        teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end)
    if not ok then
        warn("[Sakura] Rejoin Server failed: " .. tostring(err))
        pcall(teleportService.Teleport, teleportService, game.PlaceId, player)
    end
end

-- ============================================================
-- FPS BOOST / ANTI-AFK
-- ============================================================
local FpsBoostHandlers = {
    onToggle = function(state)
        local lighting = game:GetService("Lighting")
        lighting.GlobalShadows = not state
        pcall(function()
            settings().Rendering.QualityLevel = state
                and Enum.QualityLevel.Level01
                or Enum.QualityLevel.Automatic
        end)
        if setfpscap then
            pcall(setfpscap, state and 240 or 60)
        end
        print("[Sakura] FPS Boost: " .. tostring(state))
    end,
}

local AntiAfkHandlers
do
    local VirtualUser = game:GetService("VirtualUser")
    local lp = Players.LocalPlayer
    local conn
    AntiAfkHandlers = {
        onToggle = function(state)
            if conn then
                conn:Disconnect()
                conn = nil
            end
            if state then
                conn = lp.Idled:Connect(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end,
    }
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
            title = "Auto Buy Silver Weight",
            handlers = AutoBuyWeightHandlers
        },
        {
            title = "Auto Rebirth",
            handlers = AutoRebirthHandlers
        },
        {
            title = "Auto Plot Upgrade",
            handlers = AutoPlotUpgradeHandlers
        },
        {
            title = "Sell All Umas",
            handlers = SellAllHandlers
        },
    },
},
{
    id = "misc",
    name = "Misc",
    funcs = {
        { title = "Set Music", type = "music" },
        { title = "FPS Boost", handlers = FpsBoostHandlers },
        { title = "Anti-AFK", handlers = AntiAfkHandlers },
        { title = "Rejoin Server", type = "action", onClick = rejoinServer },
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

BackgroundTransparency = CONFIG.Transparency,  

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
    Size = UDim2.fromOffset(36, 36),
    Position = UDim2.new(0, 16, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundTransparency = 1,
}, TopBar)

local logoIcon = drawIcon("logo", logoHolder, 36)

local titleLabel = newLabel({
    Text = "FuckCM",
    Position = UDim2.new(0, 62, 0, 0),
    Size = UDim2.new(0, 140, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = CONFIG.SakuraPink,
}, TopBar)
attachShimmer(titleLabel, Color3.fromRGB(255, 78, 139), Color3.fromRGB(255, 224, 235), 4.2)

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
    local sT = SavedState.controls["settings_transparency"]
    local sS =  
        SavedState.controls[  
            "settings_size"  
        ]  

    createPercentRow(
        page,
        "Transparency",
        {50, 60, 70, 80, 90, 100},
        (sT and sT.value) or 50,
        function(val)
            CONFIG.Transparency = 1 - (val / 100)
            MainFrame.BackgroundTransparency = CONFIG.Transparency
            SavedState.controls["settings_transparency"] = { value = val }
            SaveConfig()
        end
    ).LayoutOrder = 1

    createPercentRow(  
        page,  
        "Window Size",  
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
    local kickService
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

    local function getKickPowerValue()
        if kickService == nil then
            local ok, service = pcall(function()
                return require(
                    game:GetService("ReplicatedStorage").Modules.ServicesLoader.KickServiceClient
                )
            end)
            kickService = ok and service or false
        end
        if kickService then
            local level = tonumber(kickService.Level)
            if level then return level end
        end
        return Players.LocalPlayer:GetAttribute("SelectedKickPower")
    end

    local function refreshStats()
        local lp = Players.LocalPlayer
        local ls = lp:FindFirstChild("leaderstats")

        local cash = ls and ls:FindFirstChild("Cash")
        statLabels["Cash"].Text = "Cash: " .. (cash and fmt(cash.Value) or "—")

        local kp = getKickPowerValue()
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

local floatingImage = getCachedAsset("floating_button", ICON_URLS.floating_button)
if floatingImage then
    local image = Instance.new("ImageLabel")
    image.Name = "BrandImage"
    image.Size = UDim2.fromScale(1, 1)
    image.BackgroundTransparency = 1
    image.Image = floatingImage
    image.ScaleType = Enum.ScaleType.Fit
    image.ZIndex = 3
    image.Parent = FloatBtn
else
    newLabel({
        Text = "F",
        Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.GothamBlack,
        TextSize = 20,
        TextColor3 = CONFIG.SakuraPink,
        ZIndex = 3,
    }, FloatBtn)
end

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

                BackgroundTransparency = CONFIG.Transparency,
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
    AutoTrainingHandlers.onToggle(false)
    SpeedUpgradeHandlers.onToggle(false)
    AutoUpgradeHandlers.onToggle(false)
    stopEventMusic()

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

BackgroundTransparency = CONFIG.Transparency,  
},  
Enum.EasingStyle.Back

)
