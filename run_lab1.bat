@echo off
REM Lance le Lab 1 (suite complete). Arguments additionnels : ex. --include smoke
REM Prerequis : environnement virtuel active (.venv\Scripts\activate.bat)
robot --outputdir lab1_ui_crm\results --name "Lab1 - Customer Service CRM" --loglevel INFO %* lab1_ui_crm\tests
