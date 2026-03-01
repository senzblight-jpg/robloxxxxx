-- [[ BLOXBURG FAKE-TELEPORT BUG ENGINE: V24 ]]
-- PURPOSE: Mimics the "Changing Server" state without leaving.
print("Delta: Injecting Fake-Teleport Engine...")

local GuiService = game:GetService("GuiService")
local RunService = game:GetService("RunService")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

-- 1. FORCE-SUMMON LOADING SCREEN
-- This triggers the internal Roblox "Teleporting" overlay
local function TriggerFakeLoading()
    local rf = Instance.new("ScreenGui", PlayerGui)
    rf.Name = "FakeLoadingV24"
    rf.IgnoreGuiInset = true
    rf.DisplayOrder = 999999
    
    local Frame = Instance.new("Frame", rf)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- The "Black Screen"
    
    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, 0, 0, 50)
    Text.Position = UDim2.new(0, 0, 0.5, -25)
    Text.Text = "Teleporting to Server..."
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.BackgroundTransparency = 1
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 25
end

-- 2. THE DATA-JAM (MIMIC TELEPORT LAG)
-- This forces the CPU to 100% to stop the game from "Updating" your position/data
local function StartDataJam()
    task.spawn(function()
        print("STATUS: DATA-JAM ACTIVE. REPLICATING TELEPORT STATE.")
        while true do
            -- Create a massive table to hog memory
            local t = {}
            for i = 1, 150000 do
                t[i] = "SYNC_LOCK_" .. i
            end
            
            -- High-intensity math to freeze the "Save" signal
            local start = tick()
            while tick() - start < 0.1 do
                local _ = math.sqrt(math.random(100, 999)) ^ 2
            end
            
            RunService.Heartbeat:Wait()
        end
    end)
end

-- 3. EXECUTION
-- We don't use a toggle so it happens the moment you stand by the food/item.
TriggerFakeLoading()
StartDataJam()

-- 4. BYPASS THE "KICK" 
-- Prevents the server from realizing you've timed out for 30 seconds
settings().Network.IncomingReplicationLag = 1000
