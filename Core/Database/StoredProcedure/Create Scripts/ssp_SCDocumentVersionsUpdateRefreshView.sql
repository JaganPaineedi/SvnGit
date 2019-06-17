/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionsUpdateRefreshView]    Script Date: 09/23/2015 13:42:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCDocumentVersionsUpdateRefreshView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCDocumentVersionsUpdateRefreshView]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCDocumentVersionsUpdateRefreshView]    Script Date: 09/23/2015 13:42:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROC [dbo].[ssp_SCDocumentVersionsUpdateRefreshView](                
@DocumentVersionId int,  
@RefreshViewValue nvarchar(1)        
)                  
as              
/*********************************************************************/                  
/* Stored Procedure: dbo.ssp_SCDocumentVersionsUpdateRefreshView     */                  
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:    07/12/2012                                      */                  
/*                                                                   */                  
/* Purpose:  Update  Document Versions  Field RefreshView = @RefreshViewValue*/                  
/*                                                                   */                
/* Input Parameters:@DocumentVersionId - DocumentVersionId           */                  
/*                 :@RefreshViewValue - RefreshViewValue    */                  
/*                                                                   */                  
/* Return:  RefreshView VALUE                                        */                  
/*                                                                   */                  
/* Called By:                                                        */                  
/*                                                                   */                  
/* Calls:                                                            */                  
/*                                                                   */                  
/* Data Modifications:                                               */                  
/* Updates:                                                          */                  
/*   Date        Author         Purpose                              */                  
/* 7/12/2012    Sanjayb        Created                              */   
/* 10/22/2012   Pradeep        Only written this comment to come this sp in UP in svn as it is compatible with version 12.10
   23/09/2015   Varun		   Added condition to check if not Old Diagnosis document version
   11/14/2018    jcarlson	  Fixed RAISERROR syntax			    */ 
/*********************************************************************/                 
BEGIN                
  
DECLARE @RefreshViewReturn nvarchar(1)  
SET @RefreshViewReturn = 'N' 

DECLARE @dvId int
SET  @dvId= (SELECT TOP 1 DocumentVersionId FROM DocumentDiagnosis WHERE DocumentVersionId=@DocumentVersionId and ISNULL(RecordDeleted,'N')='N')

DECLARE @TableList nvarchar(max)
SET @TableList= (select TableList from DocumentCodes dc   
inner join Documents d on d.DocumentCodeId=dc.DocumentCodeId  
inner join DocumentVersions dv on d.DocumentId=dv.DocumentId
where dv.DocumentVersionId=@DocumentVersionId)

IF(@dvId is not null or @TableList not like '%DocumentDiagnosisCodes%')
BEGIN
IF EXISTS(SELECT DocumentVersionId FROM DocumentVersions WHERE DocumentVersionId=@DocumentVersionId )          
BEGIN  
 SELECT @RefreshViewReturn=ISNULL(RefreshView,'N') FROM DocumentVersions WHERE DocumentVersionId=@DocumentVersionId  
 IF(@RefreshViewValue !='') -- Update only when @RefreshViewValue will be 'Y' or 'N' otherwise it will return just status of RefreshView FIELD  
 BEGIN  
 UPDATE  DocumentVersions  
 SET RefreshView = @RefreshViewValue  
 WHERE DocumentVersionId=@DocumentVersionId   
 END  
END  
END
SELECT @RefreshViewReturn                
IF (@@error!=0)                
    BEGIN                
         RAISERROR( 'ssp_SCDocumentVersionsUpdateRefreshView : An Error Occured',16,1)
                        
         RETURN(1)                
    END                
RETURN(0)                
                
END         
        
GO


