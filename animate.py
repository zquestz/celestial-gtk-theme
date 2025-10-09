#!/usr/bin/env python3
"""
Celestial GTK Theme - Marketing Animation Generator

This script creates an animated GIF showcase of theme screenshots with smooth transitions.
It adds labels to each image and creates fade transitions between them.

Usage:
    python3 animate.py

Requirements:
    - Pillow (PIL)
    - Theme screenshot images in the current directory
"""

import os
import sys
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont


class Config:
    """Configuration settings for the animation generator."""

    IMAGE_FILES: list[str] = [
        "aliz-dark.png",
        "aliz.png",
        "aliz-light.png",
        "azul-dark.png",
        "azul.png",
        "azul-light.png",
        "pueril-dark.png",
        "pueril.png",
        "pueril-light.png",
        "sea-dark.png",
        "sea.png",
        "sea-light.png",
    ]

    FONT_PATH: str = "/usr/share/fonts/TTF/DejaVuSans.ttf"
    FONT_SIZE: int = 24
    FONT_COLOR: tuple[int, int, int, int] = (
        255,
        255,
        255,
        255,
    )

    # Text positioning (offset from bottom-right corner)
    TEXT_MARGIN: int = 10

    # Animation timing (in milliseconds)
    STATIC_DURATION: int = 3000  # How long each image stays static
    TRANSITION_DURATION: int = 100  # Duration per transition frame
    TRANSITION_FRAMES: int = 10  # Number of frames for fade transition

    OUTPUT_FILE: str = "showcase.gif"
    OPTIMIZE_GIF: bool = True
    LOOP_FOREVER: bool = True


def validate_dependencies() -> None:
    """Check if required dependencies are available."""
    try:
        import importlib.util

        if importlib.util.find_spec("PIL") is None:
            raise ImportError("Pillow not found")
    except ImportError:
        print("Error: Pillow library is not installed.")
        print("Install it with: pip install Pillow")
        sys.exit(1)


def check_font_exists(font_path: str) -> bool:
    """
    Check if the specified font file exists.

    Args:
        font_path: Path to the font file

    Returns:
        True if font exists, False otherwise
    """
    return Path(font_path).exists()


def get_fallback_font(size: int) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    """
    Try to get a fallback font if the primary font is not available.

    Args:
        size: Font size

    Returns:
        ImageFont object
    """
    fallback_fonts = [
        "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf",  # Debian/Ubuntu
        "/usr/share/fonts/dejavu-sans-fonts/DejaVuSans.ttf",  # Fedora
        "/System/Library/Fonts/Helvetica.ttc",  # macOS
        "C:\\Windows\\Fonts\\arial.ttf",  # Windows
    ]

    for font_path in fallback_fonts:
        if check_font_exists(font_path):
            print(f"Using fallback font: {font_path}")
            return ImageFont.truetype(font_path, size)

    print("Warning: No TrueType fonts found. Using default font.")
    return ImageFont.load_default()


def load_font(
    font_path: str, size: int
) -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    """
    Load the specified font or fall back to an alternative.

    Args:
        font_path: Path to the primary font file
        size: Font size

    Returns:
        ImageFont object
    """
    if check_font_exists(font_path):
        return ImageFont.truetype(font_path, size)

    print(f"Warning: Font not found at {font_path}")
    return get_fallback_font(size)


def generate_label(filename: str) -> str:
    """
    Generate a display label from the filename.

    Args:
        filename: Image filename

    Returns:
        Formatted label string
    """
    return os.path.splitext(filename)[0]


def add_label_to_image(
    img: Image.Image,
    label: str,
    font: ImageFont.FreeTypeFont | ImageFont.ImageFont,
    color: tuple[int, int, int, int],
    margin: int,
) -> Image.Image:
    """
    Add a text label to the bottom-right corner of an image.

    Args:
        img: PIL Image object
        label: Text label to add
        font: Font to use for the text
        color: RGBA color tuple
        margin: Margin from the bottom-right corner

    Returns:
        Image with label added
    """
    draw = ImageDraw.Draw(img)

    text_bbox = draw.textbbox((0, 0), label, font=font)
    text_width = text_bbox[2] - text_bbox[0]
    text_height = text_bbox[3] - text_bbox[1]

    img_width, img_height = img.size
    position = (img_width - text_width - margin, img_height - text_height - margin)

    draw.text(position, label, font=font, fill=color)

    return img


def load_images(
    image_files: list[str],
    font: ImageFont.FreeTypeFont | ImageFont.ImageFont,
    config: Config,
) -> list[Image.Image]:
    """
    Load all images and add labels to them.

    Args:
        image_files: List of image filenames
        font: Font to use for labels
        config: Configuration object

    Returns:
        List of processed PIL Image objects
    """
    images: list[Image.Image] = []
    missing_files: list[str] = []

    for filename in image_files:
        if not Path(filename).exists():
            missing_files.append(filename)
            continue

        try:
            img = Image.open(filename).convert("RGBA")

            label = generate_label(filename)
            img = add_label_to_image(
                img, label, font, config.FONT_COLOR, config.TEXT_MARGIN
            )

            images.append(img)
            print(f"✓ Loaded: {filename}")

        except Exception as e:
            print(f"Error loading {filename}: {e}")
            missing_files.append(filename)

    if missing_files:
        print(f"\nWarning: {len(missing_files)} image(s) not found:")
        for missing_file in missing_files:
            print(f"  - {missing_file}")

    if not images:
        print("Error: No images could be loaded.")
        sys.exit(1)

    return images


def create_transition_frames(
    images: list[Image.Image], transition_frames: int
) -> list[tuple[int, Image.Image]]:
    """
    Create smooth fade transitions between images.

    Args:
        images: List of PIL Image objects
        transition_frames: Number of frames for each transition

    Returns:
        List of tuples containing (index, transition frame image)
    """
    transition_images: list[tuple[int, Image.Image]] = []

    for i in range(len(images) - 1):
        for step in range(1, transition_frames + 1):
            alpha = step / transition_frames
            blended = Image.blend(images[i], images[i + 1], alpha)
            transition_images.append((i, blended))

    return transition_images


def build_animation_frames(
    images: list[Image.Image], config: Config
) -> tuple[list[Image.Image], list[int]]:
    """
    Build the complete animation with static images and transitions.

    Args:
        images: List of processed images
        config: Configuration object

    Returns:
        Tuple of (frames, durations) lists
    """
    frames: list[Image.Image] = []
    durations: list[int] = []

    print("\nBuilding animation frames...")

    for i, img in enumerate(images):
        frames.append(img)
        durations.append(config.STATIC_DURATION)

        if i < len(images) - 1:
            for step in range(1, config.TRANSITION_FRAMES + 1):
                alpha = step / config.TRANSITION_FRAMES
                blended = Image.blend(images[i], images[i + 1], alpha)
                frames.append(blended)
                durations.append(config.TRANSITION_DURATION)

    total_frames = len(frames)
    total_duration = sum(durations) / 1000

    print(f"  Total frames: {total_frames}")
    print(f"  Total duration: {total_duration:.1f} seconds")
    print(f"  Static frames: {len(images)}")
    print(f"  Transition frames: {total_frames - len(images)}")

    return frames, durations


def save_gif(
    frames: list[Image.Image],
    durations: list[int],
    output_file: str,
    optimize: bool,
    loop: bool,
) -> None:
    """
    Save the animation as an optimized GIF.

    Args:
        frames: List of image frames
        durations: List of frame durations in milliseconds
        output_file: Output filename
        optimize: Whether to optimize the GIF
        loop: Whether to loop the animation forever
    """
    print(f"\nSaving GIF to {output_file}...")

    try:
        frames[0].save(
            output_file,
            format="GIF",
            save_all=True,
            append_images=frames[1:],
            duration=durations,
            loop=0 if loop else 1,
            optimize=optimize,
        )

        file_size = Path(output_file).stat().st_size / (1024 * 1024)  # MB
        print("✓ GIF saved successfully!")
        print(f"  File size: {file_size:.2f} MB")

    except Exception as e:
        print(f"Error saving GIF: {e}")
        sys.exit(1)


def main() -> None:
    """Main execution function."""
    print("=" * 60)
    print("Celestial GTK Theme - Marketing Animation Generator")
    print("=" * 60)

    validate_dependencies()

    config = Config()

    print(f"\nLoading font: {config.FONT_PATH}")
    font = load_font(config.FONT_PATH, config.FONT_SIZE)

    print(f"\nLoading {len(config.IMAGE_FILES)} images...")
    images = load_images(config.IMAGE_FILES, font, config)

    frames, durations = build_animation_frames(images, config)

    save_gif(
        frames, durations, config.OUTPUT_FILE, config.OPTIMIZE_GIF, config.LOOP_FOREVER
    )

    print("\n" + "=" * 60)
    print("Animation generation complete!")
    print("=" * 60)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n\nOperation cancelled by user.")
        sys.exit(0)
    except Exception as e:
        print(f"\n\nUnexpected error: {e}")
        sys.exit(1)
