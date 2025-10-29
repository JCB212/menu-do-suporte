@echo off
title Reparar Base de Dados Firebird
color 0A
setlocal enabledelayedexpansion

echo ================================================================
echo   REPARO DE BASE FIREBIRD - SCRIPT SIMPLIFICADO
echo ================================================================
echo.

:: ==============================
:: Solicita o caminho do Firebird
:: ==============================
set /p FIREBIRD_PATH=Digite o caminho da pasta BIN do Firebird (ex: C:\Program Files\Firebird\Firebird_2_5\bin): 
if not exist "%FIREBIRD_PATH%" (
    echo ERRO: Pasta nao encontrada.
    pause
    exit /b
)
echo Firebird localizado em: "%FIREBIRD_PATH%"
echo.

:: ==============================
:: Solicita o caminho do banco
:: ==============================
set /p DB_PATH=Digite o caminho completo do banco (ex: C:\TSD\Host\HOST.FDB): 
if not exist "%DB_PATH%" (
    echo ERRO: Banco nao encontrado.
    pause
    exit /b
)
echo Banco localizado em: "%DB_PATH%"
echo.

:: ==============================
:: Define arquivos temporarios
:: ==============================
set BACKUP_FILE=%DB_PATH%.GBK
set NEW_DB=%DB_PATH:.FDB=_NOVO.FDB%
set USER=SYSDBA
set PASS=masterkey

echo ================================================================
echo INICIANDO PROCESSO DE REPARO
echo ================================================================
echo.

:: ---------------------------------------------------
:: Etapa 1 - Verificação de integridade
:: ---------------------------------------------------
echo [1/4] Verificando integridade...
"%FIREBIRD_PATH%\gfix" -v -full "%DB_PATH%" -user %USER% -pass %PASS%
if errorlevel 1 (
    echo Erro na verificacao de integridade.
    pause
    exit /b
)
echo OK.
echo.

:: ---------------------------------------------------
:: Etapa 2 - Tentando correção leve
:: ---------------------------------------------------
echo [2/4] Tentando correção com gfix -mend...
"%FIREBIRD_PATH%\gfix" -mend "%DB_PATH%" -user %USER% -pass %PASS%
if errorlevel 1 (
    echo Erro no reparo.
    pause
    exit /b
)
echo OK.
echo.

:: ---------------------------------------------------
:: Etapa 3 - Backup com GBAK
:: ---------------------------------------------------
echo [3/4] Criando backup limpo...
if exist "%BACKUP_FILE%" del "%BACKUP_FILE%"
"%FIREBIRD_PATH%\gbak" -b -v -ignore -garbage -limbo "%DB_PATH%" "%BACKUP_FILE%" -user %USER% -pass %PASS%
if errorlevel 1 (
    echo Erro ao gerar backup.
    pause
    exit /b
)
echo Backup criado: %BACKUP_FILE%
echo.

:: ---------------------------------------------------
:: Etapa 4 - Restaurando base nova
:: ---------------------------------------------------
echo [4/4] Restaurando nova base de dados...
if exist "%NEW_DB%" del "%NEW_DB%"
"%FIREBIRD_PATH%\gbak" -c -v -z "%BACKUP_FILE%" "%NEW_DB%" -user %USER% -pass %PASS%
if errorlevel 1 (
    echo Erro ao restaurar nova base.
    pause
    exit /b
)
echo Nova base criada: %NEW_DB%
echo.

echo ================================================================
echo [SUCESSO] Processo de reparo concluído com êxito!
echo Base original : %DB_PATH%
echo Base reparada  : %NEW_DB%
echo ================================================================
pause
exit /b
