@setlocal enableextensions enabledelayedexpansion 
@echo off


CALL :OPEN-PORT 8099
CALL :OPEN-PORT 8087
CALL :OPEN-PORT 8085
CALL :OPEN-PORT 9001
CALL :OPEN-PORT 8097
CALL :OPEN-PORT 8095
CALL :OPEN-PORT 8077
CALL :OPEN-PORT 7075
CALL :OPEN-PORT 8080
CALL :OPEN-PORT 8081
CALL :OPEN-PORT 443
CALL :OPEN-PORT 8076
CALL :OPEN-PORT 9088
CALL :OPEN-PORT 9089
CALL :OPEN-PORT 3306
CALL :OPEN-PORT 37239
CALL :OPEN-PORT 3307
CALL :OPEN-PORT 23300
CALL :OPEN-PORT 29092


echo "downloading 7zip"
powershell -Command "Invoke-WebRequest https://www.7-zip.org/a/7z2107-x64.exe -Outfile 7zip.exe"
@echo "installing 7zip"
start F:\7zip.exe /S /D="F:\program files\7-zip"
echo "7zip installation successfull"

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
echo "choco installed"
choco install docker-desktop --version=3.6.0.20210906
echo "docker installed"




FOR /F "tokens=*" %%I IN ('docker -v') DO ECHO %%I & ECHO %%I>>docker.txt
for /f "delims=" %%x in (docker.txt) do set Build=%%x
echo %Build%
del docker.txt



pause



:OPEN-PORT
set PORT=%~1
set RULE_NAME="Open Port %PORT%"

netsh advfirewall firewall show rule name=%RULE_NAME% >nul
if not ERRORLEVEL 1 (
    rem Rule %RULE_NAME% already exists.
    echo Hey, you already got a out rule by that name, you cannot put another one in!
) else (
    echo Rule %RULE_NAME% does not exist. Creating...
    netsh advfirewall firewall add rule name=%RULE_NAME% dir=in action=allow protocol=TCP localport=%PORT%
	echo POrt %PORT% opened.
)

EXIT /B 0



