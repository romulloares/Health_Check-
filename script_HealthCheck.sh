#!/bin/bash

## Descrição: scriptColeta_HC.sh (Coleta de informações para realização do QRadar Health Check) 
## Escrito por: LeadComm (SP - São Paulo)
## E-mail: suporte@leadcomm.com.br 


## Exemplo de Uso: Executar o arquivo scriptColeta_HC.sh, após o término da execução, no mesmo diretório será criado uma pasta "Resultado_HC_Leadcomm.tar".
 


##################################################################################################################
#                                            DECLARAÇÃO DE FUNÇÕES

 function status () {

  if [ $? -eq 0 ]
  then
  echo "Sucesso" >> Readme.txt
  else
  echo "Falha na execução" >> Readme.txt
  fi

 }	 
  
 function verificaSeArquivoJaExiste () {

  if [ -e Resultado_HC_Leadcomm/ ]
  then
  echo "O arquivo Resultado_HC_Leadcomm já existe, mova este arquivo para outro diretório e tente novamente" ; exit 1 
  else
  echo "Iniciando a Coleta, Aguarde! " 
  fi

 }

function verificaPrivilegioUsuario () {

VERIFICA=`id -u`
USUARIOATUAL=`whoami`

## Condicional: Se o usuário não for root ( UID diferente de zero )
## então gera o alerta e finaliza o script com erro. Caso contrário,
## continua o script com os comandos que seguem.

if [ $VERIFICA != 0 ]; then
echo "O seu usuário é ${USUARIOATUAL}. Precisa executar o este comando como root…"
exit 1
else
echo "Iniciando a Coleta, Aguarde!"
fi

}

##################################################################################################################
#                                                 APPLIANCE


 function apl_01 () {
   echo
   echo
   echo '    Nome do teste   :  Nome do cliente e data '
   echo -en  '    Nome da máquina :  '  ; hostname && echo '    Data da Execução: ' | tr '\n' ' ' && date ; status 
   echo
    
 }

 
 function apl_02 () {
   echo
   echo
   echo -e '    Nome do teste     :  Tempo total de Atividade de HW'
   echo -en '    Saída do comando  : ' ; uptime ; status 
   echo
 
 }
 

 function apl_03 () {
   echo
   echo
   echo '    Nome do teste    :  Verificar espaço em disco '    
   echo -e '    Saída do comando :\n\n'; /bin/df -h ; status
   echo
 
 }
  

function apl_04 () {
   echo
   echo
   echo '    Nome do teste    :  Detalhamento de espaço em disco por diretório'    
   echo -e '    Saída do comando :\n\n'; sudo du -xh --max-depth=1 / | sort | grep -v 'Permission denied' ; status
   echo
 
 }


function apl_05 () {
   echo
   echo
   echo '    Nome do teste    :   Verificar Memória RAM   '    
   echo -e '    Saída do comando :\n\n'; /usr/bin/free -m ; status
   echo

 }

function apl_06 () {
   echo
   echo
   echo '    Nome do teste    :   Verificar Processador e Versão OS  '    
   echo -e '    Saída do comando :\n\n'; cat /proc/cpuinfo | grep "model name" && /usr/bin/lsb_release -ds ; status 
   echo

  }
 

function apl_07 () {
   echo
   echo
   echo '    Nome do teste    :   Avaliar contadores de interface de rede  '    
   echo -e '    Saída do comando :\n\n'; ifconfig ; status
   echo

 }


function apl_08 () {
   echo
   echo
   echo '    Nome do teste    :  Verificar tempo de vida últil de HW'    
   echo -e '    Saída do comando :\n\n '; sudo dmidecode | grep "Serial Number" ; status  
   echo
 
 }


function apl_09 () {
   echo
   echo
   echo '    Nome do teste    :  Obter o Build da Versão QRadar'    
   echo -e '    Saída do comando :\n\n '; /opt/qradar/bin/myver -v  ; status  
   echo
 
 }
 

function apl_10 () {
   echo
   echo
   echo '    Nome do teste    :  Verificar sincronização com relógios'    
   echo -e '    Saída do comando :\n\n '; cat /etc/ntp.conf  | grep -ve '^#'| grep . && echo -en '\n\nHorario Atual ---> ' && date ; status  
   echo
 
 }
  

function apl_11 () {
   echo
   echo
   echo '    Nome do teste    :  Obter a Build do QRadar'    
   echo -e '    Saída do comando :\n\n '; du -xh --max-depth=1 /store/backup && ls -lsh /store/backup/  ; status  
   echo
 
 }

 
##################################################################################################################
#                                                  COLETA


function col_01 () {
   echo
   echo
   echo '    Nome do teste    : Obter as fontes de logs inativas há mais de 2 dias'    
   echo -e '    Saída do comando :\n\n '; psql -U qradar -c "SELECT count(hostname) as total , sdt.devicetypename FROM sensordevice , sensordevicetype as sdt WHERE devicetypeid = sdt.id and deviceenabled='f' GROUP BY sdt.devicetypename ORDER BY total desc;" ; status  
   echo
 
 }


function col_02 () {
   echo
   echo
   echo '    Nome do teste    : Obter Wincollects Ativos'    
   echo -e '    Saída do comando :\n\n '; psql -U qradar -c "select hostname, devicename, TO_CHAR(TO_TIMESTAMP(timestamp_last_seen/1000), 'YYYY/MM/DD') as LastSeen from sensordevice where id IN (select id from sensordevice where devicename like 'WinCollect%') and deviceenabled='t' order by lastseen desc" ; status  
   echo
 
 }


function col_03 () {
   echo
   echo
   echo '    Nome do teste    : Verificar se WinCollects são atualizados automaticamante '    
   echo -e '    Saída do comando :\n\n '; psql -U qradar -c "SELECT hostname FROM ale_client WHERE agent_communication_enabled = 't' AND enabled = 't' AND id NOT IN( SELECT id FROM ale_client WHERE hostname LIKE '%OLD') ORDER BY id;" ; status  
   echo
 
 }


function col_04 () {
   echo
   echo
   echo '    Nome do teste    : Número de fonte de log e quantidade '    
   echo -e '    Saída do comando :\n\n '; psql -U qradar -c "SELECT count(hostname) as total , sdt.devicetypename FROM sensordevice , sensordevicetype as sdt WHERE devicetypeid = sdt.id and deviceenabled='t'  GROUP BY sdt.devicetypename ORDER BY total desc;" ; status  
   echo
 
 }


function col_05 () {
   echo
   echo
   echo '    Nome do teste    : Verão WinCollects '    
   echo -e '    Saída do comando :\n\n '; psql -U qradar -c "select name, description, version from ale_client" ; status  
   echo
 
 }


function col_06 () {
   echo
   echo
   echo '    Nome do teste    : Verifica se há descarte de Eventos e Flows por drop '    
   echo -e '    Saída do comando :\n\n '; grep -i dropped /var/log/qradar.log ; status  
   echo
 
 }



##################################################################################################################
#                                                  OPERAÇÃO


function ope_01 () {
   echo
   echo
   echo '    Nome do teste    : Avaliar log qradar.error '    
   echo -e '    Saída do comando :\n\n '; cat /var/log/qradar.error ; status  
   echo
 
 }



##################################################################################################################
#                                             CHAMADA DE FUNÇÕES



verificaSeArquivoJaExiste 

verificaPrivilegioUsuario

function main_appliance()
{
  apl_01 
  apl_02
  apl_03 
  apl_04
  apl_05
  apl_06 
  apl_07 
  apl_08
  apl_09 
  apl_10
  apl_11
}

main | tee -a appliance.txt



function main_coleta()
{
  col_01 
  col_02 
  col_03
  col_04 
  col_05 
  col_06
}

main | tee -a coleta.txt



function main_operacao()
{
  ope_01
}

main | tee -a operacao.txt


##################################################################################################################
#                                         CRIAÇÃO DO ARQUIVO DE COLETA

echo CRIANDO ARQUIVO -> Resultado_HC_Leadcomm.zip

mkdir -p Resultado_HC_Leadcomm/ ; mv appliance.txt coleta.txt operacao.txt Resultado_HC_Leadcomm/ ; zip -r Resultado_HC_Leadcomm.zip Resultado_HC_Leadcomm/ ;  rm -rf Resultado_HC_Leadcomm/ 

sleep 2

echo FIM. acompanhe o resultado da coleta em -> Readme.log 

echo 

exit 





