ALTER PROCEDURE lihatAnggota
AS
	DECLARE anggotaCursor Cursor
	FOR 
	SELECT Member.IdUser, [User].NamaDepan, [User].NamaBelakang, [User].Username ,Member.StatusLangganan
	FROM Member join [User]
	on Member.IdUser = [User].IdUser

	DECLARE @Hasil table(
		NamaPaket VARCHAR(50),
		NamaDepan VARCHAR(50),
		NamaBelakang VARCHAR(50),
		Username VARCHAR(100)		
	)
	
	DECLARE 
	@idCur int,
	@depan varchar(50),
	@belakang varchar(50),
	@uname varchar(100),
	@status int,
	@free varchar(50) = 'free'

	OPEN anggotaCursor

	FETCH NEXT FROM anggotaCursor INTO @idCur, @depan, @belakang, @uname, @status
	WHILE @@FETCH_STATUS = 0
	begin
		if @status = 1
		begin
			INSERT into @Hasil
			SELECT Top 1 (PaketLangganan.NamaPaket),@depan, @belakang, @uname
			FROM TransaksiLangganan join PaketLangganan
			on TransaksiLangganan.IdPaket = PaketLangganan.IdPaket
			where TransaksiLangganan.idMember = @idCur
			order by TransaksiLangganan.TanggalBerakhir desc
		end
		else
		begin
			INSERT into @Hasil
			SELECT @free, @depan, @belakang, @uname
		end
		FETCH NEXT FROM anggotaCursor INTO @idCur, @depan, @belakang, @uname, @status
	end

	CLOSE anggotaCursor
	DEALLOCATE anggotaCursor

	SELECT NamaDepan, NamaBelakang, Username, NamaPaket
	FROM @Hasil

--exec lihatAnggota