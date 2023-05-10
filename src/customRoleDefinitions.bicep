
targetScope = 'managementGroup'

@description('Baseline resource configuration')
module minimum_custom_role_definitions 'modules/customRoleDefinitions.bicep' = {
  name: 'custom_role_definition'
  params: {
    parAssignableScopeManagementGroupId: 'GSM'
  }
}
