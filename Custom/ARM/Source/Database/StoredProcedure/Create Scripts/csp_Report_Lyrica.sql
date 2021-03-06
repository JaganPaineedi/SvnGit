/****** Object:  StoredProcedure [dbo].[csp_Report_Lyrica]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Lyrica]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Lyrica]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Lyrica]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_Report_Lyrica]

as
--*/
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <02/20/2013>
-- Description:	<As per WO: 27341. Finds clients perscribed Lyrica. Does not include Larry Johnson, Lorraine Fay and Teresa Graham>
-- =============================================



SELECT m.ClientId, LastName + '', '' + FirstName as ''Client Name'', m.PrescriberName, m.CreatedDate as ''Perscribed Date'', DrugPurpose, Ordered
  FROM dbo.ClientMedications m
  
  Join Clients c
  
  On c.ClientId =m.ClientId
  
  WHERE (MedicationNameId = 42642 --Lyrica 
  or MedicationNameId = 42632) --Pregabalin 
  
  AND PrescriberId <> 760 -- Larry Johnson
  AND PrescriberId <> 1211-- Lorraine Fay
  AND PrescriberId <> 1799 --Teresa Graham
  AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
  AND (ISNULL(m.RecordDeleted, ''N'')<>''Y'')
  
  order by m.CreatedDate

' 
END
GO
