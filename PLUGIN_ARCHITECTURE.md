# Split Image Plugin Architecture

## Overview
This plugin allows users to split images into a grid with configurable passpartout spacing.

## File Structure

```
SplitImage.lrplugin/
├── Info.lua                    # Plugin manifest (SDK 15.1)
├── SplitImageDialog.lua        # Library menu handler
├── SplitImageExportDialog.lua  # Export menu handler
└── SplitImageProcessor.lua     # Core processing logic
```

## Components

### Info.lua
- Defines plugin metadata and SDK version (15.1)
- Registers two menu items:
  1. Library menu: Creates virtual copies in catalog
  2. Export menu: Exports split sections as files

### SplitImageDialog.lua
- Creates virtual copies with crops applied
- Stacks sections with original image
- Adds metadata and keywords
- User configurable:
  - Grid columns (X)
  - Grid rows (Y)
  - Passpartout distance (mm)
  - Stacking option

### SplitImageExportDialog.lua
- Exports split sections as separate files
- Supports JPEG, PNG, TIFF
- User configurable:
  - Grid settings (same as dialog)
  - Export format and quality
  - Export destination

### SplitImageProcessor.lua
- `calculateCropForCell()`: Calculates crop coordinates with passpartout
- `splitImage()`: Creates virtual copies with crops
- `exportSplitImage()`: Exports split sections to disk

## Processing Flow

### Virtual Copy Method
1. User selects photo(s) in Library
2. Opens "Split Image into Grid" dialog
3. Configures grid (e.g., 3x3) and passpartout (e.g., 10mm)
4. Plugin creates 9 virtual copies
5. Each copy gets crop applied for its grid position
6. All copies stacked with original
7. Metadata added linking to original

### Export Method
1. User selects photo(s)
2. Opens export dialog
3. Configures grid and export settings
4. Plugin creates temporary virtual copies
5. Exports each section as separate file
6. Removes temporary copies
7. Files saved with naming: `original_grid_3x3_r1_c1.jpg`

## Passpartout Calculation

The passpartout distance represents physical spacing between mounted frames.

Example: 3x3 grid with 10mm passpartout
- Total passpartout space X: 10mm × 2 = 20mm
- Total passpartout space Y: 10mm × 2 = 20mm
- Available image area: ImageWidth - 20mm, ImageHeight - 20mm
- Cell size: Available / 3

Formula for crop coordinates:
```lua
left = (col * cellWidth + col * passpartoutPx) / imageWidth
top = (row * cellHeight + row * passpartoutPx) / imageHeight
right = ((col + 1) * cellWidth + col * passpartoutPx) / imageWidth
bottom = ((row + 1) * cellHeight + row * passpartoutPx) / imageHeight
```

## Key Features

1. **Non-destructive**: Uses virtual copies, original untouched
2. **Flexible**: Any X×Y grid configuration
3. **Professional**: Passpartout spacing for gallery installations
4. **Organized**: Stacking and metadata for easy management
5. **Print-ready**: Direct printing from Lightroom
6. **Export option**: Separate files when needed

## Usage Example

**Scenario**: Create a 2×2 grid with 5mm spacing

1. Select photo in Lightroom
2. Library → Plug-in Extras → Split Image into Grid
3. Set: Columns=2, Rows=2, Passpartout=5
4. Click "Split"
5. Result: 4 virtual copies, each showing 1/4 of image
6. When printed with 5mm spacing, image appears whole

## Installation

1. Copy `SplitImage.lrplugin` to computer
2. Lightroom: File → Plug-in Manager → Add
3. Select `SplitImage.lrplugin` folder
4. Plugin appears in Library and File menus
