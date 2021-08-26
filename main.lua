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

-- All data below was found at:
-- https://wowpedia.fandom.com/wiki/UiMapID
-- https://wowpedia.fandom.com/wiki/UiMapID/Classic

-- Vanilla Locations - Kalimdor
Ragefire_Chasm = {
    1454, 213
}

Wailing_Caverns = {
    1413, 11, 279, 825
}

Razorfen_Downs = {
    1413, 300
}

Razorfen_Kraul = {
    1413, 301
}

Zul_Farrak = {
    1446, 219
}

Ahn_Qiraj = {
    1451, 327, 247, 319, 320, 321
}

Dire_Maul = {
    1444, 2324, 235, 236, 237, 238, 239, 240
}

Onyxias_Lair = {
    1445, 248
}

Maraudon = {
    1443, 67, 68, 280, 281
}

Blackfathom_Deeps = {
    1440, 221, 222, 223
}

-- Vanilla locations - Eastern Kingdoms
The_Deadmines = {
    1436, 55, 291, 292, 835, 836
}

Shadowfang_Keep = {
    1421,
}

The_Stockade = {
    1453
}

Gnomeregan = {
    1426
}

Scarlet_Monastery = {
    1420
}

Uldaman = {
    1418
}

The_Temple_Of_Atal_Hakkar = {
    1435
}

Blackrock_Mountain = {
    1428
}

Scholomance = {
    1422
}

Stratholme = {
    1423
}

Zul_Gurub = {
    1434
}

-- TBC Locations
Auchindoun = {
    1952, 256, 257, 258, 259, 260, 272
}

Serpentshrine_Cavern = {
    1946, 262, 263, 264, 265, 332, 1554
}

Blades_Edge_Mountains = {
    1949, 330
}

Netherstorm = {
    1953, 112, 266, 267, 268, 269, 270, 271, 334, 397, 889, 890, 1555
}

Hellfire_Citadel = {
    1944,
}

Black_Temple = {
    1948, 339, 490, 540, 541, 574, 575, 576, 582, 759
}

Karazhan = {
    1430, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 794, 795, 796, 797, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822
}

Caverns_Of_Time = {
    1446, 273, 274, 329, 74, 75, 1552, 1553
}

Zul_Aman = {
    1942, 333
}



function getGroupLocations(index)
    name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index);
    local member = {name = name, location = zone, class = class, hasArrived = false}
    member.uiMapID = C_Map.GetBestMapForUnit(member.name)
    return member
end



function checkWhoHasArrived(stone)
    if IsInGroup() then
        for i = 1, GetNumGroupMembers(), 1 do
            local member  = getGroupLocations(i)
            if inDebugMode then
                print(member.location, C_Map.GetBestMapForUnit(member.name))
            elseif not inDebugMode then
                for i = 1, #_G[stone], 1 do

                    if member.uiMapID == _G[stone][i] then
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
end

-- CreateEvent when GameToolTip Update
local function ToolTipOnShow()
    switcher = false
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()

        if GameTooltipLine1 == "Meeting Stone" then
            GameTooltipLine2 = GameTooltipLine2:gsub("%s+", "_")
            checkWhoHasArrived(GameTooltipLine2)
        end
    end
end

GameTooltip:HookScript("OnShow", ToolTipOnShow)

-- CreateEvent when GameToolTip Update
local function ToolTipOnHide()
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()
    end
end

GameTooltip:HookScript("OnHide", ToolTipOnHide)

if inDebugMode then
    C_Timer.NewTicker(1, checkWhoHasArrived)
end
