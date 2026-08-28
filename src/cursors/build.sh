#! /usr/bin/env bash
# Celestial Cursors Build Script
# Generates cursor theme from SVG sources

set -e  # Exit on error

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Unlike the other generators, the paths below stay absolute: this script
# navigates while it runs (into src/svg, src, then the output directory), so
# relative paths would resolve against whichever directory it last entered.
ROOT="$SCRIPT_DIR"

# Theme configuration
THEME_NAME="Celestial"
SRC="$ROOT/src"
BUILD="$ROOT/dist"
OUTPUT="$BUILD/cursors"
ALIASES="$SRC/cursorList"

# Check command availability
has_command() {
	command -v "$1" >/dev/null 2>&1
}

# Cleanup function for error handling
cleanup_on_error() {
	echo ""
	echo "Build failed! Cleaning up..."
	if [ -n "$SRC" ] && [ -d "$SRC" ]; then
		rm -rf "$SRC/x1" "$SRC/x1_25" "$SRC/x1_5" "$SRC/x2" 2>/dev/null
	fi
	if [ -n "$ROOT" ] && [ -d "$ROOT/svg-cursor" ]; then
		rm -rf "$ROOT/svg-cursor" 2>/dev/null
	fi
	exit 1
}

trap cleanup_on_error ERR

# Check for required dependencies
echo "Checking dependencies..."

if ! has_command xcursorgen; then
	echo "ERROR: xcursorgen needs to be installed to generate the cursors."
	echo ""
	echo "Install with:"
	if has_command apt-get; then
		echo "  sudo apt-get install -y x11-apps"
	elif has_command dnf; then
		echo "  sudo dnf install -y xorg-x11-apps"
	elif has_command pacman; then
		echo "  sudo pacman -S xorg-xcursorgen"
	elif has_command zypper; then
		echo "  sudo zypper install xcursorgen"
	fi
	exit 1
fi

if ! has_command rsvg-convert; then
	echo "ERROR: rsvg-convert needs to be installed to generate the cursors."
	echo ""
	echo "Install with:"
	if has_command apt-get; then
		echo "  sudo apt-get install -y librsvg2-bin"
	elif has_command dnf; then
		echo "  sudo dnf install -y librsvg2-tools"
	elif has_command pacman; then
		echo "  sudo pacman -S librsvg"
	elif has_command zypper; then
		echo "  sudo zypper install rsvg-convert"
	fi
	exit 1
fi

echo "All required dependencies found."
echo ""

# Check for optional dependencies
HAS_PYTHON3=false
HAS_GIT=false

if has_command python3; then
	HAS_PYTHON3=true
fi

if has_command git; then
	HAS_GIT=true
fi

if [ "$HAS_PYTHON3" = false ] || [ "$HAS_GIT" = false ]; then
	echo "Optional dependencies missing (SVG cursor generation will be skipped):"
	[ "$HAS_PYTHON3" = false ] && echo "  - python3"
	[ "$HAS_GIT" = false ] && echo "  - git"
	echo ""
fi

# Verify source directory exists
if [ ! -d "$SRC/svg" ]; then
	echo "ERROR: SVG source directory not found: $SRC/svg"
	exit 1
fi

if [ ! -d "$SRC/config" ]; then
	echo "ERROR: Config directory not found: $SRC/config"
	exit 1
fi

# Clean previous build
if [ -d "$BUILD" ]; then
	echo "Cleaning previous build..."
	rm -rf "$BUILD"
fi

# Create build directories
echo "Creating build directories..."
mkdir -p "$BUILD"
mkdir -p "$OUTPUT"
mkdir -p "$SRC/x1"
mkdir -p "$SRC/x1_25"
mkdir -p "$SRC/x1_5"
mkdir -p "$SRC/x2"

# Generate PNG files from SVG sources at multiple resolutions
echo ""
echo "Generating PNG files from SVG sources..."
echo "  - 32x32 (x1)"
echo "  - 40x40 (x1.25)"
echo "  - 48x48 (x1.5)"
echo "  - 64x64 (x2)"
echo ""

cd "$SRC/svg" || exit 1

svg_count=0
find . -name "*.svg" -type f | while read -r svg_file; do
	file_base="${svg_file##*/}"
	file_base="${file_base%.svg}"

	rsvg-convert -w 32 -h 32 "$svg_file" -o "../x1/${file_base}.png" 2>/dev/null
	rsvg-convert -w 40 -h 40 "$svg_file" -o "../x1_25/${file_base}.png" 2>/dev/null
	rsvg-convert -w 48 -h 48 "$svg_file" -o "../x1_5/${file_base}.png" 2>/dev/null
	rsvg-convert -w 64 -h 64 "$svg_file" -o "../x2/${file_base}.png" 2>/dev/null

	svg_count=$((svg_count + 1))
done

echo "PNG generation complete."
echo ""

# Generate cursor files
echo "Generating cursor theme..."
cd "$SRC" || exit 1

cursor_count=0
for cursor_config in config/*.cursor; do
	if [ ! -f "$cursor_config" ]; then
		echo "WARNING: No cursor config files found in config/"
		break
	fi

	cursor_name="${cursor_config##*/}"
	cursor_name="${cursor_name%.cursor}"

	if xcursorgen "$cursor_config" "$OUTPUT/$cursor_name" 2>/dev/null; then
		cursor_count=$((cursor_count + 1))
	else
		echo "WARNING: Failed to generate cursor: $cursor_name"
	fi
done

echo "Generated $cursor_count cursor files."
echo ""

# Generate symbolic links for aliases
echo "Generating cursor aliases..."
cd "$OUTPUT" || exit 1

if [ -f "$ALIASES" ]; then
	alias_count=0
	while IFS= read -r line || [ -n "$line" ]; do
		# Skip empty lines and comments
		[[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

		# Parse alias line: "alias_name source_name"
		read -r alias_name source_name <<< "$line"

		if [ -z "$alias_name" ] || [ -z "$source_name" ]; then
			continue
		fi

		# Create symbolic link if source exists and target doesn't
		if [ -e "$source_name" ] && [ ! -e "$alias_name" ]; then
			ln -sf "$source_name" "$alias_name"
			alias_count=$((alias_count + 1))
		fi
	done < "$ALIASES"

	echo "Generated $alias_count cursor aliases."
else
	echo "WARNING: cursorList file not found at: $ALIASES"
	echo "Skipping cursor aliases."
fi

echo ""

# Generate index.theme file
echo "Generating theme index..."
INDEX="$BUILD/index.theme"

cat > "$INDEX" << EOF
[Icon Theme]
Name=$THEME_NAME
Comment=Modern cursor theme for Celestial GTK theme
Example=default

EOF

echo "Theme index generated."
echo ""

# Generate SVG cursors for Wayland (optional)
if [ "$HAS_PYTHON3" = true ] && [ "$HAS_GIT" = true ]; then
	echo "Generating SVG cursors for Wayland support..."

	# Clean up any existing clone
	if [ -d "$ROOT/svg-cursor" ]; then
		rm -rf "$ROOT/svg-cursor"
	fi

	if [ -d "$BUILD/cursors_scalable" ]; then
		rm -rf "$BUILD/cursors_scalable"
	fi

	# Clone svg-cursor tool
	if git clone --quiet --depth 1 https://github.com/jinliu/svg-cursor.git "$ROOT/svg-cursor" 2>/dev/null; then
		echo "Building SVG cursors..."

		if "$ROOT/svg-cursor/build-svg-theme/build-svg-theme.py" \
			--output-dir="$BUILD/cursors_scalable" \
			--svg-dir="$SRC/svg" \
			--config-dir="$SRC/config" \
			--alias-file="$ALIASES" \
			--nominal-size=24 >/dev/null 2>&1; then
			echo "SVG cursors generated successfully."
		else
			echo "WARNING: SVG cursor generation failed (non-critical)."
		fi

		# Clean up svg-cursor clone
		rm -rf "$ROOT/svg-cursor"
	else
		echo "WARNING: Could not clone svg-cursor tool. Skipping SVG cursor generation."
	fi

	echo ""
else
	echo "Skipping SVG cursor generation (python3 and git required)."
	echo ""
fi

# Clean up temporary PNG files
echo "Cleaning up temporary files..."
rm -rf "$SRC/x1" "$SRC/x1_25" "$SRC/x1_5" "$SRC/x2"

echo ""
echo "========================================"
echo "Build complete!"
echo "========================================"
echo ""
echo "Theme name: $THEME_NAME"
echo "Output directory: $BUILD/"
echo ""
echo "Contents:"
echo "  - Binary cursors: $OUTPUT/"
if [ -d "$BUILD/cursors_scalable" ]; then
	echo "  - SVG cursors: $BUILD/cursors_scalable/"
fi
echo "  - Theme index: $INDEX"
echo ""
echo "To install the cursor theme, run from project root:"
echo "  ./install.sh --cursors"
echo ""
