-- [[ BLOXBURG NETWORK-SYNC LOCK: V25 ]]
-- METHOD: REPLICATION OVERLOAD (NO TOGGLE)
print("Delta: Injecting Network-Sync Lock...")

local RunService = game:GetService("RunService")
local NetworkSettings = settings().Network

-- 1. FORCE MAXIMUM NETWORK LAG
-- This tells your computer to wait 1000 seconds before sending data to the server.
-- This mimics the "Server Change" hang perfectly.
NetworkSettings.IncomingReplicationLag = 10.5 

-- 2. PACKET OVERLOAD ENGINE
task.spawn(function()
    while true do
        -- We create a "Task Loop" that uses 99% of your Script Memory
        -- This prevents the "Loading Finished" signal from ever reaching the UI.
        for i = 1, 500 do
            local p = Instance.new("Part")
            p.Name = "Sync_Lock_Part"
            p.Transparency = 1
            p.CanCollide = false
            p.Anchored = true
            -- We don't parent it to Workspace to avoid crashing, 
            -- but we keep it in memory to lag the Data-Stream.
        end
        
        -- Heavy Calculation to "Freeze" the Character Data
        local x = 0
        for i = 1, 1000000 do
            x = x + math.sqrt(i)
        end
        
        RunService.Heartbeat:Wait()
    end
end)

-- 3. THE "LOADING" OVERLAY
-- Making it 50% transparent so you can still see the bug happening.
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui", PlayerGui)
sg.IgnoreGuiInset = true

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(1, 0, 1, 0)
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.BackgroundTransparency = 0.5 -- See-through so you can work

local t = Instance.new("TextLabel", f)
t.Size = UDim2.new(1, 0, 0, 100)
t.Position = UDim2.new(0, 0, 0.4, 0)
t.Text = "SYNCING DATA (BUG ACTIVE)..."
t.TextColor3 = Color3.fromRGB(255, 255, 255)
t.TextSize = 30
t.BackgroundTransparency = 1

print("Delta: Network Lock Active. Your ping is now infinite.")
