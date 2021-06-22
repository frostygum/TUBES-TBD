ALTER PROCEDURE terimaArtikel
	@idArtikel int,
	@idAdmin int
AS
	UPDATE Artikel
	SET
		IdPenerima = @idAdmin,
		StatusTerima = 1
	WHERE 
		IdArtikel = @idArtikel;


-- EXEC terimaArtikel 4,3