# monitoracao
ShellScript para monitoração de ambientes GNU Linux
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
