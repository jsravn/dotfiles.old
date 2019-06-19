-------------------------------------------------------------------------------
-- Configuration for using xmonad inside xfce4.
--
-- Last tested with xmonad 0.11 and xfce 4.12.
--
-- 1. Start xmonad by adding it to "Application Autostart" in xfce.
-- 2. Make sure xfwm4 is disabled from autostart, or uninstalled.
-- 3. Make sure xfdesktop is disabled from autostart, or uninstalled
--    since it may prevent xfce-panel from appearing once xmonad is started.
-------------------------------------------------------------------------------

import qualified Data.Map as M

import qualified XMonad.StackSet as W
import Control.Exception
import System.Exit

import XMonad
import XMonad.Actions.CycleWS
import XMonad.Actions.UpdatePointer
import XMonad.Config.Xfce
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.ComboP
import XMonad.Layout.Gaps
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns


conf = ewmh xfceConfig
        { manageHook        = composeOne (myManageHook ++ defaultManageHook)
                              <+> manageDocks
                              <+> manageHook xfceConfig
        , layoutHook        = avoidStruts (myLayoutHook)
        , handleEventHook   = ewmhDesktopsEventHook
        , borderWidth       = 1
        , focusedBorderColor= "#dcdccc"
        , normalBorderColor = "#000000"
        , workspaces        = map show [1 .. 9 :: Int]
        , modMask           = mod4Mask
        , keys              = myKeys
         }

-- Main --
main :: IO ()
main =
    xmonad $ conf
        { startupHook       = startupHook conf
                            >> setWMName "LG3D" -- Java app focus fix
        , logHook           =  ewmhDesktopsLogHook
         }

-- Layouts --
myLayoutHook = smartBorders $ tile ||| mtile ||| mid ||| full
  where
    rt      = ResizableTall 1 (2/100) (1/2) []
    -- normal vertical tile
    tile    = rt
    -- normal horizontal tile
    mtile   = Mirror rt
    -- three col
    mid     = ThreeColMid 1 (3/100) (1/2)
    -- fullscreen
    full    = Full

-- Default managers
--
-- Match a string against any one of a window's class, title, name or
-- role.
matchAny :: String -> Query Bool
matchAny x = foldr ((<||>) . (=? x)) (return False) [className, title, name, role]

-- Match against @WM_NAME@.
name :: Query String
name = stringProperty "WM_CLASS"

-- Match against @WM_WINDOW_ROLE@.
role :: Query String
role = stringProperty "WM_WINDOW_ROLE"

-- ManageHook --
defaultManageHook :: [MaybeManageHook]
defaultManageHook =
    [ isDialog -?> doCenterFloat
    , isFullscreen -?> doFullFloat
    , fmap not isDialog -?> doF avoidMaster
    ]

myManageHook :: [MaybeManageHook]
myManageHook = [ matchAny v -?> a | (v,a) <- myActions]
    where myActions =
            [ ("Xfrun4"                         , doFloat)
            , ("Xfce4-notifyd"                  , doIgnore)
            , ("Whisker Menu"                   , doFloat)
            ]

-- Helpers --
-- avoidMaster:  Avoid the master window, but otherwise manage new windows normally
avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
avoidMaster = W.modify' $ \c -> case c of
    W.Stack t [] (r:rs) -> W.Stack t [r] rs
    otherwise           -> c


-- Keyboard --
myKeys :: XConfig Layout -> M.Map (KeyMask, KeySym) (X ())
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    -- launching and killing programs
    [ ((modMask .|. shiftMask,  xK_Return   ), spawn "urxvt -name zenburn")
    , ((modMask,                xK_o        ), spawn "xfrun4")
    , ((modMask,                xK_p        ), spawn "xfce4-popup-whiskermenu")
    , ((modMask,                xK_f        ), spawn "thunar")
    , ((modMask .|. shiftMask,  xK_c        ), kill)
    , ((modMask,                xK_b        ), sendMessage ToggleStruts)

    -- layouts
    , ((modMask,                xK_space    ), sendMessage NextLayout)
    , ((modMask .|. shiftMask,  xK_space    ), setLayout $ XMonad.layoutHook conf)

    -- floating layer stuff
    , ((modMask,                xK_t        ), withFocused $ windows . W.sink)

    -- refresh
    , ((modMask,                xK_n        ), refresh)

    -- focus
    , ((modMask,                xK_Tab      ), windows W.focusDown)
    , ((modMask,                xK_j        ), windows W.focusDown)
    , ((modMask,                xK_k        ), windows W.focusUp)
    , ((modMask,                xK_m        ), windows W.focusMaster)
    , ((modMask,                xK_Right    ), nextWS)
    , ((modMask,                xK_Left     ), prevWS)
    , ((modMask .|. shiftMask,  xK_Right    ), shiftToNext >> nextWS)
    , ((modMask .|. shiftMask,  xK_Left     ), shiftToPrev >> prevWS)

    -- swapping
    , ((modMask,                xK_Return   ), windows W.swapMaster)
    , ((modMask .|. shiftMask,  xK_j        ), windows W.swapDown)
    , ((modMask .|. shiftMask,  xK_k        ), windows W.swapUp)
    , ((modMask,                xK_s        ), sendMessage $ SwapWindow)

    -- increase or decrease number of windows in the master area
    , ((modMask,                xK_comma    ), sendMessage (IncMasterN 1))
    , ((modMask,                xK_period   ), sendMessage (IncMasterN (-1)))

    -- resizing
    , ((modMask,                xK_h        ), sendMessage Shrink)
    , ((modMask,                xK_l        ), sendMessage Expand)
    , ((modMask .|. shiftMask,  xK_h        ), sendMessage MirrorShrink)
    , ((modMask .|. shiftMask,  xK_l        ), sendMessage MirrorExpand)

    -- quit, or restart
    , ((modMask .|. shiftMask,  xK_q        ), spawn "xmonad --recompile; xmonad --restart")
    , ((modMask,                xK_q        ), spawn "xfce4-session-logout")
    , ((mod1Mask,               xK_q        ), spawn "xscreensaver-command --lock")
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [ ((m .|. modMask, k), windows $ f i)
    | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
    ]
    ++
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modMask, k), screenWorkspace sc >>= flip whenJust (windows . f))
    | (k, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]
    ]
