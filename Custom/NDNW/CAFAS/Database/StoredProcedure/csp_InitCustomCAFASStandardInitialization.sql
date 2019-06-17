GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomCAFASStandardInitialization]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCAFASStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCAFASStandardInitialization]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitCustomCAFASStandardInitialization]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_InitCustomCAFASStandardInitialization]      
(                    
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml
)                                            
As                                                              
 /*********************************************************************/                                                                  
 /* Stored Procedure: [csp_InitCAFASStandardInitialization]               */                                                         
                                                         
 /* Copyright: 2006 Streamline SmartCare*/                                                                  
                                                         
 /* Creation Date:  14/Jan/2008                                    */                                                                  
 /*                                                                   */                                                                  
 /* Purpose: To Initialize */                                                                 
 /*                                                                   */                                                                
 /* Input Parameters:  */                                                                
 /*                                                                   */                                                                   
 /* Output Parameters:                                */                                                                  
 /*                                                                   */                                                                  
 /* Return:   */                                                                  
 /*                                                                   */                                                                  
 /* Called By:CustomDocuments Class Of DataService    */                                                        
 /*      */                                                        
                                                         
 /*                                                                   */                                                                  
 /* Calls:                                                            */                                                                  
 /*                                                                   */                                                                  
 /* Data Modifications:                                               */                                                                  
 /*                                                                   */                                                                  
 /*   Updates:                                                          */                                                                  
                                                         
 /*       Date              Author                  Purpose                                    */                                                                  
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */        
 /*       Nov18,2009        Ankesh                Made changes as paer dataModel SCWebVenture3.0  */   
                                   
 /*************************************************************************************************/                                            
        
Begin                                              
    
BEGIN TRY                
DECLARE @primaryClinicianId AS INT               
SELECT  @primaryClinicianId=primaryClinicianId  FROM Clients WHERE ClientID=@ClientID                  
                      
                                                                                  
                               
                                 
		SELECT     TOP (1) 'CustomCAFAS' AS TableName, - 1 AS 'DocumentVersionId', getdate() AS CAFASDate, @primaryClinicianId AS RaterClinician, 0 AS SchoolPerformance, 
							  0 AS HomePerformance, 0 AS CommunityPerformance, 0 AS BehaviourTowardsOther, 0 AS MoodsEmotion, 0 AS SelfHarmfulBehavoiur, 0 AS SubstanceUse, 
							  0 AS Thinkng, 0 AS PrimaryFamilyMaterialNeeds, 0 AS PrimaryFamilySocialSupport, 0 AS NonCustodialMaterialNeeds, 0 AS NonCustodialSocialSupport, 
							  0 AS SurrogateMaterialNeeds, 0 AS SurrogateSocialSupport, '' AS CreatedBy, GETDATE() AS CreatedDate, '' AS ModifiedBy, GETDATE() AS ModifiedDate,
							  CAST(NULL AS VARCHAR(300)) AS FASProgramName,CAST(NULL AS INT) AS FASEpisodeNumber
		FROM         SystemConfigurations AS s LEFT OUTER JOIN
						  CustomCAFAS ON s.DatabaseVersion = - 1
                             
END TRY                                             
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_InitCAFASStandardInitialization')                                                                             
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + '*****' + Convert(varchar,ERROR_STATE())                          
 RAISERROR                                                                             
 (                                               
  @Error, -- Message text.                                                                            
  16, -- Severity.                                                                            
  1 -- State.                                                                            
 );                                                                          
END CATCH                         
END

GO


