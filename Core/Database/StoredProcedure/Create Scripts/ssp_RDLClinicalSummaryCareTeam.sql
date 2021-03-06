/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryCareTeam]    Script Date: 06/09/2015 04:09:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryCareTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryCareTeam]
GO


/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryCareTeam]    Script Date: 06/19/2015 10:50:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryCareTeam] --null,197086,null  
 @ServiceId INT = NULL  
 ,@ClientId INT  
 ,@DocumentVersionId INT = NULL  
 /******************************************************************************                        
**  File: ssp_RDLClinicalSummaryCareTeam.sql      
**  Name: ssp_RDLClinicalSummaryCareTeam       
**  Desc:       
**                        
**  Return values: <Return Values>                       
**                         
**  Called by: <Code file that calls>                          
**                                      
**  Parameters:                        
**  Input   Output                        
**  Serviceid      -----------                        
**                        
**  Created By: Veena S Mani     
**  Date:  Apr 26 2014      
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:  Author:    Description:                        
**  --------  --------    -------------------------------------------        
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18              
**  019/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.                    
**  02/03/2016   Ravichandra		what: format  PhoneNumber like (XXX) XXX-XXXX  
									why: Meaningful Use Stage 2 Tasks#48 Clinial Summary - PDF Issues   
*******************************************************************************/  
AS  
BEGIN  
 SET NOCOUNT ON;  
  
 BEGIN TRY  
  DECLARE @Clinican INT = NULL  
  DECLARE @Physician INT = NULL  
  
  SELECT @Clinican = PrimaryClinicianId  
   ,@Physician = PrimaryPhysicianId  
  FROM Clients  
  WHERE Clientid = @ClientId  
  
  IF (  
    @Clinican IS NOT NULL  
    OR @Physician IS NOT NULL  
    )    
  BEGIN  
   SELECT SS.LastName + ', ' + SS.FirstName AS PrimaryPhysician 
   ,CASE WHEN ISNULL(SS.PhoneNumber,'') <> ''  
   THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(SS.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')' -- 02/03/2016  Ravichandra 
    + ' ' 
    + SUBSTRING(REPLACE(REPLACE(REPLACE(SS.PhoneNumber, '(', ''), ')', ''), '-', ''), 4, 3)  
    + '-' 
    + SUBSTRING(REPLACE(REPLACE(REPLACE(SS.PhoneNumber, '(', ''), ')', ''), '-', ''), 7, 4)  
    ELSE ''
    END AS PhysicianPhone	
    ,SS.addressDisplay AS PhysicianaddressDisplay  
    ,SSS.LastName + ', ' + SSS.FirstName AS PrimaryClinician 
     
     ,CASE WHEN ISNULL(SSS.PhoneNumber,'') <> '' 
     THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(SSS.PhoneNumber, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')' -- 02/03/2016  Ravichandra 
    + ' ' 
    + SUBSTRING(REPLACE(REPLACE(REPLACE(SSS.PhoneNumber, '(', ''), ')', ''), '-', ''), 4, 3)  
    + '-' 
    + SUBSTRING(REPLACE(REPLACE(REPLACE(SSS.PhoneNumber, '(', ''), ')', ''), '-', ''), 7, 4)
    ELSE ''
    END  AS ClinicianPhone	   
    ,SSS.addressDisplay AS ClinicianaddressDisplay  
   FROM Clients C  
   LEFT JOIN staff SSS ON SSS.StaffId = C.PrimaryClinicianId  
   LEFT JOIN staff SS ON SS.StaffId = C.PrimaryPhysicianId  
   WHERE C.ClientId = @ClientId  
  END  
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryCareTeam') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                     
    16  
    ,-- Severity.                                                            
    1 -- State.             
    );  
 END CATCH  
END 
GO
