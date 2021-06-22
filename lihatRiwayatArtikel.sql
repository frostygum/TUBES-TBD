-- CREATE FUNCTION statusTerimaToString
ALTER FUNCTION statusTerimaToString
(
	@status INT
)
RETURNS VARCHAR(10)
BEGIN
	DECLARE @statusString VARCHAR(10) = ''

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
	DECLARE @statusString VARCHAR(10) = ''

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
    DECLARE @artikelKategori TABLE 
    (
        IdArtikel INT, 
        Kategori TEXT
    )

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
            SET @kategori = @kategori + @namaKategori + ';'
        END
        ELSE
        BEGIN
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