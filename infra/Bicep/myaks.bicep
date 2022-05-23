@description('Application Name')
param appName string

@description('Name of Environment')
param envName string = 'bnk'

@description('Deploy location')
param myLoc string = resourceGroup().location
param myGuid string = newGuid()

var prefix = '${envName}-${appName}'
var clusterName_var = '${prefix}-aks'
var acrName_var = toLower('${envName}${appName}acs')
var location = myLoc

resource clusterName 'Microsoft.ContainerService/managedClusters@2021-05-01' = {
  name: clusterName_var
  location: location
  properties: {
    kubernetesVersion: '1.22.4'
    dnsPrefix: 'dnsprefix'
    nodeResourceGroup: '${resourceGroup().name}-nodes'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 2
        vmSize: 'Standard_ds2'
        osType: 'Linux'
        mode: 'System'
      }
    ]
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource acrName 'Microsoft.ContainerRegistry/registries@2019-05-01' = {
  name: acrName_var
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource acrName_Microsoft_Authorization_myGuid 'Microsoft.ContainerRegistry/registries/providers/roleAssignments@2018-09-01-preview' = {
  name: '${acrName_var}/Microsoft.Authorization/${myGuid}'
  properties: {
    principalId: reference(clusterName_var, '2021-07-01').identityProfile.kubeletidentity.objectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    scope: resourceId(resourceGroup().name, 'Microsoft.ContainerRegistry/registries/', acrName_var)
  }
}