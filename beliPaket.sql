-- SP untuk pembelian paket langganan
ALTER PROCEDURE beliPaket
	@idUser int,
	@idPaket int
AS

-- Declare tabel hasil
DECLARE @tblHasil TABLE
(
	IdPaket INT,
	IdMember INT,
	StatusPembayaran BIT
)

BEGIN
	-- Insert data ke tabel transaksi langganan sebagai transaksi baru
	INSERT INTO TransaksiLangganan(IdPaket, IdMember, StatusPembayaran)
	SELECT @idPaket, @idUser, 0
	
	-- Insert data ke tabel hasil untuk preview
	INSERT INTO @tblHasil
	SELECT @idPaket, @idUser, 0
END

SELECT * FROM @tblHasil

-- EXEC beliPaket 3,2