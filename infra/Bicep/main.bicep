
param appName string
param envName string
param myLocation string = 'centralus'

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'osn22-${envName}-rg'
  location: myLocation
}

module site 'mysite.bicep' = {
  scope: resourceGroup(rg.name)
  name: deployment().name
  params: {
    appName: appName
    envName: envName
  }
}

output rgName string = rg.name
