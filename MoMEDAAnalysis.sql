/**percentage change in orders**/
use delly;
select 
Totalcustomers,
CurrentMonthOrders,
PreviousMonthOrders,
CurrentMonthRevenue,
PreviousMonthRevenue,
CurrentMonthGMV,
PreviousMonthGMV,
OrderMonth,
Order_Num,
round(cast((CurrentMonthOrders - PreviousMonthOrders) as float)
/PreviousMonthOrders * 100, 0)
as BookOrdersMoM,
round(cast((CurrentMonthGMV - PreviousMonthGMV) as float)
/PreviousMonthGMV * 100, 0)
as GMVMoM,
round(cast((CurrentMonthRevenue - PreviousMonthRevenue) as float)
/PreviousMonthRevenue * 100, 0)
as RevenueMoM 
from
(
select count(distinct a.CustomerID) as Totalcustomers,
round(count(a.OrderID),0) as CurrentMonthOrders,
round(sum(a.OrderPrice),0) as CurrentMonthGMV,
round(sum(a.CommissionPrice),0) as CurrentMonthRevenue,
round(lag(count(a.OrderID)) over(order by month(a.OrderDate)),0) as PreviousMonthOrders,
round(lag(sum(a.OrderPrice)) over(order by month(a.OrderDate)),0) as PreviousMonthGMV,
round(lag(sum(a.CommissionPrice)) over(order by month(a.OrderDate)),0) as PreviousMonthRevenue,
monthname(a.OrderDate) as OrderMonth,
month(a.OrderDate) as Order_Num
from orders as a
left join customer as b
on a.CustomerID = b.CustomerID
left join company as c
on a.CompanyID = c.CompanyID
left join companyuser as d
on a.CompanyUserID = d.CompanyUserID
where date(a.OrderDate) between "2025-01-01" and "2025-06-30"
and a.OrderStatus in
("PENDING", 
"ASSIGNED",
"INTRANSIT", 
"COMPLETED", 
"ONHOLD", 
"PENDING-RETURN",
"RETURNED"
)
group by monthname(a.OrderDate), month(a.OrderDate)
) as t;