repeat task.wait() until game:IsLoaded()

words = {'dumb','kid','retard','furry','gay','lesbian','lgbt','noob','trash','hacker','cheat','exploit','script','fat','motherless','fatherless','familyless','synapse','krnl','wizard','youtube','die'}

if setfflag then
	setfflag("AbuseReportScreenshotPercentage", 0)
	setfflag("DFFlagAbuseReportScreenshot", "False") 
end

local Default = {
    Webhook = ''
}

if not autoreport then
	getgenv().autoreport = Default
end

local players = game:GetService("Players")
local notifs = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

function notify(title, text)
    notifs:MakeNotification({
        Name = title,
        Content = text,
        Time = 4
    });
end;

function handler(msg,speaker)
   for i,v in next, words do
      if string.match(string.lower(msg),v) then
         players:ReportAbuse(players[speaker],'Bullying','He bullied me :(')
         task.wait()
         players:ReportAbuse(players[speaker],'Scamming','He advertise cheat')
         if autoreport.Webhook ~= nil and autoreport.Webhook ~= '' then
         local data = 
         {
             ["embeds"] = {{
                 ["title"] = "**" .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. "**",
                 ["description"] = "Auto-reported a player",
                 ["type"] = "rich",
                 ["color"] = tonumber(0x00aff4),
                 ["url"] = "https://www.roblox.com/games/" .. game.PlaceId,
                 ["fields"] = {
                     {
                         ["name"] = "Name",
                         ["value"] = "[" .. players[speaker].Name .. "](https://www.roblox.com/users/" .. players[speaker].UserId .. ")",
                         ["inline"] = true
                     },
                     {
                         ["name"] = "Message",
                         ["value"] = msg,
                         ["inline"] = true
                     },
                 },
                 ["footer"] = {
                     ["text"] = "\nIf you think this is a mistake: stfu"
                 },
                 ["author"] = {
                     ["name"] = "Auto Report"
                 }
             }}
         }
     local newdata = (game:GetService("HttpService")):JSONEncode(data);
     local request = http_request or request or HttpPost or http.request or syn.request;
     local abcdef = {
         Url = autoreport.Webhook,
         Body = newdata,
         Method = "POST",
         Headers = {
             ["content-type"] = "application/json"
         }
     };
     request(abcdef);
    else
        notify('Autoreport','Autoreported ' .. speaker)
    end
      end
   end
end

if game:GetService('ReplicatedStorage'):FindFirstChild('DefaultChatSystemChatEvents') then
msg = game:GetService('ReplicatedStorage'):FindFirstChild('DefaultChatSystemChatEvents'):FindFirstChild('OnMessageDoneFiltering')
msg.OnClientEvent:Connect(function(msgdata)
    if tostring(msgdata.FromSpeaker) ~= players.LocalPlayer.Name then
       handler(tostring(msgdata.Message),tostring(msgdata.FromSpeaker))
    end
end)
end
