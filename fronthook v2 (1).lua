
local TeamCheck = false
local TeamColors = false
local HideFriendly = false
local HideEnemy = false
local Storage = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Neutral = Color3.fromRGB(255, 255, 255)
local Friendly = Color3.fromRGB(47, 211, 61)
local Enemy = Color3.fromRGB(211, 47, 47)





local tpKillEnabled = false 
local tpKillKey = Enum.KeyCode.E  
local Esp = false
local Names = false
local ColoEs = Color3.fromRGB(255, 255, 255)
local ColoNa = Color3.fromRGB(255, 255, 255)
local HighlightEnabled = false
local HighlightColor = Color3.fromRGB(175, 25, 255)


local TeamCheck = true 
local tpKillEnabled = false 
local tpKillKey = Enum.KeyCode.E  
local Players = game:GetService("Players")

local flyEnabled = false
local flyKey = Enum.KeyCode.F  
local flySpeed = 50  
local userInputService = game:GetService("UserInputService")

local function tpkill()
    if not tpKillEnabled then return end 
    local camera = game:GetService('Workspace').CurrentCamera
    local client = Players.LocalPlayer
    
    local function getClosestPlayer()
        local closestPlayer
        local shortestDistance = math.huge
     
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= client and player.Character and player.Character:FindFirstChild('HumanoidRootPart') and player.TeamColor ~= client.TeamColor then
                if not TeamCheck or player.TeamColor ~= client.TeamColor then
                    local distance = (player.Character.HumanoidRootPart.Position - client.Character.HumanoidRootPart.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
        
        return closestPlayer
    end
    
    local target = getClosestPlayer()
    if target and target.Character and target.Character:FindFirstChild('HumanoidRootPart') then
        local targetPos = target.Character.HumanoidRootPart.Position
        if targetPos.Y > 0 then  
            client.Character.HumanoidRootPart.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0)) 
        else
            print("nigga is under the map, skipping teleport.")
        end
    end
end



game:GetService("RunService").RenderStepped:Connect(function()
    if tpKillEnabled then
        tpkill()  
    end
end)


RunService.RenderStepped:Connect(function()
    if tpKillEnabled then
        tpkill()  
    end
end)


game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == tpKillKey then
        tpkill()
    end
end)



game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == tpKillKey then
        tpkill()  
    end
end)
local Camera = game:GetService("Workspace").CurrentCamera

local StarterGui = game:GetService("StarterGui")
local Settings = {
    Box_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Color = Color3.fromRGB(255, 0, 0),
    Tracer_Thickness = 1,
    Box_Thickness = 1,
    Tracer_Origin = "Bottom", 
    Tracer_FollowMouse = false,
    Tracers = false
}

local Team_Check = {
    TeamCheck = false, 
    Green = Color3.fromRGB(0, 255, 0),
    Red = Color3.fromRGB(255, 0, 0)
}

local TeamColor = true

local player = game:GetService("Players").LocalPlayer
local camera = game:GetService("Workspace").CurrentCamera
local mouse = player:GetMouse()
local FillColor = Color3.fromRGB(175,25,255)
local DepthMode = "AlwaysOnTop"
local FillTransparency = 0.5
local OutlineColor = Color3.fromRGB(255,255,255)
local OutlineTransparency = 0

local CoreGui = game:FindService("CoreGui")
local Players = game:FindService("Players")
local lp = Players.LocalPlayer
local connections = {}

local Storage = Instance.new("Folder")
Storage.Parent = CoreGui
Storage.Name = "Highlight_Storage"

local function Highlight(plr)
    local Highlight = Instance.new("Highlight")
    Highlight.Name = plr.Name
    Highlight.FillColor = HighlightColor  
    Highlight.DepthMode = DepthMode
    Highlight.FillTransparency = FillTransparency
    Highlight.OutlineColor = OutlineColor
    Highlight.OutlineTransparency = 0
    Highlight.Enabled = HighlightEnabled  
    Highlight.Parent = Storage
    
    local plrchar = plr.Character
    if plrchar then
        Highlight.Adornee = plrchar
    end

    connections[plr] = plr.CharacterAdded:Connect(function(char)
        Highlight.Adornee = char
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    Highlight(player)
end
Players.PlayerAdded:Connect(Highlight)
Players.PlayerRemoving:Connect(function(plr)
    local highlight = Storage:FindFirstChild(plr.Name)
    if highlight then
        highlight:Destroy()
    end
    if connections[plr] then
        connections[plr]:Disconnect()
    end
end)

local function NewQuad(thickness, color)
    local quad = Drawing.new("Quad")
    quad.Visible = false
    quad.PointA = Vector2.new(0, 0)
    quad.PointB = Vector2.new(0, 0)
    quad.PointC = Vector2.new(0, 0)
    quad.PointD = Vector2.new(0, 0)
    quad.Color = color
    quad.Filled = false
    quad.Thickness = thickness
    quad.Transparency = 1
    return quad
end

local function NewLine(thickness, color)
    local line = Drawing.new("Line")
    line.Visible = false
    line.From = Vector2.new(0, 0)
    line.To = Vector2.new(0, 0)
    line.Color = color 
    line.Thickness = thickness
    line.Transparency = 1
    return line
end

local function NewText(size, color)
    local text = Drawing.new("Text")
    text.Visible = false
    text.Size = size
    text.Color = color
    text.Center = true
    text.Outline = true
    text.OutlineColor = Color3.fromRGB(0, 0, 0) 
    text.Text = ""
    return text
end

local function Visibility(state, lib)
    for _, x in pairs(lib) do
        x.Visible = state
    end
end

local black = Color3.fromRGB(0, 0, 0)
local connections = {}
local tracers = {} 
local names = {} 

local function ESPCleanup(plr)
   
    if tracers[plr] then
        for _, tracer in pairs(tracers[plr]) do
            tracer.Visible = false
            tracer:Remove()  
        end
        tracers[plr] = nil  
    end
    
   
    if names[plr] then
        names[plr].Visible = false
        names[plr]:Remove()  
        names[plr] = nil 
    end
    
    
    if connections[plr] then
        connections[plr]:Disconnect()
        connections[plr] = nil
    end
end
local function ESP(plr)
   
    local library = {
        blacktracer = NewLine(Settings.Tracer_Thickness * 2, black),
        tracer = NewLine(Settings.Tracer_Thickness, Settings.Tracer_Color),
        black = NewQuad(Settings.Box_Thickness * 2, black),
        box = NewQuad(Settings.Box_Thickness, Settings.Box_Color),
        healthbar = NewLine(3, black),
        greenhealth = NewLine(1.5, black),
        nameText = NewText(15, ColoNa)  
    }

 
    tracers[plr] = {library.tracer, library.blacktracer}
    names[plr] = library.nameText

    local function Colorize(color)
        for _, x in pairs(library) do
            if x ~= library.healthbar and x ~= library.greenhealth and x ~= library.blacktracer and x ~= library.black then
                x.Color = color
            end
        end
    end

    local function Updater()
        local connection
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("Head") then
                local HumPos, OnScreen = camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
                if OnScreen then
                    local head = camera:WorldToViewportPoint(plr.Character.Head.Position)
                    local DistanceY = math.clamp((Vector2.new(head.X, head.Y) - Vector2.new(HumPos.X, HumPos.Y)).magnitude, 2, math.huge)

                    local function Size(item)
                        item.PointA = Vector2.new(HumPos.X + DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointB = Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2)
                        item.PointC = Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)
                        item.PointD = Vector2.new(HumPos.X + DistanceY, HumPos.Y + DistanceY * 2)
                    end

                    if Esp then
                        Size(library.box)
                        Size(library.black)

                      
                        if Names then
                            library.nameText.Position = Vector2.new(head.X, head.Y - 50) 
                            library.nameText.Text = plr.Name
                            library.nameText.Visible = true
                        else
                            library.nameText.Visible = false  
                        end

                        if Settings.Tracers then
                            if Settings.Tracer_Origin == "Middle" then
                                library.tracer.From = camera.ViewportSize * 0.5
                                library.blacktracer.From = camera.ViewportSize * 0.5
                            elseif Settings.Tracer_Origin == "Bottom" then
                                library.tracer.From = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                                library.blacktracer.From = Vector2.new(camera.ViewportSize.X * 0.5, camera.ViewportSize.Y)
                            end
                            if Settings.Tracer_FollowMouse then
                                library.tracer.From = Vector2.new(mouse.X, mouse.Y + 36)
                                library.blacktracer.From = Vector2.new(mouse.X, mouse.Y + 36)
                            end
                            library.tracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY * 2)
                            library.blacktracer.To = Vector2.new(HumPos.X, HumPos.Y + DistanceY * 2)
                        end

                        local d = (Vector2.new(HumPos.X - DistanceY, HumPos.Y - DistanceY * 2) - Vector2.new(HumPos.X - DistanceY, HumPos.Y + DistanceY * 2)).magnitude 
                        local healthoffset = plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth * d

                        library.greenhealth.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                        library.greenhealth.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2 - healthoffset)

                        library.healthbar.From = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y + DistanceY * 2)
                        library.healthbar.To = Vector2.new(HumPos.X - DistanceY - 4, HumPos.Y - DistanceY * 2)

                        library.greenhealth.Color = Color3.fromRGB(255, 0, 0):lerp(Color3.fromRGB(0, 255, 0), plr.Character.Humanoid.Health / plr.Character.Humanoid.MaxHealth)

                        if Team_Check.TeamCheck then
                            if plr.TeamColor == player.TeamColor then
                                Colorize(Team_Check.Green)
                            else 
                                Colorize(Team_Check.Red)
                            end
                        else 
                            library.tracer.Color = Settings.Tracer_Color
                            library.box.Color = Settings.Box_Color
                        end

                        if TeamColor then
                            Colorize(plr.TeamColor.Color)
                        end

                        Visibility(true, library)
                    else
                        Visibility(false, library)  
                    end
                else 
                    Visibility(false, library)  
                end
            else 
                Visibility(false, library)  
                if game.Players:FindFirstChild(plr.Name) == nil then
                    connection:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Updater)()
end

local dwCamera = workspace.CurrentCamera
local dwRunService = game:GetService("RunService")
local dwUIS = game:GetService("UserInputService")
local dwEntities = game:GetService("Players")
local dwLocalPlayer = dwEntities.LocalPlayer
local dwMouse = dwLocalPlayer:GetMouse()
local safe = setmetatable({}, {
	__index = function(_, k)
		return game:GetService(k)
	end
})
local PlayerTable = {}

for i,v in pairs(game:GetService("Players"):GetPlayers()) do 
	if v ~= dwLocalPlayer then
		table.insert(PlayerTable,v.Name)
	end
end
local cam = safe.Workspace.CurrentCamera 
local lp = safe.Players.LocalPlayer 
local lpc = safe.Players.LocalPlayer.Character 
local function inlos(p, ...) 
	return #cam:GetPartsObscuringTarget({p}, {cam, lp.Character, ...}) == 0
end


local settings = {
	Aimbot = false,
	Aiming = false,
	Aimbot_AimPart = "Head",
	Aimbot_TeamCheck = false,
	Aimbot_Draw_FOV = true,
	Aimbot_FOV_Radius = 200,
	Aimbot_FOV_Color = Color3.fromRGB(255,255,255),
	Aimbot_visiblecheck = false,
	Aimbot_Key = Enum.KeyCode.LeftShift,
	Aimbot_Onscreen = true,
	Aimbot_Speed = 10
}


local fovcircle = Drawing.new("Circle")
fovcircle.Visible = settings.Aimbot_Draw_FOV
fovcircle.Radius = settings.Aimbot_FOV_Radius
fovcircle.Color = settings.Aimbot_FOV_Color
fovcircle.Thickness = 1
fovcircle.Filled = false
fovcircle.Transparency = 0

fovcircle.Position = Vector2.new(dwCamera.ViewportSize.X / 2, dwCamera.ViewportSize.Y / 2)



dwRunService.RenderStepped:Connect(function()

    local dist = math.huge
    local closest_char = nil
    if settings.Aimbot then
        if settings.Aiming then

            for i,v in next, dwEntities:GetChildren() do 
                if v ~= dwLocalPlayer and
                    v.Character and
                    v.Character:FindFirstChild("HumanoidRootPart") and
                    v.Character:FindFirstChild("Humanoid") and
                    v.Character:FindFirstChild("Humanoid").Health > 0 then

                    if settings.Aimbot_TeamCheck == true and
                        v.Team ~= dwLocalPlayer.Team or
                        settings.Aimbot_TeamCheck == false then

                        local char = v.Character
                        local char_part_pos, is_onscreen = dwCamera:WorldToViewportPoint(char[settings.Aimbot_AimPart].Position)

                        if is_onscreen and settings.Aimbot_Onscreen or settings.Aimbot_Onscreen == false then
                            local mag = (Vector2.new(dwMouse.X, dwMouse.Y) - Vector2.new(char_part_pos.X, char_part_pos.Y)).Magnitude
                            if mag < dist and mag < settings.Aimbot_FOV_Radius then
                                dist = mag
                                closest_char = char
                            end
                        end
                    end
                end
            end

            if closest_char ~= nil and
                closest_char:FindFirstChild("HumanoidRootPart") and
                closest_char:FindFirstChild("Humanoid") and
                closest_char:FindFirstChild("Humanoid").Health > 0 then
                local targetPos = closest_char[settings.Aimbot_AimPart].Position
                if inlos(targetPos, closest_char) and settings.Aimbot_visiblecheck then
                  
                    dwCamera.CFrame = dwCamera.CFrame:Lerp(CFrame.new(dwCamera.CFrame.Position, targetPos), settings.Aimbot_Speed * 0.02)
                elseif not settings.Aimbot_visiblecheck then
                    dwCamera.CFrame = dwCamera.CFrame:Lerp(CFrame.new(dwCamera.CFrame.Position, targetPos), settings.Aimbot_Speed * 0.02)
                end
            end
        end
    end
end)


game:GetService('RunService').Stepped:connect(function()
	if aimbotting then
		--MouseTests()
	end
end)


local plr = safe.Players.LocalPlayer
local mouse = plr:GetMouse()


for _, v in pairs(game:GetService("Players"):GetPlayers()) do
    if v.Name ~= player.Name then
        coroutine.wrap(ESP)(v)
    end
end

game.Players.PlayerAdded:Connect(function(newplr)
    if newplr.Name ~= player.Name then
        coroutine.wrap(ESP)(newplr)
    end
end)

StarterGui:SetCore("SendNotification", {
    Title = "fronthook edited By OG12345",
    Text = "https://discord.gg/r8tk45Yprv",
    Duration = 10,
})
local flySpeed = 50  

local library = loadstring(game:HttpGet('https://raw.githubusercontent.com/iceswallowpis/criminality-ui-lib-fork/refs/heads/main/lib.lua'))()

local window = library.new('fronthook', 'fronthook')

local tab = window.new_tab('rbxassetid://4483345998')

local section1 = tab.new_section('Main')
local section2 = tab.new_section('Misc')

local sector3 = section1.new_sector('Esp', 'Right')
local sector2 = section1.new_sector('Aimbot', 'Left')
local sector4 = section2.new_sector('Misc','Right')
local toggleTpKill = sector4.element('Toggle', 'Enable TP Kill', false, function(v)
    tpKillEnabled = v.Toggle 
end)


local dropdownTpKillKey = sector4.element('Dropdown', 'TP Kill Hotkey', {options = {'E', 'X', 'LeftAlt', 'LeftShift'}}, function(v)
 
    if v.Dropdown == "E" then
        tpKillKey = Enum.KeyCode.E
    elseif v.Dropdown == "X" then
        tpKillKey = Enum.KeyCode.X
    elseif v.Dropdown == "LeftAlt" then
        tpKillKey = Enum.KeyCode.LeftAlt
    elseif v.Dropdown == "LeftShift" then
        tpKillKey = Enum.KeyCode.LeftShift
    end
end)
local toggleFlyGui = sector4.element('Toggle', 'Enable Fly', false, function(v)
    flyEnabled = v.Toggle 
    if flyEnabled then
        fly() 
    else
      
        local player = Players.LocalPlayer
        local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end
end)


local dropdownFlyKey = sector4.element('Dropdown', 'Fly Hotkey', {options = {'-', 'F', 'G', 'H', 'J'}}, function(v)
    if v.Dropdown == "F" then
        flyKey = Enum.KeyCode.F
    elseif v.Dropdown == "G" then
        flyKey = Enum.KeyCode.G
    elseif v.Dropdown == "H" then
        flyKey = Enum.KeyCode.H
    elseif v.Dropdown == "J" then
        flyKey = Enum.KeyCode.J
    end
end)
local sliderFlySpeed = sector4.element('Slider', 'Fly Speed', {default = {min = 10, max = 100, default = flySpeed}}, function(v)
    flySpeed = v.Slider
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == tpKillKey then
        tpKillEnabled = not tpKillEnabled  
        toggleTpKill:Set(tpKillEnabled)  
    end
end)
local slider = sector2.element('Slider', 'FOV', {default = {min = 50, max = 1500, default = 60}}, function(v)
	settings.Aimbot_FOV_Radius = v.Slider
	fovcircle.Radius = v.Slider
end)
local slider2 = sector2.element('Slider', 'Aimbot Speed', {default = {min = 1, max = 100, default = 10}}, function(v)
    settings.Aimbot_Speed = v.Slider
end)
local dropdown = sector2.element('Dropdown', 'Aimbot Hotkey', {options = {'LeftShift','LeftAlt', 'E', 'Q', '-', 'X', 'R', 'T', 'Y', 'U', 'I', 'P', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'C', 'V', 'B', 'N', 'M', 'F12'}}, function(v)
	if v.Dropdown == "LeftShift" then
		settings.Aimbot_Key = Enum.KeyCode.LeftShift
	elseif v.Dropdown == "LeftAlt" then
		settings.Aimbot_Key = Enum.KeyCode.LeftAlt
	elseif v.Dropdown == "X" then
		settings.Aimbot_Key = Enum.KeyCode.X
    elseif v.Dropdown == "E" then
		settings.Aimbot_Key = Enum.KeyCode.E
    elseif v.Dropdown == "Q" then
        settings.Aimbot_Key = Enum.KeyCode.Q
    elseif v.Dropdown == "F12" then
        settings.Aimbot_Key = Enum.KeyCode.F12
    elseif v.Dropdown == "R" then
        settings.Aimbot_Key = Enum.KeyCode.R
    elseif v.Dropdown == "T" then
        settings.Aimbot_Key = Enum.KeyCode.T
    elseif v.Dropdown == "Y" then
        settings.Aimbot_Key = Enum.KeyCode.Y
    elseif v.Dropdown == "U" then
        settings.Aimbot_Key = Enum.KeyCode.U
    elseif v.Dropdown == "I" then
        settings.Aimbot_Key = Enum.KeyCode.I
    elseif v.Dropdown == "P" then
        settings.Aimbot_Key = Enum.KeyCode.P
    elseif v.Dropdown == "F" then
        settings.Aimbot_Key = Enum.KeyCode.F
    elseif v.Dropdown == "G" then
        settings.Aimbot_Key = Enum.KeyCode.G
    elseif v.Dropdown == "H" then
        settings.Aimbot_Key = Enum.KeyCode.H
    elseif v.Dropdown == "J" then
        settings.Aimbot_Key = Enum.KeyCode.J
    elseif v.Dropdown == "K" then
        settings.Aimbot_key = Enum.KeyCode.K
    elseif v.dropdown == "L" then 
        settings.Aimbot_Key = Enum.KeyCode.L
    elseif v.dropdown == "Z" then
        settings.Aimbot_Key = Enum.KeyCode.Z
    elseif v.Dropdown == "X" then
        settings.Aimbot_Key = Enum.KeyCode.X
    elseif v.dropdown == "C" then
        settings.Aimbot_Key = Enum.KeyCode.C
    elseif v.dropdown == "V" then
        settings.Aimbot_Key = Enum.KeyCode.V
    elseif v.dropdown == "B" then
        settings.Aimbot_Key = Enum.KeyCode.B
    elseif v.dropdown == "N" then
        settings.Aimbot_Key = Enum.KeyCode.N
    elseif v.dropdown == "M" then
        settings.Aimbot_Key = Enum.KeyCode.M
    end

end)
local dropdown2 = sector2.element('Dropdown', 'Hitbox', {options = {'-','Head', 'Torso', 'HumanoidRootPart'}}, function(v)
	settings.Aimbot_AimPart = v.Dropdown
	print(settings.Aimbot_AimPart)
end)

local toggle = sector2.element('Toggle', 'Aimbot', false, function(v)
	settings.Aimbot = v.Toggle

end)
local toggle5 = sector2.element('Toggle', 'Draw FOV Circle', false, function(v)
	if v.Toggle == true then
		fovcircle.Transparency = 1
		print(1) 
	elseif v.Toggle == false then
		fovcircle.Transparency = 0
		print(0) 
	end
end)
local toggle2 = sector2.element('Toggle', 'Team Check', false, function(v)
	settings.Aimbot_TeamCheck = v.Toggle

end)
local toggle3 = sector2.element('Toggle', 'Visibility Check', false, function(v)
	settings.Aimbot_visiblecheck = v.Toggle

end)




dwUIS.InputBegan:Connect(function(inputObject,gameProcessed)
	if inputObject.KeyCode == settings.Aimbot_Key then
		settings.Aiming = true

	end
end)

dwUIS.InputEnded:Connect(function(inputObject,gameProcessed)
	if inputObject.KeyCode == settings.Aimbot_Key then
		settings.Aiming = false

	end
end)



local toggleEsp = sector3.element('Toggle', 'Box ESP', false, function(v)
    Esp = v.Toggle
end)
local toggleNameEsp = sector3.element('Toggle', 'NameEsp', false, function(v)
   Names = v.Toggle
end)



--local toggleTracers = sector3.element('Toggle', 'Tracers', false, function(v)
  -- Settings.Tracers = v.Toggle
--end)

local toggleTeamCheck = sector3.element('Toggle', 'Team Check', false, function(v)
   Team_Check.TeamCheck = v.Toggle
end)

local toggleTeamColors = sector3.element('Toggle', 'Team Colors', false, function(v)
   TeamColor = v.Toggle
end)
local toggleHighlight = sector3.element('Toggle', 'Highlight', false, function(v)
    HighlightEnabled = v.Toggle 
    for _, highlight in pairs(Storage:GetChildren()) do
        highlight.Enabled = HighlightEnabled 
    end
end)


toggleHighlight:add_color({Color = HighlightColor}, nil, function(v)
    HighlightColor = v.Color  
    for _, highlight in pairs(Storage:GetChildren()) do
        highlight.FillColor = HighlightColor  


    end
end)
