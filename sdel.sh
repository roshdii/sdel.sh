#!/bin/bash

#Author : Eslam Rohdi 
#File : sdel.sh
#Description : Safe Remove for files "Backup"
#Date : 9/12/2019
#Supervior : Eng. George Emad - Senior Sw Engineer Valeo 
#Details : Safe Remove selected files by archive them into Trash folder then remove them 
#Procuder : 1. Check Trash directory 
#			2. Clear Trash files > 48H
#			3. archive Files
#			4. Remove Files 

##################################
######### Call once ##############
##################################
# change mode this file to be excutable
# called when no inputs to copy 
if [ $# == 0 ];
then
	chmod o+x $0
	sudo cp $0 /usr/bin
	echo "done copying to bin"

	# cronetab -e and append this line 
	# will backup these files every 1 hour
	#* */1 * * * /usr/bin/sdel.sh ~/files/1 ~/files/2 ~/files/ar.zip 

else

echo "<>SafeRemove<>"

###################################
######## 1. Check Trash ###########
###################################
cd ~
if [ -d Trash ] 
then echo "Trash Found"
else mkdir Trash/
fi
cd -

###################################
######## 2. Clear Trash ###########
################################### 
find ~/Trash -type f -name *.tar  -mtime +2 -exec rm {} \;

###################################
######## 3. Archive files #########
###################################

tar czf - $@ --exclude={'*.tar','*.zip'} > Archive.tar
mv Archive.tar ~/Trash/Archive.tar 

###################################
######## 4. Remove files ##########
###################################

for i in $@ 
do 

# if [ -f $i  ];
# then
	echo "file"
	echo $i 
	#x=find ./ -type f -wholename */$i 
	x=$(file $i | cut -d" " -f3) 
	echo $x
	if [[ $x == "archive" ]] || [[ $x == "tar" ]] || [[ $x == "compressed" ]]  ;
	then 
		xx= echo $i | cut -d"/" -f2
		mv $i ~/Trash/$xx 
		touch ~/Trash/$xx	
	else 
		rm -r $i 
	fi
# elif [ -d $i ]
# then
# 	echo "dir"
	
# fi

#for i in $@
#do
#if [ -f $i ]; then rm $i; fi
#fi [ -d $i ]; then rm -r $i; fi
#done 

done

###################################
######## 5.            ############
###################################

fi