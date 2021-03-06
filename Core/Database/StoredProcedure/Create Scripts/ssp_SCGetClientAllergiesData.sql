/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientAllergiesData]    Script Date: 11/18/2011 16:25:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientAllergiesData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientAllergiesData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[ssp_SCGetClientAllergiesData] ( @ClientId INT )
AS /*********************************************************************/                                                          
/* Stored Procedure: dbo.[ssp_SCGetClientAllergiesData]                */                                                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                          
/* Creation Date:    01/Nov/2007                                         */                                                         
/*                                                                   */                                                          
/* Purpose:  To Get Client Allergies  Data */                                                          
/*                                                                   */                                                        
/* Input Parameters: none        @ClientId */                                                        
/*                                                                   */                                                          
/* Output Parameters:   None                           */                                                          
/*                                                                   */                                                          
/* Return:  0=success, otherwise an error number                     */                                                          
/*                                                                   */                                                          
/* Called By:                                                        */                                                          
/*                                                                   */                                                          
/* Calls:                                                            */                                                          
/*                                                                   */                                                          
/* Data Modifications:                                               */                                                          
/*                                                                   */                                                          
/* Updates:                                                          */                                                          
/*   Date         Author            Purpose                                    */                                                          
/*  01/Nov/2007    Sonia Dhamija    Created                                    */        
/*26Oct 2009      Pradeep           Add ca.AllergyType as per task#9(Venture) */    
/*  03/Feb/2010    Loveena   Modified(ref to Task#86)                                    */                                                        
/* 04/28/2011 Modified added Active Column */   
/* 09/Feb/2015		Chethan N		What: Record Deleted check for MDAllergenConcepts table.
									Why: Philhaven - Customization Issues Tracking task# 1232 */
/*18/03/2019 musman   
 Existing functionality does not have display the information about selected reaction and severity. 
Added new column in Allergies section for displaying  AllergyReaction and AllergySeverity while moving the
 cursor on info icon. as part of Project :	HighPlains - Environment Issues Tracking #35*/									
/*********************************************************************/                                                     
   BEGIN TRY
                            
    DECLARE @NoKnownAllergies CHAR(1)
    DECLARE @AllergyCount INT 
    DECLARE @AllergyCount2 INT 
    DECLARE @ClientsID INT
    
    SELECT  @Clientsid = c.clientid ,
            @NoKnownAllergies = c.NoKnownAllergies ,
            @AllergyCount = SUM(CASE WHEN ISNULL(ca.AllergyType, 'A') = 'A'
                                     THEN 1
                                     ELSE 0
                                END) ,
            @AllergyCount2 = SUM(CASE WHEN ISNULL(ca.AllergyType, 'A') <> 'A'
                                      THEN 1
                                      ELSE 0
                                 END)
    FROM    Clients c
            JOIN ClientAllergies ca ON ( c.clientid = ca.clientid )
            JOIN MDAllergenConcepts md ON ( ca.AllergenConceptId = md.AllergenConceptId )
    WHERE   c.clientid = @ClientId
            AND ca.Active = 'Y'
            AND ( ISNULL(ca.RecordDeleted, 'N') <> 'Y' )
			AND ISNULL(md.RecordDeleted, 'N') = 'N' -- Chethan N changes on 09/Feb/2015
    GROUP BY c.clientid ,
            c.NoKnownAllergies
    
    
---To Pull Allergies Data                
    SELECT  ca.clientid ,
            ca.ClientAllergyId ,
            md.AllergenConceptId ,
            md.ExternalConceptId ,
            md.ConceptIdType ,
            md.ConceptDescription ,
            ca.AllergyType ,
            ca.Comment ,
            ca.Active ,
			ca.SNOMEDCode ,
			ca.LastReviewedBy,
			convert(varchar(10), ca.ModifiedDate, 101) as LastModifiedDate,
			
			 CASE 
         WHEN ca.AllergyReaction IS NOT NULL THEN gc.CodeName 
         ELSE '' 
       END                                        AS AllergyReaction, 
       CASE 
         WHEN ca.AllergySeverity IS NOT NULL THEN gc1.CodeName 
         ELSE '' 
       END                                        AS AllergySeverity
       
       
       
    FROM    ClientAllergies ca
            JOIN MDAllergenConcepts md ON ( ca.AllergenConceptId = md.AllergenConceptId )
            
             LEFT JOIN GlobalCodes gc 
                    ON gc.GlobalCodeId = ca.allergyreaction 
    LEFT JOIN GlobalCodes gc1 
                    ON gc1.GlobalCodeId = ca.allergyseverity 
                    
                    
    WHERE   ca.clientid = @ClientId
            AND ( ISNULL(ca.RecordDeleted, 'N') <> 'Y' )
			AND ISNULL(md.RecordDeleted, 'N') = 'N' -- Chethan N changes on 09/Feb/2015
    
    IF ( @NoKnownAllergies = 'Y'
         AND @AllergyCount > 0
       ) 
        BEGIN 
            UPDATE  clients
            SET     NoKnownAllergies = 'N'
            WHERE   ClientId = @ClientId            
        END 
    
    
  END TRY              
 BEGIN CATCH
DECLARE @Error VARCHAR(8000)

SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_GetCustomDocumentSubstanceAbuseHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

RAISERROR (
@Error
,-- Message text.
16
,-- Severity.
1 -- State.
);
END CATCH

GO
