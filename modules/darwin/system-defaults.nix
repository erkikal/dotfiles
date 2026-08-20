# macOS system defaults (dock, finder, global domain, screenshots).
{ ... }:

{
  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    NSGlobalDomain._HIHideMenuBar = true;
    finder.AppleShowAllExtensions = true;
    screencapture.location = "~/Pictures/Screenshots";
    # screencapture.target = "clipboard";
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
    NSGlobalDomain.KeyRepeat = 2;
  };
}
