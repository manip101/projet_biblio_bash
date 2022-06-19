
is_root()
{
	local retval='1'
	for line in `cat /etc/group | grep ^root | cut -d ":" -f 4`; do
		if [[ $line = *"$1"* ]]; then
			local retval='0'
		fi
	done
	echo $retval
}

admin()
{
	while true
	do
		clear
		echo -e "Menu de navigation\n1-Add user: adduser *\n2-Add group: addgroup *\n3-List users: listusers\n4-Delete user: deleteuser *\n5-Delete group: deletegroup\n4-Archiver repertoire: archiverep *\n"
		read -p "projet# " com
		args=`echo $com | awk '{$1= ""; print $0}' | sed "s/ //"`

		if [[ $com = "adduser"* ]]; then
			ajouter_utilisateur $args
		elif [[ $com = "addgroup"* ]]; then
			ajouter_groupe $args
		elif [[ $com = "listusers"* ]]; then
			list_users
		elif [[ $com = "deleteuser"* ]]; then
			del_user $args
		elif [[ $com = "deletegroup"* ]]; then
			del_group $args
		elif [[ $com = "archiverep"* ]]; then
			archiver_rep $args
		elif [[ $com = "exit" ]]; then
			exit 0
		else
			echo `$com`
		fi
		read -p "Press enter to continue..." tmp
	done
}

normal()
{
	while true
	do
		read -p "projet$ " com
		if [[ $com = 'quit' || $com = 'exit' ]]; then
			exit 0
		else
			echo `sudo -u $1 $com`
		fi
	done
}

login()
{
	read -p "Username: " user 
	read -sp "Password: " pass
	for line in `cat /etc/shadow`; do
	        if [[ $line = *"$user"* ]]; then
	        		salt=`echo $line | cut -d "$" -f 3`
	        		if [[ `mkpasswd -m SHA-512 $pass $salt` = `echo $line | cut -d ":" -f 2` ]]; then
	        			root=$(is_root $user)
	        			if [[ $root = "0" ]]; then
	        				echo -e "\n"
							admin
	        			else
	        				echo -e "\n"
	        				normal $user
	        			fi
	        		fi
	        fi
	done
	echo -e "\nInvalid creds"
}
