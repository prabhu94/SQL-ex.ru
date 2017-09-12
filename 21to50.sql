-- Q21
SELECT maker,max(pc.price) FROM pc,product WHERE product.model=pc.model GROUP BY maker;

-- Q22
SELECT speed,avg(price) FROM pc WHERE speed>600 GROUP BY speed

-- Q23
SELECT pd.maker FROM product pd , pc WHERE pd.model = pc.model AND pc.speed > = 750

intersect
SELECT pd.maker FROM product pd ,laptop lp WHERE pd.model = lp.model AND lp.speed > = 750

-- Q24
SELECT model FROM
(
SELECT model,price FROM pc WHERE price = (SELECT max(price) FROM pc)
UNION
SELECT model,price FROM laptop WHERE price = (SELECT max(price) FROM laptop)
UNION
SELECT model,price FROM printer WHERE price = (SELECT max(price) FROM printer)
) AS ab
WHERE price = 
(SELECT max(price) FROM
(
SELECT model,price FROM pc WHERE price = (SELECT max(price) FROM pc)
UNION
SELECT model,price FROM laptop WHERE price = (SELECT max(price) FROM laptop)
UNION
SELECT model,price FROM printer WHERE price = (SELECT max(price) FROM printer)
) AS abc) ;

-- Q25
SELECT DISTINCT maker FROM product WHERE model in (SELECT model FROM pc WHERE speed = (SELECT max(speed) FROM pc WHERE ram  = (SELECT min(ram) FROM pc)) AND ram = (SELECT min(ram) FROM pc)) AND maker in (SELECT maker FROM product WHERE type in ('PC','Printer') GROUP BY maker having count(DISTINCT type) = 2);

-- Q26
SELECT avg(price) FROM (SELECT maker,coalesce(price,0)  AS price FROM product pd, laptop lp  WHERE lp.model = pd.model AND maker = 'A'
UNION all
SELECT maker,coalesce(price,0)AS price FROM product pd, pc  WHERE pc.model = pd.model AND maker = 'A') x ;

-- Q27
with maker_list AS (SELECT maker FROM product WHERE type in ('Printer','PC') GROUP BY maker having count(DISTINCT type)=2)
SELECT ml.maker,avg(hd) FROM product pd, pc pr,maker_list ml WHERE pr.model = pd.model  AND pd.maker = ml.maker GROUP BY ml.maker

-- Q28
SELECT trunc(sum(coalesce(b_vol,0))/count(DISTINCT q_id),2) FROM utq left join utb on utq.q_id = utb.b_q_id

-- Q29
SELECT i.point,i.date,i.inc,o.out FROM income_o i  left join outcome_o o on  i.point = o.point AND i.date = o.date 
UNION
SELECT o.point,o.date,i.inc,o.out FROM outcome_o o left join income_o i on  o.point = i.point AND o.date = i.date 

-- Q30
with inc_data AS (SELECT point,date,sum(inc) AS inc FROM income GROUP BY point,date),
out_data AS(
SELECT point,date,sum(out) AS out FROM outcome GROUP BY point,date)
SELECT i.point,i.date,o.out,i.inc FROM inc_data i left join out_data o on i.point = o.point AND i.date = o.date
UNION
SELECT o.point,o.date,o.out,i.inc FROM out_data o left join inc_data i on o.point = i.point AND o.date = i.date

-- Q31
SELECT clASs,country FROM clASses WHERE bore>=16

-- Q32
SELECT c.country,round(avg(power(c.bore,3)/2)::numeric, 2) FROM (SELECT Ships.name, Ships.clASs FROM Ships inner join ClASses ON Ships.clASs = ClASses.clASs
UNION 
SELECT Outcomes.ship, ClASses.clASs FROM Outcomes inner join  ClASses ON Outcomes.ship = ClASses.clASs) s join clASses c on c.clASs = s.clASs GROUP BY c.country

-- Q33
SELECT o.ship FROM outcomes o WHERE o.battle = 'North Atlantic' AND lower(o.result) = 'sunk'

-- Q34
SELECT name FROM ships s, clASses c WHERE c.clASs = s.clASs AND launched>1921 AND displacement > 35000 AND type = 'bb' AND launched is not null;

-- Q35
SELECT model,type FROM product WHERE model ~ '^[A-Za-z]+$' or model ~ '^[0-9]+$'

-- Q36
SELECT x.name FROM(
SELECT Ships.name FROM Ships inner join ClASses ON Ships.clASs = ClASses.clASs WHERE ships.name = ships.clASs
UNION 
SELECT Outcomes.ship FROM Outcomes inner join  ClASses ON Outcomes.ship = ClASses.clASs WHERE outcomes.ship = clASses.clASs) x

-- Q37
SELECT x.clASs FROM (SELECT ships.name AS name,Ships.clASs FROM Ships inner join ClASses ON Ships.clASs = ClASses.clASs
UNION 
SELECT outcomes.ship AS name,ClASses.clASs FROM Outcomes inner join  ClASses ON Outcomes.ship = ClASses.clASs) x GROUP BY x.clASs having count(*) = 1

-- Q38
SELECT country FROM clASses WHERE type in ('bb','bc') GROUP BY country having count(DISTINCT type) =  2

-- Q39
with a AS (SELECT * FROM outcomes o join battles b on o.battle=b.name)SELECT DISTINCT a1.ship FROM a a1, a a2 WHERE a1.ship=a2.ship AND a1.result='damaged'AND a1.date<a2.date

-- Q40
SELECT s.clASs,s.name,c.country FROM ships s, clASses c WHERE s.clASs = c.clASs AND c.numguns>=10

-- Q41
with codeval AS (SELECT code FROM pc WHERE code = (SELECT max(code) FROM pc))
SELECT 'cd',cd::text FROM pc,codeval c WHERE c.code = pc.code
UNION
SELECT 'hd',hd::text FROM pc,codeval c WHERE c.code = pc.code
UNION
SELECT 'model',model::text FROM pc,codeval c WHERE c.code = pc.code
UNION
SELECT 'price',price::text FROM pc,codeval c WHERE c.code = pc.code
UNION
SELECT 'ram',ram::text FROM pc,codeval c WHERE c.code = pc.code
UNION
SELECT 'speed',speed::text FROM pc,codeval c WHERE c.code = pc.code

-- Q42
SELECT o.ship,b.name FROM outcomes o, battles b WHERE b.name= o.battle AND o.result= 'sunk'

-- Q43
SELECT b.name FROM battles b left join ships s on date_part('year',b.date)::smallint = s.launched WHERE launched is null

-- Q44
SELECT name FROM (SELECT name AS name FROM ships
UNION 
SELECT ship AS name FROM outcomes) x WHERE lower(x.name) like 'r%'

-- Q45
SELECT name FROM (SELECT name AS name FROM ships
UNION 
SELECT ship AS name FROM outcomes) x WHERE array_length(regexp_split_to_array(x.name,' '),1) >=3

-- Q46
SELECT o.ship, displacement, numGuns FROM
(SELECT name AS ship, displacement, numGuns
FROM Ships s JOIN ClASses c ON c.clASs=s.clASs
UNION
SELECT clASs AS ship, displacement, numGuns
FROM ClASses c) AS a
RIGHT JOIN Outcomes o
ON o.ship=a.ship
WHERE battle = 'Guadalcanal'

-- Q47
with rank_temp AS (SELECT rank() over ( order BY counter desc,maker)  AS ranker, maker, counter FROM (SELECT count(DISTINCT model) AS counter, maker FROM product GROUP BY maker) x)
SELECT row_number() over (order BY rt.ranker,model) ,pd.maker,pd.model FROM product pd , rank_temp rt WHERE pd.maker = rt.maker;

-- Q48
SELECT c.clASs FROM clASses c left join ships s on c.clASs = s.clASs WHERE c.clASs in (SELECT ship FROM outcomes WHERE result = 'sunk') or s.name in (SELECT ship FROM outcomes WHERE result = 'sunk' ) GROUP BY c.clASs

-- Q49
SELECT s.name  FROM ships s WHERE clASs in (SELECT clASs FROM clASses WHERE bore = 16)
UNION
SELECT o.ship  FROM outcomes o WHERE o.ship in (SELECT clASs FROM clASses WHERE bore = 16)

-- Q50
SELECT DISTINCT o.battle FROM outcomes o left join ships s on o.ship  = s.name WHERE s.clASs = 'Kongo'