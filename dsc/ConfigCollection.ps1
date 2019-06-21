xRDSessionCollectionConfiguration ConfigCollection
        {
            DependsOn = "[xRDSessionCollection]Collection"

            CollectionName = $collectionName

            CollectionDescription = $collectionDescription

            PsDscRunAsCredential = $domainCreds

            EnableUserProfileDisk = $true

            DiskPath = '\\fs-vm\UserProfileDisks'

            AutomaticReconnectionEnabled = $true

            MaxUserProfileDiskSizeGB = '5'

            DisconnectedSessionLimitMin = '30'

            IdleSessionLimitMin = '30'
        }    

    }