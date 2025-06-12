-- Active: 1749607602857@@127.0.0.1@3306@companys


-- 셀프체크
-- 다음 데이터를 employees(직원) 테이블에 담아 관리하려고 합니다. 
-- 각 칼럼에 대한 설명을 참고해 다음 1~7을 수행하는 쿼리를 작성하세요.

-- employees
-- id  | name      | department     | salary
-- ------------------------------------------
-- 101   John        Sales            7000
-- 102   Aria        IT               5500
-- 103   Mike        Sales            8000
-- 104   Lily        HR               6500
-- 105   David       IT               7200
-- 106   Emma        Sales            6500
-- 107   Oliver      IT               5900
-- 108   Sophia      HR               6300
-- 109   Lucas       Sales            5500
-- 110   Charlotte   HR               6800

-- id: 각 직원의 아이디로, 기본키이며 정수로 작성합니다.
-- name: 직원 이름으로, 최대 50자까지 문자로 작성합니다.
-- department: 직원의 소속 부서로, 최대 50자까지 문자로 작성합니다.
-- salary: 직원의 연봉으로, 단위는 '천만 원'이며, 정수로 작성합니다.

-- 1 company DB를 생성 및 진입한 후 employees 테이블을 만드세요.
-- 2 employees 테이블에 직원 10명의 데이터를 삽입하세요.
-- 3 모든 직원의 연봉 합계를 계산하세요.
-- 4 Sales 부서의 평균 연봉을 구하세요.
-- 5 부서가 모두 몇 개 있는지 조회하세요.
-- 6 Sales 부서의 최대 연봉과 최소 연봉 차이를 구하세요.
-- 7 가장 높은 연봉을 받는 직원은 전체 평균 연봉 대비 얼마를 더 받는지 구하세요.


-- 1 company DB를 생성 및 진입한 후 employees 테이블을 만드세요.
CREATE DATABASE companys;

USE companys;
CREATE TABLE employees(
	id INTEGER,
	name VARCHAR(50),
	department VARCHAR(50),
	salary INTEGER,
	PRIMARY KEY(id)
);

-- 2 employees 테이블에 직원 10명의 데이터를 삽입하세요.
INSERT INTO employees(id, name, department, salary)
VALUES
	(101, 'John', 'Sales', 7000),
	(102, 'Aria', 'IT', 5500),
	(103, 'Mike', 'Sales', 8000),
	(104, 'Lily', 'HR', 6500),
	(105, 'David', 'IT', 7200),
	(106, 'Emma', 'Sales', 6500),
	(107, 'Oliver', 'IT', 5900),
	(108, 'Sophia', 'HR', 6300),
	(109, 'Lucas', 'Sales', 5500),
	(110, 'Charlotte', 'HR', 6800);

	SELECT * FROM employees;

-- 3 모든 직원의 연봉 합계를 계산하세요.
SELECT SUM(salary) AS '총 연봉'
FROM employees;
-- 4 Sales 부서의 평균 연봉을 구하세요.
SELECT AVG(salary) AS '평균 연봉'
FROM employees
WHERE department = 'Sales';
-- 5 부서가 모두 몇 개 있는지 조회하세요.
SELECT count(DISTINCT(department))
FROM employees;
-- 6 Sales 부서의 최대 연봉과 최소 연봉 차이를 구하세요.
SELECT 
MAX(salary) AS '최대 연봉',
MIN(salary) AS '최소 연봉',
MAX(salary) - MIN(salary) AS '최대 최소 차이'
FROM employees
WHERE department = 'Sales';
-- 7 가장 높은 연봉을 받는 직원은 전체 평균 연봉 대비 얼마를 더 받는지 구하세요.
SELECT
MAX(salary) AS '최대 연봉',
AVG(salary) AS '평균 연봉',
MAX(salary) / AVG(salary) * 100 AS '결과(%)'
FROM employees;