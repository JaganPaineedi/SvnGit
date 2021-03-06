/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDDStateReporting]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDDStateReporting]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDDStateReporting]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDDStateReporting]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'          
CREATE PROCEDURE  [dbo].[csp_RDLCustomDDStateReporting]       
                          
  (           
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010     
)                          
As                          
                                  
Begin                                  
/************************************************************************/                                    
/* Stored Procedure: [csp_RDLCustomDDStateReporting]    */                           
/* Copyright: 2006 Streamline SmartCare         */                                    
/* Creation Date:  April 1, 2011           */                                    
/*                  */                                    
/* Purpose: Gets Data for RDLCustomDDStateReporting      */                                   
/*                  */                                  
/* Input Parameters: DocumentversionId         */                                  
/* Output Parameters:             */                                    
/* Purpose: Use For Rdl Report           */                          
/* Calls:                */                                    
/* Author: Neeru              */                                    
/*********************************************************************/                                     
  
SELECT     dbo.CustomDDStateReporting.DocumentVersionId, GC_CS.CodeName AS CommStyle, GC_MSU.CodeName AS MakeSelfUnderstood, 
                      GC_SWM.CodeName AS SupportWithMobility, GC_NI.CodeName AS NutritionalIntake, GC_SPC.CodeName AS SupportPersonalCare, 
                      GC_REL.CodeName AS Relationships, GC_FFSS.CodeName AS FamilyFriendSupportSystem, 
                      GC_SFCB.CodeName AS SupportForChallengingBehaviors, GC_BPP.CodeName AS BehaviorPlanPresent, GC_MMI.CodeName AS MajorMentalIllness, 
                      dbo.CustomDDStateReporting.NumberOfAntiPsychoticMedications, dbo.CustomDDStateReporting.NumberOfOtherPsychotropicMedications, 
                      convert(nvarchar,dbo.Documents.EffectiveDate,101) as EffectiveDate_2, ISNULL(dbo.Clients.LastName, '''') + '', '' + ISNULL(dbo.Clients.FirstName, '''') AS ClientName, 
                      dbo.SystemConfigurations.OrganizationName, dbo.Clients.ClientId
FROM         dbo.DocumentVersions INNER JOIN
                      dbo.CustomDDStateReporting ON dbo.DocumentVersions.DocumentVersionId = dbo.CustomDDStateReporting.DocumentVersionId INNER JOIN
                      dbo.Documents ON dbo.DocumentVersions.DocumentId = dbo.Documents.DocumentId INNER JOIN
                      dbo.Clients ON dbo.Documents.ClientId = dbo.Clients.ClientId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_CS ON dbo.CustomDDStateReporting.CommunicationStyle = GC_CS.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_NI ON dbo.CustomDDStateReporting.NutritionalIntake = GC_NI.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_SPC ON dbo.CustomDDStateReporting.SupportPersonalCare = GC_SPC.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_SWM ON dbo.CustomDDStateReporting.SupportWithMobility = GC_SWM.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_MSU ON dbo.CustomDDStateReporting.MakeSelfUnderstood = GC_MSU.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_FFSS ON dbo.CustomDDStateReporting.FamilyFriendSupportSystem = GC_FFSS.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_SFCB ON dbo.CustomDDStateReporting.SupportForChallengingBehaviors = GC_SFCB.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_REL ON dbo.CustomDDStateReporting.Relationships = GC_REL.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_BPP ON dbo.CustomDDStateReporting.BehaviorPlanPresent = GC_BPP.GlobalCodeId LEFT OUTER JOIN
                      dbo.GlobalCodes AS GC_MMI ON dbo.CustomDDStateReporting.MajorMentalIllness = GC_MMI.GlobalCodeId CROSS JOIN
                      dbo.SystemConfigurations
WHERE dbo.CustomDDStateReporting.DocumentVersionId=@DocumentVersionId 
  
--Checking For Errors                          
If (@@error!=0)                          
 Begin                          
  RAISERROR  20006   ''csp_RDLCustomDDStateReporting : An Error Occured''                           
  Return                          
 End  
End                        
                        
  ' 
END
GO
