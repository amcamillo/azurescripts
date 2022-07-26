//260722 - a look at advanced parameters commands
//reference: https://docs.microsoft.com/en-us/learn/modules/build-reusable-bicep-templates-parameters/3-exercise-add-parameters-with-decorators?pivots=cli


@description('The name of the environment, must be "dev", "test" or "prod".')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('Unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = '260722-${uniqueString(resourceGroup().id)}'

@description('Number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('Name and tier of App Service Plan SKU.')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}

@description('Azure region where resources will be deployed')
param location string = 'westus3'

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'

//defining resources

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp  'Microsoft.Web/sites@2020-06-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
