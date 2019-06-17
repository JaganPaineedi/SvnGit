/****** Object:  StoredProcedure [dbo].[csp_GetProcedureCodesForService]    Script Date: 10/29/2015 19:33:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetProcedureCodesForService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetProcedureCodesForService]
GO

/****** Object:  StoredProcedure [dbo].[csp_GetProcedureCodesForService]    Script Date: 10/29/2015 19:33:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[csp_GetProcedureCodesForService]                   
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
 /* Stored Procedure: [csp_GetProcedureCodesForService]              */                                                                               
 /* Creation Date:  2/August/2011                                     */                                                                                        
 /* Purpose: To get The Data In Procedure Table For Service            */                                                                                      
 /* Input Parameters:@ClientId, @DateOfService, @ProgramId, @ClinicianId,                 
      @ProcedureCodeId, @LocationId, @PlaceOfServiceId  */                  
  /* Output Parameters:   */            
  /*Returns The Table of ProcedureCode with Columns LocationName and LocationId */                                                                                        
 /* Called By:                                                       */                                                                              
 /* Data Modifications:                                              */                                                                                        
 /*   Updates:                                                       */                                                                                        
 /*   Date               Author                                       */                                                                                        
 /*   2/August/2011      Minakshi      Created                       */            
 /*   19/August/2011     Damanpreet    Modified                        */                                                                                      
 /********************************************************************/                     
    begin try                  
        begin                  
            select  -1 as AttendingId,  
                    '' as AttendingName,  
                    -1 as ProgramId,  
                    '' as ProgramName,  
                    -1 as LocationId,  
                    '' as LocationName,  
                    PC.ProcedureCodeId,  
                    PC.DisplayAs as ProcedureCodeName,  
                    -1 as ClinicianId,  
                    '' as ClinicianName  
            from    ProcedureCodes PC  
            where   (  
                     pc.Active = 'Y'  
                     and ISNULL(pc.RecordDeleted, 'N') <> 'Y'  
                     and (  
                          (ISNULL(@ClinicianId, -1) <= 0)  
                          or (exists ( select   *  
                                       from     dbo.StaffProcedures as sp  
                                       where    sp.ProcedureCodeId = pc.ProcedureCodeId  
                                                and sp.StaffId = @ClinicianId  
                                                and ISNULL(sp.RecordDeleted,  
                                                           'N') <> 'Y' ))  
                         )  
                    )  
                    --or (PC.ProcedureCodeId = @ProcedureCodeId)   
        end                
    end try                  
    begin catch                                                                                             
        declare @Error varchar(8000)                                                                 
        set @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****'  
            + CONVERT(varchar(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()),  
                     'csp_GetProcedureCodesForService') + '*****'  
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


