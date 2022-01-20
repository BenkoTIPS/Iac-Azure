az login

az account show

$env = "bnk"
$appName = "iac-bicep-mod"
$rg = "$env-$appName-rg"
$params = ".\params.$env.json"
$deployName = "test-bicep-" + (get-date -format "MMdd-HHmm")

az group create --name $rg --location centralus

az deployment group create --name $deployName --resource-group $rg -f WebSite.bicep --parameters $params appName=$appName

az deployment sub create -l centralus --name $deployName -f main.bicep --parameters appName=$appName envName=bnk

az group delete --name $rg