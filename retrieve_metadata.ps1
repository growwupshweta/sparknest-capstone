$projDir = "C:\Users\Pc\.gemini\antigravity-ide\scratch\sparknest-capstone"
Set-Location $projDir

Write-Host "Retrieving objects and Apex..."
sf project retrieve start -m "CustomObject:Enquiry__c" -m "CustomObject:Enquiry_Product__c" -m "CustomObject:Product2" -m "ApexClass" -m "ApexTrigger"

Write-Host "Done."
