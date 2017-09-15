# Get the parameter pass to the script
Param (

    # Set the script start loc to where the script located
    [string]$workdir = (Split-Path $MyInvocation.MyCommand.Path),

    # location of the folder contain file you want to do bulk rename (Default its the same location as where the script is)
    [string]$targetfolder = (Split-Path $MyInvocation.MyCommand.Path),
    
    # file filter (Default is all file with .txt extension)
    [string]$filefilter = '*.txt',
   
    # How many character to stripe off at the beginning of the file
    [int16]$stripoff = 0
)

$Files = Get-ChildItem -File -Filter $filefilter $targetfolder

$errcounter = 0

Foreach ($File in $Files)
{
    $Filename = $File.Name
    $FileFullPath = $File.FullName
    
    # Strip off the number of character in the file name user specified 
    $NewFileName = $Filename.Remove(0,$stripoff)

    # Remove any leading space
    $NewFilename = $NewFilename.TrimStart()

    # do the rename
    Rename-Item -LiteralPath $FileFullPath -NewName $NewFileName -ErrorVariable err
    If ($err)
    {
        Write-Host -BackgroundColor Red "Error to rename $File to $NewFileName"
        write-host -BackgroundColor Red "$err"
        $errcounter++
    }
}

If ($errcounter -gt 0)
{
    Write-host "Bulk Rename finished with $errcounter error"    
}
else 
{
    write-host "Bulk Rename finished with no error"    
}
Read-host "Press Enter to continue"