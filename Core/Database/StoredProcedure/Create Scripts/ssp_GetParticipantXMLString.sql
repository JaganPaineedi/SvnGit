/****** Object:  StoredProcedure [dbo].[ssp_GetParticipantXMLString]    Script Date: 09/22/2017 18:08:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetParticipantXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetParticipantXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetParticipantXMLString]    Script Date: 09/22/2017 18:08:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetParticipantXMLString] @ClientId INT = NULL      
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
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<participant typeCode="IND">
		  <associatedEntity classCode="PRS">
			 <code code="##PersonalRelationCode##" displayName="##PersonalRelation##" codeSystem="2.16.840.1.113883.1.11.19563" codeSystemName="Personal Relationship Role Type Value Set"/>
			 <addr use="HP">
				<!-- HP is "primary home" from codeSystem 2.16.840.1.113883.5.1119 -->
				<streetAddressLine>##Address##</streetAddressLine>
				<city>##City##</city>
				<state>##State##</state>
				<postalCode>##Zip##</postalCode>
				<country>US</country>
				<!-- US is "United States" from ISO 3166-1 Country Codes: 1.0.3166.1 -->
			 </addr>
			 <telecom value="tel:##Phone##" use="WP"/>
			 <associatedPerson>
				<name>
				   <prefix>##Prefix##</prefix>
				   <given>##FirstName##</given>
				   <family>##LastName##</family>
				</name>
			 </associatedPerson>
		  </associatedEntity>
	   </participant>'     
 DECLARE @loopCOUNT INT = 0    
 DECLARE @tResults TABLE (    
  [ClientId] INT    
  ,[Prefix] varchar(10)     
  ,[FirstName] varchar(30)     
  ,[LastName] varchar(50)    
  ,[Address]varchar(150)    
  ,[City] varchar(50)    
  ,[State] varchar(2)    
  ,[Zip] varchar(25)    
  ,[Phone] varchar(80)    
  ,[PersonalRelation] varchar(250)    
  ,[PersonalRelationCode] varchar(250)      
  )    
    
       
 INSERT INTO @tResults    
  EXEC ssp_GetParticipant @ClientId    
   ,@Type     
   ,@DocumentVersionId     
   ,@FromDate     
   ,@ToDate   
    
 DECLARE @tPrefix varchar(10) = ''    
 DECLARE @tFirstName varchar(30) = ''    
 DECLARE @tLastName varchar(50) = ''     
 DECLARE @tAgencyName varchar(250) = ''    
 DECLARE @tAddress varchar(150) = ''    
 DECLARE @tCity varchar(50) = ''    
 DECLARE @tState varchar(2) = ''    
 DECLARE @tZip varchar(25) = ''    
 DECLARE @tPhone varchar(80) = ''    
 DECLARE @tPersonalRelation varchar(250) = ''    
 DECLARE @tPersonalRelationCode varchar(250) = ''    
    
 IF EXISTS (    
   SELECT *    
   FROM @tResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT [Prefix]    
   ,[FirstName]    
   ,[LastName]    
   ,[Address]    
   ,[City]     
   ,[State]     
   ,[Zip]    
   ,[Phone]    
   ,[PersonalRelation]    
   ,[PersonalRelationCode]    
  FROM @tResults    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @tPrefix     
   ,@tFirstName    
   ,@tLastName    
   ,@tAddress    
   ,@tCity    
   ,@tState    
   ,@tZip    
   ,@tPhone    
   ,@tPersonalRelation    
   ,@tPersonalRelationCode    
    
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
        
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Prefix##', ISNULL(@tPrefix, 'UNK'))     
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##FirstName##', ISNULL(@tFirstName, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##LastName##', ISNULL(@tLastName, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Address##', ISNULL(@tAddress, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##City##', ISNULL(@tCity, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##State##', ISNULL(@tState, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Zip##', ISNULL(@tZip, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##Phone##', ISNULL(@tPhone, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##PersonalRelation##', ISNULL(@tPersonalRelation, 'UNK'))    
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##PersonalRelationCode##', ISNULL(@tPersonalRelationCode, 'UNK'))    
      
   SET @loopCOUNT = @loopCOUNT + 1    
    
   PRINT @PLACEHOLDERXML    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @tPrefix    
    ,@tFirstName    
    ,@tLastName    
    ,@tAddress    
    ,@tCity    
    ,@tState    
    ,@tZip    
    ,@tPhone    
    ,@tPersonalRelation    
    ,@tPersonalRelationCode    
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


