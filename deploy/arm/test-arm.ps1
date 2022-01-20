# az login

az account show

$env = "bnk"
$appName = "iac-arm-azcli"
$rg = "$env-$appName-rg"
$params = ".\params.$env.json"
$deployName = "test-arm-" + (get-date -format "MMdd-HHmm")

az group create --name $rg --location centralus

az deployment group create --name $deployName --resource-group $rg -f WebSite.json --parameters $params appName=$appName

az group delete --name $rg

az bicep decompile -f .\WebSite.json
