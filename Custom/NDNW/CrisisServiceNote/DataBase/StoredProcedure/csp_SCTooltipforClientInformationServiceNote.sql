/****** Object:  StoredProcedure [dbo].[csp_SCTooltipforClientInformationServiceNote]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCTooltipforClientInformationServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCTooltipforClientInformationServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCTooltipforClientInformationServiceNote]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE PROCEDURE [dbo].[csp_SCTooltipforClientInformationServiceNote]   
@ClientId           INT   
,@DocumentVersionId INT   
,@ServiceId         INT   
,@StoredProcedure   VARCHAR(100)   
AS   
/*********************************************************************/   
/* Stored Procedure: csp_SCTooltipforClientInformationServiceNote               */   
/* Creation Date:  11/Mar/2012                                    */   
/* Purpose: To Get the for ToolTip shown on service Note Page */   
/* Input Parameters:  */   
/* Output Parameters:                                */   
/* Return:   */   
/* Called By:    */   
/* Calls:                                                            */   
/*                                                                   */   
/* Data Modifications:                                               */   
/*   Updates:                                                          */   
/*       Date              Modified By          Purpose    */   
/*     11/Mar/2012      Devi Dayal          Creation  */   
/*    07/01/2015      Malathi Shiva        Woods Customizations - Added to Common database folder which can be used for all the info Icons*/  
  /*********************************************************************/   
  BEGIN   
      EXEC @StoredProcedure   
        @ClientId,   
        @DocumentVersionId,   
        @ServiceId   
  END   
  
GO


