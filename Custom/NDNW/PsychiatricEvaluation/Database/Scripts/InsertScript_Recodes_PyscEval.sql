-----INSERT INTO RecodeCategories Table for Pysc Eval
SET IDENTITY_INSERT [dbo].[RecodeCategories] ON
IF NOT EXISTS(SELECT CategoryCode from RecodeCategories WHERE CategoryCode='XPSYCHIATRICEVALUATIONVITAL')
BEGIN
INSERT INTO RecodeCategories(RecodeCategoryId, CategoryCode,CategoryName,[Description],MappingEntity)
VALUES(12020, 'XPSYCHIATRICEVALUATIONVITAL','Psychiatric Service',
         'This category is used within the Flow sheet modules to populate the Vital Information from Exam Page.',
         '') 
END
SET IDENTITY_INSERT [dbo].[RecodeCategories] OFF

IF NOT EXISTS(SELECT CodeName from Recodes WHERE CodeName='XPSYCHIATRICEVALUATIONVITAL')
BEGIN
insert into dbo.Recodes
        (
         IntegerCodeId,
         CodeName,
         FromDate,
         ToDate,
         RecodeCategoryId
        )
values  (
         110, -- customer-specific value
         'XPSYCHIATRICEVALUATIONVITAL',
         '01/01/2013',	-- becomes effective on Jan 1st, 2013
         null,
         12020
        )
END
        