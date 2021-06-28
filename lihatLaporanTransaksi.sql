-- SP untuk lihat laporan transaksi
ALTER PROCEDURE laporanTransaksi
AS

-- Deklarasi cursor untuk tabel transaksi
DECLARE transData CURSOR
FOR
	SELECT
		NamaDepan, NamaBelakang, IdTransaksi, IdPaket, IdMember, StatusPembayaran, TanggalBerakhir, TanggalPembelian
	FROM
		TransaksiLangganan INNER JOIN [User]
		ON TransaksiLangganan.IdMember = [User].IdUser

OPEN transData

-- Deklarasi tabel hasil
DECLARE @tblHasil TABLE
(
	NamaDepan varchar(50),
	NamaBelakang varchar(50),
	IdTransaksi int,
	IdPaket int,
	IdMember int,
	StatusPembayaran int,
	TanggalBerakhir date,
	TanggalPembelian date
)

-- Deklarasi variabel-variabel
DECLARE
	@namaDepan varchar(50),
	@namaBelakang varchar(50),
	@idTransaksi int,
	@idPaket int,
	@idMember int,
	@statusBayar int,
	@tanggalAkhir date,
	@tanggalBeli date

FETCH NEXT FROM transData
INTO
	@namaDepan,
	@namaBelakang,
	@idTransaksi,
	@idPaket,
	@idMember,
	@statusBayar,
	@tanggalAkhir,
	@tanggalBeli

WHILE @@FETCH_STATUS = 0
BEGIN
	-- Data dimasukkan ke tabel hasil
	INSERT INTO @tblHasil
	SELECT @namaDepan, @namaBelakang, @idTransaksi, @idPaket, @idMember, @statusBayar, @tanggalAkhir, @tanggalBeli

	FETCH NEXT FROM transData
	INTO
		@namaDepan,
		@namaBelakang,
		@idTransaksi,
		@idPaket,
		@idMember,
		@statusBayar,
		@tanggalAkhir,
		@tanggalBeli
END

CLOSE transData
DEALLOCATE transData

SELECT
	*
FROM
	@tblHasil

-- EXEC laporanTransaksi