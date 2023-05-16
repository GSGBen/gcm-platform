targetScope = 'managementGroup'

metadata name = 'ALZ Bicep orchestration - Management Group Diagnostic Settings - ALL'
metadata description = 'Orchestration module that helps enable Diagnostic Settings on the Management Group hierarchy as was defined during the deployment of the Management Group module'

@sys.description('Prefix used for the management group hierarchy in the managementGroups module. Default: alz')
@minLength(2)
@maxLength(10)
param parTopLevelManagementGroupPrefix string = 'alz'

@sys.description('Optional suffix for the management group hierarchy. This suffix will be appended to management group names/IDs. Include a preceding dash if required. Example: -suffix')
@maxLength(10)
param parTopLevelManagementGroupSuffix string = ''

@sys.description('Array of strings to allow additional or different child Management Groups of the Landing Zones Management Group.')
param parLandingZoneMgChildren array = []

@sys.description('Array of strings to allow additional or different child Management Groups of the Platform Management Group.')
param parPlatformMgChildren array = []

@sys.description('Log Analytics Workspace Resource ID.')
param parLogAnalyticsWorkspaceResourceId string

@sys.description('Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true')
param parLandingZoneMgAlzDefaultsEnable bool = true

@sys.description('Deploys Corp & Online Management Groups beneath Landing Zones Management Group if set to true. Default: true')
param parPlatformMgAlzDefaultsEnable bool = true

@sys.description('Deploys Confidential Corp & Confidential Online Management Groups beneath Landing Zones Management Group if set to true. Default: false')
param parLandingZoneMgConfidentialEnable bool = false

var varMgIds = {
  intRoot: '${parTopLevelManagementGroupPrefix}${parTopLevelManagementGroupSuffix}'
  platform: '${parTopLevelManagementGroupPrefix}-platform${parTopLevelManagementGroupSuffix}'
  landingZones: '${parTopLevelManagementGroupPrefix}-landingzones${parTopLevelManagementGroupSuffix}'
  decommissioned: '${parTopLevelManagementGroupPrefix}-decommissioned${parTopLevelManagementGroupSuffix}'
  sandbox: '${parTopLevelManagementGroupPrefix}-sandbox${parTopLevelManagementGroupSuffix}'
}

// Used if parLandingZoneMgAlzDefaultsEnable == true
var varLandingZoneMgChildrenAlzDefault = {
  landingZonesCorp: '${parTopLevelManagementGroupPrefix}-landingzones-corp${parTopLevelManagementGroupSuffix}'
  landingZonesOnline: '${parTopLevelManagementGroupPrefix}-landingzones-online${parTopLevelManagementGroupSuffix}'
}

// Used if parPlatformMgAlzDefaultsEnable == true
var varPlatformMgChildrenAlzDefault = {
  platformManagement: '${parTopLevelManagementGroupPrefix}-platform-management${parTopLevelManagementGroupSuffix}'
  platformConnectivity: '${parTopLevelManagementGroupPrefix}-platform-connectivity${parTopLevelManagementGroupSuffix}'
  platformIdentity: '${parTopLevelManagementGroupPrefix}-platform-identity${parTopLevelManagementGroupSuffix}'
}

// Used if parLandingZoneMgConfidentialEnable == true
var varLandingZoneMgChildrenConfidential = {
  landingZonesConfidentialCorp: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-corp${parTopLevelManagementGroupSuffix}'
  landingZonesConfidentialOnline: '${parTopLevelManagementGroupPrefix}-landingzones-confidential-online${parTopLevelManagementGroupSuffix}'
}

// Used if parLandingZoneMgConfidentialEnable not empty
var varLandingZoneMgCustomChildren = [for customMg in parLandingZoneMgChildren: {
  mgId: '${parTopLevelManagementGroupPrefix}-landingzones-${customMg}${parTopLevelManagementGroupSuffix}'
}]

// Used if parLandingZoneMgConfidentialEnable not empty
var varPlatformMgCustomChildren = [for customMg in parPlatformMgChildren: {
  mgId: '${parTopLevelManagementGroupPrefix}-platform-${customMg}${parTopLevelManagementGroupSuffix}'
}]

// Build final object based on input parameters for default and confidential child MGs of LZs
var varLandingZoneMgDefaultChildrenUnioned = (parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable) ? union(varLandingZoneMgChildrenAlzDefault, varLandingZoneMgChildrenConfidential) : (parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable) ? varLandingZoneMgChildrenAlzDefault : (!parLandingZoneMgAlzDefaultsEnable && parLandingZoneMgConfidentialEnable) ? varLandingZoneMgChildrenConfidential : (!parLandingZoneMgAlzDefaultsEnable && !parLandingZoneMgConfidentialEnable) ? {} : {}

// Build final object based on input parameters for default child MGs of Platform LZs
var varPlatformMgDefaultChildrenUnioned = (parPlatformMgAlzDefaultsEnable) ? varPlatformMgChildrenAlzDefault : (parPlatformMgAlzDefaultsEnable) ? varPlatformMgChildrenAlzDefault : (!parPlatformMgAlzDefaultsEnable) ? {} : (!parPlatformMgAlzDefaultsEnable) ? {} : {}

module modMgDiagSet 'mgDiagSettings.bicep' = [for mgId in items(varMgIds): {
  scope: managementGroup(mgId.value)
  name: 'mg-diag-set-${mgId.value}'
  params: {
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}]

// Default Children Landing Zone Management Groups
module modMgLandingZonesDiagSet 'mgDiagSettings.bicep' = [for childMg in items(varLandingZoneMgDefaultChildrenUnioned): {
  scope: managementGroup(childMg.value)
  name: 'mg-diag-set-${childMg.value}'
  params: {
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}]

// Default Children Platform Management Groups
module modMgPlatformDiagSet 'mgDiagSettings.bicep' = [for childMg in items(varPlatformMgDefaultChildrenUnioned): {
  scope: managementGroup(childMg.value)
  name: 'mg-diag-set-${childMg.value}'
  params: {
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}]

// Custom Children Landing Zone Management Groups
module modMgChildrenDiagSet 'mgDiagSettings.bicep' = [for childMg in varLandingZoneMgCustomChildren: {
  scope: managementGroup(childMg.mgId)
  name: 'mg-diag-set-${childMg.mgId}'
  params: {
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}]

// Custom Children Platform Management Groups
module modPlatformMgChildrenDiagSet 'mgDiagSettings.bicep' = [for childMg in varPlatformMgCustomChildren: {
  scope: managementGroup(childMg.mgId)
  name: 'mg-diag-set-${childMg.mgId}'
  params: {
    parLogAnalyticsWorkspaceResourceId: parLogAnalyticsWorkspaceResourceId
  }
}]
