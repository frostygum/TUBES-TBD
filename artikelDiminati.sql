-- SP untuk mencari artikelDiminati
ALTER PROCEDURE artikelDiminati
AS

-- Declare cursor
DECLARE logCur CURSOR
FOR
	SELECT
		IdMember, IdArtikel, [Timestamp], aksi
	FROM
		LogMemberArtikel
	ORDER BY
		IdMember, IdArtikel, [Timestamp]

OPEN logCur

-- Declare tabel durasi
DECLARE @tblDurasi TABLE
(
	IdArtikel int,
	IdMember int,
	Durasi int
)

-- Declare tabel hasil
DECLARE @tblHasil TABLE
(
	IdArtikel int,
	DurasiDibaca int
)

-- Declare variabel
DECLARE
	@idMember int,
	@idArtikel int,
	@timestamp datetime,
	@waktuBuka datetime,
	@aksi varchar(5),
	@durasi int

FETCH NEXT FROM logCur
INTO
	@idMember,
	@idArtikel,
	@timestamp,
	@aksi


WHILE @@FETCH_STATUS = 0
BEGIN
	IF (@aksi = 'tutup')
	BEGIN
		SELECT @durasi = DATEDIFF(MINUTE, @waktuBuka, @timestamp)
		INSERT INTO 
			@tblDurasi
		SELECT
			@idArtikel, @idMember, @durasi
	END
	ELSE
		BEGIN
			SET @waktuBuka = @timestamp
		END

	FETCH NEXT FROM logCur
	INTO
		@idMember,
		@idArtikel,
		@timestamp,
		@aksi
END

CLOSE logCur
DEALLOCATE logCur

INSERT INTO
		@tblHasil
	SELECT 
		IdArtikel, SUM(Durasi)
	FROM
		@tblDurasi
	GROUP BY
		IdArtikel
	ORDER BY
		SUM(Durasi) DESC

SELECT * FROM @tblHasil

-- EXEC artikelDiminati