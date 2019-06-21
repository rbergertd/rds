Configuration RDSHConfig
{
	Import-DscResource -Module PSDesiredStateConfiguration, xRemoteDesktopSessionHost
	
    Node localhost
    {
        xRDSessionCollectionConfiguration EnableUPD
        {
            CollectionName = 'AD Collection'

            #DependsOn = "[xRDSessionCollection]Collection"

            DiskPath = '\\fs-vm\UserProfileDisks'

            EnableUserProfileDisk = $true

            MaxUserProfileDiskSizeGB = '5'

            DisconnectedSessionLimitMin = '30'

            IdleSessionLimitMin = '30'

        }
    }
}
    
    RDSHConfig -OutputPath C:\
    Start-DscConfiguration -Force -Wait -path C:\ -ComputerName localhost -Verbose