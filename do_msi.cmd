@echo off
IF EXIST PS1MonService ( rd /s /q PS1MonService )
mkdir PS1MonService

copy log4net.dll PS1MonService
copy mon_sql.config PS1MonService
copy mon_sql.ps1 PS1MonService

IF EXIST mon.wxs ( del /F mon.wxs )
IF EXIST PS1MonService.wxs ( del /F PS1MonService.wxs )
copy PS1MonService.wxs.template PS1MonService.wxs
copy PS1MonService.ico PS1MonService

SET wixbin="D:\WiX Toolset v3.9\bin"
SET workingdir="%~dp0PS1MonService"
SET wixobj="%~dp0PS1MonService\*.wixobj"
SET heatfile="%~dp0mon.wxs"
SET mainfile="%~dp0PS1MonService.wxs"
SET msifile="%~dp0PS1MonService_%1.msi"
SET fnrdir="%~dp0fnr.exe"
SET wixfile="%~dp0"
pushd %wixbin%
ECHO Gen Group folder
heat.exe dir %workingdir% -o %heatfile% -cg BinaryGroup -sfrag -gg -g1
%fnrdir% --cl --dir %wixfile:~0,-2%" --fileMask "PS1MonService.wxs" --find "@MAJORVERSION@" --replace "%1"
candle.exe %heatfile% %mainfile% -o %workingdir:~0,-1%\\"
light.exe -b %workingdir% -out %msifile% %wixobj%
popd