# jankyborders — window border highlighting.
{ ... }:

{
  services.jankyborders = {
    enable = true;
    settings = {
      style = "round";
      width = 6.0;
      hidpi = "off";
      active_color = "0xffe2e2e3";
      inactive_color = "0x00000000";
    };
  };
}
