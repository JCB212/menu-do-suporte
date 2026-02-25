# 🛠️ Help To Desk v4.0 Ultimate (2026)

> **Suporte Técnico Automatizado para Windows 10 & 11**  
> Ferramenta robusta para diagnóstico de rede, manutenção de sistema, gestão de impressoras e reparo de bases Firebird.

---

## 📋 Sobre o Projeto

**Help To Desk** é um script de automação avançado criado para centralizar tarefas críticas de TI em um menu interativo, seguro e eficiente.

A versão **2026 (v4.0 Ultimate)** foi otimizada para:

- Novas camadas de segurança do Windows 11  
- Automação moderna via Winget  
- Manutenção corporativa e suporte técnico profissional  

---

## 🚀 Funcionalidades

### 🌐 Infraestrutura & Redes
- Diagnóstico completo de rede (IP, Netstat, adaptadores)
- Flush DNS e limpeza de cache de navegadores
- Testes de conectividade (Ping, PathPing)
- Liberação de portas no Firewall (ex: 3050 – Firebird)

### 💻 Manutenção de Sistema
- SFC, DISM e CHKDSK automatizados
- Limpeza de temporários e logs
- Reset do Windows Update
- Backup do Registro e drivers
- Criação de ponto de restauração

### 🖨️ Gestão de Impressoras (Fix 2026)
- Correção automática dos erros:
  - 0x0000011b
  - 0x00000bcb
  - 0x00000709
- Compartilhamento e permissões via PowerShell

### 🔥 Firebird Repair Module
- Assistente GFIX / GBAK
- Verificação e correção de bases .FDB
- Backup e restauração guiados

### 📦 Winget & Softwares
- Instalação, busca e remoção de aplicativos
- Atualização global:
```bash
winget upgrade --all
```

---

## 🧭 Estrutura de Menus

| Opção | Módulo         | Descrição |
|-----:|---------------|-----------|
| 1 | Infraestrutura | Rede e Firewall |
| 2 | Sistema | Manutenção e Diagnóstico |
| 3 | Impressoras | Spooler e Correções |
| 4 | Firebird | Reparo de Banco |
| 5 | Windows 11 | Segurança e UI |
| 6 | Winget | Softwares |

---

## ⚠️ Pré-requisitos

- Windows 10 ou 11
- Execução obrigatória como Administrador

---

## 🔐 Verificação de Privilégios

```bat
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Requer Administrador
    pause
    exit /b
)
```

---

## 👥 Público-Alvo

- Técnicos de Suporte
- Analistas de TI
- Administradores de Sistemas

---

## 📌 Observações

Projeto focado em padronização, agilidade e segurança operacional.
