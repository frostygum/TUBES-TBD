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
	@dateEnd date

FETCH NEXT FROM transData
INTO
	@idPaket

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Ambil tanggal saat ini untuk tanggal pembelian, dan tanggal + x hari untuk tanggal berakhir sesuai paket yang dibeli
	SELECT @dateNow = CONVERT(VARCHAR(10), getdate(), 111)
	IF @idPaket = 1 OR @idPaket = 3
	BEGIN
		SELECT @dateEnd = DATEADD(DAY, 30, @dateNow)
	END
	ELSE IF @idPaket = 2
	BEGIN
		SELECT @dateEnd = DATEADD(DAY, 365, @dateNow)
	END

	-- Update tabel pada kolom status pembayaran, tanggal berakhir, dan tanggal pembelian
	UPDATE TransaksiLangganan
	SET StatusPembayaran = 1, TanggalBerakhir = @dateEnd, TanggalPembelian = @dateNow
	WHERE IdMember = @iduser

	-- Isi tabel hasil
	INSERT INTO @tblHasil
	SELECT @idPaket, 1, @dateNow, @dateEnd 

	FETCH NEXT FROM transData
	INTO
		@idPaket
END

CLOSE transData
DEALLOCATE transData

SELECT * FROM @tblHasil

-- EXEC bayarPaket 5