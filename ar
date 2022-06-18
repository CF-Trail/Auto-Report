--[[

	This property is protected.
	You are not allowed to claim this as your own.
	Removal of advertisements of https://www.discord.gg/outliershub is prohibited.
	Removal of initial credits to the authors is prohibited.

]]

setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False")

if not (getgenv()).autoreport then
	(getgenv()).autoreport = {
		Advertise = true,
		Safe = false,
		Webhook = "",
	
		Words = {
		Blacklisted = "https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/blacklisted.lua",
		Whitelisted = "https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/whitelisted.lua"
		}
	};
end;

if (getgenv()).autoreport.library == nil then
	(getgenv()).autoreport.library = (loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source")))();
end;

local messages = {
	blacklisted = loadstring(game:HttpGet(getgenv().autoreport.words.Blacklisted)),
	whitelisted = loadstring(game:HttpGet(getgenv().autoreport.words.Whitelisted))
}

local lib = {};
local success, error = pcall(function()
	function lib:notify(title, text)
		(getgenv()).autoreport.library:MakeNotification({
			Name = title,
			Content = text,
			Time = 3
		});
	end;
	function lib:report(player, thing, reason, offensive)

		for _, word in next, messsages.whitelisted do
			if string.match(getgenv().autoreport.Message, word) then
				return false;
			end;
		end;
		if (getgenv()).autoreport.Webhook == "" or (getgenv()).autoreport.Webhook == nil then
			lib:notify("Report", "Reported " .. player.Name .. " because of \"" .. (getgenv()).autoreport.Message .. "\"");
		else
				local data = 
				{
					["embeds"] = {{
						["title"] = "**" .. gameName .. "**",
						["description"] = "Auto-reported a player",
						["type"] = "rich",
						["color"] = tonumber(0x00aff4),
						["url"] = "https://www.roblox.com/games/" .. game.PlaceId,
						["fields"] = {
							{
								["name"] = "Name",
								["value"] = "[" .. player.Name .. "](https://www.roblox.com/users/" .. player.UserId .. ")",
								["inline"] = true
							},
							{
								["name"] = "Message",
								["value"] = getgenv().autoreport.Message,
								["inline"] = true
							},
							{
								["name"] = "Offensive part",
								["value"] = offensive,
								["inline"] = true
							}
						},
						["footer"] = {
							["text"] = "\nIf you think this is a mistake, contact snnwer#1349 or .gg#1780"
						},
						["author"] = {
							["name"] = "Auto Report"
						}
					}}
				}
			local newdata = (game:GetService("HttpService")):JSONEncode(data);
			local headers = {
				["content-type"] = "application/json"
			};
			request = http_request or request or HttpPost or syn.request;
			local abcdef = {
				Url = (getgenv()).autoreport.Webhook,
				Body = newdata,
				Method = "POST",
				Headers = headers
			};
			request(abcdef);
		end;

		for i = 1, (getgenv().autoreport.Safe and math.random(1,2) or math.random(5, 12)) do
			wait(math.random(1, 15) / 10)
			game.Players:ReportAbuse(player, thing, reason)
		end;
	end;

	function handler(player, msg)
		local thing, reason;
		msg = string.lower(msg);
		for i, v in next, messages.blacklisted do
			if string.match(msg, i) then
				thing, reason, offensive = v[1], v[2], i;
				if (getgenv()).autoreport.Advertise == true then (game:GetService("ReplicatedStorage")).DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. player.Name .. " you got mass reported by .gg/outliershub", "All"); end;
			end;
		end;
		if thing and reason and offensive then
			lib:report(player, thing, reason, offensive);
		end;
	end;
end);

if not success then
	error(error);
end;

for i, plr in pairs(game.Players:GetPlayers()) do
	if plr ~= game.Players.LocalPlayer then
		plr.Chatted:Connect(function(msg)
			(getgenv()).autoreport.Message = msg;
			handler(plr, msg);
		end);
	end;
end;
game.Players.PlayerAdded:Connect(function(plr)
	if plr ~= game.Players.LocalPlayer then
		plr.Chatted:Connect(function(msg)
			(getgenv()).autoreport.Message = msg;
			handler(plr, msg);
		end);
	end;
end);

(getgenv()).library:MakeNotification({
	Name = "Loaded!",
	Content = "Script was made by .gg#1780 and snnwer#1349",
	Time = 8
});

(getgenv()).library:MakeNotification({
	Name = "Be sure to join our discord",
	Content = "discord.gg/outliershub",
	Time = 8
});
