
/*Insert Script for  RecodeCategories and Recodes*/
/*Created By:Chethan N
Created Date:19-Apr-2018 */
DECLARE @RecodeCategoryId INT
IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='EKGOrders' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)
VALUES('EKGOrders','EKGOrders','To idnetity EKG Orders','OrderId')
END

-- Sample Insert script
--SET @RecodeCategoryId=(SELECT MAX(RecodeCategoryId)
--FROM  RecodeCategories WHERE CategoryCode='EKGOrders' AND ISNULL(RecordDeleted,'N')='N')

--IF NOT EXISTS(SELECT 1 FROM Recodes WHERE IntegerCodeId = 52 AND ISNULL(RecordDeleted,'N')='N')
--BEGIN
--INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
--VALUES(52,'CRU Admission',@RecodeCategoryId)
--END