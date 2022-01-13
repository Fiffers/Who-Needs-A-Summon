local inDebugMode = false
local switcher = false

local GameTooltipLine1 = ""
local GameTooltipLine2 = ""
local GameTooltipLine3 = ""
local savedStoneName = ""
local locationIDs = {}

local SAVED_PER_CHAR

local _G, print, C_Map, GetRaidRosterInfo, GetNumGroupMembers, IsInGroup, GetRealZoneText, StaticPopup_Show =
      _G, print, C_Map, GetRaidRosterInfo, GetNumGroupMembers, IsInGroup, GetRealZoneText, StaticPopup_Show

-- RGB and HEX colors for each class through WotLK, because that's all that matters
local classColors = {
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

-- Numeric data below was found at:
-- https://wowpedia.fandom.com/wiki/UiMapID
-- https://wowpedia.fandom.com/wiki/UiMapID/Classic

-- Vanilla Locations - Kalimdor
locationIDs["RagefireChasm"] = {
    1454, "Ragefire Chasm"
}

locationIDs["WailingCaverns"] = {
    1413, 11, 279, 825, "Wailing Caverns"
}

locationIDs["RazorfenDowns"] = {
    1413, 300, "Razorfen Downs"
}

locationIDs["RazorfenKraul"] = {
    1413, 301, "Razorfen Kraul"
}

locationIDs["ZulFarrak"] = {
    1446, 219, "Zul'Farrak"
}

locationIDs["AhnQiraj"] = {
    1451, 327, 247, 319, 320, 321, "Ahn'Qiraj", "Ruins of Ahn'Qiraj", "Temple of Ahn'Qiraj"
}

locationIDs["DireMaul"] = {
    1444, 2324, 235, 236, 237, 238, 239, 240, "Dire Maul"
}

locationIDs["OnyxiasLair"] = {
    1445, 248, "Onyxia's Lair"
}

locationIDs["Maraudon"] = {
    1443, 67, 68, 280, 281, "Maraudon"
}

locationIDs["BlackfathomDeeps"] = {
    1440, 221, 222, 223, "Blackfathom Deeps"
}

-- Vanilla locations - Eastern Kingdoms
locationIDs["TheDeadmines"] = {
    1436, 55, 291, 292, 835, 836, "The Deadmines"
}

locationIDs["ShadowfangKeep"] = {
    1421, 311, 312, 313, 314, 315, 316, "Shadowfang Keep"
}

locationIDs["TheStockade"] = {
    1453, 1013, 225, "The Stockade"
}

locationIDs["Gnomeregan"] = {
    1426, 226, 227, 228, 229, 840, 841, 842, 1371, 1372, 1374, 1380, "Gnomeregan"
}

locationIDs["ScarletMonastery"] = {
    1420, 19, 302, 303, 304, 305, 435, 436, 804, 805, "Scarlet Monastery"
}

locationIDs["Uldaman"] = {
    1418, 16, 230, 231, "Uldaman"
}

locationIDs["TheTempleofAtalHakkar"] = {
    1415, 220, "The Temple of Atal'Hakkar"
}

locationIDs["BlackrockDepths"] = {
    1428, 33, 34, 232, 250, 251, 252, 253, 254, 255, 283, 284, 285, 286, 287, 288, 289, 290, 616, 617, 618, 868, 1538, 1539, 1560, "Blackrock Mountain", "Blackrock Depths", "Blackwing Lair", "Blackrock Spire", "Molten Core"
}

locationIDs["Scholomance"] = {
    1422, 306, 307, 308, 309, 476, 477, 478, 479, "Scholomance"
}

locationIDs["Stratholme"] = {
    1423, 317, 318, 1505, 827, "Stratholme"
}

locationIDs["ZulGurub"] = {
    1434, 233, 337, "Zul'Gurub"
}

-- TBC Locations
locationIDs["Auchindoun"] = {
    1952, 256, 257, 258, 259, 260, 272, "Auchindoun", "Mana-Tombs", "Sethekk Halls", "Auchenai Crypts", "Shadow Labyrinth"
}

locationIDs["SerpentshrineCavern"] = {
    1946, 262, 263, 264, 265, 332, 1554, "Serpentshrine Cavern", "Slave Pens", "Steam Vault", "Underbog"
}

locationIDs["BladesEdgeMountains"] = {
    1949, 330, "Gruul's Lair"
}

locationIDs["Netherstorm"] = {
    1953, 112, 266, 267, 268, 269, 270, 271, 334, 397, 889, 890, 1555, "The Mechanar", "The Botanica", "The Arcatraz", "The Eye"
}

locationIDs["HellfireCitadel"] = {
    1944, 662, 663, 664, 665, 666, 667, 668, 669, 670, 246, 261, 331, 347, "Hellfire Ramparts", "The Blood Furnace", "The Shattered Halls", "Magtheridon's Lair"
}

locationIDs["BlackTemple"] = {
    1948, 339, 490, 540, 541, 574, 575, 576, 582, 759, "The Black Temple", "Black Temple"
}

locationIDs["Karazhan"] = {
    1430, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 794, 795, 796, 797, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, "Karazhan"
}

locationIDs["CavernsofTime"] = {
    1446, 273, 274, 329, 74, 75, 1552, 1553, "Caverns of Time", "The Black Morass", "Hyjal Summit", "Old Hillsbrad"
}

locationIDs["ZulAman"] = {
    1942, 333, "Zul'Aman"
}



local function getGroupLocations(index)
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(index);
    local member = {name = name, location = zone, class = class, hasArrived = false}
    member.uiMapID = C_Map.GetBestMapForUnit(member.name)
    return member
end



local function checkWhoHasArrived(stone)
    if IsInGroup() then
        for i = 1, GetNumGroupMembers(), 1 do
            local member  = getGroupLocations(i)
            if inDebugMode and member.name ~= "Eztestyay" then
                if locationIDs[stone] then
                    for i = 1, #locationIDs[stone], 1 do
                        if member.uiMapID == locationIDs[stone] then
                            print("If 1: ", locationIDs[stone], member.uiMapID, member.location)
                            --member.hasArrived = true
                        elseif member.location == locationIDs[stone] then
                            print("If 2: ", locationIDs[stone], member.uiMapID, member.location)
                        end
                    end
                end
            end
            if locationIDs[stone] then
                for i = 1, #locationIDs[stone], 1 do
                    if member.uiMapID == locationIDs[stone][i] or member.location == locationIDs[stone][i] then
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
                    return member.name
                end
            end
        end
    end
end

-- CreateEvent when GameToolTip Shows
local function ToolTipOnShow()
    switcher = false
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()

        if GameTooltipLine1 == "Meeting Stone" then
            if not SAVED_PER_CHAR.neverAgain then
                StaticPopup_Show("WhoNeedsASummon_WELCOME")
            end
            savedStoneName = GameTooltipLine2
            GameTooltipLine2 = GameTooltipLine2:gsub("%s+", "")
            GameTooltipLine2 = GameTooltipLine2:gsub("'", "")
            checkWhoHasArrived(GameTooltipLine2)
        end
    end
end

GameTooltip:HookScript("OnShow", ToolTipOnShow)

-- CreateEvent when GameToolTip Update
local function ToolTipOnUpdate()
    switcher = false
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()

        if GameTooltipLine1 == "Meeting Stone"  and GameTooltipLine3 == nil then
            savedStoneName = GameTooltipLine2
            GameTooltipLine2 = GameTooltipLine2:gsub("%s+", "")
            GameTooltipLine2 = GameTooltipLine2:gsub("'", "")
            checkWhoHasArrived(GameTooltipLine2)
        end
    end
end

GameTooltip:HookScript("OnUpdate", ToolTipOnUpdate)

-- CreateEvent when GameToolTip Hides
local function ToolTipOnHide()
    if not (GameTooltipLine1 == GameTooltipTextLeft1:GetText() and GameTooltipLine2 == GameTooltipTextLeft2:GetText() and GameTooltipLine3 == GameTooltipTextLeft3:GetText()) then
        GameTooltipLine1 = GameTooltipTextLeft1:GetText()
        GameTooltipLine2 = GameTooltipTextLeft2:GetText()
        GameTooltipLine3 = GameTooltipTextLeft3:GetText()
    end
end

GameTooltip:HookScript("OnHide", ToolTipOnHide)

if inDebugMode then
    C_Timer.NewTicker(10, checkWhoHasArrived)
end


local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(_, event, ...)
    local arg1 = ...
    if event == "ADDON_LOADED" and arg1 == "WhoNeedsASummon" then
        frame:UnregisterEvent("ADDON_LOADED")
        
        if _G.WhoNeedsASummon_PerCharacter == nil then
            _G.WhoNeedsASummon_PerCharacter = { neverAgain = _G.neverAgain } -- copy the old savedvariable
        end
        SAVED_PER_CHAR = _G.WhoNeedsASummon_PerCharacter
    end
end)
frame:RegisterEvent("ADDON_LOADED")


_G.SLASH_GETLOC1 = "/getloc"

SlashCmdList["GETLOC"] = function()
    local uiMapId = C_Map.GetBestMapForUnit("Player")
    local printStr = "Please give the following |cff00ff98information|r to the developer by commenting on the addon page on |cffff7017CurseForge|r or whispering |cff7289daFyfor#0403|r on Discord: |cff00ff98\nZone Name:|r " .. GetRealZoneText()
    if uiMapId then
        printStr = printStr ..   "\n|cff00ff98Zone ID:|r " .. uiMapId
    end
    if savedStoneName ~= "" then
        printStr = printStr .. "\n|cff00ff98Stone Name:|r " .. savedStoneName .."|r"
    else
        printStr = printStr .. "|r"
    end
    print(printStr)
    savedStoneName = ""
end

StaticPopupDialogs["WhoNeedsASummon_WELCOME"] = {
  text = "Thank you for downloading |cff00ff98\"Who needs a summon?\"|r This addon is still very much in development. If you run into any issues with names incorrectly displaying on meeting stones, please type |cff00ff98/getloc|r and follow the instructions given. Happy gaming!",
  button1 = "Will do",
  button2 = "Never show this again",
  OnCancel = function()
     SAVED_PER_CHAR.neverAgain = true
  end,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}
