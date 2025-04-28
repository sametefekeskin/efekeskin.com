**This is a do-file spesifically designed for the currency analysis project, written by Samet Efe Keskin.
*April 20, Mannheim, Germany. 

* ------------------------------------------
* Extended Analysis: Bitcoin and Safe-Haven Status
* ------------------------------------------

clear all
set more off

* Loading the main dataset 
use "CurrencyReturnAnalysis.dta", clear

keep date Risky_Safe_Diff DollarRisk CarryRisk SPReturn SPVol GoldReturn BTCReturn

* Drop missing Bitcoin observations to match shorter BTC period
drop if missing(BTCReturn)

* Correlation matrix including Bitcoin
corr Risky_Safe_Diff DollarRisk CarryRisk SPReturn SPVol GoldReturn BTCReturn

corr Risky_Safe_Diff DollarRisk CarryRisk SPReturn SPVol GoldReturn BTCReturn, matrix(name(Rmatrix))


* Optional: Export correlations to Excel
putexcel set "BTC_Correlation_Analysis.xlsx", replace
putexcel A1=("Variable") B1=("Correlation with BTC Return")

putexcel A2=("Risky-Safe Spread") B2=Rmatrix[7,1]
putexcel A3=("Dollar Risk")       B3=Rmatrix[7,2]
putexcel A4=("Carry Risk")        B4=Rmatrix[7,3]
putexcel A5=("S&P 500 Return")    B5=Rmatrix[7,4]
putexcel A6=("S&P 500 Volatility")B6=Rmatrix[7,5]
putexcel A7=("Gold Return")       B7=Rmatrix[7,6]

* Notes:
* - Make sure variable names in your dataset match: e.g., BTCReturn should exist.
* - "Risky_Safe_Diff" should represent the monthly return difference between risky and safe currencies.
* - This approach ensures comparability with earlier correlation results.

* End of Script
