#!/bin/bash

#Everything here is an exact copy of the sub.sh script, minus the sending of signal messages. I couldn't get the sentmessages.txt file to update without running as a subscript #n00b
#This prevents the notifications/messages already in the notify/bisq logs (that you may have already seen) from being sent.
#i.e. only notifications from after startup will be sent.
#Notes on individual sections can be seen in the sub.sh script

notifylog=~/.cache/xfce4/notifyd/log
bisqlog=/home/corey/.local/share/Bisq/bisq.log

while IFS= read -r line

    do

    if [[ "$line" == "" ]]
        then continue
        else array3+=("$line")
        fi

    done < $notifylog

x=0
while [ $x -le "${#array3[@]}" ]

    do
        if [[ "${array3[x]:0:1}" == "[" ]]
            then array4+=("${array3[x+1]:9} ${array3[x]} ${array3[x+2]:8}- ${array3[x+3]:5}")
        fi

        x=$(( $x + 1 ))

    done


while IFS= read -r line

do 

    if [[ "$line" == *"sendMessage message="* ]]
        then 

            count1=0
            while [ $count1 -le ${#line} ]

                do

                    if [[ "${line:count1:10}" == ", message=" ]]
                    then 

                        if [[ "$line" == *"Your offer with ID "* ]]; then array4+=("(Bisq) ${line:count1+10:37}..."); fi
                        if [[ "$line" == *"The deposit transaction for the trade with ID "* ]]; then array4+=("(Bisq) ${line:count1+10:67}..."); fi
                        if [[ "$line" == *"The trade with ID "* ]]; then array4+=("(Bisq) ${line:count1+10:38}..."); fi
                    fi

                count1=$(( $count1 + 1 ))

                done
    fi

done < $bisqlog


while IFS= read -r line

    do

        array5+=("$line")

    done < sentmessages.txt

x=0
while [ $x -le "${#array4[@]}" ]

    do

        y=0

showresult=1
        while [ $y -le "${#array5[@]}" ]

        

            do
                if [[ "${array4[x]}" == "${array5[y]}" ]]
                    then showresult=0
                fi

                y=$(( $y + 1 ))

            done

        if [[ "$showresult" = 1 ]]

            then breakermaker=("${array4[x]//"\n"/"
"}")


                echo "${array4[x]}" >> sentmessages.txt                
                echo "$breakermaker"

        fi

    x=$(( $x + 1 ))

    done
    
        

while true; do

bash sub.sh

    sleep 5 #I increase this to 60 unless I'm making changes and testing the code.

done
