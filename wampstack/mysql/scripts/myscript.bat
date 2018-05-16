@echo off
"D:\school program files\wampstack/mysql\bin\mysql.exe" --defaults-file="D:\school program files\wampstack/mysql\my.ini" -u root -e "DELETE FROM mysql.user WHERE User='';"
"D:\school program files\wampstack/mysql\bin\mysql.exe" --defaults-file="D:\school program files\wampstack/mysql\my.ini" -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '%1';"
