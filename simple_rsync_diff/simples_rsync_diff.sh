#!/bin/bash
# 
# Backup do servidor XXXXX
# Responsavel : Mike Tesliuk (mike@wsu.com.br)

SERVIDOR=192.168.1.200
MODULO=('etc' 'home')
BKPDIR=/mnt/backup/backup_files
IMAGEDIR=$BKPDIR/data
DIFFDIR=$BKPDIR/diff

exec_limpeza(){
	# Funcao para limpeza de arquivos mais velhos

	RETENCAO=$1
	DIFFDIR=$2 
	SERVIDOR=$3
		
	DAYSD=`date +%d -d "$RETENCAO day ago"`
	DAYSY=`date +%Y -d "$RETENCAO day ago"`
	DAYSM=`date +%m -d "$RETENCAO day ago"`


	if [ -d $DIFFDIR/$DAYSY/$DAYSM/$DAYSD/$SERVIDOR ]; then 
		echo "Executando limpeza do diretorio : ${DIFFDIR}/${DAYSY}/${DAYSM}/${DAYSD}/${SERVIDOR}"
		rm -rf ${DIFFDIR}/${DAYSY}/${DAYSM}/${DAYSD}


	fi


}




# definincao da retencao
RETENCAO=15

exec_limpeza $RETENCAO $DIFFDIR $SERVIDOR

for MYMODULO in ${MODULO[@]}; do
	if [ ! -d $IMAGEDIR/$SERVIDOR/$MYMODULO ]; then
		mkdir -p $IMAGEDIR/$SERVIDOR/$MYMODULO
	fi

	if [ ! -d $DIFFDIR/$(date +%Y)/$(date +%m)/$(date +%d)/$SERVIDOR/$MYMODULO ]; then
		mkdir -p $DIFFDIR/$(date +%Y)/$(date +%m)/$(date +%d)/$SERVIDOR/$MYMODULO
	fi

	/usr/bin/rsync -av --delete --backup --backup-dir=$DIFFDIR/$(date +%Y)/$(date +%m)/$(date +%d)/$SERVIDOR/$MYMODULO $SERVIDOR::$MYMODULO $IMAGEDIR/$SERVIDOR/$MYMODULO
done
