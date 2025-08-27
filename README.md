# 🔧 Tune-Up Script para Windows

Script VBS abrangente para otimização, manutenção e reparo do Windows com interface de menu interativa.

## ⚡ Recursos Principais

### 🎯 **Otimizações de Performance**
- Limpeza de arquivos temporários
- Desabilitação do Compatibility Appraiser
- Controle de serviços (Windows Update, Search, SysMain)
- Configuração de plano de energia de alto desempenho
- Otimização de efeitos visuais
- Limpeza profunda de disco
- Desfragmentação/otimização de drives

### 🔄 **Sistema de Backup e Reversão**
- Snapshot automático do estado do sistema antes das alterações
- Reversão completa ou seletiva das otimizações aplicadas
- Backup das configurações originais em arquivo INI

### 🛠️ **Ferramentas de Reparo**
- DISM (CheckHealth, ScanHealth, RestoreHealth)
- SFC (System File Checker)
- Limpeza de componentes do Windows
- Reset completo do Windows Update
- Re-registro de DLLs do Windows Update
- Reset da pilha de rede (Winsock/IP)
- CHKDSK online e offline

### 🚀 **Recursos Avançados**
- DISM com fonte local personalizada (install.wim/esd)
- Restauração do Microsoft Store
- Gerenciamento da fila BITS
- Relatório rápido de BSOD (Blue Screen)
- Acesso direto aos Minidumps
- Reinicialização do sistema

## 📋 Pré-requisitos

- **Windows 7/8/8.1/10/11**
- **Privilégios de Administrador** (o script solicita elevação automaticamente)
- **PowerShell** (para recursos avançados)

## 🚀 Como Usar

### Execução
1. Clique com o botão direito no arquivo `.vbs`
2. Selecione "Executar como administrador"
3. Ou execute via linha de comando: `cscript tuneu-up.vbs`

### Interface do Menu

#### **Menu Principal**
```
INFORMAÇÕES
  1) Mostrar informações do sistema

APLICAR (não reversíveis: 2, 9, 10)
  2) Limpar temporários
  3) Desabilitar Compatibility Appraiser
  4) Desabilitar Windows Update (wuauserv)
  5) Desabilitar Windows Search (WSearch)
  6) Desabilitar SysMain/Superfetch
  7) Ativar plano Alto Desempenho
  8) Otimizar Efeitos Visuais
  9) Limpeza profunda de disco
  10) Otimizar/Desfragmentar C:
  98) Aplicar TUDO

REVERTER (onde aplicável)
  203-208) Reverter otimizações específicas
  99) Reverter TUDO possível

SUBMENUS
  300) Reparos do Windows
  400) Avançado
```

#### **Submenu Reparos (300)**
- DISM CheckHealth/ScanHealth/RestoreHealth
- SFC /scannow
- Limpeza de componentes
- Reset do Windows Update
- Re-registro de DLLs
- Reset de rede
- CHKDSK online/offline

#### **Submenu Avançado (400)**
- DISM com fonte local
- Restaurar Microsoft Store
- Gerenciar fila BITS
- Relatório de BSOD
- Acesso aos Minidumps
- Reinicialização do sistema

## 📁 Arquivos Criados

| Arquivo | Localização | Descrição |
|---------|-------------|-----------|
| `TuneUp_Log.txt` | `C:\` | Log detalhado de todas as operações |
| `TuneUp_Backup.ini` | `C:\` | Backup das configurações originais |
| Arquivos temporários | `%TEMP%\` | Relatórios e dados temporários |

## ⚠️ Avisos Importantes

### **Ações Não Reversíveis**
- **Opção 2**: Limpeza de temporários (arquivos são deletados permanentemente)
- **Opção 9**: Limpeza profunda de disco (arquivos são deletados permanentemente)  
- **Opção 10**: Desfragmentação (reorganização física dos dados)

### **Recomendações de Segurança**
- ✅ **Crie um ponto de restauração** antes de executar
- ✅ **Faça backup dos dados importantes**
- ✅ **Execute em modo de teste** primeiro (opções individuais)
- ✅ **Leia os logs** em `C:\TuneUp_Log.txt`

## 🔧 Funcionalidades Técnicas

### **Sistema de Snapshot**
- Salva estado original de serviços, tarefas e configurações de registro
- Permite reversão precisa das alterações
- Armazenado em formato INI legível

### **Detecção de Hardware**
- Identifica tipo de disco (HDD/SSD/NVMe)
- Mostra informações de CPU, RAM e SO
- Adapta otimizações conforme o hardware

### **Gerenciamento de Serviços**
- Para e desabilita serviços com segurança
- Salva estado original para reversão
- Usa WMI e comandos SC para máxima compatibilidade

### **Limpeza Inteligente**
- Remove arquivos temporários com tratamento de erros
- Configura limpeza profunda do Cleanmgr
- Preserva arquivos importantes do sistema

## 📊 Informações do Sistema

O script detecta e exibe:
- **Sistema Operacional**: Nome e versão
- **Processador**: Modelo e arquitetura  
- **Memória RAM**: Quantidade total em GB
- **Tipo de Disco**: HDD, SSD ou NVMe com RPM (se aplicável)

## 🛡️ Segurança e Compatibilidade

- **Elevação Automática**: Solicita privilégios de administrador quando necessário
- **Tratamento de Erros**: Operações protegidas com `On Error Resume Next`
- **Logs Detalhados**: Registro completo de todas as operações
- **Compatibilidade**: Testado em Windows 7, 8, 10 e 11
- **Reversibilidade**: Maioria das alterações podem ser desfeitas

## 🔍 Troubleshooting

### **Problemas Comuns**
- **"Acesso negado"**: Execute como administrador
- **"Script não executa"**: Verifique se VBS não está bloqueado pelo antivírus
- **"Reversão falha"**: Verifique se o arquivo `TuneUp_Backup.ini` existe

### **Logs e Diagnóstico**
- Consulte `C:\TuneUp_Log.txt` para detalhes das operações
- Use a opção 405 para relatório rápido de BSOD
- Verifique `%TEMP%` para arquivos de diagnóstico temporários

## 📝 Changelog

### **Versão Atual (2025-08-27)**
- ✨ Interface de menu completa e intuitiva
- 🔄 Sistema robusto de backup e reversão
- 🛠️ Ferramentas avançadas de reparo
- 📊 Detecção automática de hardware
- 🔒 Melhorias de segurança e tratamento de erros
- 🌐 Remoção completa de acentuação para máxima compatibilidade

## 📞 Suporte

Para relatar problemas ou sugestões:
1. Verifique os logs em `C:\TuneUp_Log.txt`
2. Anote a mensagem de erro exata
3. Inclua informações do sistema (use a opção 1 do menu)

---

**⚠️ Disclaimer**: Use por sua conta e risco. Sempre faça backup antes de executar otimizações do sistema.