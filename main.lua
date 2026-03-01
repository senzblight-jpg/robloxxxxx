-- [[ TRANSITION PROLONG ENGINE ]]
-- WARNING: This will make your game lag heavily until the teleport is done.
print("Delta: Injecting Transition Delay...")

local RunService = game:GetService("RunService")

_G.ProlongLoading = true

-- Toggle with 'X' instead of 'Z' to avoid conflict with your Take script
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.X then
        _G.ProlongLoading = not _G.ProlongLoading
        print("Delay Mode: " .. tostring(_G.ProlongLoading))
    end
end)

-- The "Heavy Lift" Loop
task.spawn(function()
    while true do
        if _G.ProlongLoading then
            -- This forces the CPU to calculate 1 million math operations every frame
            -- This delays the rendering of the new server's UI
            for i = 1, 1000000 do
                local mathHelper = math.sqrt(i) * math.tan(i)
            end
        end
        RunService.Heartbeat:Wait()
    end
end)
