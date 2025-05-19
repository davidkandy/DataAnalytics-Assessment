SELECT 
    user.id AS customer_id,
    CONCAT(
        UPPER(LEFT(user.first_name, 1)), 
        LOWER(SUBSTRING(user.first_name, 2)), ' ',
        UPPER(LEFT(user.last_name, 1)), 
        LOWER(SUBSTRING(user.last_name, 2))
    ) AS name,
    TIMESTAMPDIFF(MONTH, user.date_joined, CURDATE()) AS tenure_months,
    COUNT(save.id) AS total_transactions,
    CAST(
        ((COUNT(save.id) / NULLIF(TIMESTAMPDIFF(MONTH, user.date_joined, CURDATE()), 0))  -- (total_transactions / tenure)
        * 12 
        * (AVG(save.confirmed_amount) * 0.001) / 100  -- avg_profit_per_transaction
    ) AS DECIMAL(20, 2)) AS estimated_clv
FROM users_customuser AS user
JOIN savings_savingsaccount AS save 
    ON user.id = save.owner_id
WHERE save.confirmed_amount IS NOT NULL
GROUP BY user.id, user.first_name, user.last_name, user.date_joined
ORDER BY estimated_clv DESC;