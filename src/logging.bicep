targetScope = 'subscription'

@description('The Azure location to deploy to.')
param location string = deployment().location

@description('the prefix for named things. Generally the same as the root ALZ management group ID')
param prefix string = 'GSM'


resource loggingResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  location: location
  name: 'loggingResourceGroup'
}

@description('Baseline resource configuration')
module baseline_logging 'modules/logging.bicep' = {
  name: 'baseline_logging'
  scope: loggingResourceGroup
  params: {
    parLogAnalyticsWorkspaceLocation: location
    parAutomationAccountLocation: location
    parLogAnalyticsWorkspaceName: '${prefix}-log-analytics'
    parLogAnalyticsWorkspaceSkuName: 'Free'
    parAutomationAccountName: '${prefix}-automation-account'
  }
}
