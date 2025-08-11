@echo off
rem Define o título da janela do prompt de comando
title MENU DO SUPORTE TECNICO INFOATIVA

rem Define o ponto de entrada principal do menu
:menu
cls
rem Exibe o menu principal com as opções
echo ========= MENU DO SUPORTE TECNICO =========
echo 0 - Sair
echo 1 - Rede 
echo 2 - Impressoras 
echo 3 - Sistema 
echo ===========================================
rem Solicita que o usuário escolha uma opção
set /p opcao=Escolha uma opcao: 

rem Verifica a opção escolhida e redireciona para a seção correspondente
if "%opcao%"=="0" goto sair
if "%opcao%"=="1" goto rede 
if "%opcao%"=="2" goto impressoras
if "%opcao%"=="3" goto sistema

rem Se a opção for inválida, exibe uma mensagem de erro e retorna ao menu
echo Opcao invalida.
pause
goto menu

rem --- SEÇÃO DE REDE ---
:rede
cls
echo ================== REDE ==================
echo 0 - Voltar para o menu inicial
echo 1 - Verificar informacoes completas da rede
echo 2 - Flush DNS
echo 3 - Ping Servidor
echo 4 - Resetar configuracoes de rede (Winsock)
echo 5 - Rotas de rede
echo ===========================================
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="0" goto menu
if "%opcao%"=="1" goto ipall
if "%opcao%"=="2" goto flushdns
if "%opcao%"=="3" goto pingserv 
if "%opcao%"=="4" goto winsock 
if "%opcao%"=="5" goto rotas

echo Opcao invalida.
pause
goto menu

:ipall
rem Exibe todas as configurações de IP
ipconfig /all
pause
goto menu

:flushdns
rem Limpa o cache de DNS
ipconfig /flushdns
pause
goto menu

:pingserv
rem Solicita o IP ou nome do servidor e executa um ping
set /p ipNome=Digite o nome ou IP do Servidor:
ping %ipNome%
pause
goto menu

:winsock
rem Reseta as configurações de Winsock e IP
netsh winsock reset
netsh int ip reset
echo É necessário reiniciar o computador.
pause
goto menu

:rotas
rem Exibe a tabela de roteamento de rede
route print
pause
goto menu

rem --- SEÇÃO DE IMPRESSORAS (ATUALIZADA) ---
:impressoras
cls
echo =============== IMPRESSORAS ===============
echo 0 - Voltar para o menu inicial
echo 1 - Listar Impressoras Instaladas
echo 2 - Compartilhar Impressora na Rede
echo 3 - Corrigir Erro 0x0000011b
echo 4 - Corrigir Erro 0x00000bcb
echo 5 - Corrigir Erro 0x00000709
echo 6 - Reiniciar Spooler de Impressao
echo 7 - Limpar Fila de Impressao e Reiniciar Spooler
echo ===========================================
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="0" goto menu
if "%opcao%"=="1" goto listar_impressoras
if "%opcao%"=="2" goto compartilhar_impressora
if "%opcao%"=="3" goto erro11b
if "%opcao%"=="4" goto erro0bcb
if "%opcao%"=="5" goto erro709 
if "%opcao%"=="6" goto reiniciar_spooler
if "%opcao%"=="7" goto limpar_e_reiniciar_spooler

echo Opcao invalida.
pause
goto impressoras

:listar_impressoras
rem Lista todas as impressoras instaladas usando PowerShell para uma saída mais limpa
echo Impressoras Instaladas:
powershell -command "Get-Printer | Format-Table Name,PortName,DriverName -AutoSize"
pause
goto impressoras

:compartilhar_impressora
rem Lista as impressoras para que o usuário possa escolher
echo Impressoras disponiveis para compartilhamento:
powershell -command "Get-Printer | Format-Table Name -AutoSize"
set /p nomeImpressora=Digite o NOME da impressora que deseja compartilhar: 
rem Adiciona o comando para compartilhar a impressora
powershell -Command "Set-Printer -Name '%nomeImpressora%' -Shared:$true -ShareName '%nomeImpressora%'"
echo Impressora "%nomeImpressora%" compartilhada com sucesso.
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
rem Para, espera 3 segundos e reinicia o serviço Spooler de Impressão
net stop spooler
timeout /t 3 >nul
net start spooler
echo Spooler reiniciado com sucesso.
pause
goto impressoras

:limpar_e_reiniciar_spooler
rem Para o spooler, apaga todos os arquivos da fila e reinicia o serviço
echo Parando o Spooler de Impressao...
net stop spooler
echo Apagando arquivos da fila de impressao...
del /f /s /q "%SystemRoot%\System32\spool\PRINTERS\*.*"
echo Reiniciando o Spooler de Impressao...
net start spooler
echo Fila de impressao limpa e Spooler reiniciado com sucesso.
pause
goto impressoras

rem --- SEÇÃO DE SISTEMA (ATUALIZADA) ---
:sistema
cls
echo ================= SISTEMA =================
echo 0 - Voltar para o menu inicial
echo 1 - Reiniciar Computador
echo 2 - Lentidao (Limpar temp, Prefetch, etc)
echo 3 - Atualizar Group Policy
echo 4 - Processos com maior uso de CPU
echo 5 - Liberar acesso a compartilhamentos (SMB)
echo 6 - Compartilhamento avancado de pasta na rede
echo 7 - Liberar porta 3050 (Firebird) no Firewall
echo ===========================================
set /p opcao=Escolha uma opcao: 

if "%opcao%"=="0" goto menu
if "%opcao%"=="1" goto reiniciar
if "%opcao%"=="2" goto lentidao
if "%opcao%"=="3" goto updateGp 
if "%opcao%"=="4" goto cpu 
if "%opcao%"=="5" goto compartilhamento
if "%opcao%"=="6" goto compartilhar_avancado
if "%opcao%"=="7" goto firebird_port

echo Opcao invalida.
pause
goto sistema

:reiniciar
rem Desliga e reinicia o computador
shutdown /r /t 0
goto fim

:lentidao
cls
echo Etapa 1: Abrindo pastas temporarias...
start "" "%temp%"
start "" "%SystemRoot%\SoftwareDistribution\Download"
start "" "%LocalAppData%\Microsoft\Windows\Explorer"
start "" "C:\Windows\Prefetch"

echo.
echo Etapa 2: Executando SFC...
sfc /scannow

echo.
echo Etapa 3: Limpando arquivos temporarios...
del /f /s /q "%temp%\*.*"
del /f /s /q "%SystemRoot%\SoftwareDistribution\Download\*.*"
del /f /s /q "%LocalAppData%\Microsoft\Windows\Explorer\*.*"
del /f /s /q "C:\Windows\Prefetch\*.*"
pause
goto sistema

:updateGp 
rem Força a atualização da Política de Grupo
gpupdate /force
pause
goto sistema

:cpu
rem Lista os processos com maior uso de CPU e os ordena
wmic path Win32_PerfFormattedData_PerfProc_Process get Name,PercentProcessorTime | sort
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
rem Comando para compartilhar uma pasta na rede com permissão total para 'Todos'
set /p pasta=Digite o caminho COMPLETO da pasta que deseja compartilhar (ex: C:\dados): 
set /p nome_compartilhamento=Digite o NOME do compartilhamento:
rem O comando 'net share' cria o compartilhamento
net share "%nome_compartilhamento%"="%pasta%" /GRANT:Everyone,FULL
echo A pasta '%pasta%' foi compartilhada como '%nome_compartilhamento%' com acesso total para 'Todos'.
pause
goto sistema

:firebird_port
rem Libera a porta 3050 para o Firebird no Firewall do Windows
echo Adicionando regras de entrada e saida para a porta 3050 (Firebird)...
netsh advfirewall firewall add rule name="Firebird" dir=in action=allow protocol=TCP localport=3050
netsh advfirewall firewall add rule name="Firebird" dir=out action=allow protocol=TCP localport=3050
echo Regras do Firewall adicionadas com sucesso.
pause
goto sistema

rem --- SAIR DO SCRIPT ---
:sair
rem Apenas finaliza o script
echo Saindo...
exit

:fim
