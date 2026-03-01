-- [[ BLOXBURG NEIGHBORHOOD GHOST-HOP: V30 ]]
print("Delta: Searching for Neighborhood Handshake...")

local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game:GetService("Players").LocalPlayer

_G.InfiniteHopping = true

-- 1. DYNAMIC REMOTE FINDER
-- Bloxburg often renames these. This scans for the one that handles 'Neighborhoods'.
local function GetJoinRemote()
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") and (v.Name:find("Neighborhood") or v.Name:find("Teleport")) then
            if v.Name:lower():find("join") or v.Name:lower():find("request") then
                return v
            end
        end
    end
    -- Fallback to the most common internal name if scan fails
    return ReplicatedStorage:FindFirstChild("JoinNeighborhood", true)
end

local TargetRemote = GetJoinRemote()

-- 2. THE INFINITE LOOP ENGINE
task.spawn(function()
    while _G.InfiniteHopping do
        if TargetRemote then
            -- We fire a request to join a random neighborhood string.
            -- This keeps the server trying to "Verify" your move.
            pcall(function()
                -- Sending a random 6-digit string mimics a private neighborhood ID
                local randomID = tostring(math.random(100000, 999999))
                TargetRemote:FireServer(randomID)
            end)
        end
        
        -- Secondary "Engine Hang"
        -- This forces the Roblox client to prepare for a teleport without leaving.
        pcall(function()
            TeleportService:SetTeleportSetting("StallMode", true)
            TeleportService:Teleport(185655149, Player)
        end)

        -- WAIT TIMING (CRITICAL)
        -- 0.8s is the perfect delay to keep the "Teleporting" UI stuck on your screen.
        task.wait(0.8) 
    end
end)

-- 3. INTERACTION NOTIFIER
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local lbl = Instance.new("TextLabel", sg)
lbl.Size = UDim2.new(0, 300, 0, 50)
lbl.Position = UDim2.new(0.5, -150, 0.05, 0)
lbl.BackgroundColor3 = Color3.fromRGB(85, 0, 255)
lbl.Text = "GHOST-HOP ACTIVE [K TO STOP]"
lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
lbl.Font = Enum.Font.GothamBold
lbl.TextSize = 16

-- 4. EMERGENCY STOP (Press K)
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.K then
        _G.InfiniteHopping = false
        lbl.Text = "STOPPED"
        lbl.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

print("Delta: V30 Engine Active. Stand by food and watch for the 'Teleporting' UI.")
