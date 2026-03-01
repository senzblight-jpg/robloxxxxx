-- [[ BLOXBURG LOADING PROLONG: REQUEST OVERLOAD ]]
print("Delta: Injecting RequestQueue Bloat...")

local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

_G.BloatActive = true
local GarbageStorage = {}

-- 1. THE BLOAT FUNCTION
-- This creates massive data "noise" that the engine must clean up before it can load the next server.
local function StartBloat()
    print("CRITICAL: Bloating Game Memory...")
    task.spawn(function()
        while _G.BloatActive do
            -- Create 50,000 long strings to hog RAM
            for i = 1, 50000 do
                table.insert(GarbageStorage, string.rep("LOADING_DELAY_", 100))
            end
            -- Force the engine to process asset requests that don't exist
            for i = 1, 100 do
                game:GetService("ContentProvider"):PreloadAsync({"rbxassetid://0"})
            end
            task.wait(0.1)
        end
    end)
end

-- 2. TOGGLE (Press X)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        _G.BloatActive = not _G.BloatActive
        if _G.BloatActive then
            StartBloat()
            print("DELAY MODE: ACTIVE (Switch servers now)")
        else
            GarbageStorage = {} -- Clear it
            print("DELAY MODE: OFF")
        end
    end
end)

-- 3. AUTO-CLEANUP ATTEMPT
-- This tries to keep the script running until the very last millisecond of the teleport
TeleportService.TeleportInitFailed:Connect(function()
    _G.BloatActive = false
    GarbageStorage = {}
end)
