
-- CREATE PROCEDURE lihatMemberTeraktif
ALTER PROCEDURE lihatMemberTeraktif
(
	@showNum INT = 5
)
AS
	-- Deklarasi variabel
	DECLARE @res TABLE (
		IdMember INT, 
		IdArtikel INT,
		Durasi INT
	)

	DECLARE @resTotal TABLE (
		IdMember INT,
		TotalMenitBaca INT
	)

	-- Deklarasi cursor
	-- Cursor mengambil data log dari user yang membaca artikel, aksi dibatasi hanya buka dan tutup, 
	-- buka dan tutup artikel merupakan satu pasang. Untuk memastikan sepasang buka tutup yang benar
	-- maka dibutuhkan sort berdasarkan IdUser, IdArtikel, dan timestampnya.
	DECLARE logData CURSOR
	FOR 
	SELECT
		IdMember, IdArtikel, [Timestamp], Aksi
	FROM
		LogMemberArtikel
	ORDER BY
		IdMember, IdArtikel, [Timestamp]

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
			-- Jika aksinya tutup maka hitung jeda waktu antara buka dan tutup 
			SELECT @timeDiff = DATEDIFF(MINUTE, @timeBefore, @timestamp)

			-- Hasil perhitungan kemudian disimpan ke dalam tabel
			INSERT INTO 
				@res
			SELECT
				@memberId, @artikelId, @timeDiff
		END
		ELSE
		BEGIN
			-- Jika bukan tutup maka catat timestampnya pada variabel sementara
			SET @timeBefore = @timestamp
		END

		FETCH NEXT 
			FROM logData 
			INTO @memberId, @artikelId, @timestamp, @aksi
	END

	CLOSE logData
	DEALLOCATE logData

	-- Menjumlahkan waktu baca dari setiap artikel oleh setiap user
	INSERT INTO
		@resTotal
	SELECT 
		IdMember, SUM(Durasi)
	FROM
		@res
	GROUP BY
		IdMember

	-- Menampilkan nama dan menit baca user yang terurut berdasarkan lama menit baca terbesar
	-- Secara default, yang ditampilkan hanya 5 tertinggi saja jika input showNum tidak diisi
	SELECT TOP (@showNum)
		[User].IdUser, [User].NamaDepan, [User].NamaBelakang, temp.TotalMenitBaca
	FROM
		@resTotal AS temp
	INNER JOIN
		[User] ON [User].IdUser = temp.IdMember
	ORDER BY
		TotalMenitBaca DESC

-- Eksekusi SP lihatMemberTeraktif
-- EXEC lihatMemberTeraktif 1