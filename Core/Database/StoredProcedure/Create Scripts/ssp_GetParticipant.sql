/****** Object:  StoredProcedure [dbo].[ssp_GetParticipant]    Script Date: 09/22/2017 18:09:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetParticipant]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetParticipant]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetParticipant]    Script Date: 09/22/2017 18:09:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetParticipant] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL
AS    
-- =============================================            
-- Author:  Vijay            
-- Create date: July 24, 2017            
-- Description: Retrieves Participant details
-- Task:   MUS3 - Task#25.4 Transition of Care - CCDA Generation           
/*            
 Author   Modified Date   Reason           
*/    
-- =============================================            
BEGIN    
 BEGIN TRY    
    
  	   SELECT DISTINCT c.ClientId    
	      ,cc.Prefix    
		  ,cc.FirstName    
		  ,cc.LastName       
		  ,ca.Address        
		  ,ca.City        
		  ,ca.State       
		  ,ca.Zip    
		  ,CASE WHEN ISNULL(cp.PhoneNumber,'') <> ''        
			THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')'       
		  + ' '       
		  + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 4, 3)        
          + '-'       
          + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(cp.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 7, 4)        
		  ELSE ''      
		  END AS Phone    
		  ,GC.CodeName AS PersonalRelation    
		  ,CASE GC.CodeName    
			WHEN 'family member' THEN 'FAMMEMB'    
			WHEN 'child' THEN 'CHILD'    
			WHEN 'adopted child' THEN 'CHLDADOPT'    
			WHEN 'adopted daughter' THEN 'DAUADOPT'    
			WHEN 'adopted son' THEN 'SONADOPT'    
			WHEN 'foster child' THEN 'CHLDFOST'    
			WHEN 'foster daughter' THEN 'DAUFOST'    
			WHEN 'foster son' THEN 'SONFOST'    
			WHEN 'daughter' THEN 'DAUC'    
			WHEN 'natural daughter' THEN 'DAU'    
			WHEN 'stepdaughter' THEN 'STPDAU'    
			WHEN 'natural child' THEN 'NCHILD'    
			WHEN 'natural son' THEN 'SON'    
			WHEN 'son' THEN 'SONC'    
			WHEN 'stepson' THEN 'STPSON'    
			WHEN 'step child' THEN 'STPCHLD'    
			WHEN 'extended family member' THEN 'EXT'    
			WHEN 'aunt' THEN 'AUNT'    
			WHEN 'maternal aunt' THEN 'MAUNT'    
			WHEN 'paternal aunt' THEN 'PAUNT'    
			WHEN 'cousin' THEN 'COUSN'    
			WHEN 'maternal cousin' THEN 'MCOUSN'    
			WHEN 'paternal cousin' THEN 'PCOUSN'    
			WHEN 'great grandparent' THEN 'GGRPRN'    
			WHEN 'great grandfather' THEN 'GGRFTH'    
			WHEN 'maternal great-grandfather' THEN 'MGGRFTH'    
			WHEN 'paternal great-grandfather' THEN 'PGGRFTH'    
			WHEN 'great grandmother' THEN 'GGRMTH'    
			WHEN 'maternal great-grandmother' THEN 'MGGRMTH'    
			WHEN 'paternal great-grandmother' THEN 'PGGRMTH'    
			WHEN 'maternal great-grandparent' THEN 'MGGRPRN'    
			WHEN 'paternal great-grandparent' THEN 'PGGRPRN'    
			WHEN 'grandchild' THEN 'GRNDCHILD'    
			WHEN 'granddaughter' THEN 'GRNDDAU'    
			WHEN 'grandson' THEN 'GRNDSON'    
			WHEN 'grandparent' THEN 'GRPRN'    
			WHEN 'grandfather' THEN 'GRFTH'    
			WHEN 'maternal grandfather' THEN 'MGRFTH'    
			WHEN 'paternal grandfather' THEN 'PGRFTH'    
			WHEN 'grandmother' THEN 'GRMTH'    
			WHEN 'maternal grandmother' THEN 'MGRMTH'    
			WHEN 'paternal grandmother' THEN 'PGRMTH'    
			WHEN 'maternal grandparent' THEN 'MGRPRN'    
			WHEN 'paternal grandparent' THEN 'PGRPRN'    
			WHEN 'inlaw' THEN 'INLAW'    
			WHEN 'child-in-law' THEN 'CHLDINLAW'    
			WHEN 'daughter in-law' THEN 'DAUINLAW'    
			WHEN 'son in-law' THEN 'SONINLAW'    
			WHEN 'parent in-law' THEN 'PRNINLAW'    
			WHEN 'father-in-law' THEN 'FTHINLAW'    
			WHEN 'mother-in-law' THEN 'MTHINLAW'    
			WHEN 'sibling in-law' THEN 'SIBINLAW'    
			WHEN 'brother-in-law' THEN 'BROINLAW'    
			WHEN 'sister-in-law' THEN 'SISINLAW'    
			WHEN 'niece/nephew' THEN 'NIENEPH'    
			WHEN 'nephew' THEN 'NEPHEW'    
			WHEN 'niece' THEN 'NIECE'    
			WHEN 'uncle' THEN 'UNCLE'    
			WHEN 'maternal uncle' THEN 'MUNCLE'    
			WHEN 'paternal uncle' THEN 'PUNCLE'    
			WHEN 'parent' THEN 'PRN'    
			WHEN 'adoptive parent' THEN 'ADOPTP'    
			WHEN 'adoptive father' THEN 'ADOPTF'    
			WHEN 'adoptive mother' THEN 'ADOPTM'    
			WHEN 'father' THEN 'FTH'    
			WHEN 'foster father' THEN 'FTHFOST'    
			WHEN 'natural father' THEN 'NFTH'    
			WHEN 'natural father of fetus' THEN 'NFTHF'    
			WHEN 'stepfather' THEN 'STPFTH'    
			WHEN 'mother' THEN 'MTH'    
			WHEN 'gestational mother' THEN 'GESTM'    
			WHEN 'foster mother' THEN 'MTHFOST'    
			WHEN 'natural mother' THEN 'NMTH'    
			WHEN 'natural mother of fetus' THEN 'NMTHF'    
			WHEN 'stepmother' THEN 'STPMTH'    
			WHEN 'natural parent' THEN 'NPRN'    
			WHEN 'foster parent' THEN 'PRNFOST'    
			WHEN 'step parent' THEN 'STPPRN'    
			WHEN 'sibling' THEN 'SIB'    
			WHEN 'brother' THEN 'BRO'    
			WHEN 'half-brother' THEN 'HBRO'    
			WHEN 'natural brother' THEN 'NBRO'    
			WHEN 'twin brother' THEN 'TWINBRO'    
			WHEN 'fraternal twin brother' THEN 'FTWINBRO'    
			WHEN 'identical twin brother' THEN 'ITWINBRO'    
			WHEN 'stepbrother' THEN 'STPBRO'    
			WHEN 'half-sibling' THEN 'HSIB'    
			WHEN 'half-sister' THEN 'HSIS'    
			WHEN 'natural sibling' THEN 'NSIB'    
			WHEN 'natural sister' THEN 'NSIS'    
			WHEN 'twin sister' THEN 'TWINSIS'    
			WHEN 'fraternal twin sister' THEN 'FTWINSIS'    
			WHEN 'identical twin sister' THEN 'ITWINSIS'    
			WHEN 'twin' THEN 'TWIN'    
			WHEN 'fraternal twin' THEN 'FTWIN'    
			WHEN 'identical twin' THEN 'ITWIN'    
			WHEN 'sister' THEN 'SIS'    
			WHEN 'stepsister' THEN 'STPSIS'    
			WHEN 'step sibling' THEN 'STPSIB'    
			WHEN 'significant other' THEN 'SIGOTHR'    
			WHEN 'domestic partner' THEN 'DOMPART'    
			WHEN 'former spouse' THEN 'FMRSPS'    
			WHEN 'spouse' THEN 'SPS'    
			WHEN 'husband' THEN 'HUSB'    
			WHEN 'wife' THEN 'WIFE'    
			WHEN 'unrelated friend' THEN 'FRND'    
			WHEN 'neighbor' THEN 'NBOR'    
			WHEN 'self' THEN 'ONESELF'    
			WHEN 'Roommate' THEN 'ROOM'    
			ELSE ''    
			END AS PersonalRelationCode    
	  FROM Clients c    
	   LEFT JOIN ClientContacts cc ON cc.ClientId = c.ClientId    
	   LEFT JOIN ClientContactAddresses ca ON ca.ClientContactId = cc.ClientContactId and ca.AddressType=90 --Home    
	   LEFT JOIN ClientContactPhones cp ON cp.ClientContactId = cc.ClientContactId and cp.PhoneType = 30 --Home    
	   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = cc.Relationship               
	  WHERE (ISNULL(@ClientId, '')='' OR c.ClientId = @ClientId)    
	  AND c.Active = 'Y'     
	  AND ISNULL(c.RecordDeleted,'N')='N'     
	     
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetParticipant') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +     
   CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                           
    16    
    ,-- Severity.                                                                  
    1 -- State.                                                               
    );    
 END CATCH    
END 
GO


