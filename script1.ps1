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
