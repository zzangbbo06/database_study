-- Active: 1749607602857@@127.0.0.1@3306@market

/*
8. 그룹화 분석하기
8.1 그룹화란
*/

-- 그룹화: 데이터를 특정 기준에 따라 나누는 것
-- 그룹화 분석: 그룹별 데이터를 요약하거나 분석하는 것
-- 예: 전체 학생의 평균 키도 의미가 있으나, 성별로 나누어 평균키를 구하면 조금 더 유의미한 정보를 얻음

-- 그룹화 분석 기초 실습
-- 학생의 키 데이터를 성별에 따라 나누어 분석해보기

-- group_analysis DB 생성 및 진입
CREATE DATABASE group_analysis;
USE group_analysis;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	gender VARCHAR(10), 		-- 성별
	height DECIMAL(4, 1), 		-- 키
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (gender, height)
VALUES
	('male', 176.6),
	('female', 165.5),
	('female', 159.3),
	('male', 172.8),
	('female', 160.7),
	('female', 170.2),
	('male', 182.1);

-- 확인
SELECT *
FROM students;

-- 전체 집계: 전체 학생의 평균 키 구하기
SELECT AVG(height) AS '평균 키'
FROM students;

-- 남학생의 평균
SELECT AVG(height) AS '평균 키'
FROM students
WHERE gender = 'male';

-- 여학생의 평균
SELECT AVG(height) AS '평균 키'
FROM students
WHERE gender = 'female';

-- 그룹화 분석: 각 성별 평균 키 구하기 
-- SELECT 그룹화_컬럼, 집계_함수(일반_컬럼) -> 이 두 개가 아니면 에러남
-- FROM 테이블명
-- WHERE 조건
-- GROUP BY 그룹화_컬럼;

SELECT gender, AVG(height), SUM(height)
FROM students
GROUP BY gender; -- 성별을 기준으로 그룹화하겠다

-- 그룹화의 특징 3가지
-- 1) 집계 함수와 함께 사용해야 함
-- 그룹별 유의미한 분석을 얻기 위해서는 집계 함수 사용
-- 단순 GROUP BY 절만 사용하는 것은 데이터를 그룹으로 묶기만 함(의미 없음)

SELECT gender
FROM students
GROUP BY gender;

-- 2) 여러 컬럼으로 그룹화할 수 있다. 
SELECT 그룹화_컬럼1, 그룹화_컬럼2, 집계_함수(일반_컬럼)
FROM 테이블명
WHERE 조건
GROUP BY 그룹화_컬럽1, 그룹화_컬럼2;

-- 예: 특정 도시의 연도별 총매출 집계

-- sales 테이블 생성
CREATE TABLE sales (
	id INTEGER AUTO_INCREMENT,  	-- 아이디(자동으로 1씩 증가)
	city VARCHAR(50) NOT NULL,   	-- 도시명
	sale_date DATE NOT NULL,      	-- 판매 날짜
	amount INTEGER NOT NULL,     	-- 판매 금액
	PRIMARY KEY (id)				-- 기본키 지정: id
);

-- sales 데이터 삽입
INSERT INTO sales (city, sale_date, amount) 
VALUES
	('Seoul', '2023-01-15', 1000),
	('Seoul', '2023-05-10', 2000),
	('Seoul', '2023-08-29', 2500),
	('Seoul', '2024-02-14', 4000),
	('Busan', '2023-03-05', 1500),
	('Busan', '2024-05-10', 1800),
	('Busan', '2024-07-20', 3000),
	('Incheon', '2023-11-25', 1200),
	('Incheon', '2024-03-19', 2200),
	('Incheon', '2024-09-12', 3300);

-- 확인
SELECT * FROM sales;

-- 특정 도시의 연도별 총매출 집계
-- 일단 먼저 특정 도시별 총매출 집계
SELECT -- 3) 특정 도시의 도시, 연도, 총 매출 집계 조회
	city AS 도시, 
	YEAR(sale_date) AS '판매 연도', 
	SUM(amount) AS '총 매출' -- 실무에서는 영어로 공백없이 별칭을 만듬
FROM sales -- 1) sales 테이블을
GROUP BY city, YEAR(sale_date); -- 2) 도시와 연도로 그룹화한 후

-- 3) SELECT 절에 올 수 있는 컬럼이 제한적이다.
-- 사용 가능한 컬럼: 
-- - 그룹화 컬럼 : GROUP BY 절에서 지정한 컬럼
-- - 집계된 컬럼: 집계 함수에 사용된 컬럼

-- 잘못된 컬럼 사용 예시
SELECT id, gender, AVG(height) -> id가 불가능
FROM students
GROUP BY gender;


-- 이렇게는 가능
SELECT SUM(id), gender, AVG(height)
FROM students
GROUP BY gender;

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하시오.
-- ① 그룹화 분석이란 데이터를 특정 그룹으로 나누어 분석하는 것이다. (  )
-- ② GROUP BY 절에는 반드시 하나의 칼럼만 지정해야 한다. (  )
-- ③ 그룹화된 쿼리에서 SELECT 절에 포함된 칼럼은 GROUP BY 절에서 지정한 그룹화 칼럼이거나 집계 함수에 사용된 칼럼이어야 한다. (  )

-- 정답: O, X, O

/*
8.2 그룹화 필터링, 정렬, 조회 개수 제한
*/
-- 실습 데이터 셋 만들기

-- payments 테이블 생성
CREATE TABLE payments (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	amount INTEGER, 			-- 결제 금액
	ptype VARCHAR(50), 			-- 결제 유형
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- payments 데이터 삽입
INSERT INTO payments (amount, ptype)
VALUES
	(33640, 'SAMSONG CARD'),
	(33110, 'SAMSONG CARD'),
	(31200, 'LOTTI CARD'),
	(69870, 'COCOA PAY'),
	(32800, 'COCOA PAY'),
	(42210, 'LOTTI CARD'),
	(46060, 'LOTTI CARD'),
	(42520, 'SAMSONG CARD'),
	(23070, 'COCOA PAY');

SELECT * FROM payments;

-- 1. 그룹화 필터링(HAVING)
-- 그룹화한 결과에서 특정 조건을 만족하는 그룹의 데이터만 가져오는 것
-- GROUP BY 절에 HAVING 절을 추가하여 수행
-- 주로 집계 함수 결과에 조건을 걸 때 사용

SELECT 그룹화_컬럼, 집계_함수(일반_컬럼)
FROM 테이블명
WHERE 일반_필터링_조건 -- 그룹화 하기 전에 개별 행(row)에 대해 필터링 하는 행 단위 필터링, WHERE 절은 GROUP BY나 집계 함수가 처리되기 전에 실행되기 때문
GROUP BY 그룹화_컬럼
HAVING 그룹_필터링_조건; -- 그룹핑된 결과에 대해 필터링하는 그룹 단위 필터링

-- 결제 유형별 평균 결제 금액이 40,000원 이상인 데이터는?
SELECT ptype, AVG(amount)
FROM payments
GROUP BY ptype
HAVING AVG(amount) > 40000;


-- 2. 데이터 정렬(ORDER BY)
-- 정렬: 쿼리 결과를 오름차순 또는 내림차순으로 배열하는 것
-- ORDER BY 절을 사용하여 수행
-- SELECT로 조회된 데이터를 기준으로 정렬하는 작업(SELECT가 먼저 수행됨)

SELECT * 
FROM 테이블명
WHERE 조건
ORDER BY 정렬_컬럼1[ASC(오름차순) | DESC(내림차순)], 정렬_컬럼2[ASC(오름차순) | DESC(내림차순)], ...;

-- ASC: 오름차순(생략 시 기본값)
-- DESC: 내림차순

-- 단일 컬럼 정렬: 결제 테이블에서 결제 금액이 높은 순서대로 조회하려면?
-- 결제 금액에 대한 정렬: 내림차순
SELECT -- 2) 필요한 컬럼만 선택하고, 별칭을 부여하고
	ptype AS '결제 유형',
	amount AS '결제 금액'
FROM payments -- 1) payments 테이블에서
ORDER BY amount DESC; -- 3) amount 기준으로 내림차순 정렬함
-- 금액이 높 -> 낮

-- 다중 컬럼 정렬: 결제 테이블에서 결제 유형은 오름차순, 결제 금액은 내림차순으로 정렬하려면?
-- 두 컬럼으로 정렬: 결제 유형, 결제 금액
SELECT
	ptype AS '결제 유형',
	amount AS '결제 금액'
FROM payments
ORDER BY ptype ASC, amount DESC; -- ptype의 오름차순 정렬 후, amount의 내림차순 정렬(순서 중요)

-- 3. 조회 개수 제한(LIMIT, OFFSET)
-- 조회 결과 중 상위 N개의 레코드만을 조회하는 명령
-- LIMIT 절을 이용해 반호나하려는 레코드의 개수를 정의

SELECT 컬럼1, 컬럼2, ...
FROM 테이블명
LIMIT N;

-- 결제 금액 상위 3개 데이터만 조회하려면?
SELECT *
FROM payments
ORDER BY amount DESC
LIMIT 3;

-- 상위 N개 데이터가 아닌 중간 데이터를 가져오고 싶다면?
-- LIMIT 절에 OFFSET 키워드를 추가해 읽어 올 데이터의 시작 지점을 조정할 수 있음

SELECT 컬럼1, 컬럼2, ...
FROM 테이블명
LIMIT N OFFSET M; -- N: 가져올 레코드의 개수, M: 건너뛸 레코드의 개수
-- 또는 LIMIT M, N;

-- 결제 금액 4등~6등까지 조회
SELECT *  -- 2) 모든 컬럼을 선택
FROM payments -- 1) payments 테이블에서
ORDER BY amount DESC -- 3) amount의 내림차순으로 정렬한 후
LIMIT 3 OFFSET 3; -- 4) 처음 3개 행은 건너 뛰고 3개 행만 가져옴

-- Tip: LIMIT 활용
-- 페이지네이션(Pagination) 구현할 때 SQL에서 가장 기본적으로 사용
-- 예: 한 페이지당 10개씩 보여줄 경우
-- 1페이지
SELECT *
FROM products
LIMIT 0, 10; -- 0개를 건너뛰고 10개를 가져온다

-- 2페이지
SELECT *
FROM products
LIMIT 10, 10;

-- 3페이지
SELECT *
FROM products
LIMIT 20, 10;

-- (하드코딩X) OFFSET 계산 방법
-- OFFSET = (현제 페이지 번호 - 1) * 페이지당 개수

-- 정렬은 반드시 함께 쓰자!
SELECT *
FROM products
ORDER BY created_at DESC
LIMIT 10 OFFSET 20;
-- 정렬 없이 LIMIT만 쓰면 페이지가 뒤죽박죽 될 수 있음

-- (참고) 성능 주의사항
-- OFFSET이 커질수록 성능이 떨어짐(건너뛸 데이터를 계속 읽기 때문)

-- Quiz
-- 다음은 payments 테이블에서 ptype(결제 유형)별로 결제 횟수와 평균 결제 금액을 구하는 쿼리이다.
-- 빈칸을 순서대로 채워 이를 완성하시오.

-- 그룹화와 정렬
-- -------------------------------------
-- 결제 유형       | 결제 횟수  | 평균 결제 금액
-- -------------------------------------
-- COCOA PAY    | 3        | 41913.3333
-- LOTTI CARD   | 3        | 39823.3333
-- SAMSONG CARD | 3        | 36423.3333

SELECT 
	ptype AS '결제 유형',
	COUNT(ptype) AS '결제 횟수',
	AVG(amount) AS '평균 결제 금액'
FROM payments
GROUP BY ptype
ORDER BY COUNT(*) DESC, AVG(amount) DESC;

-- 정답: COUNT(ptype), ptype, AVG(amount)


/*
8.3 그룹화 분석 실습: 마켓 DB
*/
-- 마켓 DB를 활용하여 그룹화, 그룹화 필터링, 정렬, 조회 개수 제한을 연습!
-- (ch08_09_market_db.png 참고)

-- 마켓 DB 데이터 셋
-- • users(사용자): 사용자의 id(아이디), email(이메일), nickname(닉네임)을 저장합니다.
-- • orders(주문): 주문의 id(아이디), status(주문 상태), created_at(주문 생성 시각)을 저장합니다.
-- • payments(결제): 결제의 id(아이디), amount(결제 금액), payment_type(결제 유형)을 저장합니다.
-- • products(상품): 상품의 id(아이디), name(상품명), price(가격), product_type(상품 유형)을 저장합니다.
-- • order_details(주문 상세): 주문 상세의 id(아이디), count(판매 수량)를 저장합니다.

-- market DB 생성 및 진입
CREATE DATABASE market;
USE market;

-- users 테이블 생성
CREATE TABLE users (
	id INTEGER AUTO_INCREMENT, 		-- 아이디(자동으로 1씩 증가)
	email VARCHAR(255) UNIQUE, 		-- 이메일(고유한 값만 허용)
	nickname VARCHAR(255) UNIQUE, 	-- 닉네임(고유한 값만 허용)
	PRIMARY KEY (id) 				-- 기본키 지정: id
);

-- users 데이터 삽입
INSERT INTO users (email, nickname)
VALUES
	('sehongpark@cloudstudying.kr', '홍팍'),
	('kuma@cloudstudying.kr', '쿠마'),
	('hawk@cloudstudying.kr', '호크');
    
-- orders 테이블 생성
CREATE TABLE orders (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	status VARCHAR(50), 		-- 주문 상태
	created_at DATETIME, 		-- 주문 일시
	user_id INTEGER, 			-- 사용자 아이디
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (user_id) REFERENCES users(id) -- 외래키 지정: user_id
);

-- orders 데이터 삽입
INSERT INTO orders (status, created_at, user_id)
VALUES
	('배송 완료', '2024-11-12 11:07:12', 1),
	('배송 완료', '2024-11-17 22:14:54', 1),
	('배송 완료', '2024-11-24 19:13:46', 2),
	('배송 완료', '2024-11-29 23:57:29', 3),
	('배송 완료', '2024-12-06 22:25:13', 3),
	('배송 완료', '2025-01-02 13:04:25', 2),
	('배송 완료', '2025-01-06 15:45:51', 2),
	('장바구니', '2025-03-06 14:54:23', 1);
    
-- payments 테이블 생성
CREATE TABLE payments (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	amount INTEGER, 			-- 결제 금액
	payment_type VARCHAR(50), 	-- 결제 유형
	order_id INTEGER, 			-- 주문 아이디
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (order_id) REFERENCES orders(id) -- 외래키 지정: order_id
);

-- payments 데이터 삽입
INSERT INTO payments (amount, payment_type, order_id)
VALUES
	(9740, 'SAMSONG CARD', 1),
	(13800, 'SAMSONG CARD', 2),
	(32200, 'LOTTI CARD', 3),
	(28420, 'COCOA PAY', 4),
	(18000, 'COCOA PAY', 5),
	(5910, 'LOTTI CARD', 6),
	(17300, 'LOTTI CARD', 7);

-- products 테이블 생성
CREATE TABLE products (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(100), 			-- 상품명
	price INTEGER, 				-- 가격
	product_type VARCHAR(50), 	-- 상품 유형
	PRIMARY KEY(id) 			-- 기본키 지정: id
);

-- products 데이터 삽입
INSERT INTO products (name, price, product_type)
VALUES
	('우유 900ml', 1970, '냉장 식품'),
	('참치 마요 120g', 4400, '냉장 식품'),
	('달걀 감자 샐러드 500g', 6900, '냉장 식품'),
	('달걀 듬뿍 샐러드 500g', 6900, '냉장 식품'),
	('크림 치즈', 2180, '냉장 식품'),
	('우유 식빵', 2900, '상온 식품'),
	('샐러드 키트 6봉', 8900, '냉장 식품'),
	('무항생제 특란 20구', 7200, '냉장 식품'),
	('수제 크림 치즈 200g', 9000, '냉장 식품'),
	('플레인 베이글', 1300, '냉장 식품');
    
-- order_details 테이블 생성
CREATE TABLE order_details (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	order_id INTEGER, 			-- 주문 아이디
	product_id INTEGER, 		-- 상품 아이디
	count INTEGER, 				-- 주문 수량
	PRIMARY KEY (id), 			-- 기본키 지정: id
	FOREIGN KEY (order_id) REFERENCES orders(id), 	 -- 외래키 지정: order_id
	FOREIGN KEY (product_id) REFERENCES products(id) -- 외래키 지정: product_id
);

-- order_details 데이터 삽입
INSERT INTO order_details (order_id, product_id, count)
VALUES
	(1, 1, 2),
	(1, 6, 2),
	(2, 3, 1),
	(2, 4, 1),
	(3, 7, 2),
	(3, 8, 2),
	(4, 2, 3),
	(4, 5, 4),
	(4, 10, 5),
	(5, 9, 2),
	(6, 1, 3),
	(7, 8, 2),
	(7, 6, 1),
	(8, 6, 3);

USE market;
SELECT DATABASE();
SHOW TABLES;

-- 상품 유형별 집계하기
-- 상품 테이블에서 상품 유형별 상품의 개수, 최고 가격, 최저 가격을 구하려면?
SELECT
	COUNT(*) AS '상품의 개수', 
	MAX(price) AS '최고 가격',
    MIN(price) AS '최저 가격'
FROM products
GROUP BY product_type;		

-- 사용자 주문 총액 필터링 하기
-- 사용자별 주문 총액을 구하고, 그 총액이 30,000원 이상인 주문자는?
SELECT 
	nickname AS '주문자명',
    amount AS '주문 금액'
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN payments p ON o.id = p.order_id;

SELECT -- 6) 조회
	nickname AS '주문자명',
    SUM(amount) AS '주문 총액'
FROM users u -- 1) 사용자 테이블에
JOIN orders o ON u.id = o.user_id -- 2) 주문 테이블을 붙이고
JOIN payments p ON o.id = p.order_id -- 3) 결제 테이블도 붙이고
GROUP BY nickname -- 4) 사용자별 그룹화를 진행하여
HAVING SUM(amount) >= 30000; -- 5) 그룹 필터링을 하고

-- 가장 많이 팔린 상품 TOP3
-- 상품별 판매 수량을 집계했을 때, 가장 많이 팔린 상품 TOP3

SELECT * 
FROM products p
JOIN order_details od ON p.id = od.product_id
JOIN orders o ON od.order_id = o.id
WHERE o.status = '배송 완료';

-- 그룹화, 집계
SELECT -- 6)
	name AS 상품명, 
    SUM(count) AS '판매 수량'
FROM products p -- 1)
JOIN order_details od ON p.id = od.product_id -- 2)
JOIN orders o ON od.order_id = o.id -- 3)
WHERE o.status = '배송 완료' -- 4)
GROUP BY name  -- 상품별 그룹화 -- 5)
ORDER BY SUM(count) DESC, name ASC -- 상품의 개수가 동일할 때는 이름을 가나다 순으로 -- 7)
LIMIT 3; -- 8)
-- Quiz: 실행 순서를 번호로 달아보기

-- Quiz
-- 3. market DB에서 배송 완료된 상품별로 누적 매출 상위 3개 상품 정보를 조회하고자 한다. 다음 쿼리의 빈칸을 채워 완성하시오.

-- ------------------------------
-- 상품명              | 누적 매출
-- ------------------------------
-- 무항생제 특란 20구   | 28800
-- 수제 크림 치즈 200g  | 18000
-- 샐러드 키트 6봉      | 17800

SELECT 
	name AS '상품명',
	SUM(price*count) AS '누적 매출'
FROM products
JOIN order_details ON products.id = order_details.product_id
JOIN orders ON order_details.order_id = orders.id
			AND status = '배송 완료'
GROUP BY name
ORDER BY SUM(price*count) DESC
LIMIT 3;

-- 정답: price*count
-- 상품 가격 기준 이론상 매출액: 실제 결제와 무관하며, 할인/부분결제/결제 누락 등을 반영하지 않음





















