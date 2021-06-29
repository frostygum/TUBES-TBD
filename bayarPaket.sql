-- SP untuk pembayaran paket langganan
ALTER PROCEDURE bayarPaket
	@iduser int
AS

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
	@jumlahHariAktif int,
	@statusLangganan int

--melakukan non aktif paket agar yakin benar jika sudah habis masa aktif pada saat membayar
exec nonAktifkanPaket @idUser

--mengambil status langganan dari user
SELECT @statusLangganan = StatusLangganan
FROM Member
WHERE IdUser = @iduser 

--mengambil paket yang dibeli oleh user
SELECT @idPaket = IdPaket
FROM TransaksiLangganan
WHERE IdMember = @iduser AND StatusPembayaran = 0

--mengambil jumlah hari aktif yang akan ditambahkan
SELECT @jumlahHariAktif = JumlahHariAktif
FROM PaketLangganan
WHERE IdPaket = @idPaket

--Mengecek jika status langganan saat ini tidak ada
IF @statusLangganan = 0
BEGIN 
	-- Ambil tanggal saat ini untuk tanggal pembelian, dan tanggal + x hari untuk tanggal berakhir sesuai paket yang dibeli
	SELECT @dateNow = CONVERT(VARCHAR(10), getdate(), 111)
	SELECT @dateEnd = DATEADD(DAY, @jumlahHariAktif, @dateNow) 
END
ELSE
-- jika saat ini masih berlangganan
BEGIN
	-- Ambil tanggal saat ini untuk tanggal pembelian, dan tanggal + x hari untuk tanggal berakhir sesuai paket yang dibeli
	SELECT @dateNow = tgl.TanggalBerakhir
	FROM (
		SELECT TOP 1 TanggalBerakhir 
		FROM TransaksiLangganan 
		WHERE IdMember = @iduser
		ORDER BY TanggalBerakhir DESC) AS tgl

	SELECT @dateEnd = DATEADD(DAY, @jumlahHariAktif, @dateNow)
	
END

-- Update tabel pada kolom status pembayaran, tanggal berakhir, dan tanggal pembelian
UPDATE TransaksiLangganan
SET StatusPembayaran = 1, TanggalBerakhir = @dateEnd, TanggalPembelian = @dateNow
WHERE IdMember = @iduser and StatusPembayaran = 0

-- Update tabel Member untuk atur status langganan
UPDATE Member
SET StatusLangganan = 1
WHERE IdUser = @iduser

-- Isi tabel hasil
INSERT INTO @tblHasil
SELECT @idPaket, 1, @dateNow, @dateEnd 
	
SELECT * FROM @tblHasil

-- EXEC bayarPaket 4
-- SELECT * FROM TransaksiLangganan WHERE IdMember = 4
select * from member