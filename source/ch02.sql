-- 주석
-- 쿼리 설명을 위한 코드 (실행되지 않음)
-- 한 줄 주석
# 또 다른 한 줄 주석

/*
블록 주석
여러 줄 주석
*/ 

-- 쿼리(query)란? '문의하다', '질문하다'라는 뜻
-- 예) 데이터베이스에 사용자가 원하는 특정 데이터를 보여달라고 요청하는 것
-- 쿼리는 SQL을 이용해 하나의 명령문으로 작성
-- 하나의 쿼리는 하나의 ;(세미콜론)으로 구분 
SELECT 'hello world!'; -- 쿼리문이라고 부름

/*
권장 SQL 작성
대문자: MySQL 키워드
소문자: 사용자가 직접 만든 변수
*/

/*
2. 데이터 생성, 조회, 수정, 삭제하기
2.1 데이터 CRUD
*/
-- CRUD란? DB가 제공하는 기본 동작으로
-- 생성(Create)
-- 조회(Read)
-- 수정(Update)
-- 삭제(Delete)

-- CRUD 실습
-- 맵도날드 DB 실습

/*
2.2 데이터베이스 만들기
*/
-- 데이터베이스 목록 조회
SHOW DATABASES;
-- MySQL 설치 시 기본적으로 깔려있는 시스템 데이터베이스
-- (MySQL 서버 운영 유지 관리에 중요한 역할, 우리가 건드릴 일 없음)

-- 데이터베이스 생성
-- CREATE DATABASE 데이터베이스이름; 
CREATE DATABASE mapdonalds;

-- 데이터 베이스 진입(접속)
-- USE 데이터베이스이름;
USE mapdonalds;

-- 현재 사용 중인 DB 조회
SELECT DATABASE();

-- 데이터베이스 삭제 
-- DROP DATABASE 데이터베이스이름;
DROP DATABASE mapdonalds;

-- Quiz
-- 1. 다음 설명 중 옳지 않은 것은?
-- ① 데이터 CRUD란 데이터를 생성(Create), 조회(Read), 수정(Update), 삭제(Delete)하는 것을 말한다. 
-- ② 쿼리란 데이터베이스에 내릴 명령을 SQL 문으로 작성한 것이다.
-- ③ 쿼리는 하나의 ;(세미콜론)으로 구분한다.
-- ④ MySQL은 쿼리의 대소문자를 구분한다.
-- ⑤ 주석은 쿼리 실행에 영향을 미치지 않는다.

-- 정답: 4



/*
2.3 데이터 삽입 및 조회하기
*/
-- 실습: 맵도날드 DB에 버거 테이블을 만들고, 다음 데이터를 삽입 및 조회

-- Quiz: 다시 mapdonalds DB 생성 및 진입
CREATE DATABASE mapdonalds;
USE mapdonalds;

-- 테이블 생성
-- CREATE TABLE 테이블명(
-- 	   컬럼명1 자료형1,
--     컬럼명2 자료형 2,
--     ...
--     PRIMARY KEY(컬럼명)
-- );
CREATE TABLE burgers(
	id INTEGER, -- 아이디(정수: -1, 0, 1, 2, ...)
    name VARCHAR(50), -- 이름(최대 50글자의 문자: '빅맥', '상하이 치즈 버거', ...)
    -- VARCHAR(N): 문자를 최대 N자리까지 저장, 문법상 필수(가변 길이 타입이라 저장될 수 있는 최대 길이의 제한을 알아야 하기 때문)
    price INT, -- 가격(정수: 원)
    gram INTEGER, -- 무게(정수: g)
    kcal INT, -- 열량(정수: kcal)
    protein INTEGER, -- 단백질량(정수: g)
    
    PRIMARY KEY(id) -- 기본키 지정: id
);
-- 기본키: 레코드(row)를 대표하는 컬럼(예: 사람의 주민등록번호)
-- 테이블에 저장된 모든 버거를 구분하기 위한 컬럼
-- 중복되지 않은 값을 가짐

-- 테이블 구조 조회
-- DESC 테이블명;
DESC burgers; -- 테이블의 구조를 설명해줘(describe)
-- Field: 테이블의 컬럼
-- Type: 컬럼의 자료형(int는 INTEGER의 별칭)
-- Null: 컬럼에 빈 값을 넣어도 되는지. 즉, 입력값이 없어도 되는지 여부(기본키는 NO: 반드시 값이 들어가야 함)
-- Key: 대표성을 가진 컬럼(기본키, 외래키, 고유키 등의 특별한 대표성을 가지는지를 의미)
-- Default: 컬럼의 기본값(입력값이 없을 시 설정할 기본값)
-- Extra: 추가 설정(컬럼에 적용된 추가 속성)


-- 단일 데이터 삽입하기
-- INSERT INTO 테이블명 (컬럼명1, 컬럼명2, ...)
-- VALUES(입력값1, 입력값2, ...);
-- 컬럼 순서에 맞게 값 입력
INSERT INTO burgers (id, name, price, gram, kcal, protein)
VALUES(1, '빅맨', 5300, 223, 583, 27);
-- 컬럼 생략 가능? 가능하지만 테이블 정의와 정확히 일치해야 함
-- 항상 컬럼을 명시하는 방식을 권장

-- 데이터 조회하기
-- SELECT 컬럼명1, 컬럼명2, ... -- 컬러명 대신 *을 쓰면 모든 컬럼 조회
-- FROM 테이블명
-- WHERE 조건; -- 검색 조건(생략하면 전체 조회)

-- burgers 테이블의 모든 컬럼 조회
SELECT * -- 모든 컬럼을 조회
FROM burgers; -- 버거 테이블에서


-- 다중 데이터 삽입하기
INSERT INTO 
burgers (id, name, price, gram, kcal, protein)
VALUES
	(2, '베이컨 틈메이러 디럭스', 6200, 242, 545, 27),
	(3, '맨스파이시 상하이 버거', 5300, 235, 494, 20),
	(4, '슈비두밥 버거', 6200, 269, 563, 21),
	(5, '더블 쿼터파운드 치즈', 7700, 275, 770, 50);

-- burgers 테이블의 이름과 가격만 조회
SELECT name, price -- 특정 컬럼을 조회: 이름, 가격
FROM burgers; -- 버거 테이블에서

-- Quiz
-- 2. 다음 빈칸에 들어갈 용어를 순서대로 고르면? (입력 예: ㄱㄴㄷㄹㅁ)
-- ① __________: 테이블을 만드는 SQL 문
-- ② __________: 정수형 숫자(-1, 0. 1, )를 저장하기 위한 자료형
-- ③ __________: 문자를 저장하기 위한 자료형(최대 길이 지정 가능)
-- ④ __________: 테이블에 데이터를 삽입하는 SQL 문
-- ⑤ __________: 테이블의 데이터를 조회하는 SQL 문

-- (ㄱ) INSERT INTO 문
-- (ㄴ) CREATE TABLE 문
-- (ㄷ) INTEGER
-- (ㄹ) VARCHAR
-- (ㅁ) SELECT 문

-- 정답: ㄴ, ㄷ, ㄹ, ㄱ, ㅁ

/*
2.4 데이터 수정 및 삭제하기
*/
-- 데이터 수정하기: UPDATE
UPDATE 테이블명
SET 컬럼명 = 입력값 -- 어떤 컬럼에 어떤 값을 입력할지
WHERE 조건; -- 수정 대상을 찾는 조건(생략하면 전체 대상)

-- 모든 레코드 수정하기
-- 모든 버거를 1000원에 판매하는 이벤트가 열렸다!
-- 이를 위한 쿼리는?

-- 모든 버거의 가격을 1000으로 수정
UPDATE burgers
SET price = 1000; 
-- 에러 발생: MySQL Workbench의 기본 세팅 때문에 발생
-- 모든 값을 일괄적으로 변경하는 것을 막고 있음
-- 에러메시지 확인: Safe Update 모드는 워크벤치의 보호 기능으로 KEY 없는 UPDATE/DELETE 차단함

-- 임시로 안전모드 해제(권장 안함)
SET SQL_SAFE_UPDATES = 0; -- 0: 해제, 1: 설정

-- 전체 버거 조회
SELECT name, price
FROM burgers;

SET SQL_SAFE_UPDATES = 1; -- 0: 해제, 1: 설정

-- 특정(단일) 레코드 수정하기
-- 추가 이벤트! '빅맨' 버거 단 500원!
-- 이를 위한 쿼리는?
-- UPDATE burgers
-- SET price = 500
-- WHERE name = '빅맨'; -- 특정 대상값 변경 시, 조건은 반드시 기본키를 사용
-- 왜? 안전모드에서는 KEY(기본키나 유니크 키) 칼럼이 아닌 다른 값을 사용하면 막음

-- 수정 대상 조건 개선: 키를 통한 변경 쿼리
UPDATE burgers
SET price = 500
WHERE id = 1;

-- 데이터 삭제하기: DELETE
-- DELETE FROM 테이블명
-- WHERE 조건; -- 삭제 대상을 찾는 조건

-- '슈비두밥 버거'가 단종됐다면, 이를 위한 데이터 삭제 쿼리는?
DELETE FROM burgers
WHERE name = '슈비두밥 버거'; -- 에러 발생: 안전모드로 인해 수정과 동일하게 조건은 반드시 기본키를 사용

-- 슈비두밥 버거 삭제 -> id가 4인 버거를 삭제

DELETE FROM burgers
WHERE id = 4;

-- 테이블 삭제하기
-- 테이블 속 데이터 뿐만 아니라, 테이블 자체를 삭제하는 방법은?
-- DROP TABLE 테이블명;

-- burgers 테이블을 삭제하는 쿼리는?
DROP TABLE burgers;

-- burgers 테이블 구조 확인
DESC burgers;

-- 전체 데이터 조회
SELECT *
FROM burgers;

-- Quiz
-- 3. 다음 설명에 대한 용어를 고르면? (입력 예: ㄱㄴㄷㄹㅁ)
-- ① 테이블의 데이터를 수정하는 SQL 문
-- ② 특정조건을 만족하는 튜플을 조회하는 SQL 문
-- ③ 테이블의 데이터를 튜플 단위로 삭제하는 SQL 문
-- ④ 테이블 자체를 삭제하는 SQL 문
-- ⑤ 데이터베이스 자체를 삭제하는 SQL 문

-- (ㄱ) DELETE 문
-- (ᄂ) DROP TABLE 문
-- (ᄃ) UPDATE 문
-- (ᄅ) SELECT 문
-- (ᄆ) DROP DATABASE 문

-- 정답: ㄷㄹㄱㄴㅁ


