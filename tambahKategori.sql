ALTER procedure tambahKategori
	@Nama VARCHAR(50)
AS 
--membuat tabel untuk menyimpan hasil insert untuk dilihat datanya
	declare @tblHasil TABLE
	(
	Nama VARCHAR(50)
	)

	--memasukan nama kategori baru dari parameter ke tabel Kategori
	INSERT INTO Kategori(NamaKategori)
	SELECT @Nama

	--memasukan nama pada tabel tblHasil
	INSERT INTO @tblHasil
	SELECT @Nama

	SELECT* FROM @tblHasil

--EXEC tambahKategori Fauna
-- SELECT * FROM Kategori