# Домашние работы

## Защита информации

## Распознавание образов

## Логическое программирование

### Установка Prolog

```
sudo apt-add-repository ppa:swi-prolog/stable
sudo apt-get update
sudo apt-get install swi-prolog
```
## Параллельное программирование

Используя стандартную библиотеку POSIX Threds запустить три потока. 1) Запуск потоков последовательно т.е. <поток 1> -> <поток 2> -> <поток 3> 2) Запуск потоков параллельно без обмена информацией или сигналами т.е. <поток 1> -> <поток 2> | <поток 1> -> <поток 3> 3) Запуск потоков параллельно с обменом информацией любым способом т.е. <поток 1> -> <поток 2> : <поток 1> -> <поток 3> При этом <поток 2> имеет право выводить на печать (окно терминала) только нечетные числа. <поток 3> только четные. Разрешается много раз создавать и уничтожать потоки (особенно в задании 1). Задача: Последовательно вывести все числа от 1 до 100 Пояснение: За выполнение каждого пункта начисляется по 10 баллов

Имеется 5 потоков. 2 потока из них условно называются пользователями, 2 - клиентами, 1 - сервером. На сервере есть база данных (переменная с целочисленным значением) в которой хранится баланс на общем счету пользователей. Каждый пользователь может добавить денег на счет, либо снять денег со счета. При этом он может послать серверу через клиент следующие команды: 1) заблокировать счет монопольно 2) прибавить денег на счет 3) снять деньги со счета 4) разблокировать счет Разрешается производить бухгалтерские операции только с заблокированным счетом. При этом если в момент блокировки второй пользователь захотел воспользоваться счетом ему должно быть в этом отказано, а после освобождения счета необходимо выслать ему уведомление, что счет свободен. Задача: Реализовать описанное выше. Примечания: Для имитации интерактивности разрешается использовать генератор случайных чисел на потоках-пользователях, чтобы они генерировали сообщения в случайной последовательности. 

Написать с использованием библиотеки стандарта MPI программу "Hello World!". Главный исполнитель должен получать от всех птоков сообщения Hello и печатать их на терминале. По окончанию получения сообщений от всех остальных потоков должен печатать сообщение от себя и завершаться. 

Используя интерфейс обмена данными MPI реализовать процедуру поиска выхода из лабиринта размерности N на N. Лабиринт хранится в текстовом файле. в первой строке файле хранятся числа N и K (размерность лабиринта и количество расчетных блоков по строкам и по столбцам соответственно), K кратно N. При этом расчетные блоки должны хранить лабиринт не целиком, а только отдельные его куски. В лабиринте могут находится следующие элементы: '.' - пустая клетка, '#' - стена, '*' - вход в лабиринт 'E' - выход из лабиринта Решением считается длина минимального маршрута перемещения в ходах и набор последовательных ходов, соединяющих место старта с местом финиша. Допустимые ходы - N (на одну клетку на север), S (на одну клетку на юг), E (на одну клетку на восток), W (на одну клетку на запад) 

## Операционные системы