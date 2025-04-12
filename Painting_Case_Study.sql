--1.Fetch all the paintings which are not displayed on any museums? 
select * from work where museum_id is null;
--2. Are there museums without any paintings?
SELECT m.*
FROM museum m
LEFT JOIN work w ON m.museum_id = w.museum_id
WHERE w.museum_id IS NULL;

SELECT *
FROM museum
EXCEPT
SELECT m.*
FROM museum m
JOIN work w ON m.museum_id = w.museum_id;


--3. How many paintings have an asking price of more than their regular price?
select Count(work_id) from product_size where sale_price>regular_price

--4. Identify the paintings whose asking price is less than 50% of its regular price
select * from product_size where sale_price<(regular_price/2)
--5. Which canva size costs the most?
SELECT cs.label AS canva, ps.sale_price
FROM product_size ps
JOIN canvas_size cs ON cs.size_id::text = ps.size_id
ORDER BY ps.sale_price DESC
LIMIT 1;

--6. Delete duplicate records from work, product_size, subject and image_link tables
delete from image_link 
	where ctid not in (select min(ctid)
						from image_link
						group by work_id );

	delete from work 
	where ctid not in (select min(ctid)
						from work
						group by work_id );

	delete from product_size 
	where ctid not in (select min(ctid)
						from product_size
						group by work_id, size_id );

	delete from subject 
	where ctid not in (select min(ctid)
						from subject
						group by work_id, subject );



--7. Identify the museums with invalid city information in the given dataset
select * from museum 
	where city ~ '^[0-9]'
--8. Museum_Hours table has 1 invalid entry. Identify it and remove it.
delete from museum_hours 
	where ctid not in (select min(ctid)
						from museum_hours
						group by museum_id, day );
--9. Fetch the top 10 most famous painting subject
select subject,count(work_id) from (select s.* from subject s join work w on s.work_id=w.work_id) s 
	group by s.subject order by 2 desc limit 10

/*10. Identify the museums which are open on both Sunday and Monday. Display
museum name, city. */
SELECT m.name, m.city
FROM museum_hours mh
JOIN museum m ON mh.museum_id = m.museum_id
WHERE mh.day IN ('Sunday', 'Monday')
GROUP BY m.name, m.city
HAVING COUNT(DISTINCT mh.day) = 2;
--11. How many museums are open every single day?
SELECT COUNT(*) AS count_of_ids
FROM (
    SELECT museum_id
    FROM museum_hours
    GROUP BY museum_id
    HAVING COUNT(DISTINCT CASE WHEN day IN ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday') THEN day END) = 7
) AS ids_with_all_weekdays;

update museum_hours set day='Thursday' where day='Thusday' --Data Correction
--Data inconsistency three records with id=30,31,32 has Thrusday as 'Thusday' that causes issue .

select count(1)
	from (select museum_id, count(1)
		  from museum_hours
		  group by museum_id
		  having count(1) = 7) x;


/*12. Which are the top 5 most popular museum? (Popularity is defined based on most
no of paintings in a museum) */
select m.name, count(w.work_id) as numbers_of_paintings
from work w
join museum m on w.museum_id=m.museum_id
group by m.name
order by 2 desc
limit 5

/*13. Who are the top 5 most popular artist? (Popularity is defined based on most no of
paintings done by an artist) */
	select a.full_name as artist,a.nationality,x.no_of_work
	from (	select a.artist_id, count(1) as no_of_work
			, rank() over(order by count(1) desc) as rnk
			from work w
			join artist a on a.artist_id=w.artist_id
			group by a.artist_id) x
	join artist a on a.artist_id=x.artist_id
	where x.rnk<=5;

--14. Display the 3 least popular canva sizes

select label,ranking,no_of_paintings
	from (
		select cs.size_id,cs.label,count(1) as no_of_paintings
		, dense_rank() over(order by count(1) ) as ranking
		from work w
		join product_size ps on ps.work_id=w.work_id
		join canvas_size cs on cs.size_id::text = ps.size_id
		group by cs.size_id,cs.label) x
	where x.ranking<=3;


/*15. Which museum is open for the longest during a day. Dispay museum name, state
and hours open and which day? */
WITH hours_open AS (
    SELECT
        m.name AS museum_name,
        m.state,
        mh.day,
        mh.open,
        mh.close,
        TO_TIMESTAMP(mh.close, 'HH12:MI AM') - TO_TIMESTAMP(mh.open, 'HH12:MI AM') AS open_duration
    FROM
        museum_hours mh
    JOIN
        museum m ON mh.museum_id = m.museum_id
)
SELECT
    museum_name,
    state,
    day,
    TO_CHAR(open_duration, 'HH24:MI') AS hours_open
FROM
    hours_open
WHERE
    open_duration = (
        SELECT MAX(open_duration)
        FROM hours_open
    );

--16. Which museum has the most no of most popular painting style?
WITH popular_styles AS (
    SELECT style, COUNT(*) AS num_paintings
    FROM work
    WHERE museum_id IS NOT NULL
    GROUP BY style
    ORDER BY COUNT(*) DESC
    LIMIT 1
),
museum_popular_styles AS (
    SELECT w.museum_id, m.name AS museum_name, ps.style, COUNT(*) AS no_of_paintings
    FROM work w
    JOIN museum m ON m.museum_id = w.museum_id
    JOIN popular_styles ps ON ps.style = w.style
    WHERE w.museum_id IS NOT NULL
    GROUP BY w.museum_id, m.name, ps.style
)
SELECT museum_name, style, no_of_paintings
FROM museum_popular_styles
ORDER BY no_of_paintings DESC
LIMIT 1;


--17. Identify the artists whose paintings are displayed in multiple countries
select a.full_name,count(distinct country) as no_of_countries from (select w.work_id,w.artist_id,w.museum_id,m.country from work w join museum m on w.museum_id=m.museum_id)s
join artist a on a.artist_id=s.artist_id
group by s.artist_id,a.full_name
having count(distinct country)>1
order by 2 desc

/*18. Display the country and the city with most no of museums. Output 2 seperate
columns to mention the city and country. If there are multiple value, seperate them
with comma. */
WITH RankedCountries AS (
    SELECT
        country,
        COUNT(DISTINCT museum_id) AS num_museums,
        RANK() OVER (ORDER BY COUNT(DISTINCT museum_id) DESC) AS rnk
    FROM
        museum
    GROUP BY
        country
),
RankedCities AS (
    SELECT
        city,
        COUNT(DISTINCT museum_id) AS num_museums,
        RANK() OVER (ORDER BY COUNT(DISTINCT museum_id) DESC) AS rnk
    FROM
        museum
    GROUP BY
        city
),
TopCountries AS (
    SELECT
        STRING_AGG(country, ', ') AS countries
    FROM
        RankedCountries
    WHERE
        rnk = 1
),
TopCities AS (
    SELECT
        STRING_AGG(city, ', ') AS cities
    FROM
        RankedCities
    WHERE
        rnk = 1
)
SELECT
    TopCountries.countries,
    TopCities.cities
FROM
    TopCountries,
    TopCities;

/*19. Identify the artist and the museum where the most expensive and least expensive
painting is placed. Display the artist name, sale_price, painting name, museum
name, museum city and canvas label */
with cte as 
		(select *
		, rank() over(order by sale_price desc) as rnk
		, rank() over(order by sale_price ) as rnk_asc
		from product_size )
	select w.name as painting
	, cte.sale_price
	, a.full_name as artist
	, m.name as museum, m.city
	, cz.label as canvas
	from cte
	join work w on w.work_id=cte.work_id
	join museum m on m.museum_id=w.museum_id
	join artist a on a.artist_id=w.artist_id
	join canvas_size cz on cz.size_id = cte.size_id::NUMERIC
	where rnk=1 or rnk_asc=1;


--20. Which country has the 5th highest no of paintings?
with cte as ( select m.country,s.* from museum m join ( SELECT
        museum_id,
        COUNT( work_id) AS num_painting
    FROM
        work
    GROUP BY
        museum_id
	 having (museum_id is not null) ) s 
on m.museum_id=s.museum_id),
cte2 as(select country, sum(num_painting),rank() over(order by sum(num_painting) desc) as rnk from cte 
	group by country )
Select * from cte2 where rnk=5;
	---Simple Solution-----
with cte as 
		(select m.country, count(1) as no_of_Paintings
		, rank() over(order by count(1) desc) as rnk
		from work w
		join museum m on m.museum_id=w.museum_id
		group by m.country)
	select country, no_of_Paintings
	from cte 
	where rnk=5;

--21. Which are the 3 most popular and 3 least popular painting styles?
with cte as (SELECT style, COUNT(*) AS num_paintings,rank() over(order by COUNT(*) desc ) as most,rank() over(order by COUNT(*) asc ) as least
    FROM work
    WHERE style IS NOT NULL
    GROUP BY style)
select style,case when most in (1,2,3) then 'Most Popular' 
					when least in (1,2,3) then 'Least Popular' end as popularity from cte
WHERE 
    most IN (1, 2, 3) OR least IN (1, 2, 3);



/*22. Which artist has the most no of Portraits paintings outside USA?. Display artist
name, no of paintings and the artist nationality. */

with ste as (select w.work_id,s.subject,a.full_name,a.nationality from work w 
	join artist a on w.artist_id=a.artist_id
	join museum m on w.museum_id=m.museum_id
	join subject s on s.work_id=w.work_id
	where s.subject='Portraits' and m.country!= 'USA'),
cte2 as (select full_name,nationality,count (*) as no_of_paintings,rank()over (order by count(*) desc ) as rnk from ste
group by full_name,nationality)
select full_name,nationality,no_of_paintings from cte2 where rnk=1







