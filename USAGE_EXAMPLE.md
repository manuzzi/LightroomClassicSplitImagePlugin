# Split Image Plugin - Usage Example

## Visual Flow

### Step 1: Select Photos in Lightroom
```
┌─────────────────────────────────────────────────┐
│ Lightroom Library                               │
├─────────────────────────────────────────────────┤
│ [📷 Photo1.jpg] ✓ SELECTED                      │
│ [📷 Photo2.jpg]                                 │
│ [📷 Photo3.jpg]                                 │
└─────────────────────────────────────────────────┘
```

### Step 2: Open Split Image Dialog
```
Menu: Library → Plug-in Extras → Split Image into Grid...
```

### Step 3: Configure Grid Settings
```
┌─────────────────────────────────────────────────┐
│ Split Image into Grid                           │
├─────────────────────────────────────────────────┤
│ Split 1 photo(s) into a grid                    │
├─────────────────────────────────────────────────┤
│                                                  │
│ Grid Columns (X):        [2  ]                  │
│ Grid Rows (Y):           [2  ]                  │
│ Passpartout Distance:    [5.0] mm               │
│                                                  │
│ ☑ Create as Virtual Copies (recommended)        │
│ ☑ Stack with Original                           │
│                                                  │
│ Note: Virtual copies allow you to print each    │
│ grid section directly from Lightroom while      │
│ maintaining a link to the original image.       │
│                                                  │
│               [Cancel]  [Split]                  │
└─────────────────────────────────────────────────┘
```

### Step 4: Result - Virtual Copies Created
```
┌─────────────────────────────────────────────────┐
│ Original Photo                                   │
│ ┌───────────────────────────────────────┐       │
│ │                                       │       │
│ │          Full Image                   │       │
│ │                                       │       │
│ └───────────────────────────────────────┘       │
│                                                  │
│ Stacked Virtual Copies (4):                     │
│ ┌──────────┐ ┌──────────┐                       │
│ │ Top Left │ │ Top Right│                       │
│ │  (1,1)   │ │  (1,2)   │                       │
│ └──────────┘ └──────────┘                       │
│ ┌──────────┐ ┌──────────┐                       │
│ │ Bot Left │ │ Bot Right│                       │
│ │  (2,1)   │ │  (2,2)   │                       │
│ └──────────┘ └──────────┘                       │
└─────────────────────────────────────────────────┘
```

### Step 5: Print Sections
```
Each virtual copy can be printed individually.
When mounted with 5mm spacing between frames,
the complete image is reassembled.
```

## Example Use Cases

### Use Case 1: Large Wall Display
- **Scenario**: Create a 3×3 gallery wall from a single landscape photo
- **Settings**: 
  - Columns: 3
  - Rows: 3
  - Passpartout: 20mm
- **Result**: 9 printable sections that form a large wall display

### Use Case 2: Diptych
- **Scenario**: Split portrait into two vertical panels
- **Settings**:
  - Columns: 2
  - Rows: 1
  - Passpartout: 10mm
- **Result**: 2 printable sections for side-by-side display

### Use Case 3: Grid Art
- **Scenario**: Create a 4×4 grid for modern art display
- **Settings**:
  - Columns: 4
  - Rows: 4
  - Passpartout: 15mm
- **Result**: 16 printable sections forming a mosaic

## Export Example

### Export Dialog
```
┌─────────────────────────────────────────────────┐
│ Export Split Images                              │
├─────────────────────────────────────────────────┤
│ Export and split 1 photo(s) into a grid         │
├─────────────────────────────────────────────────┤
│                                                  │
│ Grid Columns (X):        [3  ]                  │
│ Grid Rows (Y):           [3  ]                  │
│ Passpartout Distance:    [10.0] mm              │
│                                                  │
│ Export Format:           [JPEG ▼]               │
│ JPEG Quality:            [────●─] 90            │
│                                                  │
│ Export to: [/Users/me/Pictures  ] [Browse...]   │
│                                                  │
│ Note: Images will be exported as separate files │
│ with crop metadata applied.                     │
│                                                  │
│               [Cancel]  [Export]                 │
└─────────────────────────────────────────────────┘
```

### Exported Files
```
/Users/me/Pictures/
  ├── Photo1_grid_3x3_r1_c1.jpg
  ├── Photo1_grid_3x3_r1_c2.jpg
  ├── Photo1_grid_3x3_r1_c3.jpg
  ├── Photo1_grid_3x3_r2_c1.jpg
  ├── Photo1_grid_3x3_r2_c2.jpg
  ├── Photo1_grid_3x3_r2_c3.jpg
  ├── Photo1_grid_3x3_r3_c1.jpg
  ├── Photo1_grid_3x3_r3_c2.jpg
  └── Photo1_grid_3x3_r3_c3.jpg
```

## Tips

1. **Passpartout Distance**: 
   - 0mm = no spacing (puzzle-like assembly)
   - 5-10mm = tight gallery spacing
   - 15-25mm = standard gallery spacing
   - 30mm+ = dramatic spacing for impact

2. **Grid Size**:
   - 2×2 or 3×3 = balanced, manageable
   - 4×4 or larger = dramatic, requires large space
   - Non-square (e.g., 4×2) = panoramic effects

3. **Virtual Copies vs Export**:
   - Virtual copies = keep in Lightroom, easy organization
   - Export = share files, print externally

4. **Printing**:
   - Use Lightroom Print module for virtual copies
   - All develop settings are preserved
   - Each section prints at full quality
