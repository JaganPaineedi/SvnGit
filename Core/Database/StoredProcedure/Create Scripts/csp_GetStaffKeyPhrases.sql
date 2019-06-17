/****** Object:  StoredProcedure [dbo].[csp_GetStaffKeyPhrases]    Script Date: 08/03/2017 20:33:18 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetStaffKeyPhrases]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetStaffKeyPhrases]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetStaffKeyPhrases]    Script Date: 08/03/2017 20:33:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

         
CREATE PROCEDURE [dbo].[csp_GetStaffKeyPhrases]-- 550
	@StaffID INT

AS /**********************************************************************/                                      
/* Stored Procedure: dbo.csp_GetStaffKeyPhrases            */                                      
/* Copyright: 2017 Streamline Healthcare Solutions,  LLC                 */                                      
/* Creation Date:    19-July-2017                                         */                                      
/*                                                                      */                                      
/* Purpose:Used to get KeyPhrases                 */                                     
/*                                                                      */                                    
/* Input Parameters: @StaffID                    */                                    
/*                                                                      */                                      
/* Output Parameters:   None                                            */                                      
/*                                                                      */                                      
/* Return:  0=success, otherwise an error number                        */                                      
/*                                                                      */                                      
/* Called By: KeyPhrases.aspx.cs              */                                      
/*                                                                      */                                      
/* Calls:                                                               */                                      
/*                                                                      */                                      
/* Data Modifications:                                                  */                                      
/*                                                                      */                                      
/* Updates:                                                             */                                      
/*    Date         Author          Purpose                               */                                      
/* 19-July-2017   Aravind          Created                                */                  

/**********************************************************************/                                       
                                  
	BEGIN                                    

		SELECT	kp.KeyPhraseId
				,kp.CreatedBy
				,kp.CreatedDate
				,kp.ModifiedBy
				,kp.ModifiedDate
				,kp.RecordDeleted
				,kp.DeletedDate
				,kp.DeletedBy
				,kp.StaffId
				,kp.KeyPhraseCategory
				,kp.Favorite
				,kp.PhraseText
				,dbo.csf_GetGlobalCodeNameById(kp.[KeyPhraseCategory]) as KeyPhraseCategoryName 
				
		FROM	KeyPhrases kp
	   Inner Join GlobalCodes G ON G.GlobalCodeId=kp.KeyPhraseCategory

		WHERE	kp.StaffId = @StaffID
				AND ISNULL(kp.RecordDeleted, 'N') = 'N' AND G.Category='RXKEYPHRASECATEGORY'
				
	 SELECT 	AK.AgencyKeyPhraseId
				,AK.CreatedBy
				,AK.CreatedDate
			    ,AK.CreatedDate
				,AK.ModifiedBy
				,AK.ModifiedDate
				,AK.RecordDeleted
				,AK.DeletedDate
				,AK.DeletedBy
				,AK.KeyPhraseCategory
				,AK.PhraseText
				,dbo.csf_GetGlobalCodeNameById(AK.[KeyPhraseCategory]) as KeyPhraseCategoryName
		  FROM AgencyKeyPhrases AK
		  WHERE ISNULL(AK.RecordDeleted, 'N') = 'N'	
		  
		  
		  
    SELECT SAK.[StaffAgencyKeyPhraseId]
      ,SAK.[CreatedBy]
      ,SAK.[CreatedDate]
      ,SAK.[ModifiedBy]
      ,SAK.[ModifiedDate]
      ,SAK.[RecordDeleted]
      ,SAK.[DeletedDate]
      ,SAK.[DeletedBy]
      ,SAK.[StaffId]
      ,AK.[AgencyKeyPhraseId]
  FROM [StaffAgencyKeyPhrases] SAK 
  Inner join AgencyKeyPhrases AK ON AK.AgencyKeyPhraseId=SAK.AgencyKeyPhraseId
  WHERE ISNULL(SAK.RecordDeleted,'N')='N'  AND ISNULL(SAK.RecordDeleted,'N')='N' Order by AK.ModifiedDate DESC 
		  
		IF ( @@error != 0 ) 
			BEGIN       
				RAISERROR  20002 'Key Phrases : An Error Occured '                                    
				RETURN(1)                          
			END                                    
		RETURN(0)                                    
	END 


GO


