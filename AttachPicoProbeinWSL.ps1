# 
# Attach Raspberry Pi Pico Debug Probe to WSL
# 8/2024 Frank Hoedemakers
#


# Define the path to usbipd.exe
$usbipdPath = "C:\Program Files\usbipd-win\usbipd.exe"

# Check if the usbipd.exe exists
if (-Not (Test-Path $usbipdPath)) {
    Write-Host "usbipd not installed. To install, start an Admin command prompt and execute line below:"
    Write-Host 
    Write-Host "winget install usbipd"
    Write-Host
    Write-Host "See also https://github.com/dorssel/usbipd-win"
    exit
}

# Run usbipd.exe and capture the output
$usbipdOutput = & "$usbipdPath" list
# Split the output into lines
$lines = $usbipdOutput -split "`n"
$found = $false
# Loop through each line, skipping the first one (assuming it's the header)
foreach ($line in $lines[1..$lines.Length]) {
    # Check if the line is long enough to contain the expected columns
    if ($line.Length -lt 77) {
         continue
    }
    # Extract each column based on the fixed-length positions
    $busid  = $line.Substring(0, 7).Trim()
    $vidpid = $line.Substring(7, 10).Trim()
    $device = $line.Substring(17, 60).Trim()
    $state  = $line.Substring(77).Trim()
    # Check if the DEVICE column starts with "CMSIS-DAP"
    if ($device -like "CMSIS-DAP*") {
        $found = $true
        # Make sure wsl is active
        & C:\Windows\System32\wsl.exe --system date
        # Take action based on the STATE
        switch ($state) {
            "Shared" {
                # Run the attach command and capture the output and error
                $attachOutput = & "$usbipdPath" attach --wsl --busid $busid 2>&1

                # Flag to check if the message was informational
                $isInformational = $false

                # Check each line in the output. Successful attach is handled as an error in powershell. So handle this.
                foreach ($outputLine in $attachOutput) {
                    if ($outputLine -match "usbipd: info: Using WSL distribution 'Ubuntu'") {
                        $isInformational = $true
                        break
                    }
                }

                # Handle the output based on the check
                if ($isInformational) {
                    Write-Output "Successfully attached $device with BUSID $busid"
                    Write-Output ""
                    Start-Sleep -Seconds 3
                    Write-Output "Output of commmand lsusb in WSL:"
                    & C:\Windows\System32\wsl.exe /usr/bin/lsusb
                } else {
                    Write-Error ($attachOutput -join "`n")
                }
            }
            "Attached" {
                Write-Output "$device with BUSID $busid is already Attached."
                Write-Output ""
                Write-Output "Output of commmand lsusb in WSL:"
                 & C:\Windows\System32\wsl.exe /usr/bin/lsusb
            }
            "Not shared" {
                Write-Output "Please share the device first. You only have to do this once or when the busid changes."
                Write-Output "Run cmd.exe or powershell as Administrator and execute this command:"
                Write-Output "usbipd bind --busid $busid"
            }
            default {
                Write-Output "Unknown state: $state."
            }
        }
        break;
    }
}
if ( $found -eq $false ) {
    write-host "No Pico Debug Probe (CMSIS-DAP) device found"
}
# Comment line below if you want to silently exit 
$enter = Read-Host "Press ENTER to continue"

