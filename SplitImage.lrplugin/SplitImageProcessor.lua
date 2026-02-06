--[[----------------------------------------------------------------------------

SplitImageProcessor.lua
Core image processing logic for Split Image Plugin

------------------------------------------------------------------------------]]

local LrApplication = import 'LrApplication'

SplitImageProcessor = {}

--------------------------------------------------------------------------------
-- Calculate crop rectangle for a specific grid cell
-- @param col Column index (0-based)
-- @param row Row index (0-based)
-- @param totalCols Total number of columns
-- @param totalRows Total number of rows
-- @param passpartoutMm Distance between frames in mm
-- @param imageWidth Image width in pixels
-- @param imageHeight Image height in pixels
-- @param dpi Dots per inch (for mm to pixel conversion)
-- @return left, top, right, bottom (all in 0-1 range)
--------------------------------------------------------------------------------
local function calculateCropForCell(col, row, totalCols, totalRows, passpartoutMm, imageWidth, imageHeight, dpi)
	-- Convert mm to pixels (assuming 300 DPI if not specified)
	dpi = dpi or 300
	local passpartoutPx = (passpartoutMm / 25.4) * dpi
	
	-- Calculate total passpartout space
	local totalPasspartoutX = passpartoutPx * (totalCols - 1)
	local totalPasspartoutY = passpartoutPx * (totalRows - 1)
	
	-- Calculate available space for actual image content
	local availableWidth = imageWidth - totalPasspartoutX
	local availableHeight = imageHeight - totalPasspartoutY
	
	-- Calculate cell dimensions
	local cellWidth = availableWidth / totalCols
	local cellHeight = availableHeight / totalRows
	
	-- Calculate position with passpartout
	local left = (col * cellWidth + col * passpartoutPx) / imageWidth
	local top = (row * cellHeight + row * passpartoutPx) / imageHeight
	local right = ((col + 1) * cellWidth + col * passpartoutPx) / imageWidth
	local bottom = ((row + 1) * cellHeight + row * passpartoutPx) / imageHeight
	
	-- Ensure values are within 0-1 range
	left = math.max(0, math.min(1, left))
	top = math.max(0, math.min(1, top))
	right = math.max(0, math.min(1, right))
	bottom = math.max(0, math.min(1, bottom))
	
	return left, top, right, bottom
end

--------------------------------------------------------------------------------
-- Split a single image into grid sections
-- @param photo The photo to split
-- @param cols Number of columns
-- @param rows Number of rows
-- @param passpartoutMm Distance between frames in mm
-- @param createVirtualCopies Whether to create virtual copies
-- @param stackWithOriginal Whether to stack with original
-- @param imageSizeMmWidth Image width in mm (optional, for accurate passpartout calculation)
-- @param imageSizeMmHeight Image height in mm (optional, for accurate passpartout calculation)
-- @param dpi DPI for mm to pixel conversion (optional, defaults to 300)
--------------------------------------------------------------------------------
function SplitImageProcessor.splitImage(photo, cols, rows, passpartoutMm, createVirtualCopies, stackWithOriginal, imageSizeMmWidth, imageSizeMmHeight, dpi)
	local catalog = LrApplication.activeCatalog()
	
	-- Get image dimensions in pixels
	local photoMetadata = photo:getFormattedMetadata("dimensions")
	local width = photo:getRawMetadata("width") or 1000
	local height = photo:getRawMetadata("height") or 1000
	
	-- Use provided DPI or default to 300
	dpi = dpi or 300
	
	-- If image size in mm is provided, use it to calculate the effective image dimensions
	-- Otherwise, use pixel dimensions directly
	local effectiveWidth = width
	local effectiveHeight = height
	
	if imageSizeMmWidth and imageSizeMmHeight then
		-- Convert mm to pixels based on DPI
		effectiveWidth = (imageSizeMmWidth / 25.4) * dpi
		effectiveHeight = (imageSizeMmHeight / 25.4) * dpi
	end
	
	local copies = {}
	
	-- Create virtual copies for each grid cell
	for row = 0, rows - 1 do
		for col = 0, cols - 1 do
			local copy
			
			-- Create virtual copy using catalog API
			local virtualCopies = catalog:createVirtualCopies(photo)
			if virtualCopies and #virtualCopies > 0 then
				copy = virtualCopies[1]
			end
			
			if copy then
				-- Set the copy name
				local copyName = string.format("%s_grid_%d-%d_row%d_col%d",
					photo:getFormattedMetadata("fileName") or "photo",
					cols, rows,
					row + 1,
					col + 1
				)
				
				catalog:withWriteAccessDo("Set copy name", function()
					copy:setRawMetadata("title", copyName)
				end)
				
				-- Apply crop to the virtual copy
				catalog:withWriteAccessDo("Apply crop", function()
					local left, top, right, bottom = calculateCropForCell(
						col, row, cols, rows, passpartoutMm, effectiveWidth, effectiveHeight, dpi
					)
					
					-- Set develop settings with crop
					copy:applyDevelopSettings({
						CropLeft = left,
						CropTop = top,
						CropRight = right,
						CropBottom = bottom,
						CropConstrainToWarp = false,
					})
					
					-- Add keywords to link back to original
					local keywords = copy:getRawMetadata("keywords") or {}
					copy:addKeyword(catalog:createKeyword("SplitImage", {}, false, nil, true))
					
					-- Store original photo info in metadata (caption)
					local originalFileName = photo:getFormattedMetadata("fileName") or "unknown"
					local gridInfo = string.format("Grid %dx%d, Section %d,%d of %s",
						cols, rows, row + 1, col + 1, originalFileName)
					copy:setRawMetadata("caption", gridInfo)
				end)
				
				table.insert(copies, copy)
			end
		end
	end
	
	-- Stack the copies with the original if requested
	if stackWithOriginal and #copies > 0 then
		catalog:withWriteAccessDo("Stack images", function()
			-- Create a stack with the original photo at the top
			local allPhotos = {photo}
			for _, copy in ipairs(copies) do
				table.insert(allPhotos, copy)
			end
			
			catalog:stack(photo, true)
			
			-- Add all copies to the stack
			for _, copy in ipairs(copies) do
				if photo:getRawMetadata("stackPositionInFolder") then
					copy:setRawMetadata("stackPositionInFolder", photo:getRawMetadata("stackPositionInFolder") + 1)
				end
			end
		end)
	end
	
	return copies
end

--------------------------------------------------------------------------------

return SplitImageProcessor
