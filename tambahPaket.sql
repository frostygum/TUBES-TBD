ALTER procedure tambahPaket
	@Nama VARCHAR(50),
	@Harga VARCHAR(50),
	@JumlahHariAktif INT
AS 
--membuat tabel untuk menyimpan hasil insert untuk dilihat datanya
	declare @tblHasil TABLE
	(
	Nama VARCHAR(50),
	Harga VARCHAR(50),
	JumlahHariAktif INT
	)

	--memasukan nama, harga, dan jumlah hari aktif pada tabel PaketLangganan
	INSERT INTO PaketLangganan(NamaPaket, Harga, JumlahHariAktif)
	SELECT @Nama, @Harga, @JumlahHariAktif

	--memasukan nama, harga, dan jumlah ahri aktif pada tabel tblHasil
	INSERT INTO @tblHasil
	SELECT @Nama, @Harga, @JumlahHariAktif

	SELECT* FROM @tblHasil

--EXEC TambahPaket HarianIrit, 1000, 1
--SELECT * FROM PaketLangganan