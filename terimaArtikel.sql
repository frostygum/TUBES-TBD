ALTER PROCEDURE terimaArtikel
	@idArtikel int,
	@idAdmin int
AS
	UPDATE Artikel
	SET
		IdPenerima = @idAdmin, --mengubah nilai idPenerima dan statusTerima
		StatusTerima = 1
	WHERE 
		IdArtikel = @idArtikel;


-- EXEC terimaArtikel 4,3