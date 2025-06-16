-- Active: 1749607602857@@127.0.0.1@3306@market
-- 셀프체크
-- 8장에서 만든 market DB의 상품 중 가격이 낮은 하위 4개의 누적 매출을 다음과 같이 조회하고 싶습니다.
-- 이를 위한 쿼리를 작성하세요.
-- (ch08_09_market_db.png 참고)

-- ----------------------------------
-- 상품명        | 가격     | 누적 매출
-- ----------------------------------
-- 플레인 베이글  | 1300    | 6500
-- 우유 900ml    | 1970    | 9850
-- 크림 치즈      | 2180    | 8720
-- 우유 식빵      | 2900    | 8700

USE market;

SELECT name, p.price, SUM(price*count)
FROM products p 
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON o.id = od.order_id 
WHERE o.status = '배송 완료'
GROUP BY p.id -- 기본키를 가져오면 기본키를 통해서 다른 컬럼들 사용가능, MySQL에서만 허용 아래 방법이 더 좋음
ORDER BY price ASC;


SELECT name, price, SUM(price*count)
FROM products p 
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON o.id = od.order_id 
WHERE o.status = '배송 완료'
GROUP BY name, price
ORDER BY price ASC
LIMIT 4;

