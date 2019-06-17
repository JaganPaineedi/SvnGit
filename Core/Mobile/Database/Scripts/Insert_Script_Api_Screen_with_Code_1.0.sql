IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'CF02CAA7-4F2D-41D9-8D18-900480DA0171' AND ISNULL(RecordDeleted,'N') = 'N'
)
    BEGIN
        INSERT INTO screens
        (Code,
         screenname,
         screentype,
         screenurl,
         screentoolbarurl,
         tabid
        )
        VALUES
        ('CF02CAA7-4F2D-41D9-8D18-900480DA0171',
         '/api/KPIReporting/Post',
         5767,
         '/api/KPIReporting/Post',
         NULL,
         7
        )
    END;