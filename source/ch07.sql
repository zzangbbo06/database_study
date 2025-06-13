/*
7. 테이블 조인하기
7.1 조인이란
*/
-- 두 테이블로 나뉜 여러 정보를 하나로 연결하여 가져오는 명령
-- 테이블 간에 일치하는 컬럼을 기준으로 두 테이블을 하나로 합쳐 보여줌

-- 조인 컬럼(기준이 되는 컬럼): 
-- 두 테이블이 동시에 가지고 있는 컬럼으로 조인하기 위해 사용하는 컬럼
-- 보통 한 테이블의 외래키(FK)와 다른 테이블의 기본키(PK)를 사용 
-- 관계와 조인은 다름

-- (참고) 외래키를 사용하지 않아도 JOIN은 할 수 있음
-- 그럼 외래키를 왜 쓰는 걸까? 데이터의 무결성을 보장하기 위한 제약 조건
-- 존재하지 않는 ID를 참조하지 못하게 막음
-- 부모 테이블 데이터 삭제 시 자식 처리 정의 가능
-- 실수로 잘못된 참조값을 넣는 것 방지

-- 조인 하기
-- 특정 사진에 달린 모든 댓글의 닉네임과 본문을 조회하는 법?

USE stargram;

-- 1번 사진 댓글 정보 조회
SELECT * 
FROM comments
WHERE photo_id = 1;

-- 테이블 조인 형식
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블 A
-- JOIN 테이블 B ON 테이블A.조인_컬럼 = 테이블 B.조인_컬럼;
-- JOIN만 명시하면 기본적으로 INNER JOIN으로 해석

-- 댓글 본문과 사용자 닉네임을 합쳐서 가져오기
SELECT *
FROM comments
JOIN users ON comments.user_id = users.id;

-- JOIN users: 사용자 테이블을 붙일건데
--  ON: 댓글 테이블의 외래키 = 사용자 테이블의 기본키와 같은 것끼리 

-- 1번 사진에 달린 모든 댓글 본문과 작성자 닉네임 가져오기
SELECT nickname, body -- 4) 닉네임과 본문을 조회한다.
FROM comments -- 1) 댓글 테이블에
JOIN users -- 2) 사용자 테이블 조인한다. 
  ON comments.user_id = users.id -- 2) 해당 조건으로
WHERE photo_id = 1; -- 3) 1번 사진과 관련된 것만 남긴 후, = 필터링
-- FROM --> JOIN -> WHERE -> SELECT 

-- 조인의 특징 7가지
-- 1) 조인 컬럼이 필요
-- 두 테이블을 연결하기 위한 공통 컬럼이 필요
-- 보통 외래키와 기본키를 기준으로 조인
SELECT *
FROM comments
JOIN users ON comments.user_id = users.id; -- 조인 컬럼(외래키) = 조인 컬럼(기본키)

-- 2) 조인 칼럼은 서로 자료형이 일치해야함
-- 일치해야 조인 가능
-- 예: 숫자 1과 문자열 '1'은 서로 조인 불가

-- 3) 조인 조건이 필요
-- ON 절과 함께 사용
-- 두 테이블을 어떻게 연결할지를 조인 조건으로 명시

-- 4) 연속적인 조인 가능
-- 연속 조인 연습
SELECT nickname, body, filename -- 4) 원하는 컬럼 조회
FROM comments -- 1) 댓글 테이블에
JOIN users ON comments.user_id = users.id -- 2) 사용자 테이블 조인하고
JOIN photos ON comments.photo_id = photos.id; -- 3) 다시 사진 테이블 조인 후

-- 5) 중복 컬럼은 테이블명을 붙여 구분
-- 컬럼명이 같은 경우 어느 테이블의 것인지 명시해야 함(그렇지 않은 경우 에러 발생)
-- 사용 예: 중복 컬럼 id에 테이블명 명시
SELECT body, nickname, users.id, comments.id
FROM comments
JOIN users ON comments.user_id = users.id
WHERE photo_id = 2;

-- 6) 테이블명에 별칭 사용 가능
-- 간결한 쿼리 작성 및 가독성 향상에 도움
-- 사용 예: comments 테이블과 users 테이블에 별칭 붙이기

SELECT body, nickname
FROM comments AS c
JOIN users u ON c.user_id = u.id;
-- 참고 : 테이블에 별칭을 붙일 때는 AS를 거의 생략

-- 7) 다양한 조인 유형 사용 가능
-- 다양한 결과 테이블 생성에 도움
-- INNER 조인
-- LEFT 조인
-- RIGHT 조인
-- FULL 조인


-- Quiz
-- 1. 다음은 comments 테이블과 photos 테이블을 조인하는 쿼리이다.
-- 빈칸을 순서대로 채워 쿼리를 완성하시오. (예: aaa, bbb, ccc)

-- SELECT body, filename
-- FROM comments ① __________
-- ② __________ photos AS p ③ __________ c.photo_id = p.id;

-- 정답: 

-- 2. 다음 조인에 대한 설명으로 옳지 않은 것은?
-- ① 조인 칼럼은 자료형이 달라도 된다.
-- ② 조인 조건은 JOIN 절의 ON 키워드 다음에 작성한다.
-- ③ 중복 칼럼은 '테이블명.칼럼명'과 같이 테이블명을 붙여 구분한다.
-- ④ 조인 테이블에 별칭을 붙일 때는 AS 키워드를 사용한다.

-- 정답: 1


/*
7.2 조인의 유형
*/
-- 1. INNER 조인
-- 가장 기본이 되는 조인
-- 두 테이블에서 조인 조건을 만족하는(조인 컬럼이 같은) 데이터를 찾아 조인함
-- INNER 키워드 생략 가능

-- 형식:
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A
-- INNER JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼;

-- photos 테이블과 users 테이블 INNER 조인
SELECT *
FROM photos p
INNER JOIN users u ON p.user_id = u.id;

SELECT *
FROM users u
INNER JOIN  photos p  ON p.user_id = u.id;

-- 방향은 상관없음 but LEFT, RIGHT에서는 상관 있음

-- OUTER JOIN: 두 테이블 간의 조인 결과에 누락된 행을 포함시킬 수 있는 조인 방식, 종류는 크게 3가지
-- 2. LEFT 조인
-- 왼쪽 테이블(FROM 절 테이블)의 모든 데이터에 오른쪽 테이블(JOIN 절 테이블)을 조인함
-- 왼쪽 테이블은 모든 데이터를 가져오지만, 오른쪽 테이블은 조인 조건을 만족하는 것만 가져옴
-- 조인 조건을 만족하지 않는 경우, NULL 값으로 채움

-- 형식:
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A
-- LEFT JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼;

-- photos 테이블과 users 테이블 LEFT 조인
SELECT *
FROM photos p
LEFT JOIN users u ON p.user_id = u. id;

-- 3. RIGHT 조인
-- 오른쪽 테이블(JOIN 절 테이블)의 모든 데이터에 왼쪽 테이블(FROM 절 테이블)을 조인함
-- 오른쪽 테이블은 모든 데이터를 가져오지만, 왼쪽 테이블은 조인 조건을 만족하는 것만 가져옴
-- 조인 조건을 만족하지 않는 경우, NULL 값으로 채움
-- LEFT 조인에서 기준만 바뀌고 동일하기에 거의 사용되지 않음

-- photos 테이블과 users 테이블 RIGHT 조인
SELECT *
FROM photos p
RIGHT JOIN users u ON p.user_id = u. id; --> LEFT 에서 반대로 된것이기 때문에 LEFT를 많이 씀

-- 형식:
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A
-- RIGHT JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼;



-- 4. FULL 조인
-- 두 테이블의 모든 데이터를 결합하는 조인
-- 조인 불가능한 것은 NULL 값으로 채움
-- LEFT 조인 + RIGHT 조인의 결과에 중복을 제거한 것
-- (두 테이블에 조인 컬럼 값이 같은 데이터뿐만 아니라, 한쪽 테이블에 존재하는 데이터도 모두를 반환)

-- MySQL은 FULL 조인을 제공하지 않음
-- 형식:
-- SELECT 컬럼명1, 컬럼명2, ...
-- FROM 테이블A
-- FULL JOIN 테이블B ON 테이블A.조인_컬럼 = 테이블B.조인_컬럼;

-- 5. UNION 연산자
-- 두 쿼리의 결과를 하나의 테이블로 합치는 집합 연산자
-- SELECT 결과를 단순히 위아래로 붙이는 연산
-- UNION을 사용하려면 두 쿼리의 결과 테이블 내 컬럼 개수와 각 컬럼의 자료형이 일치해야 함

-- 중복 튜플 제거하고 합치기
-- (쿼리A)
-- UNION
-- (쿼리B);

-- 중복 튜플 그대로 둔 채 합치기
-- (쿼리A)
-- UNION ALL
-- (쿼리B);


-- UNION  연산을 활용하면 FULL 조인 결과를 생성 가능
-- photos 테이블과 users 테이블 FULL 조인 = LEFT 조인 + RIGHT 조인(중복 제거) => UNION
(
SELECT *
FROM photos p
LEFT JOIN users u ON p.user_id = u. id
)
UNION -- 두 쿼리의 결과 테이블을 하나로 합치기(중복 데이터 제거)
(
SELECT *
FROM photos p
RIGHT JOIN users u ON p.user_id = u. id
);


-- Quiz
-- 3. 다음 빈칸에 들어갈 용어를 차례대로 쓰시오. (예: ㄱㄴㄷㄹㅁ)
-- ① __________: 가장 기본적인 조인 유형으로, 두 테이블에서 조인 조건을 만족하는 튜플을 찾아 조인
-- ② __________: 왼쪽 테이블의 모든 튜플에 대해 조인 조건을 만족하는 오른쪽 테이블의 튜플을 조인하고, 조인할 수 없는 경우 NULL 값으로 채움
-- ③ __________: 오른쪽 테이블의 모든 튜플에 대해 조인 조건을 만족하는 왼쪽 테이블의 튜플을 조인하고, 조인할 수 없는 경우 NULL 값으로 채움
-- ④ __________: 두 테이블 사이에서 조인이 가능한 튜플뿐만 아니라 조인 불가능한 튜플도 모두 가져오고 빈 칼럼은 NULL 값으로 채움
-- ⑤ __________: 두 쿼리의 결과 테이블을 하나로 합침

-- (ㄱ) FULL JOIN
-- (ㄴ) INNER JOIN
-- (ㄷ) UNION
-- (ㄹ) RIGHT JOIN
-- (ㅁ) LEFT JOIN

-- 정답: ㄴㅁㄹㄱㄷ


/*
7.3 조인 실습: 별그램 DB
*/
-- 가장 많이 사용되는 INNER 조인과 LEFT 조인을 연습!
USE stargram;
-- 1. 특정 사용자가 올린 사진 목록 출력하기
-- 예: 홍팍이 업로드한 모든 사진의 파일명은?
SELECT filename
FROM photos p
JOIN users u ON p.user_id = u.id
WHERE nickname = '홍팍';

-- (참고) 또는 필터링을 조인과 동시에 가능
SELECT 
  nickname AS 게시자,
  filename AS 파일명
FROM users u
JOIN photos p 
  ON p.user_id = u.id
  AND nickname = '홍팍';

-- 2. 특정 사용자가 올린 사진의 좋아요 개수
-- 예: 홍팍이 올린 모든 사진의 좋아요 개수는?
SELECT COUNT(*)
FROM users u -- 1) 사용자 정보를 가지고
JOIN photos p -- 2) 사진 정보를 합쳐서
    ON u.id = p.user_id
JOIN likes l -- 3) 좋아요 정보도 합쳐서
    ON p.id = l.photo_id
    AND nickname = '홍팍';

-- 3. 특정 사용자가 쓴 댓글 개수
-- 예: 해삼이가 작성한 모든 댓글의 개수는?
SELECT COUNT(*)
FROM users u
JOIN comments c ON c.user_id = u.id
                AND nickname = '해삼';

-- 4. 모든 댓글 본문과 해당 댓글의 달린 사진의 파일명
-- 예: 모든 댓글 본문과 함께 그 댓글이 달린 사진의 파일명을 함께 조회하려면?
SELECT body, filename
FROM comments c
LEFT JOIN photos p 
  ON c.photo_id = p.id;


-- Quiz
-- 4. 다음 설명이 맞으면 O, 틀리면 X를 순서대로 표시하시오. (예: O, X, O, X)
-- ① INNER 조인은 INNER 키워드를 생략할 수 있다. (  )
-- ② INNER 조인은 조인이 불가능한 튜플도 가져와 연결한다. (  )
-- ③ LEFT 조인은 왼쪽 테이블의 모든 데이터에 대해 오른쪽 테이블에 조인 조건을 만족하는 데이터를 가져와 연결하고 
--   오른쪽 테이블에 해당하는 데이터가 없으면 NULL 값으로 채운다. (  )
-- ④ 조인 조건에 AND 연산자를 사용하면 조인과 동시에 데이터 필터링을 할 수 있다. (  )

-- 정답: O, X, O, O




























