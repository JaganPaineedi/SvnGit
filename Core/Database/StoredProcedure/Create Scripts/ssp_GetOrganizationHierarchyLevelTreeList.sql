IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_GetOrganizationHierarchyLevelTreeList]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_GetOrganizationHierarchyLevelTreeList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetOrganizationHierarchyLevelTreeList]    Script Date: 07/06/2017******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure ssp_GetOrganizationHierarchyLevelTreeList

As

BEGIN                                                              
BEGIN TRY 

SELECT OL.OrganizationLevelId,(Case isnull(OL.ProgramId,0) when  0 then isnull(+OL.LevelName,'') else +P.ProgramName end)+' ('+OLT.LevelTypeName+')' +  Case when OL.ManagerId IS NOT NULL THEN ' - Manager: '+ISNULL(Staff.LastName+', ','')+ISNULL(Staff.FirstName,'') else '' END as LevelName,OL.ParentLevelId    
,P.ProgramId FROM OrganizationLevels OL  
 INNER JOIN OrganizationLevelTypes OLT ON  OLT.LevelTypeId=OL.LevelTypeId   
    LEFT JOIN Programs  P ON  P.ProgramId=OL.ProgramId left join Staff on OL.ManagerId=Staff.StaffId      
 WHERE   
 ISNULL(OL.RecordDeleted,'N') = 'N'  and
 ISNULL(OLT.RecordDeleted,'N') = 'N'     
 order by OL.ParentLevelId  
 
	

END TRY
--Checking For Errors  

BEGIN CATCH     
If (@@error!=0)           
  Begin            
	  RAISERROR  (  'ssp_GetOrganizationLevelTreeList: An Error Occured'               ,16,1)
	  Return            
  End 
        
END CATCH
END          
     
GO
