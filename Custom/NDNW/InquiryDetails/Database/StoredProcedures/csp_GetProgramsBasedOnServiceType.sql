IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetProgramsBasedOnServiceType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetProgramsBasedOnServiceType]
GO
CREATE PROC [dbo].[csp_GetProgramsBasedOnServiceType]       
@ServiceType int      
as   
/*********************************************************************/                                                                                      
/* Stored Procedure: dbo.csp_GetProgramsBasedOnServiceType           */                                                                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                                      
/* Creation Date:    15-Dec-2011                                     */                                                                                      
/*                                                                   */                                                                                      
/* Purpose:Used in getdata for Disposition Control--Provider/Agency  */                                                                                     
/*                                                                   */                                                                                    
/* Input Parameters:     @ServiceId                                  */                                                                                    
/*                                                                   */                                                                                      
/* Output Parameters:   None                                         */                                                                                      
/*                                                                   */                                                                                      
/* Return: ProgramId, ProgramName                                    */                                                                                      
/*                                                                   */                                                                                      
/*  Date         Author                  Purpose                     */                                                                                      
/* 15/Dec/2011   Himansu Chetal          Created                     */                    
/* 06/Jan/2012   Sudhir Singh            Updated                     */    
/*********************************************************************/      
begin   
BEGIN TRY   
 select Programs.ProgramId, Programs.ProgramName from [CustomServiceTypePrograms] inner join       
 Programs on Programs.ProgramId=[CustomServiceTypePrograms].ProgramId      
 where [CustomServiceTypePrograms].ServiceType=@ServiceType and isNull(Programs.RecordDeleted,'N')<>'Y'   
  
END TRY                                                          
 BEGIN CATCH                                       
 DECLARE @Error varchar(8000)                                                                                        
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetProgramsBasedOnServiceType')                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                          
    + '*****' + Convert(varchar,ERROR_STATE())                                                                                        
                                                                                       
    RAISERROR                                                                                         
    (                                                                              
  @Error, -- Message text.                                                                        
  16, -- Severity.                                                                                        
  1 -- State.                                                                                        
    );                                                                         
 End CATCH           
end  
  