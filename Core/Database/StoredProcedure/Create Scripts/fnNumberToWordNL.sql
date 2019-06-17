
/****** Object:  UserDefinedFunction [dbo].[fnNumberToWordNL]    Script Date: 12/09/2015 16:47:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnNumberToWordNL]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnNumberToWordNL]
GO
/****** Object:  UserDefinedFunction [dbo].[fnNumberToWordNL]    Script Date: 12/09/2015 16:47:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE FUNCTION [dbo].[fnNumberToWordNL](@Number1 AS decimal(18,2), @nl int)  
    RETURNS VARCHAR(1024)  
/********************************************************************************/                           
 -- Function: fnNumberToWords        
-- Purpose: Query to return data for the Charges and Claims list page.         
--         
-- Author: Revathi       
-- Date:    25 Nov 2015         
--           
 /********************************************************************************/    
AS  
BEGIN  
      DECLARE @Number as BIGINT  
      SET @Number = FLOOR(@Number1)  
      DECLARE @Below20 TABLE (ID int identity(0,1), Word varchar(32))  
      DECLARE @Below100 TABLE (ID int identity(2,1), Word varchar(32))  
   
      INSERT @Below20 (Word) VALUES  
                        ( 'Zero'), ('One'),( 'Two' ), ( 'Three'),  
                        ( 'Four' ), ( 'Five' ), ( 'Six' ), ( 'Seven' ),  
                        ( 'Eight'), ( 'Nine'), ( 'Ten'), ( 'Eleven' ),  
                        ( 'Twelve' ), ( 'Thirteen' ), ( 'Fourteen'),  
                        ( 'Fifteen' ), ('Sixteen' ), ( 'Seventeen'),  
                        ('Eighteen' ), ( 'Nineteen' )  
       INSERT @Below100 VALUES ('Twenty'), ('Thirty'),('Forty'), ('Fifty'),  
                               ('Sixty'), ('Seventy'), ('Eighty'), ('Ninety')  
   
DECLARE @English varchar(1024) =  
(  
  SELECT Case  
    WHEN @Number = 0 THEN  ''  
    WHEN @Number BETWEEN 1 AND 19  
      THEN (SELECT Word FROM @Below20 WHERE ID=@Number)  
   WHEN @Number BETWEEN 20 AND 99  
-- SQL Server recursive function     
     THEN  (SELECT Word FROM @Below100 WHERE ID=@Number/10)+' ' + --'-' +  
           dbo.fnNumberToWordNL( @Number % 10, @nl)  
   WHEN @Number BETWEEN 100 AND 999    
     THEN  (dbo.fnNumberToWordNL( @Number / 100, @nl))+' Hundred '+  
         dbo.fnNumberToWordNL( @Number % 100, @nl)  
   WHEN @Number BETWEEN 1000 AND 999999    
     THEN  (dbo.fnNumberToWordNL( @Number / 1000, @nl))+' Thousand '+  
         dbo.fnNumberToWordNL( @Number % 1000, @nl)   
   WHEN @Number BETWEEN 1000000 AND 999999999    
     THEN  (dbo.fnNumberToWordNL( @Number / 1000000, @nl))+' Million '+  
         dbo.fnNumberToWordNL( @Number % 1000000, @nl)  
    WHEN @Number BETWEEN 1000000000 AND 999999999999   
     THEN  (dbo.fnNumberToWordNL( @Number / 1000000000, @nl))+' Billion '+  
         dbo.fnNumberToWordNL( @Number % 1000000000, @nl)   
    WHEN @Number BETWEEN 1000000000000 AND 999999999999999    
     THEN  (dbo.fnNumberToWordNL( @Number / 1000000000000, @nl))+' Trillion '+  
         dbo.fnNumberToWordNL( @Number % 1000000000000, @nl)  
     WHEN @Number BETWEEN 1000000000000000 AND 999999999999999999    
     THEN  (dbo.fnNumberToWordNL( @Number / 1000000000000000, @nl))+' Quadrillion '+  
         dbo.fnNumberToWordNL( @Number % 1000000000000000, @nl)  
    WHEN @Number BETWEEN 1000000000000000000 AND 999999999999999999999    
     THEN  (dbo.fnNumberToWordNL( @Number / 1000000000000000000, @nl))+' Quintillion '+  
         dbo.fnNumberToWordNL( @Number % 1000000000000000000, @nl)                         
   ELSE ' INVALID INPUT' END  
)  
SELECT @English = RTRIM(@English)  
--SELECT @English = RTRIM(LEFT(@English,len(@English)-1))  
--                 WHERE RIGHT(@English,1)='-'  
IF (@@NestLevel - @nl) = 1  
BEGIN  
declare @diff varchar(max)  
  
--select @diff=CAST( convert(int,100*(@Number1 - @Number)) as varchar)  
  
  
select  @diff=Right((@Number1 - @Number),2)   
       
     IF @diff <> '00'  
     BEGIN  
      SELECT @English = @English+' point '  
      if SUBSTRING(@diff, 1,1)='0'  
      begin        
       SELECT @English = @English+' Zero'  
      End   
      else  
      Begin  
      SELECT @English = @English+ dbo.fnNumberToWordNL(SUBSTRING(@diff, 1,1), 0)  
      end  
      if len(@diff) > 1  
       if SUBSTRING(@diff, 2,1)='0'  
      begin        
       SELECT @English = @English+' Zero'  
      End   
      else  
      begin  
       SELECT @English =@English+' ' +dbo.fnNumberToWordNL(SUBSTRING(@diff, 2,1), 0)  
  end  
      --convert(varchar,convert(int,100*(@Number1 - @Number)))   
      END  
END  
RETURN (@English)  
END  
GO


