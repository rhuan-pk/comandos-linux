#!/usr/bin/env zsh

# Mensagem caso precise instalar o smem
msg(){
        echo -e "\e[40;37;1m
                \rscript: ---------------------------------------------- \n \
                \rscript: |   Necessário instalar o programa: SMEM     | \n \
                \rscript: |                                            | \n \
                \rscript: |   Enter - Prosseguir para a instalação     | \n \
                \rscript: |   Ctrl+c - Cancelar                        | \n \
                \rscript: ---------------------------------------------- \
                \e[m\n"
}

lower_to_upper(){
	echo "${1}" | tr '[:lower:]' '[:upper:]'
}

# Verifica se o smem está instalado, caso não, prossegue para a instalação
INSTALADO=$(dpkg -l smem 2> /dev/null | tail -n 1 | cut -c 1-2)
[ "${INSTALADO}" != "ii" ] && msg && read foobar && sudo apt install smem -y

# Cria e entra no diretório temporário
mkdir -p /tmp/tmp; cd /tmp/tmp

# Reseta o valor da variável SOMA
SOMA=0

# Cria o arquivo aleatório temporário
TMPFILE=$(mktemp RAM-XXXXX.tmp)

# INICIO DO POGRAMA
echo "$(smem -rtk | grep "${1}")" > ${TMPFILE}
tr 'M' ',' < ${TMPFILE} | cut -d ',' -f 2 | tr -d '[:blank:]' | sed '/^$/d' | tr 'OK' '#' | sed '/#/d' > ${TMPFILE}
for line in $(seq `wc -l ${TMPFILE} | cut -d ' ' -f 1`); do let SOMA+=$(head -n ${line} ${TMPFILE} | tail -n 1); done

# Printa o resultado na tela
echo -e "RAM - \e[1m$(lower_to_upper ${1})\e[m: $(echo "${SOMA}" | cut -d '.' -f 1)M"