#!/bin/bash

echo "hello"
echo User Name: Lee Jin Woo
echo Student Number: 12172097
echo [ MENU ]
echo 1. Get the data of the movie identified by a specific \'movie id\' from \'u.item\'
echo 2. Get the data of action genre movies from \'u.item\'
echo 3. Get the average \'rating\' of the movie identified by specific \'movie id\' from \'u.data\'
echo 4. Delete the \'IMDb URL\' from \'u.item\'
echo 5. Get the data about users from \'u.user\'
echo 6. Modify the format of \'release date\' in \'u.item\'
echo 7. Get the data of movies rated by a specific \'user id\' from \'u.data\'
echo 8. Get the average \'rating\' of movies rated by users with \'age\' between 20 and 29 and \'occupation\' as \'programmer\'
echo 9. Exit
echo --------------------------
while true ; do
read -p "Enter your choice [ 1-9 ] " input
case $input in
	1)
		read -p "Please enter 'movie id' (1~1682): " movieid
		cat u.item | awk -F'|' -v temp="${movieid}" '$1 == temp {print;}'
	;;
	2)
		read -p "Do you want to get the data of 'action' genre movies from 'u.item'? (y/n) : " answer
       		if [ "y" == $answer ]; then
			i=1
			cat u.item | awk -F'|' -v temp=$i '$7 == 1 && temp < 11 {print $1, $2; temp++}'
		fi	
	;;
	3)
		read -p "Please enter 'movie id' (1~1682): " movieid
		sum=0
		cat u.data | awk -v movieid1="${movieid}" 'BEGIN {num=0} $2 == movieid1 {temp=temp+$3; num++} END {print "average rating of", movieid1, ":", temp/num}'
	;;
	4)
		read -p "Do you want to delete the 'IMDb URL' from 'u.item'? (y/n) : " answer
		if [ "y" == $answer ]; then
			cat u.item | awk -F'|' 'temp < 10 {temp++; print ;}' | sed -E 's/http.*\)/''/g'
		fi
	;;
	5)
		read -p "Do you want to get the data about users from 'u.user'? (y/n) : " answer
		if [ "y" == $answer ]; then
			cat u.user | awk -F'|' 'temp < 10 {temp++; print;}' | awk -F'|' '{print "user "$1, "is "$2, "years old", $3, $4}' | sed 's/M/male/g' | sed 's/F/female/g'
		fi
	;;
	6)
		read -p "Do you want to Modify the format of 'release data' in 'u.item'? (y/n) : " answer
		if [ "y" == $answer ]; then
			cat u.item | awk -F'|' ' $1 >= 1673 && $1 <= 1682 { print;}' | sed -E 's/([0-9]{2})(-)([a-zA-Z]{3})(-)([0-9]{4})/\5\3\1/' | 
			sed 's/Jan/01/g'|sed 's/Feb/02/g'|sed 's/Mar/03/g'|sed 's/Apr/04/g'|sed 's/May/05/g'|sed 's/Jun/06/g'|sed 's/Jul/07/g'|sed 's/Aug/08/g'|sed 's/Sep/09/g'|sed 's/Oct/10/g'|sed 's/Nov/11/g'|sed 's/Dec/12/g'
		fi
	;;
	7)	
		read -p "Please enter the 'user id' (1~943): " userid
		cat u.data | awk -v userid1="${userid}" '$1 == userid1 {print $2;}' | sort -n | tr '\n' '|'
		echo " "
		cat u.data | awk -v userid1="${userid}" '$1 == userid1 {print $2;}' | sort -n > output.txt
		outputline=$(cat output.txt);
		cat u.item | awk -F'|' -v outputline1="${outputline}" 'BEGIN {split(outputline1,arr)} {for(i in arr) {if(arr[i]==$1) print $1, $2}}'	
	;;
	8)
		read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'? (y/n) : " answer
		if [ "y" == $answer ]; then
			cat u.user | awk -F'|' '$2 >= 20 && $2 <= 29 && $4=="programmer" {print $1;}' > output.txt
			outputline=$(cat output.txt)
			cat u.data | awk -v outputline1="${outputline}" 'BEGIN {split(outputline1,arr)} {for(i in arr) {if(arr[i]==$1) print $2, $3}}' | sort -n | awk -v outputline1="${outputline}" 'BEGIN{split(outputline1,arr); movierating[$1]=0; count[$1]=0} {movierating[$1]+=$2; count[$1]+=1} END {for(i in movierating) print i " " (movierating[i]/count[i])}' | sort -n
		fi
	;;
	9)
		echo Bye!
		exit 0
	;;
esac
done
