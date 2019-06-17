IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = '70DF1E68-CC2F-4402-8C42-74717484B3E4'
)
    BEGIN
        SET IDENTITY_INSERT screens ON;
        INSERT INTO screens
        (
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid,
		 Code
        )
        VALUES
        (
         '/api/documents',
         5767,
         '/api/documents',
         NULL,
         7,
		 '70DF1E68-CC2F-4402-8C42-74717484B3E4'
        );
        SET IDENTITY_INSERT screens OFF;
    END;