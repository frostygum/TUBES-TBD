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

DECLARE
	@tipe varchar(50)

--mengambil tipe dari user
SELECT @tipe = Tipe
FROM [User]
WHERE IdUser = @iduser 

IF @tipe = 'admin'
BEGIN
	PRINT 'User ID: ' + CAST(@idUser AS VARCHAR) + ' Bukan member.'
END
ELSE
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