#!/bin/bash
echo "Listing between SHA1 $2 and $3 in dir $1 \n"

#Current dir
currentdir=$(pwd)

#Access the repository
cd $1

#Git diff output in file
git diff --raw $2 $3 > $currentdir/out.deploy
echo "\nFiles changeds\n"

#Verify files changed is not empty
fileschanged=$(cat $currentdir/out.deploy)

if [ ! -z "$fileschanged" -a "$str" != " " ]; then
	echo "\n$fileschanged\n"
	echo "\nMaking a file with files changed"
	
	#Remove details in file
	sed -e 's/:[0-9]..... [0-9]..... [0-9a-zA-Z]......... [a-z0-9A-Z]......... [A-M]//g' $currentdir/out.deploy > $currentdir/new.deploy
	
	#Remove file
	rm $currentdir/out.deploy
	
	#Remove breaklines
	sed -e ':a;N;$!ba;s/\n//g' $currentdir/new.deploy > $currentdir/compress.deploy
	
	#Remove file
	rm $currentdir/new.deploy
	filescompress=$(cat $currentdir/compress.deploy)
	
	#Current date
	datelog=$(date +"%Y-%m-%d-%H-%M-%S")
	
	#Compress file
	tar -zcvf $currentdir/deploy_$datelog.tar.gz $filescompress 
	
	#Remove file
	rm $currentdir/compress.deploy
	echo "\n\n\t ########## COMPRESS FILE ########### \n\tYour deploy: $currentdir/deploy_$datelog.tar.gz\n\n\n"
else
	echo "\n\n\t######### Changed files not detected ##########\n\n"
fi
