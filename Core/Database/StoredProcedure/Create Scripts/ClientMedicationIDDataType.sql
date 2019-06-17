
IF type_id('[dbo].[ClientMedicationIDDataType]') IS NULL
BEGIN
CREATE TYPE [dbo].ClientMedicationIDDataType As Table
(
ClientMedicationId int
)
END

