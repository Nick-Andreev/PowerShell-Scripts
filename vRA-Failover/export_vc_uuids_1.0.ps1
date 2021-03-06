<#

.SYNOPSIS
This script exports UUIDs of all VMs registered in a vCenter to a file in
CSV format.

.DESCRIPTION
VMware uses two UUIDs to identify VMs, BIOS UUID (uuid.bios in .vmx file)
derived from hardware VM is running on and Instance UUID (vc.uuid in .vmx 
file) generated by vCenter. This script exports Instance UUIDs only.

.PARAMETER VIServerName
VMware vCenter server host name or IP address

.PARAMETER OutputFileName
File name for the output CSV file.

.EXAMPLE
.\export_vc_uuids_1.0.ps1 -VIServerName vc01.acme.com -OutputFileName vm_vc_uuids.csv

.NOTES
VMware PowerCLI is requred for script to run
   
.LINK
http://niktips.wordpress.com

#>

Param(
	[Parameter(Mandatory = $true)][string]$VIServerName,
	[Parameter(Mandatory = $true)][string]$OutputFileName
)

Connect-ViServer $VIServerName | out-null
if(!$?) { exit }

$all_vms = Get-VM
"VM_Name, Instance_UUID" | Out-File -filepath $OutputFileName
foreach ($vm in $all_vms) {
	"$($vm.Name), $($vm.extensiondata.config.InstanceUUID)" | Out-File -filepath $OutputFileName -append
}

Disconnect-VIServer -confirm:$false
