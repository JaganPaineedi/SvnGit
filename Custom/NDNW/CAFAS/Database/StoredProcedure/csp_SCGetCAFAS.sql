/****** Object:  StoredProcedure [dbo].[csp_SCGetCAFAS]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCAFAS]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCAFAS]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************/                                                
 /* Stored Procedure:csp_SCGetCAFASTest                                      */                                       
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */     
 /* Author: Pradeep                                                          */                                               
 /* Creation Date:  Aug 20,2009                                              */                                                
 /* Purpose: Gets Data for CAFAS  Document                                   */                                               
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                              
 /* Output Parameters:None                                                   */                                                
 /* Return:                                                                  */                                                
 /* Calls:                                                                   */    
 /* Called From:                                                             */                                                
 /* Data Modifications:                                                      */                                                
 /*-------------Modification History--------------------------               */
 /*-------Date----Author-------Purpose---------------------------------------*/ 
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */ 
 /* 03/04/2010 Vikas Monga             */  
 /* -- Remove [Documents] and [DocumentVersions]        */                        
 /****************************************************************************/                                                 

CREATE PROCEDURE  [dbo].[csp_SCGetCAFAS]                                 
  @DocumentVersionId INT                                   
AS                                      
BEGIN                    
  BEGIN TRY                        
   --For CustomCAFAS Table                
	SELECT     DocumentVersionId, CAFASDate, RaterClinician, CAFASInterval, SchoolPerformance, HomePerformance, CommunityPerformance, BehaviourTowardsOther, 
					  MoodsEmotion, SelfHarmfulBehavoiur, SubstanceUse, Thinkng, PrimaryFamilyMaterialNeeds, PrimaryFamilySocialSupport, NonCustodialMaterialNeeds, 
					  NonCustodialSocialSupport, SurrogateMaterialNeeds, SurrogateSocialSupport, CreatedDate, CreatedBy, ModifiedDate, ModifiedBy, RecordDeleted, DeletedDate, 
					  DeletedBy
	FROM         CustomCAFAS
	WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                                                
 END TRY                    
 BEGIN CATCH                    
	DECLARE @Error varchar(8000)                                                       
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                      
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_SCGetCAFASTest]')                                                       
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                      
	+ '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                      
	RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                  
	         
 END CATCH                                  
End

GO


