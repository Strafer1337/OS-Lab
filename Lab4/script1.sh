#!/bin/bash
dir=$1
group=$2

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

surname_list=$(cat students/groups/$group)
for student in $surname_list
do
    mark_list=$(egrep -c -h "^$group;$student.*2$" ./$dir/tests/*)
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
        max_f_student=$name
        max_f=$f_count
    fi
done < all.tmp 

if [ $max_f -eq 0 ]
then
    echo "Ни один студент не имеет неудачных попыток!"
    exit
else
    echo -e "\nИнформация о студенте с наибольши количеством неудачных попыток:\n"
    echo "Имя: $max_f_student"
    echo "Группа: $group"
    echo "Предмет: $dir"
    echo "Общее количество неудач: $max_f"
    egrep -h "^$group;$max_f_student.*2$" ./$dir/tests/* > fs.tmp
    i=1
    while IFS=';' read -r gr name year points mark
    do
        echo -e "$i. Год: $year;\n   Количество набранных баллов: $points."
        ((i++))
    done < fs.tmp 
fi
rm *.tmp
