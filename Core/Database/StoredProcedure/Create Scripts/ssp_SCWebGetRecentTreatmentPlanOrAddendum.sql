

/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetRecentTreatmentPlanOrAddendum]    Script Date: 06/25/2015 15:31:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetRecentTreatmentPlanOrAddendum]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetRecentTreatmentPlanOrAddendum]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetRecentTreatmentPlanOrAddendum]    Script Date: 06/25/2015 15:31:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE procedure [dbo].[ssp_SCWebGetRecentTreatmentPlanOrAddendum]    
(    
    
@ClientId bigint,    
@DateOfService datetime,    
@ProcedureCodeId int    
) As    
    
    
/******************************************************************************    
**  File:    
**  Name: ssp_SCGetRecentTreatmentPlanOrAddendum    
**  Desc:    
**    
**  This Stored procedure gets the latest signed Treatment Plan or Addendum for the client.    
**    
**  Return values:A Result set containing information about recent signed treatment plan or addendum.    
**    
    
**    
**  Parameters:    
**  Input    Output    
**     ----------       -----------    
  28/12/2008   Vikas Vyas    
**  --------  --------    -------------------------------------------    
** 25/06/2015  Pradeep Kumar Yadav  Took Entire Logic of ssp_SCWebGetRecentTreatmentPlanOrAddendum inside this scsp_SCWebGetRecentTreatmentPlanOrAddendumNew In this scsp Harbor
                                    have a custom logic  and rest of the client have Core logic      
    
    
*******************************************************************************/    
Begin    
 Begin Try    
    
   IF OBJECT_ID('dbo.scsp_SCWebGetRecentTreatmentPlanOrAddendumNew', 'P') IS NOT NULL
   Begin   
   EXEC scsp_SCWebGetRecentTreatmentPlanOrAddendumNew @ClientId=@ClientId,@DateOfService=@DateOfService,@ProcedureCodeId=@ProcedureCodeId
   End 
    
    
 End Try    
 Begin Catch    
  declare @Error varchar(8000)    
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())    
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCWebGetRecentTreatmentPlanOrAddendum')    
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())    
  + '*****' + Convert(varchar,ERROR_STATE())    
 End Catch    
End 
GO


