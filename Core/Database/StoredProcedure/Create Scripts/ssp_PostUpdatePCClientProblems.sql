

/****** Object:  StoredProcedure [dbo].[csp_PostUpdatePCClientProblems]    Script Date: 08/28/2012 17:54:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdatePCClientProblems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdatePCClientProblems]
GO


/****** Object:  StoredProcedure [dbo].[ssp_PostUpdatePCClientProblems]    Script Date: 08/28/2012 17:54:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_PostUpdatePCClientProblems] 
  @ScreenKeyId int,                                                                
  @StaffId int,                                                                
  @CurrentUser varchar(30),                                
  @CustomParameters xml   
as          
/**********************************************************************/                                                                                          
 /* Stored Procedure:  ssp_PostUpdatePCClientProblems  */                                                                                 
 /* Creation Date:  03/Feb/2012                                    */                                                                                          
 /* Purpose: To Validate MHA on Sign             */                                                                                         
 /* Input Parameters:   @CurrentUserId ,@ScreenKeyId         */                                                                                        
 /* Output Parameters:                 */                                                                                          
 /* Return:                 */                                                                                          
 /* Called By: MHA conslidated tab in  Mental Health Assessment     */                                                                                
 /* Calls:                                                            */                                                                                          
 /*                                                                   */                                                                                          
 /* Data Modifications:                                               */                                                                                          
 /* Updates:                                                          */                                                                                          
 /* Date            Author           Purpose           */      
  /*30 oct 2012          Vishant Garg                Replace DiagnosisDSMDescription with DiagnosisicdCodes */
  /*7 jan 2013           Vishant Garg                Change whole logic with ref task#54 primary care*/
  --03 Sep  2015  vkhare			Modified for ICD10 changes

 /*********************************************************************/                                                         
          
Begin                                                        
Begin try

	Declare @ClientId int
    Create table #temp (ClientProblemId int)
    Insert into #temp select * from [fnSplit] ( @CustomParameters.value ('(/Root/Parameters/@ClientProblemId)[1]', 'varchar(max)'),',')	
	select @ClientId=ClientId from ClientProblems as cp where  exists  (select top 1 ClientProblemId from #temp ) AND  ISNULL(cp.RecordDeleted,'N')='N'
	--Select @DSMCode=DSMCode,  @ClientId=ClientId  from ClientProblems where ClientProblemId=@ScreenKeyId and ISNULL(IncludeInCommonList,'N')='Y'
	
	--if(@DSMCode is not null)
	--Begin
	--if not exists(Select 1 from ClientCommonProblems where DSMCode=@DSMCode and ClientId=@ClientId and  isnull(RecordDeleted,'N')='N')
	--begin
	--	Insert into ClientCommonProblems
	--	(
	--		CreatedBy,
	--		CreatedDate,
	--		ModifiedBy,
	--		ModifiedDate,
	--		DSMCode,
	--		DSMNumber,
	--		Axis,
	--		ClientId
	--	)
	--	values
	--	(
	--		@CurrentUser,
	--		GETDATE(),
	--		@CurrentUser,
	--		GETDATE(),
	--		@DSMCode,
	--		0,
	--		0,
	--		@ClientId
	--	)	
	--End
	--End
	Insert into ClientCommonProblems  
  (  
   CreatedBy,  
   CreatedDate,  
   ModifiedBy,  
   ModifiedDate,  
   DSMCode,  
   DSMNumber,  
   Axis,  
   ClientId,
   ICD10CodeId,
   SNOMEDCODE,
   ICD10Code 
  )  
  select
   @CurrentUser,  
   GETDATE(),  
   @CurrentUser,
   GETDATE(),  
   cp.DSMCode,
   0,
   0,
   @ClientId,
   ICD10CodeId,
   SNOMEDCODE,
   ICD10Code
   from ClientProblems cp
   inner join #temp t on cp.ClientProblemId=t.ClientProblemId
   where isnull(cp.IncludeInCommonList,'N')='Y'
   and cp.ClientId=@ClientId
   and Not exists 
   (select 1 from ClientCommonProblems ccp where  cp.ICD10CodeId=ccp.ICD10CodeId and cp.ClientId=ccp.ClientId
   and ISNULL(cp.RecordDeleted,'N')='N'
   and ISNULL(ccp.RecordDeleted,'N')='N')
   
   drop table #temp
END TRY                                                        
BEGIN CATCH            
          
DECLARE @Error varchar(8000)                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PostUpdatePCClientProblems')                                                                                       
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


