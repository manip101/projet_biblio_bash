del_userp1()
{
	userdel -r $1 2>/dev/null
	echo "$1 deleted successfully!"
	gid=`cat /etc/passwd | grep ^$1 | cut -d ":" -f 4`
	group=`cat /etc/group | grep :$gid: | cut -d ":" -f 1`
	log "DU:$(date):$1:$group"
}

del_user()
{
	if [ $# -eq 1 ]; then
		if [[ $1 = *".csv" ]]; then
			for user in `cat $1 | cut -d ";" -f 1`; do
	        	if [[ `cat /etc/passwd | grep ^$user 2>/dev/null` != "" ]]; then
	        		del_userp1 $user
	        	else
	        		echo "$user doesn't exist"
	        	fi
			done
		elif [[ `cat /etc/passwd | grep $1 2>/dev/null` != "" ]]; then
			del_userp1 $1
		else
			echo "Type de fichier non csv ou utilisteur n'existe pas"
			log "EF:$(date):$1"
		fi
	fi
}
