

/****** Object:  View [dbo].[ViewMUStaffExclusionDateRange]    Script Date: 04/17/2018 20:20:22 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUStaffExclusionDateRange]'))
DROP VIEW [dbo].[ViewMUStaffExclusionDateRange]
GO



/****** Object:  View [dbo].[ViewMUStaffExclusionDateRange]    Script Date: 04/17/2018 20:20:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE view [dbo].[ViewMUStaffExclusionDateRange] as      
/********************************************************************************      
-- View: dbo.ViewMUStaffExclusionDateRange        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns all Electronic Prescriptions   
-- Updates:                                                             
-- Date        Author      Purpose      
-- 10-Oct-2017  Gautam  What:view for Report to display staff exclusion                             
--       Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports        
*********************************************************************************/  
 SELECT MFU.MeasureType  
   ,MFU.MeasureSubType  
   ,CAST(MFP.ProviderExclusionFromDate AS DATE) as ProviderExclusionFromDate  
   ,MFP.StaffId  
   ,CAST(MFP.ProviderExclusionToDate AS DATE) as ProviderExclusionToDate  
   ,MFU.Stage  
  FROM MeaningFulUseProviderExclusions MFP  
  INNER JOIN MeaningFulUseDetails MFU ON MFP.MeaningFulUseDetailId = MFU.MeaningFulUseDetailId  
   AND ISNULL(MFP.RecordDeleted, 'N') = 'N'  
   AND ISNULL(MFU.RecordDeleted, 'N') = 'N'
GO


