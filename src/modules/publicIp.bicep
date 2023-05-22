metadata name = 'ALZ Bicep - Public IP creation module'
metadata description = 'Module used to set up Public IP for Azure Landing Zones'

@sys.description('Azure Region to deploy Public IP Address to.')
param parLocation string = resourceGroup().location

@sys.description('Name of Public IP to create in Azure.')
param parPublicIpName string

@sys.description('Public IP Address SKU.')
param parPublicIpSku object

@sys.description('Properties of Public IP to be deployed.')
param parPublicIpProperties object

@allowed([
  '1'
  '2'
  '3'
])
@sys.description('Availability Zones to deploy the Public IP across. Region must support Availability Zones to use. If it does not then leave empty.')
param parAvailabilityZones array = []

@sys.description('Tags to be applied to resource when deployed.')
param parTags object = {}

resource resPublicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' ={
  name: parPublicIpName
  tags: parTags
  location: parLocation
  zones: parAvailabilityZones
  sku: parPublicIpSku
  properties: parPublicIpProperties
}

output outPublicIpId string = resPublicIp.id
