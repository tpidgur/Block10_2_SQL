/*1.Написать запрос, считающий суммарное количество имеющихся на сайте новостей и обзоров.*/
select sum (ids) as SUM 
from
(select count(r_id) as ids 
from reviews 
union all 
select count(n_id) as ids 
from news) as Sum2;

/*2.Написать запрос, показывающий список категорий новостей и количество новостей в каждой категории.*/
 SELECT 
    nc_name, count1
FROM
    news_categories
        LEFT JOIN
    (SELECT 
        n_category, COUNT(*) AS count1
    FROM
        news
    GROUP BY n_category) AS Temp ON news_categories.nc_id = Temp.n_category;

/*3. Написать запрос, показывающий список категорий обзоров и количество обзоров в каждой категории.*/ 
SELECT 
    rc_name, count2
FROM
    reviews_categories
        LEFT JOIN
    (SELECT 
        r_category, COUNT(*) AS count2
    FROM
        reviews
    GROUP BY r_category) AS Temp2 ON reviews_categories.rc_id = Temp2.r_category;
 
 
/*4. Написать запрос, показывающий список категорий новостей, категорий обзоров и дату 
самой свежей публикации в каждой категории.*/ 
SELECT 
    *
FROM
    (SELECT 
        news_categories.nc_name, news.n_dt
    FROM
        news_categories
    INNER JOIN news ON nc_id = n_category
        AND news.n_dt = (SELECT 
            MAX(n2.n_dt)
        FROM
            news AS n2
        WHERE
            n2.n_category = news_categories.nc_id) UNION ALL SELECT 
        reviews_categories.rc_name, reviews.r_dt
    FROM
        reviews_categories
    INNER JOIN reviews ON rc_id = r_category
        AND r_dt = (SELECT 
            MAX(r2.r_dt)
        FROM
            reviews AS r2
        WHERE
            reviews_categories.rc_id = r2.r_category)) t2;

 /*5. Написать запрос, показывающий список страниц сайта верхнего уровня 
 (у таких страниц нет родительской страницы) и список баннеров для каждой такой страницы.*/ 
 SELECT 
    p_name, m2m_banners_pages.b_id, b_url
FROM
    banners
        JOIN
    m2m_banners_pages ON banners.b_id = m2m_banners_pages.b_id
        JOIN
    pages ON m2m_banners_pages.p_id = pages.p_id
WHERE
    p_parent IS NULL;

/*6. Написать запрос, показывающий список страниц сайта, на которых есть баннеры.*/
 SELECT 
    p_name
FROM
    pages
        JOIN
    m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
GROUP BY p_name;

 /*7. Написать запрос, показывающий список страниц сайта, на которых нет баннеров.*/ 
 SELECT 
    p_name
FROM
    pages
        LEFT JOIN
    m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
WHERE
    m2m_banners_pages.p_id IS NULL
GROUP BY p_name;

 /*8. Написать запрос, показывающий список баннеров, размещённых хотя бы на одной странице сайта.*/ 
 SELECT 
    m2m_banners_pages.b_id, banners.b_url
FROM
    banners
        JOIN
    m2m_banners_pages ON banners.b_id = m2m_banners_pages.b_id
GROUP BY m2m_banners_pages.b_id;

 /*9. Написать запрос, показывающий список баннеров, не размещённых ни на одной странице сайта.*/ 
 SELECT 
    banners.b_id, banners.b_url
FROM
    banners
        LEFT JOIN
    m2m_banners_pages ON banners.b_id = m2m_banners_pages.b_id
WHERE
    m2m_banners_pages.b_id IS NULL;

/*10. Написать запрос, показывающий баннеры, для которых отношение кликов к показам >= 80% 
(при условии, что баннер был показан хотя бы один раз).*/ 
SELECT 
    banners.b_id,
    banners.b_url,
    banners.b_click / banners.b_show * 100 AS rate
FROM
    banners
WHERE
    b_show >= 1
HAVING rate IS NOT NULL AND rate > 80;

 /*11. Написать запрос, показывающий список страниц сайта, на которых показаны баннеры с текстом
 (в поле `b_text` не NULL).*/ 
 SELECT 
    pages.p_name
FROM
    pages
        INNER JOIN
    m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
        INNER JOIN
    banners ON banners.b_id = m2m_banners_pages.b_id
WHERE
    banners.b_text IS NOT NULL
GROUP BY pages.p_name;

/*12. Написать запрос, показывающий список страниц сайта, на которых показаны баннеры с картинкой 
(в поле `b_pic` не NULL).*/ 
SELECT 
    pages.p_name
FROM
    pages
        INNER JOIN
    m2m_banners_pages ON m2m_banners_pages.p_id = pages.p_id
        INNER JOIN
    banners ON banners.b_id = m2m_banners_pages.b_id
WHERE
    banners.b_pic IS NOT NULL
GROUP BY pages.p_name;

 /*13.	Написать запрос, показывающий список публикаций (новостей и обзоров) за 2011-й год*/
 SELECT 
    *
FROM
    (SELECT 
        news.n_header header, news.n_dt
    FROM
        news
    WHERE
        EXTRACT(YEAR FROM n_dt) = 2011 UNION ALL SELECT 
        reviews.r_header header, reviews.r_dt
    FROM
        reviews
    WHERE
        EXTRACT(YEAR FROM r_dt) = 2011) t;

 /*14.	Написать запрос, показывающий список категорий публикаций (новостей и обзоров), в которых нет публикаций*/ 
 SELECT 
    *
FROM
    (SELECT 
        news_categories.nc_name
    FROM
        news_categories
    LEFT JOIN news ON nc_id = n_category
    WHERE
        news.n_category IS NULL UNION ALL SELECT 
        reviews_categories.rc_name
    FROM
        reviews_categories
    LEFT JOIN reviews ON rc_id = r_category
    WHERE
        reviews.r_category IS NULL) t2;

/*15. Написать запрос, показывающий список новостей из категории «Логистика» за 2012-й год.*/ 
 SELECT 
    news.n_header, news.n_dt
FROM
    news
        JOIN
    news_categories ON news.n_category = news_categories.nc_id
        AND news_categories.nc_name = 'Логистика'
WHERE
    EXTRACT(YEAR FROM n_dt) = 2012;

/*16. Написать запрос, показывающий список годов, за которые есть новости, а также количество новостей 
за каждый из годов.*/
SELECT 
    EXTRACT(YEAR FROM n_dt) AS d, COUNT(*)
FROM
    news
GROUP BY d;

/*17.	Написать запрос, показывающий URL и id таких баннеров, где для одного и того же URL есть 
несколько баннеров.*/
 SELECT 
    banners.b_url, b_id
FROM
    banners
WHERE
    banners.b_url IN (SELECT 
            b_url
        FROM
            banners
        GROUP BY b_url
        HAVING COUNT(*) > 1);

/*18.	Написать запрос, показывающий список непосредственных подстраниц страницы 
«Юридическим лицам» со списком баннеров этих подстраниц.*/
SELECT 
    p.p_name, b.b_id, b.b_url
FROM
    pages AS p2
        INNER JOIN
    pages AS p ON p.p_parent = p2.p_id
        AND p2.p_name = 'Юридическим лицам'
        INNER JOIN
    m2m_banners_pages AS m ON m.p_id = p.p_id
        INNER JOIN
    banners AS b ON b.b_id = m.b_id;
 
 /*19.	Написать запрос, показывающий список всех баннеров с картинками (поле `b_pic` не NULL),
 отсортированный по убыванию отношения кликов по баннеру к показам баннера.*/
 SELECT 
    banners.b_id,
    banners.b_url,
    banners.b_click / banners.b_show AS rate
FROM
    banners
WHERE
    b_pic IS NOT NULL
ORDER BY rate DESC;
 
 /*20.	Написать запрос, показывающий самую старую публикацию на сайте (не важно – новость это или обзор).*/ 
 SELECT 
    *
FROM
    (SELECT 
        news.n_header header, news.n_dt date
    FROM
        news UNION ALL SELECT 
        reviews.r_header header, reviews.r_dt date
    FROM
        reviews) t
ORDER BY date ASC
LIMIT 1;

/*21.	Написать запрос, показывающий список баннеров, URL которых встречается в таблице один раз.*/
 SELECT 
    banners.b_url, b_id
FROM
    banners
WHERE
    banners.b_url IN (SELECT 
            b_url
        FROM
            banners
        GROUP BY b_url
        HAVING COUNT(*) = 1);

/*22.	Написать запрос, показывающий список страниц сайта в порядке убывания количества баннеров, 
расположенных на странице. Для случаев, когда на нескольких страницах расположено одинаковое 
количество баннеров, этот список страниц должен быть отсортирован по возрастанию имён страниц.*/
 SELECT 
    p.p_name, banners_count
FROM
    pages AS p
        JOIN
    (SELECT 
        m2m_banners_pages.p_id, COUNT(*) AS banners_count
    FROM
        m2m_banners_pages
    GROUP BY m2m_banners_pages.p_id) AS temp ON temp.p_id = p.p_id
ORDER BY banners_count DESC , p_name ASC;

/*23.	Написать запрос, показывающий самую «свежую» новость и самый «свежий» обзор.*/
 SELECT 
    news.n_header AS header, news.n_dt AS date
FROM
    news
WHERE
    news.n_dt = (SELECT 
            MAX(news.n_dt)
        FROM
            news) 
UNION ALL SELECT 
    reviews.r_header AS header, reviews.r_dt AS date
FROM
    reviews
WHERE
    reviews.r_dt = (SELECT 
            MAX(reviews.r_dt)
        FROM
            reviews);

/*24.	Написать запрос, показывающий баннеры, в тексте которых встречается часть URL, на который ссылается баннер.*/
 SELECT 
    banners.b_id, banners.b_url, banners.b_text
FROM
    banners
WHERE
    banners.b_url LIKE CONCAT('%', b_text, '%');

/*25.	Написать запрос, показывающий страницу, на которой размещён баннер с самым высоким отношением кликов к показам.*/
 SELECT 
    p.p_name
FROM
    pages AS p
        INNER JOIN
    m2m_banners_pages AS m ON p.p_id = m.p_id
        INNER JOIN
    banners AS b ON m.b_id = b.b_id
        AND (b.b_click / b.b_show) = (SELECT 
            MAX(banners.b_click / banners.b_show)
        FROM
            banners);

/*26.	Написать запрос, считающий среднее отношение кликов к показам по всем баннерам, которые были показаны
 хотя бы один раз.*/
 SELECT 
    AVG(banners.b_click / banners.b_show)
FROM
    banners
WHERE
    banners.b_show >= 1;

/*27.	Написать запрос, считающий среднее отношение кликов к показам по баннерам,
 у которых нет графической части (поле `b_pic` равно NULL).*/ 
 SELECT 
    AVG(banners.b_click / banners.b_show)
FROM
    banners
WHERE
    banners.b_pic IS NULL;

/*28.	Написать запрос, показывающий количество баннеров, размещённых на страницах сайта верхнего уровня 
(у таких страниц нет родительских страниц).*/
 SELECT 
    COUNT(*)
FROM
    pages AS p
        INNER JOIN
    m2m_banners_pages AS m ON p.p_id = m.p_id AND p.p_parent IS NULL;

/*29.	Написать запрос, показывающий баннер(ы), который(ые) показаны на самом большом количестве страниц.*/ 
SELECT 
    banners.b_id, b_url, COUNT(p_id) count
FROM
    banners
        JOIN
    m2m_banners_pages ON (banners.b_id = m2m_banners_pages.b_id)
GROUP BY b_id , b_url
HAVING count = (SELECT 
        MAX(count)
    FROM
        (SELECT 
            banners.b_id, b_url, COUNT(p_id) count
        FROM
            banners
        JOIN m2m_banners_pages ON (banners.b_id = m2m_banners_pages.b_id)
        GROUP BY b_id , b_url
        ORDER BY count DESC) t);


 /*30.	Написать запрос, показывающий страницу(ы), на которой(ых) показано больше всего баннеров.*/ 
  SELECT 
    *
FROM
    (SELECT 
        p.p_name, banners_count
    FROM
        pages AS p
    JOIN (SELECT 
        m2m_banners_pages.p_id, COUNT(*) AS banners_count
    FROM
        m2m_banners_pages
    GROUP BY m2m_banners_pages.p_id) AS temp ON temp.p_id = p.p_id
    ORDER BY banners_count DESC , p_name ASC) t2
HAVING banners_count = (SELECT 
        MAX(banners_count)
    FROM
        (SELECT 
            p.p_name, banners_count
        FROM
            pages AS p
        JOIN (SELECT 
            m2m_banners_pages.p_id, COUNT(*) AS banners_count
        FROM
            m2m_banners_pages
        GROUP BY m2m_banners_pages.p_id) AS temp ON temp.p_id = p.p_id
        ORDER BY banners_count DESC , p_name ASC) t3);

 