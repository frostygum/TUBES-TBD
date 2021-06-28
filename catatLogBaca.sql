ALTER PROCEDURE catatLogBaca
	@idArtikel int,
	@idMember int,
	@aksi varchar(5)
AS
	INSERT INTO LogMemberArtikel --memasukkan ke tabel LogMemberArtikel
		(IdMember,
		 IdArtikel,
		 Timestamp, 
		 aksi)
	VALUES
		( @idMember,
		  @idArtikel,
		 CURRENT_TIMESTAMP, --mengambil tanggal dan waktu saat dijalankan
		 @aksi);

-- EXEC catatLogBaca 1,1,'buka'
