@echo off
setlocal enabledelayedexpansion

rem Check if ../data/resourceID.csv exists.
if not exist ../data/resourceID.csv (
    echo ../data/resourceID.csv file not found!
    pause
    exit /b 1
)

rem Create (or overwrite) output CSV file in ../data directory.
echo resourceType,resourceName,resourceID,metrics > ../data/ResourcesMetrics.csv

rem Loop through resourceID.csv, skipping the header line.
for /f "skip=1 tokens=1,2,3 delims=," %%A in (../data/resourceID.csv) do (
    set "resType=%%A"
    set "resName=%%B"
    set "resID=%%C"
    set "metrics="
    
    echo Processing resource: !resName! with ID: !resID!

    rem Execute the Azure CLI command then process with jq.
    for /f "delims=" %%M in ('az monitor metrics list-definitions --resource "!resID!" ^| jq -r ".[].id | split(\"/\") | .[-1]"') do (
         set "metrics=!metrics!;%%M"
    )
    
    rem Remove the initial semicolon if present.
    if defined metrics (
       set "metrics=!metrics:~1!"
    )

    rem Output one CSV line.
    echo !resType!,!resName!,!resID!,!metrics! >> ../data/ResourcesMetrics.csv
)

echo.
echo Metrics extraction is complete. Check ../data/ResourcesMetrics.csv for results.
pause
endlocal
