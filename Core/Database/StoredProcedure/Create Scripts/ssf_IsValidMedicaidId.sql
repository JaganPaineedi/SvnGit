IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'ssf_IsValidMedicaidId')
	BEGIN
		DROP  Function  ssf_IsValidMedicaidId
	END

GO

/***********************************************
  Author:      Ed Sova
  Create date: 2/6/2004
  Description: return 1 if medicaid check digit is OK, 0 if not
  Changes:     11/1/2007 ED: modified to accomodate 10 digit medicaid ID
               12/21/2015 Dknewtson: Returning 0 for insuredIds with periods in them.
***********************************************/
CREATE FUNCTION [dbo].ssf_IsValidMedicaidId ( @med_id VARCHAR(16) )
RETURNS BIT
AS 
    BEGIN


        DECLARE @i INT ,
            @tot INT ,
            @chk INT ,
            @chk1 INT ,
            @chk2 INT ,
            @len INT ,
            @nresult BIT

        IF ISNUMERIC(@med_id) = 0 
            RETURN 0

        IF @med_id LIKE '%.%' 
           RETURN 0	

        SELECT  @len = LEN(@med_id)

        IF @len NOT IN ( 8, 10 ) 
            RETURN 0


        SELECT  @i = 1
        SELECT  @tot = 0

        WHILE @i < @len 
            BEGIN
                SELECT  @tot = @tot + CAST(SUBSTRING(@med_id, @i, 1) AS INT)
                        * ( @len - @i )
                SELECT  @i = @i + 1
            END

        SELECT  @chk = CAST(SUBSTRING(@med_id, @len, 1) AS INT) 
        SELECT  @chk1 = 11 - ( @tot % 11 )
        IF @chk1 = 11 
            SELECT  @chk1 = 0
        SELECT  @chk2 = ( @chk1 + 5 ) % 10

        IF ( @chk = @chk1
             OR @chk = @chk2
           )
            AND @chk1 != 10 
            SELECT  @nresult = 1
        ELSE 
            SELECT  @nresult = 0

        RETURN @nresult
    END
GO


