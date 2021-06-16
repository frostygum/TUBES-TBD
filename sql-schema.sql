
/* ********************************************** SCHEMA ********************************************************* */

/*
	TABLE USER
*/

DROP TABLE LogMemberArtikel;
DROP TABLE ArtikelKategori;
DROP TABLE TransaksiLangganan;
DROP TABLE PaketLangganan;
DROP TABLE Kategori;
DROP TABLE Artikel;
DROP TABLE Member;
DROP TABLE [User];

CREATE TABLE [User]
(
	IdUser INT NOT NULL IDENTITY(1, 1),
	NamaDepan VARCHAR(50) NOT NULL,
	NamaBelakang VARCHAR(50),
	Username VARCHAR(100) NOT NULL,
	Email VARCHAR(100) NOT NULL,
	[Password] VARCHAR(150) NOT NULL,
	Tipe VARCHAR(10) NOT NULL,
	CONSTRAINT PK_User PRIMARY KEY (IdUser)
)

CREATE TABLE Member
(
	IdUser INT NOT NULL,
	StatusLangganan BIT DEFAULT 0 NOT NULL,
	CONSTRAINT PK_Member PRIMARY KEY (IdUser),
	CONSTRAINT FK_M_User FOREIGN KEY (IdUser) REFERENCES [User](IdUser),
)

/*
	TABLE KATEGORI
*/

CREATE TABLE Kategori 
(
	IdKategori INT NOT NULL IDENTITY(1, 1),
	NamaKategori VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Kategori PRIMARY KEY (IdKategori)
)

/*
	TABLE ARTIKEL
	**StatusBerbayar tipe BIT, 1 untuk artikel berbayar, 0 untuk gratisan
*/

CREATE TABLE Artikel 
(
	IdArtikel INT NOT NULL IDENTITY(1, 1),
	IdPenulis INT NOT NULL,
	IdPenerima INT DEFAULT NULL,
	Judul VARCHAR(100) NOT NULL,
	TanggalTerbit DATE NOT NULL,
	StatusBerbayar BIT DEFAULT 0 NOT NULL,
	IsiArtikel TEXT NOT NULL,
	StatusTerima BIT DEFAULT 0 NOT NULL,
	CONSTRAINT PK_Artikel PRIMARY KEY (IdArtikel),
	CONSTRAINT FK_A_Member FOREIGN KEY (IdPenulis) REFERENCES [User](IdUser),
	CONSTRAINT FK_A_Admin FOREIGN KEY (IdPenerima) REFERENCES [User](IdUser)
)

/*
	TABLE ARTIKELKATEGORI
*/

CREATE TABLE ArtikelKategori 
(
	Id INT NOT NULL IDENTITY(1, 1),
	IdArtikel INT NOT NULL,
	IdKategori INT NOT NULL,
	CONSTRAINT PK_ArtikelKategori PRIMARY KEY (Id),
	CONSTRAINT FK_Artikel FOREIGN KEY (IdArtikel) REFERENCES Artikel(IdArtikel),
	CONSTRAINT FK_Kategori FOREIGN KEY (IdKategori) REFERENCES Kategori(IdKategori)
)

/*
	TABLE PAKETLANGGANAN
*/

CREATE TABLE PaketLangganan 
(
	IdPaket INT NOT NULL IDENTITY(1, 1),
	NamaPaket VARCHAR(50) NOT NULL,
	Harga VARCHAR(50) NOT NULL,
	JumlahHariAktif INT NOT NULL,
	CONSTRAINT PK_PaketLangganan PRIMARY KEY (IdPaket),
)

/*
	TABLE TRANSAKSILANGGANAN
	**StatusPembayaran tipe BIT, 1 untuk sudah bayar, 0 untuk belum bayar
*/

CREATE TABLE TransaksiLangganan 
(
	IdTransaksi INT NOT NULL IDENTITY(1, 1),
	IdPaket INT NOT NULL,
	IdMember INT NOT NULL,
	StatusPembayaran BIT DEFAULT 0 NOT NULL,
	TanggalBerakhir DATE NOT NULL, 
	TanggalPembelian DATE NOT NULL,
	CONSTRAINT PK_TransaksiLangganan PRIMARY KEY (IdTransaksi),
	CONSTRAINT FK_TL_Paket FOREIGN KEY (IdPaket) REFERENCES PaketLangganan(IdPaket),
	CONSTRAINT FK_TL_Member FOREIGN KEY (IdMember) REFERENCES [User](IdUser)
) 

/*
	TABLE BACAARTIKEL
*/

CREATE TABLE LogMemberArtikel 
(
	Id INT NOT NULL IDENTITY(1, 1),
	IdMember INT NOT NULL,
	IdArtikel INT NOT NULL,
	[Timestamp] DATETIME NOT NULL,
	aksi VARCHAR(10) NOT NULL,
	CONSTRAINT PK_LogMemberArtikel PRIMARY KEY (Id),
	CONSTRAINT FK_LMA_Member FOREIGN KEY (IdMember) REFERENCES [User](IdUser),
	CONSTRAINT FK_LMA_Transaksi FOREIGN KEY (IdArtikel) REFERENCES Artikel(IdArtikel),
) 

/* ********************************************** INSERT  DATA ********************************************************* */

/*
	INSERT DATA TABLE USER
*/

INSERT INTO [User] 
(
	NamaDepan, 
	NamaBelakang,
	Username,
	Email,
	[Password],
	Tipe
)
VALUES 
(
	'Teresa',
	'Magira Limantara',
	'coconutz',
	'6181801049@student.unpar.ac.id',
	'HHce7LMHjc7GZyw88uX4wYR4AdUmDL6M8juLfWHTfnTHHqN5uuQQkp4NKxh6aGTSJA3b7kehPCwRFgQL5k6krGg2RS',
	'member'
),
(
	'Josie',
	'Esthelher',
	'joesth12',
	'6181801053@student.unpar.ac.id',
	'MhHSnj2XkTVD3PHHquJwJYGvNNUTTLRCV4WeAXwGXVWZw2Jxat4mWfCd9vhZFDnB75wJL3tBhmsrvrSafeun924T52',
	'member'
),
(
	'Splier',
	'Spoond',
	'gummyball',
	'gummy.ball@gmail.com',
	'f9KHJdPByuAqxMYwxnCwzaGQvVm4juMeCaEuuMb8r9Zgb2x5Dtny6tyexKWwdSrSNJWcPFpefp6LCqX7VdYB3ZU3B8',
	'admin'
),
(
	'Alexander',
	'Xavier',
	'almondfork',
	'almond.fork@gmail.com',
	'yrWtWFyXwugvWzZ6WghQtCdQBugfBCVeNvsbw9NdD54SVAFcnWQ3Bh4RkZ8qCYb6PBNHL25zUzazSncwqKnPz9h6vm',
	'member'
),
(
	'Gradio',
	'Martinez',
	'flowerducket',
	'flower@duck.et',
	'ZxGJKS52srNGqs5BPyX35dmrxJFJ3GJEBUranrrCcr3u7V6KNAd2h5K6nvd9QKZca4LHfUJ2QaYrcN4gnvvtWaf77q',
	'member'
)

INSERT INTO Member
(
	idUser
)
VALUES
( 1 ),
( 2 ),
( 4 ),
( 5 )

/*
	INSERT DATA TABLE KATEGORI
*/

INSERT INTO Kategori 
(
	NamaKategori
)
VALUES
('Teknologi'),
('Makanan'),
('Sejarah'),
('Elektronik'),
('Kultur'),
('Politik'),
('Olahraga'),
('Komputer'),
('Seni'),
('Budaya'),
('Musik'),
('Karikatur'),
('Binatang'),
('Pakaian'),
('Bisnis'),
('Permainan'),
('Kesehatan'),
('Berita'),
('Sosial'),
('Politik'),
('Buku'),
('Rumah')

/*
	INSERT DATA TABLE ARTIKEL
*/

INSERT INTO Artikel
(
	IdPenulis,
	Judul,
	TanggalTerbit,
	StatusBerbayar,
	IsiArtikel
)
VALUES
(
	1,
	'Cara Membuat Dodol atau Kue Keranjang',
	'2021-02-21',
	0,
	'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
),
(
	2,
	'Bank Jago sudah mengakusisi ayam untuk menjadi maskotnya',
	'2021-04-18',
	1,
	'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
),
(
	2,
	'Datacenter milik Google di Indonesia terbakar karena letusan rokok',
	'2021-06-12',
	1,
	'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
),
(
	1,
	'Piring plastik buatan Jawa Tengah mendadak viral karena terbuat dari batu',
	'2021-06-24',
	0,
	'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'
)

/*
	UPDATE DATA TABLE ARTIKEL
*/

UPDATE Artikel
SET 
	IdPenerima = 3,
	StatusTerima = 1
WHERE
	IdArtikel = 1

UPDATE Artikel
SET 
	IdPenerima = 3,
	StatusTerima = 1
WHERE
	IdArtikel = 2

UPDATE Artikel
SET 
	IdPenerima = 3,
	StatusTerima = 1
WHERE
	IdArtikel = 3

/*
	INSERT DATA TABLE ARTIKELKATEGORI
*/

INSERT INTO ArtikelKategori 
(
	IdArtikel,
	IdKategori
)
VALUES
( 1, 1 ),
( 1, 2 ),
( 1, 5 ),
( 1, 6 ),
( 1, 11 ),
( 2, 2 ),
( 2, 4 ),
( 2, 5 ),
( 2, 13 ),
( 2, 9 ),
( 3, 1 ),
( 3, 5 ),
( 3, 6 ),
( 3, 13 ),
( 3, 2 ),
( 4, 2 ),
( 4, 4 ),
( 4, 5 ),
( 4, 7 ),
( 4, 3 )

/*
	INSERT DATA TABLE PAKET LANGGANAN
*/

INSERT INTO PaketLangganan 
(
	NamaPaket,
	Harga,
	JumlahHariAktif
)
VALUES
(
	'Merdeka Sebulan',
	'50000',
	30
),
(
	'Setahun Hore',
	'500000',
	365
),
(
	'Pelajar Rajin Sebulan',
	'20000',
	30
)

/*
	INSERT DATA TABLE TRANSAKSILANGGANAN
*/

INSERT INTO TransaksiLangganan 
(
	IdPaket,
	IdMember,
	StatusPembayaran,
	TanggalPembelian,
	TanggalBerakhir
) 
VALUES
(
	1,
	1,
	1,
	'2021/04/12',
	'2021/05/12'
),
(
	1,
	1,
	1,
	'2021/03/12',
	'2021/04/12'
),
(
	1,
	1,
	1,
	'2021/05/12',
	'2021/06/12'
),
(
	2,
	4,
	1,
	'2021/05/12',
	'2022/05/12'
)

/*
	UPDATE DATA TABLE MEMBER HAS TRANSAKSI
*/

UPDATE Member 
SET
	StatusLangganan = 1
WHERE
	IdUser = 1

UPDATE Member 
SET
	StatusLangganan = 1
WHERE
	IdUser = 4

/*
	INSERT DATA TABLE LOGMEMBERARTIKEL
*/

INSERT INTO LogMemberArtikel 
(
	IdMember,
	IdArtikel,
	[Timestamp],
	aksi
) 
VALUES
(
	1,
	1,
	'2021/05/12 12:45:22',
	'buka'
),
(
	1,
	1,
	'2021/05/12 13:25:43',
	'tutup'
),
(
	1,
	1,
	'2021/08/24 09:12:22',
	'buka'
),
(
	1,
	1,
	'2021/08/24 10:25:32',
	'tutup'
),
(
	1,
	3,
	'2021/02/13 08:10:11',
	'buka'
),
(
	1,
	3,
	'2021/02/13 09:28:36',
	'tutup'
),
(
	1,
	1,
	'2021/02/14 14:15:23',
	'buka'
),
(
	1,
	1,
	'2021/02/14 14:32:12',
	'tutup'
),
(
	1,
	1,
	'2021/04/13 08:07:23',
	'buka'
),
(
	1,
	1,
	'2021/04/13 08:10:45',
	'tutup'
),
(
	4,
	2,
	'2021/02/04 12:34:12',
	'buka'
),
(
	4,
	2,
	'2021/02/04 13:05:35',
	'tutup'
),
(
	4,
	2,
	'2021/02/04 13:12:08',
	'buka'
),
(
	4,
	2,
	'2021/02/04 13:59:12',
	'tutup'
),
(
	4,
	1,
	'2021/03/04 12:34:12',
	'buka'
),
(
	4,
	1,
	'2021/03/04 13:12:02',
	'tutup'
),
(
	4,
	1,
	'2021/03/04 17:51:01',
	'buka'
),
(
	4,
	1,
	'2021/03/04 18:24:06',
	'tutup'
),
(
	4,
	3,
	'2021/03/12 13:32:00',
	'buka'
),
(
	4,
	2,
	'2021/02/04 06:12:32',
	'buka'
),
(
	4,
	3,
	'2021/03/12 14:12:22',
	'tutup'
),
(
	4,
	2,
	'2021/02/04 06:55:21',
	'tutup'
)

/* ********************************************** CHECK DATA ********************************************************* */

SELECT * FROM [User]

SELECT * FROM Kategori

SELECT * FROM ArtikelKategori

SELECT * FROM PaketLangganan

SELECT * FROM LogMemberArtikel

SELECT 
	* 
FROM 
	[User]
LEFT OUTER JOIN Member ON [User].IdUser = Member.IdUser

SELECT 
	Artikel.IdArtikel,
	[User].NamaDepan,
	Artikel.Judul,
	Artikel.TanggalTerbit,
	Artikel.IsiArtikel,
	artikel.StatusBerbayar,
	Kategori.NamaKategori,
	Artikel.StatusTerima
FROM 
	Artikel
INNER JOIN [User] ON Artikel.IdPenulis = [User].IdUser
INNER JOIN ArtikelKategori ON Artikel.IdArtikel = ArtikelKategori.IdArtikel
INNER JOIN Kategori ON ArtikelKategori.IdKategori = Kategori.IdKategori