select DocumentValidationId,DocumentCodeId,ROW_NUMBER() Over(partition by DocumentCodeId order by [ValidationOrder] ) as NewOrder,[ValidationOrder]
into #NewOrders
from DocumentValidations
where ISNULL(RecordDeleted,'N')='N'


Update dv 
set dv.ValidationOrder = ne.NewOrder,
dv.ModifiedBy = 'EII634',
dv.ModifiedDate = GETDATE()
from DocumentValidations as dv
join #NewOrders as ne on dv.DocumentValidationId = ne.DocumentValidationId

drop table #NewOrders