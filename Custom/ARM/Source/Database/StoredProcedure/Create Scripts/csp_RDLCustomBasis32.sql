/****** Object:  StoredProcedure [dbo].[csp_RDLCustomBasis32]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomBasis32]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomBasis32]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomBasis32]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomBasis32]
--@DocumentId int,
--@Version int
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010

AS

Begin
/*********************************************************************/
/* Stored Procedure: [csp_RDLCustomBasis32]   */

/* Copyright: 2006 Streamline SmartCare*/

/* Creation Date:  Dec 07 ,2007                                  */
/*                                                                   */
/* Purpose: Gets Data for CustomBasis32 */
/*                                                                   */
/* Input Parameters: DocumentID,Version */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/*    */
/*                                                                   */
/* Purpose Use For Rdl Report  */
/*      */

/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Author Vikas Vyas          */
/*                                                                   */
/*                                                             */

/*                                        */
/*           */
/*********************************************************************/
 SELECT SystemConfig.OrganizationName,
       C.LastName + '', '' + C.FirstName as ClientName,
       Documents.ClientID,
       Documents.EffectiveDate,
       GCInterVal.CodeName as [Basis32Interval]
      ,[RelationToSelfOthers]
      ,[DepressionAnxiety]
      ,[DailyLivingFunctioning]
      ,[ImpulsiveBehavior]
      ,[Psychosis]
      ,[TotalScore]
FROM [CustomBasis32] CBasis32
join DocumentVersions as dv on dv.DocumentVersionId = CBasis32.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
   and isnull(Documents.RecordDeleted,''N'')<>''Y''
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''
join GlobalCodes  GCInterVal On CBasis32.Basis32Interval=GCInterval.GlobalCodeId and Isnull(GCInterVal.RecordDeleted,''N'')<>''Y''
Cross Join SystemConfigurations as SystemConfig
where CBasis32.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010




 --Checking For Errors
  If (@@error!=0)
  Begin
   RAISERROR  20006   ''[csp_RDLCustomBasis32] : An Error Occured''
   Return
   End




End
' 
END
GO
