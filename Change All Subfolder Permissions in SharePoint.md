Change All Subfolder Permissions in SharePoint
This script will allow you to change all subfolder permissions in SharePoint. I will then revert the sub folders to inherit permissions from the root directory.

Just save the below 2 scripts as .ps1 for Powershell and then edit your Site URL and Folder URLs


##Script 1
##confirm the directory where you want to apply the changes
$SiteUrl = "https://company.sharepoint.com/"
$FolderURL = "RootFolder/SubFolder"
 
# Connect to the Site
Connect-PnPOnline -URL $SiteUrl -UseWebLogin
 
# Get the Folder
$Folder = Get-PnPFolder -Url $FolderURL

# List all subfolders
$SubFolders = Get-PnPFolderItem -FolderSiteRelativeUrl $FolderURL -ItemType Folder

# Display the names of the subfolders
$SubFolders | ForEach-Object {
    Write-Host $_.Name
}

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
