list_users()
{
	for line in `cat /etc/passwd | grep -E "/bin/bash|/bin/sh"`; do
		user=`echo $line | cut -d ":" -f 1`
		group=`groups $user | cut -d ":" -f 2 | sed "s/ //"`
		echo "User: $user || Groups: $group"
	done
}

utilisateur1()
{
	if [[ $1 && $2 && $3 ]]; then
		valid=$(check_user_group $1 $2 $3)
		if [[ $valid = "0" ]]; then
			useradd -m -G $3 $1
			echo "$1:$2" | chpasswd 2>/dev/null
			echo "Added $1 successfully!"
			log "AU:$(date):$1:$3"
		else
			echo "Error creating user $1"
		fi
	else
		echo "Arguments non valides"
	fi
}

ajouter_utilisateur()
{
	if [ $# -eq 1 ]; then
		if [[ $1 = *".csv" && -f $1 ]]; then
			for line in `cat $1`; do
				line=`echo $line | sed "s/;/ /g"`
				utilisateur1 $line
			done
		else
			if [[ !( -f $1 ) && $1 = *".csv" ]]; then
				echo "Fichier n'existe pas"
				log "EF:$(date):$1"
			else
				echo "Erreur dans l'un des champs"
			fi
		fi
	else
		utilisateur1 $1 $2 $3
	fi
}
