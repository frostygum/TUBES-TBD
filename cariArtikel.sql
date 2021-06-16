
-- CREATE PROCEDURE cariArtikel
ALTER PROCEDURE cariArtikel
	@parameter varchar(10),
	@filter nvarchar(32)
AS
	IF(@parameter = 'judul')
	BEGIN
		SELECT judul 
		FROM artikel 
		WHERE judul LIKE '%' + @filter +'%'
	END

	ELSE IF(@parameter='kategori')
	BEGIN
		SELECT Artikel.IdArtikel , Judul
		FROM artikelKategori 
			JOIN kategori
				ON artikelKategori.idKategori = kategori.idKategori
			JOIN Artikel 
				ON Artikel.IdArtikel = ArtikelKategori.IdArtikel
		WHERE NamaKategori LIKE '%' + @filter +'%' 
	END

	ELSE IF(@parameter='penulis')
	BEGIN
		SELECT * 
		FROM Artikel join [User]
			ON Artikel.IdPenulis = [User].IdUser
		WHERE NamaDepan LIKE '%' + @filter +'%'  OR
			  NamaBelakang LIKE '%' + @filter +'%' 	
	END

-- Eksekusi SP cariArtikel
-- EXEC cariArtikel judul,Google