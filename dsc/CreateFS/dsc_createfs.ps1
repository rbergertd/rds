Configuration FileServer
{
	param 
    ( 
        [Parameter(Mandatory)]
        [String]$domainName,

        [Parameter(Mandatory)]
        [PSCredential]$adminCreds
	) 
	
	Import-DscResource -Module PSDesiredStateConfiguration, xStorage, xSmbShare, cNtfsAccessControl, xComputerManagement
	
	Node localhost
	{
		DomainJoin DomainJoin
        {
            domainName = $domainName 
            adminCreds = $adminCreds 
        }

		WindowsFeature 'FileServices'
        {
            Ensure = 'Present'
            Name = 'File-Services'
		}
		
        xWaitforDisk Disk2
        {
            DiskNumber = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        xDisk UPDDisk {
            DiskNumber = 2
            DriveLetter = "F"
            FSLabel = "UserProfileDisks"
            DependsOn = "[xWaitForDisk]Disk2"
        }

        xWaitforDisk Disk3
        {
            DiskNumber = 3
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        xDisk NetwrkShr {
            DiskNumber = 3
            DriveLetter = "G"
            FSLabel = "Data"
            DependsOn = "[xWaitForDisk]Disk3"
        }
        
        File 'UPD'
		{
			Ensure = 'Present'
			Type = 'Directory'
			DestinationPath = 'F:\UserProfileDisks'
		}
		
		File 'Data'
		{
			Ensure = 'Present'
			Type = 'Directory'
			DestinationPath = 'G:\AutoDesk Network Share'
		}
		
		xSmbShare 'Share1'
		{
			Ensure = 'Present'
			Name   = 'UserProfileDisks'
			Path = 'F:\UserProfileDisks'
			FullAccess = 'Everyone'
			DependsOn = '[File]UPD'
		}
		
		xSmbShare 'Share2'
		{
			Ensure = 'Present'
			Name   = 'AutoDeskNetwork Share'
			Path = 'G:\AutoDesk Network Share'
			FullAccess = 'Everyone'
			DependsOn = '[File]Data'
		}
		
		cNtfsPermissionEntry 'UPD Permissions' {
			Ensure = 'Present'
			DependsOn = "[File]UPD"
			Principal = 'Authenticated Users'
			Path = 'F:\UserProfileDisks'
			AccessControlInformation = @(
				cNtfsAccessControlInformation
				{
					AccessControlType = 'Allow'
					FileSystemRights = 'Read'
					Inheritance = 'ThisFolderSubfoldersAndFiles'
					NoPropagateInherit = $false
				}
			)
		}
		
		cNtfsPermissionEntry 'Data Permissions' {
			Ensure = 'Present'
			DependsOn = "[File]Data"
			Principal = 'Authenticated Users'
			Path = 'G:\AutoDesk Network Share'
			AccessControlInformation = @(
				cNtfsAccessControlInformation
				{
					AccessControlType = 'Allow'
					FileSystemRights = 'Read'
					Inheritance = 'ThisFolderSubfoldersAndFiles'
					NoPropagateInherit = $false
				}
			)
		}
		
	}
}