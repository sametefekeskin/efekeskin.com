*This is a do-file spesifically designed for the currency analysis project, written by Samet Efe Keskin.
*April 20, Mannheim, Germany. 

* STEP 1: Load the Excel dataset
clear
cd "/Users/efekeskin/Desktop"
import excel "Currency Returns.xlsx", sheet("Sheet1") firstrow clear

* STEP 2: Identify currency columns (exclude global factors)
ds Date DollarRisk CarryRisk GoldReturn BTCReturn SPReturn SPVol, not
local currencies `r(varlist)'

* STEP 3: Regress each currency on DollarRisk and CarryRisk
tempname results_handle
postfile `results_handle' str30 currency b_dollar b_carry using regresults.dta, replace

foreach c of local currencies {
    display ">>> Regressing: `c'"
    capture regress `c' DollarRisk CarryRisk if !missing(`c', DollarRisk, CarryRisk)
    
    if _rc == 0 {
        display "✅ Posting: `c'"
        post `results_handle' ("`c'") (_b[DollarRisk]) (_b[CarryRisk])
    }
    else {
        display "⚠️ Skipped: `c' (regression failed)"
    }
}

postclose `results_handle'

use regresults.dta, clear

generate category = "safe"
replace category = "risky" if b_dollar > 0.05 & b_carry > 0.05


export excel using "currency_classification.xlsx", firstrow(variables) replace


clear
cd "/Users/efekeskin/Desktop"
use "DATA.dta", clear

capture gen row_id = _n

local currencies AUSTRALIAN BULGARIAN CANADIAN CHILEAN COLOMBIAN CROATIAN CZECH DANISH EURO HUNGARIAN ICELAND INDIAN ISRAELI JAPANESE KASAKHSTAN KENYAN MEXICAN MOROCCAN NEWZEALAND NORWEGIAN PAKISTANI PERU PHILIPPINE POLISH ROMANIAN SOUTH SWEDISH SWISS THAI TUNISIAN TURKISH

stack `currencies', into(currency_return) wide clear

rename _stack varname

gen row_id = _n
tempfile returns_data
save `returns_data'

import excel using "currency_classification.xlsx", firstrow clear
keep currency category
rename currency varname
tempfile class_data
save `class_data'

use `returns_data', clear
merge m:1 varname using `class_data'
drop _merge

summarize
