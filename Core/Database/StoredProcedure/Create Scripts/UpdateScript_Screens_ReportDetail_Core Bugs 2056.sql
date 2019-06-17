-------------------------------------------------------
--Author:Manjunath K.
--Date  :28th April 2016
--Purpose:Updated Init sp in screens table for Report Detail. Ref : Core Bugs #2056.
-------------------------------------------------------

if exists(select ScreenId from Screens where ScreenId=108)
begin
update Screens set InitializationStoredProcedure='ssp_InitializeReportDetail' where ScreenId=108
end