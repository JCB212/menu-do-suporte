# menu-do-suporte

Script em batch (.bat) interativo para otimizar o suporte técnico em ambientes Windows. Ele automatiza uma série de tarefas de diagnóstico e correção de problemas comuns, aumentando a eficiência e reduzindo erros humanos.

Este script é uma ferramenta poderosa para técnicos de suporte, analistas de TI e administradores de rede, oferecendo uma interface de menu simples para executar comandos complexos e solucionar problemas de forma padronizada.

## Funcionalidades

### 1. Rede

**Diagnóstico:**

- Exibe informações de rede completas (`ipconfig /all`)
- Limpa o cache DNS (`ipconfig /flushdns`)
- Realiza ping em um servidor específico
- Exibe a tabela de roteamento de rede

**Correção:**

- Reseta as configurações de rede (Winsock e IP)

### 2. Impressoras

**Gerenciamento:**

- Lista todas as impressoras instaladas no sistema
- Oferece uma opção interativa para compartilhar qualquer impressora na rede

**Correção de Erros Comuns:**

- Solução automática para os erros de impressão:
  - 0x0000011b
  - 0x00000bcb
  - 0x00000709
- Reinicia o serviço de Spooler de Impressão
- Opção completa para:
  - Parar o Spooler
  - Apagar todos os arquivos de impressão da fila
  - Reiniciar o Spooler
  - Corrigindo problemas de documentos travados

### 3. Sistema

**Manutenção e Diagnóstico:**

- Reinicia o computador
- Executa uma rotina de lentidão:
  - Abre pastas temporárias
  - Limpa arquivos indesejados
- Executa o `sfc /scannow` para verificar a integridade do sistema
- Força a atualização da Política de Grupo (`gpupdate /force`)
- Lista os processos com maior uso de CPU

**Configuração Avançada:**

- Libera o acesso a compartilhamentos de arquivos via SMB entre versões do Windows
- Permite o compartilhamento avançado de qualquer pasta na rede com permissão total
- Adiciona regras de entrada e saída no Firewall do Windows para liberar a porta **3050**, usada pelo banco de dados **Firebird**

## Requisitos

- Executar o script como **administrador**
- Compatível com **Windows 10** e **Windows 11**

## Como usar

1. Clique duas vezes no arquivo `.bat` ou execute-o a partir do terminal como administrador.
2. Um menu interativo será exibido.
3. Digite o número correspondente à opção desejada.
4. O script executará automaticamente as ações selecionadas.

> ⚠️ **Observação**: O script utiliza comandos do **PowerShell** em algumas opções para obter resultados mais detalhados e realizar configurações avançadas.
