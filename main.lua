-- [[ BLOXBURG INFINITE-HANG: V23 ]]
-- AUTO-RUN: NO TOGGLE REQUIRED
print("Delta: Injecting Infinite-Hang Engine...")

local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

-- 1. PREVENT SCRIPT FROM BEING KILLED
-- This attempts to keep the data-jam alive during the "Black Screen"
TeleportService.LocalPlayerArrivedFromServer:Connect(function()
    print("ENTRY DETECTED: RESUMING STALL...")
end)

-- 2. THE OVERLOAD ENGINE
task.spawn(function()
    local StallBuffer = {}
    
    while true do
        -- STEP A: CLOG THE ASSET PIPELINE
        -- This forces the loading bar to wait for 5,000 "errors" before loading the map
        local AssetList = {}
        for i = 1, 5000 do
            table.insert(AssetList, "rbxassetid://666" .. math.random(100000, 999999))
        end
        
        -- High-priority async call that blocks the UI thread
        pcall(function()
            ContentProvider:PreloadAsync(AssetList)
        end)

        -- STEP B: RAM SATURATION
        -- We fill the memory with "Sync Noise" so the game can't save/load character data quickly
        for i = 1, 200000 do
            StallBuffer[i] = string.rep("DATA_SYNC_STALLER_V23_", 60)
        end

        -- STEP C: CPU THROTTLE
        -- This ensures the game cannot finish the "Server Connection" handshake instantly
        local start = tick()
        while tick() - start < 0.2 do
            local _ = math.sin(tick()) * math.tan(tick())
        end

        -- Frame sync to prevent the client from crashing (keeps it in "Infinite Loading")
        RunService.Heartbeat:Wait()
    end
end)

print("Delta: Engine Active. Server changes will now hang indefinitely.")
