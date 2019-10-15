#!/bin/bash
echo "Backup full Para HD Externo"
#Autor: Lucas Werle Pires
#Programa de criação de backup full
#DATA: 27/06/2016
 
#Variaveis Globais
msg2=""
msg3=""
msg4=""
msg5=""
msg6=""
 
#SRCDIR="/dados/Backup/srvarquivos/full-$DATA.tar.gz" #diretorios que sera feito backup
#DSTDIR=/hdexterno #diretorio de destino do backup
DATA=`date +%x` #data atual
TIME_BKCP=+2 #retencao
#data de inicio backup
DATAIN=`date +%c`
echo "Data de inicio: $DATAIN"
 
montahd(){
 
VERIFICA=$(df -h | awk '{ print $1}' | grep /dev/sdc2)
 
if [ $VERIFICA = /dev/sdc2 ]; then
 
echo"JA MONTADO"
else
ntfs-3g /dev/sdc2 /hdexterno/
echo"HD MONTOU"
fi
}
 
backupfull(){
 
rsync -avzh  /dados/Backup/engenharia /hdexterno/engenharia

if [ $? -eq 0 ] ; then
   echo "----------------------------------------"
        echo "Backup Full concluído com Sucesso"
 
DATAFIN=`date +%c`
 
   echo "Data de termino: $DATAFIN"
   echo "Backup realizado com sucesso" >> /var/log/backup_hdexterno.log
   echo "Criado pelo usuário: $USER" >> /var/log/backup_hdexterno.log
   echo "INICIO: $DATAIN" >> /var/log/backup_hdexterno.log
   echo "FIM: $DATAFIN" >> /var/log/backup_hdexterno.log
   echo "Log Gerado em /var/log/backup_hdexterno.log"
   echo "-----------------------------------------" >> /var/log/backup_hdexterno.log 
   echo " "
   echo "Log gerado em /var/log/backup_hdexterno.log"
   msg2="Backup concluido com sucesso "  
   msg4="Data de Inicio do Backup "$DATAIN
   msg5="Data de Termino "$DATAFIN
   
    else
   echo "ERRO! Backup do dia $DATAIN" >> /var/log/backup_full.log
   echo "ERRO Backup do Dia " >> msg
  msg3="ERRO de Backup "$ARQ
 
fi
}
montaemail(){
 
 msg6=$(du -hs /hdexterno/*)
 msg7=$(df)
}
 
enviaemail(){
 
FROM="infra.alcast@gmail.com"
TO="myemail@gmail.com,"
SUBJECT="Log Backup BACKUP para HD Externo $(date "+dia %d de %b de %Y as %r")"
 
cat <<EOF | /usr/sbin/sendmail -t  /opt/msg
From: $FROM
To: $TO
Subject: $SUBJECT
 
Resultado do Backup do Servidor Backup.
 
$msg2
$msg3
$msg4
$msg5
$msg6
 
    Tamanho dos Discos SERVERBKP
 
$msg7
 
By - Lucas Pires
EOF
}
 
procuraedestroifull(){
 
#apagando arquivos mais antigos (a mais de 04 dias que existe)
find /hdexterno/SRVARQUIVOS -name "f*" -ctime $TIME_BKCP -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
   else
      echo "Erro durante a busca e destruição do backup antigo!"
   fi
}
montahd
backupfull
procuraedestroifull
montaemail
enviaemail
 
#exit 0 
