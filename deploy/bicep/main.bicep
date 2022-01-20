param appName string
param envName string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${envName}-${appName}-bicep'
  location: 'centralus'
}

module site 'website.bicep' = {
  scope: resourceGroup(rg.name)
  name: 'website.bicep'
  params: {
    appName: appName
    envName: envName
    favoriteColor: 'tan'
    mySecret: 'not-secret'
  }
}
