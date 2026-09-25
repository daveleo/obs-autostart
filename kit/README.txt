Expromo OBS Autostart
=====================

Makes OBS Studio start by itself when the PC boots, come back if it closes
or crashes, and never stop to ask about Safe Mode after a power cut.

Full step-by-step guide:  https://daveleo.github.io/obs-autostart/

  Install.cmd       Set it up for the Windows user you are signed in as.
  Pause OBS.cmd     Close OBS and keep it closed (for maintenance).
  Resume OBS.cmd    Go back to normal: OBS starts and is kept running.
  Uninstall.cmd     Remove it again. OBS itself is not touched.

  obs-watchdog.ps1  The watchdog that keeps OBS running (installed to
                    %LOCALAPPDATA%\OBS-Appliance\ together with its log).
  setup.ps1         Does the work for the four .cmd files above.

Before you start: Windows must sign in automatically, and OBS Studio must be
installed in its default folder. The guide explains both.
