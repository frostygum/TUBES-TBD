ALTER PROCEDURE tulisArtikel
	@IdPenulis int,
	@Judul varchar(100),
	@StatusBerbayar bit,
	@IsiArtikel text
AS
	INSERT INTO Artikel
	(
	IdPenulis,
	Judul,
	TanggalTerbit,
	StatusBerbayar,
	IsiArtikel
	)
VALUES
	(
	@IdPenulis,
	@Judul,
	CURRENT_TIMESTAMP,
	@StatusBerbayar,
	@IsiArtikel
	)

--EXEC tulisArtikel 3, 'Judul dari Artikel', 0, 'Artikel keren sekali isinya'
