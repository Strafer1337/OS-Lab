#!/bin/bash
if [ $# -lt 1 ]
then
    echo -e "Не заданы входные параметры для работы программы!\nЗапустите программу заново."
    exit
fi
dir=$1
group=$2
surname=$3

while [ "$dir" != "p" -a "$dir" != "c" ]
do
    echo "Такого предмета не существует."
    read -p 'Введите код правильного предмета: ' dir
done
if [ $dir == "p" ]
then
    dir=Пивоварение
    echo Предмет: $dir
elif [ $dir == "c" ]
then
    dir=Криптозоология
    echo Предмет: $dir
fi

file=students/groups/$group
while [ ! -f "$file" ]
do 
    echo "Такой группы не существует."
    read -p "Введите правильный номер группы: " group
    file=students/groups/$group
done
echo Номер группы: $group

student=$(egrep -i "$surname" $dir/$group-attendance)
while [ -z "$student" ]
do
    echo "Такого студента нет."
    read -p 'Введите фамилию: ' surname
    student=$(egrep -i $surname $dir/$group-attendance)
done
read -r name attendance <<< "$student"
missed=''
for ((i=1; i <= ${#attendance} ; i++))
do
    if [ ${attendance:i-1:1} -eq 0 ]
    then
        missed+="$i "
    fi    
done
echo -e "\nИнформация о пропущенных занятиях:\n"
echo "Имя: $name"
echo "Номера пропущенных занятий: $missed"

