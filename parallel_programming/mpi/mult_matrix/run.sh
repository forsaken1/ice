mpicc main.c -o main.out
mpirun -np 8 ./main.out

# на каждую строку заводим поток
# первую матрицу разбить построчно
# каждый столбец пересылаем на строки (использовать операторы пересылки оьих групп)

# производстыенный процесс

#№2 производитель производит n единиц товара
#5 потребитель потребляет k единиц товара в сек.
#склад 1000 единиц товара. произвдод 5 ед. потреб 2 ед. тов.


#сбалансирвоать потребителя и производитель