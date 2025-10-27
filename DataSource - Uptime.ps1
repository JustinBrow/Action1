[timespan]$timeSpan = [timespan]::FromSeconds([Diagnostics.Stopwatch]::GetTimestamp() / [Diagnostics.Stopwatch]::Frequency)

$output = [PSCustomObject]@{
   'Days' = [Math]::Round($timeSpan.TotalDays, 0)
   'Hours' = [Math]::Round($timeSpan.TotalHours, 0)
   'Minutes' = [Math]::Round($timeSpan.TotalMinutes, 0)
   'A1_Key' = $env:COMPUTERNAME
}

Write-Output $output
