
/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFamily]    Script Date: 05/15/2013 18:10:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientFamily]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientFamily]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientFamily]    Script Date: 05/15/2013 18:10:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetClientFamily]
	@ClientId int
/*********************************************************************                                                                                          
-- Stored Procedure: dbo.ssp_SCGetClientInformation                                                                                                                             
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                           
-- Creation Date:    7/24/05                                                                                          
--                                                                                           
-- Purpose:  Return Tables for ClientInformations and fill the type Dataset                                                                                          
--                                                                                          
-- Updates:                                                                                          
--   Date       Author        Purpose 
-----------------------------------------------------------------------                                                                                         
--  23-05-2014  Vkhare       Added ClientDemographicInformationDeclines   table  
--  29-04-2015	PradeepA	 Added ClientPictures table
--  01 Sep 2015	Avi Goyal	 What : Added checked for recode category RELATIONFAMILY to fetch records for Family Tab
							 Why : Task # 907.1 Family Tab to Client Information Screen ; Project : Valley - Customizations
--21-DEC-2015   Basudev Sahu Modified For Task #609 Network180 Customization to restrict family information on family tab if									client is organisation  .
*************************************  ********************************/                                                                                                                               

AS
BEGIN
 BEGIN TRY 
SELECT 
	CC.LastName + ', ' + CC.FirstName AS FamilyContact
	,GC.CodeName AS Relation
	,(CASE 
		WHEN CC.Sex='M'
		THEN 'Male'
		WHEN CC.Sex='F'
		THEN 'Female'
		ELSE ''
	END) AS FamilySex
	,CONVERT(VARCHAR(10), CC.DOB, 101) AS FamilyDOB
	,CC.ClientId
	,(dbo.[GetAge]  (CC.DOB, GETDATE())) AS Age
	,CC.AssociatedClientId
FROM ClientContacts CC
INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=CC.Relationship AND ISNULL(GC.RecordDeleted,'N')='N' 			
WHERE (ISNULL(CC.RecordDeleted, 'N') <> 'Y')
	AND (CC.ClientId = @ClientId)
	-- Modified By Avi Goyal, on 01 Sep 2015
	AND EXISTS (
					SELECT 1 
					FROM Recodes R 
					INNER JOIN RecodeCategories RC ON RC.RecodeCategoryId=R.RecodeCategoryId AND RC.CategoryCode='RELATIONFAMILY' AND ISNULL(RC.RecordDeleted,'N')='N' 
					WHERE R.IntegerCodeId=CC.Relationship AND ISNULL(R.RecordDeleted,'N')='N' 
					 and Gc.GlobalCodeId not IN	(9355,9356)
				)
END TRY                                                      
                                                                                      
BEGIN CATCH          
        
DECLARE @Error varchar(8000)                                                       
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                     
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetClientFamily')                                                                                     
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


