/****** Object:  StoredProcedure [dbo].[csp_ControlEnableNoteMentalStatus]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ControlEnableNoteMentalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ControlEnableNoteMentalStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ControlEnableNoteMentalStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_ControlEnableNoteMentalStatus]

as

--This validation returns four fields
--Field1 = ActivityPageType
--Field2 = ControlName
--Field3 = Enabled
--Field4 = Visible

Select ''pageNote'' , ''PanelCognition'',''true'' ,''false''
union
Select ''pageNote'' , ''PanelSpeech'',''true'' ,''false''
Union
Select ''pageNote'' , ''PanelThoughtProcessing'',''true'' ,''false''
Union
Select ''pageNote'' , ''PanelAttention'',''true'' ,''false''
Union
Select ''pageNote'' , ''PanelLevelOfConsciousness'',''true'' ,''false''
Union
Select ''pageNote'' , ''panelMemory'',''true'' ,''false''
Union
Select ''pageNote'' , ''PanelJudgement'',''true'' ,''false''
Union
Select ''pageNote'' , ''panel14'',''true'' ,''false''


if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_ControlEnableNoteMentalStatus failed.  Contact your system administrator.''

return
' 
END
GO
