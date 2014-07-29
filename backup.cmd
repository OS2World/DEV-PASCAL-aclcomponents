@echo off
@echo Backup script
if "%1"="" goto NoLabel
zip %1 *.pas *.dfm *.dpr *.spr *.res *.vyd *.txt *.cmd *.scu *.rc *.bmp *.ptr *.ico
goto End
:NoLabel
echo No name supplied 
:End