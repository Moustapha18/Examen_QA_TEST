@echo off
REM Lance le Lab 2 (API Petstore). Prerequis : environnement virtuel actif.
robot --outputdir lab2_api_petstore\results --name "Lab2 - Swagger Petstore API" --loglevel INFO %* lab2_api_petstore\tests
