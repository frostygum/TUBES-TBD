ALTER PROCEDURE lihatAnggota
AS
--declare cursor anggota untuk mengecek ke seluruh data user
	DECLARE anggotaCursor Cursor
	FOR 
	SELECT Member.IdUser, [User].NamaDepan, [User].NamaBelakang, [User].Username ,Member.StatusLangganan
	FROM Member join [User]
	on Member.IdUser = [User].IdUser

--declare tabel hasil
	DECLARE @Hasil table(
		NamaPaket VARCHAR(50),
		NamaDepan VARCHAR(50),
		NamaBelakang VARCHAR(50),
		Username VARCHAR(100),
		id int
	)

--declare variable	
	DECLARE 
	@idCur int,
	@depan varchar(50),
	@belakang varchar(50),
	@uname varchar(100),
	@status int,
	@free varchar(50) = 'free'

	OPEN anggotaCursor

--menjalankan cursor
	FETCH NEXT FROM anggotaCursor INTO @idCur, @depan, @belakang, @uname, @status
	WHILE @@FETCH_STATUS = 0
	begin
		--menegcek jika statusnya 1 atau memiliki paket langganan
		if @status = 1
		begin
			INSERT into @Hasil
			SELECT Top 1 (PaketLangganan.NamaPaket),@depan, @belakang, @uname, @idCur
			FROM TransaksiLangganan join PaketLangganan
			on TransaksiLangganan.IdPaket = PaketLangganan.IdPaket
			where TransaksiLangganan.idMember = @idCur
			order by TransaksiLangganan.TanggalBerakhir desc
		end
		-- jika member tidak berlangganan.
		else
		begin
			INSERT into @Hasil
			SELECT @free, @depan, @belakang, @uname, @idCur
		end
		FETCH NEXT FROM anggotaCursor INTO @idCur, @depan, @belakang, @uname, @status
	end

	CLOSE anggotaCursor
	DEALLOCATE anggotaCursor

	SELECT id, NamaDepan, NamaBelakang, Username, NamaPaket
	FROM @Hasil

--exec lihatAnggota