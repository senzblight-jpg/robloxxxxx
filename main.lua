-- [[ BLOXBURG NEIGHBORHOOD-LOOP STALLER: V31 ]]
print("Delta: Targeting Neighborhood Handshake...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Player = game:GetService("Players").LocalPlayer
local UserInputService = game:GetService("UserInputService")

_G.NeighborhoodLoop = true

-- 1. NEIGHBORHOOD REMOTE SCANNER
-- Scans specifically for the event that triggers the Neighborhood Join
local function FindNeighborhoodRemote()
    local target = nil
    -- Scan ReplicatedStorage for any event containing "Join" and "Neighborhood"
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and v.Name:find("Neighborhood") then
            if v.Name:lower():find("join") or v.Name:lower():find("enter") then
                target = v
                break
            end
        end
    end
    return target or ReplicatedStorage:FindFirstChild("JoinNeighborhood", true)
end

local JoinRemote = FindNeighborhoodRemote()

-- 2. THE INFINITE NEIGHBORHOOD HOP ENGINE
task.spawn(function()
    while _G.NeighborhoodLoop do
        if JoinRemote then
            -- Generate a random 6-digit Neighborhood ID
            -- This forces the game to try and "Find" a neighborhood that doesn't exist
            local fakeNeighborhoodID = tostring(math.random(111111, 999999))
            
            pcall(function()
                -- Firing the Neighborhood remote specifically
                JoinRemote:FireServer(fakeNeighborhoodID)
            end)
        end
        
        -- VISUAL SYNC: This triggers the native "Teleporting..." circle
        -- By targeting the Bloxburg PlaceID directly, we keep the data 'In-Flight'
        pcall(function()
            TeleportService:SetTeleportSetting("StallMode", true)
            TeleportService:Teleport(185655149, Player)
        end)

        -- CRITICAL STALL DELAY
        -- 0.8s allows the 'Joining Neighborhood' UI to stay stuck without a full load
        task.wait(0.8)
    end
end)

-- 3. INTERFACE (Clear Screen)
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 300, 0, 45)
frame.Position = UDim2.new(0.5, -150, 0.02, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 200, 255) -- Neighborhood Blue

local lbl = Instance.new("TextLabel", frame)
lbl.Size = UDim2.new(1, 0, 1, 0)
lbl.Text = "NEIGHBORHOOD-LOOP: ACTIVE"
lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
lbl.Font = Enum.Font.GothamBold
lbl.BackgroundTransparency = 1

-- 4. EMERGENCY STOP (Press K)
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        _G.NeighborhoodLoop = false
        frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        lbl.Text = "STALL STOPPED"
    end
end)

print("Delta: V31 Active. Remote Found: " .. (JoinRemote and JoinRemote.Name or "Not Found"))
