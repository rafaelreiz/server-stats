# server-stats

Script em Bash que mostra estatísticas básicas de desempenho de um servidor Linux.

Projeto baseado no desafio [Server Stats](https://roadmap.sh/projects/server-stats) do roadmap.sh.

## O que o script mostra

- Uso total de CPU
- Uso de memória (usada vs livre, com porcentagem)
- Uso de disco (usado vs livre, com porcentagem)
- Top 5 processos por uso de CPU
- Top 5 processos por uso de memória

## Requisitos

- Qualquer distribuição Linux
- Bash
- Comandos padrão: `free`, `df`, `ps`, `awk` (já vêm instalados na maioria dos sistemas)

## Como executar

1. Clone o repositório:

   ```bash
   git clone https://github.com/rafaelreiz/server-stats.git
   cd server-stats
   ```

2. Dê permissão de execução ao script:

   ```bash
   chmod +x server-stats.sh
   ```

3. Execute:

   ```bash
   ./server-stats.sh
   ```

## Exemplo de saída

```
--- CPU ---
Uso total de CPU: 0.5%

--- MEMORIA ---
Total: 8031 MB
Usada: 425 MB (5.3%)
Livre: 7606 MB (94.7%)

--- DISCO ---
Total: 50G
Usado: 14G (28%)
Livre: 36G

--- TOP 5 PROCESSOS POR CPU ---
  PID COMMAND         %CPU %MEM
 ...
```

## Como funciona

- **CPU:** lê `/proc/stat` duas vezes (com 1 segundo de intervalo) e calcula a diferença entre o tempo ocioso e o tempo total.
- **Memória:** usa `free -m` e calcula a porcentagem com `awk`.
- **Disco:** usa `df -h --total`, ignorando sistemas de arquivos virtuais (tmpfs, devtmpfs etc.).
- **Top 5:** usa `ps -eo ... --sort` ordenando por `%cpu` e `%mem`.

## Página do projeto

https://roadmap.sh/projects/server-stats
