@echo off

title %global-title% - Confirm password
mode %global-window-width%, 10
color %global-color%

set "error-level=f"
set "value="

:ini (
  echo n> temp\confirm-password.txt

  goto :home
)

:home (
  cls
  echo.
  call lib\draw-center-text "{0c}-{06}-{02}-{0f} Confirm your password {0c}-{06}-{02}-", 4
  echo.
  call lib\draw-center-text "{0f}[{06}\.{0f}] Exit", 1
  echo.
  echo.

  :home-pass (
    cecho  {0%error-level%}Type your user password:{0f} 

    if "%global-system-architecture%" == "x64" (
      editv64 -m -p "" value
    ) else if "%global-system-architecture%" == "x86" (
      editv32 -m -p "" value
    )

    if "%value%" == "\." exit
    if "%value%" neq "%user-pass%" (
      set "error-level=c"
      goto :home-pass
    ) else (
      echo y> temp\confirm-password.txt
    )
  )

  exit
)