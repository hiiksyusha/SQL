## База данных "Компьютерная фирма"


Схема БД состоит из четырех таблиц:<br/>
**Product**(maker, model, type)<br/>
**PC**(code, model, speed, ram, hd, cd, price)<br/>
**Laptop**(code, model, speed, ram, hd, price, screen)<br/>
**Printer**(code, model, color, type, price)<br/>
Таблица Product представляет производителя (maker), номер модели (model) и тип ('PC' - ПК, 'Laptop' - ПК-блокнот или 'Printer' - принтер). Предполагается, что номера моделей в таблице Product уникальны для всех производителей и типов продуктов. В таблице PC для каждого ПК, однозначно определяемого уникальным кодом – code, указаны модель – model (внешний ключ к таблице Product), скорость - speed (процессора в мегагерцах), объем памяти - ram (в мегабайтах), размер диска - hd (в гигабайтах), скорость считывающего устройства - cd (например, '4x') и цена - price (в долларах). Таблица Laptop аналогична таблице РС за исключением того, что вместо скорости CD содержит размер экрана -screen (в дюймах). В таблице Printer для каждой модели принтера указывается, является ли он цветным - color ('y', если цветной), тип принтера - type (лазерный – 'Laser', струйный – 'Jet' или матричный – 'Matrix') и цена - price.
____
#### В файле представлены решения задач 1-13,15-25
### 1
Найдите номер модели, скорость и размер жесткого диска для всех ПК стоимостью менее 500 дол. Вывести: model, speed и hd.

```SQL
SELECT model, speed, hd 
  FROM PC
  WHERE price < 500
```

### 2
Найдите производителей принтеров. Вывести: maker.

```SQL
SELECT DISTINCT maker 
  FROM product
  WHERE type = 'Printer'
```

### 3
Найдите номер модели, объем памяти и размеры экранов ПК-блокнотов, цена которых превышает 1000 дол.

```SQL
SELECT model, ram, screen 
  FROM laptop
  WHERE price > 1000
```

### 4
Найдите все записи таблицы Printer для цветных принтеров.

```SQL
SELECT * 
  FROM printer
  WHERE color = 'y'
```

### 5
Найдите номер модели, скорость и размер жесткого диска ПК, имеющих 12x или 24x CD и цену менее 600 дол.

```SQL
SELECT model, speed, hd 
  FROM PC
  WHERE (cd ='12x' or  cd = '24x') 
  AND price < 600
```

### 6
Для каждого производителя, выпускающего ПК-блокноты c объёмом жесткого диска не менее 10 Гбайт, найти скорости таких ПК-блокнотов. Вывод: производитель, скорость.

```SQL
SELECT DISTINCT product.maker, speed 
  FROM product 
    JOIN laptop 
    ON product.model = laptop.model
  WHERE laptop.hd >= 10

```

### 7
Найдите номера моделей и цены всех имеющихся в продаже продуктов (любого типа) производителя B (латинская буква).

```SQL
SELECT DISTINCT product.model, PC.price 
  FROM product 
    JOIN PC 
    ON product.model = PC.model
  WHERE product.maker = 'B'
    
UNION
SELECT DISTINCT product.model, laptop.price 
  FROM product 
    JOIN laptop 
    ON product.model = laptop.model
  WHERE product.maker = 'B'
    
UNION
SELECT DISTINCT product.model, printer.price 
  FROM product 
    JOIN printer 
    ON product.model = printer.model
  WHERE product.maker = 'B'
```

### 8
Найдите производителя, выпускающего ПК, но не ПК-блокноты.

```SQL
SELECT DISTINCT maker 
  FROM product
  WHERE type = 'pc'
  
EXCEPT
SELECT DISTINCT product.maker 
  FROM product
  WHERE type = 'laptop'
```

### 9
Найдите производителей ПК с процессором не менее 450 Мгц. Вывести: Maker.

```SQL
SELECT DISTINCT maker 
  FROM product 
    JOIN PC 
    ON PC.model = product.model
  WHERE speed >= 450
```

### 10
Найдите модели принтеров, имеющих самую высокую цену. Вывести: model, price.

```SQL
SELECT DISTINCT model, price 
  FROM printer
  WHERE price = (SELECT MAX(price) FROM printer)
```

### 11
Найдите среднюю скорость ПК.

```SQL
SELECT AVG(speed) 
  FROM pc
```

### 12
Найдите среднюю скорость ПК-блокнотов, цена которых превышает 1000 дол.

```SQL
SELECT AVG(speed) 
  FROM laptop
  WHERE price > 1000
```

### 13
Найдите среднюю скорость ПК, выпущенных производителем A.

```SQL
SELECT AVG(speed) 
  FROM PC 
    JOIN product ON
    product.model = PC.model 
  WHERE maker = 'A'
```

### 15
Найдите размеры жестких дисков, совпадающих у двух и более PC. Вывести: HD.

```SQL
SELECT hd 
  FROM PC 
  GROUP BY(hd) 
  HAVING COUNT(model) >=2
```

### 16
Найдите пары моделей PC, имеющих одинаковые скорость и RAM. В результате каждая пара указывается только один раз, т.е. (i,j), но не (j,i), Порядок вывода: модель с большим номером, модель с меньшим номером, скорость и RAM.

```SQL
SELECT DISTINCT p1.model, p2.model, p1.speed, p1.ram
  FROM pc p1, pc p2
  WHERE p1.speed = p2.speed
  AND p1.ram = p2.ram 
  AND p1.model > p2.model
```

### 17
Найдите модели ПК-блокнотов, скорость которых меньше скорости каждого из ПК. 
Вывести: type, model, speed.

```SQL
SELECT DISTINCT type, product.model, laptop.speed 
  FROM product 
    JOIN laptop 
      ON product.model = laptop.model
  WHERE laptop.speed < ALL(SELECT speed FROM PC)
```

### 18
Найдите производителей самых дешевых цветных принтеров. Вывести: maker, price.

```SQL
SELECT DISTINCT pro.maker, pri.price 
  FROM product pro 
   JOIN printer pri 
     ON pro.model = pri.model
  WHERE pri.color = 'y'  
  AND pri.price = (
    SELECT MIN(pri2.price)
      FROM printer pri2
      WHERE pri2.color = 'y'
      )
```

### 19
Для каждого производителя, имеющего модели в таблице Laptop, найдите средний размер экрана выпускаемых им ПК-блокнотов. 
Вывести: maker, средний размер экрана.

```SQL
SELECT pro.maker, AVG(lap.screen) 
  FROM product pro 
    JOIN laptop lap 
    ON pro.model = lap.model
  GROUP BY pro.maker
```

### 20
Найдите производителей, выпускающих по меньшей мере три различных модели ПК. Вывести: Maker, число моделей ПК.

```SQL
SELECT maker, COUNT(model)
  FROM product
  WHERE type = 'pc'
  GROUP BY product.maker
  HAVING COUNT(model) > 2
```

### 21
Найдите максимальную цену ПК, выпускаемых каждым производителем, у которого есть модели в таблице PC. 
Вывести: maker, максимальная цена.

```SQL
SELECT pro.maker, MAX(PC.price)
  FROM product pro 
    JOIN PC 
      ON pro.model = PC.model 
  GROUP BY pro.maker
```

### 22
Для каждого значения скорости ПК, превышающего 600 МГц, определите среднюю цену ПК с такой же скоростью. Вывести: speed, средняя цена.

```SQL
SELECT speed, AVG(price) 
  FROM PC
  WHERE speed > 600
  GROUP BY speed
```

### 23
Найдите производителей, которые производили бы как ПК
со скоростью не менее 750 МГц, так и ПК-блокноты со скоростью не менее 750 МГц.
Вывести: Maker.

```SQL
SELECT DISTINCT maker
  FROM product t1  
    JOIN pc t2 
      ON t1.model=t2.model
  WHERE speed>=750 
  AND maker IN (
    SELECT maker
      FROM product t1 
        JOIN laptop t2 
          ON t1.model=t2.model
      WHERE speed>=750 
  )
```

### 24
Перечислите номера моделей любых типов, имеющих самую высокую цену по всей имеющейся в базе данных продукции.

```SQL
WITH t1 AS (
  SELECT model, price 
    FROM pc
  UNION
  SELECT model, price 
    FROM Laptop
 UNION
 SELECT model, price 
  FROM Printer
),

t2 AS ( 
  SELECT price 
    FROM pc
  UNION
  SELECT price 
    FROM Laptop
  UNION
  SELECT price 
    FROM Printer) 

SELECT model 
  FROM t1 
  WHERE t1.price = (
    SELECT MAX(t2.price) 
      FROM t2
  )
```

### 25
Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker.

```SQL
SELECT DISTINCT maker
  FROM product
  WHERE model IN (
    SELECT model
      FROM pc
      WHERE ram = (
        SELECT MIN(ram)
          FROM pc
      )
    AND speed = (
      SELECT MAX(speed)
        FROM pc
        WHERE ram = (
          SELECT MIN(ram)
            FROM pc
        )
    )
  )
  AND maker IN (
    SELECT maker
      FROM product
      WHERE type='printer'
  )
```
