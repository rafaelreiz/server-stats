#!/bin/bash
# server-stats.sh - Estatisticas basicas de desempenho do servidor Linux
# Uso: ./server-stats.sh

echo "=========================================="
echo "   ESTATISTICAS DO SERVIDOR"
echo "   Host: $(hostname)  |  $(date '+%d/%m/%Y %H:%M:%S')"
echo "=========================================="

# ------------------------------------------------------------
# 1. USO TOTAL DE CPU
# Lemos /proc/stat duas vezes (com 1s de intervalo) e comparamos:
# a diferenca entre "tempo ocioso" e "tempo total" mostra o uso real.
# ------------------------------------------------------------
echo
echo "--- CPU ---"

# Primeira leitura: linha "cpu  user nice system idle iowait irq softirq steal"
read -r _ u1 n1 s1 i1 w1 q1 sq1 st1 _ < /proc/stat
sleep 1
# Segunda leitura
read -r _ u2 n2 s2 i2 w2 q2 sq2 st2 _ < /proc/stat

# Ocioso = idle + iowait | Total = soma de todos os campos
ocioso=$(( (i2 + w2) - (i1 + w1) ))
total=$(( (u2+n2+s2+i2+w2+q2+sq2+st2) - (u1+n1+s1+i1+w1+q1+sq1+st1) ))

uso_cpu=$(awk -v o="$ocioso" -v t="$total" 'BEGIN { printf "%.1f", (t - o) * 100 / t }')
echo "Uso total de CPU: ${uso_cpu}%"

# ------------------------------------------------------------
# 2. USO DE MEMORIA (livre vs usada)
# "free -m" mostra os valores em MB. Coluna 2 = total, 3 = usada.
# ------------------------------------------------------------
echo
echo "--- MEMORIA ---"
free -m | awk '/^Mem:/ {
    total = $2
    usada = $3
    livre = total - usada
    printf "Total: %d MB\n", total
    printf "Usada: %d MB (%.1f%%)\n", usada, usada * 100 / total
    printf "Livre: %d MB (%.1f%%)\n", livre, livre * 100 / total
}'

# ------------------------------------------------------------
# 3. USO DE DISCO (livre vs usado)
# "--total" soma todos os sistemas de arquivos; ignoramos os virtuais (tmpfs).
# A ultima linha do df eh a linha "total".
# ------------------------------------------------------------
echo
echo "--- DISCO ---"
df -h --total -x tmpfs -x devtmpfs -x squashfs -x overlay 2>/dev/null | tail -1 | awk '{
    printf "Total: %s\n", $2
    printf "Usado: %s (%s)\n", $3, $5
    printf "Livre: %s\n", $4
}'

# ------------------------------------------------------------
# 4. TOP 5 PROCESSOS POR USO DE CPU
# ps lista os processos; --sort=-%cpu ordena do maior para o menor.
# head -6 = 1 linha de cabecalho + 5 processos.
# ------------------------------------------------------------
echo
echo "--- TOP 5 PROCESSOS POR CPU ---"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -6

# ------------------------------------------------------------
# 5. TOP 5 PROCESSOS POR USO DE MEMORIA
# Mesma ideia, ordenando por %mem.
# ------------------------------------------------------------
echo
echo "--- TOP 5 PROCESSOS POR MEMORIA ---"
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -6

echo
