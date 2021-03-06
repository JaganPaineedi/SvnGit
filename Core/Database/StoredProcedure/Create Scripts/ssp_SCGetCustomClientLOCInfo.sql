/****** Object:  StoredProcedure [dbo].[ssp_SCGetCustomClientLOCInfo]    Script Date: 11/18/2011 16:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCustomClientLOCInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCustomClientLOCInfo]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCustomClientLOCInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCGetCustomClientLOCInfo]                                          
     
 @ClientID int    
                            
AS     
/********************************************************************************************/                                                  
/* Stored Procedure: ssp_SCGetCustomClientLOCInfo											*/                                         
/* Copyright: 2009 Streamline Healthcare Solutions											*/                                                  
/* Creation Date:  9 Dec 2010 																*/                                                  
/* Purpose: Get Entry from Custom Client LOC Table based on Client ID						*/                                                 
/* Input Parameters: @AuthorizationId        											    */                                                
/* Output Parameters:																		*/                                                  
/* Return:																					*/                                                  
/* Called By: GetCustomClientLOCCategories() Method in TreatmentPlan Class Of DataService */                                                  
/* Calls:																					*/                                                  
/* Data Modifications:																		*/                                                  
/*       Date              Author                  Purpose									*/                                                  
/*	  9 Dec 2010           Rakesh                Created 									*/   
/*	  8 June 2015		   MD Hussain K			Added condition to ensure that only one LOC is returned even if 2 exist without end dates w.r.t task #188 Customization Bugs*/                                               
/********************************************************************************************/                                          
                                  
BEGIN                                            
BEGIN TRY                                            

	Select CL.LOCCategoryId,CL.MinDeterminatorScore,CL.MaxDeterminatorScore,CL.LOCType ,     
		CCL.ClientLOCId,CCL.LOCID,CCL.LOCStartDate,CCL.LOCEndDate,CCL.LOCBy,CL.LOCName ,CLC.LOCCategoryName  

	from CustomClientLOCs CCL    
		join CustomLOCs CL on CL.LOCId = CCL.LOCId  and Isnull(CCL.RecordDeleted,''N'') = ''N''  
		join CustomLOCCategories CLC on CL.LOCCategoryId = CLC.LOCCategoryId  
	where ClientId = @ClientID and LOCEndDate IS NULL  
	AND NOT EXISTS ( SELECT *
                             FROM   CustomClientLOCs AS b
                             WHERE  b.ClientId = CCL.ClientId
                                    AND b.LOCEndDate IS NULL
                                    AND ISNULL(b.RecordDeleted, ''N'') = ''N''
                                    AND ( ( b.LOCStartDate > CCL.LOCStartDate )
                                          OR ( b.LOCStartDate = CCL.LOCStartDate
                                               AND b.ClientLOCId > CCL.ClientLOCId
                                             )
                                        ) )  
	   

	     
END TRY                                              
                                            
BEGIN CATCH                                               
DECLARE @Error varchar(8000)                                                
 SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                 
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[ssp_SCGetCustomClientLOCInfo]'')                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                                                
                                            
 RAISERROR                                                 
 (                                                
  @Error, -- Message text.                                                
  16, -- Severity.                                                
  1 -- State.                                                
 );                                                
                                                
END CATCH                                             
END    
  ' 
END
GO
