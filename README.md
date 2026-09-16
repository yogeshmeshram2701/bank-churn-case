# Bank Customer Churn: A SQL Business Case Study

## Business Problem
A retail bank wants to understand why 1 in 5 customers leave, and — more usefully — *which* customers are most at risk, so retention efforts can be targeted rather than applied blanket-wide. This project analyzes 10,000 customer records using SQL to test hypotheses one at a time, the way a business stakeholder actually asks questions: "does X matter?" rather than "show me everything."

**Dataset:** [Churn Modelling dataset](https://www.kaggle.com/datasets/shrutimechlearn/churn-modelling) (Kaggle) — 10,000 bank customers with demographic, account, and product-holding data, and a churn flag (`Exited`).

## Approach
Rather than running every possible cut of the data, each query here started as a hypothesis, was tested, and was kept or discarded based on the result — including the hypotheses that turned out to be **wrong**, which are reported here too since knowing what *doesn't* drive churn is as useful to a stakeholder as knowing what does.

## Findings & Recommendations

### Baseline: 20.37% overall churn rate
2,037 of 10,000 customers have left. Every finding below is measured against this baseline.

### Ruled out: credit card ownership and salary level
| Hypothesis | Result |
|---|---|
| Has credit card? | 20.81% (no card) vs 20.18% (has card) — no meaningful difference |
| Salary band | 19.87%–21.47% across all four bands — flat |

**Recommendation:** Don't spend retention budget targeting by income tier or card ownership — the data doesn't support either as a driver.

### 1. Inactive members churn nearly 2x more often
| Status | Churn Rate |
|---|---|
| Inactive | 26.85% |
| Active | 14.27% |

**Recommendation:** Activity status is a simple, already-available early warning signal. A re-engagement trigger for members who go inactive could catch at-risk customers before they formally leave.

### 2. Product count is the single strongest driver — and it's not linear
| Products Held | Churn Rate |
|---|---|
| 1 | 27.71% |
| 2 | **7.58%** (healthiest segment) |
| 3 | 82.71% |
| 4 | 100.00% |

**Recommendation:** This contradicts the common assumption that more products sold means a stickier customer. Two products is the sweet spot; three or more is a near-certain predictor of churn. This pattern likely reflects poorly-fit cross-selling (products pushed rather than chosen) rather than genuine engagement. Worth auditing how 3rd/4th products get sold before pushing more cross-sell campaigns.

### 3. Germany churns ~2x more than France or Spain — independently of the product problem
| Country | Churn Rate |
|---|---|
| France | 16.15% |
| Germany | **32.44%** |
| Spain | 16.67% |

Breaking this down by product count confirms the two problems are separate, not one explaining the other:

| Products | France | Germany | Spain |
|---|---|---|---|
| 1 | 22.43% | 42.85% | 21.87% |
| 2 | 5.70% | 12.12% | 7.35% |
| 3 | 78.85% | 89.58% | 78.79% |
| 4 | 100.00% | 100.00% | 100.00% |

The product-count "cliff" pattern holds in every country, but Germany runs roughly 2x worse than France/Spain at every product tier. **Recommendation:** Germany needs its own retention investigation (competition, service quality, or local pricing) — fixing the product-bundling issue alone will not close this gap.

### 4. Churn peaks in the 50-60 age band, not a simple linear trend
| Age Band | Churn Rate |
|---|---|
| Under 30 | 7.56% |
| 30-40 | 10.88% |
| 40-50 | 30.79% |
| **50-60** | **56.04%** (peak) |
| 60+ | 27.95% |

**Recommendation:** Churn rises with age but drops again after 60 rather than continuing to climb — a bulge, not a trend. A plausible read: customers in their 50s are actively shopping around (e.g. for retirement/investment products elsewhere), while 60+ customers who've stayed this long have settled in. Retention campaigns aimed at the 50-60 segment specifically would likely outperform an age-blind campaign.

### 5. Funded accounts churn more than zero-balance accounts (counterintuitive)
| Balance Group | Churn Rate |
|---|---|
| Zero Balance | 13.82% |
| Has Balance | **24.08%** |

**Recommendation:** This runs against the intuitive assumption that money-in-account means loyalty. A plausible explanation: zero-balance customers have often already disengaged (moved funds elsewhere) without formally closing the account, so they don't yet register as "churned" — while funded customers are the ones still actively deciding to leave. Worth validating with tenure/last-activity data if available.

## Tools Used
SQL (SQLite), DB Browser for SQLite for querying and exploration

## Files in This Repo
- `queries.sql` — all 9 queries, commented with the business question each answers
- `README.md` — this write-up

## How to Reproduce
1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/shrutimechlearn/churn-modelling)
2. Open `Churn_Modelling.csv` in DB Browser for SQLite (or any SQL tool) as a table named `Churn_Modelling`
3. Run the queries in `bank_churn_analysis.sql`

## About This Project
Built as a business analyst portfolio project to demonstrate hypothesis-driven SQL analysis — testing assumptions (including wrong ones) rather than mining for whatever pattern appears, and translating raw churn data into segment-specific, actionable recommendations.
