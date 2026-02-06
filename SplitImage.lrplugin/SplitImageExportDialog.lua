--[[----------------------------------------------------------------------------

SplitImageExportDialog.lua
Export dialog for Split Image Plugin

------------------------------------------------------------------------------]]

local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'
local LrFileUtils = import 'LrFileUtils'
local LrPathUtils = import 'LrPathUtils'
local LrExportSession = import 'LrExportSession'

require 'SplitImageProcessor'

--------------------------------------------------------------------------------

local function showExportDialog()
	LrFunctionContext.callWithContext("splitImageExportDialog", function(context)
		local catalog = LrApplication.activeCatalog()
		local photos = catalog:getTargetPhotos()
		
		if #photos == 0 then
			LrDialogs.message("No photos selected", "Please select at least one photo to export and split.", "info")
			return
		end
		
		-- Get first photo for metadata
		local firstPhoto = photos[1]
		local photoWidth = firstPhoto:getRawMetadata("width") or 1000
		local photoHeight = firstPhoto:getRawMetadata("height") or 1000
		
		-- Create observable properties
		local props = LrBinding.makePropertyTable(context)
		props.gridColumns = 2
		props.gridRows = 2
		props.passpartoutDistance = 0
		props.exportFormat = "JPEG"
		props.exportQuality = 90
		props.exportPath = LrPathUtils.getStandardFilePath("pictures")
		
		-- Image size properties (in mm)
		props.imageSizeMmWidth = 200
		props.imageSizeMmHeight = 150
		props.imageDPI = 300
		
		-- Preview properties
		props.previewInfo = ""
		
		-- Update preview info when settings change
		local function updatePreviewInfo()
			local cols = tonumber(props.gridColumns) or 2
			local rows = tonumber(props.gridRows) or 2
			local imgWidthMm = tonumber(props.imageSizeMmWidth) or 200
			local imgHeightMm = tonumber(props.imageSizeMmHeight) or 150
			local passpartoutMm = tonumber(props.passpartoutDistance) or 0
			
			-- Calculate cell dimensions
			local totalPasspartoutX = passpartoutMm * (cols - 1)
			local totalPasspartoutY = passpartoutMm * (rows - 1)
			local cellWidthMm = (imgWidthMm - totalPasspartoutX) / cols
			local cellHeightMm = (imgHeightMm - totalPasspartoutY) / rows
			
			props.previewInfo = string.format(
				"Grid: %dx%d cells | Each cell: %.1f x %.1f mm | Total: %.1f x %.1f mm",
				cols, rows, cellWidthMm, cellHeightMm, imgWidthMm, imgHeightMm
			)
		end
		
		-- Set up observers
		props:addObserver("gridColumns", updatePreviewInfo)
		props:addObserver("gridRows", updatePreviewInfo)
		props:addObserver("passpartoutDistance", updatePreviewInfo)
		props:addObserver("imageSizeMmWidth", updatePreviewInfo)
		props:addObserver("imageSizeMmHeight", updatePreviewInfo)
		
		-- Initial update
		updatePreviewInfo()
		
		-- Create the UI
		local f = LrView.osFactory()
		
		local contents = f:column {
			spacing = f:control_spacing(),
			
			f:row {
				f:static_text {
					title = "Export and split " .. #photos .. " photo(s) into a grid",
					font = "<system/bold>",
				},
			},
			
			f:separator { fill_horizontal = 1 },
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Grid Columns (X):",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("gridColumns"),
					width_in_digits = 4,
					min = 1,
					max = 20,
					increment = 1,
					precision = 0,
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Grid Rows (Y):",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("gridRows"),
					width_in_digits = 4,
					min = 1,
					max = 20,
					increment = 1,
					precision = 0,
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Passpartout Distance (mm):",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("passpartoutDistance"),
					width_in_digits = 6,
					min = 0,
					max = 100,
					increment = 0.5,
					precision = 1,
				},
			},
			
			f:separator { fill_horizontal = 1 },
			
			f:row {
				f:static_text {
					title = "Print Size Settings",
					font = "<system/bold>",
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Image Width (mm):",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("imageSizeMmWidth"),
					width_in_digits = 6,
					min = 10,
					max = 5000,
					increment = 10,
					precision = 0,
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Image Height (mm):",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("imageSizeMmHeight"),
					width_in_digits = 6,
					min = 10,
					max = 5000,
					increment = 10,
					precision = 0,
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Print DPI:",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("imageDPI"),
					width_in_digits = 6,
					min = 72,
					max = 600,
					increment = 50,
					precision = 0,
				},
			},
			
			f:row {
				f:static_text {
					title = "Specify the final print size to ensure accurate passpartout spacing.",
					width = 400,
					height_in_lines = 1,
					size = "small",
				},
			},
			
			f:separator { fill_horizontal = 1 },
			
			f:row {
				f:static_text {
					title = "Preview",
					font = "<system/bold>",
				},
			},
			
			f:row {
				f:static_text {
					title = LrView.bind("previewInfo"),
					width = 400,
					height_in_lines = 2,
					size = "small",
				},
			},
			
			f:separator { fill_horizontal = 1 },
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Export Format:",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:popup_menu {
					value = LrView.bind("exportFormat"),
					items = {
						{ title = "JPEG", value = "JPEG" },
						{ title = "PNG", value = "PNG" },
						{ title = "TIFF", value = "TIFF" },
					},
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "JPEG Quality:",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:slider {
					value = LrView.bind("exportQuality"),
					min = 0,
					max = 100,
					width = 200,
				},
				f:static_text {
					title = LrView.bind("exportQuality"),
					width = 30,
				},
			},
			
			f:row {
				spacing = f:label_spacing(),
				f:static_text {
					title = "Export to:",
					width = LrView.share("label_width"),
					alignment = "right",
				},
				f:edit_field {
					value = LrView.bind("exportPath"),
					width = 300,
				},
				f:push_button {
					title = "Browse...",
					action = function()
						local result = LrDialogs.runOpenPanel({
							title = "Select Export Folder",
							canChooseFiles = false,
							canChooseDirectories = true,
							canCreateDirectories = true,
							allowsMultipleSelection = false,
						})
						if result then
							props.exportPath = result[1]
						end
					end,
				},
			},
			
			f:row {
				f:static_text {
					title = "Note: Images will be exported as separate files with crop metadata applied.",
					width = 400,
					height_in_lines = 2,
					size = "small",
				},
			},
		}
		
		local result = LrDialogs.presentModalDialog({
			title = "Export Split Images",
			contents = contents,
			actionVerb = "Export",
		})
		
		if result == "ok" then
			-- Validate inputs
			local cols = tonumber(props.gridColumns) or 2
			local rows = tonumber(props.gridRows) or 2
			local distance = tonumber(props.passpartoutDistance) or 0
			local imgWidthMm = tonumber(props.imageSizeMmWidth) or 200
			local imgHeightMm = tonumber(props.imageSizeMmHeight) or 150
			local dpi = tonumber(props.imageDPI) or 300
			
			if cols < 1 or rows < 1 then
				LrDialogs.message("Invalid Grid Size", "Grid columns and rows must be at least 1.", "critical")
				return
			end
			
			if imgWidthMm < 10 or imgHeightMm < 10 then
				LrDialogs.message("Invalid Image Size", "Image width and height must be at least 10mm.", "critical")
				return
			end
			
			if not LrFileUtils.exists(props.exportPath) then
				LrDialogs.message("Invalid Path", "Export path does not exist.", "critical")
				return
			end
			
			-- Export the images
			LrTasks.startAsyncTask(function()
				local progress = LrProgressScope({
					title = "Exporting Split Images",
				})
				
				progress:setPortionComplete(0, #photos * cols * rows)
				
				local exportSuccess = true
				local exportCount = 0
				
				for photoIndex, photo in ipairs(photos) do
					local success, message = SplitImageProcessor.exportSplitImage(
						photo,
						cols,
						rows,
						distance,
						props.exportPath,
						props.exportFormat,
						props.exportQuality,
						function(current, total, caption)
							progress:setPortionComplete((photoIndex - 1) * cols * rows + current - 1, #photos * cols * rows)
							progress:setCaption(caption)
						end,
						imgWidthMm,
						imgHeightMm,
						dpi
					)
					
					if success then
						exportCount = exportCount + (cols * rows)
					else
						exportSuccess = false
						LrDialogs.message("Export Error", message or "Failed to export image", "critical")
						break
					end
				end
				
				progress:done()
				
				if exportSuccess then
					LrDialogs.message("Export Complete", "Successfully exported " .. exportCount .. " image sections.", "info")
				end
			end)
		end
	end)
end

--------------------------------------------------------------------------------

LrTasks.startAsyncTask(function()
	showExportDialog()
end)
