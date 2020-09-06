# XMonad/xmobar
* Look into layouts, pick/customize them to look nice
    * Windows are too packed, and everything sticks to the edges, add spacing and "shrink" windows to fit these slightly more limited sizes
         * Render all windows in 1080p sizes within these layouts? Or change rendering based on placement/layout used, but let's not keep "cutting" them up all the time (rendering in all sizes at 1080p will be resource intensive)
* Float specific windows
    * Give specific windows specific sizes (mgba takes fullscreen, which is not desired)
* Refactor configs to be multiple files + import
* Make xmobar into pure haskell config
    * Make some elements clickable
    * Get Temps (but only show if too hot)
    * Click on CPU or Memory -> Open terminal with a list of the current highest (if above X) jobs
        * if possible make this a dropdown instead
    * Click on haskell opens an xmenu with "common" system things (lock, shutdown, restart)
* Top bar in FULL layout to have a better overview of what is open
* Add Audio to xmobar (and mic with mute and unmuted state, ignore mic volume control, let applications handle that)
* Add "Swallow" features, e.g. running nnn or terminal and opening a video with mpv (or an image with feh) should then (xmonad) unmanage the origin (nnn or terminal) as it is for the duration of the gallery/image/video not needed
* Check keybindings for layout changing
    * Find a way to quickly change to Tabs for example
    * Move grid to a keybind only
* Change ManageHook to allow a list of "move these to X workspace" (one per workspace?)
* Change managehook to have a list of items that just need to float (center float too?)
* Create an extension (prompt) that allows opening (and searching) desktop application entries (https://wiki.archlinux.org/index.php/desktop_entries)
    * Include a thumbnail creator (separate extension) to generate icons for the search results 
* Clickable workspaces

# PHPStorm/InteliJ (any derivative really)
1. Compare plugins for the specific language to create a minimal working product
2. Strip it down to minimal size, no need for a terminal, no need for project, make other things floating (strip out database too maybe)
3. (?) context aware keyboard lookup for a function/something to pop out, this could allow for ONLY having the editor section open, reducing size massively

Stripping out the project tree section requires whatever file manager there is to be context aware of what is opened in phpstorm... tricky

# Theming
* Use env vars? (pam.d?)
* XDM customization (login screen)
* Plymouth (boot stuff)
* Minimize xmobar text
  * Use icons rather than text (<ICON> mem: <MEM> (<PERMEM>), could be <MEM> <ICON> (<PERMEM>))
  * Replace workspaces with icons

# Misc
* Add opacity to background (but not through say picom for ALL things)
* Unify this repo
    * No more submodules, possible a small program to check discrepencies between repos, with a local db of "resolved" things
    * Have one branch per machine, instead of per system type OR one repo per system instead (probably better), with one being the "main" promoted, and the others being derivatives
* Change iwd's iwctl coloring (station wlan0 get-networks color is black, which is hard to see with black on white alacritty)
* Better youtube downloader
    * Use urlstring to check if video is downloaded, flag to override name always (+ config setting), default to interactive
    * Add hash for quality(s) so when re-downloading, not only will it correctly realize it has been downloaded in that format, but also allow for quality check (does it exist in a higher quality? Ask to skip...)
* Colorscript doesn't play well with smaller screens, make renderer pixels scale


# Config
* Merge this and README
* Cleanup readme
* Make the other dotfiles into "desktop dotfiles" or something
* Configure Dunst


# Development
* Git templates for a magento docker setup
* Create a TCP port list of ports in use, and for what + check this list regularly to regulate it
* Compile php 7.3 as a standalone, AUR seems to be unreliable + experience for LFS
