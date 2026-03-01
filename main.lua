-- [[ BLOXBURG DATA-SYNC LOCK: V22 ]]
print("Delta: Injecting Data-Sync Staller...")

local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")

_G.StallActive = true
local SyncBuffer = {}

-- 1. THE STALLING ENGINE
-- We create "Ghost Assets" that the game thinks it MUST load before the teleport completes.
local function StartStall()
    print("STALLING: Syncing Ghost Data...")
    task.spawn(function()
        while _G.StallActive do
            -- Create 100,000 fake entry points in the memory table
            -- This makes the "Character Saving" process take much longer
            for i = 1, 100000 do
                SyncBuffer[i] = string.rep("SYNC_LOCK_DATA_", 50)
            end
            
            -- Force the ContentProvider to check for 500 fake assets
            -- This clogs the "Downloading Assets" bar in the loading screen
            local fakeAssets = {}
            for i = 1, 500 do
                table.insert(fakeAssets, "rbxassetid://9999999" .. i)
            end
            
            pcall(function()
                ContentProvider:PreloadAsync(fakeAssets)
            end)
            
            -- This tiny wait prevents a crash while keeping the CPU at 100%
            RunService.Stepped:Wait()
        end
    end)
end

-- 2. TOGGLE (Press X)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        _G.StallActive = not _G.StallActive
        if _G.StallActive then
            StartStall()
            print("STATUS: DATA-SYNC LOCKED. CHANGE SERVER NOW.")
        else
            SyncBuffer = {}
            print("STATUS: UNLOCKED.")
        end
    end
end)

-- 3. THE TELEPORT HOOK
-- This tries to keep the stall alive during the black screen
game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    _G.StallActive = false -- Emergency stop if disconnected
end)
