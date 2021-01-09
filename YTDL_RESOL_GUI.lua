local ui = fu.UIManager
local disp = bmd.UIDispatcher(ui)
local width,height = 600,300
local clock = os.clock

function sleep(n)  
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
	lpath = '\"%APPDATA%/Roaming/Blackmagic Design/DaVinci Resolve/Support/Fusion/Scripts/Comp\"'
	dump(lpath)


	ffmpegProgramPath = '\"%APPDATA%/Roaming/Blackmagic Design/DaVinci Resolve/Support/Fusion/Scripts/Compffmpeg.exe\"' 
	ytdlProgramPath = '\"%APPDATA%/Roaming/Blackmagic Design/DaVinci Resolve/Support/Fusion/Scripts/Comp/youtube-dl.exe\"'

	yttitlecmd=ytdlProgramPath.." --get-filename "..url
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
	fpath = lpath.."/"..hname..".mp4"
	os.execute(ffmpegProgramPath.." -i "..lpath.."/"..hname..".mkv -c:v h264 "..lpath.."/"..hname..".mp4")
	dump(fpath)
	mediastorage:AddItemListToMediaPool(fpath)



	folder = mediapool:GetCurrentFolder()


end
win:Show()
disp:RunLoop()
win:Hide() 
