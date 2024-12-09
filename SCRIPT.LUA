local ESP, Speed, Jump = {Enabled = true, Color = Color3.fromRGB(0, 255, 0), Distance = 300}, 32, 100

local function setup()
    local h = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait():WaitForChild("Humanoid")
    h.WalkSpeed, h.JumpPower = Speed, Jump
end

local function createESP(p)
    local tag = Drawing.new("Text")
    tag.Visible, tag.Color, tag.Center, tag.Size, tag.Outline = false, ESP.Color, true, 20, true
    coroutine.wrap(function()
        while task.wait() and p.Character and p.Character:FindFirstChild("HumanoidRootPart") do
            local hrp, plrPos = p.Character.HumanoidRootPart, game.Players.LocalPlayer.Character.HumanoidRootPart
            local pos, vis = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
            tag.Visible = vis and (hrp.Position - plrPos.Position).Magnitude <= ESP.Distance
            if tag.Visible then tag.Position, tag.Text = Vector2.new(pos.X, pos.Y - 15), p.Name end
        end
    end)()
end

for _, p in pairs(game.Players:GetPlayers()) do if p ~= game.Players.LocalPlayer then createESP(p) end end
game.Players.PlayerAdded:Connect(function(p) task.wait(1) createESP(p) end)
game.Players.LocalPlayer.CharacterAdded:Connect(function() task.wait(1) setup() end)

local gui, frame = Instance.new("ScreenGui", game.CoreGui), Instance.new("Frame")
frame.Parent, frame.Size, frame.Position, frame.BackgroundColor3, frame.Active, frame.Draggable = gui, UDim2.new(0, 300, 0, 200), UDim2.new(0.5, -150, 0.5, -100), Color3.fromRGB(50, 50, 50), true, true

local function btn(txt, pos, color, act)
    local b = Instance.new("TextButton", frame)
    b.Text, b.Size, b.Position, b.BackgroundColor3, b.TextColor3, b.TextSize = txt, UDim2.new(0.8, 0, 0, 40), pos, color, Color3.new(0, 0, 0), 18
    b.MouseButton1Click:Connect(act)
end

Instance.new("TextLabel", frame).Text, frame.TextLabel.Size = "ESP Menu", UDim2.new(1, 0, 0, 40)
btn("Toggle ESP", UDim2.new(0.1, 0, 0.3, 0), Color3.fromRGB(0, 255, 0), function() ESP.Enabled = not ESP.Enabled end)
btn("Delete Menu", UDim2.new(0.1, 0, 0.6, 0), Color3.fromRGB(255, 0, 0), function() gui:Destroy() end)

setup()
