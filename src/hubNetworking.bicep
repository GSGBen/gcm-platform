targetScope = 'subscription'

@description('The Azure location to deploy to.')
param location string = deployment().location

resource hubNetworkingResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  location: location
  name: 'hubNetworkingResourceGroup'
}

@description('Baseline resource configuration')
module baseline_hub_networking 'modules/hubNetworking.bicep' = {
  name: 'baseline_hub_networking'
  scope: hubNetworkingResourceGroup
  params: {
    parLocation: location
    parAzBastionEnabled: false
    parDdosEnabled: false
    parAzFirewallEnabled: false
    parPrivateDnsZonesEnabled: false
    parAzFirewallDnsProxyEnabled: false
    parVpnGatewayConfig: {}
    parExpressRouteGatewayConfig: {}
  }
}
