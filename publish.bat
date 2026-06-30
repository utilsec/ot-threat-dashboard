@echo off
REM ============================================================
REM  Publishes the latest OT/ICS dashboard to GitHub Pages.
REM  - Double-click to run manually, OR
REM  - Schedule via Windows Task Scheduler for full automation.
REM
REM  Safe to run as often as you like: it only pushes when
REM  index.html actually changed, and quietly no-ops otherwise.
REM  Every run appends a line to publish-log.txt.
REM ============================================================
cd /d "%~dp0"

REM --- Stage only the dashboard ---
git add index.html

REM --- Commit only if there is a change; otherwise stop cleanly ---
git diff --cached --quiet
if %errorlevel%==0 (
    echo [%DATE% %TIME%] No changes - nothing to publish.>> publish-log.txt
    echo No changes to publish right now.
    timeout /t 4 >nul
    exit /b 0
)

git commit -m "Daily OT/ICS dashboard update %DATE% %TIME%"
git push origin main
if errorlevel 1 (
    echo [%DATE% %TIME%] PUSH FAILED - check network / git credentials.>> publish-log.txt
    echo Push failed. See publish-log.txt.
    timeout /t 8 >nul
    exit /b 1
)

echo [%DATE% %TIME%] Published OK.>> publish-log.txt
echo.
echo Done. Your Wix page will reflect the update within a couple of minutes.
timeout /t 6 >nul
exit /b 0
