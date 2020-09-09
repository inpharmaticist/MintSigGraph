#!/bin/bash

#Customize the lines below to your specs
notifylog=~/.cache/xfce4/notifyd/log
bisqlog=/home/corey/.local/share/Bisq/bisq.log
signalfrom=+11234567890
signalto=+10987654321


#Loop through each line of the notify log
while IFS= read -r line

    do

    if [[ "$line" == "" ]]
        then continue
        else array3+=("$line")
        fi

    done < $notifylog

#Look for a new notification using "["
#Then organize the info into a useful SMS
x=0
while [ $x -le "${#array3[@]}" ]

    do
        if [[ "${array3[x]:0:1}" == "[" ]]
            then array4+=("${array3[x+1]:9} ${array3[x]} ${array3[x+2]:8}- ${array3[x+3]:5}")
        fi

        x=$(( $x + 1 ))

    done

#Loop through each line of the Bisq log for "sendMEssage message." Not sure if this shows up when the mobile app isn't set up. Look into this...
#I was too lazy to formulate the message, so just did a certain number of characters. Depending on the length of the tradeID, some info gets cut off
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

#Is the message of interest already in the sentmessages doc? If so, don't send again
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

#Get rid of "\n" and replace it with a linebreak. There's probably a better way to do this but whatevs
            then breakermaker=("${array4[x]//"\n"/" 
"}")
            breakermaker=("${array4[x]//"\s"/"
"}")

            if [[ "$breakermaker" == *"Thunar"* ]] #I don't want messages if I just ejected a thumb drive.
                then dummy=1
                else #Send the message of interest and add to the sent doc
                     signal-cli -u $signalfrom send -m "$breakermaker" $signalto
            fi
                echo "${array4[x]}" >> sentmessages.txt                
                echo "$breakermaker"

        fi

    x=$(( $x + 1 ))

    done
    
