-- =============================================  
-- Author:    Tom Remisoski 
-- Create date: Nov 14th, 2016 
-- Description: Cleanup leftover "deletedby" values.  

/* 
Modified Date    Modidifed By    Purpose 
14 Nov 2016	  T.Remisoski	   Core Bugs: Task# 2333 - Cleanup leftover "deletedby" values
*/ 
-- =============================================  

update icd set
    DeletedBy = null
from DiagnosisICD10Codes as icd
where isnull(icd.RecordDeleted, 'N') = 'N'
and icd.DeletedBy is not null
