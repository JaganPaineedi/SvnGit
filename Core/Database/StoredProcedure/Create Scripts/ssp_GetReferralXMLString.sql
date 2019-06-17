/****** Object:  StoredProcedure [dbo].[ssp_GetReferralXMLString]    Script Date: 09/22/2017 18:14:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetReferralXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetReferralXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetReferralXMLString]    Script Date: 09/22/2017 18:14:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

   
CREATE PROCEDURE [dbo].[ssp_GetReferralXMLString] @ClientId INT = NULL    
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
 DECLARE @DefaultComponentXML VARCHAR(MAX) =   
  '<component>      
	   <section nullFlavor="NI">  
		<!-- Reason for Referral Section (V2) -->  
		<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1" extension="2014-06-09"/>  
		<templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1"/>  
		<code code="42349-1" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="Reason for Referral"/>  
		<title>REASON FOR REFERRAL</title>  
		<text>No Reason for Referral data</text>  
	   </section>  
  </component>'  
 DECLARE @FinalComponentXML VARCHAR(MAX)  
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<component>  
	  <section>  
		 <templateId root="1.3.6.1.4.1.19376.1.5.3.1.3.1"/>  
		 <!-- ** Reason for Referral Section Template ** -->  
		 <code codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" code="42349-1" displayName="REASON FOR REFERRAL"/>  
		 <title>REASON FOR REFERRAL</title>  
		 ###REFERRALTEXT###       
	  </section>  
  </component>'  
   
 DECLARE @entryXML VARCHAR(MAX) =   
    '<text>  
		<paragraph>##ReferralReason##</paragraph>  
    </text>'  
  
 DECLARE @finalEntry VARCHAR(MAX)  
 SET @finalEntry = ''  
  
 DECLARE @loopCOUNT INT = 0  
 DECLARE @tResults TABLE (  
  [ClientId] INT  
  ,[ReferralReason] VARCHAR(250)  
  )  
   
 INSERT INTO @tResults  
  SELECT ce.ClientId, GC.CodeName AS ReferralReason FROM ClientEpisodes ce  
  LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = ce.ReferralReason1)     
  WHERE ce.ClientId = @ClientId        
  AND ISNULL(ce.RecordDeleted,'N')='N'      
  
 DECLARE @tReferralReason VARCHAR(MAX) = ''  
   
 IF EXISTS (  
   SELECT *  
   FROM @tResults  
   )  
 BEGIN  
  DECLARE tCursor CURSOR FAST_FORWARD  
  FOR  
  SELECT [ReferralReason]  
  FROM @tResults TDS  
  
  OPEN tCursor  
  
  FETCH NEXT  
  FROM tCursor  
  INTO @tReferralReason  
  
  WHILE (@@FETCH_STATUS = 0)  
  BEGIN  
   SET @finalEntry = @finalEntry + @entryXML  
   SET @finalEntry = REPLACE(@finalEntry, '##ReferralReason##', ISNULL(@tReferralReason, 'UNK'))  
   SET @loopCOUNT = @loopCOUNT + 1  
  
   PRINT @finalEntry  
  
   FETCH NEXT  
   FROM tCursor  
   INTO @tReferralReason  
  END  
  
  CLOSE tCursor  
  
  DEALLOCATE tCursor  
  
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###REFERRALTEXT###', @finalEntry)  
  SET @OutputComponentXML = @FinalComponentXML  
 END  
   ELSE                
	 BEGIN                
	  SET @OutputComponentXML = @DefaultComponentXML                
	 END 
END  
  
GO


