#!/bin/bash
if [ $# -lt 1 ]
then
    echo -e "Не заданы входные параметры для работы программы!\nЗапустите программу заново."
    exit
fi
dir=$1
group=$2

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

while IFS=' ' read -r name attendance
do
    count=0
    for ((i=1; i <= ${#attendance} ; i++))
    do
        if [ ${attendance:i-1:1} -eq 1 ]
        then
            ((count++))
        fi    
    done
    echo $count $name >> att1.tmp
done < ./$dir/$group-attendance
sort -n att1.tmp > att2.tmp

i=1
echo -e "\nУпорядоченный по посещению список студентов:\n"
while IFS=' ' read -r attendance name 
do
    echo -e "$i. Имя: $name;\tКоличество посещенных занятий:$attendance"
    ((i++))
done < att2.tmp
rm *.tmp

