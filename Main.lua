---@diagnostic disable: unused-local
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")

local Dictionary = loadstring(game:HttpGet("https://raw.githubusercontent.com/safariragoli2/Auto-Report-Not-Dumb/main/Dictionary.lua"))()

local PlayersTracking = {}

local NotificationGui = Instance.new("ScreenGui", CoreGui)
local NotificationFrame = Instance.new("Frame", NotificationGui)
local UIListLayout = Instance.new("UIListLayout", NotificationFrame)
NotificationFrame.AnchorPoint = Vector2.new(0.5,0.05)
NotificationFrame.Position = UDim2.fromScale(0.5,0.05)
NotificationFrame.BackgroundColor3 = Color3.new(0,0,0)
NotificationFrame.BackgroundTransparency = 0.85
NotificationFrame.Size = UDim2.fromOffset(350,450)

function Report(plr, ctx)
    Players:ReportAbuse(plr, "Dating", string.format("said \"%s\" which is inappropriate", ctx))
end

function NotifyAboutReport(plr, ctx, parent)
    local Notification = Instance.new("TextLabel", parent)
    Notification.TextSize = 16
    Notification.TextWrapped = true
    Notification.Font = Enum.Font.ArialBold
    Notification.BackgroundTransparency = 1
    Notification.TextColor3 = Color3.new(1,1,1)
    Notification.TextStrokeTransparency = 0
    Notification.Size = UDim2.new(1,0,0,50)
    Notification.Text = "Reported "..plr.." for saying '"..ctx.."'"
    wait(3)
    Notification:Destroy()
end

function TrackPlayerChat(player)
    player.Chatted:Connect(function(message)
        for _,word in pairs(Dictionary) do
            if string.match(message, word) then
                Report(player, message)
                spawn(function()
                    NotifyAboutReport(player.Name, message, NotificationFrame)
                end)
            end
        end
    end)
end

for _,player in pairs(Players:GetPlayers()) do
    TrackPlayerChat(player)
end

Players.PlayerAdded:Connect(function(player)
    TrackPlayerChat(player)
end)
