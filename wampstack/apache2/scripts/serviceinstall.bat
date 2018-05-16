@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"D:/school program files/wampstack/apache2\bin\httpd.exe" -k install -n "wampstackApache" -f "D:/school program files/wampstack/apache2\conf\httpd.conf"

net start wampstackApache >NUL
goto end

:remove
rem -- STOP SERVICE BEFORE REMOVING

net stop wampstackApache >NUL
"D:/school program files/wampstack/apache2\bin\httpd.exe" -k uninstall -n "wampstackApache"

:end
exit
