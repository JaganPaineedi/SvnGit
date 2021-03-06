/****** Object:  StoredProcedure [dbo].[csp_ConvertPatientId]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ConvertPatientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ConvertPatientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ConvertPatientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE     procedure [dbo].[csp_ConvertPatientId]
@start_patient_id	char(10),
@end_patient_id		char(10)

AS


select c.clientId, patient_id 

from cstm_conv_map_clients as cmp 

	JOIN clients as c on cmp.clientId = c.clientId

where patient_id >= @start_patient_id 

	AND patient_id <= @end_patient_id

' 
END
GO
