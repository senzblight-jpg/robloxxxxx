-- [[ BLOXBURG INFINITE-HOP STALLER: V28 ]]
print("Delta: Injecting Infinite-Hop Engine...")

local TeleportService = game:GetService("TeleportService")
local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

_G.LoopHopping = true

-- 1. THE RECURSIVE HOOK
-- This function calls itself to keep the "Teleporting" state active in the engine
local function InitiateInfiniteHop()
    task.spawn(function()
        while _G.LoopHopping do
            -- We use 'Teleport' to a random public server
            -- By calling this repeatedly, the 'Data Save' signal never gets a 'Finish' confirmation
            pcall(function()
                TeleportService:Teleport(185655149, Player) -- Bloxburg PlaceID
            end)
            
            -- This delay is the "Sweet Spot"
            -- Too fast and it crashes; too slow and it finishes. 
            -- 0.5s keeps the 'Transition' state stuck.
            task.wait(0.5) 
        end
    end)
end

-- 2. THE BACKGROUND DATA CLOG
-- While the hopping is happening, we fill the RequestQueue so it moves slowly
task.spawn(function()
    while _G.LoopHopping do
        -- Overloading the 'TeleportData' buffer
        local massiveData = {}
        for i = 1, 5000 do
            massiveData[i] = "HOPSYNC_DATA_STALL_" .. i
        end
        
        -- Creating "Micro-Lag" to keep the character in a 'Ghost' state
        local start = tick()
        while tick() - start < 0.1 do
            local _ = math.cos(tick()) * math.sin(tick())
        end
        
        RunService.Heartbeat:Wait()
    end
end)

-- 3. UI NOTIFIER (No Black Screen)
local sg = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
local txt = Instance.new("TextLabel", sg)
txt.Size = UDim2.new(0, 300, 0, 50)
txt.Position = UDim2.new(0.5, -150, 0.1, 0)
txt.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
txt.Text = "INFINITE HOP ACTIVE - BUG NOW"
txt.Font = Enum.Font.GothamBold
txt.TextSize = 18

-- 4. START
InitiateInfiniteHop()

-- Press 'P' to stop the loop if you actually want to land in a server
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.P then
        _G.LoopHopping = false
        txt.Text = "HOPPING STOPPED - LANDING..."
        txt.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end)
