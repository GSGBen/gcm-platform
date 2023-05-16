targetScope = 'managementGroup'

param parTopLevelManagementGroupPrefix string = 'GSM'

param parLogAnalyticsWorkspaceResourceId string

module baseline_diagnostic_settings 'modules/mgDiagSettingsAll.bicep' = {
  name: 'baseline_diagnostic_settings'
  params: {
    parTopLevelManagementGroupPrefix: parTopLevelManagementGroupPrefix
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}
