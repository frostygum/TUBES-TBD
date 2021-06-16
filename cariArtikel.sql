--CREATE FUNCTION
ALTER FUNCTION pemotongTitikKoma
(
	@kalimat varchar(200)
)
RETURNS @tblHasil TABLE
(
	Kata varchar(100)
)
BEGIN
	INSERT @tblHasil
	 SELECT value  
		FROM STRING_SPLIT(@kalimat, ';')
	RETURN
END


-- CREATE PROCEDURE cariArtikel
ALTER PROCEDURE cariArtikel
	@parameter varchar(10),
	@filter varchar(200)
AS
	IF(@parameter = 'judul')
	BEGIN
		SELECT judul 
		FROM artikel 
		WHERE judul LIKE '%' + @filter +'%'
	END

	ELSE IF(@parameter='kategori')
	BEGIN

		SELECT DISTINCT Artikel.IdArtikel, Artikel.Judul
		FROM artikelKategori 
			JOIN kategori
				ON artikelKategori.idKategori = kategori.idKategori
			JOIN Artikel 
				ON Artikel.IdArtikel = ArtikelKategori.IdArtikel
		WHERE namaKategori IN (SELECT Kata FROM pemotongTitikKoma(@filter))
				
	END

	ELSE IF(@parameter='penulis')
	BEGIN
		SELECT artikel.idArtikel, Judul
		FROM Artikel join [User]
			ON Artikel.IdPenulis = [User].IdUser
		WHERE NamaDepan LIKE '%' + @filter +'%'  OR
			  NamaBelakang LIKE '%' + @filter +'%' 	
	END

-- Eksekusi SP cariArtikel
-- EXEC cariArtikel judul,Google
-- EXEC cariArtikel penulis,teresa
-- EXEC cariArtikel kategori, 'teknologi;makanan'
