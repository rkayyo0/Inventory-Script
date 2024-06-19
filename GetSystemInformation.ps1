$csvPath = '\\10.23.1.103\Public\__Software\Inventory Script\PC Data.csv'
#Test if Path Exists 



if (Test-Path $csvPath){

# Create a custom object with the gathered data
$systemInfo = [PSCustomObject]@{
    SystemName            = (Get-WmiObject Win32_ComputerSystem).Name
    OSName               = (Get-ComputerInfo).OsName
    OSVersion            = (Get-ComputerInfo).OsVersion
    SystemType           = (Get-ComputerInfo).CsSystemType
    SystemManufacturer   = (Get-WmiObject Win32_ComputerSystem).Manufacturer
    Processor            = (Get-WmiObject Win32_Processor) | Select-Object -ExpandProperty Name
    Role                 = (Get-ComputerInfo).PowerPlatformRole
    RAM                  = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
    BaseboardProduct     = (Get-WmiObject Win32_Baseboard).Product
    BIOSVersion          = (Get-WmiObject -Class Win32_BIOS).Version
    BIOSMode             = $env:firmware_type
    BaseboardManufacturer = (Get-WmiObject Win32_Baseboard).Manufacturer
    DisplayName          = (Get-WmiObject Win32_PnPEntity | Where-Object { $_.PnPClass -eq 'Display' }).Name
    DiskModel            = (Get-WmiObject Win32_DiskDrive | Where-Object { $_.MediaType -eq 'Fixed hard disk media' }).Model
    DiskSizeGB           = [math]::Round((Get-WmiObject Win32_DiskDrive | Where-Object { $_.MediaType -eq 'Fixed hard disk media' }).Size / 1GB, 2)
}


    $systemInfo | Export-Csv -Path $csvPath -NoTypeInformation -Append

}else{
Write-Host "The path $csvPath does not exist" 

}


