ajouter_groupe()
{	
	existsg=`cat /etc/group | grep $group 2>/dev/null`

	if [[ $existsg != "" ]]; then
		echo "Groupe existe deja"
		log "EG:$(date):$1:Groupe-existe"
	else
		groupadd $1
		echo "$1 has been created!"
		log "AG:$(date):$1"
	fi
}

del_group()
{
	if [[ `cat /etc/group | cut -d ":" -f 1 | grep $1 2>/dev/null` != "" ]]; then
		for member in `cat /etc/group | grep ^$1: | cut -d ":" -f 4 | sed "s/,/\n/g"`; do 
			del_user $member
		done
		groupdel $1
		echo "$1 has been deleted"
		log "DG:$(date):$1" 
	else
		echo "Group doesn't exist"
		log "EG:$(date):$1:!(Groupe-existe)"
	fi
}
