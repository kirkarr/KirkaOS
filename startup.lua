local sx,sy = term.getSize()
term.clear()
if not fs.exists("os/config.json") then
	term.setCursorPos(1,1)
	term.write("OS running first time")
	term.setCursorPos(1,2)
	term.write("Collecting data")
	local datareq,reason = http.get("https://raw.githubusercontent.com/kirkarr/KirkaOS/main/config.json")
	sleep(2)
	if datareq ~= nil then
		local data = unserializeJSON(datareq.readAll())
		datareq.close()
		fs.makeDir("os")
		for i=1,#data["Files"] do
			filedata = data["Files"][i]
			term.clear()
			term.setCursorPos(1,1)
			term.write("Loading files")
			term.setCursorPos(1,2)
			term.write("Loading "..filedata["Name"])
			if filedata["Url"] ~= "" then
				file = fs.open("os/"..filedata["Name"],"w+")
				req = http.get(filedata["Url"])
				content = req.readAll()
				file.write(content)
				req.close()
				file.close()
			end
			sleep(3)
		end
		local cfg = fs.open("os/data.json","w+")
		cfg.write(serializeJSON(data))
		cfg.close()
		os.rebo0t()
	else
		term.clear()
		term.setCursorPos(1,1)
		term.write("Cannot load OS")
		term.setCursorPos(1,2)
		term.write("Reason: "..reason)
		term.setCursorPos(1,3)
		term.write("Using craftOS")
		sleep(3)
		term.clear()
	end
else
	os.run("os/main.lua")
end
