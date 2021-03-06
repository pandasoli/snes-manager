@echo off
setlocal enabledelayedexpansion

title !window-title! - Read backup
mode !window-size-width!, 20
color !window-color!

set "menu="
set "menu-show="

set "backup-user-name="
set "backup-local="
set "check-list="
set "new-value="
set "if-or=n"
set index=0

set "prop-name="
set "prop-value="

set "temp="
set "result="
set "result-index="

:ini (
  set "menu="
  set "menu-show="
)

:home (
  cls
  echo.
  call components\draw-title "Read backup"
  echo.
  call lib\draw-center-text "Type '{&1&4}back{&0}' to go back", 1
  echo.
  echo.

  :home-location (
    start /wait /shared lib\file-selector "C:\Users", "y", "file", ".backup.ini"
    set /p new-value=< "temp\file-selector.txt"

    if "!new-value!" == "exit" exit

    if exist "!new-value!" (
      set backup-local=!new-value!

      for /f "usebackq tokens=1,2 delims=^=" %%a in ("!backup-local!") do (

        if "%%a" == "user-name" (
          set backup-user-name=%%b
        ) else if "%%a" neq "pass" (
          set prop-name=%%a
          set prop-name=!prop-name:-= !
          set prop-value=%%b

          set check-list=!check-list! y
          set menu=!menu! "y"
          set menu-show=!menu-show! " y - !prop-name!: !prop-value!"
        )

      )

      for %%x in ("" "Done" "Back") do (
        set menu=!menu! %%x

        call lib\center-text %%x, result
        set menu-show=!menu-show! "!result!"
      )

      goto :read
    )

    goto :home-location
  )

)

:read (
  cls
  echo.
  call components\draw-title "Select informations to save"
  call lib\draw-center-text "Created by: {&1&3}!backup-user-name!{&0}", 1
  echo.
  call lib\draw-center-text "Type '{&1&4}back{&0}' to go back", 1
  echo.
  echo.

  cmdmenusel f880 !menu-show!

  set result-index=!errorlevel!
  call lib\get-array-vector menu, !result-index!, result
  set result=!result:~1,-1!

  if "!result!" == "Done" (
    set index=0

    for /f "usebackq tokens=1,2 delims=^=" %%a in ("!backup-local!") do (
      if "%%a" neq "user-name" if "%%a" neq "pass" (
        set /a index+=1
        set "if-or=n"
        set "temp="

        call lib\get-array-vector check-list, !index!, result

        if "!result!" == "y" (
          set prop-name=%%a

          call lib\string-contains "%%a", "location", result
          if "!result!" == "y" set "prop-name=locations"

          call lib\string-contains "%%a", "share", result
          if "!result!" == "y" set "prop-name=share-locations"

          if "!prop-name!" == "locations" set "if-or=y"
          if "!prop-name!" == "share-locations" set "if-or=y"

          if "!if-or!" == "y" (
            if "%%a" == "roms-location" set "temp=roms"
            if "%%a" == "emulator-location" set "temp=emulator"

            if "%%a" == "share-roms-location" set "temp=roms"
            if "%%a" == "share-emulator-location" set "temp=emulator"

            call database\update\!prop-name! !user-name!, "!temp!", "%%b"
          ) else (
            call database\update\!prop-name! !user-name!, "%%b"
          )
        )

      )

    )

    exit
  ) else if "!result!" == "Back" (
    goto :ini
  ) else if "!result!" neq "" (
    set "new-value=n"

    call lib\get-array-vector check-list, !result-index!, result

    if "!result!" == "n" set "new-value=y"

    call lib\change-array-index check-list, !result-index!, !new-value!, check-list

    set "menu="
    set "menu-show="
    set index=0

    for /f "usebackq tokens=1,2 delims=^=" %%a in ("!backup-local!") do (
      if "%%a" neq "user-name" if "%%a" neq "pass" (
        set /a index+=1

        call lib\get-array-vector check-list, !index!, result

        set prop-name=%%a
        set prop-name=!prop-name:-= !
        set prop-value=%%b

        set menu=!menu! "!result!"
        set menu-show=!menu-show! " !result! - !prop-name!: !prop-value!"
      )
    )

    for %%x in ("" "Done" "Back") do (
      set menu=!menu! %%x

      call lib\center-text %%x, result
      set menu-show=!menu-show! "!result!"
    )
  )

  goto :read
)
