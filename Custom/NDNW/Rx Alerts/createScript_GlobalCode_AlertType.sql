
   --create new alert type
   IF NOT EXISTS (SELECT 1 FROM dbo.GlobalCodes gc WHERE gc.CodeName = 'Electronic Script Error' AND gc.Category = 'ALERTTYPE' AND ISNULL(gc.RecordDeleted,'N')='N')
   BEGIN
   INSERT INTO dbo.GlobalCodes (Category,CodeNAme,[Description],Active,CannotModifyNameOrDelete)
   VALUES
   ('ALERTTYPE','Electronic Script Error','Valley Customization','Y','N')
   END
   