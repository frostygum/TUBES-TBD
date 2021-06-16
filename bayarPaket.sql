-- SP untuk pembayaran paket langganan
CREATE PROCEDURE bayarPaket
	@iduser int
AS

-- Declare tabel hasil
DECLARE @tblHasil TABLE
(
	StatusPembayaran int,
	TanggalPembelian date,
	TanggalBerakhir date
)

DECLARE
	@status int,
	@dateNow date,
	@dateEnd date

BEGIN
	-- Ambil tanggal saat ini untuk tanggal pembelian, dan tanggal + 1 bulan untuk tanggal berakhir
	SELECT @dateNow = CONVERT(VARCHAR(10), getdate(), 111)
	SELECT @dateEnd = DATEADD(MONTH, 1, @dateNow)
	
END