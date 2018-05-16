@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

if exist "D:\school program files\wampstack\hypersonic\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\server\hsql-sample-database\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\ingres\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\ingres\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\mysql\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\mysql\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\postgresql\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\postgresql\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\elasticsearch\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\elasticsearch\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\logstash\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\logstash\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\logstash-forwarder\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\logstash-forwarder\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\openoffice\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\openoffice\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\apache-tomcat\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\apache-tomcat\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\apache2\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\apache2\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\resin\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\resin\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\activemq\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\activemq\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\jboss\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\jboss\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\wildfly\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\wildfly\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\jetty\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\jetty\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\subversion\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\subversion\scripts\servicerun.bat" START)
rem RUBY_APPLICATION_START
if exist "D:\school program files\wampstack\lucene\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\lucene\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\mongodb\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\mongodb\scripts\servicerun.bat" START)
if exist "D:\school program files\wampstack\third_application\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\third_application\scripts\servicerun.bat" START)
goto end

:stop
echo "Stopping services ..."
if exist "D:\school program files\wampstack\third_application\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\third_application\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\lucene\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\lucene\scripts\servicerun.bat" STOP)
rem RUBY_APPLICATION_STOP
if exist "D:\school program files\wampstack\subversion\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\subversion\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\jetty\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\jetty\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\hypersonic\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\server\hsql-sample-database\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\jboss\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\jboss\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\wildfly\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\wildfly\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\resin\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\resin\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\activemq\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\activemq\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\openoffice\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\openoffice\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\apache2\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\apache2\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\apache-tomcat\scripts\servicerun.bat" (start "" /MIN /WAIT "D:\school program files\wampstack\apache-tomcat\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\logstash-forwarder\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\logstash-forwarder\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\logstash\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\logstash\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\elasticsearch\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\elasticsearch\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\ingres\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\ingres\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\mysql\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\mysql\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\mongodb\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\mongodb\scripts\servicerun.bat" STOP)
if exist "D:\school program files\wampstack\postgresql\scripts\servicerun.bat" (start "" /MIN "D:\school program files\wampstack\postgresql\scripts\servicerun.bat" STOP)

:end
