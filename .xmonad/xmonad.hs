import XMonad
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.MouseResize

-- Data
import Data.List
import Data.Ratio
import qualified Data.Map as M

-- Hooks
import XMonad.ManageHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.Place
import XMonad.Hooks.WorkspaceHistory

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.SpawnOnce

-- Prompt
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.FuzzyMatch
import Control.Arrow (first)

-- Layouts
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed

-- Layout Modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.WindowArranger (windowArrange)
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts)

---
-- Variables
---
myFont :: String
myFont = "xft:JetBrainsMono Nerd Font:size=10"

myTerminal :: String
myTerminal = "alacritty"

myModMask :: KeyMask
myModMask = mod4Mask -- Win key

altMask :: KeyMask
altMask = mod1Mask -- Used by xprompts for alt

myBorderWidth :: Dimension
myBorderWidth = 2

myNormColor :: String
myNormColor = "#91A0BD"

myFocusColor :: String
myFocusColor = "#C7C9CB"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


---
-- Additional Keys
---
-- Because of XMonad.Util.EZConfig, keymaps can be written simpler like this
myKeys :: [(String, X ())]
myKeys =
    -- Main keybindings
    [ ("M-S-<Return>"  , shellPrompt myXPromptConfig)
    , ("M-<Return>"    , spawn myTerminal)
    , ("M-S-l"         , spawn "slock")

    -- Multimedia keys
    , ("<XF86AudioMute>"        , spawn "amixer set -q Master toggle")
    , ("<XF86AudioLowerVolume>" , spawn "amixer set -q Master 5%-")
    , ("<XF86AudioRaiseVolume>" , spawn "amixer set -q Master 5%+")
    , ("<XF86AudioMicMute>"     , spawn "amixer set -q Capture toggle")
    ]

---
-- Prompt Config
---
myXPromptConfig :: XPConfig
myXPromptConfig =
    def
      { font                = myFont
      , bgColor             = "#1F1F2C"
      , fgColor             = myNormColor
      , bgHLight            = "#3F3F4C"
      , fgHLight            = "#CCCACA"
      , borderColor         = myFocusColor
      , promptBorderWidth   = 0
      , promptKeymap        = myXPKeymap
      , position            = Top
      , height              = 20
      , historySize         = 256
      , historyFilter       = id
      , defaultText         = []
      , autoComplete        = Just 100000
      , showCompletionOnTab = False
      , searchPredicate     = fuzzyMatch
      , alwaysHighlight     = True
      , maxComplRows        = Nothing
      }

---
-- XPrompt Keymap
---
myXPKeymap :: M.Map (KeyMask,KeySym) (XP ())
myXPKeymap = M.fromList $
     map (first $ (,) controlMask)   -- control + <key>
         [ (xK_z, killBefore)            -- kill line backwards
         , (xK_k, killAfter)             -- kill line forwards
         , (xK_a, startOfLine)           -- move to the beginning of the line
         , (xK_e, endOfLine)             -- move to the end of the line
         , (xK_m, deleteString Next)     -- delete a character foward
         , (xK_b, moveCursor Next)       -- move cursor forward
         , (xK_f, moveCursor Prev)       -- move cursor backward
         , (xK_BackSpace, killWord Prev) -- kill the previous word
         , (xK_y, pasteString)           -- paste a string
         , (xK_g, quit)                  -- quit out of prompt
         , (xK_bracketleft, quit)
         ]
         ++
         map (first $ (,) altMask)       -- meta key + <key>
         [ (xK_BackSpace, killWord Prev) -- kill the prev word
         , (xK_f, moveWord Next)         -- move a word forward
         , (xK_b, moveWord Prev)         -- move a word backward
         , (xK_d, killWord Next)         -- kill the next word
         , (xK_n, moveHistory W.focusUp')   -- move up thru history
         , (xK_p, moveHistory W.focusDown') -- move down thru history
         ]
         ++
         map (first $ (,) 0) -- <key>
         [ (xK_Return, setSuccess True >> setDone True)
         , (xK_KP_Enter, setSuccess True >> setDone True)
         , (xK_BackSpace, deleteString Prev)
         , (xK_Delete, deleteString Next)
         , (xK_Left, moveCursor Prev)
         , (xK_Right, moveCursor Next)
         , (xK_Home, startOfLine)
         , (xK_End, endOfLine)
         , (xK_Down, moveHistory W.focusUp')
         , (xK_Up, moveHistory W.focusDown')
         , (xK_Escape, quit)
         ]

---
-- Startup Hooks
---
myStartupHook :: X()
myStartupHook = do
    spawnOnce "~/.fehbg &"
    spawnOnce "picom &"

---
-- Workspaces
---
myWorkspaces :: [WorkspaceId]
myWorkspaces = ["dev", "www", "sys", "irc", "doc", "gam", "vid"]


---
-- Manage Hooks
-- Custom application rules, use xprop to get data
---
myManageHook :: ManageHook
myManageHook = composeAll . concat $
    [ [ isDialog               --> doCenterFloat ]
    , [ isFullscreen           --> doFullFloat ]
    , [ className =? "firefox" --> doShift "www" ]
    , [ className =? "mGBA"    --> doShift "game" <+> doRectFloat (W.RationalRect (1%4) (1%4) (1%2) (1%2)) ]
    , [ className =? "Steam"   --> doShift "game" ]
    , [ className =? "explorer.exe"        --> doHideIgnore ]
    
    -- Jetbrains specific... might need to edit for other intelliJs tho.
    , [ fmap ( c `isInfixOf`) className --> doShift "dev" | c <- devShift ]
    , [ (fmap ( c `isInfixOf`) className <&&> title =? "win0") --> doCenterFloat | c <- devShift ]
    ]
  where devShift = ["jetbrains"]
---
-- Layouts
---
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Layout Definitions
tall    = renamed [Replace "Tall"]
          $ limitWindows 12
          $ mySpacing 8
          $ ResizableTall 1 (3/100) (1/2) []
 
magnify = renamed [Replace "Magnify"]
          $ magnifier
          $ limitWindows 12
          $ mySpacing 8
          $ ResizableTall 1 (3/100) (1/2) []

monocle = renamed [Replace "Monocle"]
          $ limitWindows 20 Full

floats  = renamed [Replace "Floats"]
          $ limitWindows 20 simplestFloat
       
grid    = renamed [Replace "Grid"]
          $ limitWindows 12
          $ mySpacing 8
          $ mkToggle (single MIRROR)
          $ Grid (16/10)
tabs    = renamed [Replace "Tabs"]
          $ tabbed shrinkText myTabConfig
  where
    myTabConfig = def { fontName            = myFont
                      , activeColor         = myNormColor
                      , inactiveColor       = "#525263"
                      , activeBorderColor   = "#C3CED6"
                      , inactiveBorderColor = "#6A748B"
                      , activeTextColor     = "#756A8B"
                      , inactiveTextColor   = "#ADA4BD"
                      }

myLayouts = smartBorders $ avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
          where
           myDefaultLayout =      tall
                              ||| Mirror tall
           --                 ||| magnify
           --                 ||| noBorders monocle
           --                 ||| floats
                              ||| noBorders tabs
                              ||| grid

---
-- Main
---

main = do
  xmproc0 <- spawnPipe "xmobar -x 0 ~/.xmonad/xmobar/xmobarrc"
  xmproc1 <- spawnPipe "xmobar -x 1 ~/.xmonad/xmobar/xmobarrc"
  xmonad $ ewmh def
    { manageHook          = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
    , handleEventHook     = fullscreenEventHook <+> docksEventHook
    , terminal            = myTerminal
    , modMask             = myModMask
    , borderWidth         = myBorderWidth
    , normalBorderColor   = myNormColor
    , focusedBorderColor  = myFocusColor
    , layoutHook          = myLayouts
    , logHook             = workspaceHistoryHook <+> dynamicLogWithPP xmobarPP
                                { ppOutput          = \x -> hPutStrLn xmproc0 x >> hPutStrLn xmproc1 x
                                , ppTitle           = xmobarColor "green" "" . shorten 50
                                , ppCurrent         = xmobarColor myNormColor "" . wrap "[" "]"
                                , ppVisible         = xmobarColor myNormColor ""
                                , ppHidden          = xmobarColor myNormColor "" . wrap "*" ""
                                , ppHiddenNoWindows = xmobarColor myNormColor ""
                                , ppSep             = "<fc=#666666> | </fc>"
                                , ppUrgent          = xmobarColor myFocusColor "" . wrap "!" "!"
                                , ppExtras          = [windowCount]
                                , ppOrder           = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                                }
    , startupHook         = myStartupHook
    , workspaces          = myWorkspaces
    , focusFollowsMouse   = False
    } `additionalKeysP` myKeys
