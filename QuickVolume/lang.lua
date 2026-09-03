--------------------------------------------------
-- QuickVolume Localization
--------------------------------------------------

QuickVolume_L = {}

local locale = GetLocale()

--------------------------------------------------
-- English
--------------------------------------------------

local EN = {
    TITLE   = "QuickVolume",

    MASTER  = "Master",
    MUSIC   = "Music",
    SFX     = "SFX",
    DIALOG  = "Dialog",

    MUTE    = "Mute",
    UNMUTE  = "Unmute",

    TOOLTIP_LEFT   = "Left Click: Volume panel",
    TOOLTIP_MIDDLE = "Middle Click: Mute / Unmute",
    TOOLTIP_WHEEL  = "Mouse Wheel: Master volume",

    OUTPUT_DEVICE = "Output Device",
    SYSTEM_DEFAULT = "System Default",
}

--------------------------------------------------
-- Simplified Chinese
--------------------------------------------------

local ZHCN = {
    TITLE   = "快捷音量",

    MASTER  = "主音量",
    MUSIC   = "音乐",
    SFX     = "音效",
    DIALOG  = "对话",

    MUTE    = "静音",
    UNMUTE  = "取消静音",

    TOOLTIP_LEFT   = "左键：打开音量面板",
    TOOLTIP_MIDDLE = "中键：静音 / 恢复",
    TOOLTIP_WHEEL  = "滚轮：调整主音量",

    OUTPUT_DEVICE = "输出设备",
    SYSTEM_DEFAULT = "系统默认",
}

--------------------------------------------------
-- Traditional Chinese
--------------------------------------------------

local ZHTW = {
    TITLE   = "快速音量",

    MASTER  = "主音量",
    MUSIC   = "音樂",
    SFX     = "音效",
    DIALOG  = "對話",

    MUTE    = "靜音",
    UNMUTE  = "取消靜音",

    TOOLTIP_LEFT   = "左鍵：開啟音量面板",
    TOOLTIP_MIDDLE = "中鍵：靜音 / 恢復",
    TOOLTIP_WHEEL  = "滾輪：調整主音量",
}

--------------------------------------------------
-- German
--------------------------------------------------

local DE = {
    TITLE   = "QuickVolume",

    MASTER  = "Gesamt",
    MUSIC   = "Musik",
    SFX     = "Effekte",
    DIALOG  = "Dialog",

    MUTE    = "Stumm",
    UNMUTE  = "Ton an",

    TOOLTIP_LEFT   = "Linksklick: Lautstärkefenster",
    TOOLTIP_MIDDLE = "Mittelklick: Stumm / Ton an",
    TOOLTIP_WHEEL  = "Mausrad: Gesamtlautstärke",
}

--------------------------------------------------
-- French
--------------------------------------------------

local FR = {
    TITLE   = "QuickVolume",

    MASTER  = "Général",
    MUSIC   = "Musique",
    SFX     = "Effets",
    DIALOG  = "Dialogue",

    MUTE    = "Muet",
    UNMUTE  = "Son activé",

    TOOLTIP_LEFT   = "Clic gauche : panneau du volume",
    TOOLTIP_MIDDLE = "Clic milieu : Muet / Son",
    TOOLTIP_WHEEL  = "Molette : volume général",
}

--------------------------------------------------
-- Korean
--------------------------------------------------

local KO = {
    TITLE   = "QuickVolume",

    MASTER  = "전체",
    MUSIC   = "음악",
    SFX     = "효과음",
    DIALOG  = "대화",

    MUTE    = "음소거",
    UNMUTE  = "음소거 해제",

    TOOLTIP_LEFT   = "왼쪽 클릭: 볼륨 패널",
    TOOLTIP_MIDDLE = "가운데 클릭: 음소거",
    TOOLTIP_WHEEL  = "마우스 휠: 전체 볼륨",
}

--------------------------------------------------
-- Spanish
--------------------------------------------------

local ES = {
    TITLE   = "QuickVolume",

    MASTER  = "General",
    MUSIC   = "Música",
    SFX     = "Efectos",
    DIALOG  = "Diálogo",

    MUTE    = "Silenciar",
    UNMUTE  = "Activar sonido",

    TOOLTIP_LEFT   = "Clic izquierdo: panel de volumen",
    TOOLTIP_MIDDLE = "Clic central: silenciar",
    TOOLTIP_WHEEL  = "Rueda: volumen general",
}

--------------------------------------------------
-- Russian
--------------------------------------------------

local RU = {
    TITLE   = "QuickVolume",

    MASTER  = "Общая",
    MUSIC   = "Музыка",
    SFX     = "Эффекты",
    DIALOG  = "Диалоги",

    MUTE    = "Без звука",
    UNMUTE  = "Включить звук",

    TOOLTIP_LEFT   = "ЛКМ: панель громкости",
    TOOLTIP_MIDDLE = "СКМ: звук вкл/выкл",
    TOOLTIP_WHEEL  = "Колесо: общая громкость",
}

--------------------------------------------------
-- Portuguese
--------------------------------------------------

local PT = {
    TITLE   = "QuickVolume",

    MASTER  = "Geral",
    MUSIC   = "Música",
    SFX     = "Efeitos",
    DIALOG  = "Diálogo",

    MUTE    = "Mudo",
    UNMUTE  = "Ativar som",

    TOOLTIP_LEFT   = "Clique esquerdo: painel de volume",
    TOOLTIP_MIDDLE = "Clique do meio: Mudo / Som",
    TOOLTIP_WHEEL  = "Roda do mouse: volume geral",
}

--------------------------------------------------
-- Italian
--------------------------------------------------

local IT = {
    TITLE   = "QuickVolume",

    MASTER  = "Generale",
    MUSIC   = "Musica",
    SFX     = "Effetti",
    DIALOG  = "Dialoghi",

    MUTE    = "Muto",
    UNMUTE  = "Audio attivo",

    TOOLTIP_LEFT   = "Clic sinistro: pannello volume",
    TOOLTIP_MIDDLE = "Clic centrale: Muto / Audio",
    TOOLTIP_WHEEL  = "Rotella: volume generale",
}

--------------------------------------------------
-- Select Language
--------------------------------------------------

local languageTable = {
    zhCN = ZHCN,
    zhTW = ZHTW,

    deDE = DE,
    frFR = FR,
    koKR = KO,

    esES = ES,
    esMX = ES,

    ruRU = RU,
    ptBR = PT,
    itIT = IT,
}

local selected = languageTable[locale] or EN

--------------------------------------------------
-- English fallback
--------------------------------------------------

for key, value in pairs(EN) do
    QuickVolume_L[key] =
        selected[key] or value
end