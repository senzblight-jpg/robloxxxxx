-- [[ BLOXBURG NEIGHBORHOOD CRAWL-STALL: V32 ]]
print("Delta: Initiating Neighborhood Crawl-Engine...")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Player = game:GetService("Players").LocalPlayer

_G.NeighborhoodCrawl = true

-- 1. SEARCH FOR THE NEIGHBORHOOD HANDSHAKE
-- Bloxburg uses a specific RemoteFunction to verify Private Server IDs.
local function GetNeighborhoodRemote()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:find("Neighborhood") or v.Name:find("PrivateServer")) then
            if v.Name:lower():find("join") or v.Name:lower():find("request") then
                return v
            end
        end
    end
    return ReplicatedStorage:FindFirstChild("JoinNeighborhood", true)
end

local JoinRemote = GetNeighborhoodRemote()

-- 2. THE CRAWL-ENGINE
task.spawn(function()
    while _G.NeighborhoodCrawl do
        if JoinRemote then
            -- We generate a 'Crawl ID' that matches the Neighborhood format
            -- (Usually a 5-7 digit string or a specific Player Name)
            local crawlID = tostring(math.random(100000, 999999))
            
            pcall(function()
                -- Firing the Neighborhood Join Request
                -- This forces the "Joining Neighborhood" loading bar to appear
                JoinRemote:FireServer(crawlID)
            end)
        end
        
        -- STALL-LOCK: Instead of Teleporting to Public, we "Request" a Teleport 
        -- to a specific Private Server instance (Neighborhood).
        -- This is what keeps the data "In-Flight" between servers.
        pcall(function()
            -- 185655149 is Bloxburg, but we add a 'PrivateServerId' tag
            -- to prevent it from defaulting to Public servers.
            TeleportService:TeleportToPrivateServer(185655149, "STALL_SYNC_ID", {Player})
        end)

        -- WAIT TIMING (0.9s is the 'Infinite Loading' sweet spot)
        task.wait(0.9)
    end
end)

-- 3. INTERFACE (Neighborhood Cyan)
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 320, 0, 50)
frame.Position = UDim2.new(0.5, -160, 0.01, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 150, 200)

local lbl = Instance.new("TextLabel", frame)
lbl.Size = UDim2.new(1, 0, 1, 0)
lbl.Text = "NEIGHBORHOOD CRAWL: ON"
lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 14
lbl.BackgroundTransparency = 1

-- 4. EMERGENCY STOP (Press K)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        _G.NeighborhoodCrawl = false
        frame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        lbl.Text = "CRAWL STOPPED"
    end
end)

print("Delta: V32 Active. Target: Neighborhood Private Servers.")
