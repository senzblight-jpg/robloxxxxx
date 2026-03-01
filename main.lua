-- [[ BLOXBURG BLIND-JOIN & INFINITE STALL: V27 ]]
print("Delta: Injecting Blind-Join Engine...")

local ContentProvider = game:GetService("ContentProvider")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. THE AUTO-JOIN ENGINE (Bypasses UI)
-- This tries to force-join a neighborhood even if your screen is black.
task.spawn(function()
    while true do
        -- Bloxburg uses RemoteEvents for joining. 
        -- We attempt to fire the 'Join' signal every 2 seconds until successful.
        local joinRemote = ReplicatedStorage:FindFirstChild("JoinNeighborhood", true) 
        if joinRemote and joinRemote:IsA("RemoteEvent") then
            -- Firing with a 'nil' or random string usually triggers a random join
            joinRemote:FireServer("Random") 
            print("Delta: Sent Blind-Join Request...")
        end
        task.wait(2)
    end
end)

-- 2. THE ASSET-JAM (The "Forever Loading" part)
task.spawn(function()
    while true do
        local FakeQueue = {}
        for i = 1, 15000 do -- Increased to 15,000 for even longer stall
            table.insert(FakeQueue, "rbxassetid://111" .. math.random(1000000, 9999999))
        end

        pcall(function()
            -- This blocks the thread, making the 'Loading' stay stuck
            ContentProvider:PreloadAsync(FakeQueue)
        end)
        
        RunService.Heartbeat:Wait()
    end
end)

-- 3. THE PERMANENT BLACKOUT
local Player = game:GetService("Players").LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local sg = Instance.new("ScreenGui", PlayerGui)
sg.Name = "BlindStateV27"
sg.IgnoreGuiInset = true
sg.DisplayOrder = 1000000

local f = Instance.new("Frame", sg)
f.Size = UDim2.new(1, 0, 1, 0)
f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
f.ZIndex = 1000000

print("Delta: V27 Active. Screen is locked black, Auto-Join is searching.")
