--------------------------------------------------
-- QuickVolume v2.2
--------------------------------------------------

local L = QuickVolume_L

local addon = CreateFrame("Frame")

--------------------------------------------------
-- Settings
--------------------------------------------------

local BUTTON_SIZE = 28

local NORMAL_ICON =
    "Interface\\COMMON\\VoiceChat-Speaker"

local previousMasterVolume = 1

--------------------------------------------------
-- Utility
--------------------------------------------------

local function Clamp(value, minValue, maxValue)

    if value < minValue then
        return minValue
    elseif value > maxValue then
        return maxValue
    end

    return value
end


local function GetVolume(cvar)

    return tonumber(
        GetCVar(cvar)
    ) or 0

end


local function SetVolume(cvar, value)

    value =
        Clamp(
            value,
            0,
            1
        )

    SetCVar(
        cvar,
        value
    )

end


local function Percent(value)

    return math.floor(
        value * 100 + 0.5
    )

end


--------------------------------------------------
-- Main Button
--------------------------------------------------

local button =
    CreateFrame(
        "Button",
        "QuickVolumeButton",
        UIParent
    )

button:SetSize(
    BUTTON_SIZE,
    BUTTON_SIZE
)

button:SetPoint(
    "TOP",
    UIParent,
    "TOP",
    0,
    -10
)

button:SetMovable(true)
button:EnableMouse(true)

button:RegisterForDrag(
    "LeftButton"
)

button:SetClampedToScreen(true)

button:RegisterForClicks(
    "LeftButtonUp",
    "MiddleButtonUp"
)

--------------------------------------------------
-- Speaker Icon
--------------------------------------------------

local icon =
    button:CreateTexture(
        nil,
        "ARTWORK"
    )

icon:SetAllPoints()

icon:SetTexture(
    NORMAL_ICON
)

button.icon = icon

--------------------------------------------------
-- Mute X
--------------------------------------------------

local muteMark =
    button:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

muteMark:SetPoint(
    "CENTER",
    button,
    "CENTER",
    6,
    -5
)

muteMark:SetText(
    "|cffff3030X|r"
)

muteMark:Hide()

button.muteMark =
    muteMark

--------------------------------------------------
-- Update Speaker
--------------------------------------------------

local function UpdateSpeakerIcon()

    local volume =
        GetVolume(
            "Sound_MasterVolume"
        )

    icon:SetTexture(
        NORMAL_ICON
    )

    if volume <= 0 then

        icon:SetVertexColor(
            0.6,
            0.6,
            0.6,
            1
        )

        muteMark:Show()

    else

        icon:SetVertexColor(
            1,
            1,
            1,
            1
        )

        muteMark:Hide()

    end

end

--------------------------------------------------
-- Drag
--------------------------------------------------

button:SetScript(
    "OnDragStart",
    function(self)

        self:StartMoving()

    end
)

button:SetScript(
    "OnDragStop",
    function(self)

        self:StopMovingOrSizing()

    end
)

--------------------------------------------------
-- Basic Panel
--------------------------------------------------

local function CreatePanel(name)

    local frame =
        CreateFrame(
            "Frame",
            name,
            UIParent,
            "BackdropTemplate"
        )

    frame:SetFrameStrata(
        "DIALOG"
    )

    frame:SetBackdrop({

        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Tooltips\\UI-Tooltip-Border",

        edgeSize = 12,

        insets = {
            left = 3,
            right = 3,
            top = 3,
            bottom = 3
        }

    })

    frame:SetBackdropColor(
        0,
        0,
        0,
        0.65
    )

    return frame
end

--------------------------------------------------
-- Create +/- Button
--------------------------------------------------

local function CreateAdjustButton(
    parent,
    text,
    point,
    relativeTo,
    relativePoint,
    x,
    y,
    callback
)

    local btn =
        CreateFrame(
            "Button",
            nil,
            parent
        )

    btn:SetSize(
        24,
        20
    )

    btn:SetPoint(
        point,
        relativeTo,
        relativePoint,
        x,
        y
    )

    local label =
        btn:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalLarge"
        )

    label:SetPoint(
        "CENTER"
    )

    label:SetText(text)

    btn:SetScript(
        "OnClick",
        callback
    )

    btn:SetScript(
        "OnEnter",
        function()

            label:SetTextColor(
                1,
                1,
                1
            )

        end
    )

    btn:SetScript(
        "OnLeave",
        function()

            label:SetTextColor(
                1,
                0.82,
                0
            )

        end
    )

    return btn
end



--------------------------------------------------
-- Hover Panel
--------------------------------------------------

local hoverPanel =
    CreatePanel(
        "QuickVolumeHoverPanel"
    )

hoverPanel:SetSize(
    64,
    190
)


hoverPanel:Hide()

--------------------------------------------------
-- Smart Hover Panel Position
--------------------------------------------------

local function UpdateHoverPosition()

    local buttonX, buttonY =
        button:GetCenter()

    local screenHeight =
        UIParent:GetHeight()

    if not buttonX or not buttonY then
        return
    end

    hoverPanel:ClearAllPoints()

    --------------------------------------------------
    -- 图标在屏幕下半部
    -- 面板向上弹
    --------------------------------------------------

    if buttonY < screenHeight / 2 then

        hoverPanel:SetPoint(
            "BOTTOM",
            button,
            "TOP",
            0,
            4
        )

    --------------------------------------------------
    -- 图标在屏幕上半部
    -- 面板向下弹
    --------------------------------------------------

    else

        hoverPanel:SetPoint(
            "TOP",
            button,
            "BOTTOM",
            0,
            -4
        )

    end

end

--------------------------------------------------
-- Hover Title
--------------------------------------------------

local hoverTitle =
    hoverPanel:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalSmall"
    )

hoverTitle:SetPoint(
    "TOP",
    0,
    -10
)

hoverTitle:SetText(
    L.MASTER
)

--------------------------------------------------
-- Hover Percent
--------------------------------------------------

local hoverPercent =
    hoverPanel:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontHighlightSmall"
    )

hoverPercent:SetPoint(
    "BOTTOM",
    0,
    10
)

--------------------------------------------------
-- Hover Slider
--------------------------------------------------

local masterSlider =
    CreateFrame(
        "Slider",
        "QuickVolumeMasterSlider",
        hoverPanel,
        "OptionsSliderTemplate"
    )

masterSlider:SetOrientation(
    "VERTICAL"
)

masterSlider:SetSize(
    18,
    95
)

masterSlider:SetPoint(
    "CENTER",
    hoverPanel,
    "CENTER",
    0,
    0
)

masterSlider:SetMinMaxValues(
    0,
    1
)

masterSlider:SetValueStep(
    0.01
)

masterSlider:SetObeyStepOnDrag(
    true
)

--------------------------------------------------
-- Clear Default Labels
--------------------------------------------------

local sliderName =
    masterSlider:GetName()

if _G[sliderName .. "Low"] then
    _G[sliderName .. "Low"]:SetText("")
end

if _G[sliderName .. "High"] then
    _G[sliderName .. "High"]:SetText("")
end

if _G[sliderName .. "Text"] then
    _G[sliderName .. "Text"]:SetText("")
end

--------------------------------------------------
-- Update Hover
--------------------------------------------------

local function UpdateMasterSlider()

    local volume =
        GetVolume(
            "Sound_MasterVolume"
        )

    masterSlider:SetValue(
        volume
    )

    hoverPercent:SetText(
        Percent(volume)
        .. "%"
    )

    UpdateSpeakerIcon()

end

--------------------------------------------------
-- Hover - up
--------------------------------------------------

local hoverMinus =
    CreateAdjustButton(
        hoverPanel,
        "-",
        "BOTTOM",
        masterSlider,
        "TOP",
        0,
        4,

        function()

            local value =
                GetVolume(
                    "Sound_MasterVolume"
                )

            SetVolume(
                "Sound_MasterVolume",
                value - 0.01
            )

            UpdateMasterSlider()

        end
    )


--------------------------------------------------
-- Hover + buttom
--------------------------------------------------

local hoverPlus =
    CreateAdjustButton(
        hoverPanel,
        "+",
        "TOP",
        masterSlider,
        "BOTTOM",
        0,
        -4,

        function()

            local value =
                GetVolume(
                    "Sound_MasterVolume"
                )

            SetVolume(
                "Sound_MasterVolume",
                value + 0.01
            )

            UpdateMasterSlider()

        end
    )

--------------------------------------------------
-- Slider Change
--------------------------------------------------

masterSlider:SetScript(
    "OnValueChanged",
    function(self, value)

        SetVolume(
            "Sound_MasterVolume",
            value
        )

        hoverPercent:SetText(
            Percent(value)
            .. "%"
        )

        UpdateSpeakerIcon()

    end
)

--------------------------------------------------
-- Main Control Panel
--------------------------------------------------

local controlPanel =
    CreatePanel(
        "QuickVolumeControlPanel"
    )

controlPanel:SetSize(
    320,
    310
)

controlPanel:SetPoint(
    "CENTER"
)

controlPanel:SetMovable(true)
controlPanel:EnableMouse(true)

controlPanel:RegisterForDrag(
    "LeftButton"
)

controlPanel:Hide()

--------------------------------------------------
-- Panel Drag
--------------------------------------------------

controlPanel:SetScript(
    "OnDragStart",
    function(self)

        self:StartMoving()

    end
)

controlPanel:SetScript(
    "OnDragStop",
    function(self)

        self:StopMovingOrSizing()

    end
)

--------------------------------------------------
-- Panel Title
--------------------------------------------------

local panelTitle =
    controlPanel:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

panelTitle:SetPoint(
    "TOP",
    0,
    -15
)

panelTitle:SetText(
    L.TITLE
)

--------------------------------------------------
-- Close Button
--------------------------------------------------

local closeButton =
    CreateFrame(
        "Button",
        nil,
        controlPanel,
        "UIPanelCloseButton"
    )

closeButton:SetPoint(
    "TOPRIGHT",
    -3,
    -3
)

--------------------------------------------------
-- Channels
--------------------------------------------------

local channels = {

    {
        name = L.MASTER,
        cvar = "Sound_MasterVolume"
    },

    {
        name = L.MUSIC,
        cvar = "Sound_MusicVolume"
    },

    {
        name = L.SFX,
        cvar = "Sound_SFXVolume"
    },

    {
        name = L.DIALOG,
        cvar = "Sound_DialogVolume"
    }

}

local channelSliders = {}

--------------------------------------------------
-- Create Channel Slider
--------------------------------------------------

local function CreateVolumeSlider(
    parent,
    data,
    index
)

    local container =
        CreateFrame(
            "Frame",
            nil,
            parent
        )

    container:SetSize(
        65,
        175
    )

    container:SetPoint(
        "TOPLEFT",
        25 + ((index - 1) * 72),
        -50
    )

    --------------------------------------------------
    -- Title
    --------------------------------------------------

    local title =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormal"
        )

    title:SetPoint(
        "TOP",
        0,
        0
    )

    title:SetText(
        data.name
    )

    --------------------------------------------------
    -- Slider
    --------------------------------------------------

    local sliderName =
        "QuickVolumeSlider"
        .. index

    local slider =
        CreateFrame(
            "Slider",
            sliderName,
            container,
            "OptionsSliderTemplate"
        )

    slider:SetOrientation(
        "VERTICAL"
    )

    slider:SetSize(
        18,
        95
    )

    slider:SetPoint(
        "CENTER",
        container,
        "CENTER",
        0,
        0
    )

    slider:SetMinMaxValues(
        0,
        1
    )

    slider:SetValueStep(
        0.01
    )

    slider:SetObeyStepOnDrag(
        true
    )

    --------------------------------------------------
    -- Remove Default Text
    --------------------------------------------------

    if _G[sliderName .. "Low"] then
        _G[sliderName .. "Low"]:SetText("")
    end

    if _G[sliderName .. "High"] then
        _G[sliderName .. "High"]:SetText("")
    end

    if _G[sliderName .. "Text"] then
        _G[sliderName .. "Text"]:SetText("")
    end

    --------------------------------------------------
    -- Percentage
    --------------------------------------------------

    local percentText =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )

    percentText:SetPoint(
        "BOTTOM",
        0,
        0
    )

--------------------------------------------------
-- Output Device
--------------------------------------------------

local outputLabel =
    controlPanel:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormal"
    )

outputLabel:SetPoint(
    "BOTTOMLEFT",
    controlPanel,
    "BOTTOMLEFT",
    22,
    48
)

outputLabel:SetText(
    L.OUTPUT_DEVICE
)

--------------------------------------------------
-- Output Device Dropdown
--------------------------------------------------

local outputDropdown =
    CreateFrame(
        "DropdownButton",
        "QuickVolumeOutputDropdown",
        controlPanel,
        "WowStyle1DropdownTemplate"
    )

outputDropdown:SetPoint(
    "TOPLEFT",
    outputLabel,
    "BOTTOMLEFT",
    -4,
    -6
)

outputDropdown:SetWidth(
    275
)

--------------------------------------------------
-- Get Current Output Device
--------------------------------------------------

local function GetCurrentOutputDriverIndex()

    return tonumber(
        GetCVar(
            "Sound_OutputDriverIndex"
        )
    ) or 0

end

--------------------------------------------------
-- Apply Output Device
--------------------------------------------------

local function SetOutputDevice(index)

    SetCVar(
        "Sound_OutputDriverIndex",
        index
    )

    --------------------------------------------------
    -- Restart WoW Sound Engine
    --------------------------------------------------

    if Sound_GameSystem_RestartSoundSystem then

        Sound_GameSystem_RestartSoundSystem()

    end

end

--------------------------------------------------
-- Initialize Dropdown
--------------------------------------------------

local function SetupOutputDropdown()

    outputDropdown:SetupMenu(
        function(dropdown, rootDescription)

            local numDrivers = 0

            if Sound_GameSystem_GetNumOutputDrivers then

                numDrivers =
                    Sound_GameSystem_GetNumOutputDrivers()
                    or 0

            end

            local currentIndex =
                GetCurrentOutputDriverIndex()

            --------------------------------------------------
            -- Output Drivers
            --------------------------------------------------

            for index = 0, numDrivers - 1 do

                local driverName =
                    Sound_GameSystem_GetOutputDriverNameByIndex(
                        index
                    )

                if
                    driverName
                    and
                    driverName ~= ""
                then

                    rootDescription:CreateRadio(
                        driverName,

                        function()

                            return
                                GetCurrentOutputDriverIndex()
                                == index

                        end,

                        function()

                            SetOutputDevice(
                                index
                            )

                        end
                    )

                end

            end

        end
    )

end

SetupOutputDropdown()

--------------------------------------------------
-- Minus
-- 上方
--------------------------------------------------

local minusButton =
    CreateAdjustButton(
        container,
        "-",
        "BOTTOM",
        slider,
        "TOP",
        0,
        4,

        function()

            local value =
                GetVolume(
                    data.cvar
                )

            SetVolume(
                data.cvar,
                value - 0.01
            )

            local object =
                channelSliders[
                    data.cvar
                ]

            if object then

                object.slider:SetValue(
                    GetVolume(
                        data.cvar
                    )
                )

            end

        end
    )

--------------------------------------------------
-- Plus
-- 下方
--------------------------------------------------

local plusButton =
    CreateAdjustButton(
        container,
        "+",
        "TOP",
        slider,
        "BOTTOM",
        0,
        -4,

        function()

            local value =
                GetVolume(
                    data.cvar
                )

            SetVolume(
                data.cvar,
                value + 0.01
            )

            local object =
                channelSliders[
                    data.cvar
                ]

            if object then

                object.slider:SetValue(
                    GetVolume(
                        data.cvar
                    )
                )

            end

        end
    )

    --------------------------------------------------
    -- Slider Change
    --------------------------------------------------

    slider:SetScript(
        "OnValueChanged",
        function(self, value)

            SetVolume(
                data.cvar,
                value
            )

            percentText:SetText(
                Percent(value)
                .. "%"
            )

            if data.cvar ==
                "Sound_MasterVolume"
            then

                masterSlider:SetValue(
                    value
                )

                UpdateSpeakerIcon()

            end

        end
    )

    --------------------------------------------------
    -- Store
    --------------------------------------------------

    channelSliders[
        data.cvar
    ] = {

        slider =
            slider,

        percent =
            percentText,

        plus =
            plusButton,

        minus =
            minusButton
    }

end

--------------------------------------------------
-- Create Four Channels
--------------------------------------------------

for index, data
    in ipairs(channels)
do

    CreateVolumeSlider(
        controlPanel,
        data,
        index
    )

end

--------------------------------------------------
-- Update Control Panel
--------------------------------------------------

local function UpdateControlPanel()

    for _, data
        in ipairs(channels)
    do

        local object =
            channelSliders[
                data.cvar
            ]

        local value =
            GetVolume(
                data.cvar
            )

        object.slider:SetValue(
            value
        )

        object.percent:SetText(
            Percent(value)
            .. "%"
        )

    end

    UpdateSpeakerIcon()

end

--------------------------------------------------
-- Hover Show / Hide
--------------------------------------------------

local hideTimer

local function CancelHideTimer()

    if hideTimer then

        hideTimer:Cancel()

        hideTimer = nil

    end

end


local function ShowHoverPanel()

    if controlPanel:IsShown() then
        return
    end

    CancelHideTimer()

    ----------------------------------------------
    -- 根据喇叭当前位置重新决定弹出方向
    ----------------------------------------------

    UpdateHoverPosition()

    UpdateMasterSlider()

    hoverPanel:Show()

end


local function HideHoverDelayed()

    CancelHideTimer()

    hideTimer =
        C_Timer.NewTimer(
            0.35,

            function()

                if
                    not button:IsMouseOver()
                    and
                    not hoverPanel:IsMouseOver()
                then

                    hoverPanel:Hide()

                end

            end
        )

end

--------------------------------------------------
-- Hover Scripts
--------------------------------------------------

button:SetScript(
    "OnEnter",
    function()

        ShowHoverPanel()

    end
)

button:SetScript(
    "OnLeave",
    function()

        HideHoverDelayed()

    end
)

hoverPanel:SetScript(
    "OnEnter",
    function()

        CancelHideTimer()

    end
)

hoverPanel:SetScript(
    "OnLeave",
    function()

        HideHoverDelayed()

    end
)

hoverPanel:SetSize(
    64,
    190
)

hoverPanel:SetClampedToScreen(true)

hoverPanel:Hide()

--------------------------------------------------
-- Click
--------------------------------------------------

button:SetScript(
    "OnClick",
    function(self, mouseButton)

        --------------------------------------------------
        -- Left Click
        --------------------------------------------------

        if mouseButton ==
            "LeftButton"
        then

            hoverPanel:Hide()

            if
                controlPanel:IsShown()
            then

                controlPanel:Hide()

            else

                UpdateControlPanel()

                controlPanel:Show()

            end

        --------------------------------------------------
        -- Middle Click
        --------------------------------------------------

        elseif mouseButton ==
            "MiddleButton"
        then

            local currentVolume =
                GetVolume(
                    "Sound_MasterVolume"
                )

            if currentVolume > 0 then

                previousMasterVolume =
                    currentVolume

                SetVolume(
                    "Sound_MasterVolume",
                    0
                )

            else

                if
                    previousMasterVolume <= 0
                then

                    previousMasterVolume =
                        1
                end

                SetVolume(
                    "Sound_MasterVolume",
                    previousMasterVolume
                )

            end

            UpdateMasterSlider()
            UpdateControlPanel()

        end

    end
)

--------------------------------------------------
-- Mouse Wheel
--------------------------------------------------

button:EnableMouseWheel(true)

button:SetScript(
    "OnMouseWheel",
    function(self, delta)

        local volume =
            GetVolume(
                "Sound_MasterVolume"
            )

        volume =
            volume +
            delta * 0.05

        SetVolume(
            "Sound_MasterVolume",
            volume
        )

        UpdateMasterSlider()

        if
            controlPanel:IsShown()
        then

            UpdateControlPanel()

        end

    end
)

--------------------------------------------------
-- Tooltip
--------------------------------------------------

button:SetScript(
    "OnEnter",
    function(self)

        ShowHoverPanel()

        GameTooltip:SetOwner(
            self,
            "ANCHOR_LEFT"
        )

        GameTooltip:AddLine(
            L.TITLE
        )

        GameTooltip:AddLine(
            L.TOOLTIP_LEFT,
            1,
            1,
            1
        )

        GameTooltip:AddLine(
            L.TOOLTIP_MIDDLE,
            1,
            1,
            1
        )

        GameTooltip:AddLine(
            L.TOOLTIP_WHEEL,
            1,
            1,
            1
        )

        GameTooltip:Show()

    end
)

button:HookScript(
    "OnLeave",
    function()

        GameTooltip:Hide()

    end
)

--------------------------------------------------
-- Login
--------------------------------------------------

addon:RegisterEvent(
    "PLAYER_LOGIN"
)

addon:SetScript(
    "OnEvent",
    function()

        local volume =
            GetVolume(
                "Sound_MasterVolume"
            )

        if volume > 0 then

            previousMasterVolume =
                volume
        end

        UpdateSpeakerIcon()

    end
)