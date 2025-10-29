@echo off
rem ************************************************************
rem * Criado por: Alice Dzindzik                               *
rem * Modificado por: Jean Carlos De Jesus Barreto             *
rem * Unificado por: Gemini (Assistente de IA)                 *
rem * GitHub: AliceDzindzik                                    *
rem * GitHub: JCB212                                           *
rem * FERRAMENTA HELP TO DESK V 2.0 (UNIFICADA)                *
rem ************************************************************

rem Define o título da janela do prompt de comando
title FERRAMENTA HELP TO DESK V 2.0 (UNIFICADA)
color 0A
setlocal enabledelayed!expansion

rem Define o ponto de entrada principal do menu
:menu
cls
echo ==================================================
echo   FERRAMENTA HELP TO DESK V 2.0 (UNIFICADA)
echo   Criado por Alice Dzindzik e Jean Carlos
echo ==================================================
echo 1. Infraestrutura (Rede, Logs, Firewall)
echo 2. Sistema (Manutencao, Reparo, Diagnostico)
echo 3. Impressoras
echo 0. Reparo de Base de Dados Firebird  <-- NOVA OPÇÃO
echo 4. Sair
echo ==================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto infra
if "%opcao%"=="2" goto sistema
if "%opcao%"=="3" goto impressoras
if "%opcao%"=="0" goto reparo_firebird  <-- CHAMADA PARA O NOVO BLOCO
if "%opcao%"=="4" goto sair
echo Opcao invalida.
pause
goto menu

rem ************************************************************
rem * BLOCO DE REPARO FIREBIRD (INTEGRADO DO FIREBIRD.BAT.BAT) *
rem ************************************************************
:reparo_firebird
cls
echo ================================================================
echo   REPARO DE BASE FIREBIRD - SCRIPT SIMPLIFICADO [cite: 1]
echo ================================================================
echo.
:: ==============================
:: Solicita o caminho do Firebird
:: ==============================
set /p FIREBIRD_PATH=Digite o caminho da pasta BIN do Firebird (ex: C:\Program Files\Firebird\Firebird_2_5\bin): [cite: 2]
if not exist "%FIREBIRD_PATH%" (
    echo ERRO: Pasta nao encontrada.
    pause
    goto menu  :: Volta para o menu principal
)
echo Firebird localizado em: "%FIREBIRD_PATH%" [cite: 2]
echo.
:: ==============================
:: Solicita o caminho do banco
:: ==============================
set /p DB_PATH=Digite o caminho completo do banco (ex: C:\TSD\Host\HOST.FDB): [cite: 3]
if not exist "%DB_PATH%" (
    echo ERRO: Banco nao encontrado. [cite: 3]
    pause
    goto menu  :: Volta para o menu principal
)
echo Banco localizado em: "%DB_PATH%" [cite: 3]
echo.
:: ==============================
:: Define arquivos temporarios
:: ==============================
set BACKUP_FILE=%DB_PATH%.GBK [cite: 4]
set NEW_DB=%DB_PATH:.FDB=_NOVO.FDB% [cite: 4]
set USER=SYSDBA [cite: 4]
set PASS=masterkey [cite: 4]

echo ================================================================
echo INICIANDO PROCESSO DE REPARO [cite: 4]
echo ================================================================
echo.
:: ---------------------------------------------------
:: Etapa 1 - Verificação de integridade
:: ---------------------------------------------------
echo [1/4] Verificando integridade... [cite: 5]
"%FIREBIRD_PATH%\gfix" -v -full "%DB_PATH%" -user %USER% -pass %PASS% [cite: 5]
if errorlevel 1 (
    echo Erro na verificacao de integridade. [cite: 5]
    pause
    goto menu  :: Volta para o menu principal
)
echo OK. [cite: 5]
echo. [cite: 6]

:: ---------------------------------------------------
:: Etapa 2 - Tentando correção leve
:: ---------------------------------------------------
echo [2/4] Tentando correção com gfix -mend... [cite: 6]
"%FIREBIRD_PATH%\gfix" -mend "%DB_PATH%" -user %USER% -pass %PASS% [cite: 6]
if errorlevel 1 (
    echo Erro no reparo. [cite: 6]
    pause
    goto menu  :: Volta para o menu principal
)
echo OK. [cite: 6]
echo. [cite: 7]

:: ---------------------------------------------------
:: Etapa 3 - Backup com GBAK
:: ---------------------------------------------------
echo [3/4] Criando backup limpo... [cite: 7]
if exist "%BACKUP_FILE%" del "%BACKUP_FILE%" [cite: 7]
"%FIREBIRD_PATH%\gbak" -b -v -ignore -garbage -limbo "%DB_PATH%" "%BACKUP_FILE%" -user %USER% -pass %PASS% [cite: 7]
if errorlevel 1 (
    echo Erro ao gerar backup. [cite: 7]
    pause
    goto menu  :: Volta para o menu principal
)
echo Backup criado: %BACKUP_FILE% [cite: 7]
echo. [cite: 8]

:: ---------------------------------------------------
:: Etapa 4 - Restaurando base nova
:: ---------------------------------------------------
echo [4/4] Restaurando nova base de dados... [cite: 8]
if exist "%NEW_DB%" del "%NEW_DB%" [cite: 8]
"%FIREBIRD_PATH%\gbak" -c -v -z "%BACKUP_FILE%" "%NEW_DB%" -user %USER% -pass %PASS% [cite: 8]
if errorlevel 1 (
    echo Erro ao restaurar nova base. [cite: 8]
    pause
    goto menu  :: Volta para o menu principal
)
echo Nova base criada: %NEW_DB% [cite: 8]
echo. [cite: 9]
echo ================================================================ [cite: 9]
echo [SUCESSO] Processo de reparo concluído com êxito! [cite: 9]
echo Base original : %DB_PATH% [cite: 9]
echo Base reparada  : %NEW_DB% [cite: 9]
echo ================================================================ [cite: 9]
pause
goto menu  :: Volta para o menu principal

rem ************************************************************
rem * RESTANTE DO CÓDIGO DO MENUDOSUPORTE.BAT (MANUTENÇÃO)     *
rem ************************************************************

rem --- SEÇÃO DE INFRAESTRUTURA ---
:infra
cls
echo ================= INFRAESTRUTURA =================
echo 1. Verificar informacoes completas da rede
echo 2. Flush DNS
echo 3. Limpar cache DNS do navegador
echo 4. Ping Servidor
echo 5. Rastrear rota para servidor (Pathping)
echo 6. Testar conectividade de rede (Ping Google)
echo 7. Resetar configuracoes de rede
echo 8. Exibir conexoes de rede ativas (Netstat)
echo 9. Mapear unidade de rede
echo A. Abrir configuracoes do Firewall
echo B. Liberar porta 3050 (Firebird) no Firewall
echo C. Abrir Visualizador de Eventos
echo D. Ver adaptadores de rede
echo E. Voltar para o menu principal
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto ipall
if "%opcao%"=="2" goto flushdns
if "%opcao%"=="3" goto flush_navegador
if "%opcao%"=="4" goto pingserv
if "%opcao%"=="5" goto pathping_serv
if "%opcao%"=="6" goto ping_google
if "%opcao%"=="7" goto winsock_completo
if "%opcao%"=="8" goto netstat_info
if "%opcao%"=="9" goto mapear_rede
if /i "%opcao%"=="a" goto firewall_ui
if /i "%opcao%"=="b" goto firebird_port
if /i "%opcao%"=="c" goto eventlog
if /i "%opcao%"=="d" goto ncpa_cpl
if /i "%opcao%"=="e" goto menu
echo Opcao invalida. [cite: 15]
pause
goto infra

:ipall
rem Exibe todas as configuracoes de IP e pagina a saida
echo Exibindo informacoes de rede (pressione a barra de espaco para avancar)...
ipconfig /all | [cite: 16] more
pause
goto infra

:flushdns
rem Limpa o cache de DNS
echo Executando ipconfig /flushdns...
ipconfig /flushdns
echo Cache DNS limpo com sucesso!
pause [cite: 17]
goto infra

:flush_navegador
rem Limpa o cache DNS dos navegadores Chrome e Firefox.
echo Limpando cache do navegador... [cite: 18]
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
echo Cache do navegador limpo. [cite: 19]
pause
goto infra

:pingserv
rem Solicita o IP ou nome do servidor e executa um ping
set /p ipNome=Digite o nome ou IP do Servidor:
ping %ipNome%
pause
goto infra

:pathping_serv
rem Rastreia a rota e identifica gargalos na rede
set /p ipNome=Digite o nome ou IP do Servidor para rastrear a rota:
pathping %ipNome%
pause
goto infra

:ping_google
rem Teste de conectividade simples com o Google
echo Testando conexao com google.com...
ping google.com -n 4
echo Teste concluido! [cite: 20]
pause
goto infra

:winsock_completo
rem Reseta as configuracoes de Winsock e IP de forma completa
echo Resetando configuracoes de rede...
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
echo Eh necessario reiniciar o computador para que as alteracoes tenham efeito. [cite: 21]
pause
goto infra

:netstat_info
rem Exibe as conexoes de rede ativas e as portas abertas
echo Exibindo conexoes de rede ativas (pressione a barra de espaco para avancar)...
netstat -ano | [cite: 22] more
pause
goto infra

:mapear_rede
rem Mapeia ou desconecta uma unidade de rede
set /p "acao=Digite 'mapear' para mapear ou 'desconectar' para desconectar: " [cite: 23]
if /i "%acao%"=="mapear" goto mapear_rede_executar
if /i "%acao%"=="desconectar" goto desconectar_rede_executar
echo Opcao invalida. [cite: 23]
pause
goto infra

:mapear_rede_executar
set /p "letra=Digite a letra da unidade (ex: Z): "
set /p "caminho=Digite o caminho da pasta compartilhada (ex: \\servidor\pasta): "
net use %letra%: %caminho%
echo Unidade mapeada com sucesso! [cite: 24]
pause
goto infra

:desconectar_rede_executar
set /p "letra=Digite a letra da unidade para desconectar (ex: Z): " [cite: 25]
net use %letra%: /delete [cite: 25]
echo Unidade desconectada com sucesso! [cite: 25]
pause
goto infra

:firewall_ui
rem Abre a interface de configuracoes do Firewall
echo Abrindo configuracoes do Firewall do Windows...
firewall.cpl
pause
goto infra

:firebird_port
rem Libera a porta 3050 para o Firebird no Firewall do Windows
echo Adicionando regras de entrada e saida para a porta 3050 (Firebird)... [cite: 26]
netsh advfirewall firewall add rule name="Firebird_In" dir=in action=allow protocol=TCP localport=3050 [cite: 26]
netsh advfirewall firewall add rule name="Firebird_Out" dir=out action=allow protocol=TCP localport=3050 [cite: 26]
echo Regras do Firewall adicionadas com sucesso. [cite: 26]
pause
goto infra

:eventlog
rem Abre o Visualizador de Eventos
echo Abrindo Visualizador de Eventos...
eventvwr.msc
pause
goto infra

:ncpa_cpl
rem Abre a tela de adaptadores de rede
echo Abrindo adaptadores de rede...
start ncpa.cpl
pause
goto infra

rem --- SEÇÃO DE SISTEMA ---
:sistema
cls
echo ================== SISTEMA ==================
echo 1. Reiniciar Computador
echo 2. Lentidao e reparo (Limpeza + SFC + DISM)
echo 3. Verificar e Reparar Disco (CHKDSK)
echo 4. Exibir informacoes do sistema
echo 5. Exibir espaco em disco
echo 6. Desinstalar programa
echo 7. Gerenciar aplicativos com Winget
echo 8. Backup rapido do Registro
echo 9. Criar Ponto de Restauracao
echo A. Limpeza de arquivos temporarios
echo B. Reset do Windows Update
echo C. Limpeza de logs de eventos
echo D. Ver status dos principais servicos [cite: 27]
echo E. Backup dos logs de eventos
echo F. Visualizar dispositivos USB conectados
echo G. Abertura de chamado
echo H. Testar velocidade da internet
echo I. Verificar status do antivirus
echo J. Abrir Restauracao do Sistema
echo K. Abrir Gerenciamento de Disco
echo L. Abrir Gerenciador de Dispositivos
echo M. Abrir Gerenciador de Programas
echo N. Abrir Diagnostico de Memoria
echo O. Desfragmentar Disco
echo P. Gerenciar Usuarios Locais [cite: 29]
echo Q. Atualizar Group Policy
echo R. Testar velocidade de disco
echo S. Fazer backup de drivers
echo T. Abrir Gerenciador de Tarefas
echo U. Executar Comando Personalizado
echo V. Liberar acesso a compartilhamentos (SMB)
echo W. Compartilhamento avancado de pasta na rede
echo X. Verificar Atualizacoes do Windows
echo Y. Voltar para o menu principal [cite: 28]
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto reiniciar
if "%opcao%"=="2" goto lentidao_completa
if "%opcao%"=="3" goto chkdsk_opcoes
if "%opcao%"=="4" goto sysinfo
if "%opcao%"=="5" goto espaco_disco
if "%opcao%"=="6" goto desinstalar_programa
if "%opcao%"=="7" goto winget_menu
if "%opcao%"=="8" goto backup_registro
if "%opcao%"=="9" goto restorepoint
if /i "%opcao%"=="a" goto limpeza_temp
if /i "%opcao%"=="b" goto update_reset
if /i "%opcao%"=="c" goto limpar_logs
if /i "%opcao%"=="d" goto servicos_status
if /i "%opcao%"=="e" goto backup_logs_eventos
if /i "%opcao%"=="f" goto usb_check
if /i "%opcao%"=="g" goto abrir_chamado
if /i "%opcao%"=="h" goto testar_velocidade
if /i "%opcao%"=="i" goto antivirus_status
if /i "%opcao%"=="j" goto restore_ui
if /i "%opcao%"=="k" goto diskmgmt
if /i "%opcao%"=="l" goto devmgmt_cpl
if /i "%opcao%"=="m" goto appwiz_cpl
if /i "%opcao%"=="n" goto memory_diag
if /i "%opcao%"=="o" goto defrag_opcoes
if /i "%opcao%"=="p" goto usermgmt [cite: 29]
if /i "%opcao%"=="q" goto updateGp
if /i "%opcao%"=="r" goto disktest
if /i "%opcao%"=="s" goto driverbackup
if /i "%opcao%"=="t" goto taskmgr
if /i "%opcao%"=="u" goto customcmd
if /i "%opcao%"=="v" goto compartilhamento
if /i "%opcao%"=="w" goto compartilhar_avancado
if /i "%opcao%"=="x" goto windows_updates
if /i "%opcao%"=="y" goto menu
echo Opcao invalida. [cite: 30]
pause
goto sistema

:reiniciar
rem Desliga e reinicia o computador
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
echo Limpeza concluida! [cite: 31]
pause

echo Etapa 2: Executando SFC...
sfc /scannow
pause

echo Etapa 3: Verificando integridade da imagem do Windows (DISM)...
dism /online /cleanup-image /restorehealth
pause
goto sistema

:escolher_drive
rem Funcao para permitir que o usuario escolha a unidade
set /p "drive=Digite a letra da unidade (ex: C): "
set "drive=%drive::=%"
if not exist "%drive%:" (
    echo Unidade "%drive%" nao encontrada. Tente novamente.
    goto escolher_drive
)
goto %1

:chkdsk_opcoes
cls
rem Verificacao de disco
echo Executando verificacao e reparo de disco...
call :escolher_drive chkdsk_executar
pause
goto sistema

:chkdsk_executar
echo Isso pode levar algum tempo. Por favor, aguarde. [cite: 32]
chkdsk %drive%: /f /r
echo Verificacao concluida!
pause
goto sistema

:sysinfo
cls
rem Exibe informacoes detalhadas do sistema
echo Exibindo informacoes do sistema (pressione a barra de espaco para avancar)...
systeminfo | [cite: 33] more
pause
goto sistema

:espaco_disco
rem Exibe o espaco livre e total em disco
echo Espaco em disco:
wmic logicaldisk get deviceid,volumename,size,freespace
pause
goto sistema

:desinstalar_programa
rem Lista os programas e desinstala o selecionado usando PowerShell
echo Listando programas instalados (pode levar alguns segundos)...
powershell -command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,Publisher,InstallDate | Format-Table -AutoSize"
set /p "nome_programa=Digite o nome EXATO do programa para desinstalar: "
wmic product where name="%nome_programa%" call uninstall /nointeractive
pause
goto sistema

:winget_menu
cls
echo ==================================================
echo   GERENCIADOR DE APLICATIVOS COM WINGET
echo ==================================================
echo 1. Listar aplicativos instalados
echo 2. Procurar por um aplicativo
echo 3. Instalar um aplicativo
echo 4. Atualizar todos os aplicativos
echo 5. Desinstalar um aplicativo
echo 6. Voltar
echo ==================================================
set /p "opcao=Escolha uma opcao: "
if "%opcao%"=="1" goto wingetlist [cite: 34]
if "%opcao%"=="2" goto wingetsearch
if "%opcao%"=="3" goto wingetinstall
if "%opcao%"=="4" goto wingetupgrade
if "%opcao%"=="5" goto wingetuninstall
if "%opcao%"=="6" goto sistema
echo Opcao invalida. [cite: 35]
pause
goto winget_menu

:wingetlist
winget list | more
pause
goto winget_menu

:wingetsearch
set /p "appsearch=Digite o nome do aplicativo para procurar: "
winget search "%appsearch%" | [cite: 36] more
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

:backup_registro
rem Realiza um backup rapido do registro
set "backupPath=%USERPROFILE%\Desktop\Backup_Registro_%date:~-4,4%%date:~-7,2%%date:~-10,2%_%time:~0,2%%time:~3,2%%time:~6,2%.reg"
reg export "HKLM\SYSTEM\CurrentControlSet" "%backupPath%" /y
echo Backup do registro salvo em: %backupPath%
pause
goto sistema

:restorepoint
cls
rem Cria um ponto de restauracao
echo Criando ponto de restauracao...
wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "Ponto de Restauracao - Script TI", 100, 7
echo Ponto de restauracao criado com sucesso! [cite: 37]
pause
goto sistema

:limpeza_temp
rem Limpa arquivos temporarios
cls
echo Limpando arquivos temporarios...
del /s /f /q "%TEMP%\*"
del /s /f /q "C:\Windows\Temp\*"
echo Concluido. [cite: 38]
pause
goto sistema

:update_reset
rem Reseta os componentes do Windows Update
cls
echo Resetando componentes do Windows Update... [cite: 39]
net stop wuauserv [cite: 39]
net stop cryptSvc [cite: 39]
net stop bits [cite: 39]
net stop msiserver [cite: 39]
ren C:\Windows\SoftwareDistribution SoftwareDistribution.old [cite: 39]
ren C:\Windows\System32\catroot2 catroot2.old [cite: 39]
net start wuauserv [cite: 39]
net start cryptSvc [cite: 39]
net start bits [cite: 39]
net start msiserver [cite: 39]
echo Concluido. [cite: 39]
pause
goto sistema

:limpar_logs
rem Limpa todos os logs de eventos
cls
echo Limpando logs de eventos...
for /F "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1" [cite: 40]
echo Concluido. [cite: 40]
pause
goto sistema

:servicos_status
rem Verifica o status dos servicos principais
cls
echo Verificando status de servicos principais...
sc query wuauserv
sc query bits
sc query dhcp
sc query dnscache
sc query nlasvc
sc query netprofm
pause
goto sistema

:backup_logs_eventos
rem Cria backup dos logs de eventos
cls
echo Criando backup dos logs de eventos...
mkdir C:\BackupLogs
wevtutil epl Application C:\BackupLogs\Application.evtx
wevtutil epl System C:\BackupLogs\System.evtx
echo Backup concluido em C:\BackupLogs
pause
goto sistema

:usb_check
rem Verifica dispositivos USB conectados
@echo off
cls
echo Verificando dispositivos USB conectados...
REM Verifica se há dispositivos USB conectados
wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description | [cite: 41] findstr /i "USB" >nul
if %errorlevel%==0 (
    echo Dispositivos USB conectados:
    wmic path CIM_LogicalDevice where "Description like 'USB%'" get Name, Description
) else (
    echo Nenhum dispositivo USB encontrado.
)
pause
goto sistema

:abrir_chamado
rem Abre o link para a pagina de abertura de chamado
start https://dufryprod.service-now.com/dufry_sp?id=sub_ticket
echo Abrindo pagina de abertura de chamado. [cite: 42]
pause
goto sistema

:testar_velocidade
rem Abre o site para teste de velocidade
start https://www.fast.com
echo Abrindo site de teste de velocidade. [cite: 43]
pause
goto sistema

:antivirus_status
rem Verifica o status do Windows Defender
cls
echo Verificando status do Windows Defender...
powershell -command "Get-MpComputerStatus | Select AMServiceEnabled,AntivirusEnabled,RealTimeProtectionEnabled"
pause
goto sistema

:restore_ui
rem Abre a interface de Restauracao do Sistema
echo Abrindo Restauracao do Sistema...
rstrui.exe
pause
goto sistema

:diskmgmt
rem Abre a ferramenta de Gerenciamento de Disco
echo Abrindo Gerenciamento de Disco...
diskmgmt.msc
pause
goto sistema

:devmgmt_cpl
rem Abre o Gerenciador de Dispositivos
echo Abrindo Gerenciador de Dispositivos...
start devmgmt.msc
pause
goto sistema

:appwiz_cpl
rem Abre a tela de programas instalados
echo Abrindo lista de programas instalados...
start appwiz.cpl
pause
goto sistema

:memory_diag
rem Abre o Diagnostico de Memoria
echo Abrindo Diagnostico de Memoria do Windows...
mdsched.exe
pause
goto sistema

:defrag_opcoes
cls
rem Executa a desfragmentacao de disco
echo Executando desfragmentacao de disco...
call :escolher_drive defrag_executar
pause
goto sistema

:defrag_executar
echo Isso pode levar algum tempo. Por favor, aguarde. [cite: 44]
defrag %drive%: /O
echo Desfragmentacao concluida!
pause
goto sistema

:usermgmt
rem Abre o Gerenciador de Usuarios Locais
echo Abrindo Gerenciamento de Usuarios Locais...
lusrmgr.msc
pause
goto sistema

:updateGp 
rem Forca a atualizacao da Politica de Grupo
echo Atualizando Politica de Grupo...
gpupdate /force
pause
goto sistema

:disktest
rem Testa a velocidade do disco C
echo Testando velocidade de disco...
winsat disk -drive C
pause
goto sistema

:driverbackup
cls
rem Backup de drivers
echo Realizando backup de drivers...
echo Isso pode levar algum tempo. Por favor, aguarde. [cite: 45]
mkdir C:\DriverBackup
dism /online /export-driver /destination:C:\DriverBackup
echo Backup de drivers concluido! [cite: 46] Salvo em C:\DriverBackup [cite: 46]
pause
goto sistema

:taskmgr
rem Abre o Gerenciador de Tarefas
echo Abrindo Gerenciador de Tarefas...
taskmgr.exe
pause
goto sistema

:customcmd
rem Abre um prompt de comando
cls
echo Abrindo prompt de comando para comandos personalizados...
cmd.exe
echo Retornando ao menu. [cite: 47]
pause
goto sistema

:compartilhamento
rem Executa comandos PowerShell para liberar acesso a compartilhamentos
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Confirm:$false"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Confirm:$false"
echo Acesso a compartilhamentos liberado. [cite: 48]
pause
goto sistema

:compartilhar_avancado
rem Comando para compartilhar uma pasta na rede com permissao total para 'Todos'
set /p "pasta=Digite o caminho COMPLETO da pasta que deseja compartilhar (ex: C:\dados): "
set /p "nome_compartilhamento=Digite o NOME do compartilhamento: "
net share "%nome_compartilhamento%"="%pasta%" /GRANT:Everyone,FULL
echo A pasta '%pasta%' foi compartilhada como '%nome_compartilhamento%' com acesso total para 'Todos'. [cite: 49]
pause
goto sistema

:windows_updates
rem Abre a pagina de configuracoes do Windows Update
start ms-settings:windowsupdate
echo Abrindo configuracoes do Windows Update. [cite: 50]
pause
goto sistema

rem --- SEÇÃO DE IMPRESSORAS ---
:impressoras
cls
echo =============== IMPRESSORAS ===============
echo 1. Listar Impressoras Instaladas
echo 2. Compartilhar/Renomear Impressora na Rede
echo 3. Adicionar impressora de rede
echo 4. Corrigir Erro 0x0000011b
echo 5. Corrigir Erro 0x00000bcb
echo 6. Corrigir Erro 0x00000709
echo 7. Reiniciar Spooler de Impressao
echo 8. Limpar Fila de Impressao e Reiniciar Spooler
echo 9. Instalar impressora / Abrir link de driver
echo A. Voltar para o menu principal [cite: 51]
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto listar_impressoras
if "%opcao%"=="2" goto compartilhar_impressora_flow
if "%opcao%"=="3" goto add_impressora
if "%opcao%"=="4" goto erro11b
if "%opcao%"=="5" goto erro0bcb
if "%opcao%"=="6" goto erro709 
if "%opcao%"=="7" goto reiniciar_spooler
if "%opcao%"=="8" goto limpar_e_reiniciar_spooler
if "%opcao%"=="9" goto install_printer_oki
if /i "%opcao%"=="a" goto menu [cite: 51]
echo Opcao invalida.
pause
goto impressoras

:compartilhar_impressora_flow
rem Fluxo completo para compartilhar impressora, evitando o erro 0x00000709
setlocal enabledelayedexpansion
cls
echo Tentando corrigir erro 0x00000709 antes de compartilhar...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
echo Correcao do erro 0x00000709 aplicada. [cite: 52] Prosseguindo... [cite: 52]
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
echo 0. Voltar [cite: 54]
echo ===========================================
set /p "escolha=Escolha uma impressora pelo numero: "
if "!escolha!"=="0" (
    endlocal
    goto impressoras
)

set "nome_impressora_original=!impressora_%escolha%!"
if not defined nome_impressora_original ( [cite: 55]
    echo Escolha invalida. [cite: 55]
    pause
    goto listar_impressoras_numeradas
)
echo Voce escolheu: "!nome_impressora_original!" [cite: 56]
echo.

:renomear_menu
set /p "opcao_renomear=Deseja RENOMEAR esta impressora? (S/N): " [cite: 57]
if /i "!opcao_renomear!"=="S" goto renomear_impressora_prompt
if /i "!opcao_renomear!"=="N" goto compartilhar_sem_renomear
echo Opcao invalida. [cite: 57]
pause
goto renomear_menu

:renomear_impressora_prompt
cls
echo ===========================================
echo   RENOMEAR IMPRESSORA
echo ===========================================
echo Nome atual: !nome_impressora_original! [cite: 58]
set /p "nome_impressora_novo=Digite o NOVO nome para a impressora: " [cite: 58]

:renomear_sub_menu
cls
echo ===========================================
echo   CONFIRMAR NOVO NOME
echo ===========================================
echo Novo nome: !nome_impressora_novo! [cite: 59]
echo. [cite: 59]
echo 1 - Salvar e Compartilhar
echo 2 - Editar nome
echo 3 - Voltar para pergunta anterior (S/N)
echo 0 - Voltar para o menu principal
echo ===========================================
set /p "opcao_salvar=Escolha uma opcao: "

if "%opcao_salvar%"=="1" (
    powershell -Command "Rename-Printer -Name '%nome_impressora_original%' -NewName '%nome_impressora_novo%'"
    echo Impressora renomeada para '%nome_impressora_novo%'.
    set "nome_final_compartilhar=!nome_impressora_novo!"
    goto compartilhar_final
)
if "%opcao_salvar%"=="2" goto renomear_impressora_prompt
if "%opcao_salvar%"=="3" goto renomear_menu
if "%opcao_salvar%"=="0" (
    endlocal
    goto impressoras
)
echo Opcao invalida. [cite: 60]
pause
goto renomear_sub_menu

:compartilhar_sem_renomear
set "nome_final_compartilhar=!nome_impressora_original!"
goto compartilhar_final

:compartilhar_final
powershell -Command "Set-Printer -Name '%nome_final_compartilhar%' -Shared:$true -ShareName '%nome_final_compartilhar%'"
echo Impressora "%nome_final_compartilhar%" compartilhada com sucesso. [cite: 61]
pause
endlocal
goto impressoras

:listar_impressoras
rem Lista todas as impressoras instaladas usando PowerShell
echo Impressoras Instaladas:
powershell -command "Get-Printer | Format-Table Name,PortName,DriverName -AutoSize" | [cite: 62] more
pause
goto impressoras

:add_impressora
rem Abre o assistente para adicionar uma impressora de rede
echo Abrindo o assistente para adicionar impressora de rede...
RUNDLL32 PRINTUI.DLL,PrintUIEntry /in
echo Siga as instrucoes na tela para adicionar a impressora. [cite: 63]
pause
goto impressoras

:install_printer_oki
rem Abre o caminho de rede para os drivers da impressora OKI
cls
echo Abrindo pasta de instalacao da impressora OKI...
start \\brprt001
echo Selecione o driver ou instalador da impressora OKI conforme necessário. [cite: 64]
pause
goto impressoras

:erro11b
rem Adiciona uma chave no registro para corrigir o erro 0x0000011b
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
echo Erro 0x0000011b corrigido. [cite: 65]
pause
goto impressoras

:erro0bcb
rem Adiciona uma chave no registro para corrigir o erro 0x00000bcb
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0 /f
echo Erro 0x00000bcb corrigido. [cite: 66]
pause
goto impressoras

:erro709
rem Adiciona uma chave no registro para corrigir o erro 0x00000709
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
echo Erro 0x00000709 corrigido. [cite: 67]
pause
goto impressoras

:reiniciar_spooler
rem Para, espera 3 segundos e reinicia o servico Spooler de Impressao
net stop spooler
timeout /t 3 >nul
net start spooler
echo Spooler reiniciado com sucesso. [cite: 68]
pause
goto impressoras

:limpar_e_reiniciar_spooler
rem Para o spooler, apaga todos os arquivos da fila e reinicia o servico
echo Parando o Spooler de Impressao... [cite: 69]
net stop spooler [cite: 69]
echo Apagando arquivos da fila de impressao... [cite: 69]
del /f /s /q "%SystemRoot%\System32\spool\PRINTERS\*.*" [cite: 69]
echo Reiniciando o Spooler de Impressao... [cite: 69]
net start spooler [cite: 69]
echo Fila de impressao limpa e Spooler reiniciado com sucesso. [cite: 69]
pause
goto impressoras

rem --- SAIR DO SCRIPT ---
:sair
rem Apenas finaliza o script
echo Obrigado por usar o utilizar a ferramenta de reparo!! [cite: 70]
pause
exit

:fim
