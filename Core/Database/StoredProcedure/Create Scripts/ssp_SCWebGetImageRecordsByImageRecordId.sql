/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetImageRecordsByImageRecordId]    Script Date: 11/18/2011 16:26:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetImageRecordsByImageRecordId]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebGetImageRecordsByImageRecordId]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebGetImageRecordsByImageRecordId]    
 -- Add the parameters for the stored procedure here      
 @ImageRecordId int      
AS      
/*********************************************************************/                            
/* Stored Procedure: dbo.[ssp_SCWebGetImageRecordsByImageRecordId]      */                  
                                                          
                  
/* Copyright: 2007 Streamlin Healthcare Solutions           */                            
                  
/* Creation Date:  21 september 2010                                   */                            
/*                                                                   */                            
/* Purpose: */                           
/*                                                                   */                          
/* Input Parameters: */                          
/*                                                                   */                             
/* Output Parameters:                                */                            
/*                                                                   */                            
/* Return:   */                            
/*                                                                   */                            
/* Called By: */                            
                  
/*                                                                   */                            
/* Calls:                                                            */                            
/*                                                                   */                            
/* Data Modifications:                                               */                            
/*                                                                   */                            
/*   Updates:                                                          */                            
                  
/* Date            Author                           Purpose                                    */                  
/* 21/09/2010      Ashwani Kumar Angrish      Created                                    */   
/* 19/05/2011      Karan Garg	              Updated(Commented rowidentifier column)    */
/* 21 Oct 2015     Revathi                    what:Changed code to display Clients LastName and FirstName when */
/*                                            ClientType=''I'' else  OrganizationName.  */
/*                                            why:task #609, Network180 Customization  */                                
/*13 Sep 2016	Manjunath K What: Added Condition to Check ClientID when selecting Client FirstName and LastName.*/  
/*							Why : It was returning only Comma if ClientId is NULL    								 */
/*                          What: Returning RecordType from EventTypes, GlobalCodes or DocumentCodes			 */  
/*						    For Core Bugs 2260											*/                       
/*********************************************************************/        
BEGIN  
BEGIN TRY
	
DECLARE @EventID int
SET @EventID =(select Top 1 EventId from Documents where DocumentId in  (
select DocumentId from DocumentVersions where DocumentVersionId in(
select distinct  DocumentVersionId from ImageRecords IR where DocumentVersionId is not null AND 
IR.ImageRecordId=@ImageRecordId )))

  CREATE TABLE #TempImageRecords
  (
  RecordType VARCHAR(250),
  ImageRecordId Int
  )
  
  INSERT INTO #TempImageRecords
  SELECT 
  CASE 
  WHEN ISNULL(dc.DocumentName,'') <> '' THEN dc.DocumentName
  WHEN ISNULL(gc.CodeName,'') <> '' then gc.CodeName
  WHEN ISNULL(e.EventName,'') <> '' THEN e.EventName
  END as RecordType, 
  IR.ImageRecordId as ImageRecordId
  FROM [ImageRecords] IR 
  left join EventTypes as e on ir.AssociatedId=e.EventTypeId AND ISNULL(e.RecordDeleted,'N')='N' 
  left join GlobalCodes as gc on ir.AssociatedId=gc.GlobalCodeId  AND ISNULL(gc.RecordDeleted,'N')='N' 
  left join DocumentCodes as dc on ir.AssociatedId=dc.DocumentCodeId AND ISNULL(dc.RecordDeleted,'N')='N'
  WHERE 
  (ir.ImageRecordId=@ImageRecordId AND ISNULL(ir.RecordDeleted,'N')='N') 
  AND((IR.DocumentVersionId is not null AND @EventID is null )		-- Document
  OR (IR.DocumentVersionId is null)									-- GlobalCode
  OR (ISNULL(IR.RecordDeleted,'N')='N' AND @EventID is not null))	-- Event
    
 SELECT ir.[ImageRecordId]      
      ,ir.[ScannedOrUploaded]      
      ,ir.[DocumentVersionId]      
      ,ir.[ImageServerId]      
      --Added by Revathi 21 Oct 2015
      ,CASE WHEN ir.ClientId <> NULL then					 -- 13 Sep 2016	Manjunath K  
      case when  ISNULL(cs.ClientType,'I')='I' 
      then ISNULL(cs.LastName,'') + ',' + ISNULL(cs.FirstName,'') 
      else isnull(cs.OrganizationName,'') END ELSE '' end as ClientName     
      ,ti.RecordType as RecordType							 -- 13 Sep 2016	Manjunath K      
      ,ir.[AssociatedWith]      
      ,ir.[RecordDescription]      
      ,ir.[EffectiveDate]      
      ,ir.[NumberOfItems]      
      ,ir.[AssociatedWithDocumentId]      
      ,ir.[AppealId]      
      ,ir.[StaffId]      
      ,ir.[EventId]      
      ,ir.[ProviderId]      
      ,ir.[TaskId]      
      ,ir.[ScannedBy]      
      --,ir.[RowIdentifier]      
      ,ir.[CreatedBy]      
      ,ir.[CreatedDate]      
      ,ir.[ModifiedBy]      
      ,ir.[ModifiedDate]      
      ,ir.[RecordDeleted]      
      ,ir.[DeletedDate]      
      ,ir.[DeletedBy]      
  FROM [ImageRecords] as ir   
  left join Clients as cs on ir.ClientId=cs.ClientId AND ISNULL(cs.RecordDeleted,'N')='N'
  left join #TempImageRecords ti on ir.ImageRecordId=ti.ImageRecordId  -- 13 Sep 2016	Manjunath K    
  where ir.ImageRecordId=@ImageRecordId and ISNULL(ir.RecordDeleted,'N')='N'  
    
  END TRY    
BEGIN CATCH

        declare @Error varchar(8000)
        set @Error = convert(varchar, error_number()) + '*****'
            + convert(varchar(4000), error_message()) + '*****'
            + isnull(convert(varchar, error_procedure()),
                     'ssp_SCWebGetImageRecordsByImageRecordId') + '*****'
            + convert(varchar, error_line()) + '*****'
            + convert(varchar, error_severity()) + '*****'
            + convert(varchar, error_state())
        raiserror
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );
    end catch
end
GO