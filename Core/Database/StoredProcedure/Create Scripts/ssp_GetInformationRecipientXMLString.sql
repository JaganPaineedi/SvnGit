/****** Object:  StoredProcedure [dbo].[ssp_GetInformationRecipientXMLString]    Script Date: 09/24/2017 13:33:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInformationRecipientXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInformationRecipientXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetInformationRecipientXMLString]    Script Date: 09/24/2017 13:33:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetInformationRecipientXMLString] @ClientId INT = NULL    
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
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<informationRecipient>
		<intendedRecipient>
			<informationRecipient>
				<name>
					<given>##FirstName##</given>
					<family>##LastName##</family>
				</name>
			</informationRecipient>
			<receivedOrganization>
				<name>##AgencyName##</name>
			</receivedOrganization>
		</intendedRecipient>
	</informationRecipient>'   
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
  
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [FirstName]  
   ,[LastName]  
   ,[AgencyName]  
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tFirstName  
	   ,@tLastName  
	   ,@tAgencyName  
     
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
     
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##FirstName##', ISNULL(@tFirstName, 'UNK'))  
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##LastName##', ISNULL(@tLastName, 'UNK'))  
   SET @PLACEHOLDERXML = REPLACE(@PLACEHOLDERXML, '##AgencyName##', ISNULL(@tAgencyName, 'UNK'))  
     
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @PLACEHOLDERXML  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tFirstName  
		,@tLastName  
		,@tAgencyName  
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


