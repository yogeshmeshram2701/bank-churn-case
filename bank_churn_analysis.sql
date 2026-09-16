/* ================================================================
   Bank Customer Churn — Business Analysis Queries
   Dataset: Churn Modelling dataset (Kaggle) — 10,000 bank customers
   Engine tested on: SQLite
   ================================================================ */


-- ----------------------------------------------------------------
-- Q1. What's our overall churn rate?
-- Business question: Baseline every other finding gets compared against.
-- ----------------------------------------------------------------
SELECT
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling;


-- ----------------------------------------------------------------
-- Q2. Does account activity affect churn?
-- Business question: Is disengagement (inactivity) a leading indicator
-- of churn, and how much does it matter?
-- ----------------------------------------------------------------
SELECT
    IsActiveMember,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY IsActiveMember;


-- ----------------------------------------------------------------
-- Q3. Does the number of products a customer holds affect churn?
-- Business question: Does cross-selling more products increase loyalty,
-- as commonly assumed, or does it backfire past a certain point?
-- ----------------------------------------------------------------
SELECT
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY NumOfProducts
ORDER BY NumOfProducts;


-- ----------------------------------------------------------------
-- Q4. Does churn vary by country?
-- Business question: Is retention a bigger problem in specific markets?
-- ----------------------------------------------------------------
SELECT
    Geography,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY Geography;


-- ----------------------------------------------------------------
-- Q5. Is the country effect (Q4) actually explained by product mix (Q3),
-- or are the two independent problems?
-- Business question: Should Germany get its own retention investigation,
-- or is fixing the product-bundling issue enough to fix Germany too?
-- ----------------------------------------------------------------
SELECT
    Geography,
    NumOfProducts,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY Geography, NumOfProducts
ORDER BY Geography, NumOfProducts;


-- ----------------------------------------------------------------
-- Q6. How does churn vary by age band?
-- Business question: Which life-stage segment is most at risk, so
-- retention campaigns can be targeted rather than blanket-applied?
-- ----------------------------------------------------------------
SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age < 40 THEN '30-40'
        WHEN Age < 50 THEN '40-50'
        WHEN Age < 60 THEN '50-60'
        ELSE '60+'
    END AS age_band,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY age_band;


-- ----------------------------------------------------------------
-- Q7. Do zero-balance customers behave differently from funded ones?
-- Business question: Is an empty balance a sign of a "soon to churn"
-- customer, or the opposite — an already-disengaged customer who just
-- hasn't formally left yet?
-- ----------------------------------------------------------------
SELECT
    CASE WHEN Balance = 0 THEN 'Zero Balance' ELSE 'Has Balance' END AS balance_group,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY balance_group;


-- ----------------------------------------------------------------
-- Q8. Do credit card ownership and salary level affect churn?
-- Business question: Ruling out two commonly assumed churn drivers.
-- ----------------------------------------------------------------
SELECT
    HasCrCard,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY HasCrCard;

SELECT
    CASE
        WHEN EstimatedSalary < 50000 THEN 'Under 50k'
        WHEN EstimatedSalary < 100000 THEN '50k-100k'
        WHEN EstimatedSalary < 150000 THEN '100k-150k'
        ELSE '150k+'
    END AS salary_band,
    COUNT(*) AS total_customers,
    SUM(Exited) AS churned_customers,
    ROUND(100.0 * SUM(Exited) / COUNT(*), 2) AS churn_rate_pct
FROM Churn_Modelling
GROUP BY salary_band;
