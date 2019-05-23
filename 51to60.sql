--Q51
WITH list
 AS (SELECT l.NAME,
			c.displacement,
			c.numguns
	 FROM   (SELECT NAME,
					class
			 FROM   ships
			 UNION
			 SELECT ship,
					ship
			 FROM   outcomes o) l,
			classes c
	 WHERE  c.class = l.class)
SELECT k.NAME
FROM   list k,
   (SELECT j.displacement,
		   Max(j.numguns) AS mn
	FROM   list j
	GROUP  BY j.displacement) l
WHERE  k.displacement = l.displacement
   AND l.mn = k.numguns  
   
   
--Q52
 SELECT s.NAME
FROM   ships s
       LEFT JOIN classes c
              ON s.class = c.class
WHERE  ( numguns IS NULL
          OR numguns >= 9 )
       AND ( bore < 19
              OR bore IS NULL )
       AND ( displacement IS NULL
              OR displacement <= 65000 )
       AND country = 'Japan'
       AND type = 'bb'  
	   
--Q53
 SELECT Round(Avg(numguns), 2)
FROM   classes
WHERE  type = 'bb'  

--Q54
 SELECT Round(Avg(numguns), 2)
FROM   (SELECT o.ship,
               c.class,
               c.numguns
        FROM   outcomes o,
               classes c
        WHERE  o.ship = c.class
               AND c.type = 'bb'
        UNION
        SELECT s.NAME,
               c.class,
               c.numguns
        FROM   ships s,
               classes c
        WHERE  s.class = c.class
               AND c.type = 'bb') x  
			   
--Q55
 SELECT class,
       Min(launched)
FROM   (SELECT class,
               launched
        FROM   ships
        WHERE  NAME = class
        UNION
        SELECT c.class,
               s.launched
        FROM   classes c
               LEFT JOIN ships s
                      ON c.class = s.class) x
GROUP  BY class  

--Q56
 WITH sunk
     AS (SELECT class
         FROM   (SELECT o.ship,
                        s.class,
                        o.result
                 FROM   outcomes o,
                        ships s
                 WHERE  o.ship = s.NAME
                 UNION
                 SELECT c.class,
                        c.class,
                        o.result
                 FROM   classes c,
                        outcomes o
                 WHERE  c.class = o.ship) x
         WHERE  result = 'sunk')
SELECT c.class,
       Sum(CASE
             WHEN sk.class = c.class THEN 1
             ELSE 0
           END)
FROM   classes c
       LEFT JOIN sunk sk
              ON c.class = sk.class
GROUP  BY c.class  

--Q59
 WITH temp_i
     AS (SELECT 'i',
                point,
                Sum(COALESCE(inc, 0)) AS sum
         FROM   income_o
         GROUP  BY point),
     temp_o
     AS (SELECT 'o',
                point,
                Sum(COALESCE(out, 0)) AS sum
         FROM   outcome_o
         GROUP  BY point) SELECT o.point,
       COALESCE(i.sum, 0) - COALESCE(o.sum, 0)
FROM   temp_i i
       JOIN temp_o o
         ON i.point = o.point
UNION
SELECT point    P,
       Sum(inc) rem
FROM   income_o
WHERE  point NOT IN (SELECT point
                     FROM   outcome_o)
GROUP  BY point  
