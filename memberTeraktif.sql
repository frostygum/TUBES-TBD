
-- CREATE PROCEDURE lihatMemberTeraktif
ALTER PROCEDURE lihatMemberTeraktif
AS

	DECLARE @res TABLE (
		IdMember INT, 
		IdArtikel INT,
		Durasi INT
	)

	DECLARE @resTotal TABLE (
		IdMember INT,
		TotalMenitBaca INT
	)

	DECLARE logData CURSOR
	FOR 
	SELECT
		IdMember, IdArtikel, [Timestamp], Aksi
	FROM
		LogMemberArtikel

	OPEN logData

	DECLARE
		@memberId INT, 
		@artikelId INT,
		@timestamp DATETIME,
		@aksi VARCHAR(10),
		@timeBefore DATETIME,
		@timeDiff INT

	FETCH NEXT 
		FROM logData 
		INTO @memberId, @artikelId, @timestamp, @aksi
	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		IF (@aksi = 'tutup')
		BEGIN
			SELECT @timeDiff = DATEDIFF(MINUTE, @timeBefore, @timestamp)

			INSERT INTO 
				@res
			SELECT
				@memberId, @artikelId, @timeDiff
		END
		ELSE
		BEGIN
			SET @timeBefore = @timestamp
		END

		FETCH NEXT 
			FROM logData 
			INTO @memberId, @artikelId, @timestamp, @aksi
	END

	CLOSE logData
	DEALLOCATE logData

	INSERT INTO
		@resTotal
	SELECT 
		IdMember, SUM(Durasi)
	FROM
		@res
	GROUP BY
		IdMember
	ORDER BY
		SUM(Durasi) DESC

	SELECT 
		[User].IdUser, [User].NamaDepan, [User].NamaBelakang, temp.TotalMenitBaca
	FROM
		@resTotal AS temp
	INNER JOIN
		[User] ON [User].IdUser = temp.IdMember

-- Eksekusi SP lihatMemberTeraktif
-- EXEC lihatMemberTeraktif