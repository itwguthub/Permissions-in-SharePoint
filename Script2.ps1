##Script 2
#Set your directory where you want apply the changes 
$SiteUrl = "https://company.sharepoint.com/"
$FolderURL = "RootFolder/SubFolder"
 
Connect-PnPOnline -URL $SiteURL -UseWebLogin
 
#reset all teh permissions
Function Reset-SubFolderPermissions($FolderURL)
{
    #list all the sub folder
    $SubFolders = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderURL -ItemType Folder | Where {$_.Name -ne "Forms" -and $_.Name -ne "Document"}
 
    #just a loop
    ForEach($SubFolder in $SubFolders)
    {
        $SubFolderURL = $FolderUrl+"/"+$SubFolder.Name
        Write-host -ForegroundColor Green "Processing Folder '$($SubFolder.Name)' at $SubFolderURL"
 
        #list permissions
        $Folder = Get-PnPFolder -Url $SubFolderURL -Includes ListItemAllFields.HasUniqueRoleAssignments, ListItemAllFields.ParentList, ListItemAllFields.ID
  
        $FolderItem = $Folder.ListItemAllFields
 
        If($FolderItem.HasUniqueRoleAssignments)
        {
            #retest permission 
            Set-PnPListItemPermission -List $FolderItem.ParentList -Identity $FolderItem.ID -InheritPermissions
            Write-host "Unique Permissions are removed from the Folder!"
        }
        Reset-SubFolderPermissions $SubFolderURL
    }
}

Reset-SubFolderPermissions $FolderURL
