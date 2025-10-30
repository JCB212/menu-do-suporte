@echo off
rem ************************************************************
rem * Criado por: Alice Dzindzik                               *
rem * Modificado por: Jean Carlos De Jesus Barreto             *
rem * GitHub: AliceDzindzik                                    *
rem * GitHub: JCB212                                           *
rem * FERRAMENTA HELP TO DESK V 4.1 (COM VERIFICAÇÃO DE ADMIN) *
rem ************************************************************

rem Define o título da janela do prompt de comando
title FERRAMENTA HELP TO DESK V 4.1 (COM VERIFICAÇÃO DE ADMIN)
color 0A

rem Ativa a expansão de variáveis para o menu principal
setlocal enabledelayedexpansion 

rem ==========================================================
rem                           MENU PRINCIPAL
rem ==========================================================
:menu
cls
echo ==================================================
echo   FERRAMENTA HELP TO DESK V 4.1 (UNIFICADA)
echo   Criado por Alice Dzindzik e Jean Carlos
echo ==================================================
echo 1. Infraestrutura (Rede, Firewall, Eventos)
echo 2. Sistema (Manutencao, Diagnostico e Links)
echo 3. Impressoras (Spooler, Erros e Compartilhamento)
echo 0. Reparo de Base de Dados Firebird 
echo 4. Sair
echo ==================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto infra
if "%opcao%"=="2" goto sistema
if "%opcao%"=="3" goto impressoras
if "%opcao%"=="0" goto reparo_firebird
if "%opcao%"=="4" goto sair
echo Opcao invalida.
pause
goto menu

rem ==========================================================
rem                         FUNÇÕES DE BACKUP (AJUSTADAS)
rem ==========================================================

:escolher_destino
rem Funcao para solicitar o caminho de destino do backup
set "destino="
set /p "destino=Digite o caminho COMPLETO da pasta de destino para o backup (Ex: C:\Usuarios\SeuNome\Desktop\BACKUP): "
if not exist "%destino%" (
    echo.
    echo ATENCAO: O caminho nao existe. Deseja cria-lo? (S/N)
    set /p "criar= "
    if /i "%criar%"=="S" (
        mkdir "%destino%"
        if errorlevel 1 (
            echo.
            echo ERRO: Nao foi possivel criar a pasta. Verifique as permissoes.
            pause
            goto :menu
        )
    ) else (
        echo.
        echo Operacao de backup cancelada.
        pause
        goto :menu
    )
)
rem Retorna para o label que chamou a funcao
goto %1

:backup_registro_executar
rem Realiza um backup rapido do registro
call :escolher_destino backup_registro_executar
if not defined destino goto sistema_backup
set "backupPath=%destino%\Backup_Registro_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.reg"
reg export "HKLM\SYSTEM\CurrentControlSet" "%backupPath%" /y
echo.
echo Backup do registro salvo em: %backupPath%
pause
goto sistema_backup

:backup_logs_eventos_executar
rem Cria backup dos logs de eventos
call :escolher_destino backup_logs_eventos_executar
if not defined destino goto sistema_backup
echo.
echo Criando backup dos logs de eventos...
wevtutil epl Application "%destino%\Application.evtx"
wevtutil epl System "%destino%\System.evtx"
echo.
echo Backup concluido em: %destino%
pause
goto sistema_backup

:driverbackup_executar
rem Backup de drivers
call :escolher_destino driverbackup_executar
if not defined destino goto sistema_backup
echo.
echo Realizando backup de drivers...
echo Isso pode levar algum tempo. Por favor, aguarde.
dism /online /export-driver /destination:"%destino%\Drivers_Backup"
echo.
echo Backup de drivers concluido! Salvo em: "%destino%\Drivers_Backup"
pause
goto sistema_backup

rem ==========================================================
rem                    REPARO FIREBIRD (MANTIDO)
rem ==========================================================
:reparo_firebird
setlocal 
cls
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
    endlocal
    goto menu
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
    endlocal
    goto menu
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
    endlocal
    goto menu
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
    endlocal
    goto menu
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
    endlocal
    goto menu
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
    endlocal
    goto menu
)
echo Nova base criada: %NEW_DB%
echo.
echo ================================================================
echo [SUCESSO] Processo de reparo concluído com êxito!
echo Base original : %DB_PATH%
echo Base reparada  : %NEW_DB%
echo ================================================================
pause
endlocal
goto menu

rem ==========================================================
rem                         GRUPO 1: INFRAESTRUTURA
rem ==========================================================
:infra
cls
echo ================= INFRAESTRUTURA =================
echo 1. Informacoes de Rede e Diagnostico
echo 2. Configuracao e Liberacao de Firewall
echo 3. Compartilhamento de Pastas e SMB
echo 4. Logs e Visualizador de Eventos
echo A. Voltar para o menu principal
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto infra_rede
if "%opcao%"=="2" goto infra_firewall
if "%opcao%"=="3" goto infra_compartilhamento
if "%opcao%"=="4" goto infra_logs
if /i "%opcao%"=="a" goto menu
echo Opcao invalida.
pause
goto infra

rem --- SUBGRUPO: INFRAESTRUTURA/REDE ---
:infra_rede
cls
echo ============= INFRAESTRUTURA / REDE =============
echo 1. Verificar informacoes completas da rede (IPCONFIG /ALL)
echo 2. Flush DNS e Limpeza de Cache de Navegador
echo 3. Testes de Conectividade (Ping e Pathping)
echo 4. Resetar configuracoes de rede (Winsock/IP)
echo 5. Mapear unidade de rede
echo 6. Ver adaptadores de rede (ncpa.cpl)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto ipall
if "%opcao%"=="2" goto flush_tudo
if "%opcao%"=="3" goto pingserv_menu
if "%opcao%"=="4" goto winsock_completo
if "%opcao%"=="5" goto mapear_rede
if "%opcao%"=="6" goto ncpa_cpl
if /i "%opcao%"=="b" goto infra
echo Opcao invalida.
pause
goto infra_rede

:flush_tudo
call :flushdns
call :flush_navegador
goto infra_rede

:pingserv_menu
cls
echo ============= TESTES DE CONECTIVIDADE =============
echo 1. Ping Servidor
echo 2. Rastrear rota para servidor (Pathping)
echo 3. Testar conectividade de rede (Ping Google)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto pingserv
if "%opcao%"=="2" goto pathping_serv
if "%opcao%"=="3" goto ping_google
if /i "%opcao%"=="b" goto infra_rede
echo Opcao invalida.
pause
goto pingserv_menu

:pingserv
set /p ipNome=Digite o nome ou IP do Servidor:
ping %ipNome%
pause
goto pingserv_menu

:pathping_serv
set /p ipNome=Digite o nome ou IP do Servidor para rastrear a rota:
pathping %ipNome%
pause
goto pingserv_menu

:ipall
echo Exibindo informacoes de rede (pressione a barra de espaco para avancar)...
ipconfig /all | more
pause
goto infra_rede

:flushdns
echo Executando ipconfig /flushdns...
ipconfig /flushdns
echo Cache DNS limpo com sucesso!
goto :eof

:flush_navegador
echo Limpando cache do navegador...
if exist "%LocalAppData%\Google\Chrome\User Data\Default\Cache" (
    del /s /q "%LocalAppData%\Google\Chrome\User Data\Default\Cache\*.*"
)
if exist "%AppData%\Mozilla\Firefox\Profiles" (
    for /d %%d in ("%AppData%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%d\cache2" (
            rd /s /q "%%d\cache2"
        )
    )
)
echo Cache do navegador limpo.
pause
goto :eof

:ping_google
echo Testando conexao com google.com...
ping google.com -n 4
echo Teste concluido!
pause
goto pingserv_menu

:winsock_completo
echo Resetando configuracoes de rede...
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
echo Eh necessario reiniciar o computador para que as alteracoes tenham efeito.
pause
goto infra_rede

:mapear_rede
cls
echo ============= MAPEAR UNIDADE =============
set /p "acao=Digite 'mapear' para mapear ou 'desconectar' para desconectar: "
if /i "%acao%"=="mapear" goto mapear_rede_executar
if /i "%acao%"=="desconectar" goto desconectar_rede_executar
echo Opcao invalida.
pause
goto mapear_rede

:mapear_rede_executar
set /p "letra=Digite a letra da unidade (ex: Z): "
set /p "caminho=Digite o caminho da pasta compartilhada (ex: \\servidor\pasta): "
net use %letra%: %caminho%
echo Unidade mapeada com sucesso!
pause
goto infra_rede

:desconectar_rede_executar
set /p "letra=Digite a letra da unidade para desconectar (ex: Z): "
net use %letra%: /delete
echo Unidade desconectada com sucesso!
pause
goto infra_rede

:ncpa_cpl
echo Abrindo adaptadores de rede...
start ncpa.cpl
pause
goto infra_rede


rem --- SUBGRUPO: INFRAESTRUTURA/FIREWALL ---
:infra_firewall
cls
echo =========== INFRAESTRUTURA / FIREWALL ===========
echo 1. Abrir configuracoes do Firewall
echo 2. Liberar porta 3050 (Firebird) no Firewall
echo 3. Liberar acesso a compartilhamentos (SMB)
echo 4. Exibir conexoes de rede ativas (Netstat)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto firewall_ui
if "%opcao%"=="2" goto firebird_port
if "%opcao%"=="3" goto compartilhamento
if "%opcao%"=="4" goto netstat_info
if /i "%opcao%"=="b" goto infra
echo Opcao invalida.
pause
goto infra_firewall

:firewall_ui
echo Abrindo configuracoes do Firewall do Windows...
firewall.cpl
pause
goto infra_firewall

:firebird_port
echo Adicionando regras de entrada e saida para a porta 3050 (Firebird)...
netsh advfirewall firewall add rule name="Firebird_In" dir=in action=allow protocol=TCP localport=3050
netsh advfirewall firewall add rule name="Firebird_Out" dir=out action=allow protocol=TCP localport=3050
echo Regras do Firewall adicionadas com sucesso.
pause
goto infra_firewall

:compartilhamento
echo Executando comandos PowerShell para liberar acesso a compartilhamentos...
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature \$false -Confirm:\$false"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons \$true -Confirm:\$false"
echo Acesso a compartilhamentos liberado.
pause
goto infra_firewall

:netstat_info
echo Exibindo conexoes de rede ativas (pressione a barra de espaco para avancar)...
netstat -ano | more
pause
goto infra_firewall


rem --- SUBGRUPO: INFRAESTRUTURA/COMPARTILHAMENTO ---
:infra_compartilhamento
cls
echo ====== INFRAESTRUTURA / COMPARTILHAMENTO ======
echo 1. Compartilhamento avancado de pasta na rede
echo 2. Liberar acesso a compartilhamentos (SMB) (Duplicado, mas mantido por seguranca)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto compartilhar_avancado
if "%opcao%"=="2" goto compartilhamento
if /i "%opcao%"=="b" goto infra
echo Opcao invalida.
pause
goto infra_compartilhamento

:compartilhar_avancado
set /p "pasta=Digite o caminho COMPLETO da pasta que deseja compartilhar (ex: C:\dados): "
set /p "nome_compartilhamento=Digite o NOME do compartilhamento: "
net share "%nome_compartilhamento%"="%pasta%" /GRANT:Everyone,FULL
echo A pasta '%pasta%' foi compartilhada como '%nome_compartilhamento%' com acesso total para 'Todos'.
pause
goto infra_compartilhamento


rem --- SUBGRUPO: INFRAESTRUTURA/LOGS ---
:infra_logs
cls
echo ============== INFRAESTRUTURA / LOGS ==============
echo 1. Abrir Visualizador de Eventos (eventvwr.msc)
echo 2. Limpeza de logs de eventos
echo 3. Backup dos logs de eventos (com escolha de destino)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto eventlog
if "%opcao%"=="2" goto limpar_logs
if "%opcao%"=="3" goto backup_logs_eventos_executar
if /i "%opcao%"=="b" goto infra
echo Opcao invalida.
pause
goto infra_logs

:eventlog
echo Abrindo Visualizador de Eventos...
eventvwr.msc
pause
goto infra_logs

:limpar_logs
echo Limpando logs de eventos...
for /F "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1"
echo Concluido.
pause
goto infra_logs


rem ==========================================================
rem                           GRUPO 2: SISTEMA
rem ==========================================================
:sistema
cls
echo ====================== SISTEMA =====================
echo 1. Manutencao, Otimizacao e Reparo
echo 2. Diagnostico e Gerenciamento de Hardware
echo 3. Backup e Restauracao
echo 4. Aplicativos e Gerenciamento de Programas
echo 5. Links Uteis (Sistema de Gestao)
echo A. Voltar para o menu principal
echo ====================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto sistema_manutencao
if "%opcao%"=="2" goto sistema_diagnostico
if "%opcao%"=="3" goto sistema_backup
if "%opcao%"=="4" goto sistema_apps
if "%opcao%"=="5" goto sistema_links
if /i "%opcao%"=="a" goto menu
echo Opcao invalida.
pause
goto sistema

rem --- SUBGRUPO: SISTEMA/MANUTENÇÃO ---
:sistema_manutencao
cls
echo =========== SISTEMA / MANUTENCAO ===========
echo 1. Reiniciar Computador
echo 2. Lentidao e reparo (Limpeza + SFC + DISM)
echo 3. Atualizar Group Policy (gpupdate /force)
echo 4. Reset do Windows Update
echo 5. Desfragmentar Disco
echo 6. Limpeza de arquivos temporarios
echo 7. Executar Comando Personalizado
echo 8. Instalar Acesso Remoto (AnyDesk, RustDesk, HopToDesk)
echo B. Voltar para o menu anterior
echo ============================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto reiniciar
if "%opcao%"=="2" goto lentidao_completa
if "%opcao%"=="3" goto updateGp
if "%opcao%"=="4" goto update_reset
if "%opcao%"=="5" goto defrag_opcoes
if "%opcao%"=="6" goto limpeza_temp
if "%opcao%"=="7" goto customcmd
if "%opcao%"=="8" goto instalar_acesso_remoto
if /i "%opcao%"=="b" goto sistema
echo Opcao invalida.
pause
goto sistema_manutencao

:reiniciar
shutdown /r /t 0
goto fim

:lentidao_completa
cls
echo Etapa 1: Abrindo pastas temporarias e limpando...
start "" "%temp%"
start "" "%SystemRoot%\SoftwareDistribution\Download"
start "" "C:\Windows\Prefetch"
del /f /s /q "%temp%\*.*"
del /f /s /q "%SystemRoot%\SoftwareDistribution\Download\*.*"
del /f /s /q "C:\Windows\Prefetch\*.*"
cleanmgr /sagerun:1
echo Limpeza concluida!
pause

echo Etapa 2: Executando SFC...
sfc /scannow
pause

echo Etapa 3: Verificando integridade da imagem do Windows (DISM)...
dism /online /cleanup-image /restorehealth
pause
goto sistema_manutencao

:updateGp
echo Atualizando Politica de Grupo...
gpupdate /force
pause
goto sistema_manutencao

:update_reset
cls
echo Resetando componentes do Windows Update...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old
ren C:\Windows\System32\catroot2 catroot2.old
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo Concluido.
pause
goto sistema_manutencao

:defrag_opcoes
cls
echo Executando desfragmentacao de disco...
call :escolher_drive defrag_executar
pause
goto sistema_manutencao

:defrag_executar
echo Isso pode levar algum tempo. Por favor, aguarde.
defrag %drive%: /O
echo Desfragmentacao concluida!
pause
goto sistema_manutencao

:limpeza_temp
cls
echo Limpando arquivos temporarios...
del /s /f /q "%TEMP%\*"
del /s /f /q "C:\Windows\Temp\*"
echo Concluido.
pause
goto sistema_manutencao

:customcmd
cls
echo Abrindo prompt de comando para comandos personalizados...
cmd.exe
echo Retornando ao menu.
pause
goto sistema_manutencao

:escolher_drive
set /p "drive=Digite a letra da unidade (ex: C): "
set "drive=%drive::=%"
if not exist "%drive%:" (
    echo Unidade "%drive%" nao encontrada. Tente novamente.
    goto escolher_drive
)
goto %1

rem --- NOVO BLOCO: INSTALAÇÃO DE ACESSO REMOTO (Com Verificação de Admin) ---
:instalar_acesso_remoto
chcp 65001 >nul
setlocal
cls

REM VERIFICAÇÃO DE PRIVILÉGIOS DE ADMIN
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ===================================================
    echo ERRO: PERMISSAO NEGADA
    echo Para instalar softwares (winget/silencioso),
    echo o script DEVE ser executado como ADMINISTRADOR.
    echo Por favor, feche e abra o arquivo .bat novamente
    echo clicando com o botao direito e escolhendo "Executar
    echo como administrador".
    echo ===================================================
    pause
    endlocal
    goto sistema_manutencao
)


REM ------------------------------------------------
REM Install AnyDesk, HopToDesk, RustDesk (winget+fallback)
REM ------------------------------------------------
echo ===================================================
echo INSTALADOR DE ACESSO REMOTO
echo Aplicativos: AnyDesk, HopToDesk, RustDesk
echo ===================================================
echo.

REM ---------- parâmetros ----------
set "ANYDESK_WINGET=AnyDeskSoftwareGmbH.AnyDesk"
set "RUST_WINGET=RustDesk.RustDesk"
set "HOP_WINGET=9N0NXG9ZMF7Z"   REM MS Store id (HopToDesk)

REM ---------- helper: checa winget ----------
where winget >nul 2>&1
if %errorlevel%==0 (
  set "HAS_WINGET=1"
) else (
  set "HAS_WINGET=0"
)

REM ---------- AnyDesk ----------
echo ===================================================
echo Instalando AnyDesk...
if "%HAS_WINGET%"=="1" (
  echo Tentando winget install AnyDesk...
  winget install --id=%ANYDESK_WINGET% -e --accept-package-agreements --accept-source-agreements
  if %errorlevel%==0 (
    echo AnyDesk instalado via winget.
    goto after_anydesk
  ) else (
    echo winget falhou para AnyDesk, tentando fallback...
  )
)

REM Fallback: baixar instalador AnyDesk e instalar silenciosamente
echo Baixando AnyDesk (fallback)...
powershell -Command "Invoke-WebRequest 'https://download.anydesk.com/AnyDesk.exe' -OutFile '$env:TEMP\AnyDesk_installer.exe' -UseBasicParsing"
if exist "%TEMP%\AnyDesk_installer.exe" (
  echo Executando instalador AnyDesk (silencioso)...
  "%TEMP%\AnyDesk_installer.exe" --install --silent
  if %errorlevel%==0 (
    echo AnyDesk instalado via instalador.
  ) else (
    echo Falha ao instalar AnyDesk via instalador. Verifique manualmente.
  )
) else (
  echo FALHA: nao foi possivel baixar AnyDesk.
)

:after_anydesk
echo.

REM ---------- HopToDesk ----------
echo ===================================================
echo Instalando HopToDesk...
if "%HAS_WINGET%"=="1" (
  echo Tentando winget install HopToDesk (MS Store)...
  winget install --id=%HOP_WINGET% -s msstore -e --accept-package-agreements --accept-source-agreements
  if %errorlevel%==0 (
    echo HopToDesk instalado via winget/msstore.
    goto after_hop
  ) else (
    echo winget/msstore falhou para HopToDesk. Tentando baixar do site...
  )
)

REM Fallback HopToDesk: baixar do site oficial e executar
echo Baixando HopToDesk instalador (fallback)...
powershell -Command "Invoke-WebRequest 'https://www.hoptodesk.com/download/windows' -OutFile '$env:TEMP\HopToDesk_installer.exe' -UseBasicParsing" >nul 2>&1
if exist "%TEMP%\HopToDesk_installer.exe" (
  echo Instalando HopToDesk...
  "%TEMP%\HopToDesk_installer.exe" /SILENT /VERYSILENT /NORESTART >nul 2>&1
  if %errorlevel%==0 (
    echo HopToDesk instalado via instalador.
  ) else (
    echo Falha na instalacao silenciosa do HopToDesk. Pode ser necessario instalar manualmente.
  )
) else (
  echo Aviso: nao foi possivel baixar HopToDesk automaticamente; instale manualmente a partir de https://hoptodesk.com
)

:after_hop
echo.

REM ---------- RustDesk ----------
echo ===================================================
echo Instalando RustDesk...
if "%HAS_WINGET%"=="1" (
  echo Tentando winget install RustDesk...
  winget install --id=%RUST_WINGET% -e --accept-package-agreements --accept-source-agreements
  if %errorlevel%==0 (
    echo RustDesk instalado via winget.
    goto after_rust
  ) else (
    echo winget falhou para RustDesk, tentando fallback...
  )
)

REM Fallback RustDesk: baixar release do GitHub e instalar silenciosamente
echo Baixando RustDesk (fallback)...
powershell -Command "Invoke-WebRequest 'https://github.com/rustdesk/rustdesk/releases/latest/download/rustdesk-setup.exe' -OutFile '$env:TEMP\rustdesk-setup.exe' -UseBasicParsing" >nul 2>&1
if exist "%TEMP%\rustdesk-setup.exe" (
  echo Executando RustDesk (instalacao silenciosa --silent-install)...
  "%TEMP%\rustdesk-setup.exe" --silent-install
  if %errorlevel%==0 (
    echo RustDesk instalado via instalador.
  ) else (
    echo Falha ao instalar RustDesk via instalador. Verifique manualmente.
  )
) else (
  echo FALHA: nao foi possivel baixar RustDesk automaticamente.
)

:after_rust
echo.
echo ===================================================
echo Processo de instalacao finalizado.
echo Verifique se os apps estao presentes no menu Iniciar.
echo ===================================================
pause
endlocal
goto sistema_manutencao
rem --- FIM DO BLOCO: INSTALAÇÃO DE ACESSO REMOTO ---

rem --- SUBGRUPO: SISTEMA/DIAGNÓSTICO ---
:sistema_diagnostico
cls
echo =========== SISTEMA / DIAGNOSTICO ===========
echo 1. Verificar e Reparar Disco (CHKDSK)
echo 2. Exibir informacoes do sistema (systeminfo)
echo 3. Exibir espaco em disco
echo 4. Verificar status do antivirus
echo 5. Ver status dos principais servicos
echo 6. Testar velocidade de disco (winsat)
echo 7. Testar velocidade da internet (fast.com)
echo 8. Visualizar dispositivos USB conectados
echo B. Voltar para o menu anterior
echo =============================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto chkdsk_opcoes
if "%opcao%"=="2" goto sysinfo
if "%opcao%"=="3" goto espaco_disco
if "%opcao%"=="4" goto antivirus_status
if "%opcao%"=="5" goto servicos_status
if "%opcao%"=="6" goto disktest
if "%opcao%"=="7" goto testar_velocidade
if "%opcao%"=="8" goto usb_check
if /i "%opcao%"=="b" goto sistema
echo Opcao invalida.
pause
goto sistema_diagnostico

:chkdsk_opcoes
echo Executando verificacao e reparo de disco...
call :escolher_drive chkdsk_executar
pause
goto sistema_diagnostico

:chkdsk_executar
echo Isso pode levar algum tempo. Por favor, aguarde.
chkdsk %drive%: /f /r
echo Verificacao concluida!
pause
goto sistema_diagnostico

:sysinfo
echo Exibindo informacoes do sistema (pressione a barra de espaco para avancar)...
systeminfo | more
pause
goto sistema_diagnostico

:espaco_disco
echo Espaco em disco:
wmic logicaldisk get deviceid,volumename,size,freespace
pause
goto sistema_diagnostico

:antivirus_status
cls
echo Verificando status do Windows Defender...
powershell -command "Get-MpComputerStatus | Select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled"
pause
goto sistema_diagnostico

:servicos_status
cls
echo Verificando status de servicos principais...
sc query wuauserv
sc query bits
sc query dhcp
sc query dnscache
sc query nlasvc
sc query netprofm
pause
goto sistema_diagnostico

:disktest
echo Testando velocidade de disco...
winsat disk -drive C
pause
goto sistema_diagnostico

:testar_velocidade
start https://www.fast.com
echo Abrindo site de teste de velocidade.
pause
goto sistema_diagnostico

:usb_check
@echo off
cls
echo Verificando dispositivos USB conectados...
wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description | findstr /i "USB" >nul
if %errorlevel%==0 (
    echo Dispositivos USB conectados:
    wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description
) else (
    echo Nenhum dispositivo USB encontrado.
)
pause
goto sistema_diagnostico


rem --- SUBGRUPO: SISTEMA/BACKUP E RESTAURAÇÃO ---
:sistema_backup
cls
echo ========= SISTEMA / BACKUP E RESTAURACAO =========
echo 1. Criar Ponto de Restauracao
echo 2. Abrir Restauracao do Sistema (rstrui.exe)
echo 3. Backup rapido do Registro (com escolha de destino)
echo 4. Fazer backup de Drivers (com escolha de destino)
echo B. Voltar para o menu anterior
echo ==================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto restorepoint
if "%opcao%"=="2" goto restore_ui
if "%opcao%"=="3" goto backup_registro_executar
if "%opcao%"=="4" goto driverbackup_executar
if /i "%opcao%"=="b" goto sistema
echo Opcao invalida.
pause
goto sistema_backup

:restorepoint
cls
echo Criando ponto de restauracao...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Ponto de Restauracao - Script TI", 100, 7
echo Ponto de restauracao criado com sucesso!
pause
goto sistema_backup

:restore_ui
echo Abrindo Restauracao do Sistema...
rstrui.exe
pause
goto sistema_backup


rem --- SUBGRUPO: SISTEMA/APLICATIVOS E GERENCIAMENTO ---
:sistema_apps
cls
echo ====== SISTEMA / APPS E GERENCIAMENTO ======
echo 1. Desinstalar programa
echo 2. Gerenciar aplicativos com Winget
echo 3. Abrir Gerenciador de Programas (appwiz.cpl)
echo 4. Abrir Gerenciador de Tarefas
echo 5. Abrir Gerenciador de Dispositivos (devmgmt.msc)
echo 6. Abrir Gerenciamento de Disco (diskmgmt.msc)
echo 7. Gerenciar Usuarios Locais (lusrmgr.msc)
echo 8. Verificar Atualizacoes do Windows
echo B. Voltar para o menu anterior
echo ==============================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto desinstalar_programa
if "%opcao%"=="2" goto winget_menu
if "%opcao%"=="3" goto appwiz_cpl
if "%opcao%"=="4" goto taskmgr
if "%opcao%"=="5" goto devmgmt_cpl
if "%opcao%"=="6" goto diskmgmt
if "%opcao%"=="7" goto usermgmt
if "%opcao%"=="8" goto windows_updates
if /i "%opcao%"=="b" goto sistema
echo Opcao invalida.
pause
goto sistema_apps

:desinstalar_programa
echo Listando programas instalados (pode levar alguns segundos)...
powershell -command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,Publisher,InstallDate | Format-Table -AutoSize"
set /p "nome_programa=Digite o nome EXATO do programa para desinstalar: "
wmic product where name="%nome_programa%" call uninstall /nointeractive
pause
goto sistema_apps

:winget_menu
cls
echo ==================================================
echo   SISTEMA / WINGET
echo ==================================================
echo 1. Listar aplicativos instalados
echo 2. Procurar por um aplicativo
echo 3. Instalar um aplicativo
echo 4. Atualizar todos os aplicativos
echo 5. Desinstalar um aplicativo
echo 6. Voltar para o menu anterior
echo ==================================================
set /p "opcao=Escolha uma opcao: "
if "%opcao%"=="1" goto wingetlist
if "%opcao%"=="2" goto wingetsearch
if "%opcao%"=="3" goto wingetinstall
if "%opcao%"=="4" goto wingetupgrade
if "%opcao%"=="5" goto wingetuninstall
if "%opcao%"=="6" goto sistema_apps
echo Opcao invalida.
pause
goto winget_menu

:wingetlist
winget list | more
pause
goto winget_menu

:wingetsearch
set /p "appsearch=Digite o nome do aplicativo para procurar: "
winget search "%appsearch%" | more
pause
goto winget_menu

:wingetinstall
set /p "appinstall=Digite o ID ou nome do aplicativo para instalar: "
winget install "%appinstall%"
pause
goto winget_menu

:wingetupgrade
winget upgrade --all
pause
goto winget_menu

:wingetuninstall
set /p "appuninstall=Digite o ID ou nome do aplicativo para desinstalar: "
winget uninstall "%appuninstall%"
pause
goto winget_menu

:appwiz_cpl
echo Abrindo lista de programas instalados...
start appwiz.cpl
pause
goto sistema_apps

:taskmgr
echo Abrindo Gerenciador de Tarefas...
taskmgr.exe
pause
goto sistema_apps

:devmgmt_cpl
echo Abrindo Gerenciador de Dispositivos...
start devmgmt.msc
pause
goto sistema_apps

:diskmgmt
echo Abrindo Gerenciamento de Disco...
diskmgmt.msc
pause
goto sistema_apps

:usermgmt
echo Abrindo Gerenciamento de Usuarios Locais...
lusrmgr.msc
pause
goto sistema_apps

:windows_updates
start ms-settings:windowsupdate
echo Abrindo configuracoes do Windows Update.
pause
goto sistema_apps

rem --- SUBGRUPO: SISTEMA/LINKS ÚTEIS ---
:sistema_links
cls
echo ========= SISTEMA / LINKS ÚTEIS =========
echo 1. Sistema de Gestão (Host da Hotline)
echo B. Voltar para o menu anterior
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto link_host_hotline
if /i "%opcao%"=="b" goto sistema
echo Opcao invalida.
pause
goto sistema_links

:link_host_hotline
start https://mega.nz/folder/TApVnBQT#VCEDyDe6MepHLjw1g7zTzw
echo Abrindo link com as versoes do sistema Host da Hotline...
pause
goto sistema_links


rem ==========================================================
rem                         GRUPO 3: IMPRESSORAS
rem ==========================================================
:impressoras
cls
echo ==================== IMPRESSORAS ===================
echo 1. Diagnostico e Reparo de Fila
echo 2. Instalacao e Correcao de Erros Comuns
echo A. Voltar para o menu principal
echo ====================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto impressoras_diagnostico
if "%opcao%"=="2" goto impressoras_erros_instalacao
if /i "%opcao%"=="a" goto menu
echo Opcao invalida.
pause
goto impressoras

rem --- SUBGRUPO: IMPRESSORAS/DIAGNÓSTICO E REPARO DE FILA ---
:impressoras_diagnostico
cls
echo ====== IMPRESSORAS / DIAGNOSTICO E FILA ======
echo 1. Listar Impressoras Instaladas
echo 2. Reiniciar Spooler de Impressao
echo 3. Limpar Fila de Impressao e Reiniciar Spooler
echo 4. Compartilhar/Renomear Impressora na Rede
echo B. Voltar para o menu anterior
echo ==============================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto listar_impressoras
if "%opcao%"=="2" goto reiniciar_spooler
if "%opcao%"=="3" goto limpar_e_reiniciar_spooler
if "%opcao%"=="4" goto compartilhar_impressora_flow
if /i "%opcao%"=="b" goto impressoras
echo Opcao invalida.
pause
goto impressoras_diagnostico

:listar_impressoras
echo Impressoras Instaladas:
powershell -command "Get-Printer | Format-Table Name,PortName,DriverName -AutoSize" | more
pause
goto impressoras_diagnostico

:reiniciar_spooler
net stop spooler
timeout /t 3 >nul
net start spooler
echo Spooler reiniciado com sucesso.
pause
goto impressoras_diagnostico

:limpar_e_reiniciar_spooler
echo Parando o Spooler de Impressao...
net stop spooler
echo Apagando arquivos da fila de impressao...
del /f /s /q "%SystemRoot%\System32\spool\PRINTERS\*.*"
echo Reiniciando o Spooler de Impressao...
net start spooler
echo Fila de impressao limpa e Spooler reiniciado com sucesso.
pause
goto impressoras_diagnostico

:compartilhar_impressora_flow
setlocal enabledelayedexpansion
cls
echo Tentando corrigir erro 0x00000709 antes de compartilhar...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
echo Correcao do erro 0x00000709 aplicada. Prosseguindo...
echo.

:listar_impressoras_numeradas
cls
echo ===========================================
echo   SELECIONAR IMPRESSORA PARA COMPARTILHAR
echo ===========================================
echo Impressoras disponiveis:
echo.
set "contador=0"
for /f "delims=" %%I in ('powershell -command "Get-Printer | Select-Object -ExpandProperty Name"') do (
    set /a contador+=1
    set "impressora_!contador!=%%I"
    echo !contador!. %%I
)
echo.
echo 0. Voltar
echo ===========================================
set /p "escolha=Escolha uma impressora pelo numero: "
if "!escolha!"=="0" (
    endlocal
    goto impressoras_diagnostico
)

set "nome_impressora_original=!impressora_%escolha%!"
if not defined nome_impressora_original (
    echo Escolha invalida.
    pause
    goto listar_impressoras_numeradas
)
echo Voce escolheu: "!nome_impressora_original!"
echo.

:renomear_menu
set /p "opcao_renomear=Deseja RENOMEAR esta impressora? (S/N): "
if /i "!opcao_renomear!"=="S" goto renomear_impressora_prompt
if /i "!opcao_renomear!"=="N" goto compartilhar_sem_renomear
echo Opcao invalida.
pause
goto renomear_menu

:renomear_impressora_prompt
cls
echo ===========================================
echo   RENOMEAR IMPRESSORA
echo ===========================================
echo Nome atual: !nome_impressora_original!
set /p "nome_impressora_novo=Digite o NOVO nome para a impressora: "

:renomear_sub_menu
cls
echo ===========================================
echo   CONFIRMAR NOVO NOME
echo ===========================================
echo Novo nome: !nome_impressora_novo!
echo.
echo 1 - Salvar e Compartilhar
echo 2 - Editar nome
echo 3 - Voltar para pergunta anterior (S/N)
echo 0 - Voltar para o menu principal
echo ===========================================
set /p "opcao_salvar=Escolha uma opcao: "

if "%opcao_salvar%"=="1" (
    powershell -Command "Rename-Printer -Name '!nome_impressora_original!' -NewName '!nome_impressora_novo!'"
    echo Impressora renomeada para '!nome_impressora_novo!'.
    set "nome_final_compartilhar=!nome_impressora_novo!"
    goto compartilhar_final
)
if "%opcao_salvar%"=="2" goto renomear_impressora_prompt
if "%opcao_salvar%"=="3" goto renomear_menu
if "%opcao_salvar%"=="0" (
    endlocal
    goto impressoras_diagnostico
)
echo Opcao invalida.
pause
goto renomear_sub_menu

:compartilhar_sem_renomear
set "nome_final_compartilhar=!nome_impressora_original!"
goto compartilhar_final

:compartilhar_final
powershell -Command "Set-Printer -Name '!nome_final_compartilhar!' -Shared:\$true -ShareName '!nome_final_compartilhar!'"
echo Impressora "!nome_final_compartilhar!" compartilhada com sucesso.
pause
endlocal
goto impressoras_diagnostico


rem --- SUBGRUPO: IMPRESSORAS/INSTALAÇÃO E ERROS COMUNS ---
:impressoras_erros_instalacao
cls
echo === IMPRESSORAS / INSTALACAO E CORRECAO DE ERROS ===
echo 1. Adicionar impressora de rede (Assistente do Windows)
echo 2. Instalar impressora / Abrir link de driver (OKI)
echo 3. Corrigir Erro 0x0000011b
echo 4. Corrigir Erro 0x00000bcb
echo 5. Corrigir Erro 0x00000709
echo B. Voltar para o menu anterior
echo ====================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto add_impressora
if "%opcao%"=="2" goto install_printer_oki
if "%opcao%"=="3" goto erro11b
if "%opcao%"=="4" goto erro0bcb
if "%opcao%"=="5" goto erro709
if /i "%opcao%"=="b" goto impressoras
echo Opcao invalida.
pause
goto impressoras_erros_instalacao

:add_impressora
echo Abrindo o assistente para adicionar impressora de rede...
RUNDLL32 PRINTUI.DLL,PrintUIEntry /in
echo Siga as instrucoes na tela para adicionar a impressora.
pause
goto impressoras_erros_instalacao

:install_printer_oki
cls
echo Abrindo pasta de instalacao da impressora OKI...
start \\brprt001
echo Selecione o driver ou instalador da impressora OKI conforme necessário.
pause
goto impressoras_erros_instalacao

:erro11b
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
echo Erro 0x0000011b corrigido.
pause
goto impressoras_erros_instalacao

:erro0bcb
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0 /f
echo Erro 0x00000bcb corrigido.
pause
goto impressoras_erros_instalacao

:erro709
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
echo Erro 0x00000709 corrigido.
pause
goto impressoras_erros_instalacao

rem --- SAIR DO SCRIPT ---
:sair
echo Obrigado por usar o utilizar a ferramenta de reparo!!
pause
endlocal
exit /b

:fim
