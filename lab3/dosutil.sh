#!/bin/bash
#Ethan Emmons
#Purpose: This script ....
#Last Revision Date:  11/5/21
#Variables:
#ARG1 = Command/mode
#ARG2 = Original file
#ARG3 = Destination/target file
HELPOUTPUT="author  |\toutputs the author of the script\n
type [file]  |\toutputs the contents of the file\n
copy [file] [destination]  |\tmakes a copy of a file\n
ren [file] [new name]  |\trenames a file\n
move [file] [destination]  |\tmoves a file\n
del [file]  |\t deletes a file skipping confirmation\n
help [file]  |\tdisplays this help and exit"
#read arguments ..
ARG1=$1
ARG2=$2
ARG3=$3

#Chooses a specific set of operations 
case $ARG1 in
	#prints author info
	"author")
		echo Emmons, Ethan
		;;
	
	#prints file contents
	"type")
		cat $2
		;;
	
	#copys file
	"copy")
		cp $2 $3 1> /dev/null 2> /dev/null
		;;
	
	#renames file
	"ren")
		mv $2 $3 1> /dev/null 2> /dev/null
		;;

	"move")
		mv $2 $3 1> /dev/null 2> /dev/null
		;;

	#deletes file skipping confirmation
	"del")
		rm -f $2 1> /dev/null 2> /dev/null
		;;
	
	#outputs supported commands, action, and required parameters
	"help")
		echo -e $HELPOUTPUT
		;;

	#catch all other unsupported commands
	*)
		echo -e $HELPOUTPUT
		;;
esac

#successful escape code
exit 0


























