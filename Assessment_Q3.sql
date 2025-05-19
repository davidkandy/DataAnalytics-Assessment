create or replace view inactive_users as
SELECT distinct save.owner_id
	FROM savings_savingsaccount save
	WHERE save.transaction_date between DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY) AND current_date
    AND save.confirmed_amount = 0

create or replace view user_activity as
select 
	plan.id as plan_id,
	plan.owner_id as owner_id,
	case 
		when plan.is_regular_savings = 1 then 'Savings'
		when plan.is_a_fund = 1 then 'Investment'
	end as type,
    save.transaction_date
from plans_plan as plan
join savings_savingsaccount as save on plan.owner_id = save.owner_id and plan.id = save.plan_id
where (plan.is_regular_savings = 1 or plan.is_a_fund = 1)
  and save.transaction_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY)

select ua.plan_id, iu.owner_id, ua.type,
    datediff(current_date, max(ua.transaction_date)) as inactivity_days,
    max(date_format(ua.transaction_date, '%Y-%m-%d')) as last_transaction_date
from user_activity as ua
join inactive_users as iu on iu.owner_id = ua.owner_id
group by ua.plan_id, iu.owner_id, ua.type;
