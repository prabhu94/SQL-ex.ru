--Q11
Select avg(speed) from pc
--Q12
Select avg(speed) from laptop where price>1000
--Q13
Select avg(speed) from pc join product on pc.model=product.model where product.maker='A'
--Q14
Select distinct maker,type from product where maker = any(select maker from product group by maker having count(model)>1 and count(distinct type)=1)
--Q15
Select hd from pc group by hd having count(hd)>1
--Q16
Select distinct a.model,b.model,a.speed,b.ram from pc a, pc b where a.model>b.model and a.speed=b.speed and a.ram=b.ram
--Q17
Select distinct type,laptop.model,speed from laptop,product where laptop.model=product.model and speed < all(select speed from pc)
--Q18
Select distinct pd.maker,pr.price from product pd inner join printer pr on  pd.model = pr.model where pr.price in ( select min(price) as price from printer where color = 'y') and pr.color = 'y';
--Q19
Select maker,avg(screen) from laptop lp,product pd where pd.model=lp.model group by maker
--Q20
Select pd.maker, count(distinct pd.model) as count_maker from product pd where pd.type = 'pc' group  by pd.maker having count(distinct pd.model) >= 3
