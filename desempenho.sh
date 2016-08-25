#!/bin/bash
#  _ __ ___   ___  _ __ (_) |_ ___  _ __ __ _  ___ __ _  ___  
# | '_ ` _ \ / _ \| '_ \| | __/ _ \| '__/ _` |/ __/ _` |/ _ \ 
# | | | | | | (_) | | | | | || (_) | | | (_| | (_| (_| | (_) |
# |_| |_| |_|\___/|_| |_|_|\__\___/|_|  \__,_|\___\__,_|\___/ 
#                                                            
# 	[versao 1.0]
#
# 	[NOME]
#   	desempenho.sh
#
# 	[DESCRICAO]
#   	Realiza uma breve checagem nos serviços principais rodando em ambiente Linux, os principais serviços 
#		(Apache, CF, New Relic, Bacula) e processos sistemáticos (vCPU's, RAM, IP's/Usuários Conectados, SSL).
#
#
# 	[NOTA]
#   	Um log no diretório atual e gerado a cada execucao deste script, contendo o nome sendo a data/hora atual da monitoração.
#
#
# 	[REQUISITOS]
# 		Serviços Atualizados:
#			- apache2
#			- newrelic
#			- sar
#			- netstat
#			- bacula
#			- cf-agent
#			- dstat
#
#
#	[MODIFICADO_POR]	[DD/MM/YYYY]	[Ação]
#  	victor.queiroz 		28/01/2015		Criado o escopo do script.
#  	victor.queiroz   	24/02/2015		Adicionado monitoração do apache2.
#  	victor.queiroz   	24/02/2015		Primeira versao.
#	victor.queiroz		25/08/2016		Acrescimo do dstat / consumo de espaço em disco
#
#
#	[LICENÇA]
#		GNU/GPL:
#			Em termos gerais, este código opera sob a licença GPL, onde é baseado nas 4 liberdades:
#				1 - Liberdade de executar o programa, para qualquer propósito;
#				2 - Liberdade de estudar como o programa funciona e adaptá-lo às suas necessidades. O acesso ao código-fonte.
#				3 - Liberdade de redistribuir cópias de modo que você possa ajudar ao seu próximo
#				4 - Liberdade de aperfeiçoar o programa e liberar os seus aperfeiçoamentos, de modo que toda a comunidade beneficie deles. Novamente, cesso ao código-fonte.
#		
#				-> https://www.gnu.org/
#				
#		RESPEITE !
#

	diretorio=$(pwd)
	Arquivo=monitoracao-`date +"%Y-%m-%d"`.txt
	touch $diretorio/$Arquivo
echo "===================================================================================================" >> $Arquivo 

echo "Hora de inicio do teste:" >> $Arquivo
	echo "" >> $Arquivo 
	date >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Consumo do Apache" >> $Arquivo
	echo "" >> $Arquivo 
	usuario=www-data
	processos=$(ps u -u $usuario | wc -l) >> $Arquivo
	memoria=$(ps u -u $usuario | awk '{print $4}' | grep -vi mem) >> $Arquivo
	tamanho_memoria=$(ps u -u $usuario | awk '{print $6}' | grep -vi RSS) >> $Arquivo
	memoria=$(echo $memoria | sed "s, ,+,g" | bc) >> $Arquivo 
	tamanho_memoria=$(echo $tamanho_memoria | sed "s, ,+,g" | bc) >> $Arquivo
	tamanho_memoria=$(echo "$tamanho_memoria*0.001024" | bc) >> $Arquivo
	cpu=$(ps u -u $usuario | awk '{print $3}' | grep -vi %CPU) >> $Arquivo
	cpu=$(echo $cpu | sed "s, ,+,g" | bc) >> $Arquivo
	media=$(echo $memoria/$processos | bc) >> $Arquivo
	media_cpu=$(echo $cpu/$processos | bc) >> $Arquivo
	echo -e "processos: $processos \nPorcentagem de memoria: $memoria % \nmedia da porcentagem de memoria: $media%\ntamanho dos processos: $tamanho_memoria MB \nPorcentagem cpu: $cpu% \nMedia porcentagem cpu: $media_cpu%" >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Load Average" >> $Arquivo
	echo "" >> $Arquivo 
	cat /proc/loadavg >> $Arquivo 

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "# Usuarios Conectados:" >> $Arquivo 
	echo "" >> $Arquivo 
	w | awk '{print $1}' | grep -viE user >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "# Uso de I/O no disco" >> $Arquivo
	echo "" >> $Arquivo 
	sar -u 1 20  >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "# Consumo total da memoria" >> $Arquivo
	echo "" >> $Arquivo 
	free -m >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Conexoes ativas no apache: " >> $Arquivo
	echo "" >> $Arquivo 
	netstat -ntu | grep :80 | wc -l >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "IP's que fazem conexao com o servidor varias vezes:" >> $Arquivo
	echo "" >> $Arquivo 
	netstat -ntu | grep ':80 '| awk '{print $5}' | grep -v "servers\|Address" | cut -d: -f1 | sort | uniq -c | sort -n | grep -v '127\.0\.0\.1\|CLOSE\_WAIT\|TIME\_WAIT\|LISTEN|ESTABLISHED' | tac | head | tac | tac | head -n8 | tac >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Conexoes ativas no apache pelo SSL: " >> $Arquivo
	echo "" >> $Arquivo 
	netstat -ntu | grep :443 | wc -l >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "# Processos do newrelic" >> $Arquivo 
	echo "" >> $Arquivo 
	echo PID...%CPU.%MEM...TIME.COMMAND >> $Arquivo 
	ps aux | grep newrelic >> $Arquivo 

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo 
echo "# Processos do CF" >> $Arquivo 
	echo "" >> $Arquivo 
	echo PID...%CPU.%MEM...TIME.COMMAND >> $Arquivo 
	ps aux | grep cf >> $Arquivo 

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo 
echo "# Processos do Bacula" >> $Arquivo 
	echo "" >> $Arquivo 
	echo PID...%CPU.%MEM...TIME.COMMAND >> $Arquivo 
	ps aux | grep bacula >> $Arquivo

echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Hora do termino do teste" >> $Arquivo 
	echo "" >> $Arquivo 
	date >> $Arquivo

#echo "====================================================================" >> $Arquivo
#echo "Quantidade corrente de memória swap de todos os processos em execução" >> $Arquivo 
#
#SOMA=0
#OVERALL=0
#for DIR in `find /proc/ -maxdepth 1 -type d -regex "^/proc/[0-9]+"`
#do
#    PID=`echo $DIR | cut -d / -f 3`
#    PROGNAME=`ps -p $PID -o comm --no-headers`
#    for SWAP in `grep Swap $DIR/smaps 2>/dev/null | awk '{ print $2 }'`
#    do
#        let SOMA=$SOMA+$SWAP
#    done
#    if (( $SOMA > 0 )); then
#        echo "PID=$PID swapped $SOMA KB ($PROGNAME)" >> $Arquivo
#    fi
#    let OVERALL=$OVERALL+$SOMA
#    SOMA=0
#done
#echo "Overall swap used: $OVERALL KB" >> $Arquivo


echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "DSTAT" >> $Arquivo
	dstat -tcndylp --top-cpu --proc-count 2 10 >> $Arquivo
	dstat -tscm --top-mem >> $Arquivo
	dstat -tscm --top-cpu >> $Arquivo


echo "---------------------------------------------------------------------------------------------------" >> $Arquivo
echo "Utilização de Disco" >> $Arquivo
	echo "		FHS:" >> $Arquivo
	cd /; du / --max-depth=1 -h --exclude=/proc --exclude=/run
	echo "		Usuários:" >> $Arquivo
	du /home --max-depth=1 -h


echo "===================================================================================================" >> $Arquivo 
echo "888      d8b                            " >> $Arquivo
echo "888      Y8P                            " >> $Arquivo
echo "888                                     " >> $Arquivo
echo "888      888 88888b.  888  888 888  888 " >> $Arquivo
echo "888      888 888  88b 888  888  Y8bd8P  " >> $Arquivo
echo "888      888 888  888 888  888   X88K   " >> $Arquivo
echo "888      888 888  888 Y88b 888 .d8""8b. " >> $Arquivo
echo "88888888 888 888  888  YY88888 888  888 " >> $Arquivo