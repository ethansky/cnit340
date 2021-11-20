#!/bin/bash
#Ethan Emmons
#Purpose: This script takes DOS commands and performs the UNIX equivalent.
#Last Revision Date:  11/5/21
#Variables:
#ARG1 = Command/mode
#ARG2 = Original file
#ARG3 = Destination/target file
HELPOUTPUT="author  |\toutputs the author of the script\n
type [file]  |\toutputs the contents of the file\n
copy [file] [destination]  |\tmakes a copy of a file\n
copy! [file] [destination]  |\tmakes a copy of a file and overwrites any existing file\n
ren [file] [new name]  |\trenames a file\n
ren! [file] [new name]  |\trenames a file and overwrites any existing file\n
move [file] [destination]  |\tmoves a file\n
move! [file] [destination]  |\tmoves a file and overwrite any existing file\n
chgrp [file] [group]  |\tchanges the group for a file
chperm [file] [perm]  |\tchanges the permissions for a file
firstlines [file] [lines]  |\tdisplays the first n lines of the file
lastlines [file] [lines]  |\tdisplays last n lines of the file
del [file]  |\t deletes a file skipping confirmation\n
help [file]  |\tdisplays this help and exit"
#read arguments ..
ARG1=${1,,} # converts to lower case
ARG2=$2
ARG3=$3
# FS=$(ls)
# for F in "${FS[@]}"; do echo "$F"; done



interactive(){
	PS3="Select a sorting option: "
	OLD_IFS=${IFS}
	IFS="
	"
	OPTIONS=(name age size)
	select OPTION in ${OPTIONS[@]}
	do
		case $OPTION in
			name)
				FILES=$(ls)
			;;

			age)
				FILES=$(ls --sort=time)
			;;

			size)
				FILES=$(ls --sort=size)
			;;
		esac
	break
	done
	PS3="Select an file: "
	select FILE in ${FILES[@]}
	do
		PS3="Select an option: "
		OPTIONS=(type copy ren del move help copy\! move\! ren\! chgrp chperm "first lines" "last lines")
		select OPTION in ${OPTIONS[@]}
		do
			IFS=${OLD_IFS}
			case $OPTION in 
				type)
					cat ./$FILE
				;;
				copy)
					read -p 'Enter the name for the copied file: ' FILE2
					copy ./$FILE ./$FILE2 1
				;;
				ren)
					read -p 'Enter the new file name: ' FILE2
					ren ./$FILE ./$FILE2 1
				;;
				del)
					del ./$FILE
				;;
				move)
					read -p 'Enter the directory the file should be moved into: ' DIR
					move ./$FILE ./$DIR 1
				;;
				help)
					help
				;;
				copy\!)
					read -p 'Enter the name for the copied file: ' FILE2
					copy ./$FILE ./$FILE2 0
				;;
				move\!)
					read -p 'Enter the directory the file should be moved into: ' DIR
					move ./$FILE ./$DIR 0
				;;
				ren\!)
					read -p 'Enter the new file name: ' FILE2
					ren ./$FILE ./$FILE2 0
				;;
				chgrp)
					read -p 'Enter the new group: ' GROUP
					chgrp ./$FILE $GROUP
				;;
				chperm)
					read -p 'Enter the new permissions in octal form: ' OCT
					chperm ./$FILE $OCT
				;;
				"first lines")
					read -p 'Enter the number of lines: ' NUM
					firstlines ./$FILE $NUM
				;;
				"last lines")
					read -p 'Enter the number of lines: ' NUM
					lastlines ./$FILE $NUM
				;;
			esac
			break
		done
		break
	done
}

checkf(){
	if [[ -f $1 ]]
	then
		echo "file"
	elif [[ -d $1 ]]
	then
		echo "dir"
	else
		echo "not found"
	fi
}

author(){
	#prints author info
	echo Emmons, Ethan
}

chgrp(){
	#assumes that the group exists
	if [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file or directory does not exist."
	else
		chgrp $1 $2
	fi
}

chperm(){
	if [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file or directory does not exist."
	else
		chmod $2 ./$1
	fi
}

firstlines(){
	if [[ $(checkf $1) == "directory" ]]
	then
		echo "The inputted file is a directory... aborting"
	elif [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file does not exist."
	else
		head -$2 ./$1
	fi
}

lastlines(){
	if [[ $(checkf $1) == "directory" ]]
	then
		echo "The inputted file is a directory... aborting"
	elif [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file does not exist."
	else
		tail -$2 ./$1
	fi
}

type(){
	#prints file contents
	typeset TYPE=$(checkf $1)
	if [[  $TYPE == "file" ]]
	then
		cat $1
		echo -e "\nUNIX command ran: cat $1\n"
	elif [[ $TYPE == "dir" ]]
	then
		echo "The inputted file is a directory."
	else
		echo "The inputted file does not exist."
	fi
}

copy(){
	#copys file
	if [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file or directory does not exist."

	elif [[ $(checkf $2) != "not found" && $3 != 0 ]]
		then
			echo "The target path already exists and would be overwritten... aborting."
	else
		if [[ $3 == 0 ]]
		#force is true
		then
			if [[ $(checkf $1) == "file" ]]
			then
				echo -e "\nUNIX command ran: cp -f $1 $2\n"
				cp -f $1 $2 1> /dev/null 2> /dev/null
				echo "The command was a success!"
			else
				echo -e "\nUNIX command ran: cp -f $1 $2\n"
				cp -Rf $1 $2 1> /dev/null 2> /dev/null
				echo "The command was a success!"
			fi
		else
		#force is false
			if [[ $(checkf $1) == "file" ]]
			then
				echo -e "\nUNIX command ran: cp $1 $2\n"
				cp $1 $2 1> /dev/null 2> /dev/null
				echo "The command was a success!"
			else
				echo -e "\nUNIX command ran: cp $1 $2\n"
				cp -R $1 $2 1> /dev/null 2> /dev/null
				echo "The command was a success!"
			fi
		fi
	fi
}

ren(){
	#renames file
	if [[ $(checkf $1) == "not found" ]]
	then
		echo "The inputted file or directory does not exist."
	
	elif [[ $(checkf $2) != "not found" && $3 != 0 ]]
	then
		echo "The target path already exists and would be overwritten... aborting."
	
	else
		if [[ $3 == 0 ]]
		#force is true
		then
			echo -e "\nUNIX command ran: mv -f $1 $2\n"
			mv -f $1 $2 1> /dev/null 2> /dev/null
			echo "The command was a success!"

		else
		#force is false
			echo -e "\nUNIX command ran: mv $1 $2\n"
			mv $1 $2 1> /dev/null 2> /dev/null
			echo "The command was a success!"
		fi
	fi
}

move(){
	#moves file
	if [[ $(checkf $1) == "not found" || $(checkf $2) == "not found" ]]
	then
		echo "The inputted file or directory does not exist."
	elif [[ $(checkf $2) == "file" ]]
	then
		echo "The target destination is not a directory. Aborting..."	
	elif [[ $(checkf $2/$1) != "not found"  && $3 != 0 ]]
	then
		echo "The target path already exists and would be overwritten... aborting."
	else
		if [[ $3 == 0 ]]
		#force is true
		then
			echo -e "\nUNIX command ran: mv -f $1 $2\n"
			mv -f $1 $2 1> /dev/null 2> /dev/null
			echo "The command was a success!"
		
		else
		#force is false
			echo -e "\nUNIX command ran: mv $1 $2\n"
			mv $1 $2 1> /dev/null 2> /dev/null
			echo "The command was a success!"
		fi
	fi
}

del(){
	#deletes file skipping confirmation
	if [[ $(checkf $1) == "file" ]]
	then
		echo -e "\nUNIX command ran: rm -f $1\n"
		rm -f $1 1> /dev/null 2> /dev/null
		echo "The command was a success!"

	elif [[ $(checkf $1) == "dir" ]]
	then
		echo -e "\nUNIX command ran: rm -rf $1\n"
		rm -rf $1 1> /dev/null 2> /dev/null
		echo "The command was a success!"

	else
		echo "The inputted file or directory does not exist."
	fi
}

help(){
	#outputs supported commands, action, and required parameters
	echo -e $HELPOUTPUT
}


#Chooses a specific set of operations 
case $ARG1 in
	#prints author info
	"author")
		author
		;;
	
	#prints file contents
	"type")
		type $2
		;;
	
	#copys file
	"copy")
		copy $2 $3 1
		;;

	#copys file and overwrites existing
	"copy!")
		copy $2 $3 0 
		;;
	
	#renames file
	"ren")
		ren $2 $3 1
		;;

	#renames file and overwrite existing
	"ren!")
		ren $2 $3 0
		;;

	#moves a file
	"move")
		move $2 $3 1
		;;

	#moves a file and overwrite existing
	"move!")
		move $2 $3 0
		;;

	#deletes file skipping confirmation
	"del")
		del $2 
		;;
	
	#changes the group of a file or directory
	"chgrp")	
		chgrp $2 $3
		;;

	#changes the permissions of a file
	"chperm")
		chperm $2 $3
		;;

	#displays first n lines of a file
	"firstlines")
		firstlines $2 $3
		;;

	#displays last n lines of a file
	"lastlines")
		lastlines $2 $3
		;;
	#outputs supported commands, action, and required parameters
	"help")
		help
		;;

	#catch all other unsupported commands
	*)
		interactive
		;;
esac

#successful escape code
exit 0


























