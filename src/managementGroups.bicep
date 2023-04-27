// deployment configuration for management groups. Wraps the module of the same name.

targetScope = 'tenant'

@description('Baseline resource configuration')
module baseline_managementgroups 'modules/managementGroups.bicep' = {
  name: 'baseline-alz-managementGroups'
  params: {
    // no parTopLevelManagementGroupParentId, deploy under tenant root group
    parTopLevelManagementGroupPrefix: 'GSM'
    parTopLevelManagementGroupDisplayName: 'Azure Landing Zones'
    parLandingZoneMgAlzDefaultsEnable: true
    parLandingZoneMgConfidentialEnable: false
  }
}
