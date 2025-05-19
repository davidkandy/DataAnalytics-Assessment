CREATE OR REPLACE VIEW inactive_users AS
SELECT DISTINCT save.owner_id
FROM savings_savingsaccount save
WHERE save.transaction_date BETWEEN DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY) AND CURRENT_DATE
	AND save.confirmed_amount = 0;

CREATE OR REPLACE VIEW user_activity AS
SELECT 
	plan.id AS plan_id,
    plan.owner_id AS owner_id,
    CASE 
        WHEN plan.is_regular_savings = 1 THEN 'Savings'
        WHEN plan.is_a_fund = 1 THEN 'Investment'
    END AS type,
    save.transaction_date
FROM plans_plan AS plan
JOIN savings_savingsaccount AS save ON plan.owner_id = save.owner_id AND plan.id = save.plan_id
WHERE (plan.is_regular_savings = 1 OR plan.is_a_fund = 1)
	AND save.transaction_date < DATE_SUB(CURRENT_DATE, INTERVAL 365 DAY);

SELECT 
    ua.plan_id, 
    iu.owner_id, 
    ua.type,
    DATEDIFF(CURRENT_DATE, MAX(ua.transaction_date)) AS inactivity_days,
    MAX(DATE_FORMAT(ua.transaction_date, '%Y-%m-%d')) AS last_transaction_date
FROM user_activity AS ua
JOIN inactive_users AS iu ON iu.owner_id = ua.owner_id
GROUP BY ua.plan_id, iu.owner_id, ua.type;