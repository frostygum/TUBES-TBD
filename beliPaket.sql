-- SP untuk pembelian paket langganan
-- CREATE PROCEDURE beliPaket
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

-- Declare variabel
DECLARE
	@dateNow DATE,
	@dateEnd DATE

BEGIN
	-- Insert data disimulasikan ke tabel hasil
	INSERT INTO @tblHasil
	SELECT @idPaket, @idUser, 0
END

SELECT * FROM @tblHasil

-- Eksekusi SP beliPaket
-- EXEC beliPaket 1,1