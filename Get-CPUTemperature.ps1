function Get-CPUTemperature {
    $temperatures = @()

    # Query thermal zone temperature information using CIM cmdlets
    $thermalZoneTemperatures = Get-CimInstance -ClassName MSAcpi_ThermalZoneTemperature -Namespace "root/wmi"

    # Iterate through each temperature reading
    foreach ($temperature in $thermalZoneTemperatures.CurrentTemperature) {
        # Calculate temperature in Celsius
        $celsius = $temperature / 10 - 273.15
        
        # Calculate temperature in Fahrenheit
        $fahrenheit = ($celsius * 9/5) + 32

        # Create a custom object to store temperature data
        $temperatureData = [PSCustomObject]@{
            Celsius = $celsius
            Fahrenheit = $fahrenheit
        }

        # Add the temperature data to the array
        $temperatures += $temperatureData
    }

    # Return the array of temperature data
    $temperatures
}
