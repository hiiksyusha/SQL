Задание 

Задача 1.
Условие: есть 3 таблицы:
Таблица 1 (содержит данные source A):
Date, Campaign, Ad, Impression, Click, Cost
Таблица 2 (содержит данные source B):
DateTime, Campaign, Ad, Impression, Click, Cost
Таблица 3 (содержит данные различных source):
Date, Source, Campaign, Ad, install, purchase

Задача: написать запрос, который объединил бы все 3 таблицы. Выводил поля за текущий месяц:
Date, Source, Campaign, Ad, SUM(Click), SUM(Cost), SUM(install), SUM(purchase)

Замечания:
sourse в таблице 3 может быть больше 2
пример поля date: '2021-05-01', пример поля datetime '2021-05-01 12:31:47'
Запрос может содержать UNION, но не должен являться единственным способом решения


Решая задачу я предполагала, что в таблица source A и source B лежат данные из источников А и В соответсвенно. В таблице source лежат данные данные из всех источников, при этом для конечного запроса я выбираю только строчки, для которых их разных таблиц совпали Date, Source, Campaign и Ad, так как иначе мы не сможем посчитать сумму и сами данные будут не объективные.

Мое первое решение было написано через оконные функции, потом я подумала и решила написать запрос без них и он, как и предполагалось, работает на порядок быстрее даже с небольшим набором данных. Поэтому решила оставить оба решения и привести сравнение :) 

Решение через оконные функции.

```SQL
WITH t1 AS (
	SELECT Source.Date, Source.Source, Source.Campaign, Source.Ad, Click, Cost, install, purchase from Source_A 
		JOIN Source 
			ON ((Source.Source = 'Source A') 
			AND (Source.Date = Source_A.Date) 
			AND (Source.Campaign = Source_A.Campaign) 
			AND (Source.Ad = Source_A.Ad))
	UNION
	SELECT Date, Source.Source, Source.Campaign, Source.Ad, Click, Cost, install, purchase from Source_B 
		JOIN Source
	    		ON (Source.Source = 'Source B') 
            		AND (Source.Date = date(Source_B.Datetime)) 
           		AND (Source.Campaign = Source_B.Campaign) 
            		AND (Source.ad = Source_B.Ad)) 

SELECT DISTINCT t1.Date,
t1.Source,
t1.Campaign,
t1.Ad,
SUM(Click) over (partition by t1.Date, t1.Source, t1.Campaign, t1.Ad) as SUM_Click,
SUM(Cost) over (partition by t1.Date, t1.Source, t1.Campaign, t1.Ad) as SUM_Cost,
SUM(install) over (partition by t1.Date, t1.Source, t1.Campaign, t1.Ad) as SUM_install,
SUM(purchase) over (partition by t1.Date, t1.Source, t1.Campaign, t1.Ad) as SUM_purchase
	FROM t1
	WHERE month(t1.Date) = month(CURDATE()) 
	AND year (t1.Date) = year(CURDATE());
```
Время выполнения: 0.01165000.

Решение через group by.

```SQL
SELECT Source.Date, Source.Source, Source.Campaign, Source.Ad, SUM(Click), SUM(Cost), SUM(install), SUM(purchase)
 FROM source
	JOIN source_A 
		ON (Source.Source = 'Source A') 
		AND (Source.Date = Source_A.Date) 
		AND (Source.Campaign = Source_A.Campaign) 
		AND (Source.Ad = Source_A.Ad)
	WHERE month(Source.Date) = month(CURDATE()) 
	AND year (Source.Date) = year(CURDATE())
	GROUP BY Source.Date, Source.Source, Source.Campaign, Source.Ad

UNION

SELECT Source.Date, Source.Source, Source.Campaign, Source.Ad, SUM(Click), SUM(Cost), SUM(install), SUM(purchase)
	FROM source
		JOIN source_B 
			ON (Source.Source = 'Source B') 
            		AND (Source.Date = date(Source_B.DateTime)) 
           		AND (Source.Campaign = Source_B.Campaign) 
            		AND (Source.Ad = Source_B.Ad)
		WHERE month(Source.Date) = month(CURDATE()) 
		AND year (Source.Date) = year(CURDATE())
		GROUP BY Source.Date, Source.Source, Source.Campaign, Source.Ad;
```

Время выполнения: 0.00242300.
    
