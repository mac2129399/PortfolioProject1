
--SELECT * 
--FROM dbo.drugs2025

--SELECT *
--FROM dbo.financial2025


-- BASIC JOIN
SELECT *
FROM drugs2025 d
JOIN financial2025 f
ON d.sponsor_company = f.company_name

-- Business Insights
-- 1. Innovation vs. Revenue - Which companies earn the most revenue, and what types of drugs are they getting approved?
SELECT COALESCE(f.company_name, 'Unspecified') AS company_name, 
	COALESCE(f.revenue_usd_bn, 0) AS revenue_usd_bn,
	d.drug_type,
	COUNT(d.drug_id) AS approvals_2025
FROM drugs2025 d
LEFT JOIN financial2025 f 
	ON d.sponsor_company = f.company_name
GROUP BY f.company_name, f.revenue_usd_bn, d.drug_type
ORDER BY f.revenue_usd_bn DESC, approvals_2025 DESC

-- 2. Peak Sales Potential vs. Company Revenue - Do high-revenue companies also launch drugs with the highest peal-sales potential?
SELECT COALESCE(f.company_name, 'Unspecified') AS company_name,  
	COALESCE(f.revenue_usd_bn, 0) AS revenue_usd_bn,
	SUM(d.peak_sales_usd_bn_est) AS total_peak_sales,
	AVG(d.peak_sales_usd_bn_est) AS avg_peak_sales, 
	COUNT(d.drug_id) AS approvals_2025
FROM drugs2025 d 
LEFT JOIN financial2025 f 
	ON d.sponsor_company = f.company_name
GROUP BY f.company_name, f.revenue_usd_bn
ORDER BY total_peak_sales DESC;
	
-- 3. Therapy Area Dominance - Which companies get the most approvals in each therapy area (oncology, infectious, neurology, etc.)?
SELECT 
    COALESCE(f.company_name, 'Unspecified') AS company_name,
    d.therapy_area,
    COUNT(d.drug_id) AS approvals_2025
FROM drugs2025 d
LEFT JOIN financial2025 f
    ON d.sponsor_company = f.company_name
GROUP BY f.company_name, d.therapy_area
ORDER BY d.therapy_area, approvals_2025 DESC;

-- 4. Pipeline Size vs. Approvals - Do companies with larger pipelines achieve more FDA approvals?
SELECT f.company_name,
	f.pipeline_size_est,
	COUNT(d.drug_id) AS approvals_2025
FROM financial2025 f
LEFT JOIN drugs2025 d 
	ON d.sponsor_company = f.company_name
GROUP BY f.company_name, f.pipeline_size_est
ORDER BY f.pipeline_size_est DESC;

-- 5. Revenue vs. Approval Productivity - Are higher-revenue companies producing more approvals than lower-revenue companies?
SELECT f.company_name,
	f.revenue_usd_bn,
	COUNT(d.drug_id) AS approvals_2025
FROM financial2025 f
LEFT JOIN drugs2025 d 
	ON f.company_name = d.sponsor_company
GROUP BY f.company_name, f.revenue_usd_bn
ORDER BY f.revenue_usd_bn DESC

-- 6. Company Strategy Profiles - What does each company seem to focus on based on its approvals (therapy areas and drug types)?
SELECT d.sponsor_company, 
	d.therapy_area,
	d.drug_type,
	COUNT(d.drug_id) AS approvals_2025
FROM drugs2025 d
GROUP BY d.sponsor_company, d.therapy_area, d.drug_type
ORDER BY d.sponsor_company, d.therapy_area, d.drug_type

-- Which companies had the most FDA approvals in 2025?
SELECT sponsor_company, COUNT(*) AS total_drugs
FROM drugs2025
GROUP BY sponsor_company
ORDER BY total_drugs DESC;

-- Which drug types were most approved in 2025?
SELECT drug_type, COUNT(*) AS total_approvals
FROM drugs2025
GROUP BY drug_type
ORDER BY total_approvals DESC;

-- Which companies focus on which drug types?
SELECT sponsor_company, drug_type, COUNT(*) AS total
FROM drugs2025
GROUP BY sponsor_company, drug_type
ORDER BY sponsor_company, total DESC;

-- Which segments had the most FDA approvals in 2025? 
SELECT  COALESCE(f.segment, 'Unspecified') AS segment,
	COUNT(d.drug_id) AS approvals_2025
FROM drugs2025 d
LEFT JOIN financial2025 f
	ON d.sponsor_company = f.company_name
GROUP BY f.segment
ORDER BY f.segment, approvals_2025