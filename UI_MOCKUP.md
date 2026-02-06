# Split Image Plugin - Updated UI

## Dialog Layout (After Changes)

```
┌─────────────────────────────────────────────────────────────────┐
│ Split Image into Grid                                      [X]  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Split 1 photo(s) into a grid                                   │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Grid Columns (X):           [  2  ]                            │
│ Grid Rows (Y):              [  2  ]                            │
│ Passpartout Distance (mm):  [ 5.0 ]                            │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Print Size Settings                                            │
│                                                                 │
│ Image Width (mm):           [ 200 ]                            │
│ Image Height (mm):          [ 150 ]                            │
│ Print DPI:                  [ 300 ]                            │
│                                                                 │
│ Specify the final print size to ensure accurate passpartout   │
│ spacing.                                                       │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Preview                                                        │
│                                                                 │
│ Grid: 2x2 cells | Each cell: 95.0 x 70.0 mm |                │
│ Total: 200.0 x 150.0 mm                                       │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ ☑ Create as Virtual Copies (recommended)                      │
│ ☑ Stack with Original                                         │
│                                                                 │
│ Note: Virtual copies allow you to print each grid section     │
│ directly from Lightroom while maintaining a link to the       │
│ original image.                                               │
│                                                                 │
│                                      [Cancel]  [Split]         │
└─────────────────────────────────────────────────────────────────┘
```

## Export Dialog Layout

```
┌─────────────────────────────────────────────────────────────────┐
│ Export Split Images                                        [X]  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│ Export and split 1 photo(s) into a grid                       │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Grid Columns (X):           [  3  ]                            │
│ Grid Rows (Y):              [  3  ]                            │
│ Passpartout Distance (mm):  [ 10.0 ]                           │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Print Size Settings                                            │
│                                                                 │
│ Image Width (mm):           [ 300 ]                            │
│ Image Height (mm):          [ 300 ]                            │
│ Print DPI:                  [ 300 ]                            │
│                                                                 │
│ Specify the final print size to ensure accurate passpartout   │
│ spacing.                                                       │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Preview                                                        │
│                                                                 │
│ Grid: 3x3 cells | Each cell: 93.3 x 93.3 mm |                │
│ Total: 300.0 x 300.0 mm                                       │
│                                                                 │
│ ─────────────────────────────────────────────────────────────  │
│                                                                 │
│ Export Format:              [JPEG ▼]                           │
│ JPEG Quality:               [─────●────] 90                    │
│                                                                 │
│ Export to: [/Users/me/Pictures    ] [Browse...]               │
│                                                                 │
│ Note: Images will be exported as separate files with crop     │
│ metadata applied.                                             │
│                                                                 │
│                                      [Cancel]  [Export]        │
└─────────────────────────────────────────────────────────────────┘
```

## Key UI Changes

### New Sections Added:

1. **Print Size Settings** (both dialogs)
   - Image Width (mm) - numeric input, 10-5000 range
   - Image Height (mm) - numeric input, 10-5000 range
   - Print DPI - numeric input, 72-600 range
   - Help text explaining the purpose

2. **Preview** (both dialogs)
   - Shows grid configuration (e.g., "Grid: 2x2 cells")
   - Shows individual cell dimensions (e.g., "Each cell: 95.0 x 70.0 mm")
   - Shows total image size (e.g., "Total: 200.0 x 150.0 mm")
   - Updates in real-time as settings change

### Interactive Behavior:

When user changes **any** of these settings:
- Grid Columns
- Grid Rows
- Passpartout Distance
- Image Width
- Image Height

The **Preview** section automatically updates showing new calculations.

### Example Interactions:

**Scenario 1: Change grid size**
```
User changes: Grid Columns from 2 to 3
Preview updates: "Grid: 3x2 cells | Each cell: 60.0 x 70.0 mm | ..."
```

**Scenario 2: Adjust passpartout**
```
User changes: Passpartout from 5mm to 10mm
Preview updates: "... | Each cell: 90.0 x 65.0 mm | ..."
(Smaller cells because more space used for gaps)
```

**Scenario 3: Change print size**
```
User changes: Width from 200mm to 400mm
Preview updates: "... | Total: 400.0 x 150.0 mm"
Cell sizes increase proportionally
```

## Calculation Examples

### Example 1: Basic 2×2 Grid
```
Input:
- Grid: 2 columns × 2 rows
- Image: 200mm × 150mm
- Passpartout: 5mm
- DPI: 300

Calculations:
- Total passpartout X: 5mm × (2-1) = 5mm
- Total passpartout Y: 5mm × (2-1) = 5mm
- Available width: 200mm - 5mm = 195mm
- Available height: 150mm - 5mm = 145mm
- Cell width: 195mm ÷ 2 = 97.5mm
- Cell height: 145mm ÷ 2 = 72.5mm

Preview:
"Grid: 2x2 cells | Each cell: 97.5 x 72.5 mm | Total: 200.0 x 150.0 mm"
```

### Example 2: Complex 3×4 Grid
```
Input:
- Grid: 3 columns × 4 rows
- Image: 300mm × 400mm
- Passpartout: 15mm
- DPI: 300

Calculations:
- Total passpartout X: 15mm × (3-1) = 30mm
- Total passpartout Y: 15mm × (4-1) = 45mm
- Available width: 300mm - 30mm = 270mm
- Available height: 400mm - 45mm = 355mm
- Cell width: 270mm ÷ 3 = 90mm
- Cell height: 355mm ÷ 4 = 88.75mm

Preview:
"Grid: 3x4 cells | Each cell: 90.0 x 88.8 mm | Total: 300.0 x 400.0 mm"
```

### Example 3: No Passpartout
```
Input:
- Grid: 4 columns × 4 rows
- Image: 400mm × 400mm
- Passpartout: 0mm
- DPI: 300

Calculations:
- Total passpartout: 0mm
- Available: 400mm × 400mm
- Cell: 100mm × 100mm

Preview:
"Grid: 4x4 cells | Each cell: 100.0 x 100.0 mm | Total: 400.0 x 400.0 mm"
```

## User Workflow

1. **Open Dialog**
   - User selects photo and opens split dialog
   - Default values populate (2×2 grid, 200×150mm, 0mm passpartout)

2. **Adjust Settings**
   - User sets desired grid size
   - Enters intended print dimensions
   - Sets passpartout spacing
   - Preview updates with each change

3. **Verify**
   - User reviews preview to confirm dimensions
   - Checks that cell sizes are appropriate
   - Ensures total matches intended print size

4. **Execute**
   - Clicks "Split" or "Export"
   - Plugin processes with exact specifications
   - Results match preview calculations

## Benefits of New UI

✅ **Immediate Feedback** - No guesswork about final dimensions
✅ **Prevents Errors** - See miscalculations before processing
✅ **Professional** - Accurate control for gallery installations
✅ **Educational** - Users understand the calculations
✅ **Flexible** - Works with any print size and grid configuration

