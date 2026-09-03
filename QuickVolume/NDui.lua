--------------------------------------------------
-- QuickVolume
-- NDui Compatibility Layer
--------------------------------------------------

if not C_AddOns.IsAddOnLoaded("NDui") then
    return
end

--------------------------------------------------
-- QuickVolume Frames
--------------------------------------------------

local button =
    _G["QuickVolumeButton"]

local hoverPanel =
    _G["QuickVolumeHoverPanel"]

local controlPanel =
    _G["QuickVolumeControlPanel"]

local masterSlider =
    _G["QuickVolumeMasterSlider"]

local closeButton =
    _G[
        "QuickVolumeControlPanelCloseButton"
    ]

local outputDropdown =
    _G[
        "QuickVolumeOutputDropdown"
    ]

if not button then
    return
end

--------------------------------------------------
-- Style
--------------------------------------------------

local BACKGROUND_ALPHA =
    0.75

local BUTTON_ALPHA =
    0.40

local SLIDER_ALPHA =
    0.65

local BORDER_COLOR = {
    0.20,
    0.20,
    0.20,
    1
}

local HIGHLIGHT_COLOR = {
    1,
    0.80,
    0,
    1
}

--------------------------------------------------
-- Utility
--------------------------------------------------

local function SetBorderColor(
    frame,
    color
)

    if
        frame
        and
        frame.SetBackdropBorderColor
    then

        frame:SetBackdropBorderColor(
            unpack(color)
        )

    end

end

--------------------------------------------------
-- Hide Texture
--------------------------------------------------

local function HideTexture(texture)

    if
        texture
        and
        texture.SetAlpha
    then

        texture:SetAlpha(0)

    end

end

--------------------------------------------------
-- Strip Frame Textures
--------------------------------------------------

local function StripTextures(frame)

    if
        not frame
        or
        not frame.GetRegions
    then
        return
    end

    local regions = {
        frame:GetRegions()
    }

    for _,
        region
    in ipairs(regions)
    do

        if
            region
            and
            region.IsObjectType
            and
            region:IsObjectType(
                "Texture"
            )
        then

            HideTexture(
                region
            )

        end

    end

end

--------------------------------------------------
-- Panel Skin
--------------------------------------------------

local function SkinFrame(frame)

    if not frame then
        return
    end

    if frame.__QuickVolumeNDuiFrameSkinned then
        return
    end

    frame.__QuickVolumeNDuiFrameSkinned =
        true

    if not frame.SetBackdrop then
        return
    end

    frame:SetBackdrop({
        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeSize =
            1,

        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1
        }
    })

    frame:SetBackdropColor(
        0,
        0,
        0,
        BACKGROUND_ALPHA
    )

    frame:SetBackdropBorderColor(
        unpack(
            BORDER_COLOR
        )
    )

end

--------------------------------------------------
-- Panel Hover
--------------------------------------------------

local function AddHoverBorder(frame)

    if not frame then
        return
    end

    frame:HookScript(
        "OnEnter",
        function(self)

            SetBorderColor(
                self,
                HIGHLIGHT_COLOR
            )

        end
    )

    frame:HookScript(
        "OnLeave",
        function(self)

            SetBorderColor(
                self,
                BORDER_COLOR
            )

        end
    )

end

--------------------------------------------------
-- Generic Button
--------------------------------------------------

local function SkinButton(btn)

    if not btn then
        return
    end

    if btn.__QuickVolumeNDuiButtonSkinned then
        return
    end

    btn.__QuickVolumeNDuiButtonSkinned =
        true

    --------------------------------------------------
    -- Safely hide existing button textures
    --------------------------------------------------

    if btn.GetNormalTexture then

        HideTexture(
            btn:GetNormalTexture()
        )

    end

    if btn.GetHighlightTexture then

        HideTexture(
            btn:GetHighlightTexture()
        )

    end

    if btn.GetPushedTexture then

        HideTexture(
            btn:GetPushedTexture()
        )

    end

    if btn.GetDisabledTexture then

        HideTexture(
            btn:GetDisabledTexture()
        )

    end

    --------------------------------------------------
    -- Background
    --------------------------------------------------

    local bg =
        CreateFrame(
            "Frame",
            nil,
            btn,
            "BackdropTemplate"
        )

    bg:SetAllPoints(
        btn
    )

    bg:SetFrameLevel(
        math.max(
            0,
            btn:GetFrameLevel() - 1
        )
    )

    bg:SetBackdrop({
        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeSize =
            1
    })

    bg:SetBackdropColor(
        0,
        0,
        0,
        BUTTON_ALPHA
    )

    bg:SetBackdropBorderColor(
        unpack(
            BORDER_COLOR
        )
    )

    btn.__QuickVolumeNDuiBG =
        bg

    --------------------------------------------------
    -- Hover
    --------------------------------------------------

    btn:HookScript(
        "OnEnter",
        function()

            bg:SetBackdropColor(
                1,
                0.8,
                0,
                0.12
            )

            bg:SetBackdropBorderColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

        end
    )

    btn:HookScript(
        "OnLeave",
        function()

            bg:SetBackdropColor(
                0,
                0,
                0,
                BUTTON_ALPHA
            )

            bg:SetBackdropBorderColor(
                unpack(
                    BORDER_COLOR
                )
            )

        end
    )

end

--------------------------------------------------
-- Slider Skin
--
-- IMPORTANT:
--
-- QuickVolume.lua creates plain sliders
-- while NDui is loaded.
--
-- Therefore there are NO Blizzard slider
-- textures to strip here.
--------------------------------------------------

local function SkinSlider(slider)

    if not slider then
        return
    end

    if slider.__QuickVolumeNDuiSliderSkinned then
        return
    end

    slider.__QuickVolumeNDuiSliderSkinned =
        true

    --------------------------------------------------
    -- Track
    --------------------------------------------------

    local track =
        CreateFrame(
            "Frame",
            nil,
            slider,
            "BackdropTemplate"
        )

    track:SetPoint(
        "TOP",
        slider,
        "TOP",
        0,
        0
    )

    track:SetPoint(
        "BOTTOM",
        slider,
        "BOTTOM",
        0,
        0
    )

    track:SetWidth(
        6
    )

    track:SetFrameLevel(
        math.max(
            0,
            slider:GetFrameLevel() - 1
        )
    )

    track:SetBackdrop({
        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeSize =
            1
    })

    track:SetBackdropColor(
        0,
        0,
        0,
        SLIDER_ALPHA
    )

    track:SetBackdropBorderColor(
        unpack(
            BORDER_COLOR
        )
    )

    slider.__QuickVolumeNDuiTrack =
        track

    --------------------------------------------------
    -- Thumb
    --------------------------------------------------

    local thumb =
        slider:CreateTexture(
            nil,
            "OVERLAY"
        )

    thumb:SetTexture(
        "Interface\\Buttons\\WHITE8X8"
    )

    thumb:SetSize(
        14,
        8
    )

    thumb:SetVertexColor(
        unpack(
            HIGHLIGHT_COLOR
        )
    )

    slider:SetThumbTexture(
        thumb
    )

    slider.__QuickVolumeNDuiThumb =
        thumb

    --------------------------------------------------
    -- Hover
    --------------------------------------------------

    slider:HookScript(
        "OnEnter",
        function()

            track:SetBackdropBorderColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

        end
    )

    slider:HookScript(
        "OnLeave",
        function()

            track:SetBackdropBorderColor(
                unpack(
                    BORDER_COLOR
                )
            )

        end
    )

end

--------------------------------------------------
-- Close Button
--------------------------------------------------

local function SkinCloseButton(btn)

    if not btn then
        return
    end

    if btn.__QuickVolumeNDuiCloseSkinned then
        return
    end

    btn.__QuickVolumeNDuiCloseSkinned =
        true

    --------------------------------------------------
    -- Hide Blizzard close button textures
    --------------------------------------------------

    StripTextures(
        btn
    )

    btn:SetSize(
        20,
        20
    )

    --------------------------------------------------
    -- Custom X
    --------------------------------------------------

    local text =
        btn:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormalLarge"
        )

    text:SetPoint(
        "CENTER",
        0,
        0
    )

    text:SetText(
        "×"
    )

    text:SetTextColor(
        0.8,
        0.8,
        0.8
    )

    btn.__QuickVolumeCloseText =
        text

    btn:HookScript(
        "OnEnter",
        function()

            text:SetTextColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

        end
    )

    btn:HookScript(
        "OnLeave",
        function()

            text:SetTextColor(
                0.8,
                0.8,
                0.8
            )

        end
    )

end

--------------------------------------------------
-- Output Dropdown
--
-- QuickVolume.lua creates a plain
-- DropdownButton under NDui.
--
-- Therefore this function draws
-- the COMPLETE appearance.
--------------------------------------------------

local function SkinDropdown(
    dropdown
)

    if not dropdown then
        return
    end

    if dropdown.__QuickVolumeNDuiDropdownSkinned then
        return
    end

    dropdown.__QuickVolumeNDuiDropdownSkinned =
        true

    --------------------------------------------------
    -- Background
    --------------------------------------------------

    local bg =
        CreateFrame(
            "Frame",
            nil,
            dropdown,
            "BackdropTemplate"
        )

    bg:SetAllPoints(
        dropdown
    )

    bg:SetFrameLevel(
        math.max(
            0,
            dropdown:GetFrameLevel() - 1
        )
    )

    bg:SetBackdrop({
        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeSize =
            1
    })

    bg:SetBackdropColor(
        0,
        0,
        0,
        0.65
    )

    bg:SetBackdropBorderColor(
        unpack(
            BORDER_COLOR
        )
    )

    dropdown.__QuickVolumeNDuiBG =
        bg

    --------------------------------------------------
    -- Arrow
    --------------------------------------------------

    local arrow =
        dropdown:CreateFontString(
            nil,
            "OVERLAY",
            "GameFontNormal"
        )

    arrow:SetPoint(
        "RIGHT",
        dropdown,
        "RIGHT",
        -9,
        0
    )

    arrow:SetText(
        "▼"
    )

    arrow:SetTextColor(
        0.8,
        0.8,
        0.8
    )

    dropdown.__QuickVolumeNDuiArrow =
        arrow

    --------------------------------------------------
    -- Separator before arrow
    --------------------------------------------------

    local separator =
        dropdown:CreateTexture(
            nil,
            "ARTWORK"
        )

    separator:SetTexture(
        "Interface\\Buttons\\WHITE8X8"
    )

    separator:SetVertexColor(
        0.20,
        0.20,
        0.20,
        1
    )

    separator:SetWidth(
        1
    )

    separator:SetPoint(
        "TOPRIGHT",
        dropdown,
        "TOPRIGHT",
        -27,
        -3
    )

    separator:SetPoint(
        "BOTTOMRIGHT",
        dropdown,
        "BOTTOMRIGHT",
        -27,
        3
    )

    dropdown.__QuickVolumeNDuiSeparator =
        separator

    --------------------------------------------------
    -- Hover
    --------------------------------------------------

    dropdown:HookScript(
        "OnEnter",
        function()

            bg:SetBackdropBorderColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

            arrow:SetTextColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

        end
    )

    dropdown:HookScript(
        "OnLeave",
        function()

            bg:SetBackdropBorderColor(
                unpack(
                    BORDER_COLOR
                )
            )

            arrow:SetTextColor(
                0.8,
                0.8,
                0.8
            )

        end
    )

end

--------------------------------------------------
-- Recursive Slider Search
--------------------------------------------------

local function SkinSlidersRecursive(
    frame
)

    if
        not frame
        or
        not frame.GetChildren
    then
        return
    end

    local children = {
        frame:GetChildren()
    }

    for _,
        child
    in ipairs(children)
    do

        if
            child
            and
            child.IsObjectType
        then

            if
                child:IsObjectType(
                    "Slider"
                )
            then

                SkinSlider(
                    child
                )

            end

            if child.GetChildren then

                SkinSlidersRecursive(
                    child
                )

            end

        end

    end

end

--------------------------------------------------
-- Recursive +/- Button Search
--------------------------------------------------

local function SkinButtonsRecursive(
    frame
)

    if
        not frame
        or
        not frame.GetChildren
    then
        return
    end

    local children = {
        frame:GetChildren()
    }

    for _,
        child
    in ipairs(children)
    do

        if
            child
            and
            child.IsObjectType
        then

            --------------------------------------------------
            -- Do not touch special controls
            --------------------------------------------------

            if
                child == outputDropdown
                or
                child == closeButton
            then

                --------------------------------------------------
                -- Don't recurse into these
                --------------------------------------------------

            else

                if
                    child:IsObjectType(
                        "Button"
                    )
                then

                    SkinButton(
                        child
                    )

                end

                if child.GetChildren then

                    SkinButtonsRecursive(
                        child
                    )

                end

            end

        end

    end

end

--------------------------------------------------
-- Panels
--------------------------------------------------

SkinFrame(
    hoverPanel
)

SkinFrame(
    controlPanel
)

AddHoverBorder(
    hoverPanel
)

AddHoverBorder(
    controlPanel
)

--------------------------------------------------
-- Speaker Background
--------------------------------------------------

if not button.__QuickVolumeNDuiSpeakerBG then

    local buttonBG =
        CreateFrame(
            "Frame",
            nil,
            button,
            "BackdropTemplate"
        )

    buttonBG:SetAllPoints(
        button
    )

    buttonBG:SetFrameLevel(
        math.max(
            0,
            button:GetFrameLevel() - 1
        )
    )

    buttonBG:SetBackdrop({
        bgFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeFile =
            "Interface\\Buttons\\WHITE8X8",

        edgeSize =
            1
    })

    buttonBG:SetBackdropColor(
        0,
        0,
        0,
        0.55
    )

    buttonBG:SetBackdropBorderColor(
        unpack(
            BORDER_COLOR
        )
    )

    button.__QuickVolumeNDuiSpeakerBG =
        buttonBG

    --------------------------------------------------
    -- Speaker Hover
    --------------------------------------------------

    button:HookScript(
        "OnEnter",
        function()

            buttonBG:SetBackdropBorderColor(
                unpack(
                    HIGHLIGHT_COLOR
                )
            )

        end
    )

    button:HookScript(
        "OnLeave",
        function()

            buttonBG:SetBackdropBorderColor(
                unpack(
                    BORDER_COLOR
                )
            )

        end
    )

end

--------------------------------------------------
-- Sliders
--------------------------------------------------

SkinSlider(
    masterSlider
)

SkinSlidersRecursive(
    hoverPanel
)

SkinSlidersRecursive(
    controlPanel
)

--------------------------------------------------
-- +/- Buttons
--------------------------------------------------

SkinButtonsRecursive(
    hoverPanel
)

SkinButtonsRecursive(
    controlPanel
)

--------------------------------------------------
-- Close Button
--------------------------------------------------

SkinCloseButton(
    closeButton
)

--------------------------------------------------
-- Output Dropdown
--------------------------------------------------

SkinDropdown(
    outputDropdown
)

--------------------------------------------------
-- Refresh Current Device Text
--------------------------------------------------

if QuickVolume_RefreshOutputDropdown then

    C_Timer.After(
        0,
        function()

            QuickVolume_RefreshOutputDropdown()

        end
    )

end

--------------------------------------------------
-- Integration Flag
--------------------------------------------------

QuickVolume_NDuiEnabled =
    true