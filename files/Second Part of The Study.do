*This is a do-file spesifically designed for the currency analysis project, written by Samet Efe Keskin.
*April 20, Mannheim, Germany. 


clear
cd "/Users/efekeskin/Desktop"
import excel using "Currency Returns.xlsx", firstrow clear


gen Currency = ""
gen Value = .

local currencies AUSTRALIAN BULGARIAN CANADIAN CHILEAN COLOMBIAN CROATIAN CZECH DANISH EURO HUNGARIAN ICELAND INDIAN ISRAELI JAPANESE KASAKHSTAN KENYAN MEXICAN MOROCCAN NEWZEALAND NORWEGIAN PAKISTANI PERU PHILIPPINE POLISH ROMANIAN SOUTH SWEDISH SWISS THAI TUNISIAN TURKISH DollarRisk CarryRisk GoldReturn BTCRet SPReturn SPVol

local i = 1
foreach currency of local currencies {
    * Loop through each date in the dataset
    foreach date of varlist Date {
        * Add currency name to the Currency variable
        replace Currency = "`currency'" in `i'
        
        * Add the corresponding currency value to the Value variable
        replace Value = `currency' in `i'
        
        * Increment counter
        local i = `i' + 1
    }
}

list Date Currency Value in 1/20

* Step 5: Portfolio Construction and Return Analysis
* Step 5a: Classify currencies into "safe" and "risky" groups
* Step 5a: Classify currencies into "safe" and "risky" groups

*Classify Currencies into "safe" and "risky"
gen CurrencyType = ""  // Initialize with empty values

* Assign risky currencies (breaking the list into smaller parts)
replace CurrencyType = "risky" if inlist(Currency, "AUSTRALIAN", "BULGARIAN", "CANADIAN")
replace CurrencyType = "risky" if inlist(Currency, "CHILEAN", "COLOMBIAN", "CROATIAN")
replace CurrencyType = "risky" if inlist(Currency, "CZECH", "DANISH", "EURO")
replace CurrencyType = "risky" if inlist(Currency, "HUNGARIAN", "ICELAND", "INDIAN")
replace CurrencyType = "risky" if inlist(Currency, "ISRAELI", "JAPANESE")

* Assign safe currencies (breaking the list into smaller parts)
replace CurrencyType = "safe" if inlist(Currency, "KASAKHSTAN", "KENYAN", "MEXICAN")
replace CurrencyType = "safe" if inlist(Currency, "MOROCCAN", "NEWZEALAND", "NORWEGIAN")
replace CurrencyType = "safe" if inlist(Currency, "PAKISTANI", "PERU", "PHILIPPINE")
replace CurrencyType = "safe" if inlist(Currency, "POLISH", "ROMANIAN", "SOUTH")
replace CurrencyType = "safe" if inlist(Currency, "SWEDISH", "SWISS", "THAI")
replace CurrencyType = "safe" if inlist(Currency, "TUNISIAN", "TURKISH", "DollarRisk")
replace CurrencyType = "safe" if inlist(Currency, "CarryRisk", "GoldReturn", "BTCRet")
replace CurrencyType = "safe" if inlist(Currency, "SPReturn", "SPVol")

collapse (mean) Value, by(Date CurrencyType)

gen RiskyReturn = .

bysort Date: replace RiskyReturn = Value if CurrencyType == "risky"

gen ReturnDifference = .
bysort Date: replace ReturnDifference = Value - RiskyReturn if CurrencyType == "risky"

* Step 4: Report the mean and standard deviation of the return differences
summarize ReturnDifference

save "CurrencyReturnAnalysis.dta", replace

******

