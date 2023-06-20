@echo off

python --version >nul 2>&1

if errorlevel 1 (
    echo Python is not installed or not in the system PATH.
    echo Attempting to download and install Python...

    powershell -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.10.2/python-3.10.2-amd64.exe' -OutFile 'python_installer.exe'"
    python_installer.exe /passive /norestart InstallAllUsers=1 PrependPath=1

    if errorlevel 1 (
        echo Failed to install Python. Please visit https://www.python.org/downloads/ and install it manually.
        exit /b
    )

    echo Successfully installed Python.
    del python_installer.exe

    echo Adding Python to the PATH.
    set "PATH=%PATH%;%localappdata%\Programs\Python\Python310\Scripts;%localappdata%\Programs\Python\Python310\"
)

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