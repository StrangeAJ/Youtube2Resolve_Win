local ui = fu.UIManager
local disp = bmd.UIDispatcher(ui)
local width,height = 600,300
local clock = os.clock

function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end

win = disp:AddWindow({
    ID = 'YTimport',
    TargetID = 'YTimport',
    Geometry = {0, 0, 600, 600},
	WindowTitle = 'Youtube Import',
	
	ui:VGroup{
	ID = 'root',
	ui:HGroup{
	ui:LineEdit{ ID = "inputurl",
					PlaceholderText = "Enter a video's url",
					Text = "",
					Weight = 1.5,
					MinimumSize = {150, 24} },
	ui:Button{ID='geturl', Text='Get Video', weight=1.5}
        },
        ui:VGap(5, 0.01),
        ui:HGroup{
            Weight = 0.1,
            ui:CheckBox{ID = "CheckPref", Text = "Preference", Checked = false,},
            ui:ComboBox{ID = "Pref",},
          },      
	},

})



	itm=win:GetItems()
	resolve = Resolve()
	projectManager = resolve:GetProjectManager()
	project = projectManager:GetCurrentProject()
	mediapool = project:GetMediaPool()
	folder = mediapool:GetCurrentFolder()
	mediastorage=resolve:GetMediaStorage()
	mtdvol = mediastorage:GetMountedVolumes()
	dump(mtdvol)
function win.On.YTimport.Close(ev)
		disp:ExitLoop()
end
boxes = {
  { boxes = 'Video 360p mp4', check = itm.CheckPref, combo = itm.Pref, },}
function PopulateCombo(boxes)
box = {
	  'Video 360p mp4',
	  'Video 480p mp4',
	  'Video 720p mp4',
	  'Video 1080p mp4',
	  'Video 360p any',
	  'Video 480p any',
	  'Video 720p any',
	  'Video 720p any',
	  'Video 1080p any',}

	for i, meta in ipairs(boxes) do
		itm.Pref:AddItems(box)        
		itm.Pref.CurrentText = boxes
	end
  end
 PopulateCombo(boxes)
 function win.On.CheckPref.Clicked(ev)
	if itm.CheckPref.Checked then
		itm.Pref.Enabled = true
	else
		itm.Pref.Enabled = false
	end
  end
  
  
function win.On.MyWin.Close(ev)
	disp:ExitLoop()
end
function win.On.geturl.Clicked(ev)
	url = tostring(itm.inputurl.Text)
	dump(url)
	lpath = 'C:/Users/jinga/YTD'
	dump(lpath)

	--[[ytbsh = lpath.."/S1P1.sh"
	editytb = assert(io.output(ytbsh))
	editytb:write("#!/bin/sh")
	editytb:write("\r\nyoutube-dl "..url.." -o "..lpath.."/ytdl/input.mp4")
	editytb:close()

	bull = os.execute("chmod +x "..ytbsh)
dump(bull)]]--
	ffmpegProgramPath = 'C://Users//jinga//YTD//ffmpeg.exe' 
	ytdlProgramPath = 'C://Users//jinga//YTD//youtube-dl.exe'

	yttitlecmd=ytdlProgramPath.." --get-filename "..url
	--.." -o "..lpath.."/ytdl/input.mp4"
	titleproc=io.popen(yttitlecmd)
local output = titleproc:read('*all')
titleproc:close()
fname = string.gsub(output, "%.%w%w%w", "")
hname = string.gsub(fname, "\n","") 


comand = ''
if itm.Pref.CurrentText == 'Video 360p mp4' then comand = '-f \'bestvideo[height<=360][ext=mp4]+bestaudio[ext=m4a]/best[height<=360][ext=mp4]\' ' end
if itm.Pref.CurrentText == 'Video 480p mp4' then comand = '-f \'bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]\' ' end
if itm.Pref.CurrentText == 'Video 720 mp4' then comand = '-f \'bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]\' ' end
if itm.Pref.CurrentText == 'Video 1080p mp4' then comand = '-f \'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]\' ' end
if itm.Pref.CurrentText == 'Video 360p any' then comand = '-f \'bestvideo[height<=360]+bestaudio[ext=m4a]/best[height<=360]\' ' end
if itm.Pref.CurrentText == 'Video 480p any' then comand = '-f \'bestvideo[height<=480]+bestaudio[ext=m4a]/best[height<=480]\' ' end
if itm.Pref.CurrentText == 'Video 720 any' then comand = '-f \'bestvideo[height<=720]+bestaudio[ext=m4a]/best[height<=720]\' ' end
if itm.Pref.CurrentText == 'Video 1080p any' then comand = '-f \'bestvideo[height<=1080]+bestaudio[ext=m4a]/best[height<=1080]\' ' end
dump(comand)
	ytcommand= ytdlProgramPath.." "..comand.." -o \'"..lpath.."/"..hname..".%(ext)s\'"..url
dump(ytcommand)
dump("Attempting to download "..hname)
	os.execute(ytcommand)
--	dump(yttitlecmd)
	--dump(propat)
--[[
	EncTable = {}
	ToEncode = assert(io.popen("ls "..lpath))
		for line in ToEncode:lines() do
			table.insert(EncTable,line)
		end
		ToEncode:close()

		for i,v in ipairs(EncTable) do
			titleform = string.gsub(v,"%p%w%w%w","")
			titleform2 = string.gsub(titleform,"%s","")
		--	EncodeCommand = ffmpegProgramPath.." -y -i \'"..lpath.."/"..v.."\' -c:v prores_ks -profile:v 0 -s 1280x720 -r 29.97 \""..titleform2..".mov\""
		--	print(EncodeCommand)

		end]]
	fpath = lpath.."/"..hname..".mp4"
	os.execute(ffmpegProgramPath.." -i "..lpath.."/"..hname..".mkv -c:v h264 "..lpath.."/"..hname..".mp4")
	dump(fpath)
	mediastorage:AddItemListToMediaPool(fpath)

--	ffmpegcmd = ffmpegProgramPath.." -y -i "..lpath.."/ytdl/input.mp4".." -c:v prores_ks -profile:v 0 -s 1280x720 -r 29.97 output.mp4"
	--encode = os.execute(ffmpegcmd)
	--dump(ffmpegcmd)

	folder = mediapool:GetCurrentFolder()


end

			--	local newXml = "/Users/haus/Movies/Drawer/Cache/"..binName.."_"..tlName.."-"..b..".fcpxml"
						--	/Users/haus/Movies/Drawer/Cache
			--	tmpXML = assert(io.output(newXml))
			--	tmpXML:write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\r\n<!DOCTYPE fcpxml>\r\n<fcpxml version=\"1.8\"> \r\n	<resources>")


			--	tmpXML:seek("end")
			--	tmpXML:wr

win:Show()
disp:RunLoop()
win:Hide() 