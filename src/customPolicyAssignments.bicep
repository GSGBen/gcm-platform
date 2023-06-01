// deployment configuration for custom policy assignments. Wraps the default assignments but can be extended

targetScope = 'managementGroup'

param parTopLevelManagementGroupPrefix string = 'GSM'

param parLogAnalyticsWorkspaceResourceId string

@description('Baseline resource configuration')
module baseline_policy 'modules/alzDefaultPolicyAssignments.bicep' = {
  name: 'baseline-alz-policy-assignments'
  params: {
    parTopLevelManagementGroupPrefix: 'GSM'
    parLogAnalyticsWorkSpaceAndAutomationAccountLocation: 'Australia East'
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
    parLogAnalyticsWorkspaceLogRetentionInDays: '365'
    parAutomationAccountName: '${parTopLevelManagementGroupPrefix}-automation-account'
    parMsDefenderForCloudEmailSecurityContact: 'ben@goldensyrupgames.com'
  }
}
