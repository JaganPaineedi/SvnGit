/* What : Removing Health Data and  GrowthCharts*/
/* Why  : As per wasif mail*/
/* Created by : Anto 02/02/2016  Engineering Improvement Initiatives #270*/

Update SystemActions 
set RecordDeleted = 'Y'  
where Action = 'Health Data' and ActionId = 10053

Update SystemActions 
set RecordDeleted = 'Y'  
where Action = 'GrowthCharts' and ActionId = 10064