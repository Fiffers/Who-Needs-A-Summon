local inDebugMode = false
local switcher = false


local GameTooltipLine1 = ""
local GameTooltipLine2 = ""
local GameTooltipLine3 = ""

-- RGB and HEX colors for each class through WotLK, because that's all that matters
classColors = {
    deathknight = {r = .77, g = .12, b = .23, hex = "C41F3B"},
    druid = {r = 1, g = .49, b = .04, hex = "FF7D0A"},
    hunter = {r = .67, g = .83, b = .45, hex = "ABD473"},
    mage = {r = .41, g = .80, b = .94, hex = "69CCF0"},
    paladin = {r = .96, g = .55, b = .73, hex = "F58CBA"},
    priest = {r = 1, g = 1, b = 1, hex = "FFFFFF"},
    rogue = {r = 1, g = .96, b = .41, hex = "FFF569"},
    shaman = {r = 0, g = .44, b = .87, hex = "0070DE"},
    warlock = {r = .58, g = .51, b = .79, hex = "9482C9"},
    warrior = {r = .78, g = .61, b = .43, hex = "C79C6E"}
}

-- Vanilla Locations - Kalimdor
Ragefire_Chasm = {
    "Orgrimmar",
    "Ragefire Chasm"
}

Wailing_Caverns = {
    "The Barrens",
    "Wailing Caverns"
}

Razorfen_Downs = {
    "The Barrens",
    "Razorfen Downs"
}

Razorfen_Kraul = {
    "The Barrens",
    "Razorfen Kraul"
}

Zul_Farrak = {
    "Tanaris",
    "Zul'Farrak"
}

Ahn_Qiraj = {
    "Silithus",
    "Ahn'Qiraj",
    "Gates of Ahn'Qiraj",
    "Ruins of Ahn'Qiraj",
    "Temple of Ahn'Qiraj"
}

Dire_Maul = {
    "Feralas",
    "Dire Maul"
}

Onyxias_Lair = {
    "Dustwallow Marsh",
    "Onyxia's Lair"
}

Maraudon = {
    "Desolace",
    "Maraudon"
}

Blackfathom_Deeps = {
    "Ashenvale",
    "Blackfathom_Deeps"
}

-- Vanilla locations - Eastern Kingdoms
The_Deadmines = {
    "Westfall",
    "The Deadmines"
}

Shadowfang_Keep = {
    "Silverpine Forest",
    "Shadowfang Keep"
}

The_Stockade = {
    "Stormwind City",
    "The Stockade"
}

Gnomeregan = {
    "Dun Morough",
    "Gnomeregan"
}

Scarlet_Monastery = {
    "Tirisfal Glades",
    "Scarlet_Monastery"
}

Uldaman = {
    "Badlands",
    "Uldaman"
}

The_Temple_Of_Atal_Hakkar = {
    "Swamp of Sorrows",
    "The Temple of Atal'Hakkar"
}

Blackrock_Mountain = {
    "Burning Steppes",
    "Blackrock Mountain",
    "Blackrock Depths",
    "Blackrock Spire",
    "Molten Core",
    "Blackwing Lair"
}

Scholomance = {
    "Western Plaguelands",
    "Scholomance"
}

Stratholme = {
    "Eastern Plaguelands",
    "Stratholme"
}

Zul_Gurub = {
    "Stranglethorn Vale",
    "Zul'Gurub"
}

-- TBC Locations
Auchindoun = {
    "Terokkar Forest",
    "Sethekk Halls",
    "Shadow Labyrinth",
    "Auchenai Crypts",
    "Mana Tombs"
}

Serpentshrine_Cavern = {
    "Zangarmarsh",
    "Slave Pens",
    "Steam Vaults",
    "Underbog",
    "Serpentshrine Cavern"
}

Blades_Edge_Mountains = {
    "Blade's Edge Mountains",
    "Gruul's Lair"
}

Netherstorm = {
    "Netherstorm",
    "The Mechanar",
    "The Botanica",
    "The Arcatraz",
    "The Eye"
}

Hellfire_Citadel = {
    "Hellfire Peninsula",
    "Hellfire Ramparts",
    "The Blood Furnace",
    "The Shattered Halls",
    "Magtheridon's Lair"
}

Black_Temple = {
    "Shadowmoon Valley",
    "Black Temple"
}

Karazhan = {
    "Deadwind Pass",
    "Karazhan"
}

Caverns_Of_Time = {
    "Tanaris",
    "Caverns of Time",
    "Old Hillsbrad",
    "Black Morass",
    "Hyjal Summit",
}

Zul_Aman = {
    "Ghostlands",
    "Zul'Aman"
}



function getGroupLocations(index)
    name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index);
    local member = {name = name, location = zone, class = class, hasArrived = false}
    return member
end

function checkWhoHasArrived(stone)
    if IsInGroup() then
        for i = 1, GetNumGroupMembers(), 1 do
            local member  = getGroupLocations(i)
            for i = 1, #_G[stone], 1 do
                if member.location == _G[stone][i] then
                    member.hasArrived = true
                end
            end
            if not member.hasArrived then
                if not switcher then
                    GameTooltip:AddLine("Needs Summon:", 1, 1, 1, false)
                    switcher = true
                end
                GameTooltip:AddLine(member.name, classColors[member.class:lower()].r, classColors[member.class:lower()].g, classColors[member.class:lower()].b, false)
                GameTooltip:Show()
            end
        end
    end
end

-- CreateEvent when GameToolTip Update
local function ToolTipOnShow()
    switcher = false
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        if (inDebugMode) then
            DEFAULT_CHAT_FRAME:AddMessage("Tooltip OnShow Event fired!")
        end
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()

        if GameTooltipLine1 == "Meeting Stone" then
            checkWhoHasArrived(GameTooltipLine2)
        end
    end
end

GameTooltip:HookScript("OnShow", ToolTipOnShow)

-- CreateEvent when GameToolTip Update
local function ToolTipOnHide()
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        if (inDebugMode) then
            DEFAULT_CHAT_FRAME:AddMessage("Tooltip OnHide Event fired!")
        end
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()
    end
end

GameTooltip:HookScript("OnHide", ToolTipOnHide)
