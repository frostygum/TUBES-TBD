-- SP untuk mencari artikelDiminati
ALTER PROCEDURE artikelDiminati
AS

-- Declare cursor untuk baca data dari tabel logMemberArtikel
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
		-- Jika aksi tutup, maka durasi akan dihitung dengan menghitung selisih waktu buka dan waktu tutup
		SELECT @durasi = DATEDIFF(MINUTE, @waktuBuka, @timestamp)
		-- Data disimpan ke tabel durasi sehingga berisi durasi per sesi baca
		INSERT INTO 
			@tblDurasi
		SELECT
			@idArtikel, @idMember, @durasi
	END
	ELSE
		-- Jika aksi buka, waktu timestamp akan disimpan sebagai waktu buka
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

-- Data dari tabel durasi akan dikelompokkan menurut ID artikel dan durasi dari seluruh sesi akan dijumlahkan
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

-- Menampilkan isi tabel hasil
SELECT * FROM @tblHasil

-- EXEC artikelDiminati