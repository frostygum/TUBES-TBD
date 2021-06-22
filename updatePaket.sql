-- SP untuk update paket langganan
ALTER PROCEDURE updatePaket
	@idPaket int,
	@nama varchar(50),
	@harga varchar(50),
	@jumlahHariAktif int
AS

-- Deklarasi tabel hasil untuk preview
DECLARE @tblHasil TABLE
(
	IdPaket int,
	NamaPaket varchar(50),
	Harga varchar(50),
	JumlahHariAktif int
)

BEGIN
	-- Update paket langganan sesuai ID
	UPDATE PaketLangganan
	SET NamaPaket = @nama, Harga = @harga, JumlahHariAktif = @jumlahHariAktif
	WHERE IdPaket = @idPaket

	-- Masukkan ke tabel hasil untuk preview
	INSERT INTO @tblHasil
	SELECT @idPaket, @nama, @harga, @jumlahHariAktif
END

SELECT * FROM @tblHasil

-- EXEC updatePaket 2, 'Setahun Hore', '500000', 364