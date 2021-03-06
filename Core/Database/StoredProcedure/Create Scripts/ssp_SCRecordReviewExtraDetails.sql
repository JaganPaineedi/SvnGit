/****** Object:  StoredProcedure [dbo].[ssp_SCRecordReviewExtraDetails]    Script Date: 11/18/2011 16:25:59 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCRecordReviewExtraDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCRecordReviewExtraDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCRecordReviewExtraDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = 
		N'CREATE proc  [dbo].[ssp_SCRecordReviewExtraDetails]   -- 219          
      
@recordReviewId int                                   
AS                                                
                                                
/*********************************************************************/                                                  
/* Stored Procedure: dbo.ssp_SCRecordReviewExtraDetails                */                                                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                  
/* Creation Date:    15/June/2011                                         */                                                  
/*                                                                   */                                                  
/* Purpose:  Used to get the template details assigned to a particular staff member */                                                 
/*                                                                   */                                                
/* Input Parameters:   @recordReviewId        */                                                
/*                                                                   */                                                  
/* Output Parameters:   None                */                                                  
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
/*  Date          Author          Purpose                             */                                                  
/* 15/june/2011   Karan Garg      Created                             */                                                
/*  21 Oct 2015    Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  /   
/								  why:task #609, Network180 Customization  */                                          
                                                
/*********************************************************************/                                                       
BEGIN                                   
  BEGIN TRY                               
     
   select   
   CustomRecordReviews.RecordReviewId,  
   CustomRecordReviews.CreatedBy,  
   CustomRecordReviews.CreatedDate,  
   CustomRecordReviews.ModifiedBy,  
   CustomRecordReviews.ModifiedDate,  
   CustomRecordReviews.RecordDeleted,  
   CustomRecordReviews.DeletedDate,  
   CustomRecordReviews.DeletedBy,  
   CustomRecordReviews.RecordReviewTemplateId,  
   CustomRecordReviews.ReviewingStaff,  
   CustomRecordReviews.ClinicianReviewed,  
   CustomRecordReviews.ClientId,  
   CustomRecordReviews.Status,  
   CustomRecordReviews.AssignedDate,  
   CustomRecordReviews.CompletedDate,  
   CustomRecordReviews.ReviewComments,  
   CustomRecordReviews.Results,  
   CustomRecordReviews.RequestQIReview,  
     
   CustomRecordReviewTemplates.RecordReviewTemplateName ,
   --Added by Revathi 21 Oct 2015
   case when  ISNULL(Clients.ClientType,''I'')=''I'' then
   ISNULL(Clients.LastName,'''')+'', ''+ISNULL(Clients.FirstName,'''') else ISNULL(Clients.OrganizationName,'''') end as ClientName  
   from   CustomRecordReviews inner join CustomRecordReviewTemplates  
   on CustomRecordReviews.RecordReviewTemplateId = CustomRecordReviewTemplates.RecordReviewTemplateId  
   inner join Clients on  
   CustomRecordReviews.ClientId = Clients.ClientId  
     
   where CustomRecordReviews.RecordReviewId = @recordReviewId   
 END TRY                              
BEGIN CATCH                                  
DECLARE @Error varchar(8000)                                                    
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''ssp_SCRecordReviewExtraDetails'')                          
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                      
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                    
                                                  
   RAISERROR                                                     
   (                                                    
    @Error, -- Message text.                                                    
    16, -- Severity.                                                    
    1 -- State.                                                    
   );                                     
End CATCH                                                                                           
                              
End '
END
GO

