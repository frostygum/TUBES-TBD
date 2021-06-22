ALTER PROCEDURE catatLogBaca
	@idArtikel int,
	@idMember int,
	@aksi varchar(5)
AS
	INSERT INTO LogMemberArtikel
		(IdMember,
		 IdArtikel,
		 Timestamp,
		 aksi)
	VALUES
		( @idMember,
		  @idArtikel,
		 CURRENT_TIMESTAMP,
		 @aksi);

-- EXEC catatLogBaca 1,1,'buka'
