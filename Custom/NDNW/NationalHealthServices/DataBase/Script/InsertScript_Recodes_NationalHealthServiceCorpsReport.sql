
 /* Date		  Author			Purpose  
 22/DEC/2015	  Ravichandra 		what:Save CoveragePlanId in Recodes for Auto Create Other Public Insurence 
								    why:Customizations: #32 National Health Service Corps Report*/

DECLARE @RecodeCategoryId INT


IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='XOTHERPUBLICINSURENCE' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)VALUES('XOTHERPUBLICINSURENCE','XOTHERPUBLICINSURENCE','CoveragePlanId for the CoveragePlanName - OtherPublicInsurence','CoveragePlanId')
END


SET @RecodeCategoryId=(SELECT MAX(RecodeCategoryId)FROM  RecodeCategories WHERE CategoryCode='XOTHERPUBLICINSURENCE' AND ISNULL(RecordDeleted,'N')='N')

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-DHS' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (278,'XOTHERPUBLICINSURENCE-DHS',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Parole/probation' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (279,'XOTHERPUBLICINSURENCE-Parole/probation',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Baker County Parole and Probation' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (280,'XOTHERPUBLICINSURENCE-Baker County Parole and Probation',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-CEOJJC' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (281,'XOTHERPUBLICINSURENCE-CEOJJC',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Crime Victims Assistance' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (282,'XOTHERPUBLICINSURENCE-Crime Victims Assistance',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Vocational Rehab' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (283,'XOTHERPUBLICINSURENCE-Vocational Rehab',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Jail' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (284,'XOTHERPUBLICINSURENCE-Jail',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-SE 25 Crisis' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (285,'XOTHERPUBLICINSURENCE-SE 25 Crisis',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-Federal' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (286,'XOTHERPUBLICINSURENCE-Federal',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-EOSHC' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (287,'XOTHERPUBLICINSURENCE-EOSHC',@RecodeCategoryId) 

END

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XOTHERPUBLICINSURENCE-AMHI' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (288,'XOTHERPUBLICINSURENCE-AMHI',@RecodeCategoryId) 

END

SET @RecodeCategoryId = NULL


IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='XSLIDINGFEES' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
INSERT INTO RecodeCategories(CategoryCode,CategoryName,[Description],MappingEntity)VALUES('XSLIDINGFEES','XSLIDINGFEES','CoveragePlanId for the CoveragePlanName - Sliding Fees','CoveragePlanId')
END



SET @RecodeCategoryId=(SELECT MAX(RecodeCategoryId)FROM  RecodeCategories WHERE CategoryCode='XSLIDINGFEES' AND ISNULL(RecordDeleted,'N')='N')

IF NOT EXISTS(SELECT 1 FROM Recodes WHERE CodeName='XSLIDINGFEES' AND ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO Recodes( IntegerCodeId,CodeName,RecodeCategoryId)
	VALUES (289,'XSLIDINGFEES-Sliding Scale Fee',@RecodeCategoryId) 
END



