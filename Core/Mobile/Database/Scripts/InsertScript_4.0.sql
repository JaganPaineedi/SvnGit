IF NOT EXISTS
(
    SELECT 1
    FROM screens
    WHERE Code = 'D350E65F-8FC5-4B6D-A176-BD6C645CF912'
)
    BEGIN
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
         '/api/Briefcase/Configs',
         5767,
         '/api/Briefcase/Configs',
         NULL,
         7,
		 'D350E65F-8FC5-4B6D-A176-BD6C645CF912'
        );
    END;