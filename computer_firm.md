## База данных "Компьютерная фирма"


Схема БД состоит из четырех таблиц:<br/>
**Product**(maker, model, type)<br/>
**PC**(code, model, speed, ram, hd, cd, price)<br/>
**Laptop**(code, model, speed, ram, hd, price, screen)<br/>
**Printer**(code, model, color, type, price)<br/>
Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price (в долларах). Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.
____
### 1
Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd.

```SQL
select model, speed, hd from PC
where price < 500
```

### 2
Найдите производителей принтеров. Вывести: maker.

```SQL
Select distinct maker from product
where type = 'Printer'
```

### 3
Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

```SQL
Select model, ram, screen from laptop
where price > 1000
```

### 4
Найдите все записи таблицы Printer для цветных принтеров.

```SQL
Select * from printer
where color = 'y'
```

### 5
Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.

```SQL
Select model, speed, hd from PC
where (cd ='12x' or  cd = '24x') and price < 600
```

### 6
Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

```SQL
Select distinct product.maker, speed from product join laptop on product.model = laptop.model
where laptop.hd >= 10

```

### 7
Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

```SQL
Select distinct product.model, PC.price from product join PC on product.model = PC.model
where product.maker = 'B'
union
Select distinct product.model, laptop.price from product join laptop on product.model = laptop.model
where product.maker = 'B'
union
Select distinct product.model, printer.price from product join printer on product.model = printer.model
where product.maker = 'B'
```

### 8
Найдите производителя, выпускающего ПК, но не ПК-блокноты.

```SQL
Select distinct maker FROM product
where type = 'pc'
except
Select distinct product.maker FROM product
Where type = 'laptop'
```

### 9
Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker.

```SQL
Select distinct maker from product join PC on PC.model = product.model
where speed >= 450
```

### 10
Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price.

```SQL
Select distinct model, price from printer
where price = (select max(price) from printer)

```

### 11
Найдите среднюю скорость ПК.

```SQL
Select avg(speed) from pc
```

### 12
Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

```SQL
Select avg(speed) from laptop
where price > 1000
```
