# DataAnalytics-Assessment


#Question 1 - High-Value Customers with Multiple Products

This SQL query identifies **high-value customers** who have **both a funded savings plan and a funded investment plan**, enabling data-driven **cross-selling opportunities**.

## ✅ Features

- Filters for customers with **at least one funded savings account** *and* **one funded investment account**.
- Calculates each customer's **total confirmed deposits**.
- Presents customer names in properly formatted casing (e.g., `Jane Doe`).
- Ranks customers by **total deposit amount** in descending order.

## 📄 Output Columns

| Column Name       | Description                                             |
|-------------------|---------------------------------------------------------|
| `owner_id`        | Unique identifier for the customer                     |
| `name`            | Full name of the customer (title-cased)               |
| `savings_count`   | Number of funded savings accounts                      |
| `investment_count`| Number of funded investment accounts                   |
| `total_deposits`  | Total confirmed deposits across both product types     |


## 📈 Sorting

The result is **sorted by total deposits** (`total_deposits`) in descending order so that the highest-value customers appear at the top.


#Question 2 - Transaction Frequency Analysis

This SQL query analyzes how frequently customers make transactions, enabling the **segmentation of users into behavioral categories** such as high, medium, or low-frequency users. It's ideal for finance teams looking to tailor communication, rewards, or product offerings based on customer activity.

## ✅ Features

- Calculates **average monthly transactions per customer**.
- Segments customers into:
  - **High Frequency** (≥10 transactions/month)
  - **Medium Frequency** (3–9 transactions/month)
  - **Low Frequency** (≤2 transactions/month)
- Aggregates the number of customers in each category.
- Returns rounded average transaction values per frequency segment.

## 📄 Output Columns

| Column Name                | Description                                                  |
|----------------------------|--------------------------------------------------------------|
| `frequency_category`       | Category based on transaction frequency (High/Medium/Low)    |
| `customer_count`           | Number of customers in each category                         |
| `avg_transactions_per_month` | Average monthly transactions for users in the category     |


## 📈 Sorting
The output is sorted from **highest to lowest frequency** to ensure business attention starts with the most engaged users.


#Question 3 - Account Inactivity Alert

This SQL workflow identifies **active accounts (savings or investments)** with **no inflow transactions in the past 365 days**, helping operations teams flag dormant accounts for follow-up or intervention.

## ✅ Features

- Flags accounts with **no inflow (confirmed amount = 0)** in the last year.
- Returns details on account type (Savings/Investment), last transaction date, and days since last activity.
- Uses views (`inactive_users`, `user_activity`) for modular, reusable logic.

## ⚙️ Views Workflow Breakdown

### 1. `inactive_users` View
A list of users who had no positive inflows over the past year — these are candidates for inactivity review.

save.transaction_date BETWEEN ...: Filters for transactions that occurred within the last year.

save.confirmed_amount = 0: Ensures that only transactions with zero monetary value (no inflow) are considered.

DISTINCT save.owner_id: Avoids duplicate entries for the same user.


### 2. `user_activity` View
Returns details about old transactions tied to each plan, helping determine when the user was last active before their 365-day inactivity window.

Joins plans (plans_plan) with transactions (savings_savingsaccount) based on both owner_id and plan_id.

Filters only active plans, either:

is_regular_savings = 1 (Savings), or

is_a_fund = 1 (Investment).

Focuses on transaction history older than 1 year — useful for calculating the last active date.


## 📄 Output Columns
| Column Name             | Description                              |
| ----------------------- | ---------------------------------------- |
| `plan_id`               | Unique ID of the savings/investment plan |
| `owner_id`              | Customer's unique identifier             |
| `type`                  | Account type: `Savings` or `Investment`  |
| `inactivity_days`       | Days since the last recorded transaction |
| `last_transaction_date` | Date of the last recorded transaction    |



#Question 4 - Customer Lifetime Value (CLV) Estimation

This SQL query estimates the **Customer Lifetime Value (CLV)** using a simplified model based on **account tenure** and **transaction volume**. It's built to help **marketing teams** identify the most valuable customers and optimize retention or upselling efforts.


## ✅ Features

- Calculates **account tenure** in months since signup.
- Aggregates **total number of transactions**.
- Computes **estimated CLV** using a simplified formula.
- Outputs customer names and sorts results by **CLV in descending order**.


## 🧮 CLV Calculation Logic

### Formula
CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction

### Assumptions
- `profit_per_transaction` is **0.1% of the transaction value**.
- CLV is **annualized** using the factor `* 12`.


## 📄 Output Columns
| Column Name          | Description                               |
| -------------------- | ----------------------------------------- |
| `customer_id`        | Unique user ID                            |
| `name`               | Full name (first + last, capitalized)     |
| `tenure_months`      | Number of months since the user joined    |
| `total_transactions` | Number of transactions linked to the user |
| `estimated_clv`      | Simplified annual CLV in currency units   |

## 📈 Sorting
Results are ordered by estimated_clv in descending order, showing the most valuable users at the top.
