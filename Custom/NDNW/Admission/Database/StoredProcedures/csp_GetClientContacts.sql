IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[csp_GetClientContacts]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[csp_GetClientContacts] 

GO 

CREATE PROCEDURE [dbo].[csp_GetClientContacts] 
-- csp_GetClientContacts 2                     
(@ClientId INT) 
AS 
/*********************************************************************/ 
/* Stored Procedure: [csp_GetClientContacts]               */ 
/* Creation Date:  08 Sept 2014                                    */ 
/* Author:  Malathi Shiva                     */ 
/* Purpose: To load data after save */ 
/* Data Modifications:                   */ 
/*  Modified By    Modified Date    Purpose        */ 
/*                                                                   */ 
  /*********************************************************************/ 
  BEGIN TRY 
            
		SELECT CC.ClientContactId 
				 ,CC.RecordDeleted
				 ,CC.DeletedBy
				 ,CC.DeletedDate
                 ,CC.ListAs 
                 ,GC.CodeName               AS RelationshipText, 
                 ( SELECT TOP ( 1 )  
                        PhoneNumber  
              FROM      ClientContactPhones  
              WHERE     ( ClientContactId = CC.ClientContactId )  
                        AND ( PhoneNumber IS NOT NULL )  
                        AND ( ISNULL(RecordDeleted, 'N') = 'N' )  
              ORDER BY  PhoneType  
            ) AS Phone ,
                 CC.Organization 
                 ,CC.Guardian               AS GuardianText 
                 ,CC.EmergencyContact       AS EmergencyText 
                 ,CC.FinanciallyResponsible AS FinResponsibleText 
                 ,CC.HouseholdMember        AS HouseholdnumberText 
                 ,CC.Active                 AS Active 
          FROM  ClientContacts CC   
            INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CC.Relationship  
                                      AND ISNULL(GC.RecordDeleted,  
                                                 'N') <> 'Y'  
                                      AND GC.Category = 'RELATIONSHIP'  
       WHERE   ( ISNULL(CC.RecordDeleted, 'N') <> 'Y' )  
            AND ( CC.ClientId =  @ClientID )
  END TRY 

  BEGIN CATCH 
      DECLARE @Error VARCHAR(8000) 

      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                  + '*****' 
                  + isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                  'csp_GetClientContacts') 
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                  + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

      RAISERROR ( @Error,-- Message text.                       
                  16,-- Severity.                       
                  1 -- State.                       
      ); 
  END CATCH 

GO 