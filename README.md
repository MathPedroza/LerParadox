# LerParadox — Utilitário de Leitura de Tabelas Paradox

Aplicação desktop desenvolvida em **Delphi (Object Pascal)** voltada para a leitura, visualização e extração de dados contidos em tabelas de bancos de dados legados no formato **Paradox (`.db`)**.

---

## 🎯 Sobre o Projeto

O formato Paradox foi amplamente utilizado em sistemas de gestão (ERPs e PDVs) durante as décadas de 1990 e 2000, operado via Borland Database Engine (BDE). Com a modernização das plataformas, acessar e auditar esses arquivos legados tornou-se um desafio comum em processos de migração de dados e suporte técnico.

O **LerParadox** foi construído para fornecer uma interface direta e funcional que permite abrir arquivos de tabelas Paradox, carregar sua estrutura e registros em tela de forma rápida, dispensando configurações complexas de infraestrutura de bancos modernos.

### Principais Recursos

- **Leitura Direta:** Abertura e parsing de tabelas legadas `.db`.
- **Exibição Tabular:** Carregamento estruturado das colunas e linhas em interface gráfica VCL nativa.
- **Leveza e Portabilidade:** Aplicação compilada nativamente para Windows (Win32), sem dependência de runtimes externos pesados.

---

## 🛠️ Tecnologias e Ferramentas

- **Linguagem:** Object Pascal (Delphi)
- **Framework de Interface:** VCL (Visual Component Library)
- **Compilador/IDE Base:** Embarcadero Delphi (compatível com Delphi 11 Alexandria / versões modernas)
- **Plataforma de Destino:** Windows (Win32)
- **Acesso a Dados Legados:** Componentes nativos de manipulação de dados tabulares

---

🚀 Como Executar e Compilar
Pré-requisitos
Embarcadero Delphi / RAD Studio (versão XE ou superior recomendada).

Sistema Operacional Windows 7, 10 ou 11.

Abra o arquivo LerParadox.dproj diretamente no Delphi (RAD Studio).

Selecione a plataforma de compilação como Win32 (Debug ou Release).

Pressione Ctrl + F9 para compilar ou F9 para compilar e executar o projeto diretamente.

O executável final será gerado no diretório de saída correspondente (Win32/Release ou na pasta raiz conforme configurado).

👤 Autor
Desenvolvido por Matheus Pedroza.
