@echo off
set DIR=%~dp0
set GRADLE_HOME=%DIR%gradle
set PATH=%GRADLE_HOME%\bin;%PATH%
gradle %*
