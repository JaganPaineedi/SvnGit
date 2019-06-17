/****** Object:  StoredProcedure [dbo].[csp_RDLGetBillingModifierDropdown]    Script Date: 11/11/2013 10:13:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLGetBillingModifierDropdown]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].csp_RDLGetBillingModifierDropdown
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLGetBillingModifierDropdown]    Script Date: 11/11/2013 10:13:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].csp_RDLGetBillingModifierDropdown

AS

/************************************************************************/                    
/* Stored Procedure: dbo.[csp_RDLGetBillingModifierDropdown]           */                    
/* Copyright: 2017 Streamline Healthcare Solutions,  LLC                */                    
/* Creation Date:    04/06/2017                                         */                    
/*                                                                      */                    
/* Purpose: Generate Report to List ClaimLines based on Selection       */
/*			Criteria in the Filter and Update Charge and Claimed Amount	*/                    
/*                                                                      */                                    
/*                                                                      */                                                                                                                 
/* Data Modifications:                                                  */                    
/*                                                                      */                    
/*                                                                      */                    
/*  Date        Author              Purpose                             */                    
/*	04/06/2017  Robert Caffrey      Creation                            */
/*                                                                      */
/************************************************************************/


CREATE TABLE #MyBillingCodes
(Id INT IDENTITY (1,1),
BillingCodeId INT,
BillingCode VARCHAR(Max),
Modifier1 VARCHAR(Max),
Modifier2 VARCHAR(Max),
Modifier3 VARCHAR(Max),
Modifier4 VARCHAR(Max),
Label VARCHAR(Max)
)

INSERT INTO #MyBillingCodes
        ( BillingCodeId,
		  BillingCode,
          Modifier1 ,
          Modifier2 ,
          Modifier3 ,
          Modifier4 ,
          Label
        )
SELECT DISTINCT bc.BillingCodeId, bc.BillingCode , bcm.Modifier1 , bcm.Modifier2 , bcm.Modifier3 , bcm.Modifier4, ISNULL(bc.BillingCode, 'ErrorSA')   
FROM      dbo.BillingCodes         bc 
 JOIN dbo.BillingCodeModifiers bcm ON bcm.BillingCodeId = bc.BillingCodeId
		AND ISNULL(bcm.RecordDeleted,
		'N') <> 'Y'
WHERE bc.Active = 'Y'
AND ISNULL(bc.RecordDeleted, 'N') <> 'Y'
ORDER BY bc.BillingCodeId, bc.BillingCode , bcm.Modifier1 , bcm.Modifier2 , bcm.Modifier3 , bcm.Modifier4

UPDATE b SET b.Label = Label + ISNULL(' - ' + Modifier1, '') + ISNULL(':' + Modifier2, '') + ISNULL(':' + Modifier3, '') + ISNULL(':' + Modifier4, '') 
FROM #MyBillingCodes b 

SELECT * FROM #MyBillingCodes ORDER BY BillingCode

DROP TABLE #MyBillingCodes
GO

RETURN


EXEC dbo.csp_RDLGetBillingModifierDropdown




