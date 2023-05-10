targetScope = 'managementGroup'

metadata name = 'ALZ Bicep - Custom Role Definitions'
metadata description ='Custom Role Definitions for ALZ Bicep'

@sys.description('The management group scope to which the role can be assigned. This management group ID will be used for the assignableScopes property in the role definition.')
param parAssignableScopeManagementGroupId string = 'alz'

module modRolesSubscriptionOwnerRole 'cafSubscriptionOwnerRole.bicep' = {
  name: 'deploy-subscription-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesApplicationOwnerRole 'cafApplicationOwnerRole.bicep' = {
  name: 'deploy-application-owner-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesNetworkManagementRole 'cafNetworkManagementRole.bicep' = {
  name: 'deploy-network-management-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

module modRolesSecurityOperationsRole 'cafSecurityOperationsRole.bicep' = {
  name: 'deploy-security-operations-role'
  params: {
    parAssignableScopeManagementGroupId: parAssignableScopeManagementGroupId
  }
}

output outRolesSubscriptionOwnerRoleId string = modRolesSubscriptionOwnerRole.outputs.outRoleDefinitionId
output outRolesApplicationOwnerRoleId string = modRolesApplicationOwnerRole.outputs.outRoleDefinitionId
output outRolesNetworkManagementRoleId string = modRolesNetworkManagementRole.outputs.outRoleDefinitionId
output outRolesSecurityOperationsRoleId string = modRolesSecurityOperationsRole.outputs.outRoleDefinitionId
