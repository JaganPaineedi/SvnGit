/****** Object:  StoredProcedure [dbo].[ssp_GetLegalAuthenticatorXMLString]    Script Date: 09/22/2017 18:07:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetLegalAuthenticatorXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetLegalAuthenticatorXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetLegalAuthenticatorXMLString]    Script Date: 09/22/2017 18:07:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[ssp_GetLegalAuthenticatorXMLString] @ClientId INT = NULL        
 ,@Type VARCHAR(10) = NULL        
 ,@DocumentVersionId INT = NULL        
 ,@FromDate DATETIME = NULL        
 ,@ToDate DATETIME = NULL       
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT      
 -- =============================================                                 
/*                      
 Author   Added Date   Reason   Task                      
 Vijay    05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation        
*/    
AS      
BEGIN      
 DECLARE @DefaultComponentXML VARCHAR(MAX) = ''      
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<legalAuthenticator>  
		<time value="##Date##"/>  
		<signatureCode code="S"/>  
		<assignedEntity>  
			<id extension="999999999" root="2.16.840.1.113883.4.6"/>  
			<addr>  
				<streetAddressLine>##Address## </streetAddressLine>  
				<city>##City##</city>  
				<state>##State##</state>  
				<postalCode>##ZipCode##</postalCode>  
				<country>US</country>  
			</addr>  
			<telecom use="WP" value="tel:##Phone##"/>  
			<assignedPerson>  
				<name>  
				   <given>##FirstName##</given>  
				   <family>##LastName##</family>  
				</name>  
			</assignedPerson>  
		</assignedEntity>  
    </legalAuthenticator>'       
 DECLARE @loopCOUNT INT = 0      
 DECLARE @tResults TABLE (      
  [ClientId] INT      
  ,[FirstName] varchar(20)       
  ,[LastName] varchar(30)      
  ,[AgencyName] varchar(250)      
  ,[Address]varchar(100)      
  ,[City] varchar(30)      
  ,[State] varchar(2)      
  ,[ZipCode] varchar(12)      
  ,[Phone] varchar(50)      
  ,[Date] DATETIME         
  )      
            
 INSERT INTO @tResults      
  EXEC ssp_GetAuthor @ClientId      
   ,@Type       
   ,@DocumentVersionId       
   ,@FromDate       
   ,@ToDate
          
      
 DECLARE @tFirstName varchar(20) = ''      
 DECLARE @tLastName varchar(30) = ''       
 DECLARE @tAgencyName varchar(250) = ''      
 DECLARE @tAddress varchar(100) = ''      
 DECLARE @tCity varchar(30) = ''      
 DECLARE @tState varchar(2) = ''      
 DECLARE @tZipCode varchar(12) = ''      
 DECLARE @tPhone varchar(50) = ''      
 DECLARE @tDate varchar(100) = ''      
      
 IF EXISTS (      
   SELECT *      
   FROM @tResults      
   )      
 BEGIN        DECLARE tCursor CURSOR FAST_FORWARD      
  FOR      
  SELECT [FirstName]      
   ,[LastName]      
   ,[AgencyName]      
   ,[Address]      
   ,[City]       
   ,[State]       
   ,[ZipCode]      
   ,[Phone]      
   ,[Date]      
  FROM @tResults      
      
  OPEN tCursor      
      
  FETCH NEXT      
  FROM tCursor      
  INTO @tFirstName      
   ,@tLastName      
   ,@tAgencyName      
   ,@tAddress      
   ,@tCity      
   ,@tState      
   ,@tZipCode      
   ,@tPhone      
   ,@tDate      
         
  WHILE (@@FETCH_STATUS = 0)      
  BEGIN      
            
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##FirstName##', ISNULL(@tFirstName, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##LastName##', ISNULL(@tLastName, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Address##', ISNULL(@tAddress, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##City##', ISNULL(@tCity, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##State##', ISNULL(@tState, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##ZipCode##', ISNULL(@tZipCode, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Phone##', ISNULL(@tPhone, 'UNK'))      
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Date##', convert(VARCHAR(max), convert(DATETIME, @tDate), 112))      
         
   SET @loopCOUNT = @loopCOUNT + 1      
      
   PRINT @PLACEHOLDERXML      
      
   FETCH NEXT      
   FROM tCursor      
   INTO @tFirstName      
    ,@tLastName      
    ,@tAgencyName      
    ,@tAddress      
    ,@tCity      
    ,@tState      
    ,@tZipCode      
    ,@tPhone      
    ,@tDate      
  END      
      
  CLOSE tCursor      
      
  DEALLOCATE tCursor      
      
  SET @OutputComponentXML = @PLACEHOLDERXML      
 END      
 ELSE      
 BEGIN      
  SET @OutputComponentXML = @DefaultComponentXML      
 END      
       
END 
GO


