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

while IFS=' ' read -r name attendance
do
    len=${#attendance}
    echo $attendance >> att.tmp
done < $dir/$group-attendance

row_cnt=1
while [ $row_cnt -le $len ]
do
    sum=0
    while read -r str
    do
        if [ ${str:$row_cnt-1:1} -eq 1 ]
        then
            ((sum++))
        fi   
    done < att.tmp 
    echo $sum $row_cnt >> row.tmp    
    ((row_cnt++))
done
sort -n -r row.tmp > row1.tmp

read -r max_num lesson <<< "$(head -n 1 row1.tmp)"
res=''
while read -r num lesson
do
    if [ $max_num == $num ]
    then
        res+="$lesson "
    fi
done < row1.tmp
rm *.tmp
echo -e "\nИнформация о максимальной посещаемости:\n"
echo "Максимальное количество студентов на одном занятии: $max_num"
echo "Номера занятий с максимальной помещаемостью: $res"
