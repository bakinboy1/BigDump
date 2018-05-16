@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

"D:\school program files\wampstack/mysql\bin\mysqld.exe" --install "wampstackMySQL" --defaults-file="D:\school program files\wampstack/mysql\my.ini"

net start "wampstackMySQL" >NUL
goto end

:remove
rem -- STOP SERVICES BEFORE REMOVING

net stop "wampstackMySQL" >NUL
"D:\school program files\wampstack/mysql\bin\mysqld.exe" --remove "wampstackMySQL"

:end
exit
