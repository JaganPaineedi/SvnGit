/****** Object:  StoredProcedure [dbo].[ssp_GetPatientAdmitDate]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPatientAdmitDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPatientAdmitDate]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPatientAdmitDate]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE  PROCEDURE [dbo].[ssp_GetPatientAdmitDate]        
/*********************************************************************************/        
-- Copyright: Streamline Healthcate Solutions        
--        
--        
-- Author:  Vaibhav        
-- Date:    19 Sep 2018           
-- Purpose: Created SP to fetch Patient Name          
        
/*********************************************************************************/        
        
       
 @ClientId INT,    
 @DocumentId INT ,    
 @EffectiveDate DATETIME    
         
AS        
BEGIN         
        
      DECLARE @Result VARCHAR(20)=''  
 Select  @Result=CONVERT(VARCHAR(20),AdmitDate, 103)    
      from ClientInpatientVisits where clientId=@ClientId Order by 1        
       
   SELECT CASE @Result when '' THEN '<span style=''color:black''><b> &nbsp;&nbsp;No Inpatient Record Found</b></span>' ELSE  '<span style=''color:black''>&nbsp;&nbsp;'+@Result+ '</span>'  END      
END     
    
    
    
    
    
 GO 