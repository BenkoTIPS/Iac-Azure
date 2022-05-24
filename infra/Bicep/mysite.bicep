param appName string
param envName string
param color string

@secure()
param secret string

var prefix = '${envName}-${appName}'
var siteName_var = '${prefix}-site'
var hostName_var = '${prefix}-host'

resource hostName 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostName_var
  location: resourceGroup().location
  kind: 'app,linux'
  sku: {
    name: 'S1'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource siteName 'Microsoft.Web/sites@2020-12-01' = {
  name: siteName_var
  location: resourceGroup().location
  kind: 'linux,app'
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${hostName_var}': 'Resource'
    displayName: siteName_var
  }
  properties: {
    name: siteName_var
    serverFarmId: hostName.id
  }
}

resource siteName_appsettings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: siteName
  name: 'appsettings'
  location: 'resourceGroup().location'
  tags: {
    displayName: 'config'
  }
  properties: {
    EnvName: envName
    FavoriteColor: color
    Secret: secret
  }
}