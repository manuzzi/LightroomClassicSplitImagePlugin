--[[----------------------------------------------------------------------------

Info.lua
Split Image Plugin for Adobe Lightroom Classic

------------------------------------------------------------------------------]]

return {
	LrSdkVersion = 15.1,
	LrSdkMinimumVersion = 15.1,

	LrToolkitIdentifier = 'com.manuzzi.lightroom.splitimage',
	LrPluginName = LOC "$$$/SplitImage/PluginName=Split Image",
	
	LrExportMenuItems = {
		{
			title = LOC "$$$/SplitImage/ExportMenuItem=Split Image into Grid...",
			file = "SplitImageExportDialog.lua",
			enabledWhen = "photosSelected",
		},
	},
	
	LrLibraryMenuItems = {
		{
			title = LOC "$$$/SplitImage/LibraryMenuItem=Split Image into Grid...",
			file = "SplitImageDialog.lua",
			enabledWhen = "photosSelected",
		},
	},

	VERSION = { major=1, minor=0, revision=0, build=1 },
}
