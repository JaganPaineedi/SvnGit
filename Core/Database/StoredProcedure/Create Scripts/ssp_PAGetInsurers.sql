SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_PAGetInsurers]')
                    AND type IN (N'P', N'PC') ) 
    DROP PROCEDURE [dbo].[ssp_PAGetInsurers]
GO

      
        
         
CREATE PROCEDURE [dbo].[ssp_PAGetInsurers] (@LoggedInStaffId INT )
AS 

/*******************************************************************                            
 Stored Procedure: dbo.ssp_PAGetInsurers                                                         
 Copyright: 2007 Provider Access System                                                       
 Creation Date:  07/06/2007                                                                   
                                                                                               
 Purpose: shows insurer according to user selection                                        
                                                                                             
 Input Parameters: @Userid                                     
                                                                                               
 Output Parameters:                                                            
                                                                                               
 Return: Insurer  based on userid                             
                                                                                               
 Called By:                                                                                    
                                                                                               
 Calls:                                                                                        
                                                                                               
 Data Modifications:                                                                           
                                                                                               
 Updates:                                                                                      
  Date              Author                     Purpose                                                                
 07/06/2007        Sandeep Kumar Trivedi       Created                                          
 29/07/2011        priya                       Modified (Ref:task No:770)  
 02/07/2014        Aravind                     Modified for Task #59 - CM to SC  
 18-Aug-2014       Rohith Uppin                LoggedInStaff was hardcoded and now Passed as Paramater
 10-Dec-2014       Vichee Humane               Modified code to reterive data on the basis of  permissions 
                                               CareManagemet to SC Env Issues Tracking #168  
 10/03/2016        jwheeler                    Addedd SCSP Hook                                                                                             
*********************************************************************/                           
    BEGIN       
             
        IF EXISTS ( SELECT *
                        FROM sys.objects
                        WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PAGetInsurers]')
                            AND type IN ( N'P', N'PC' ) )
            BEGIN  
                DECLARE @SpName VARCHAR(255)
                SET @SpName = 'scsp_PAGetInsurers'
                EXEC @SpName @LoggedInStaffId
                RETURN  
            END

        DECLARE @AllStaffInsurer VARCHAR(1)  
        SELECT @AllStaffInsurer = AllInsurers
            FROM Staff
            WHERE StaffId = @LoggedInStaffId              
        BEGIN TRY   
            IF ( @AllStaffInsurer = 'Y' )
                BEGIN
                    SELECT C.InsurerId
                        ,   C.InsurerName
                        FROM Insurers C
                        WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
                            AND ISNULL(Active, 'N') = 'Y'
                            AND C.InsurerId > 0
                        ORDER BY InsurerName     
                END  
    
            ELSE
                BEGIN 
       
                    SELECT C.InsurerId
                        ,   I.InsurerName
                        FROM Contracts C
                            LEFT JOIN StaffInsurers SI ON C.InsurerId = SI.InsurerId
                            LEFT JOIN Providers P ON P.ProviderId = C.ProviderId
                            LEFT JOIN StaffProviders SP ON SP.StaffId = SI.StaffId
                                                           AND SP.ProviderId = P.ProviderId
                            LEFT JOIN Insurers I ON I.InsurerId = C.InsurerId
                        WHERE P.SubstanceUseProvider = 'Y'
                            AND SI.StaffId = @LoggedInStaffId
                            AND ISNULL(C.Status, 'I') = 'A'
                            AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(SI.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(P.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(SP.RecordDeleted, 'N') <> 'Y'
                            AND ISNULL(I.RecordDeleted, 'N') <> 'Y'
                        GROUP BY C.InsurerId
                        ,   I.InsurerName
                        ORDER BY C.InsurerId    
 
                END
        END TRY                                                                                            
        BEGIN CATCH                                                                              
            DECLARE @Error VARCHAR(8000)                                                                               
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PAGetInsurers') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())           
            RAISERROR                                                                    
   (                                                                
     @Error, -- Message text.                                                                                    
     16, -- Severity.                                                                                                                      
     1 -- State.                                                
    );                                                                                                                      
        END CATCH       
               
    END            
            



GO
