@echo off
rem ************************************************************
rem * Criado por: Jean Carlos De Jesus Barreto      *
rem * GitHub: JCB212                                *
rem * FERRAMENTA HELP TO DESK V 0.8                 *
rem ************************************************************

rem Define o título da janela do prompt de comando
title FERRAMENTA HELP TO DESK V 0.8
color 0A

rem Define o ponto de entrada principal do menu
:menu
cls
echo ==================================================
echo   FERRAMENTA HELP TO DESK V 0.8
echo   Criado por Jean Carlos De Jesus Barreto
echo ==================================================
echo 1. Infraestrutura (Rede, Logs, Firewall)
echo 2. Sistema (Manutencao, Reparo, Diagnostico)
echo 3. Impressoras
echo 4. Sair
echo ==================================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto infra
if "%opcao%"=="2" goto sistema
if "%opcao%"=="3" goto impressoras
if "%opcao%"=="4" goto sair
echo Opcao invalida.
pause
goto menu

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
echo D. Voltar para o menu principal
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
if /i "%opcao%"=="d" goto menu
echo Opcao invalida.
pause
goto infra

:ipall
rem Exibe todas as configuracoes de IP e pagina a saida
echo Exibindo informacoes de rede (pressione a barra de espaco para avancar)...
ipconfig /all | more
pause
goto infra

:flushdns
rem Limpa o cache de DNS
echo Executando ipconfig /flushdns...
ipconfig /flushdns
echo Cache DNS limpo com sucesso!
pause
goto infra

:flush_navegador
rem Limpa o cache DNS dos navegadores Chrome e Firefox.
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
echo Teste concluido!
pause
goto infra

:winsock_completo
rem Reseta as configuracoes de Winsock e IP de forma completa
echo Resetando configuracoes de rede...
netsh winsock reset
netsh int ip reset
ipconfig /release
ipconfig /renew
echo Eh necessario reiniciar o computador para que as alteracoes tenham efeito.
pause
goto infra

:netstat_info
rem Exibe as conexoes de rede ativas e as portas abertas
echo Exibindo conexoes de rede ativas (pressione a barra de espaco para avancar)...
netstat -ano | more
pause
goto infra

:mapear_rede
rem Mapeia ou desconecta uma unidade de rede
set /p "acao=Digite 'mapear' para mapear ou 'desconectar' para desconectar: "
if /i "%acao%"=="mapear" goto mapear_rede_executar
if /i "%acao%"=="desconectar" goto desconectar_rede_executar
echo Opcao invalida.
pause
goto infra

:mapear_rede_executar
set /p "letra=Digite a letra da unidade (ex: Z): "
set /p "caminho=Digite o caminho da pasta compartilhada (ex: \\servidor\pasta): "
net use %letra%: %caminho%
echo Unidade mapeada com sucesso!
pause
goto infra

:desconectar_rede_executar
set /p "letra=Digite a letra da unidade para desconectar (ex: Z): "
net use %letra%: /delete
echo Unidade desconectada com sucesso!
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
echo Adicionando regras de entrada e saida para a porta 3050 (Firebird)...
netsh advfirewall firewall add rule name="Firebird_In" dir=in action=allow protocol=TCP localport=3050
netsh advfirewall firewall add rule name="Firebird_Out" dir=out action=allow protocol=TCP localport=3050
echo Regras do Firewall adicionadas com sucesso.
pause
goto infra

:eventlog
rem Abre o Visualizador de Eventos
echo Abrindo Visualizador de Eventos...
eventvwr.msc
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
echo A. Abrir Restauracao do Sistema
echo B. Abrir Gerenciamento de Disco
echo C. Abrir Diagnostico de Memoria
echo D. Desfragmentar Disco
echo E. Gerenciar Usuarios Locais
echo F. Atualizar Group Policy
echo G. Testar velocidade de disco
echo H. Fazer backup de drivers
echo I. Abrir Gerenciador de Tarefas
echo J. Executar Comando Personalizado
echo K. Liberar acesso a compartilhamentos (SMB)
echo L. Compartilhamento avancado de pasta na rede
echo M. Verificar Atualizacoes do Windows
echo N. Verificar virus com Windows Defender
echo O. Voltar para o menu principal
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
if /i "%opcao%"=="a" goto restore_ui
if /i "%opcao%"=="b" goto diskmgmt
if /i "%opcao%"=="c" goto memory_diag
if /i "%opcao%"=="d" goto defrag_opcoes
if /i "%opcao%"=="e" goto usermgmt
if /i "%opcao%"=="f" goto updateGp
if /i "%opcao%"=="g" goto disktest
if /i "%opcao%"=="h" goto driverbackup
if /i "%opcao%"=="i" goto taskmgr
if /i "%opcao%"=="j" goto customcmd
if /i "%opcao%"=="k" goto compartilhamento
if /i "%opcao%"=="l" goto compartilhar_avancado
if /i "%opcao%"=="m" goto windows_updates
if /i "%opcao%"=="n" goto defender_scan
if /i "%opcao%"=="o" goto menu
echo Opcao invalida.
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
echo Limpeza concluida!
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
echo Isso pode levar algum tempo. Por favor, aguarde.
chkdsk %drive%: /f /r
echo Verificacao concluida!
pause
goto sistema

:sysinfo
cls
rem Exibe informacoes detalhadas do sistema
echo Exibindo informacoes do sistema (pressione a barra de espaco para avancar)...
systeminfo | more
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
powershell -command "Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,Publisher,InstallDate | Format-Table –AutoSize"
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
if "%opcao%"=="1" goto wingetlist
if "%opcao%"=="2" goto wingetsearch
if "%opcao%"=="3" goto wingetinstall
if "%opcao%"=="4" goto wingetupgrade
if "%opcao%"=="5" goto wingetuninstall
if "%opcao%"=="6" goto sistema
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
echo Ponto de restauracao criado com sucesso!
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
echo Isso pode levar algum tempo. Por favor, aguarde.
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
echo Isso pode levar algum tempo. Por favor, aguarde.
mkdir C:\DriverBackup
dism /online /export-driver /destination:C:\DriverBackup
echo Backup de drivers concluido! Salvo em C:\DriverBackup
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
echo Retornando ao menu.
pause
goto sistema

:compartilhamento
rem Executa comandos PowerShell para liberar acesso a compartilhamentos
powershell -Command "Set-SmbClientConfiguration -RequireSecuritySignature $false -Confirm:$false"
powershell -Command "Set-SmbClientConfiguration -EnableInsecureGuestLogons $true -Confirm:$false"
echo Acesso a compartilhamentos liberado.
pause
goto sistema

:compartilhar_avancado
rem Comando para compartilhar uma pasta na rede com permissao total para 'Todos'
set /p "pasta=Digite o caminho COMPLETO da pasta que deseja compartilhar (ex: C:\dados): "
set /p "nome_compartilhamento=Digite o NOME do compartilhamento: "
net share "%nome_compartilhamento%"="%pasta%" /GRANT:Everyone,FULL
echo A pasta '%pasta%' foi compartilhada como '%nome_compartilhamento%' com acesso total para 'Todos'.
pause
goto sistema

:windows_updates
rem Abre a pagina de configuracoes do Windows Update
start ms-settings:windowsupdate
echo Abrindo configuracoes do Windows Update.
pause
goto sistema

:defender_scan
rem Executa um scan rapido com o Windows Defender via PowerShell
powershell -command "Start-MpScan -ScanType QuickScan"
echo Verificacao rapida do Windows Defender iniciada.
pause
goto sistema

rem --- SEÇÃO DE IMPRESSORAS ---
:impressoras
cls
echo =============== IMPRESSORAS ===============
echo 1. Listar Impressoras Instaladas
echo 2. Compartilhar Impressora na Rede
echo 3. Adicionar impressora de rede
echo 4. Corrigir Erro 0x0000011b
echo 5. Corrigir Erro 0x00000bcb
echo 6. Corrigir Erro 0x00000709
echo 7. Reiniciar Spooler de Impressao
echo 8. Limpar Fila de Impressao e Reiniciar Spooler
echo 9. Voltar para o menu principal
echo ===========================================
set /p "opcao=Escolha uma opcao: "

if "%opcao%"=="1" goto listar_impressoras
if "%opcao%"=="2" goto compartilhar_impressora
if "%opcao%"=="3" goto add_impressora
if "%opcao%"=="4" goto erro11b
if "%opcao%"=="5" goto erro0bcb
if "%opcao%"=="6" goto erro709 
if "%opcao%"=="7" goto reiniciar_spooler
if "%opcao%"=="8" goto limpar_e_reiniciar_spooler
if "%opcao%"=="9" goto menu
echo Opcao invalida.
pause
goto impressoras

:listar_impressoras
rem Lista todas as impressoras instaladas usando PowerShell
echo Impressoras Instaladas:
powershell -command "Get-Printer | Format-Table Name,PortName,DriverName -AutoSize" | more
pause
goto impressoras

:compartilhar_impressora
rem Lista as impressoras para o usuario escolher
echo Impressoras disponiveis para compartilhamento:
powershell -command "Get-Printer | Format-Table Name -AutoSize" | more
set /p "nomeImpressora=Digite o NOME da impressora que deseja compartilhar: "
rem Adiciona o comando para compartilhar a impressora
powershell -Command "Set-Printer -Name '%nomeImpressora%' -Shared:$true -ShareName '%nomeImpressora%'"
echo Impressora "%nomeImpressora%" compartilhada com sucesso.
pause
goto impressoras

:add_impressora
rem Abre o assistente para adicionar uma impressora de rede
echo Abrindo o assistente para adicionar impressora de rede...
RUNDLL32 PRINTUI.DLL,PrintUIEntry /in
echo Siga as instrucoes na tela para adicionar a impressora.
pause
goto impressoras

:erro11b
rem Adiciona uma chave no registro para corrigir o erro 0x0000011b
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
echo Erro 0x0000011b corrigido.
pause
goto impressoras

:erro0bcb
rem Adiciona uma chave no registro para corrigir o erro 0x00000bcb
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\PointAndPrint" /v RestrictDriverInstallationToAdministrators /t REG_DWORD /d 0 /f
echo Erro 0x00000bcb corrigido.
pause
goto impressoras

:erro709
rem Adiciona uma chave no registro para corrigir o erro 0x00000709
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Printers\RPC" /v RpcUseNamedPipeProtocol /t REG_DWORD /d 1 /f
echo Erro 0x00000709 corrigido.
pause
goto impressoras

:reiniciar_spooler
rem Para, espera 3 segundos e reinicia o servico Spooler de Impressao
net stop spooler
timeout /t 3 >nul
net start spooler
echo Spooler reiniciado com sucesso.
pause
goto impressoras

:limpar_e_reiniciar_spooler
rem Para o spooler, apaga todos os arquivos da fila e reinicia o servico
echo Parando o Spooler de Impressao...
net stop spooler
echo Apagando arquivos da fila de impressao...
del /f /s /q "%SystemRoot%\System32\spool\PRINTERS\*.*"
echo Reiniciando o Spooler de Impressao...
net start spooler
echo Fila de impressao limpa e Spooler reiniciado com sucesso.
pause
goto impressoras

rem --- SAIR DO SCRIPT ---
:sair
rem Apenas finaliza o script
echo Obrigado por usar o utilizar a ferramenta de reparo!!
pause
exit

:fim
