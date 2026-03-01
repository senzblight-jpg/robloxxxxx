-- [[ BLOXBURG NEIGHBORHOOD LOOP-HOPPER: V29 ]]
print("Delta: Injecting Neighborhood-Hopping Staller...")

local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

_G.NeighborhoodHop = true

-- 1. THE JOIN-EVENT FINDER
-- This locates the specific Bloxburg event used to switch neighborhoods
local JoinEvent = ReplicatedStorage:FindFirstChild("JoinNeighborhood", true) or ReplicatedStorage:FindFirstChild("TeleportToNeighborhood", true)

-- 2. THE INFINITE NEIGHBORHOOD LOOP
task.spawn(function()
    while _G.NeighborhoodHop do
        -- We generate a "Dummy" neighborhood join request
        -- This forces the 'Loading' screen to trigger without a black-out
        if JoinEvent then
            pcall(function()
                -- Firing with "Random" or a fake ID triggers the 'Searching' state
                JoinEvent:FireServer("Random_Sync_" .. math.random(100, 999))
            end)
        end

        -- Secondary Force: Standard Teleport to the Bloxburg Start-Place
        -- This ensures the character data stays 'In-Flight'
        pcall(function()
            TeleportService:Teleport(185655149, Player)
        end)

        -- STALL TIMING: 0.7 seconds is the fastest the server can handle 
        -- multiple neighborhood requests before the 'Loading' UI disappears.
        task.wait(0.7)
    end
end)

-- 3. INTERACTION NOTIFIER (Keeps screen clear)
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 250, 0, 40)
frame.Position = UDim2.new(0.5, -125, 0.05, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 1, 0)
label.Text = "NEIGHBORHOOD HOPPING..."
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.GothamBold
label.BackgroundTransparency = 1

-- 4. EMERGENCY STOP (Press K)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        _G.NeighborhoodHop = false
        frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        label.Text = "HOP STOPPED"
    end
end)
