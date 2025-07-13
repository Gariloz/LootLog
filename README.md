# LootLog - WoW 3.3.5a Addon

LootLog is a comprehensive loot tracking addon for World of Warcraft 3.3.5a that records and displays all items you've looted during your adventures.

**🎯 Latest Version: v1.6.0 - Optimized & Clean Code!**

## Features

### Core Functionality
- **Automatic Loot Tracking**: Records all items looted automatically
- **Detailed Loot History**: View complete history of looted items with timestamps
- **Item Filtering**: Filter loot by item quality, type, and custom criteria
- **Search Functionality**: Quickly find specific items in your loot history
- **Minimap Button**: Easy access via minimap button (LibDBIcon integration)

### TSM Integration (v1.5+)
- **Accurate Quantity Display**: When holding Shift and hovering over items in LootLog, TSM will see the correct quantities from your loot log
- **Real Price Calculations**: TSM automatically recalculates all prices (Market Value, Buyout, etc.) for the actual logged quantities
- **Non-Invasive Integration**: Works without modifying TSM addon files
- **LibExtraTip Hook**: Uses proper tooltip integration for seamless functionality

## Installation

1. Download the latest code as ZIP from the green "Code" button above
2. Extract the `LootLog` folder to your `Interface/AddOns/` directory
3. Restart World of Warcraft or reload your UI with `/reload`

## Usage

### Basic Usage
- **Open LootLog**: Click the minimap button or use `/lootlog` command
- **View Loot History**: Browse through all your looted items
- **Filter Items**: Use the filter options to narrow down your search
- **Item Details**: Click on items to see detailed information

### TSM Integration
1. Make sure both LootLog and TradeSkillMaster are installed and loaded
2. Open LootLog and find an item you want to check prices for
3. **Hold Shift** and hover over the item in LootLog
4. TSM will display accurate prices calculated for the total quantity you've looted

### Commands
- `/lootlog` - Open/close the LootLog window
- `/lootlog config` - Open configuration options
- `/reload` - Reload UI after installation or updates

## Configuration

LootLog offers various configuration options:
- **Auto-open on loot**: Automatically open LootLog when you loot items
- **Quality filters**: Set minimum item quality to track
- **Exclusion lists**: Exclude specific items or item types from tracking
- **Display options**: Customize the appearance and behavior

## Compatibility

- **WoW Version**: 3.3.5a (Wrath of the Lich King)
- **TSM Compatibility**: Full integration with TradeSkillMaster
- **Other Addons**: Compatible with most other addons

## Changelog

### Version 1.6 - Code Optimization & Cleanup
- Optimized code structure and removed duplications
- Removed debug messages for production use
- Translated all comments to English
- Improved performance and maintainability
- Clean codebase ready for production

### Version 1.5 - TSM Integration
- Added full TSM integration for accurate quantity display
- LootLog now properly integrates with TradeSkillMaster tooltips
- TSM sees correct item counts from LootLog when Shift is held
- TSM automatically recalculates all prices for logged quantities
- Clean integration using LibExtraTip hooks without modifying TSM files
- Functional price calculations instead of visual-only modifications

### Previous Versions
- v1.4: Enhanced filtering and search functionality
- v1.3: Added minimap button integration
- v1.2: Improved item cache and performance
- v1.1: Added localization support
- v1.0: Initial release

## Support

If you encounter any issues or have suggestions:
1. Check the [Issues](https://github.com/Gariloz/LootLog/issues) page
2. Create a new issue with detailed information about the problem
3. Include your WoW version, addon version, and any error messages

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This addon is released under the MIT License. See the LICENSE file for details.
