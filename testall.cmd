del *.nupkg
choco pack
choco install splunkforwarder  -s '%cd%' -f -y
pause
choco uninstall splunkforwarder -y