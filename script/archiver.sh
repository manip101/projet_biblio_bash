arch_file()
{
	if [[ ! ( -d $1 ) ]]; then
		echo "Repertoire n'existe pas"
		arch_log "EAR:$(date):$1:Repertoire-non-existant"
	else
		tar -cf "/home/Archive/$1.tar" "$1"
		arch_log "AR:$(date):/home/Archive/$1.tar:$1"
		echo "$1 has been archived"
		rm -r $1
	fi
}

archiver_rep()
{
	if [ $# > 0 ]; then
		if [[ $# -eq 1 ]]; then
			if [[ $1 = *".txt" ]];then
				for line in `cat $1`; do
					arch_file $line	
				done
			elif [[ $1 = *".txt" && !( -f $1 ) ]]; then
				echo "Fichier non existant"
				arch_log "EAR:$(date):Fichier-non-existant"
			else
				arch_file $1
			fi
		else
			for (( i=1; i<=$#; i++ )); do
				arch_file ${!i}
			done
		fi
	else
		echo "Pas de repertoires precis"
	fi
}
