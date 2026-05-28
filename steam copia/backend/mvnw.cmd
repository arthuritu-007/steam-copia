@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET WRAPPER_DIR=%~dp0\.mvn\wrapper
SET WRAPPER_JAR=%WRAPPER_DIR%\maven-wrapper.jar
SET WRAPPER_PROPS=%WRAPPER_DIR%\maven-wrapper.properties
SET "MAVEN_PROJECTBASEDIR=%~dp0"
IF "!MAVEN_PROJECTBASEDIR:~-1!"=="\" SET "MAVEN_PROJECTBASEDIR=!MAVEN_PROJECTBASEDIR:~0,-1!"

IF NOT EXIST "%WRAPPER_JAR%" (
  FOR /F "usebackq tokens=1,2 delims==" %%A IN ("%WRAPPER_PROPS%") DO (
    IF "%%A"=="wrapperUrl" SET "WRAPPER_URL=%%B"
  )
  IF "!WRAPPER_URL!"=="" (
    ECHO wrapperUrl no encontrado en %WRAPPER_PROPS%
    EXIT /B 1
  )
  IF NOT EXIST "%WRAPPER_DIR%" MKDIR "%WRAPPER_DIR%"
  POWERSHELL -NoProfile -ExecutionPolicy Bypass -Command ^
    "$p='%WRAPPER_JAR%'; $u='!WRAPPER_URL!';" ^
    "Write-Host 'Descargando maven-wrapper...';" ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;" ^
    "Invoke-WebRequest -Uri $u -OutFile $p"
  IF NOT EXIST "%WRAPPER_JAR%" (
    ECHO No se pudo descargar !WRAPPER_URL!
    EXIT /B 1
  )
)

SET MAVEN_OPTS=%MAVEN_OPTS%
SET MVNW_REPOURL=

SET JAVA_EXE=java

"%JAVA_EXE%" -classpath "%WRAPPER_JAR%" -Dmaven.multiModuleProjectDirectory="!MAVEN_PROJECTBASEDIR!" org.apache.maven.wrapper.MavenWrapperMain %*

ENDLOCAL
