SELECT 
    u.id AS owner_id,
    CONCAT(
        UPPER(LEFT(u.first_name, 1)), 
        LOWER(SUBSTRING(u.first_name, 2)), ' ',
        UPPER(LEFT(u.last_name, 1)), 
        LOWER(SUBSTRING(u.last_name, 2))
    ) AS name,
    COUNT(DISTINCT CASE 
        WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 
        THEN s.id 
    END) AS savings_count,
    COUNT(DISTINCT CASE 
        WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 
        THEN s.id 
    END) AS investment_count,
    CAST(
        (SUM(CASE WHEN p.is_regular_savings = 1 THEN s.confirmed_amount ELSE 0 END) +
        (SUM(CASE WHEN p.is_a_fund = 1 THEN s.confirmed_amount ELSE 0 END))
    ) / 100 AS DECIMAL(20, 2)) AS total_deposits
FROM 
    users_customuser u
    JOIN plans_plan p ON u.id = p.owner_id
    JOIN savings_savingsaccount s ON p.owner_id = s.owner_id AND p.id = s.plan_id
GROUP BY u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 AND s.confirmed_amount > 0 THEN s.id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 AND s.confirmed_amount > 0 THEN s.id END) >= 1
ORDER BY 
    total_deposits DESC;