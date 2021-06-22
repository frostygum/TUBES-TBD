
-- CREATE PROCEDURE nonAktifkanPaket
ALTER PROCEDURE nonAktifkanPaket
	@idMember int
AS
	DECLARE 
        @endDate DATE,
        @status INT

    SELECT 
        @status = StatusLangganan
    FROM
        Member
    WHERE
        IdUser = @idMember

    IF @status = 1
    BEGIN
        SELECT TOP 1 
            @endDate = TanggalBerakhir
        FROM 
            TransaksiLangganan
        WHERE
            idMember = @idMember AND StatusPembayaran = 1
        ORDER BY 
            TanggalBerakhir DESC

        IF @endDate <= GETDATE()
        BEGIN
            UPDATE 
                Member
            SET 
                StatusLangganan = 0
            WHERE
                IdUser = @idMember

            PRINT CAST(@idMember AS VARCHAR)
        END
        ELSE
        BEGIN
            PRINT 'User ID: ' + CAST(@idMember AS VARCHAR) + ' Sedang dalam masa langganan.'
        END
    END
    ELSE
    BEGIN
        PRINT 'User ID: ' + CAST(@idMember AS VARCHAR) + ' Tidak sedang berlangganan.'
    END

-- Eksekusi SP nonAktifkanPaket
-- EXEC nonAktifkanPaket 1