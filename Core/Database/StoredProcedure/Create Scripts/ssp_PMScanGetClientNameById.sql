/****** Object:  StoredProcedure [dbo].[ssp_PMScanGetClientNameById]    Script Date: 11/18/2011 16:25:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMScanGetClientNameById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMScanGetClientNameById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMScanGetClientNameById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_PMScanGetClientNameById]       
  @ClientId int   
AS      
    
/******************************************************************************                
**  File: MedicalRecordsScanningDetails.cs                
**  Name: ssp_PMScanGetClientNameById                
**  Desc: Get clien name against client id  
**                
**  This template can be customized:                
**                              
**  Return values:                
**                 
**  Called by:                   
**                              
**  Parameters:                
**  Input       Output                
**     ----------       -----------                
**                
**  Auth: Rohit Verma             
**  Date: 03 Nov 2008                
*******************************************************************************                
**  Change History                
*******************************************************************************                
**  Date:  Author:    Description:                
**  --------  --------    -------------------------------------------                
** 19 Oct 2015			Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
**										why:task #609, Network180 Customization                   
*******************************************************************************/        
    
BEGIN      
  
  Select  CASE 
			WHEN ISNULL(ClientType, ''I'') = ''I'' then rtrim(ISNULL(LastName,'''')) + '', '' + rtrim(ISNULL(FirstName,'''')) ELSE  OrganizationName END from Clients where ClientId=@ClientId    
              and ISNULL(RecordDeleted, ''N'') = ''N''  
  
 IF (@@error!=0)      
     BEGIN      
           RAISERROR  20002 ''ssp_PMScanGetClientNameById: An Error Occured''         
     END   
  
END    
  
' 
END
GO
