# Virtuemart SVN
$svn_default = 'https://dev.virtuemart.net/svn/virtuemart/trunk/virtuemart/'

# Main folders
$working_directory_path_default = 'C:/Virtuemart SVN/'

# Change virtuemart version
$virtuemart_version_default = '4.0.20'
$virtuemart_release_type_default = 'BUGFIX'
$virtuemart_code_name_default = 'Eagle owl'

# ---------------------------------------------------------------------------------------------------
# --------------------------------- Nothing to change from here on! ---------------------------------
# ---------------------------------------------------------------------------------------------------

$lines = "----------------------------------------------------------------------------------------"
Write-Host $lines
Write-Host $lines
Write-Host $lines
Write-Host "Script to generate new Virtuemart-Package from SVN"
Write-Host $lines
Write-Host $lines
Write-Host $lines

Write-Host "Press enter to use the default [] values"
Write-Host $lines

if (!($svn = Read-Host "SVN URL [$svn_default]")) { $svn = $svn_default }
if (!($working_directory_path = Read-Host "Working Directory [$working_directory_path_default]")) { $working_directory_path = $working_directory_path_default }
if (!($virtuemart_version = Read-Host "Virtuemart-Version [$virtuemart_version_default]")) { $virtuemart_version = $virtuemart_version_default }
if (!($virtuemart_release_type = Read-Host "Virtuemart-Release-Type [$virtuemart_release_type_default]")) { $virtuemart_release_type = $virtuemart_release_type_default }
if (!($virtuemart_code_name = Read-Host "Virtuemart-Code-Name [$virtuemart_code_name_default]")) { $virtuemart_code_name = $virtuemart_code_name_default }

# Main joomla folder variables
$administrator = 'administrator'
$components = 'components'
$libraries = 'libraries'
$modules = 'modules'
$package = 'package'
$plugins = 'plugins'
$templates = 'templates'

$component_name_tcpdf = 'com_tcpdf'
$vmbeez3 = 'vmbeez3'
$horme_3 = 'horme_3'

$path_delimiter = '/';
Write-Host $lines
Write-Host $lines
Write-Host $lines
Write-Host "Start generating Virtuemart from SVN"
Write-Host $lines

# ---------------------------------------------------------------------------------------------------
# Get files from SVN
# ---------------------------------------------------------------------------------------------------

$svn_directory = 'svn'
$svn_directory_path = $working_directory_path + $svn_directory + $path_delimiter

if (Test-Path $svn_directory_path) {
   Write-Host 'Removing previous SVN folder: '$svn_directory_path
   Remove-Item $svn_directory_path -Recurse -Force
}

Write-Host 'Creating new SVN folder: '$svn_directory_path
New-Item -Path $svn_directory_path -ItemType Directory | Out-Null

Write-Host 'Download from SVN: '$svn
svn checkout $svn $svn_directory_path --quiet

# ---------------------------------------------------------------------------------------------------
# Generate variables from SVN
# ---------------------------------------------------------------------------------------------------

$virtuemart_revision = svn info --show-item revision $working_directory_path$svn_directory
$virtuemart_release_date = svn info --show-item last-changed-date $working_directory_path$svn_directory
$virtuemart_release_date = [DateTime]$virtuemart_release_date
$virtuemart_release_date = $virtuemart_release_date.ToString("D", [cultureinfo]::GetCultureInfo('en-US'))

$pattern = "<version>(.*?)</version>"

$file = Get-Content $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name_tcpdf$path_delimiter"tcpdf.xml"
$tcpdf_version = [regex]::Match($file,$pattern).Groups[1].Value

$file = Get-Content $svn_directory_path$templates$path_delimiter$vmbeez3$path_delimiter"templateDetails.xml"
$template_vmbeez3_version = [regex]::Match($file,$pattern).Groups[1].Value

$file = Get-Content $svn_directory_path$templates$path_delimiter$horme_3$path_delimiter"templateDetails.xml"
$template_horme_3_version = [regex]::Match($file,$pattern).Groups[1].Value

# ---------------------------------------------------------------------------------------------------
# Generate package
# ---------------------------------------------------------------------------------------------------

Write-Host $lines

$package_directory = 'com_virtuemart.' + $virtuemart_version + '.' + $virtuemart_revision + '_package_or_extract'
$package_directory_path = $working_directory_path + $package_directory + $path_delimiter

if (Test-Path $package_directory_path) {
   Write-Host 'Removing previous Package folder: '$package_directory_path
   Remove-Item $package_directory_path -Recurse -Force | Out-Null
}

Write-Host 'Create package'

# ---------------------------------------------------------------------------------------------------
# Core files
# ---------------------------------------------------------------------------------------------------

$installer_core_directory = 'com_virtuemart.' + $virtuemart_version + '.' + $virtuemart_revision
$install = 'install';
$component_name = 'com_virtuemart'
$installer_xml = 'virtuemart.xml'
$vm_build = 'vm_build'
$readme_txt = 'README-VIRTUEMART.txt'

#Write-Host 'Copy Admin folder'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name$path_delimiter -Destination $package_directory_path$installer_core_directory$path_delimiter$administrator$path_delimiter$components$path_delimiter$component_name$path_delimiter -Recurse
#Write-Host 'Copy Installation folder'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name$path_delimiter$install$path_delimiter -Destination $package_directory_path$installer_core_directory$path_delimiter$install$path_delimiter -Recurse
#Write-Host 'Copy Installation XML'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name$path_delimiter$installer_xml -Destination $package_directory_path$installer_core_directory$path_delimiter$installer_xml
#Write-Host 'Copy Components folder'
Copy-Item -Force -Path $svn_directory_path$components$path_delimiter$component_name$pat_delimiter -Destination $package_directory_path$installer_core_directory$path_delimiter$components$path_delimiter$component_name$path_delimiter -Recurse
#Write-Host 'Copy Readme TXT'
Copy-Item -Force -Path $svn_directory_path$vm_build$path_delimiter$readme_txt -Destination $package_directory_path$installer_core_directory$path_delimiter$readme_txt


# ---------------------------------------------------------------------------------------------------
# AIO files
# ---------------------------------------------------------------------------------------------------

$installer_aio_directory = $installer_core_directory + '_ext_aio'
$component_name_aio = $component_name + '_allinone'
#Write-Host 'Copy AIO libraries folder'
Copy-Item -Force -Path $svn_directory_path$libraries -Destination $package_directory_path$installer_aio_directory$path_delimiter$libraries$path_delimiter -Recurse
#Write-Host 'Copy AIO modules folder'
Copy-Item -Force -Path $svn_directory_path$modules -Destination $package_directory_path$installer_aio_directory$path_delimiter$modules$path_delimiter -Recurse
#Write-Host 'Copy AIO plugins folder'
Copy-Item -Force -Path $svn_directory_path$plugins -Destination $package_directory_path$installer_aio_directory$path_delimiter$plugins$path_delimiter -Recurse
#Write-Host 'Copy AIO modulesBE folder'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$modules -Destination $package_directory_path$installer_aio_directory$path_delimiter$modules'BE'$path_delimiter -Recurse
#Write-Host 'Copy AIO Installation files'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name_aio$path_delimiter'*' -Destination $package_directory_path$installer_aio_directory$path_delimiter -Recurse

# ---------------------------------------------------------------------------------------------------
# TCPDF files
# ---------------------------------------------------------------------------------------------------

$installer_tcpdf_directory = 'com_tcpdf_' + $tcpdf_version
$src_path = 'src' + $path_delimiter + 'Document' + $path_delimiter
$vendor_path = 'vendor' + $path_delimiter + 'tecnickcom'
#Write-Host 'Copy TCPDF files'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$components$path_delimiter$component_name_tcpdf$path_delimiter -Destination $package_directory_path$installer_tcpdf_directory$path_delimiter -Recurse
Copy-Item -Force -Path $svn_directory_path$libraries$path_delimiter$src_path -Destination $package_directory_path$installer_tcpdf_directory$path_delimiter$src_path -Recurse
Copy-Item -Force -Path $svn_directory_path$libraries$path_delimiter$vendor_path -Destination $package_directory_path$installer_tcpdf_directory$path_delimiter$libraries$path_delimiter$vendor_path -Recurse

# ---------------------------------------------------------------------------------------------------
# VMAdmin Template files
# ---------------------------------------------------------------------------------------------------
$installer_vmadmin_directory = 'vmadmin_' + $virtuemart_version + '.' + $virtuemart_revision
$vmadmin = 'vmadmin'
#Write-Host 'Copy vmadmin templates files'
Copy-Item -Force -Path $svn_directory_path$administrator$path_delimiter$templates$path_delimiter$vmadmin$path_delimiter -Destination $package_directory_path$installer_vmadmin_directory$path_delimiter -Recurse

# ---------------------------------------------------------------------------------------------------
# VMBeez3 Template files
# ---------------------------------------------------------------------------------------------------

$installer_vmbeez3_directory = 'vmbeez3_' + $template_vmbeez3_version
#Write-Host 'Copy vmbeez3 templates files'
Copy-Item -Force -Path $svn_directory_path$templates$path_delimiter$vmbeez3 -Destination $package_directory_path$installer_vmbeez3_directory$path_delimiter -Recurse

# ---------------------------------------------------------------------------------------------------
# Horme3 Template files
# ---------------------------------------------------------------------------------------------------

$installer_horme_3_directory = 'horme_3_' + $template_horme_3_version
#Write-Host 'Copy horme_3 templates files'
Copy-Item -Force -Path $svn_directory_path$templates$path_delimiter$horme_3 -Destination $package_directory_path$installer_horme_3_directory$path_delimiter -Recurse

# ---------------------------------------------------------------------------------------------------
# Package installer files
# ---------------------------------------------------------------------------------------------------

#Write-Host 'Copy package installer files'
Copy-Item -Force -Path $svn_directory_path$package$path_delimiter'*' -Destination $package_directory_path -Recurse

# ---------------------------------------------------------------------------------------------------
# Change ${PHING.xxx} variables
# ---------------------------------------------------------------------------------------------------

Write-Host 'Change ${PHING.xxx} variables in all files'

$virtuemart_year = get-date -Format yyyy
$virtuemart_copyright = 'Copyright (C) 2004 - ' + $virtuemart_year + ' Virtuemart Team. All rights reserved.'
Get-ChildItem -Path $package_directory_path -Recurse -Include('*.php', '*.xml') | Foreach-Object {
    if (-not($_.PSIsContainer)) {
         #Write-Host 'Change ${PHING.xxx} variables: '$_.FullName
         $filetext = Get-Content $_.FullName -Raw   
         $filetext = $filetext -replace '\${PHING.VM.PRODUCT}', 'VirtueMart'
         $filetext = $filetext -replace '\${PHING.VM.RELEASE}', $virtuemart_version
         $filetext = $filetext -replace '\${PHING.VM.DEV_STATUS}', $virtuemart_release_type
         $filetext = $filetext -replace '\${PHING.VM.CODENAME}', $virtuemart_code_name
         $filetext = $filetext -replace '\${PHING.VM.RELDATE}', $virtuemart_release_date
         $filetext = $filetext -replace '\${PHING.VM.RELTIME}', '0000'
         $filetext = $filetext -replace '\${PHING.VM.RELTZ}', 'GMT'
         $filetext = $filetext -replace '\${PHING.VM.REVISION}', $virtuemart_revision
         $filetext = $filetext -replace '\${PHING.VM.COPYRIGHT}', $virtuemart_copyright
         $filetext = $filetext -replace '\${PHING.VM.MAINTAINERURL}', 'https://virtuemart.net'
         $filetext = $filetext -replace '\${PHING.VM.UPDATEFOLDER}', 'http://virtuemart.net/releases/vm3/'
         $filetext = $filetext -replace '\${PHING.VM.YEAR}', $virtuemart_year
         $filetext = $filetext -replace '\${PHING.VM.MAINTAINER}', 'The VirtueMart Team'
         $filetext = $filetext -replace '\${component.name}', 'com_virtuemart'
         $filetext = $filetext -replace '\${vm.version}', $virtuemart_version
         Set-Content $_.FullName $filetext
         #[GC]::Collect()
    }
}

# ---------------------------------------------------------------------------------------------------
# Zip folders
# ---------------------------------------------------------------------------------------------------

Write-Host 'Compress all generated folders into individual archives'
# Compress-Archive does not work properly - Joomla cannot expand the packages - use 7z instead...
# Compress-Archive -Path $package_directory_path$installer_core_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_core_directory'.zip' | Out-Null
# Compress-Archive -Path $package_directory_path$installer_aio_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_aio_directory'.zip' | Out-Null
# Compress-Archive -Path $package_directory_path$installer_tcpdf_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_tcpdf_directory'.zip' | Out-Null
# Compress-Archive -Path $package_directory_path$installer_vmadmin_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_vmadmin_directory'.zip' | Out-Null
# Compress-Archive -Path $package_directory_path$installer_vmbeez3_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_vmbeez3_directory'.zip' | Out-Null
# Compress-Archive -Path $package_directory_path$installer_horme_3_directory$path_delimiter'*' -DestinationPath $package_directory_path$installer_horme_3_directory'.zip' | Out-Null
7z.exe a $package_directory_path$installer_core_directory'.zip' $package_directory_path$installer_core_directory$path_delimiter'*' | Out-Null
7z.exe a $package_directory_path$installer_aio_directory'.zip' $package_directory_path$installer_aio_directory$path_delimiter'*' | Out-Null
7z.exe a $package_directory_path$installer_tcpdf_directory'.zip' $package_directory_path$installer_tcpdf_directory$path_delimiter'*' | Out-Null
7z.exe a $package_directory_path$installer_vmadmin_directory'.zip' $package_directory_path$installer_vmadmin_directory$path_delimiter'*' | Out-Null
7z.exe a $package_directory_path$installer_vmbeez3_directory'.zip' $package_directory_path$installer_vmbeez3_directory$path_delimiter'*' | Out-Null
7z.exe a $package_directory_path$installer_horme_3_directory'.zip' $package_directory_path$installer_horme_3_directory$path_delimiter'*' | Out-Null

# ---------------------------------------------------------------------------------------------------
# Remove folders
# ---------------------------------------------------------------------------------------------------

Write-Host 'Remove folders'
Remove-Item $package_directory_path$installer_core_directory -Recurse
Remove-Item $package_directory_path$installer_aio_directory -Recurse
Remove-Item $package_directory_path$installer_tcpdf_directory -Recurse
Remove-Item $package_directory_path$installer_vmadmin_directory -Recurse
Remove-Item $package_directory_path$installer_vmbeez3_directory -Recurse
Remove-Item $package_directory_path$installer_horme_3_directory -Recurse

# ---------------------------------------------------------------------------------------------------
# Zip Main folder
# ---------------------------------------------------------------------------------------------------

Write-Host 'Compress whole folder'
$resulting_zip = $package_directory + '.zip'
# Compress-Archive does not work properly - Joomla cannot expand the packages - use 7z instead...
# Compress-Archive -Path $package_directory_path -DestinationPath $working_directory_path$resulting_zip | Out-Null
7z.exe a $working_directory_path$resulting_zip $package_directory_path'*' | Out-Null

# ---------------------------------------------------------------------------------------------------
# DONE
# ---------------------------------------------------------------------------------------------------

Write-Host $lines
Write-Host $lines
Write-Host $lines
Write-Host 'A fresh Virtuemart installation package from SVN is now created and can be found here:'
Write-Host $working_directory_path$resulting_zip
Write-Host $lines
Write-Host $lines
Write-Host $lines
Write-Host "Press any key to exit the script..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
