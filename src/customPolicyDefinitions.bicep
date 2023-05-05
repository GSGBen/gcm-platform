// deployment configuration for custom policy definitions. Wraps the module of the same name.

targetScope = 'managementGroup'

@description('Baseline resource configuration')
module baseline_policy 'modules/customPolicyDefinitions.bicep' = {
  name: 'minimum policy'
  params: {
    parTargetManagementGroupId: 'GSM'
  }
}
