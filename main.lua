local inDebugMode = false

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
    GameTooltip:AddLine("Needs Summon:", 1, 1, 1, false)
    for i = 1, GetNumGroupMembers(), 1 do
        if UnitInParty("Player") or UnitInRaid("Player") then
            local member  = getGroupLocations(i)
            for i = 1, #stone, 1 do
                if member.location == stone[i] then
                    member.hasArrived = true
                end
            end
            if not member.hasArrived then
                GameTooltip:AddLine(member.name, classColors[member.class:lower()].r, classColors[member.class:lower()].g, classColors[member.class:lower()].b, false)
                GameTooltip:Show()
            end
        end
    end
end

-- CreateEvent when GameToolTip Update
local function ToolTipOnShow()
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        if (inDebugMode) then
            DEFAULT_CHAT_FRAME:AddMessage("Tooltip OnShow Event fired!")
        end

        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()

        if GameTooltipLine1 == "Meeting Stone" then
            -- Vanilla Locations - Kalimdor
            if GameTooltipLine2 == "Ragefire Chasm" then
                checkWhoHasArrived(Ragefire_Chasm)
            end
            if GameTooltipLine2 == "Wailing Caverns" then
                checkWhoHasArrived(Wailing_Caverns)
            end
            if GameTooltipLine2 == "Razorfen Downs" then
                checkWhoHasArrived(Razorfen_Downs)
            end
            if GameTooltipLine2 == "Razorfen Kraul" then
                checkWhoHasArrived(Razorfen_Kraul)
            end
            if GameTooltipLine2 == "Zul'Farrak" then
                checkWhoHasArrived(Zul_Farrak)
            end
            if GameTooltipLine2 == "Ahn'Qiraj" then
                checkWhoHasArrived(Ahn_Qiraj)
            end
            if GameTooltipLine2 == "Dire Maul" then
                checkWhoHasArrived(Dire_Maul)
            end
            if GameTooltipLine2 == "Onyxia's Lair" then
                checkWhoHasArrived(Onyxias_Lair)
            end
            if GameTooltipLine2 == "Maraudon" then
                checkWhoHasArrived(Maraudon)
            end
            if GameTooltipLine2 == "Blackfathom Deeps" then
                checkWhoHasArrived(Blackfathom_Deeps)
            end

            -- Vanilla Locations - Eastern Kingdoms
            if GameTooltipLine2 == "The Deadmines" then
                checkWhoHasArrived(The_Deadmines)
            end
            if GameTooltipLine2 == "Shadowfang Keep" then
                checkWhoHasArrived(Shadowfang_Keep)
            end
            if GameTooltipLine2 == "The Stockade" then
                checkWhoHasArrived(The_Stockade)
            end
            if GameTooltipLine2 == "Gnomeregan" then
                checkWhoHasArrived(Gnomeregan)
            end
            if GameTooltipLine2 == "Scarlet Monastery" then
                checkWhoHasArrived(Scarlet_Monastery)
            end
            if GameTooltipLine2 == "Uldaman" then
                checkWhoHasArrived(Uldaman)
            end
            if GameTooltipLine2 == "The Temple of Atal'Hakkar" then
                checkWhoHasArrived(The_Temple_Of_Atal_Hakkar)
            end
            if GameTooltipLine2 == "Blackrock Depths" then
                checkWhoHasArrived(Blackrock_Depths)
            end
            if GameTooltipLine2 == "Blackrock Spire" then
                checkWhoHasArrived(Blackrock_Spire)
            end
            if GameTooltipLine2 == "Scholomance" then
                checkWhoHasArrived(Scholomance)
            end
            if GameTooltipLine2 == "Stratholme" then
                checkWhoHasArrived(Stratholme)
            end
            if GameTooltipLine2 == "Zul'Gurub" then
                checkWhoHasArrived(Zul_Gurub)
            end

            -- TBC Locations
            if GameTooltipLine2 == "Auchindoun" then
                checkWhoHasArrived(Auchindoun)
            end
            if GameTooltipLine2 == "Serpentshrine Cavern" then
                checkWhoHasArrived(Serpentshrine_Cavern)
            end
            if GameTooltipLine2 == "Blade's Edge Mountains" then
                checkWhoHasArrived(Blades_Edge_Mountains)
            end
            if GameTooltipLine2 == "Netherstorm" then
                checkWhoHasArrived(Netherstorm)
            end
            if GameTooltipLine2 == "Hellfire Citadel" then
                checkWhoHasArrived(Hellfire_Citadel)
            end
            if GameTooltipLine2 == "Black Temple" then
                checkWhoHasArrived(Black_Temple)
            end
            if GameTooltipLine2 == "Caverns of Time" then
                checkWhoHasArrived(Caverns_Of_Time)
            end
            if GameTooltipLine2 == "Zul'Aman" then
                checkWhoHasArrived(Zul_Aman)
            end
            if GameTooltipLine2 == "Karazhan" then
                checkWhoHasArrived(Karazhan)
            end
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
