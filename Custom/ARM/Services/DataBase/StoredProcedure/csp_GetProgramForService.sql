/****** Object:  StoredProcedure [dbo].[csp_GetProgramForService]    Script Date: 02/03/2014 19:59:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetProgramForService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetProgramForService]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetProgramForService]    Script Date: 02/03/2014 19:59:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
    
CREATE PROCEDURE [dbo].[csp_GetProgramForService]               
 -- Add the parameters for the stored procedure here              
 @ClientId int,             
 @DateOfService DateTime = null,             
 @ProgramId int,             
 @AttendingId int,             
 @ProcedureCodeId int,             
 @LocationId int,             
 @PlaceOfServiceId int,  
 @ClinicianId int             
AS              
BEGIN             
/*********************************************************************/                                                                                      
 /* Stored Procedure: [csp_GetProgramForService]                         */                                                                             
 /* Creation Date:  2/August/2011                                     */                                                                                      
 /* Purpose: To get The Data  For Service            */                                                                                    
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,               
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */                
  /* Output Parameters:   Returns The Table of Program */                                                                                      
 /* Called By:                                                       */                                                                            
 /* Data Modifications:                                              */                                                                                      
 /*   Updates:                                                       */                                                                                      
 /*   Date              Author                                       */                                                                                      
 /*   3/August/2011     Minakshi    Created                       */        
 /*   19/August/2011     Damanpreet    Modified                        */
 /*	  03/Feb/2014		Rohith		ProgramCode Column added and committed to SVN		*/
 /*	  10/April/2014		Rohith		Reverting 1364-Core changes & committing the original Production Copy	*/                                                                                       
 /********************************************************************/               
BEGIN TRY              
  BEGIN             
  
 select    
  -1 AS AttendingId, '' AS AttendingName,      
  P.ProgramId,P.ProgramName,      
 -1 AS LocationId,'' AS LocationName,       
 -1 as ProcedureCodeId,   
 '' AS ProcedureCodeName, -1 AS ClinicianId, '' AS ClinicianName   
 from  Programs P  
 where   
 (  
  P.Active = 'Y'  
  and ISNULL(P.RecordDeleted, 'N') <> 'Y'  
  and (  
   (@ClinicianId <= 0)  
   or exists (select * from dbo.StaffPrograms as sp where sp.StaffId = @ClinicianId and sp.ProgramId = P.ProgramId and ISNULL(sp.RecordDeleted, 'N') <> 'Y')  
  )  
 )  
 or (P.ProgramId = @ProgramId)  
  order by P.ProgramName  
       
 END            
 END TRY              
BEGIN CATCH                                                                                         
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetProgramForService')                                                                                           
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


