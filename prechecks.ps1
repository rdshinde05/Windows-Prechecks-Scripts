#Windows Standard Prechecks script
#Version 1.0
Write-Host ' '
Write-Host ' Windows Standard Precheck Scripts '
Write-Host ' '
Write-Host ' '
Write-Output '****************Current Date is : *********************'
$date=Get-Date -Format g
echo $date
Write-Output '********************************************************'

Write-Host ' '
Write-Host ' '

echo '****************Hostname is : *********************'
$env:computername
echo $env
echo '********************************************************'

Write-Host ' '
Write-Host ' '

echo '****************Local Administrators Are: *********************'

$users= net localgroup Administrators
echo $users

echo '********************************************************'

Write-Host ' '
Write-Host ' '

echo '****************RDP Port Status : *********************'
#Port connectivity
test-connection $env:computername -Count 1 | Select Address
try
{
(New-Object System.Net.Sockets.TCPClient ($env:computername, 3389))
 
" "
Write-Host 'RDP is open'
}
catch
{
" "
Write-Host 'RDP in not connected' }
echo '********************************************************'

Write-Host ' '
Write-Host ' '

echo '****************ALL IP Address are : *********************'

echo "System IP Adress are as follows:-"
$ip=Get-WmiObject -query "select * from Win32_NetworkAdapterConfiguration where IPEnabled = $true" |
  Select-Object -Expand IPAddress | 
  Where-Object { ([Net.IPAddress]$_).AddressFamily -eq "InterNetwork" }
echo $ip

echo '**********************************************************'

Write-Host ' '
Write-Host ' '

echo '**************** IP Address are : *********************'
$ip = @(foreach ( $i in (get-wmiobject -class win32_networkadapter -filter "netconnectionstatus = 2" | select-object NetConnectionID ) ) { $i.NetConnectionID })

$ipsettings = @(foreach ( $j in (Get-WmiObject -class Win32_NetworkAdapterConfiguration -Namespace "root\CIMV2" | where { $_.IPEnabled -eq "True" } | select IPAddress) ) { $j.IPAddress[0] })


Write-Host 	" 	"	$ip[0]
Write-Host 	" 	"   $ipsettings[0]

Write-Host 	" 	"	$ip[1]
Write-Host 	" 	"   $ipsettings[1]

Write-Host 	" 	"	$ip[2]
Write-Host 	" 	"   $ipsettings[2]
echo '**********************************************************'


Write-Host ' '
Write-Host ' '

echo '****************Last system Patch Date is:*********************'

$patch=Get-HotFix | Where { $_.InstalledOn -gt "01/1/1990" -AND $_.InstalledOn -lt "12/30/2017" } | sort InstalledOn | Select-Object -Last 5

echo $patch | Format-Table | Out-String|% {Write-Host $_}
echo '***********************************************************'

Write-Host ' '
Write-Host ' '

echo '****************C Disk Space *********************'

Write-Host $env "Disk space in GB is as follows:-"
$disk=gwmi win32_logicaldisk -filter "deviceid='C:'" | Format-Table DeviceId, MediaType, @{n="Size";e={[math]::Round($_.Size/1GB,2)}},@{n="FreeSpace";e={[math]::Round($_.FreeSpace/1GB,2)}}
$disk | Format-Table | Out-String|% {Write-Host $_} 
 

echo '***************************************************'

Write-Host ' '
Write-Host ' '

echo '****************Services Status *********************'
#Can include any service name as per requirement
Get-Service BITS | Where-Object {$_.Status -eq "Running"}
Get-Service **SQL** | Where-object {$_.Status -eq "Running"}
Get-Service wuauserv | Where-object {$_.Status -eq "Running"}
if (Get-Service **Exchange** | Where-Object{$_.Status -eq "Running"})
{
Get-Service **Exchange** | Where-Object{$_.Status -eq "Running"}
}
else
{
" "
Write-Host "No Exchange service"
}
if (Get-Service **SAP** | Where-Object{$_.Status -eq "Running"})
{
Get-Service **SAP** | Where-Object{$_.Status -eq "Running"}
}
else
{
" "
Write-Host "No SAP service"
}
if (Get-Service **Cluster** | Where-Object{$_.Status -eq "Running"})
{
Get-Service **Cluster** | Where-Object{$_.Status -eq "Running"}
Get-ClusterNode
}
else
{
" "
Write-Host "No Cluster service"
}
echo '****************************** *********************'
 
Write-Host ' '
Write-Host ' '

