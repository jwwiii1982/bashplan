#!/bin/bash

##------File Locations-------##
install="/home/${USER}/bp2/"
alleventslist="${install}alleventslist.log"
notedir="${install}notifications/"

##--------reuse------------##
#variables
retry="Would you like to try again? [y][n]"
dateline="${mchoice}/${dchoice}/${ychoice}"
evtline="${evtitle} - ${evdesc}"
inval="Invalid Choice"

#functions
correct () {
echo "Is this correct? [y][n]"
read cort
}

##--------Date Calc--------##

#-------Month--------##
#Month suppliments
#variables
mdial="Month [mm]"
monthformat="Invalid Format. Correct format is mm (i.e. 05)"
monthinvalid="Invalid Month. Pick between 01-12."

#functions
monthretry () {
echo "$retry"
read merchoice
if [ $merchoice == "y" ]
then
    monthcalc
else
    start
fi
}

#main month
monthcalc () {
echo "$mdial"
read mchoice
if [ ${#mchoice} -ne 2 ]
then
    echo "$monthformat"
    monthretry
else
    if [ $mchoice -lt 01 ] || [ $mchoice -gt 12 ]
    then
        echo "$monthinvalid"
        monthretry
    fi
fi
}

#---------Year-----------#
#Year Suppliments
#variables
ydial="Year [yyyy]"
yearformat="Invalid format. Correct format is yyyy (i.e. 1999)"

#functions
yearretry () {
echo "$retry"
	read yerchoice
	if [ $yerchoice == "y" ]
	then
		yearcalc
	else
		start
	fi
}

#Main Year
yearcalc () {
echo "$ydial"
read ychoice
if [ ${#ychoice} -ne 4 ]
then
    echo "$yearformat"
    yearretry
fi
}

#---------Day----------#
#Day Suppliments
#Variables
ddial="Day [dd]"
thirtyone=( 01 03 05 07 08 10 12 )
dayinvalid="Invalid Day"

#Functions
dayretry () {
echo "$retry"
read derchoice
if [ $derchoice == "y" ]
then
    daycalc
else
    start
fi
}

#Main Day
daycalc () {
echo "$ddial"
read dchoice
for num in ${thirtyone[@]}
do
	if [ $num -eq $mchoice ] && [ $dchoice -ge 01 ] && [ $dchoice -lt 32 ]
	then
		right="yes"
	fi
done

if [[ $right == "yes" ]]
then
	echo ""
elif [[ $right != "yes" ]] && [ $mchoice -ne 02 ] && [ $dchoice -ge 01 ] && [ $dchoice -lt 31 ]
then
	echo ""
elif [[ $right != "yes" ]] && [ $mchoice -eq 02 ] && [ $dchoice -ge 01 ] && [ $dchoice -lt 29 ]
then
	echo ""
elif [[ $right != "yes" ]] && [ $mchoice -eq 02 ] && [ $ychoice -eq 2024 ] && [ $dchoice -ge 01 ] && [ $dchoice -lt 30 ]
then
	echo ""
else
	echo "$dayinvalid"
    dayretry
fi	
}

##-----------Time Calc----------------##
#------Beginning Hour----------#
#bgh suppliments
#variables
bghdial="Beginning Hour"
hinvalid="Invalid Hour"

#functions
bghretry () {
echo "$retry"
read bherchoice
if [ $bherchoice == "y" ]
then
	bghcalc
else
	start
fi
}

#Main Beginning Hour
bghcalc () {
echo "$bghdial"
read bghour
if [ $bghour -gt 23 ]
then
    echo "$hinvalid"
    bghretry
fi
}

#-------Beginning Minutes----------#
#bgm suppliments
#variables
bgmdial="Beginning Minutes"
minvalid="Invalid Minutes"

#functions
bgmretry () {
echo "$retry"
read bmerchoice
if [ $bmerchoice == "y" ]
then
	bgmcalc
else
	start
fi
}

#Main Beginning Minutes
bgmcalc () {
echo "$bgmdial"
read bgmin
if [ $bgmin -gt 59 ]
then
    echo "$minvalid"
    bgmretry
fi
}

#-----------End Hour----------#
#edh suppliments
#variables
edhdial="End Hour"

#functions
edhretry () {
echo "$retry"
read eherchoice
if [ $eherchoice == "y" ]
then
	edhcalc
else
	start
fi 
}

#Main End Hour
edhcalc () {
echo "edhdial"
read edhour
if [ $edhour -gt 23 ]
then
    echo "hinvalid"
    edhretry
elif [ $edhour -lt $bghour ]
then
    echo "The End Hour can't be less than the Beginning Hour"
    edhretry
fi
}

#---------End Minutes---------#
#edm suppliments
#variables
edmdial="End Minutes"

#functions
edmretry () {
echo "$retry"
read emerchoice
if [ $emerchoice == "y" ]
then
	edmcalc
else
	start
fi    
}

#Main End Minutes
edmcalc () {
echo "edmdial"
read edmin
if [ $edmin -gt 59 ]
then
    echo "minvalid"
    edmretry
elif [ $bghour -eq $edhour ] && [ $edmin -lt $bgmin ]
then
    echo "The End Minutes can't be less than the Beginning Minutes in this situation."
    edmretry
fi
}

##------Events Title & Descriptions--------##
#Ev Title & Desc suppliment
#functions


evtcalc () {
echo "Event Title"
read evtitle
}

evdcalc () {
echo "Event Description"
read evdesc
}

eventcheck () {
correct
if [ $cort == "n" ]
then
   echo "$retry"
		read cerchoice
		if [ $cerchoice == "y" ]
		then
			crevents
		else
			start
		fi
fi
}

##-----------Notifications----------##
#notechoice
notechoice () {
echo "Would you like to add a notification? [y][n]"
read nchoice
if [[ $nchoice == "y" ]]
then
    notify
else
    start
fi
}

#Create Notifications
#notify suppliments
#functions
noteread () {
cat << EOF | tee -a ${notedir}${nychoice}${nmchoice}${ndchoice}${nbghour}${nbgmin}.txt
---------------------------
(${nychoice}/${nmchoice}/${ndchoice} ${nbghour}:${nbgmin} n${nvar})
${evread}
---------------------------
EOF
}

notify () {
notemonthcalc
notedaycalc
noteyearcalc
notebghcalc
notebgmcalc
noteid
noteread
echo -e "Your notification has been created\n"
start
}


#--------Notificaiton Date & Time Functions-------#
#----------Note Month------------#
#NM suppliments
#variables

#functions
notemonthretry () {
	echo "$retry"
	read nmerchoice
	if [ $nmerchoice == "y" ]
	then
		notemonthcalc
	else
		start
	fi
}

#Main Note Month
notemonthcalc () {
echo "$mdial"
read nmchoice
if [ ${#nmchoice} -ne 2 ]
then
    echo "$monthformat"
    notemonthretry
else
    if [ $nmchoice -lt 01 ] || [ $nmchoice -gt 12 ]
    then
        echo "$monthinvalid"
        notemonthretry
    fi
fi
}

#-----------Note Day-------------------#
#ND suppliments
#variables

#functions
notedayretry () {
echo "$retry"
read nderchoice
if [ $nderchoice == "y" ]
then
    notedaycalc
else
    start
fi
}

#Main Note Day
notedaycalc () {
echo "$ddial"
read ndchoice
for num in ${thirtyone[@]}
do
	if [ $num -eq $nmchoice ] && [ $ndchoice -ge 01 ] && [ $ndchoice -lt 32 ]
	then
		right="yes"
	fi
done

if [[ $right == "yes" ]]
then
	echo ""
elif [[ $right != "yes" ]] && [ $nmchoice -ne 02 ] && [ $ndchoice -ge 01 ] && [ $ndchoice -lt 31 ]
then
	echo ""
elif [[ $right != "yes" ]] && [ $nmchoice -eq 02 ] && [ $ndchoice -ge 01 ] && [ $ndchoice -lt 29 ]
then
	echo ""
elif [[ $right != "yes" ]] && [ $nmchoice -eq 02 ] && [ $nychoice -eq 2024 ] && [ $ndchoice -ge 01 ] && [ $ndchoice -lt 30 ]
then
	echo ""
else
	echo "$dayinvalid"
    notedayretry
fi	
}

#--------Note Year----------#
#NY suppiments
#variables
noteyearretry () {
echo "$retry"
	read nyerchoice
	if [ $nyerchoice == "y" ]
	then
		noteyearcalc
	else
		start
	fi
}
#functions

#Main Note Year
noteyearcalc () {
echo "$ydial"
read nychoice
if [ ${#nychoice} -ne 4 ]
then
    echo "$yearformat"
    noteyearretry
fi
}

#-----------Note Beg Hour------#
#NBH suppliments
#variables

#functions
notebghretry () {
echo "$retry"
read nbherchoice
if [ $nbherchoice == "y" ]
then
	notebghcalc
else
	start
fi
}

#Main Note Beginnning Hour
notebghcalc () {
echo "$bghdial"
read nbghour
if [ $nbghour -gt 23 ]
then
    echo"$hinvalid"
    bghretry
fi
}

#-------Note Beg Minutes--------#
#NBM suppliments
#variables

#functions
notebgmretry () {
echo "$retry"
read nbmerchoice
if [ $nbmerchoice == "y" ]
then
	notebgmcalc
else
	start
fi
}

#Main Beginning Minutes
notebgmcalc () {
echo "$bgmdial"
read nbgmin
if [ $nbgmin -gt 59 ]
then
    echo "$minvalid"
    notebgmretry
fi
}

##----------File Creation-------------##
#File Create suppliments
#variables

#Event ID
evid () {
evidfile="${install}.evid.file"
elast=$(tail -n -1 $evidfile)
var=$(expr $elast + 1)
echo "$var" >> $evidfile
}

#Notification ID
noteid () {
noteidfile="${install}.noteid.file"
nlast=$(tail -n 1 $noteidfile)
nvar=$(expr $nlast + 1)
echo "${nvar}" >> $noteidfile
}

##-----------View/Search-----------------##
#---------Events---------#
#functions
moreve () {
echo "Would you like to see more events?"
read morevachoice
if [ $morevachoice == "y" ]
then
	viewev
else
	start
fi
}

searchevents () {
echo "What is your search term?"
read sterm
grep "$sterm" $alleventslist
}

#-------Notifications-------#
#functions
searchnote () {
echo "What is your search term"
read nterm
nsearch="$(grep -rwl $notdir -e "$nterm")"
cat $nsearch
}

vninvalid () {
echo "Invalid Choice"
viewnote
}

morenote () {
echo "Would you like to see more events?"
read morevnchoice
if [ $morevnchoice == "y" ]
then
	viewnote
else
	start
fi
}
##---------Choices---------##

start () {
cat << EOF
Please select a task:
[1]Calendar
[2]Create an Event
[3]Add a notification for event
[4]View/Search Events
[5]View/Search Notifications
[6]Delete events or notifications
EOF
read choice
if [ $choice -eq 1 ]
then
    cal
    anothercal
elif [ $choice -eq 2 ]
then
    crevents
elif [ $choice -eq 3 ]
then
    addnote
elif [ $choice -eq 4 ]
then
    viewev
elif [ $choice -eq 5 ]
then
    viewnote
elif [ $choice -eq 6 ]
then
    delevent
fi
}

anothercal () {
echo "Would you like to see another calendar? [y][n]"
read calchoice
if [ $calchoice == "y" ]
then
    calendar
else
    start
fi
}

calendar () {
    monthcalc
    yearcalc
    cal $mchoice $ychoice
    anothercal
}

crevents () {
echo "Is this an all day event? [y][n]"
read allday
if [ $allday == "y" ]
then
    monthcalc
    daycalc
    yearcalc
    evtcalc
    evdcalc
    echo "${mchoice}/${dchoice}/${ychoice} All Day ${evtitle} - ${evdesc}"
    eventcheck
    evid
    evallread="${ychoice}/${mchoice}/$dchoice 00All Day: ${evtitle} - ${evdesc} e${var}"
    echo "$evallread" | tee -a $alleventslist
    noteid
cat << EOF >> ${notedir}${ychoice}${mchoice}${dchoice}0800.txt
---------------------------
(${ychoice}/${mchoice}/${dchoice} 08:00 n${nvar})
$evallread
---------------------------
EOF
echo "This Event has been create and a notification has been created for the same day at 08:00."
start
elif [ $allday == "n" ]
then
    monthcalc
    daycalc
    yearcalc
    evtcalc
    evdcalc
    bghcalc
	bgmcalc
	edhcalc
	edmcalc
    echo "${mchoice}/${dchoice}/${ychoice} ${bghour}:${bgmin}-${edhour}:${edmin} ${evtitle} - ${evdesc}"
    eventcheck
	evid
    evread="${ychoice}/${mchoice}/${dchoice} at ${bghour}:${bgmin}-${edhour}:${edmin} ${evtitle} - ${evdesc} e${var}"
    echo "$evread" | tee -a $alleventslist
    echo "This Event has been created."
    notechoice
else
    start
fi
}

addnote () {
cat << EOF
[1]Enter Event ID (i.e. e600)
[2]Search for Event
[3]back to start
EOF
read seventchoice
if [ $seventchoice -eq 1 ]
then
	echo "Event ID"
	read eventid
elif [ $seventchoice -eq 2 ]
then
	searchevents
	addnot
elif [ $seventchoice == 3 ]
then
    start
fi
evread="$(grep "$eventid" /home/wes/bashplan/alleventslist.log)"
echo "When would you like to make the notification for."
notify
}

viewev () {
cat << EOF
What would Events would you like to view?
[1] All Today's events
[2] Another day's events
[3] Search for an event
[4] See all events
[5] back to start
EOF
read vechoice
if [ $vechoice -eq 1 ]
then
	grep $(date +"%Y/%m/%d") $alleventslist
    echo ""
	moreve
elif [ $vechoice -eq 2 ]
then
	monthcalc
    daycalc
	yearcalc
	grep "$(date +"%Y/%m/%d" -d ${mchoice}/${dchoice}/${ychoice})" $alleventslist
    echo ""
	moreve
elif [ $vechoice -eq 3 ]
then
	searchevents
    echo ""
	moreve
elif [ $vechoice -eq 4 ]
then
	cat $alleventslist | sort
	echo ""
    moreve
elif [ $vachoice -eq 5 ]
then
	start
else
	echo "inval"
    viewev
fi
}

viewnote () {
cat << EOF
What notifications would you like to view?
[1]Today's notifications
[2]Another day's notifications
[3]All notifications
[4]Back to start
EOF
read viewnotechoice
nonote="no notifications\n"
if [[ $viewnotechoice -eq 1 ]]
then
    todaynote="${notedir}$(date +"%Y%m%d")*.txt"
    if [ -f $todaynote ]
    then
        cat $todaynote
        echo ""
    else
        echo -e "$nonote"
    fi
    morenote
elif [[ $viewnotechoice -eq 2 ]]
then
    monthcalc
    daycalc
    yearcalc
    specdate="${notedir}$(date +"%Y%m%d" -d ${mchoice}/${dchoice}/${ychoice})*"
    if [ -f $specdate ]
    then
        cat $specdate
    else
        echo "nonote"
    fi
    morenote
elif [[ $viewnotechoice -eq 3 ]]
then
    if [ ${#notedir[@]} ]
    then
        echo ""
        cat ${notedir}*
        echo ""
    else
        echo -e "$nonote"
    fi
    morenote
elif [[ $viewnotechoice -eq 4 ]]
then
    start
else
    vninvalid
fi
}

delevent () {
cat << EOF
BashPlan cannot currently automatically delete events or notifications. 
You can delete events manually by going to the "alleventslist.log" file in the BashPlan folder location (you set this up on the install).
You can delete notifications manually, by deleting or altering the files in the Notifications folder located in the BashPlan folders. Notification folders are named as the date 20210418 and the notification time 0800 - 202104180800.txt would contain notification(s) for April 18, 2021 at 08:00.
I'm working on this to become available in the future.
EOF
}

start
