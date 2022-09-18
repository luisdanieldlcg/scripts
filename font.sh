: '
This Script is used for Installing the JetBrains Mono font
with the assumption that path ~/.local/share already exists.
'

FONT_DIR=~/.local/share/fonts
FONT_NAME=jetbrains-mono-regular.ttf

 # Create the fonts directory if it doesn't exists
if ! [ -d $FONT_DIR ]; then
    mkdir fonts
fi

# Move the font to the fonts folder.
mv $FONT_NAME $FONT_DIR

echo "Refreshing font cache..."
fc-cache -f -v
