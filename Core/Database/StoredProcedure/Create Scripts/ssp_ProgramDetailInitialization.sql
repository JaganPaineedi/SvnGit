IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[ssp_ProgramDetailInitialization]')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE [ssp_ProgramDetailInitialization];
    END;
                    
SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[ssp_ProgramDetailInitialization]
    @StaffId INT
  , @ClientID INT
  , @CustomParameters XML
AS
    BEGIN                                                                      
 /*********************************************************************                                                                        
 * Stored Procedure: [ssp_ProgramDetailInitialization]                                                                             
 * Creation Date:  04/04/2012                                                                                                         
 * Creation By : Shruthi.S                                                                                                                                        
 * Purpose: To Initialize                                                                       
 *                                                                                                                                        
 * Input Parameters:                                                                       
 *                                                                                                                                           
 * Output Parameters:                                                                                                      
 *                                                                                                                                          
 * Return:                                                                         
 *                                                                                                                                          
 * Called By:CustomDocuments Class Of DataService                                                                
 *                                                                                                                           
 *                                                                                                               
 * Calls:                                                                                                        
 *                                                                                                               
 * Data Modifications:                                                                                           
 *                                                                                                               
 *   Updates:                                                                                                                                                        
 *   Date       Author      Purpose                                                                                
 *  09/13/2013	Jagan		Added 3 new Columns--
 *  04/20/2017  jcarlson	Keystone Customizations 55 - Added logic to handle changes to ProgramProcedures table
  ********************************************************************/                                                                  
             
             
   --Programs by ProgramID    
        SELECT  'Programs' AS TableName, -1 AS [ProgramId], p.[CreatedBy], p.[CreatedDate], p.[ModifiedBy], p.[ModifiedDate], [RecordDeleted], [DeletedDate],
                [DeletedBy], '' AS [ProgramCode], '' AS [ProgramName], 'Y' AS [Active], 'N' AS [CanNotBePrimaryAssignment], [ProgramType], [IntakePhone],
                [IntakePhoneText], [ProgramManager], [Capacity], [Comment], [Address], [City], [State], [ZipCode], [AddressDisplay], [NationalProviderId],
                [InpatientProgram], [ServiceAreaId], [ResidentialProgram], [AfterSchoolProgram], [ShowInWhiteBoard]
        FROM    SystemConfigurations s
        LEFT OUTER JOIN [Programs] p ON s.DatabaseVersion = -1;   
		
	
       
        DECLARE @ProgramProcedureId INT;
        SELECT  @ProgramProcedureId = ( MAX(ProcedureCodeId) + 10000 )
        FROM    ProgramProcedures;
       
        SELECT  'ProgramProcedures' AS TableName, CAST(PC.ProcedureCodeId AS VARCHAR(8)) + ' - ' + PC.DisplayAs AS ProcedureCodeName,
                CAST(( ISNULL(@ProgramProcedureId, 99999999) + ( ROW_NUMBER() OVER ( ORDER BY PC.ProcedureCodeId ) ) ) AS INT) AS [ProgramProcedureId],
                -1 AS [ProgramId], PC.ProcedureCodeId AS [ProcedureCodeId], 'Y' AS AllowAllPrograms
        FROM    ProcedureCodes PC
        WHERE   ISNULL(PC.RecordDeleted, 'N') = 'N'
                AND ISNULL(PC.AllowAllPrograms, 'N') = 'Y'; 
  
    END;                                      
                                        
--Checking For Errors           
    IF ( @@error != 0 )
        BEGIN                           
            RAISERROR ('[ssp_ProgramDetailInitialization] : An Error Occured',16,1);               
            RETURN;                         
        END;


GO

