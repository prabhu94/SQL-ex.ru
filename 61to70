--Q61
 SELECT Sum(inc) - Sum(out)
FROM   (SELECT COALESCE(i.point, o.point) AS point,
               COALESCE(i.date, o.date)   AS date,
               COALESCE(i.inc, 0)         AS inc,
               COALESCE(o.out, 0)         AS out
        FROM   income_o i
               FULL JOIN outcome_o o
                      ON i.point = o.point
                         AND i.date = o.date)x  

--Q62
 SELECT Sum(COALESCE(inc, 0)) - Sum(COALESCE(out, 0))
FROM   income_o i
       FULL OUTER JOIN outcome_o o using (point, date)
WHERE  date < '2001-04-15';  
