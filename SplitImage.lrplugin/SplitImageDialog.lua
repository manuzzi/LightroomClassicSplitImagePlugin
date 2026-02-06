--[[----------------------------------------------------------------------------

SplitImageDialog.lua
Main dialog for Split Image Plugin

------------------------------------------------------------------------------]]

local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrFunctionContext = import 'LrFunctionContext'
local LrBinding = import 'LrBinding'
local LrView = import 'LrView'
local LrTasks = import 'LrTasks'
local LrProgressScope = import 'LrProgressScope'

require 'SplitImageProcessor'

--------------------------------------------------------------------------------

local function showDialog()
	LrFunctionContext.callWithContext("splitImageDialog", function(context)
		local catalog = LrApplication.activeCatalog()
		local photos = catalog:getTargetPhotos()
		
		if #photos == 0 then
			LrDialogs.message("No photos selected", "Please select at least one photo to split.", "info")
			return
		end
		
		-- Create observable properties
		local props = LrBinding.makePropertyTable(context)
		props.gridColumns = 2
		props.gridRows = 2
		props.passpartoutDistance = 0
		props.createVirtualCopies = true
		props.stackWithOriginal = true
		
		-- Create the UI
		local f = LrView.osFactory()
		
		local contents = f:column {
			spacing = f:control_spacing(),
			
			f:row {
				f:static_text {
					title = "Split " .. #photos .. " photo(s) into a grid",
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
				f:checkbox {
					title = "Create as Virtual Copies (recommended)",
					value = LrView.bind("createVirtualCopies"),
				},
			},
			
			f:row {
				f:checkbox {
					title = "Stack with Original",
					value = LrView.bind("stackWithOriginal"),
					enabled = LrView.bind("createVirtualCopies"),
				},
			},
			
			f:row {
				f:static_text {
					title = "Note: Virtual copies allow you to print each grid section directly from Lightroom while maintaining a link to the original image.",
					width = 400,
					height_in_lines = 2,
					size = "small",
				},
			},
		}
		
		local result = LrDialogs.presentModalDialog({
			title = "Split Image into Grid",
			contents = contents,
			actionVerb = "Split",
		})
		
		if result == "ok" then
			-- Validate inputs
			local cols = tonumber(props.gridColumns) or 2
			local rows = tonumber(props.gridRows) or 2
			local distance = tonumber(props.passpartoutDistance) or 0
			
			if cols < 1 or rows < 1 then
				LrDialogs.message("Invalid Grid Size", "Grid columns and rows must be at least 1.", "critical")
				return
			end
			
			-- Process the images
			LrTasks.startAsyncTask(function()
				local progress = LrProgressScope({
					title = "Splitting Images",
				})
				
				progress:setPortionComplete(0, #photos)
				
				catalog:withWriteAccessDo("Split Images", function()
					for i, photo in ipairs(photos) do
						progress:setPortionComplete(i - 1, #photos)
						progress:setCaption("Processing " .. photo:getFormattedMetadata("fileName"))
						
						SplitImageProcessor.splitImage(photo, cols, rows, distance, props.createVirtualCopies, props.stackWithOriginal)
					end
				end)
				
				progress:done()
				
				LrDialogs.message("Split Complete", "Successfully split " .. #photos .. " image(s) into " .. (cols * rows) .. " sections each.", "info")
			end)
		end
	end)
end

--------------------------------------------------------------------------------

showDialog()
