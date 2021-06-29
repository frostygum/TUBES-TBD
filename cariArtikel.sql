--CREATE FUNCTION
CREATE FUNCTION pemotongTitikKoma
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
	@parameter varchar(10), --variable untuk menentukan tipe pencarian
	@filter varchar(200) -- variable yang dicari
AS
	IF(@parameter = 'judul') --kueri yang dilakukan untuk mencari berdasarkan judul
	BEGIN
		SELECT judul 
		FROM artikel 
		WHERE judul LIKE '%' + @filter +'%'
	END

	ELSE IF(@parameter='kategori') -- kueri yang dilakukan untuk mencari berdasarkan kategori
	BEGIN

		SELECT DISTINCT Artikel.IdArtikel, Artikel.Judul
		FROM artikelKategori 
			JOIN kategori
				ON artikelKategori.idKategori = kategori.idKategori
			JOIN Artikel 
				ON Artikel.IdArtikel = ArtikelKategori.IdArtikel
		WHERE namaKategori IN 
			(SELECT Kata 
			 FROM pemotongTitikKoma(@filter)) -- mencari dari hasil function
				
	END

	ELSE IF(@parameter='penulis') -- kueri yang dilakukan untuk mencari berdasarkan nama penulis
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
