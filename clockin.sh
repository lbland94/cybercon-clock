#!/bin/bash
printf "Cybercon Username: "
read username
printf "Cybercon Password: "
stty -echo
# read password
CHARCOUNT=0
while IFS= read -p "$PROMPT" -r -s -n 1 CHAR
do
    # Enter - accept password
    if [[ $CHAR == $'\0' ]] ; then
        break
    fi
    # Backspace
    if [[ $CHAR == $'\177' ]] ; then
        if [ $CHARCOUNT -gt 0 ] ; then
            CHARCOUNT=$((CHARCOUNT-1))
            PROMPT=$'\b \b'
            password="${password%?}"
        else
            PROMPT=''
        fi
    else
        CHARCOUNT=$((CHARCOUNT+1))
        PROMPT='*'
        password+="$CHAR"
    fi
done
stty echo

curl -s -c ~/cookies.txt --data-urlencode "login=$username" --data-urlencode "password=$password" --data-urlencode 'submit=login' http://rams.hyson.com/welcome.asp > /dev/null
curl -s -b ~/cookies.txt --data-urlencode 'btnCheckIn=Check In' http://rams.hyson.com/employee_checkin.asp > ~/.loginlog/loggedin.html
if (( $(cat ~/.loginlog/loggedin.html | tr -d '\r\n' | grep -Eo "Your check in time .*" | sed -e 's/<[^>]*>//g' | wc -l) < 1 )); then
	echo "This probably didn't work; check rams.hyson.com ."
else
	cat ~/.loginlog/loggedin.html | tr -d '\r\n' | grep -Eo "Your check in time .*" | sed -e 's/<[^>]*>//g'
fi
