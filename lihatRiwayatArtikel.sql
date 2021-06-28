-- CREATE FUNCTION statusTerimaToString
ALTER FUNCTION statusTerimaToString
(
	@status INT
)
RETURNS VARCHAR(10)
BEGIN
    -- Deklarasi variabel
	DECLARE @statusString VARCHAR(10) = ''

    -- Cek boolean, jika 1 sudah diterima, 0 belum diterima
    IF @status = 1
    BEGIN
        SET @statusString = 'Sudah Diterima'
    END
    ELSE
    BEGIN
        SET @statusString = 'Belum Diterima'
    END
	RETURN @statusString
END

-- CREATE FUNCTION statusBayarToString
ALTER FUNCTION statusBerbayarToString
(
	@status INT
)
RETURNS VARCHAR(10)
BEGIN
    -- Deklarasi variabel
	DECLARE @statusString VARCHAR(10) = ''

    -- Cek boolean, jika 1 sudah diterima, 0 belum diterima
    IF @status = 1
    BEGIN
        SET @statusString = 'Berbayar'
    END
    ELSE
    BEGIN
        SET @statusString = 'Gratis'
    END
	RETURN @statusString
END

-- CREATE PROCEDURE lihatRiwayatArtikel
ALTER PROCEDURE lihatRiwayatArtikel
	@idPenulis int
AS  
    -- Deklarasi variabel untuk menampung list kategori yang sudah digabungkan
    DECLARE @artikelKategori TABLE 
    (
        IdArtikel INT, 
        Kategori TEXT
    )

    -- Deklarasi cursor
    -- Menyatukan artikel dengan masin-masing kategorinya
    DECLARE listKategori CURSOR
	FOR 
	SELECT 
        Artikel.IdArtikel, Kategori.NamaKategori
    FROM
        Artikel
    INNER JOIN 
        ArtikelKategori ON ArtikelKategori.IdArtikel = Artikel.IdArtikel
    LEFT OUTER JOIN
        Kategori ON ArtikelKategori.IdKategori = Kategori.IdKategori
    WHERE
        idPenulis = @idPenulis

	OPEN listKategori

    -- Deklarasi variabel cursor
	DECLARE
		@namaKategori VARCHAR(50), 
		@idArtikel INT,
        @currIdArtikel INT,
        @kategori VARCHAR(max) = ''

	FETCH NEXT 
		FROM listKategori
		INTO @currIdArtikel, @namaKategori
	WHILE @@FETCH_STATUS = 0
	BEGIN
        IF @currIdArtikel = @idArtikel
        BEGIN
            -- Jika id artikel merupakan id sebelumnya maka kategori yang sekarang digabungkan
            SET @kategori = @kategori + @namaKategori + ';'
        END
        ELSE
        BEGIN
            -- Jika id artikel baru maka buat baris baru dan masukkan yang menjadi kategori pertamanya
            SET @idArtikel = @currIdArtikel
            SET @kategori = ''

            INSERT INTO @artikelKategori
            (
                IdArtikel
            )
            VALUES
            (
                @idArtikel
            )
        END
        
        -- Update list kategori pada tabel sementara
        UPDATE
            @artikelKategori
        SET
            Kategori = @kategori
        WHERE
            IdArtikel = @idArtikel

		FETCH NEXT 
			FROM listKategori 
			INTO @currIdArtikel, @namaKategori
	END

	CLOSE listKategori
	DEALLOCATE listKategori

    -- Tampilkan hasil, dimana kategori sudah digabungkan dan status bayar, status terima sudah dibuat menjadi text
    SELECT 
        Artikel.IdArtikel, 
        Artikel.Judul, 
        Artikel.TanggalTerbit, 
        TK.Kategori, 
        dbo.statusBerbayarToString(Artikel.StatusBerbayar) AS 'Status Berbayar', 
        dbo.statusTerimaToString(Artikel.StatusTerima) AS 'Status Terima'
    FROM
        Artikel
    INNER JOIN 
        @artikelKategori AS TK ON TK.IdArtikel = Artikel.IdArtikel
    WHERE
        idPenulis = @idPenulis

-- Eksekusi SP lihatRiwayatArtikel
-- EXEC lihatRiwayatArtikel 1