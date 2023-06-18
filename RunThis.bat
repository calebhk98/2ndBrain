@echo off

if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    set INSTALL_REQUIREMENTS=1
) else (
    set INSTALL_REQUIREMENTS=0
)

echo Activating virtual environment...
call venv\Scripts\activate

if %INSTALL_REQUIREMENTS%==1 (
    echo Installing dependencies from requirements.txt...
) else (
    echo Checking for updates in requirements.txt...
)

for /F "tokens=*" %%p in (requirements.txt) do (
    echo Installing/updating package: %%p
    pip install --no-cache-dir %%p --upgrade >nul 2>&1
)

echo Running the application...
python run.py

echo Deactivating virtual environment...
call venv\Scripts\deactivate.bat

pause