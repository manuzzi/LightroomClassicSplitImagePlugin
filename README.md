# Lightroom Classic Split Image Plugin

A powerful Adobe Lightroom Classic plugin that allows you to split images into a customizable grid with support for passpartout spacing, perfect for creating multi-panel prints and gallery installations.

## Features

- **Customizable Grid**: Split images into any X by Y grid (e.g., 2x2, 3x3, 4x2, etc.)
- **Passpartout Support**: Set distance between frames in millimeters for professional mounting
- **Virtual Copies**: Creates virtual copies linked to the original image for easy printing
- **Stack Management**: Automatically stacks grid sections with the original image
- **Export Function**: Optional export functionality to save split sections as separate files
- **Multiple Formats**: Export as JPEG, PNG, or TIFF
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

### Method 1: Split Images in Library (Recommended)

This method creates virtual copies that remain in your Lightroom catalog:

1. Select one or more photos in your Lightroom catalog
2. Go to **Library > Plug-in Extras > Split Image into Grid...**
3. Configure the split settings:
   - **Grid Columns (X)**: Number of columns (1-20)
   - **Grid Rows (Y)**: Number of rows (1-20)
   - **Passpartout Distance (mm)**: Space between frames (0-100mm)
   - **Create as Virtual Copies**: Keep checked (recommended)
   - **Stack with Original**: Keep checked to organize sections with original
4. Click **Split**
5. The plugin will create virtual copies with appropriate crops applied
6. Each section will be named: `original_filename_grid_XxY_rowR_colC`
7. Sections are stacked with the original image for easy management

### Method 2: Export Split Images

This method exports split sections as separate image files:

1. Select one or more photos in your Lightroom catalog
2. Go to **File > Plug-in Extras > Split Image into Grid...**
3. Configure the split settings:
   - **Grid Columns (X)**: Number of columns (1-20)
   - **Grid Rows (Y)**: Number of rows (1-20)
   - **Passpartout Distance (mm)**: Space between frames (0-100mm)
   - **Export Format**: Choose JPEG, PNG, or TIFF
   - **JPEG Quality**: Set quality (0-100, only applies to JPEG)
   - **Export to**: Choose destination folder
4. Click **Export**
5. Split sections will be exported as separate files

## Understanding Passpartout Distance

The passpartout distance represents the spacing between each frame when mounted. For example:

- **0mm**: No spacing - sections are edge-to-edge
- **10mm**: 10mm space between each section (useful for matboard mounting)
- **20mm**: 20mm space between each section (wider spacing for gallery walls)

The plugin calculates the crop areas to account for this spacing, ensuring that when printed and mounted with the specified spacing, the image appears correctly assembled.

## Printing Your Split Images

After splitting:

1. Select the virtual copies (or locate exported files)
2. Use Lightroom's Print module or standard export for printing
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
├── SplitImageExportDialog.lua  # Export menu dialog
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

**Export fails:**
- Ensure export path exists and is writable
- Check available disk space

## License

See LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Support

For issues, questions, or feature requests, please open an issue on GitHub.
