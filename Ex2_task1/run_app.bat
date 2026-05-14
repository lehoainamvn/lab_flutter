@echo off
echo Flutter Shopping Cart App Setup
echo.
echo Starting backend server...
start cmd /k "cd backend && npm install && npm start"
echo.
echo Waiting for backend to start...
timeout /t 5 /nobreak > nul
echo.
echo Getting Flutter dependencies...
call flutter pub get
echo.
echo Starting Flutter app...
call flutter run