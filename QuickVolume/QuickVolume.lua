--------------------------------------------------
-- QuickVolume
--------------------------------------------------

local L = QuickVolume_L or {}

local addon =
    CreateFrame("Frame")

--------------------------------------------------
-- Constants
--------------------------------------------------

local BUTTON_SIZE = 28

local NORMAL_ICON =
    "Interface\\COMMON\\VoiceChat-Speaker"

local PANEL_ALPHA = 0.65

local previousMasterVolume = 1

--------------------------------------------------
-- NDui Detection
--------------------------------------------------

local NDUI_ENABLED =
    C_AddOns.IsAddOnLoaded("NDui")

--------------------------------------------------
-- Slider Template
--
-- NDui:
--   plain slider, NDui.lua draws everything
--
-- Default:
--   Blizzard OptionsSliderTemplate
--------------------------------------------------

local SLIDER_TEMPLATE

if NDUI_ENABLED then
    SLIDER_TEMPLATE = nil
else
    SLIDER_TEMPLATE =
        "OptionsSliderTemplate"
end

--------------------------------------------------
-- Localization Fallback
--------------------------------------------------

local TEXT_TITLE =
    L.TITLE or "QuickVolume"

local TEXT_MASTER =
    L.MASTER or "Master"

local TEXT_MUSIC =
    L.MUSIC or "Music"

local TEXT_SFX =
    L.SFX or "SFX"

local TEXT_DIALOG =
    L.DIALOG or "Dialog"

local TEXT_OUTPUT_DEVICE =
    L.OUTPUT_DEVICE or "Output Device"

local TEXT_TOOLTIP_LEFT =
    L.TOOLTIP_LEFT
    or
    "Left Click: Volume panel"

local TEXT_TOOLTIP_MIDDLE =
    L.TOOLTIP_MIDDLE
    or
    "Middle Click: Mute / Unmute"

local TEXT_TOOLTIP_WHEEL =
    L.TOOLTIP_WHEEL
    or
    "Mouse Wheel: Master volume"

--------------------------------------------------
-- Utility
--------------------------------------------------

local function Clamp(
    value,
    minValue,
    maxValue
)

    if value < minValue then
        return minValue
    end

    if value > maxValue then
        return maxValue
    end

    return value

end

local function GetVolume(cvar)

    return
        tonumber(
            GetCVar(cvar)
        )
        or
        0

end

local function SetVolume(
    cvar,
    value
)

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

    return
        math.floor(
            value * 100 + 0.5
        )

end

--------------------------------------------------
-- Main Speaker Button
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
-- Mute Mark
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
-- Dragging
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
-- Panel Creator
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
        PANEL_ALPHA
    )

    return frame

end

--------------------------------------------------
-- +/- Button Creator
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

    label:SetText(
        text
    )

    btn.label =
        label

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
    200
)

hoverPanel:SetClampedToScreen(
    true
)

hoverPanel:Hide()

--------------------------------------------------
-- Hover Position
--------------------------------------------------

local function UpdateHoverPosition()

    local buttonX,
          buttonY =
        button:GetCenter()

    local screenHeight =
        UIParent:GetHeight()

    if
        not buttonX
        or
        not buttonY
    then
        return
    end

    hoverPanel:ClearAllPoints()

    --------------------------------------------------
    -- Bottom half:
    -- open upward
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
    -- Top half:
    -- open downward
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
    TEXT_MASTER
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
-- Hover Master Slider
--------------------------------------------------

local masterSlider

if SLIDER_TEMPLATE then

    masterSlider =
        CreateFrame(
            "Slider",
            "QuickVolumeMasterSlider",
            hoverPanel,
            SLIDER_TEMPLATE
        )

else

    masterSlider =
        CreateFrame(
            "Slider",
            "QuickVolumeMasterSlider",
            hoverPanel
        )

end

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
-- Clear Blizzard Slider Labels
--------------------------------------------------

if SLIDER_TEMPLATE then

    local sliderName =
        masterSlider:GetName()

    if sliderName then

        if _G[sliderName .. "Low"] then

            _G[
                sliderName .. "Low"
            ]:SetText("")

        end

        if _G[sliderName .. "High"] then

            _G[
                sliderName .. "High"
            ]:SetText("")

        end

        if _G[sliderName .. "Text"] then

            _G[
                sliderName .. "Text"
            ]:SetText("")

        end

    end

end

--------------------------------------------------
-- Update Master Slider
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
        ..
        "%"
    )

    UpdateSpeakerIcon()

end

--------------------------------------------------
-- Hover -
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
-- Hover +
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
-- Master Slider Callback
--------------------------------------------------

masterSlider:SetScript(
    "OnValueChanged",
    function(
        self,
        value
    )

        SetVolume(
            "Sound_MasterVolume",
            value
        )

        hoverPercent:SetText(
            Percent(value)
            ..
            "%"
        )

        UpdateSpeakerIcon()

    end
)

--------------------------------------------------
-- Full Control Panel
--------------------------------------------------

local controlPanel =
    CreatePanel(
        "QuickVolumeControlPanel"
    )

controlPanel:SetSize(
    320,
    330
)

controlPanel:SetPoint(
    "CENTER"
)

controlPanel:SetMovable(
    true
)

controlPanel:EnableMouse(
    true
)

controlPanel:RegisterForDrag(
    "LeftButton"
)

controlPanel:SetClampedToScreen(
    true
)

controlPanel:Hide()

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
-- Main Panel Title
--------------------------------------------------

local title =
    controlPanel:CreateFontString(
        nil,
        "OVERLAY",
        "GameFontNormalLarge"
    )

title:SetPoint(
    "TOP",
    0,
    -12
)

title:SetText(
    TEXT_TITLE
)

--------------------------------------------------
-- Close Button
--------------------------------------------------

local closeButton =
    CreateFrame(
        "Button",
        "QuickVolumeControlPanelCloseButton",
        controlPanel,
        "UIPanelCloseButton"
    )

closeButton:SetPoint(
    "TOPRIGHT",
    controlPanel,
    "TOPRIGHT",
    -2,
    -2
)

--------------------------------------------------
-- Volume Channels
--------------------------------------------------

local channels = {

    {
        name = TEXT_MASTER,
        cvar =
            "Sound_MasterVolume"
    },

    {
        name = TEXT_MUSIC,
        cvar =
            "Sound_MusicVolume"
    },

    {
        name = TEXT_SFX,
        cvar =
            "Sound_SFXVolume"
    },

    {
        name = TEXT_DIALOG,
        cvar =
            "Sound_DialogVolume"
    }

}

local channelSliders = {}

--------------------------------------------------
-- Build Volume Columns
--------------------------------------------------

for index,
    data
in ipairs(channels)
do

    local container =
        CreateFrame(
            "Frame",
            nil,
            controlPanel
        )

    container:SetSize(
        65,
        185
    )

    container:SetPoint(
        "TOPLEFT",
        controlPanel,
        "TOPLEFT",
        18
        +
        (
            index - 1
        )
        *
        72,
        -45
    )

    --------------------------------------------------
    -- Channel Name
    --------------------------------------------------

    local channelName =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalSmall"
        )

    channelName:SetPoint(
        "TOP",
        0,
        0
    )

    channelName:SetText(
        data.name
    )

    --------------------------------------------------
    -- Slider
    --------------------------------------------------

    local slider

    if SLIDER_TEMPLATE then

        slider =
            CreateFrame(
                "Slider",
                nil,
                container,
                SLIDER_TEMPLATE
            )

    else

        slider =
            CreateFrame(
                "Slider",
                nil,
                container
            )

    end

    slider:SetOrientation(
        "VERTICAL"
    )

    slider:SetSize(
        18,
        120
    )

    slider:SetPoint(
        "TOP",
        container,
        "TOP",
        0,
        -40
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
    -- -
    --------------------------------------------------

    local minusButton =
        CreateAdjustButton(
            container,
            "-",
            "BOTTOM",
            slider,
            "TOP",
            0,
            0,

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
    -- +
    --------------------------------------------------

    local plusButton =
        CreateAdjustButton(
            container,
            "+",
            "TOP",
            slider,
            "BOTTOM",
            0,
            0,

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
    -- Percent
    --------------------------------------------------

    local percentText =
        container:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )

    percentText:SetPoint(
        "BOTTOM",
        container,
        "BOTTOM",
        0,
        -18
    )

    --------------------------------------------------
    -- Slider Callback
    --------------------------------------------------

    slider:SetScript(
        "OnValueChanged",
        function(
            self,
            value
        )

            SetVolume(
                data.cvar,
                value
            )

            percentText:SetText(
                Percent(value)
                ..
                "%"
            )

            if
                data.cvar
                ==
                "Sound_MasterVolume"
            then

                UpdateSpeakerIcon()

            end

        end
    )

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
-- Output Device Label
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
    49
)

outputLabel:SetText(
    TEXT_OUTPUT_DEVICE
)

--------------------------------------------------
-- Output Dropdown
--------------------------------------------------

local outputDropdown

if NDUI_ENABLED then

    --------------------------------------------------
    -- Plain DropdownButton
    -- NDui.lua draws appearance
    --------------------------------------------------

    outputDropdown =
        CreateFrame(
            "DropdownButton",
            "QuickVolumeOutputDropdown",
            controlPanel
        )

else

    --------------------------------------------------
    -- Blizzard default appearance
    --------------------------------------------------

    outputDropdown =
        CreateFrame(
            "DropdownButton",
            "QuickVolumeOutputDropdown",
            controlPanel,
            "WowStyle1DropdownTemplate"
        )

end

outputDropdown:SetPoint(
    "TOPLEFT",
    outputLabel,
    "BOTTOMLEFT",
    0,
    -5
)

outputDropdown:SetSize(
    275,
    28
)

--------------------------------------------------
-- NDui Dropdown Text
--------------------------------------------------

local outputCustomText

if NDUI_ENABLED then

    outputCustomText =
        outputDropdown:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontHighlightSmall"
        )

    outputCustomText:SetPoint(
        "LEFT",
        outputDropdown,
        "LEFT",
        10,
        0
    )

    outputCustomText:SetPoint(
        "RIGHT",
        outputDropdown,
        "RIGHT",
        -30,
        0
    )

    outputCustomText:SetJustifyH(
        "LEFT"
    )

    outputDropdown.QuickVolumeText =
        outputCustomText

end

--------------------------------------------------
-- Output Driver Helpers
--------------------------------------------------

local function GetCurrentOutputDriverIndex()

    return
        tonumber(
            GetCVar(
                "Sound_OutputDriverIndex"
            )
        )
        or
        0

end

local function GetOutputDriverName(index)

    if
        not
        Sound_GameSystem_GetOutputDriverNameByIndex
    then
        return nil
    end

    return
        Sound_GameSystem_GetOutputDriverNameByIndex(
            index
        )

end

--------------------------------------------------
-- Refresh Output Dropdown Text
--------------------------------------------------

local function RefreshOutputDropdownText()

    local index =
        GetCurrentOutputDriverIndex()

    local driverName =
        GetOutputDriverName(
            index
        )

    if
        not driverName
        or
        driverName == ""
    then

        driverName =
            TEXT_OUTPUT_DEVICE

    end

    --------------------------------------------------
    -- NDui Custom Text
    --------------------------------------------------

    if outputDropdown.QuickVolumeText then

        outputDropdown.QuickVolumeText:SetText(
            driverName
        )

    end

    --------------------------------------------------
    -- Blizzard Dropdown
    --------------------------------------------------

    if outputDropdown.SetDefaultText then

        outputDropdown:SetDefaultText(
            driverName
        )

    end

end

--------------------------------------------------
-- Export Refresh Function
--
-- NDui.lua can call this if needed
--------------------------------------------------

QuickVolume_RefreshOutputDropdown =
    RefreshOutputDropdownText

--------------------------------------------------
-- Change Output Device
--------------------------------------------------

local function SetOutputDevice(index)

    SetCVar(
        "Sound_OutputDriverIndex",
        index
    )

    if
        Sound_GameSystem_RestartSoundSystem
    then

        Sound_GameSystem_RestartSoundSystem()

    end

    C_Timer.After(
        0.2,
        function()

            RefreshOutputDropdownText()

        end
    )

end

--------------------------------------------------
-- Setup Output Menu
--------------------------------------------------

local function SetupOutputDropdown()

    if
        not
        outputDropdown.SetupMenu
    then

        print(
            "|cffff3030QuickVolume:|r "
            ..
            "DropdownButton SetupMenu is unavailable."
        )

        return

    end

    outputDropdown:SetupMenu(
        function(
            dropdown,
            rootDescription
        )

            local numDrivers = 0

            if
                Sound_GameSystem_GetNumOutputDrivers
            then

                numDrivers =
                    Sound_GameSystem_GetNumOutputDrivers()
                    or
                    0

            end

            for index =
                0,
                numDrivers - 1
            do

                local driverName =
                    GetOutputDriverName(
                        index
                    )

                if
                    driverName
                    and
                    driverName ~= ""
                then

                    local driverIndex =
                        index

                    rootDescription:CreateRadio(
                        driverName,

                        function()

                            return
                                GetCurrentOutputDriverIndex()
                                ==
                                driverIndex

                        end,

                        function()

                            SetOutputDevice(
                                driverIndex
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
-- Update Full Control Panel
--------------------------------------------------

local function UpdateControlPanel()

    for _,
        data
    in ipairs(channels)
    do

        local object =
            channelSliders[
                data.cvar
            ]

        if object then

            local value =
                GetVolume(
                    data.cvar
                )

            object.slider:SetValue(
                value
            )

            object.percent:SetText(
                Percent(value)
                ..
                "%"
            )

        end

    end

    RefreshOutputDropdownText()

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
-- Hover Panel Mouse
--------------------------------------------------

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

--------------------------------------------------
-- Button Tooltip / Hover
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
            TEXT_TITLE
        )

        GameTooltip:AddLine(
            TEXT_TOOLTIP_LEFT,
            1,
            1,
            1
        )

        GameTooltip:AddLine(
            TEXT_TOOLTIP_MIDDLE,
            1,
            1,
            1
        )

        GameTooltip:AddLine(
            TEXT_TOOLTIP_WHEEL,
            1,
            1,
            1
        )

        GameTooltip:Show()

    end
)

button:SetScript(
    "OnLeave",
    function()

        GameTooltip:Hide()

        HideHoverDelayed()

    end
)

--------------------------------------------------
-- Button Click
--------------------------------------------------

button:SetScript(
    "OnClick",
    function(
        self,
        mouseButton
    )

        --------------------------------------------------
        -- Left Click:
        -- full control panel
        --------------------------------------------------

        if mouseButton == "LeftButton" then

            hoverPanel:Hide()

            if controlPanel:IsShown() then

                controlPanel:Hide()

            else

                UpdateControlPanel()

                controlPanel:Show()

            end

        --------------------------------------------------
        -- Middle Click:
        -- mute / restore
        --------------------------------------------------

        elseif mouseButton == "MiddleButton" then

            local volume =
                GetVolume(
                    "Sound_MasterVolume"
                )

            if volume > 0 then

                previousMasterVolume =
                    volume

                SetVolume(
                    "Sound_MasterVolume",
                    0
                )

            else

                local restoreVolume =
                    previousMasterVolume

                if
                    not restoreVolume
                    or
                    restoreVolume <= 0
                then

                    restoreVolume = 1

                end

                SetVolume(
                    "Sound_MasterVolume",
                    restoreVolume
                )

            end

            UpdateMasterSlider()

            if controlPanel:IsShown() then

                UpdateControlPanel()

            end

        end

    end
)

--------------------------------------------------
-- Mouse Wheel
--------------------------------------------------

button:EnableMouseWheel(
    true
)

button:SetScript(
    "OnMouseWheel",
    function(
        self,
        delta
    )

        local volume =
            GetVolume(
                "Sound_MasterVolume"
            )

        volume =
            volume
            +
            delta * 0.05

        SetVolume(
            "Sound_MasterVolume",
            volume
        )

        UpdateMasterSlider()

        if controlPanel:IsShown() then

            UpdateControlPanel()

        end

    end
)

--------------------------------------------------
-- PLAYER_LOGIN
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

        UpdateMasterSlider()

        UpdateControlPanel()

        C_Timer.After(
            0,
            function()

                RefreshOutputDropdownText()

            end
        )

    end
)
