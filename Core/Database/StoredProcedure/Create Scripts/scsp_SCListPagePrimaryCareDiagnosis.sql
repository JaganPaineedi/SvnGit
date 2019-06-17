/****** Object:  StoredProcedure [dbo].[scsp__SCListPagePrimaryCareDiagnosis]    Script Date: 02/21/2014 16:00:15 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[scsp__SCListPagePrimaryCareDiagnosis]')
  AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[scsp__SCListPagePrimaryCareDiagnosis]
GO

/****** Object:  StoredProcedure [dbo].[scsp__SCListPagePrimaryCareDiagnosis]    Script Date: 02/21/2014 16:00:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[scsp__SCListPagePrimaryCareDiagnosis] 
@ClientID INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@ICD9 VARCHAR(100)
	,@ICD10 VARCHAR(100)
	,@SNOMED VARCHAR(100)
	,@Description VARCHAR(1000)
	,@SNOMEDDescription VARCHAR(100)
	,@OtherFilter INT

/********************************************************************************    
** Stored Procedure: dbo.scsp__SCListPagePrimaryCareDiagnosis      
    
** Copyright: Streamline Healthcate Solutions    
    
** Purpose: used by Primary Care Appointments List page.   
** Called by: scsp__SCListPagePrimaryCareDiagnosis    
    
** Updates:                                                           
** Date    		Author			Purpose    
** 06 Mar 2014	Chethan N     Created.          
   
*********************************************************************************/

AS
  SELECT
    -1
  RETURN