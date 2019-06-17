/****** Object:  StoredProcedure [dbo].[ssp_GetClinicianForService]    Script Date: 11/30/2018 2:44:17 PM ******/
if object_id('dbo.ssp_GetClinicianForService') is not null 
DROP PROCEDURE [dbo].[ssp_GetClinicianForService]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClinicianForService]    Script Date: 11/30/2018 2:44:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  
  
      
CREATE PROCEDURE [dbo].[ssp_GetClinicianForService] 
 -- Add the parameters for the stored procedure here                
    @ClientId int,  
    @DateOfService datetime = null,  
    @ProgramId int,  
    @AttendingId int,  
    @ProcedureCodeId int,  
    @LocationId int,  
    @PlaceOfServiceId int,  
    @ClinicianId int  
as   
begin               
/*********************************************************************/                                                                                      
 /* Stored Procedure: [ssp_GetClinicianForService]              */                                                                             
 /* Creation Date:  2/August/2011                                     */                                                                                      
 /* Purpose: To get The Data In Procedure Table For Service            */                                                                                    
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,               
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */                
  /* Output Parameters:   */          
  /*Returns The Table of Staff  */                                                                                      
 /* Called By:                                                       */                                                                            
 /* Data Modifications:                                              */                                                                                      
 /*   Updates:                                                       */                                                                                      
 /*   Date               Author                                       */                                                                                      
 /*   2/August/2011      Minakshi      Created                       */      
 /*   19/August/2011     Damanpreet    Modified                        */ 
 /*   12/Feb/2016		 Chethan N	   Converted to Core				*/		
 /*  11/30/2018          BFagaly    Added nonstaffuser check as clients were showing in drop down   */                                                                                   
 /********************************************************************/                   
    begin try                
        begin                
            select  S.StaffId as ClinicianId,  
                    S.LastName + ', ' + S.FirstName as ClinicianName,  
                    -1 as ProgramId,  
                    '' as ProgramName,  
                    -1 as LocationId,  
                    '' as LocationName,  
                    -1 as ProcedureCodeId,  
                    '' as ProcedureCodeName,  
                    -1 as AttendingId,  
                    '' as AttendingName  
            from    Staff S  
            where   (Active = 'Y' and ISNULL(nonstaffuser,'N')<>'Y' and ISNULL(S.RecordDeleted, 'N') <> 'Y')  
            or (s.StaffId = @ClinicianId)  
			
        end              
    end try                
    begin catch                                                                                           
        declare @Error varchar(8000)                                                               
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
                     'csp_GetAttendingForService') + '*****'  
            + CONVERT(varchar, ERROR_LINE()) + '*****'  
            + CONVERT(varchar, ERROR_SEVERITY()) + '*****'  
            + CONVERT(varchar, ERROR_STATE())                                                                                            
        raiserror                                                                                             
  (                    
   @Error, -- Message text.                                                                                            
   16, -- Severity.                                                                        
   1 -- State.                                                                                            
  ) ;                                                                                            
    end catch                  
end   
  
  

GO


