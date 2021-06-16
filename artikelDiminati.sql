-- SP untuk mencari artikelDiminati
ALTER PROCEDURE artikelDiminati
AS

-- Declare cursor
DECLARE logCur CURSOR
FOR
	SELECT
		TOP 10 IdArtikel, COUNT(Id) AS JumlahDibaca
	FROM
		LogMemberArtikel
	WHERE
		aksi = 'buka'
	GROUP BY
		IdArtikel
	ORDER BY
		JumlahDibaca DESC

OPEN logCur

-- Declare tabel hasil
DECLARE @tblHasil TABLE
(
	IdArtikel int,
	JumlahDibaca int
)

-- Declare variabel
DECLARE
	@idArtikel int,
	@jumlahDibaca int

FETCH NEXT FROM logCur
INTO
	@idArtikel,
	@jumlahDibaca

WHILE @@FETCH_STATUS = 0
BEGIN
	INSERT INTO @tblHasil
	SELECT @idArtikel, @jumlahDibaca
	FETCH NEXT FROM logCur
	INTO
		@idArtikel,
		@jumlahDibaca
END

CLOSE logCur
DEALLOCATE logCur

SELECT * FROM @tblHasil

EXEC artikelDiminati