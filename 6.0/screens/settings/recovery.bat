@echo off
setlocal enabledelayedexpansion

title !window-title! - Recovery account
mode !window-size!
color !window-color!

set "user-recovery-questions-1="
set "user-recovery-questions-2="
set "user-recovery-questions-3="
set "user-recovery-questions-1-answer="
set "user-recovery-questions-2-answer="
set "user-recovery-questions-3-answer="

set error-level=0
set index=1
set "result="
set "answer="

:ini (
  set index=0

  call database\get\recovery-questions "!user-name!", result

  for /f "tokens=1,2,3,4,5,6 delims=^=" %%a in ("!result!") do (
    set user-recovery-questions-1=%%a
    set user-recovery-questions-1-answer=%%b
    set user-recovery-questions-2=%%c
    set user-recovery-questions-2-answer=%%d
    set user-recovery-questions-3=%%e
    set user-recovery-questions-3-answer=%%f
  )

  goto :home
)

:home (
  cls
  echo.
  call components\draw-title "Console Games Menu"
  echo.
  call lib\draw-center-text "Type {&1&4}'back'{&0} to go back", 1
  echo.
  echo.

  :question-1 (
    call components\draw-input-errorlevel "!user-recovery-questions-1!?", !error-level!
    set /p "answer="

    if "!answer!" == "back" exit
    if "!answer!" neq "!user-recovery-questions-1-answer!" (
      set error-level=3
      goto :question-1
    )

    set error-level=0
  )

  :question-2 (
    call components\draw-input-errorlevel "!user-recovery-questions-2!?", !error-level!
    set /p "answer="

    if "!answer!" == "back" exit
    if "!answer!" neq "!user-recovery-questions-2-answer!" (
      set error-level=3
      goto :question-2
    )

    set error-level=0
  )

  :question-3 (
    call components\draw-input-errorlevel "!user-recovery-questions-3!?", !error-level!
    set /p "answer="

    if "!answer!" == "back" exit
    if "!answer!" neq "!user-recovery-questions-3-answer!" (
      set error-level=3
      goto :question-3
    )

    set error-level=0
  )

  :home-new-pass (
    call components\draw-input-errorlevel "Type your new password", !error-level!
    call components\type-password new-user-pass

    if "!new-user-pass!" == "back" exit
    call database\lib\valid-new-password "!new-user-pass!", result

    if "!result!" == "n" (
      set error-level=3
      goto :home-new-pass
    )
  )

  exit
)
