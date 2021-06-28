-- CREATE PROCEDURE tambahUser
ALTER PROCEDURE tambahUser
	@NamaDepan VARCHAR(50),
	@NamaBelakang VARCHAR(50),
    @Username VARCHAR(100),
    @Email VARCHAR(100),
    @Password VARCHAR(150),
	@Tipe VARCHAR(10)
AS
	-- Memasukkan data ke tabel user
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
		@NamaDepan,
		@NamaBelakang,
		@Username,
		@Email,
		@Password,
		@Tipe
	)

	-- Mendapatkan Id dari AutoIncrement Terakhir menggunakan @IDENTITY
	DECLARE
		@lastInsertedId INT = NULL

	SELECT 
		@lastInsertedId = IdUser
	FROM [User] 
		WHERE IdUser = @@Identity;
	
	-- Jika tipenya Member maka tambahkan juga ke tabel member
	IF (@Tipe = 'member')
	BEGIN
		INSERT INTO Member
		(
			idUser
		)
		VALUES
		( @lastInsertedId )
	END

-- SELECT * FROM [User]
-- SELECT * FROM Member
-- EXEC tambahUser Juan,Anthonius,wonderCookies,'wonde@cooki.es',KSosnsS52srNGqs5BPyX35dmrxJFJ3GJEBUranrrCcr3u7V6KNAd2h5K6nvd9QKZca4LHfUJ2QaYrcN4gnvvtWaf03j,member
-- EXEC tambahUser Darisu,Hiroshimas,fortuneHands,'fortune@japanhands.co.jp',aoLSnsS52srNGqs5BPyX35dmrxJFJ3GJEBUranrrCcr3u7V6KNAd2h5K6nvd9QKZca4LHfUJ2QaYrcN4gnvvtWaf93N,admin