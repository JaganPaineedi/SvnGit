IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMDeleteImageRecordItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMDeleteImageRecordItems]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_PMDeleteImageRecordItems]        
	@ImageRecordId int,        
	@UserCode varchar(30)        
AS        
/*********************************************************************/        
/* Stored Procedure: dbo.[ssp_PMDeleteImageRecordItems]                         */        
/* Creation Date:    12 July 2010                                   */        
/*                                                                   */        
/* Purpose:  This procedure is called from Scanned Medical Record detail  to delete the ImageRecordItems when       
user opted to Delete ImageRecords by clicking on Delete button provided by architechture       */        
/* Input Parameters:             */        
/*                                                                   */        
/* Output Parameters:                                                */        
/*                                                                   */        
/* Return Status:                                                    */        
/*                                                                   */        
/* Called By:       */        
/*                                                                   */        
/* Calls:                                                            */        
/*                                                                   */        
/* Data Modifications:    */        
/*                                                                   */        
/* Updates:                                                          */        
/* Date            Author                   Purpose                                    */        
/* 12 July 2010    Ashwani Kumar Angrish    Created                                    
   11/14/2018    jcarlson	  Fixed RAISERROR syntax			    */         
/*********************************************************************/        
BEGIN        
Begin try        
    
	 -- set RecordDeleted in ScannedMedicalRecords table        
	 Update ImageRecordItems set RecordDeleted='Y', DeletedBy=@UserCode,DeletedDate=getDate(),ModifiedBy=@UserCode,ModifiedDate=GETDATE()         
	  where ImageRecordId = @ImageRecordId        
        
        
End Try

Begin Catch        
	DECLARE @Error varchar(8000)                                    
	 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                     
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_PMDeleteImageRecordItems]')                                     
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                      
		+ '*****' + Convert(varchar,ERROR_STATE())                                    
	                              
	                                
	 RAISERROR                                     
	 (                                    
	  @Error, -- Message text.                                    
	  16, -- Severity.                                    
	  1 -- State.                                    
	 );                
End Catch        
        
END
