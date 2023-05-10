// deployment configuration for custom policy assignments. Wraps the default assignments but can be extended

// PLACEHOLDER - other IAC needs to be deployed first

targetScope = 'managementGroup'

@description('Baseline resource configuration')
module baseline_policy 'modules/alzDefaultPolicyAssignments.bicep' = {
  name: 'baseline-alz-policy-assignments'
  params: {
    parTopLevelManagementGroupPrefix: 'GSM'
    parLogAnalyticsWorkSpaceAndAutomationAccountLocation: 'Australia East'
    parLogAnalyticsWorkspaceResourceId: '/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/alz-logging/providers/Microsoft.OperationalInsights/workspaces/alz-log-analytics'
    parLogAnalyticsWorkspaceLogRetentionInDays: '365'
    parAutomationAccountName: 'alz-automation-account'
    parMsDefenderForCloudEmailSecurityContact: 'security_contact@replace_me.com'
  }
}
