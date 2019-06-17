IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCGetActiveProcedureCodes')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCGetActiveProcedureCodes;
    END;
GO
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE dbo.ssp_SCGetActiveProcedureCodes 
@TeamId INT
AS
/**************************************************************                                                                                        
* Stored Procedure: [ssp_SCGetActiveProcedureCodes]	 13                                                                                    
* Creation Date:  20March2012                                                                                                                        
* Purpose: To Get Active ProcedureCodes					                                                                                         
* Input Parameters:   None									                                                                                        
* Output Parameters:										                                                                                          
* Return:													                                                                                          
* Called By: Core Team Scheduling Detail screen			                                                                                
* Calls:                                                                                                                                             
*                                                                                                                                                    
* Data Modifications:                                                                                                                                
* Updates:                                                                                                                                           
* Date			Author		Purpose							      
* 03/20/2012	Shifali		To get Active Procedures for a Program
* 05/15/2012	Shifali		Changed Table 'ProcedureCodePrograms' to ProgramProcedures
* 05/17/2012	Shifali		Added condition AND ISNULL(PC.GroupCode,'N')<>'Y' 
* 04/20/2017	jcarlson	Keystone Customizations 55 - Update logic to handle ProgramProcedure Updates
* 11/17/2017    kavya      Reverted  Keystone Customizations 55 changes .-Philhaven-Support #280
**************************************************************/  
BEGIN
BEGIN TRY

            SELECT  PC.ProcedureCodeId ,    
                    PC.DisplayAs AS ProcedureCodeName    
            FROM    ProgramProcedures PCP    
                    LEFT JOIN ProcedureCodes PC ON PCP.ProcedureCodeId = PC.ProcedureCodeId    
            WHERE   PCP.ProgramId = @TeamId    
                    AND PC.Active = 'Y'    
                    AND ISNULL(PCP.RecordDeleted, 'N') <> 'Y'    
                    AND ISNULL(PC.RecordDeleted, 'N') <> 'Y'    
                    AND ISNULL(PC.GroupCode, 'N') <> 'Y'    
            ORDER BY PC.ProcedureCodeName    
END TRY
BEGIN CATCH                            
DECLARE @Error varchar(8000)                                                                      
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetActiveProcedureCodes')                                                                                                       
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