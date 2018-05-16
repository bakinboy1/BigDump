@echo off
rem -- Check if argument is INSTALL or REMOVE

if not ""%1"" == ""INSTALL"" goto remove

if exist "D:\school program files\wampstack\mysql\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\mysql\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\postgresql\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\postgresql\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\elasticsearch\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\elasticsearch\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\logstash\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\logstash\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\logstash-forwarder\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\logstash-forwarder\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\kibana\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\kibana\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\apache2\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\apache2\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\apache-tomcat\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\apache-tomcat\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\resin\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\resin\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\jboss\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\jboss\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\wildfly\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\wildfly\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\activemq\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\activemq\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\openoffice\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\openoffice\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\subversion\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\subversion\scripts\serviceinstall.bat" INSTALL)
rem RUBY_APPLICATION_INSTALL
if exist "D:\school program files\wampstack\mongodb\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\mongodb\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\lucene\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\lucene\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\third_application\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\third_application\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\nginx\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\nginx\scripts\serviceinstall.bat" INSTALL)
if exist "D:\school program files\wampstack\php\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\php\scripts\serviceinstall.bat" INSTALL)
goto end

:remove

if exist "D:\school program files\wampstack\third_application\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\third_application\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\lucene\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\lucene\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\mongodb\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\mongodb\scripts\serviceinstall.bat")
rem RUBY_APPLICATION_REMOVE
if exist "D:\school program files\wampstack\subversion\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\subversion\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\openoffice\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\openoffice\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\jboss\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\jboss\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\wildfly\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\wildfly\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\resin\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\resin\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\activemq\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\activemq\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\apache-tomcat\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\apache-tomcat\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\apache2\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\apache2\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\logstash-forwarder\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\logstash-forwarder\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\kibana\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\kibana\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\logstash\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\logstash\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\elasticsearch\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\elasticsearch\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\postgresql\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\postgresql\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\mysql\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\mysql\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\php\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\php\scripts\serviceinstall.bat")
if exist "D:\school program files\wampstack\nginx\scripts\serviceinstall.bat" (start "" /MIN "D:\school program files\wampstack\nginx\scripts\serviceinstall.bat")
:end
