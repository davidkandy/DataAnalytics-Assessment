SELECT 
    frequency_category,
    COUNT(DISTINCT owner_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM (
		SELECT 
        owner_id,
		AVG(transaction_count) AS avg_transactions_per_month,
		CASE
			WHEN AVG(transaction_count) >= 10 THEN 'High Frequency'
			WHEN AVG(transaction_count) >= 3 THEN 'Medium Frequency'
			ELSE 'Low Frequency'
		END AS frequency_category
FROM (
		SELECT user.id AS owner_id,
			DATE_FORMAT(save.transaction_date, '%y-%m-01') AS month,
			COUNT(save.id) AS transaction_count
		FROM users_customuser user
		JOIN savings_savingsaccount AS save ON user.id = save.owner_id
		WHERE save.savings_id IS NOT NULL
		GROUP BY user.id , DATE_FORMAT(save.transaction_date, '%y-%m-01')
    ) AS monthly_transactions
GROUP BY owner_id) AS customer_stats
GROUP BY frequency_category
ORDER BY CASE
    WHEN frequency_category = 'High Frequency' THEN 1
    WHEN frequency_category = 'Medium Frequency' THEN 2
    ELSE 3
END;