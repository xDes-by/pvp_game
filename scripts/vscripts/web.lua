if web == nil then
	web = class({})
end

function web:init()
	web:start_game()
end

function web:start_game()
	_G.Players_info = {}
	local arr = {}
	for i = 0 , PlayerResource:GetPlayerCount() do
	    if PlayerResource:IsValidPlayer(i) then
			arr[i] = {
				sid = tostring(PlayerResource:GetSteamID(i))
			}
		end
	end
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", "http://62.109.14.118/api_game_start/?key=".._G.key )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			_G.Players_info = json.decode(res.Body)
			web:pick()
			Shop:createShop()
		else
			print("ERROR START GAME")
			print(res.StatusCode)
			print("ERROR START GAME")
		end
	end)
end
	
function web:pick()
	for i = 0, PlayerResource:GetPlayerCount() do
	    if PlayerResource:IsValidPlayer(i) then
			-- DeepPrintTable(_G.Players_info[i+1].heroes)
			CustomNetTables:SetTableValue("hero_pick", tostring(i), {_G.Players_info[i+1].heroes})
		end
	end
end