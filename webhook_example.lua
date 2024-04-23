local plugin_ = {
	["webhook_Name"] = 'Hook1',
	["webhook_URL"] = 'WEBHOOK_URL_HERE',
	["webhook_data"] = 'all',
	--[[INFO
	To get a webhook, go to channel settings in Discord > integrations
	
	webhook_data OPTIONS
	===========================================
	"all" >> Will send upon initialization, command run
	"commands" >> Will send when commands are run
	"initial" >> Will send when system boots
	]]
}

return plugin_