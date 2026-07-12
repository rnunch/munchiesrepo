@echo off
rem Writes catalog2.json — the whole skin list in one file so the mod loads it in a single request
rem instead of fetching every folder's info.json (github rate-limits that burst). New repos only need
rem this one file; the mod still reads the legacy flat catalog.json from older repos that predate it.
if exist "%~dp0generate_catalog2.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0generate_catalog2.ps1"
) else (
    echo generate_catalog2.ps1 not found next to this bat.
)
