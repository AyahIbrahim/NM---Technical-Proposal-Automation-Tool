@echo off
REM Double-click to start the proposal builder on Windows.
REM This window must stay open while you use the app. Errors are shown here.
title Proposal Builder
cd /d "%~dp0"

REM 1. Find Python (the "py" launcher from python.org, or "python")
set PY=
py -3 --version >nul 2>&1 && set PY=py -3
if not defined PY (
  python --version >nul 2>&1 && set PY=python
)
if not defined PY (
  echo.
  echo Python was not found. Install Python 3.10 or newer from https://www.python.org/downloads/
  echo During the install, tick "Add python.exe to PATH". Then double-click this file again.
  goto :fail
)

REM 2. First run: create a private Python folder (.venv) and install the libraries
if not exist ".venv\Scripts\python.exe" (
  echo Setting up for the first time. This takes a few minutes...
  if exist .venv rmdir /s /q .venv
  %PY% -m venv .venv || goto :fail
)
REM install again whenever requirements.txt changes (new versions of the app)
fc /b requirements.txt ".venv\installed.txt" >nul 2>&1
if errorlevel 1 (
  ".venv\Scripts\python.exe" -m pip install --upgrade pip
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt || goto :fail
  copy /y requirements.txt ".venv\installed.txt" >nul
)

REM 3. Start the app. It opens the browser itself once it is ready.
".venv\Scripts\python.exe" app.py
if errorlevel 1 goto :fail
goto :eof

:fail
echo.
echo ------------------------------------------------------------
echo The proposal builder could not start. The error is shown above.
echo Take a screenshot of this window and send it over.
echo ------------------------------------------------------------
pause
