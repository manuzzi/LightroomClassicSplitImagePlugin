# Lightroom Classic Split Image Plugin

A powerful Adobe Lightroom Classic plugin that allows you to split images into a customizable grid with support for passpartout spacing, perfect for creating multi-panel prints and gallery installations.

## Features

- **Customizable Grid**: Split images into any X by Y grid (e.g., 2x2, 3x3, 4x2, etc.)
- **Passpartout Support**: Set distance between frames in millimeters for professional mounting
- **Print Size Configuration**: Specify final print dimensions in mm for accurate passpartout calculations
- **Real-time Preview**: Live calculation and preview of grid layout and cell dimensions
- **DPI Control**: Configure print resolution (72-600 DPI) for precise output
- **Virtual Copies**: Creates virtual copies linked to the original image for easy printing
- **Stack Management**: Automatically stacks grid sections with the original image
- **Metadata Linking**: Each section is tagged and linked to the original image

## Requirements

- Adobe Lightroom Classic (SDK Version 15.1 or higher)
- Compatible with Lightroom Classic CC

## Installation

1. Download or clone this repository
2. Locate the `SplitImage.lrplugin` folder
3. In Lightroom Classic, go to **File > Plug-in Manager**
4. Click **Add** button
5. Navigate to and select the `SplitImage.lrplugin` folder
6. Click **Done**

## Usage

### Split Images in Library

This method creates virtual copies that remain in your Lightroom catalog:

1. Select one or more photos in your Lightroom catalog
2. Go to **Library > Plug-in Extras > Split Image into Grid...**
3. Configure the split settings:
   - **Grid Columns (X)**: Number of columns (1-20)
   - **Grid Rows (Y)**: Number of rows (1-20)
   - **Passpartout Distance (mm)**: Space between frames (0-100mm)
   - **Image Width (mm)**: Final print width in millimeters
   - **Image Height (mm)**: Final print height in millimeters
   - **Print DPI**: Resolution for print (default: 300)
   - **Create as Virtual Copies**: Keep checked (recommended)
   - **Stack with Original**: Keep checked to organize sections with original
4. The preview section shows calculated grid and cell dimensions
5. Click **Split**
6. The plugin will create virtual copies with appropriate crops applied
7. Each section will be named: `original_filename_grid_XxY_rowR_colC`
8. Sections are stacked with the original image for easy management

> **Note**: To export your split images, use Lightroom's built-in Export feature on the virtual copies created by this plugin.

## Understanding Print Size and Passpartout Distance

### Print Size Settings

To ensure accurate passpartout spacing, specify your final print dimensions:

- **Image Width (mm)**: The total width of your final print (e.g., 200mm for an 8" print)
- **Image Height (mm)**: The total height of your final print (e.g., 150mm for a 6" print)
- **Print DPI**: Resolution for printing (default: 300 DPI for high quality)

The plugin converts these measurements to pixels and calculates precise crop areas that account for the passpartout spacing.

### Passpartout Distance

The passpartout distance represents the spacing between each frame when mounted. For example:

- **0mm**: No spacing - sections are edge-to-edge
- **10mm**: 10mm space between each section (useful for matboard mounting)
- **20mm**: 20mm space between each section (wider spacing for gallery walls)

The plugin calculates the crop areas to account for this spacing, ensuring that when printed and mounted with the specified spacing, the image appears correctly assembled.

### Example Calculation

For a 300mm × 200mm print with a 2×2 grid and 10mm passpartout:
- Total passpartout space: 10mm (1 gap horizontally), 10mm (1 gap vertically)
- Available space: 290mm × 190mm
- Each cell: 145mm × 95mm
- When mounted with 10mm gaps, the complete image is reassembled correctly

The **Preview** section in the dialog shows these calculations in real-time as you adjust settings.

## Printing Your Split Images

After splitting:

1. Select the virtual copies created by the plugin
2. Use Lightroom's Print module or Export feature to print/export the sections
3. Each section maintains its crop and can be printed directly
4. When mounting, use the passpartout distance you specified to space the frames

## Technical Details

- **SDK Version**: 15.1
- **Plugin Identifier**: com.manuzzi.lightroom.splitimage
- **Version**: 1.0.0

## File Structure

```
SplitImage.lrplugin/
├── Info.lua                    # Plugin manifest
├── SplitImageDialog.lua        # Library menu dialog
└── SplitImageProcessor.lua     # Core processing logic
```

## Metadata and Organization

Each split section includes:

- **Title**: Descriptive name with grid position
- **Caption**: Information about grid dimensions and source image
- **Keywords**: Tagged with "SplitImage" for easy filtering
- **Stack**: Grouped with original image (if enabled)

## Troubleshooting

**Plugin doesn't appear in menu:**
- Ensure plugin is properly installed via Plug-in Manager
- Restart Lightroom Classic

**Grid sections don't align:**
- Check that passpartout distance is correctly set
- Verify original image has sufficient resolution

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues, questions, or feature requests, please open an issue on GitHub.
