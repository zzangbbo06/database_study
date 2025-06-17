/*
9. 서브쿼리 활용하기
9.1 서브쿼리란
*/
-- 서브쿼리: 쿼리 안에 포함된 또 다른 쿼리
-- 안쪽 서브쿼리의 실행 결과를 받아 바깥쪽 메인쿼리가 실행됨

-- 서브쿼리 예: 다음 학생 중 성적이 평균보다 높은 학생은?
-- students
-- ----------------------
-- id  | name    | score
-- ----------------------
-- 1   | 엘리스    | 85
-- 2   | 밥       | 78
-- 3   | 찰리     | 92
-- 4   | 데이브    | 65
-- 5   | 이브     | 88

-- sub_query DB 생성 및 진입
CREATE DATABASE sub_query;
USE sub_query;

-- students 테이블 생성
CREATE TABLE students (
	id INTEGER AUTO_INCREMENT, 	-- 아이디(자동으로 1씩 증가)
	name VARCHAR(30), 			-- 이름
	score INTEGER, 				-- 성적
	PRIMARY KEY (id) 			-- 기본키 지정: id
);

-- students 데이터 삽입
INSERT INTO students (name, score)
VALUES
	('엘리스', 85),
	('밥', 78),
	('찰리', 92),
	('데이브', 65),
	('이브', 88);

-- 확인
SELECT * FROM students;

-- 평균 점수보다 더 높은 점수를 받은 학생 조회
SELECT *
FROM students
WHERE score > (평균_점수); -- (괄호 안이 서브쿼리로 작성할 부분)

-- 평균 점수 계산
SELECT AVG(score)
FROM students;

-- 위 커리를 서브쿼리로 사용
-- 메인 쿼리
SELECT *
FROM students
WHERE score > (
	-- 서브 쿼리: 평균 점수 계산
	SELECT AVG(score) 
	FROM students
);

-- 서브 쿼리의 특징 5가지
-- 1) 중첩 구조
-- 메인쿼리 내부에 중첩하여 작성
SELECT 컬럼명1, 컬럼명2, ...
FROM 테이블명
WHERE 컬럼명 연산자(
	서브쿼리
);

-- 2) 메인 쿼리와는 독립적으로 실행됨
-- 서브쿼리 우선 실행 후
-- 그 결과를 받아 메인쿼리가 수행됨

-- 3) 다양한 위치에서 사용 가능
-- SELECT
-- FROM / JOIN
-- WHERE/HAVING 등

-- 4) 단일 값 또는 다중 값을 반환
-- 단일 값 서브쿼리: 특정 값을 반환하는 서브쿼리(1행 1열)
-- 다중 값 서브쿼리: 여러 레코드를 반환하는 서브쿼리(N행 M열) - IN, ANY, ALL, EXISTS 연산자와 함께 사용됨
-- 5) 복잡하고 정교한 데이터 분석에 유용
-- 필터링 조건 추출 
-- 데이터 집계 결과 추출
-- => 이를 기준으로 메인쿼리를 수행

-- Quiz
-- 1. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① 서브쿼리는 메인쿼리 내부에 중첩해 작성한다. (  )
-- ② 서브쿼리는 다양한 위치에서 사용할 수 있다. (  )
-- ③ 서브쿼리는 단일 값만 반환한다. (  )

-- 정답: O, O, X

/*
9.2 다양한 위치에서의 서브쿼리
*/
-- 8장에서 다루었던 마켓 DB를 기반으로 다양한 서브쿼리를 연습!
USE market;

-- 1. SELECT 절에서의 서브쿼리
-- 1x1 단일값만 반환하는 서브쿼리만 사용 가능
-- 여러 행 또는 여러 컬럼을 반환하면 SQL이 어떤 값을 선택해야 할 지 몰라 에러 발생

-- 모든 결제 정보에 대한 평균 결제 금액과의 차이는?
SELECT
	payment_type AS '결제 유형',
    amount AS '결제 금액',
    amount - (	
				SELECT AVG(amount) 
				FROM payments
                ) AS '평균 결제 금액과의 차이'
FROM payments;

-- 잘못된 사용 예
SELECT
	payment_type AS '결제 유형',
    amount AS '결제 금액',
    amount - (SELECT AVG(amount), '123' FROM payments) AS '평균 결제 금액과의 차이'
FROM payments; -- -> 에러코드: 단일 값만 반환해야하는데 그렇지 않기 때문, SELECT는 어떤것 하나를 사용해야할지 모름


-- 2. FROM 절에서의 서브쿼리
-- N x M 반환하는 행과 컬럼의 개수에 제한이 없음
-- 단, 서브쿼리에 별칭 지정 필수

-- 1회 주문 시 평균 상품 개수? (장바구니 상품 포함)
-- 주문별(order_id)로 그룹화 -> count 집계: SUM() -> 재집계: AVG()
-- 일단 먼저 주문 당 상품 개수 집계 구하기

SELECT 
	order_id, 
	SUM(count) AS total_count
FROM order_details od
GROUP BY order_id; -- 서브쿼리로 사용


-- 메인쿼리: 1회 주문 시 평균 상품 개수 집계
SELECT AVG(total_count) AS '1회 주문 시 평균 상품 개수'
FROM(
SELECT 
	order_id, 
	SUM(count) AS total_count -- 집계 함수 결과에 별칭 필수(컬럼명이 아니라 계산된 값을 반환하기 때문에)
FROM order_details od
GROUP BY order_id	
) AS sub; -- 별칭 필수(AS는 생략 가능), 원리: 이름이 없어서 이름을 지어줌 

-- 3. JOIN 절에서의 서브쿼리
-- N x M 반환하는 행과 컬럼의 개수에 제한이 없음
-- 단, 서브쿼리에 별칭 지정 필수

-- 상품별 주문 개수를 '배송 완료'와 장바구니'에 상관없이 상품명과 주문 개수를 조회한다면?
SELECT 
	name AS 상품명,
  total_count
FROM products p
JOIN (
	-- 서브쿼리: 상품 아이디별 주문 개수 집계
    SELECT 
			product_id, 
      SUM(count) AS total_count
    FROM order_details 
	GROUP BY product_id -- 번개 버튼으로 실행 결과 확인
) AS sub ON sub.product_id = p.id;

-- (참고) 다른 방법: 일단 붙여놓고 그룹화 및 집계 
SELECT 
	name AS 상품명,
    SUM(count) AS '주문 개수'
FROM order_details od
JOIN products p ON od.product_id = p.id
GROUP BY name;

-- 4. WHERE 절에서 서브쿼리
-- 1x1, Nx1 반환하는 서브쿼리만 사용 가능
-- (필터링의 조건으로 값 또는 값의 목록을 사용하기 때문)

-- 평균 가격보다 비싼 상품을 조회 하려면?
SELECT *
FROM products
WHERE price > (
	-- 서브쿼리: 평균 가격
    SELECT AVG(price) 
	FROM products
);
-- 평균 가격을 서브쿼리로 구해서 넣으면 됨

-- 5. HAVING 절에서의 서브쿼리
-- 1x1, Nx1 반환하는 서브쿼리만 사용 가능
-- (필터링의 조건으로 값 또는 값의 목록을 사용하기 때문)

-- 크림치즈보다 매출이 높은 상품은? (장바구니 상품 포함)
-- 상품 x 주문상세 조인해서 -> 상품명으로 그룹화 -> 상품별로 매출을 집계
-- 메인쿼리: 전체 상품의 매출을 조회 => 크림 치즈보다 매출이 높은 상품 조회로 변경
SELECT 
	name AS 상품명,
    SUM(price * count) AS 매출
FROM products p
JOIN order_details od ON od.product_id = p.id
GROUP BY name
HAVING SUM(price * count) > (
								-- 서브쿼리: 크림 치즈의 매출(= 8720)
								SELECT SUM(price * count)
								FROM products p
								JOIN order_details od ON od.product_id = p.id
                                WHERE name = '크림 치즈'
							);

-- Quiz
-- 2. 다음 설명이 맞으면 O, 틀리면 X를 표시하세요.
-- ① SELECT 절의 서브쿼리는 단일 값만 반환해야 한다. (  )
-- ② FROM 절과 J0IN 절의 서브쿼리는 별칭을 지정해야 한다. (  )
-- ③ WHERE 절과 HAVING 절의 서브쿼리는 단일 값 또는 다중 행의 단일 칼럼을 반환할 수 있다. (  )

-- 정답: O, O, O

/*
9.3 IN, ANY, ALL, EXISTS
*/
-- 주로 WHERE 절에서의 서브쿼리와 쓰임


-- 1. IN 연산자
-- 괄호 사이 목록에 포함되는 대상을 찾음


-- 형식
컬럼명 IN(쉼표로_구분된_값_목록);
-- 또는 
컬럼명 IN (다중_행의_단일_컬럼을_반환하는_서브쿼리);

-- IN 연산자 사용 예1: 값 목록을 입력받은 경우
-- 상품명이 '우유 식빵', '크림 치즈'인 대상의 id 목록은?
SELECT id
FROM products
WHERE name IN('우유 식빵', '크림 치즈');

-- IN 연산자 사용 예2: 서비쿼리를 입력받은 경우
-- '우유 식빵', '크림 치즈'를 포함하는 모든 주문의 상세 내역
SELECT *
FROM order_details
WHERE product_id IN (
		-- 서브쿼리: 우유 식빵과 크림 치즈의 아이디를 반환(Nx1)
        SELECT id
        FROM products
        WHERE name IN ('우유 식빵', '크림 치즈')
);


-- IN 연산자 사용 예3: 조인과 IN 연산자
-- '우유 식빵', '크림 치즈'를 주문한 사용자의 아이디와 닉네임은?
-- users에 products를 바로 붙일 수 없으므로 orders와 order_details를 붙여 연결
SELECT 
	DISTINCT u.id,
	nickname
FROM users u
JOIN orders o ON u.id = o.user_id
JOIN order_details od ON o.id = od.order_id
JOIN products p ON od.product_id = p.id
WHERE name IN ('우유 식빵', '크림 치즈');

-- 2. ANY 연산자
-- 지정된 집합의 모든 요소와 비교 연산을 수행하여 하나라도 만족하는 대상을 찾음

-- 형식
컬럼명 비교_연산자 ANY(다중_행의_단일_컬럼을_반환하는_서브쿼리);

-- '우유 식빵'이나 '플레인 베이글'보다 저렴한 상품 목록은?
-- 메인쿼리
SELECT name AS 이름, price AS 가격
FROM products
WHERE price < ANY(
	-- 서브 쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT price
    FROM products
    WHERE name IN('우유 식빵','플레인 베이글') -- 2900, 1300
); -- 결과적으로 2900원 보다 작은 모든 상품 조회, 하나라도 해당되면 조회

-- 3. ALL 연산자
-- 지정된 집합의 모든 요소와 비교 연산을 수행하여 모두를 만족하는 대상을 찾음

-- 형식
컬럼명 비교_연산자 ALL(다중_행의_단일_컬럼을_반환하는_서브쿼리);

-- '우유 식빵'이나 '플레인 베이글'보다 비싼 상품 목록은?
SELECT name AS 이름, price AS 가격
FROM products
WHERE price > ALL(
	-- 서브 쿼리: 우유 식빵과 플레인 베이글의 가격 조회
    SELECT price
    FROM products
    WHERE name IN('우유 식빵','플레인 베이글')
); -- 결과적으로 2900원 보다 큰 모든 상품 조회, 둘다 해당되어야 조회

-- 4. EXISTS 연산자
-- 입력받은 서브커리가 하나 이상의 행을 반환하는 경우 TRUE, 그렇지 않으면 FALSE를 반환

-- 형식
SELECT 컬러명1, 컬럼명2, ...
FROM 테이블명
WHERE EXISTS (서브쿼리);

-- 적어도 1번 이상 주문한 사용자를 조회하려면?
-- 메인쿼리 
SELECT *
FROM users u
WHERE EXISTS( -- 존재하기만 하면 true 반환
	-- 서브쿼리: 주문자 아이디가 사용자 테이블에 있다면 1 반환
    SELECT 1 -- *: 굳이 모든 컬럼을 다 가져오는 것 보다 1만 써주는게 효율적 -> 1을 반환
    FROM orders o
	WHERE o.user_id = u.id -- 이렇게 서브쿼리가 메인쿼리의 특정 값을 참조하는 쿼리를 '상관 쿼리'라고 함
);
-- (참고)상관 쿼리의 동작 원리
-- users 테이블 1번 사용자의 주문이 있는지
-- orders 테이블을 반복하며 확인 
-- 같은 방식으로 2번 사용자, 3번 사용자도 확인
-- EXISTS는 결과가 하나라도 존재하면 TRUE가 되기 때문에, 매칭되는 레코드를 찾으면 더 이상 검사하지 않음

-- (참고) 상관 쿼리의 특징
-- 1) 의존성: 서브쿼리는 메인쿼리의 값을 참조해 데이터 필터링을 수행
-- 2) 반복 실행: 서브쿼리는 메인쿼리의 각 행에 대해 반복적으로 실행됨
-- 3) 성능 저하: 메인쿼리의 각 행마다 서브쿼리를 실행하므로 쿼리 전체의 성능이 저하될 수 있음(특히 데이터 양이 많을 경우)

-- NOT EXISTS 연산자 실습
-- 'COCOA PAY'로 결제하지 않은 사용자를 조회하려면?
-- 메인쿼리
SELECT *
FROM users u
WHERE NOT EXISTS( 
	-- 서브쿼리: COCOA PAY를 사용한 사용자가 있다면 1을 반환
    SELECT 1 -- 존재 여부만 확인할 때 사용하는 관행
    FROM orders o
    JOIN payments p ON p.order_id = o.id
    WHERE o.user_id = u.id AND payment_type = 'COCOA PAY'
);
-- 의미: 주문과 결제 테이블에서 COCOA PAY를 사용한 사용자가 있다면 그 놈을 제외한 사용자를 뽑아줘

-- Quiz
-- 3. 다음 빈칸에 들어갈 용어를 고르세요.
-- ① __________: 지정된 집합에 포함되는 대상을 찾음
-- ② __________: 별칭을 지정하는 키워드로, 생략하고 사용할 수 있음
-- ③ __________: 지정된 집합의 모든 요소와 비교 연산을 수행해 하나라도 만족하는 대상을 찾음
-- ④ __________: 지정된 집합의 모든 요소와 비교 연산을 수행해 모두를 만족하는 대상을 찾음
-- ⑤ __________: 서브쿼리를 입력받아 서브쿼리가 하나 이상의 행을 반환할 경우 TRUE, 그렇지 않으면 FALSE 반환

-- (ㄱ) AS
-- (ㄴ) ANY
-- (ㄷ) IN
-- (ㄹ) ALL
-- (ㅁ) EXISTS

-- 정답: ㄷㄱㄴㄹㅁ
































