-- 셀프체크
-- 별그램 DB를 보고 다음 1~3을 수행하는 쿼리를 작성하세요.
-- (ch06_07_selfcheck.png 참고)

-- 1 사용자가 자신의 계정을 공개하는지 여부를 다음과 같이 조회하세요.
-- ------------------------
-- 닉네임      | 계정 공개 여부
-- ------------------------
-- 2 누가 올렸는지 확인할 수 있는 사진에 대해서만 사진 파일명과 올린 사람을 다음과 같이 조회하세요.
-- ------------------------
-- 파일명      | 게시자
-- ------------------------
-- 3 모든 사진에 대해 사진 파일명과 올린 사람을 다음과 같이 조회하세요.(올린 사람이 누구인지 모르는 사진도 조회합니다.)
-- ------------------------
-- 파일명      | 게시자
-- ------------------------

-- 1. 사용자 닉네임과 계정 공개 여부 조회
USE stargram;
SELECT nickname AS 닉네임, private '계정 공개 여부'
FROM users
JOIN settings ON settings.user_id = users.id;


-- 2. 사진 파일명과 올린 사람 닉네임 조회
SELECT filename, nickname
FROM users
JOIN photos ON photos.user_id = users.id;

-- 3. 모든 사진 파일명과 올린 사람 닉네임 조회
(
SELECT filename, nickname
FROM photos p
LEFT JOIN users u ON p.user_id = u. id
)
UNION -- 두 쿼리의 결과 테이블을 하나로 합치기(중복 데이터 제거)
(
SELECT filename, nickname
FROM photos p
RIGHT JOIN users u ON p.user_id = u. id
);
--------------------------------------------------------------------
-- 1. 사용자 닉네임과 계정 공개 여부 조회
SELECT 
	nickname AS 닉네임,
    private AS '계정 공개 여부'
FROM users u
JOIN settings s ON u.id = s.user_id;

-- 2. 사진 파일명과 올린 사람 닉네임 조회
SELECT 
	filename AS 파일명,
    nickname AS 게시자
FROM photos p
JOIN users u ON p.user_id = u.id;

-- 3. 모든 사진 파일명과 올린 사람 닉네임 조회
SELECT 
	filename AS 파일명,
    nickname AS 게시자
FROM photos p
LEFT JOIN users u ON p.user_id = u.id;

