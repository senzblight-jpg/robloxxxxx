-- [[ BLOXBURG INFINITE-LOADING: ASSET-JAM V26 ]]
-- No toggle needed - Inject right before changing servers.
print("Delta: Injecting Asset-Jam Engine...")

local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")

-- 1. THE ASSET-JAMMER
-- This creates a "Black Hole" in the loading queue.
task.spawn(function()
    while true do
        -- Generate 10,000 fake Asset IDs that don't exist
        local FakeQueue = {}
        for i = 1, 10000 do
            -- Using random IDs ensures the cache can't skip them
            table.insert(FakeQueue, "rbxassetid://999" .. math.random(1000000, 9999999))
        end

        print("JAMMING: Requesting 10,000 Ghost Assets...")
        
        -- This is a 'Blocking' call. It freezes the loading UI 
        -- while it tries to find these fake items.
        pcall(function()
            ContentProvider:PreloadAsync(FakeQueue)
        end)
        
        -- Small wait to prevent an actual crash, but keeps CPU at max
        RunService.Heartbeat:Wait()
    end
end)

-- 2. THE MEMORY OVERLOAD
-- We fill the local RAM so the 'Cleanup' phase of the teleport takes longer.
local MemoryBloat = {}
for i = 1, 500000 do
    MemoryBloat[i] = "BLOCK_CLEANUP_DATA_" .. i
end

-- 3. THE VISUAL STALL
-- This makes the screen stay black even if the game tries to load.
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui", PlayerGui)
sg.IgnoreGuiInset = true
sg.DisplayOrder = 1000000

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(1, 0, 1, 0)
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.ZIndex = 1000000

print("Delta: Asset-Jam Active. Change server now to begin the hang.")
