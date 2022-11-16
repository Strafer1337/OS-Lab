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
    echo "Предмет указан неверно."
    read -p 'Введите правильный код предмета: ' dir
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
    echo "Группа не указана или указана неверно."
    read -p "Введите правильный номер группы: " group
    file=students/groups/$group
done
echo Номер группы: $group

surname_list=$(cat students/groups/$group)

if [ $# -lt 3 ]
then
    echo -e "\nФамилия студента не указана.\nСписок группы:"
    echo -e "$surname_list\n"
    read -p "Введите фамилию студента: " surname
fi

fl=0
while [ $fl -eq 0 ]
do
    for student in $surname_list
    do
        if [[ $student =~ "$surname"[A-Z].* ]]
        then
            fl=1
        fi
    done
    if [ $fl -eq 0 ] 
    then
        echo "Фамилия студента указана неверно."
        read -p "Введите фамилию студента: " surname
    fi
done

student=$(egrep -i -m 1 "$surname" $dir/$group-attendance)
read -r name attendance <<< "$student"
missed=''
for ((i=1; i <= ${#attendance} ; i++))
do
    if [ ${attendance:i-1:1} -eq 0 ]
    then
        missed+="$i "
    fi    
done
echo -e "\nИнформация о пропущенных занятиях:"
echo "Имя: $name"
echo "Номера пропущенных занятий: $missed"

