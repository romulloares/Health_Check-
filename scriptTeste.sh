#!/bin/bash


 function run_01 () {
   echo
   echo
   echo '    Nome do teste   :  Nome do cliente e data'
   echo -en '    Nome da máquina :  '  ; hostname ; echo '    Data da Execução: ' | tr '\n' ' ' ; date  
   echo 
 }
 
 function run_02 () {
   echo
   echo
   echo -e '    Nome do teste     :  Tempo total de Atividade de HW'
   echo -en '    Saída do comando  : ' ; uptime  
   echo
 
 }
 
 function run_03 () {
   echo
   echo
   echo '    Nome do teste    :  Verificar espeço em disco HD'    
   echo -e '    Saída do comando :\n\n'; df -h
   echo
 
 }
  
function run_04 () {
   echo
   echo
   echo '    Nome do teste    :  Detalhamento de espeço em disco por diretório'    
   echo -e '    Saída do comando :\n\n'; sudo du -xh --max-depth=1 / | sort | grep -v 'Permission denied'
   echo
 
 }

function run_05 () {
   echo
   echo
   echo '    Nome do teste    :   Verificar Memória RAM   '    
   echo -e '    Saída do comando :\n\n'; free
   echo
 
 }

function run_06 () {
   echo
   echo
   echo '    Nome do teste    :   Avaliar contadores de interface de rede  '    
   echo -e '    Saída do comando :\n\n'; ifconfig
   echo
 
 }


function run_07 () {
   echo
   echo
   echo '    Nome do teste    :  Verificar tempo de vida últil de HW'    
   echo -e '    Saída do comando :\n\n '; sudo dmidecode | grep "Serial Number"  
   echo
 
 }

  
  run_01
  run_02
  run_03
  run_04
  run_05
  run_06
  run_07














 # func_01()
 # if [ $? -eq 0 ]
 # then
 # echo "Sucesso"
 # else
 # echo "Falha na execução"
 # fi



