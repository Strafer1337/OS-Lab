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
    echo "Такого предмета не существует."
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
    echo "Такой группы не существует."
    read -p "Введите правильный номер группы: " group
    file=students/groups/$group
done
echo Номер группы: $group

surname_list=$(cat students/groups/$group)
for student in $surname_list
do
    egrep -h "^$group;$student.*[3-5]$" ./$dir/tests/* > $student.tmp
    student_mark=0
    while IFS=';' read -r gr name year points mark
    do        
        ((student_mark+=mark))
    done < $student.tmp
    echo $student_mark $student >> marks.tmp
    rm $student.tmp
done
sort -n -r marks.tmp > marks2.tmp

i=1
echo -e "\nУпорядоченный по успеваемости список студентов:\n"
while IFS=' ' read -r mark name 
do
    echo -e "$i. Имя: $name;\tОбщая сумма положительных оценок: $mark"
    ((i++))
done < marks2.tmp
rm *.tmp