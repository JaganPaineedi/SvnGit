SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

--Modified By Robert Caffrey - 10/10/2018 - Strip the Non Numeric Characters from the Phone Number field - Harbor Support #1785

ALTER FUNCTION [dbo].[ssf_SureScriptsFormatPhone] ( @inPhone VARCHAR(100) )
RETURNS VARCHAR(35)
AS 
    BEGIN
        DECLARE @NewPhone VARCHAR(100)
        SET @NewPhone = REPLACE(REPLACE(REPLACE(REPLACE(@inPhone, ' ', ''),
                                                '(', ''), ')', ''), '-', '')
		WHILE PATINDEX('%[A-Z .]%', @NewPhone) > 1
		begin
			SET @NewPhone = SUBSTRING(@NewPhone, 1, PATINDEX('%[A-Z .]%', @NewPhone) -1) + SUBSTRING(@NewPhone, PATINDEX('%[A-Z .]%', @NewPhone) + 1, 100)
		end

        IF LEN(@NewPhone) > 10
            AND SUBSTRING(@NewPhone, 1, 1) <> '1' 
            BEGIN 
                RETURN SUBSTRING(@NewPhone,1,10) + 'X' + SUBSTRING(@NewPhone,11, LEN(@NewPhone)-10) 
            END
        IF LEN(@NewPhone) = 11
            AND SUBSTRING(@NewPhone, 1, 1) = '1' 
            BEGIN
                RETURN SUBSTRING(@NewPhone,2,10)
            END                
        IF LEN(@NewPhone) > 10
            AND SUBSTRING(@NewPhone, 1, 1) = '1' 
            BEGIN
                RETURN SUBSTRING(@NewPhone,2,10) + 'X' + SUBSTRING(@NewPhone,12, LEN(@NewPhone)-11)
            END      
        RETURN @NewPhone 

--return replace(replace(replace(replace(@inPhone, ' ', ''), '(', ''), ')', ''), '-', '')

    END



GO

