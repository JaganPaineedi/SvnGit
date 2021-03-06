/****** Object:  StoredProcedure [dbo].[csp_PAGetDataForASAM]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetDataForASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PAGetDataForASAM]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PAGetDataForASAM]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE  [dbo].[csp_PAGetDataForASAM]                      
(                                
  @DocumentVersionId int                                 
)                                
                                
As                                
                                        
Begin                                        
/*********************************************************************/                                          
/* Stored Procedure: dbo.csp_PAGetDataForASAM                */                                 
                                
/* Copyright: 2009 Streamline Healthcare Solutions           */                                          
                                
/* Creation Date:  04 Feb 2010                                   */                                          
/*                                                                   */               
/*  Author: Jitender Kumar                                                                 */               
/*                                                                   */                                          
/* Purpose: Gets Data for ASAM Multi Tab Document      */                                         
/*                                                                   */                                        
/* Input Parameters: @DocumentVersionId*/                                        
/*                                                                   */                                           
/* Output Parameters:                                */                                          
/*                                                                   */                                          
/* Return:   */                                          
/*                                                                   */                                          
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                                          
                                
                                       
                                      
 BEGIN TRY                                                     
  -----For CustomDocumentEventInformation-----
----------Added By SWAPAN MOHAN-------------
----------ADDED ON 28 dec 2012--------------
 SELECT [DocumentVersionId]
  ,[CreatedBy]
  ,[CreatedDate]
  ,[ModifiedBy]
  ,[ModifiedDate]
  ,[RecordDeleted]
  ,[DeletedDate]
  ,[DeletedBy]
  ,[EventDateTime]
  ,[InsurerId]
 FROM CustomDocumentEventInformations
 WHERE [DocumentVersionId]=@DocumentVersionId
 AND ISNULL(RecordDeleted,''N'')=''N''
              
 /*CustomASAMPlacements Table*/              
 SELECT [DocumentVersionId],         
  [Dimension1LevelOfCare],           
  [Dimension1Need],              
  [Dimension2LevelOfCare],              
  [Dimension2Need],                              
  [Dimension3LevelOfCare],               
  [Dimension3Need],              
  [Dimension4LevelOfCare],              
  [Dimension4Need],                 
  [Dimension5LevelOfCare],              
  [Dimension5Need],              
  [Dimension6LevelOfCare],              
  [Dimension6Need],              
  [SuggestedPlacement],              
  [FinalPlacement],              
  [FinalPlacementComment],              
  [RowIdentifier],                              
  [CreatedBy],                              
  [CreatedDate],                              
  [ModifiedBy],                              
  [ModifiedDate],                              
  [RecordDeleted],                              
  [DeletedDate],                     
  [DeletedBy],          
            
  isnull((select top 1 LevelOfCareName from CustomASAMLevelOfCares  A ,CustomASAMPlacements B             
 where  (ASAMLevelOfcareId =    Dimension1LevelOfCare or                 
 ASAMLevelOfcareId = Dimension2LevelOfCare or ASAMLevelOfcareId = Dimension3LevelOfCare ) and                 
 isnull(A.RecordDeleted,''N'')=''N'' and isnull(B.RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId order by LevelNumber  desc),'''')  AS SuggestedPlacementName,        
         
 (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension1LevelOfCare,'''') ) as Dimension1LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension2LevelOfCare,'''') ) as Dimension2LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension3LevelOfCare,'''') ) as Dimension3LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension4LevelOfCare,'''') ) as Dimension4LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension5LevelOfCare,'''') ) as Dimension5LevelOfCareName,        
  (select LevelOfCareName from CustomASAMLevelOfCares   where isnull(RecordDeleted,''N'')=''N''             
  and ASAMLevelOfCareId = isnull(Dimension6LevelOfCare,'''') ) as Dimension6LevelOfCareName                              
                    
 FROM [CustomASAMPlacements]                        
    WHERE ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId=@DocumentVersionId                
                     
                         
  END TRY                              
                                
  BEGIN CATCH                                                    
  DECLARE @Error varchar(8000)                                                                                       
  set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                      
  + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_PAGetDataForASAM'')                                                                                       
  + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                                                      
  + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())             
  RAISERROR                                                                                       
  (                                                 
  @Error, -- Message text.                                                                                       
  16, -- Severity.                                                                                       
  1 -- State.                                                                                       
  )                                    
 END CATCH                              
End 

' 
END
GO
