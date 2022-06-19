check_user_group()
{
    user=$1
    pass=$2
    group=$3

    existsu=$(cat /etc/passwd | grep "^$user:" 2>/dev/null)
    existsg=$(cat /etc/group | grep "^$group:" 2>/dev/null)
    
    if [[ $user && $pass && $group && $existsu = "" && $existsg != "" ]]; then
            local ret="0" 
    else
    		local ret="1"
    		if [[ !($user) ]]; then
    			log "AU:$(date):$user:$groupe:No-user"
    		elif [[ !($pass) ]]; then
    			log "AU:$(date):$user:$groupe:No-pass"
    		elif [[ !($group) ]]; then
    			log "AU:$(date):$user:$groupe:No-group"
    		elif [[ $existsu ]]; then
    			log "AU:$(date):$user:$groupe:User-exists"
    		else
    			log "AU:$(date):$user:$groupe:!(Group-exists)"
    
		fi
    fi
    echo $ret
}
