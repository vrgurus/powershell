# Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

Param (
    
    [Parameter(Mandatory=$True)]
    [string] $file,

    [Parameter(Mandatory=$False)]
    [string] $MD5 = $null,

    [Parameter(Mandatory=$False)]
    [string] $SHA256 = $null

)

$hash_list = @('MD5', 'SHA256')
$md5_calculated = $null
$sha256_calculated = $null

For ($i=0; $i -lt $hash_list.Length; $i++) {

        $hash = $hash_list[$i]
        $hashFromFile = Get-FileHash -Path $file -Algorithm $hash

        # Open $file as a stream
        $stream = [System.IO.File]::OpenRead($file)
        $hashFromStream = Get-FileHash -InputStream $stream -Algorithm $hash
        $stream.Close()

        Write-Host "$hash Hash from File  : $($hashFromFile.Hash)" #-NoNewline
        Write-Host "$hash Hash from Stream: $($hashFromStream.Hash)" #-NoNewline

        if ($hash -eq 'MD5'){
            $md5_calculated = $hashFromFile.Hash 
            if ($MD5.Length -gt 0) {
                Write-Host "supplied $hash Hash   : $($MD5.toUpper())"
                if ($MD5 -eq $md5_calculated) {
	                Write-Host 'MD5 match with supplied value' -ForegroundColor Green
                } else {
	                Write-Host 'MD5 inconsistent with supplied value!!' -ForegroundColor Red
                }
            }
        }
        elseif ($hash -eq 'SHA256'){
            $sha256_calculated = $hashFromFile.Hash         
            if ($SHA256.Length -gt 0) {
                Write-Host "supplied $hash Hash   : $($SHA256.toUpper())"
                if ($SHA256 -eq $sha256_calculated) {
	                Write-Host 'SHA256 match with supplied value' -ForegroundColor Green
                } else {
	                Write-Host 'SHA256 inconsistent with supplied value!!' -ForegroundColor Red
                }
            }
        } 

        # Check both hashes are the same
        if ($hashFromFile.Hash -eq $hashFromStream.Hash) {
	        Write-Host "$hash results are consistent" -ForegroundColor Green
        } else {
	        Write-Host "$hash results are inconsistent!!" -ForegroundColor Red
        }

    }



