REM change with version in your computer
set msBuildDir=%programfiles%/MSBuild\14.0/Bin

call "%msBuildDir%"/msbuild.exe  /p:Configuration=Debug;FavoriteFood=Twix /l:FileLogger,Microsoft.Build.Engine;logfile=ZZZZZMSBuildSetupAndBuildAllTargetsWrapper_Debug.log  /target:AllTargetsWrapper %*

set msBuildDir=
