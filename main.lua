--[[

	This property is protected.
	You are not allowed to claim this as your own.
	Removal of advertisements of https://www.discord.gg/outliershub is prohibited.
	Removal of initial credits to the authors is prohibited.

]]

setfflag("AbuseReportScreenshotPercentage", 0)
setfflag("DFFlagAbuseReportScreenshot", "False") 

repeat task.wait() until game:IsLoaded()

local Default = {
	Advertise = true;
	Safe = false;
	Webhook = "";
	
	Words = {
	    Blacklist = "https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/blacklisted.lua";
	    Whitelist = "https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/whitelisted.lua";
	};
}

pcall(function()
	if not autoreport then
		autoreport = Default
	end;
	
	for _,v in next, Default do
		if not autoreport[_] then autoreport[_] = v end
	end
	
	if autoreport.library == nil then
		autoreport.library = (loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source")))();
	end;
	
	autoreport.gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

local messages = {
	blacklisted = loadstring(game:HttpGet("https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/blacklisted.lua"))(),
	whitelisted = loadstring(game:HttpGet("https://raw.githubusercontent.com/CF-Trail/Auto-Report/main/words/whitelisted.lua"))()
}

local lib = {};
local success, err = pcall(function()
	function lib:notify(title, text)
		autoreport.library:MakeNotification({
			Name = title,
			Content = text,
			Time = 3
		});
	end;
	function lib:report(player, report_type, reason, offensive)

		for word, _ in next, messages.whitelisted do
			if string.match(autoreport.Message, word) then
				return false;
			end;
		end;
		lib:notify("Report", "Reported " .. player.Name .. " because of \"" .. autoreport.Message .. "\"");
		if not (autoreport.Webhook == "" or autoreport.Webhook == nil) then
				local data = 
				{
					["embeds"] = {{
						["title"] = "**" .. autoreport.gameName .. "**",
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
								["value"] = autoreport.Message,
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

			local args = {
				Url = autoreport.Webhook,
				Body = game:GetService("HttpService"):JSONEncode(data),
				Method = "POST",
				Headers = {
					["content-type"] = "application/json"
				}
			};

			request = http_request or request or HttpPost or syn.request;
			request(args);
		end;

		for i = 1, (autoreport.Safe and math.random(1,2) or math.random(5, 12)) do
			task.wait(math.random(1, 15) / 10)
			game:GetService('Players'):ReportAbuse(player, report_type, reason)
		end;
	end;

	function handler(player, msg)
		local report_type, reason;
		msg = string.lower(msg);
		for i, v in next, messages.blacklisted do
			if string.match(msg, i) then
				report_type, reason, offensive = v[1], v[2], i;
				if autoreport.Advertise == true then game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("/w " .. player.Name .. " you got mass reported by .gg/outliershub", "All"); end;
			end;
		end;
		if thing and reason and offensive then
			lib:report(player, report_type, reason, offensive);
		end;
	end;
end);

if not success then
	error(err);
end;

for i, plr in pairs(game:GetService('Players'):GetPlayers()) do
	if plr ~= game:GetService('Players').LocalPlayer then
		plr.Chatted:Connect(function(msg)
			autoreport.Message = msg;
			handler(plr, msg);
		end);
	end;
end;
game:GetService('Players').PlayerAdded:Connect(function(plr)
	if plr ~= game:GetService('Players').LocalPlayer then
		plr.Chatted:Connect(function(msg)
			autoreport.Message = msg;
			handler(plr, msg);
		end);
	end;
end);

pcall(function()
	autoreport.library:MakeNotification({
		Name = "Loaded!",
		Content = "Script was made by .gg#1780 and snnwer#1349",
		Time = 8
	});
	
	autoreport.library:MakeNotification({
		Name = "Join our discord",
		Content = "discord.gg/outliershub",
		Time = 8
	});
end)
