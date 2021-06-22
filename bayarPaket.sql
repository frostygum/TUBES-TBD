-- SP untuk pembayaran paket langganan
ALTER PROCEDURE bayarPaket
	@iduser int
AS

-- Declare cursor untuk tabel transaksi
DECLARE transData CURSOR
FOR
	SELECT
		IdPaket
	FROM
		TransaksiLangganan
	WHERE
		IdMember = @iduser AND StatusPembayaran = 0

OPEN transData

-- Declare tabel hasil
DECLARE @tblHasil TABLE
(
	IdPaket int,
	StatusPembayaran int,
	TanggalPembelian date,
	TanggalBerakhir date
)

-- Deklarasi variabel-variabel
DECLARE
	@idPaket int,
	@dateNow date,
	@dateEnd date,
	@jumlahHariAktif int

FETCH NEXT FROM transData
INTO
	@idPaket
	
-- Declare cursor untuk tabel paket
DECLARE paketData CURSOR
FOR
	SELECT
		JumlahHariAktif
	FROM
		PaketLangganan
	WHERE
		IdPaket = @idPaket

OPEN paketData

FETCH NEXT FROM paketData
INTO
	@jumlahHariAktif

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Ambil tanggal saat ini untuk tanggal pembelian, dan tanggal + x hari untuk tanggal berakhir sesuai paket yang dibeli
	SELECT @dateNow = CONVERT(VARCHAR(10), getdate(), 111)
	SELECT @dateEnd = DATEADD(DAY, @jumlahHariAktif, @dateNow)

	-- Update tabel pada kolom status pembayaran, tanggal berakhir, dan tanggal pembelian
	UPDATE TransaksiLangganan
	SET StatusPembayaran = 1, TanggalBerakhir = @dateEnd, TanggalPembelian = @dateNow
	WHERE IdMember = @iduser

	-- Update tabel Member untuk atur status langganan
	UPDATE Member
	SET StatusLangganan = 1
	WHERE IdUser = @iduser

	-- Isi tabel hasil
	INSERT INTO @tblHasil
	SELECT @idPaket, 1, @dateNow, @dateEnd 

	FETCH NEXT FROM transData
	INTO
		@idPaket

	FETCH NEXT FROM paketData
	INTO
		@jumlahHariAktif
END

CLOSE transData
DEALLOCATE transData

CLOSE paketData
DEALLOCATE paketData

SELECT * FROM @tblHasil

-- EXEC bayarPaket 3