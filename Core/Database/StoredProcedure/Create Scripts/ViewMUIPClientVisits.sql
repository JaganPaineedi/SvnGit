
/****** Object:  View [dbo].[ViewMUIPClientVisits]    Script Date: 04/11/2018 19:07:42 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUIPClientVisits]'))
DROP VIEW [dbo].[ViewMUIPClientVisits]
GO


/****** Object:  View [dbo].[ViewMUIPClientVisits]    Script Date: 04/11/2018 19:07:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
   
CREATE view [dbo].[ViewMUIPClientVisits] as          
/********************************************************************************          
-- View: dbo.ViewClientServices            
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: returns all Client IP visits    
-- Updates:                                                                 
-- Date        Author      Purpose          
-- 21.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports             
*********************************************************************************/      
      
 SELECT S.ClinicianId,    
 S.ClientId,     
 cast(S.AdmitDate AS DATE) as AdmitDate,   
 S.DischargedDate ,    
  RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  ,     
   C.PrimaryClinicianId as AssignedStaffId                                               
       FROM dbo.ClientInpatientVisits S                                        
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                        
        AND ISNULL(C.RecordDeleted, 'N') = 'N'                                        
       INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType       
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                          
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                          
         AND CP.ClientId = S.ClientId                                           
       WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                              
        AND isnull(S.RecordDeleted, 'N') = 'N'                                        
                                          
  
GO


