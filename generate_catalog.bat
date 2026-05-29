@echo off
setlocal enabledelayedexpansion

set OUTPUT=catalog.json
set PATHS=

echo Scanning for skin

set COUNT=0
set RESULT=[

for /d %%C in (Costumes Accessories Items Plinths) do (
    if exist "%%C" (
        for /d %%S in ("%%C\*") do (
            if exist "%%C\%%~nxS\info.json" (
                if !COUNT! gtr 0 set RESULT=!RESULT!,
                set RESULT=!RESULT!"%%C/%%~nxS"
                set /a COUNT+=1
                echo   found %%C/%%~nxS
            )
        )
    )
)

set RESULT=!RESULT!]

echo !RESULT! > %OUTPUT%

echo.
echo Done... %COUNT% skin written to %OUTPUT%
