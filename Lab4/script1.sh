#!/bin/bash
if [ $# -lt 1 ]
then
    echo -e "Не заданы входные параметры для работы программы!\nЗапустите программу заново."
    exit
fi
group=$1

file=students/groups/$group
while [ ! -f "$file" ]
do 
    echo "Группа не указана или указана неверно."
    read -p "Введите правильный номер группы: " group
    file=students/groups/$group
done
echo Номер группы: $group

surname_list=$(cat students/groups/$group)
for student in $surname_list
do
    mark_list=$(egrep -c -h "^$group;$student.*2$" ./*/tests/*)
    f_count=0
    for i in $mark_list
    do
        ((f_count+=i))
    done
    echo "$student $f_count" >> all.tmp
done

max_f=0
while IFS=' ' read -r name f_count
do
    if [ $f_count -gt $max_f ]
    then
        max_f=$f_count
    fi
done < all.tmp 

subjects="Пивоварение
Криптозоология"
if [ $max_f -eq 0 ]
then
    echo "Ни один студент не имеет неудачных попыток!"
    exit
else
    echo -e "\nИнформация о студенте(-ах) с наибольшим количеством неудачных попыток:"
    while read -r name points
    do
        if [ $max_f -eq $points ]
        then
            curr_name=$name
            echo -e "\nИмя: $curr_name"
            echo "Группа: $group"
            echo "Общее количество неудач: $max_f"
            i=1
            while  read -r subj
            do
                egrep -h "^$group;$curr_name.*2$" ./$subj/tests/* > fs.tmp
                while IFS=';' read -r gr name year curr_points mark
                do
                    echo -e "$i. Год: $year;\n   Предмет: $subj;\n   Количество набранных баллов: $curr_points.   "
                    ((i++))
                done < fs.tmp 
            done <<< "$subjects"
        fi
    done < all.tmp
fi
rm *.tmp
