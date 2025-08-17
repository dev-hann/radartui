# Anti-Flickering Solution for RadarTUI

## Problem
The initial aggressive screen clearing solution caused visible flickering during every rerender.

## Solution Implemented

### 1. Smart Clearing Strategy
- **`smartClear()`**: Clears only the grid buffer, preserves previous grid for diff-based rendering
- **`clearAll()`**: Aggressive clearing with terminal.clear() - used only when necessary
- **`conditionalClear()`**: Intelligently chooses between smart and aggressive clearing

### 2. Content-Based Detection
- **`needsFullClear()`**: Analyzes content footprint to detect when remnants are likely
- Compares current vs previous content density
- Uses threshold to avoid false positives
- Only triggers aggressive clearing when previous frame had significantly more content

### 3. Optimized Frame Handling
- **Regular frames**: Use `conditionalClear()` for smooth rendering
- **Navigation frames**: Use `conditionalClear()` with intelligent detection
- **Differential rendering**: Existing flush() method already uses efficient cell-by-cell updates

### 4. Key Benefits
- ✅ **No flickering** during regular updates and animations
- ✅ **Clean navigation** with remnants cleared only when needed
- ✅ **Performance optimized** with minimal terminal operations
- ✅ **Double buffering** preserves smooth user experience

## Implementation Details

### Files Modified:
- `lib/src/services/output_buffer.dart`: Added smart clearing methods
- `lib/src/scheduler/binding.dart`: Updated frame handling with conditional clearing
- `lib/src/widgets/navigation.dart`: Navigation still uses enhanced clearing but now conditionally

### Clearing Strategy:
1. **Smart Clear**: Default for most frames (no terminal.clear())
2. **Conditional Clear**: Detects when aggressive clearing is needed
3. **Aggressive Clear**: Only when content shrinkage suggests remnants

This solution eliminates flickering while maintaining clean screen transitions during navigation.