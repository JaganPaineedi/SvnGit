/****** Object:  FUNCTION [dbo].[ssf_GetOverriddenTextFromScreenLabels]    Script Date: 20/12/2018 11:44:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetOverriddenTextFromScreenLabels]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_GetOverriddenTextFromScreenLabels]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/****** Object:  FUNCTION [dbo].[ssf_GetOverriddenTextFromScreenLabels]    Script Date: 20/12/2018 11:44:13 ******/

/************************************************************************/                                                                
/* Stored FUNCTION: ssf_GetOverriddenTextFromScreenLabels  6832   */                                                       
/*											 */                                                                
/* Creation Date:  20 Dec 2018                          */                                                                
/*											*/                                                            
/* Purpose: Gets Overridetext for ssp_RdlCarePlanSummaryInformation to create dynamic label    */                                                               
/* Input Parameters: @ScreenId, @TabControlId, @LabelControlId         */                                                              
/* Retun:   @Overridetext          */ 
--Select dbo.ssf_GetOverriddenTextFromScreenLabels(1077,'CarePlanTabPageInstance_C0','span_MHLoc')                                                               
         

CREATE FUNCTION ssf_GetOverriddenTextFromScreenLabels (@ScreenId Int, @TabControlId Varchar(500),@LabelControlId Varchar(500))
RETURNS VARCHAR(500)
AS BEGIN
    DECLARE @Overridetext VARCHAR(500)

    Select @Overridetext = Overridetext From ScreenLabels Where ScreenId = @ScreenId And TabControlId = @TabControlId and LabelControlId = @LabelControlId

    RETURN @Overridetext
END
GO

