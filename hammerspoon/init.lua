require("hs.ipc")

-- ── Audio: auto-switch output based on device priority ──────────────────────
local AUDIO_PRIORITY = {
    "Soundcore Space A40",
    "Headphone",
    "MacBook Pro Speakers",
}

local function switchToBestOutput()
    for _, name in ipairs(AUDIO_PRIORITY) do
        local device = hs.audiodevice.findOutputByName(name)
        if device then
            if hs.audiodevice.defaultOutputDevice():name() ~= name then
                device:setDefaultOutputDevice()
                hs.notify.new({title="Audio", informativeText="Switched to " .. name}):send()
            end
            return
        end
    end
end

-- Event codes are always 4 chars: "dIn ", "dOut", "sOut", "dev#".
-- "dev#" is a device appearing/disappearing, and it is the ONLY event fired
-- when the dock's audio device shows up while the current default stays valid.
hs.audiodevice.watcher.setCallback(function(event)
    if event == "dOut" or event == "sOut" or event == "dev#" then
        switchToBestOutput()
    end
end)
hs.audiodevice.watcher.start()
switchToBestOutput()

-- ── Ratwarp: per-window mouse position memory ────────────────────────────────
local STORE_DIR = os.getenv("HOME") .. "/.cache/ratwarp"
os.execute("mkdir -p " .. STORE_DIR)

local lastWindowId = nil

-- Some windows aren't a real context change. Google Meet's floating "ongoing
-- call" window is a Chrome document-picture-in-picture window that steals focus
-- every time you flip tabs mid-call; warping to its center and back is noise.
-- Focusing an excluded window is a no-op: no save, no restore, and lastWindowId
-- is left alone so returning to the previous window doesn't warp either.
local RATWARP_DEBUG = false
local RATWARP_LOG = "/tmp/ratwarp-focus.log"

-- Free-form debug line (save/restore decisions), same log and switch as ratwarpLog.
local function ratwarpNote(fmt, ...)
    if not RATWARP_DEBUG then return end
    local f = io.open(RATWARP_LOG, "a")
    if not f then return end
    f:write(os.date("%H:%M:%S") .. "   " .. string.format(fmt, ...) .. "\n")
    f:close()
end

-- Meet's floating window is a Chrome document-picture-in-picture window. It
-- reports subrole AXStandardWindow, so isStandard() can't spot it, and AeroSpace
-- never manages it (so aerospace's own on-focus-changed move-mouse doesn't fire
-- for it -- this is purely a ratwarp concern). It is titled "Meet - <code>" and,
-- unlike every real browser window, has no " - Google Chrome" suffix.
local function isExcluded(win)
    local app = win:application()
    if not app or app:bundleID() ~= "com.google.Chrome" then return false end
    local title = win:title() or ""
    return title:match("^Meet %- ") ~= nil and title:match("Google Chrome$") == nil
end

local function ratwarpLog(win, skipped)
    if not RATWARP_DEBUG then return end
    local f = io.open(RATWARP_LOG, "a")
    if not f then return end
    local app = win:application()
    local fr = win:frame()
    f:write(string.format(
        "%s skip=%s id=%s app=%q bundle=%s role=%s subrole=%s standard=%s frame=%dx%d@%d,%d title=%q\n",
        os.date("%H:%M:%S"), tostring(skipped), tostring(win:id()),
        app and app:name() or "?", app and app:bundleID() or "?",
        tostring(win:role()), tostring(win:subrole()), tostring(win:isStandard()),
        fr.w, fr.h, fr.x, fr.y, win:title() or ""))
    f:close()
end

-- Where the USER last put the mouse while lastWindowId was focused. Sampling
-- hs.mouse.absolutePosition() at focus-change time is wrong: AeroSpace's own
-- move-mouse (on-focus-changed / on-focused-monitor-changed) often warps the
-- cursor into the NEW window before this callback runs, so the old window got
-- saved with the new window's center. Cursor warps (AeroSpace's and ours) post
-- no mouseMoved events, so tracking real movement is immune to that race.
local lastUserMousePos = nil
-- Frame of the focused window, cached at focus time. On fallensword AeroSpace's
-- warps DO post mouseMoved events, so movement alone can't tell the user from
-- AeroSpace; a position only counts for a window if it lies inside that window.
-- AeroSpace pulling the cursor into the NEXT window is then ignored.
local lastWindowFrame = nil

local function pointInFrame(p, fr)
    return fr and p.x >= fr.x and p.x < fr.x + fr.w and p.y >= fr.y and p.y < fr.y + fr.h
end

-- Keep a global reference: an eventtap that gets garbage-collected stops silently.
ratwarpMouseTap = hs.eventtap.new({
    hs.eventtap.event.types.mouseMoved,
    hs.eventtap.event.types.leftMouseDragged,
    hs.eventtap.event.types.rightMouseDragged,
}, function(_)
    local p = hs.mouse.absolutePosition()
    if pointInFrame(p, lastWindowFrame) then
        lastUserMousePos = p
    end
    return false  -- observe only, never swallow the event
end)
ratwarpMouseTap:start()

local function saveMousePos(windowId)
    if not windowId then return end
    -- Nothing moved since this window got focus: keep whatever was saved before.
    if not lastUserMousePos then return end
    local pos = lastUserMousePos
    ratwarpNote("SAVE id=%s pos=%d,%d", tostring(windowId), math.floor(pos.x), math.floor(pos.y))
    local f = io.open(STORE_DIR .. "/" .. tostring(windowId), "w")
    if f then
        f:write(math.floor(pos.x) .. "," .. math.floor(pos.y))
        f:close()
    end
end

local function restoreMousePos(windowId)
    if not windowId then return end
    local f = io.open(STORE_DIR .. "/" .. tostring(windowId), "r")
    if f then
        local data = f:read("*l")
        f:close()
        local x, y = data:match("(-?%d+),(-?%d+)")
        if x and y then
            ratwarpNote("RESTORE id=%s saved=%s,%s", tostring(windowId), x, y)
            hs.mouse.absolutePosition({x=tonumber(x), y=tonumber(y)})
            return
        end
    end
    -- No saved position: center on the window
    local win = hs.window.get(windowId)
    if win then
        local frame = win:frame()
        hs.mouse.absolutePosition({
            x = frame.x + frame.w / 2,
            y = frame.y + frame.h / 2,
        })
    end
end

local windowFilter = hs.window.filter.new(nil, "ratwarp")
windowFilter:subscribe(hs.window.filter.windowFocused, function(win)
    local excluded = isExcluded(win)
    local m = hs.mouse.absolutePosition()
    ratwarpNote("FOCUS new=%s last=%s mouse_now=%d,%d", tostring(win:id()), tostring(lastWindowId), math.floor(m.x), math.floor(m.y))
    ratwarpLog(win, excluded)
    if excluded then return end

    local newId = win:id()
    if lastWindowId ~= newId then
        saveMousePos(lastWindowId)
        lastWindowId = newId
        lastWindowFrame = win:frame()
        lastUserMousePos = nil  -- only movement made in the NEW window counts from here
        restoreMousePos(newId)
    end
end)

-- ── SecurityAgent: surface sudo/auth prompts so they don't hide on a stray Space ─
local preAuthWindow = nil

-- Track last focused non-SecurityAgent window
local authFocusTracker = hs.window.filter.new(nil, "authFocusTracker")
authFocusTracker:subscribe(hs.window.filter.windowFocused, function(win)
    local app = win:application()
    if app and app:name() ~= "SecurityAgent" then
        preAuthWindow = win
    end
end)

-- Watch the SecurityAgent process itself (more reliable than window events)
local authAppWatcher = hs.application.watcher.new(function(appName, eventType, appObj)
    if appName ~= "SecurityAgent" then return end

    if eventType == hs.application.watcher.activated then
        hs.execute("/usr/bin/afplay /System/Library/Sounds/Sosumi.aiff &")
        hs.alert.show("auth prompt waiting", {
            strokeColor = {red=1, green=0.3, blue=0.3, alpha=1},
            fillColor  = {red=0, green=0, blue=0, alpha=0.9},
            textSize   = 40,
        }, 4)

        -- Give the window a moment to materialize, then jump to its Space
        hs.timer.doAfter(0.3, function()
            local win = appObj:mainWindow() or appObj:focusedWindow()
            if not win then
                local all = appObj:allWindows()
                if all and #all > 0 then win = all[1] end
            end
            if win then
                local spaces = hs.spaces.windowSpaces(win:id())
                if spaces and #spaces > 0 then
                    pcall(hs.spaces.gotoSpace, spaces[1])
                end
                pcall(function() win:focus() end)
            end
        end)
    elseif eventType == hs.application.watcher.deactivated then
        if preAuthWindow then
            hs.timer.doAfter(0.1, function()
                pcall(function() preAuthWindow:focus() end)
            end)
        end
    end
end)
authAppWatcher:start()
