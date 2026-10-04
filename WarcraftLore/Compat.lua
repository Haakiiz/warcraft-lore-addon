-- Compat.lua
-- EVERY call that depends on the client version lives here.
-- The Forever beta (interface 16001, build 1.60.1) is built on the Mainline/Midnight
-- API (12.x), not the Classic API. If Blizzard changes something in the beta, this is
-- the file to fix. The rest of the addon only calls the functions in ns.Compat.

local _, ns = ...
local C = {}
ns.Compat = C

-- Names of APIs we could not find. Shown by /wcl debug.
C.missing = {}

local function noteMissing(name)
    C.missing[name] = true
end

-- Midnight introduced "secret values": some values (names, GUIDs, …) can be secret
-- in certain situations and then cannot be compared, split or printed.
function C.IsSecret(value)
    if issecretvalue == nil then
        return false
    end
    local ok, secret = pcall(issecretvalue, value)
    return ok and secret == true
end

-- Calls fn safely. Returns nil if fn is missing, fails or returns a secret value.
local function safeCall(name, fn, ...)
    if type(fn) ~= "function" then
        noteMissing(name)
        return nil
    end
    local ok, result = pcall(fn, ...)
    if not ok or result == nil or C.IsSecret(result) then
        return nil
    end
    return result
end

function C.UnitGUID(unit)
    return safeCall("UnitGUID", UnitGUID, unit)
end

function C.UnitName(unit)
    return safeCall("UnitName", UnitName, unit)
end

function C.UnitExists(unit)
    return safeCall("UnitExists", UnitExists, unit) == true
end

-- GUID format in modern clients: "Creature-0-<server>-<instance>-<zone>-<NPC ID>-<spawn>".
-- "Vehicle" is used for rideable NPCs/vehicles and has the same layout.
local NPC_GUID_TYPES = { Creature = true, Vehicle = true }

-- Returns the NPC ID (number) and the GUID type. Players give (nil, "Player").
function C.NPCIDFromGUID(guid)
    if type(guid) ~= "string" or C.IsSecret(guid) then
        return nil, nil
    end
    local unitType, _, _, _, _, npcID = strsplit("-", guid)
    if NPC_GUID_TYPES[unitType] then
        return tonumber(npcID), unitType
    end
    return nil, unitType
end

-- Hooks callback(tooltip, unit, guid) into unit tooltips.
-- Returns the name of the method used, or nil if none was found.
function C.HookUnitTooltip(callback)
    -- Modern API (10.0.2 and later, including Midnight/Forever).
    if TooltipDataProcessor and TooltipDataProcessor.AddTooltipPostCall
        and Enum and Enum.TooltipDataType and Enum.TooltipDataType.Unit then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip, data)
            if tooltip ~= GameTooltip then
                return
            end
            local guid = data and data.guid
            if C.IsSecret(guid) then
                guid = nil
            end
            local unit
            if tooltip.GetUnit then
                local ok, _, u = pcall(tooltip.GetUnit, tooltip)
                if ok and not C.IsSecret(u) then
                    unit = u
                end
            end
            callback(tooltip, unit, guid)
        end)
        return "TooltipDataProcessor"
    end
    noteMissing("TooltipDataProcessor")

    -- Older API (Classic Era / before 10.0.2).
    if GameTooltip and GameTooltip.HasScript and GameTooltip:HasScript("OnTooltipSetUnit") then
        GameTooltip:HookScript("OnTooltipSetUnit", function(tooltip)
            local _, unit = tooltip:GetUnit()
            callback(tooltip, unit, nil)
        end)
        return "OnTooltipSetUnit"
    end
    noteMissing("OnTooltipSetUnit")
    return nil
end

-- Adds a line. Both hook methods above run before the tooltip gets its final
-- size, so there is no need to call Show() ourselves.
function C.AddTooltipLine(tooltip, text, r, g, b)
    tooltip:AddLine(text, r, g, b)
end

-- Buttons: on Forever, OnClick never fires until the button has registered click
-- types (older clients defaulted to LeftButtonUp).
function C.RegisterClicks(button)
    if button.RegisterForClicks then
        button:RegisterForClicks("AnyUp")
    end
end

-- Fonts. STANDARD_TEXT_FONT follows the client's language; the others exist in every client.
C.FONT_BODY = STANDARD_TEXT_FONT or "Fonts\\FRIZQT__.TTF"
C.FONT_TITLE = "Fonts\\MORPHEUS.TTF"

function C.SetFont(fontString, path, size, flags)
    -- Newer clients return false when the font is missing; older ones return nothing.
    if fontString:SetFont(path, size, flags or "") == false then
        fontString:SetFont(C.FONT_BODY, size, flags or "")
    end
end

-- A texture repeated (tiled) along an axis. SetTexture's wrap-mode arguments
-- arrived in Legion; without them the texture is stretched instead.
-- tilesU/tilesV = how many times the tile repeats; negative values mirror it.
function C.SetTiledTexture(texture, path, tilesU, tilesV)
    local ok = pcall(texture.SetTexture, texture, path, "REPEAT", "REPEAT")
    if not ok then
        noteMissing("SetTexture wrap modes")
        texture:SetTexture(path)
        tilesU = tilesU < 0 and -1 or 1
        tilesV = tilesV < 0 and -1 or 1
    end
    local u0, u1 = 0, tilesU
    local v0, v1 = 0, tilesV
    if tilesU < 0 then u0, u1 = -tilesU, 0 end
    if tilesV < 0 then v0, v1 = -tilesV, 0 end
    texture:SetTexCoord(u0, u1, v0, v1)
end

-- A round mask on a texture (the portrait). Without masks the portrait stays square.
function C.ApplyCircleMask(texture, maskPath)
    local parent = texture:GetParent()
    if not (parent and parent.CreateMaskTexture and texture.AddMaskTexture) then
        noteMissing("CreateMaskTexture")
        return false
    end
    local mask = parent:CreateMaskTexture()
    mask:SetTexture(maskPath, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    mask:SetAllPoints(texture)
    texture:AddMaskTexture(mask)
    return true
end

-- A unit's WoW portrait (the same as in the target frame).
function C.SetUnitPortrait(texture, unit)
    if type(SetPortraitTexture) ~= "function" then
        noteMissing("SetPortraitTexture")
        return false
    end
    local ok = pcall(SetPortraitTexture, texture, unit)
    return ok
end

-- Registers an event if the client knows it. Returns false instead of erroring
-- when the event does not exist in this client version.
function C.RegisterEventSafe(frame, event)
    local ok = pcall(frame.RegisterEvent, frame, event)
    if not ok then
        noteMissing("event " .. event)
    end
    return ok
end

-- Fires with a unit token ("nameplate3") when a nameplate appears. Nameplates only
-- exist for units whose plates are shown (friendly NPC plates may need to be enabled).
C.EVENT_NAMEPLATE_ADDED = "NAME_PLATE_UNIT_ADDED"

-- A short, unobtrusive alert sound.
function C.PlayAlertSound()
    if type(PlaySound) ~= "function" then
        noteMissing("PlaySound")
        return
    end
    local kit = SOUNDKIT and (SOUNDKIT.MAP_PING or SOUNDKIT.IG_QUEST_LOG_OPEN)
    if kit then
        pcall(PlaySound, kit, "Master")
    end
end

-- Lets Esc close the window. The frame needs a global name.
function C.RegisterEscapeClose(frame)
    local name = frame:GetName()
    if name and type(UISpecialFrames) == "table" then
        table.insert(UISpecialFrames, name)
    else
        noteMissing("UISpecialFrames")
    end
end

-- Prints to the default chat frame.
function C.Print(msg)
    local chat = DEFAULT_CHAT_FRAME
    if chat and chat.AddMessage then
        chat:AddMessage(msg)
    else
        print(msg)
    end
end

-- Client facts for /wcl debug.
function C.Report()
    local build, interface
    if GetBuildInfo then
        local _
        build, _, _, interface = GetBuildInfo()
    end
    return {
        build = build,
        interface = interface,
        issecretvalue = issecretvalue ~= nil,
        tooltipDataProcessor = TooltipDataProcessor ~= nil,
    }
end

-- Player position on the current map: mapID, x, y (x and y in 0..1), or nil if unknown
-- (no map, instance, or secret values).
function C.GetPlayerMapPos()
    if type(C_Map) ~= "table" or type(C_Map.GetBestMapForUnit) ~= "function"
        or type(C_Map.GetPlayerMapPosition) ~= "function" then
        noteMissing("C_Map.GetPlayerMapPosition")
        return nil
    end
    local okMap, mapID = pcall(C_Map.GetBestMapForUnit, "player")
    if not okMap or type(mapID) ~= "number" or C.IsSecret(mapID) then
        return nil
    end
    local okPos, pos = pcall(C_Map.GetPlayerMapPosition, mapID, "player")
    if not okPos or type(pos) ~= "table" or type(pos.GetXY) ~= "function" then
        return nil
    end
    local okXY, x, y = pcall(pos.GetXY, pos)
    if not okXY or type(x) ~= "number" or type(y) ~= "number" or C.IsSecret(x) or C.IsSecret(y) then
        return nil
    end
    return mapID, x, y
end

-- True when the player is inside an instance (dungeon, raid, battleground, arena).
function C.InInstance()
    if type(IsInInstance) ~= "function" then
        noteMissing("IsInInstance")
        return false
    end
    local ok, inInstance = pcall(IsInInstance)
    return ok and inInstance == true
end

-- Calls fn every `seconds` seconds. Returns true if the ticker could be started.
function C.StartTicker(seconds, fn)
    if type(C_Timer) ~= "table" or type(C_Timer.NewTicker) ~= "function" then
        noteMissing("C_Timer.NewTicker")
        return false
    end
    return pcall(C_Timer.NewTicker, seconds, fn)
end
