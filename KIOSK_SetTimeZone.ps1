
# Function to set the time zone based on the state abbreviation in the device name.
Function SetTimeZone () {

    # Define the time zone mapping
    $timeZoneMap = @{
        "CT" = "Eastern"; "DE" = "Eastern"; "FL" = "Eastern"; "GA" = "Eastern"; 
        "ME" = "Eastern"; "MD" = "Eastern"; "MA" = "Eastern"; "MI" = "Eastern"; "NH" = "Eastern"; "NJ" = "Eastern"; 
        "NY" = "Eastern"; "NC" = "Eastern"; "OH" = "Eastern"; "PA" = "Eastern"; "RI" = "Eastern"; "SC" = "Eastern"; 
        "VT" = "Eastern"; "VA" = "Eastern"; "WV" = "Eastern";
        "AL" = "Central"; "AR" = "Central"; "IL" = "Central"; "IN" = "Central"; "IA" = "Central"; 
        "KS" = "Central"; "KY" = "Central"; "LA" = "Central"; "MN" = "Central"; "MS" = "Central"; "MO" = "Central"; 
        "NE" = "Central"; "OK" = "Central"; "TN" = "Central"; "TX" = "Central"; "WI" = "Central";
        "AZ" = "USMountain"; "CO" = "Mountain"; "ID" = "Mountain"; "MT" = "Mountain"; 
        "NM" = "Mountain"; "ND" = "Mountain"; "SD" = "Mountain"; "UT" = "Mountain"; "WY" = "Mountain";
        "CA" = "Pacific"; "NV" = "Pacific"; "OR" = "Pacific"; "WA" = "Pacific";
        "AK" = "Alaska";
        "HI" = "Hawaii-Aleutian"
    }

    # Get the computer name
    $computerName = $env:COMPUTERNAME

    # Extract the first two letters
    $stateCode = $computerName.Substring(0,2).ToUpper()

    # Determine the time zone
    if ($timeZoneMap.ContainsKey($stateCode)) {
        $timeZone = $timeZoneMap[$stateCode]
        Write-Output "The computer '$computerName' is in the '$timeZone' time zone.", ""

        switch($timeZone) {

            Eastern {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'Eastern Standard Time' -Verbose

            }

            Central {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'Central Standard Time' -Verbose

            }

            Mountain {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'Mountain Standard Time' -Verbose

            }

            USMountain {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'US Mountain Standard Time' -Verbose

            }

            Pacific {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'Pacific Standard Time' -Verbose

            }

            Hawaii-Aleutian {

                Write-Output "Setting $timeZone time zone...", ""

                Set-TimeZone -Id 'Hawaiian Standard Time' -Verbose

            }

            default {

                Write-Output "Unable to identify the time zone...", ""

            }

        }

    } else {

        Write-Output "State code '$stateCode' not found in the time zone mapping."
    
    }

}


SetTimeZone

