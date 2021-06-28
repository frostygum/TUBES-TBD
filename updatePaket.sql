-- SP untuk update paket langganan
ALTER PROCEDURE updatePaket
	@idPaket int,
	@harga varchar(50)
AS

-- Deklarasi tabel hasil untuk preview
DECLARE @tblHasil TABLE
(
	IdPaket int,
	Harga varchar(50)
)

BEGIN
	-- Update paket langganan sesuai ID
	UPDATE PaketLangganan
	SET Harga = @harga
	WHERE IdPaket = @idPaket

	-- Masukkan ke tabel hasil untuk preview
	INSERT INTO @tblHasil
	SELECT @idPaket,  @harga
END

SELECT * FROM @tblHasil

-- EXEC updatePaket 2, '600000'