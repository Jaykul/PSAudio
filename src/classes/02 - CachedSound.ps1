using namespace System.Collections.Generic
using namespace System.Linq
using namespace NAudio.Wave

class CachedSound
{
    [float[]]$AudioData
    [WaveFormat]$WaveFormat
    CachedSound([string]$audioFileName) {
        # Write-Host "Loading $audioFileName"
        $audioFileReader = [AudioFileReader]::new($audioFileName)
        try {
            # Write-Host "Loading $($audioFileReader.Length) bits from $audioFileName (at $($audioFileReader.WaveFormat.SampleRate)Hz)"
            $this.WaveFormat = $audioFileReader.WaveFormat

            $wholeFile = [List[float]]::new([int]($audioFileReader.Length / 4))
            $readBuffer = [float[]]::new($audioFileReader.WaveFormat.SampleRate * $audioFileReader.WaveFormat.Channels)

            [int]$samplesRead = 0
            while(($samplesRead = $audioFileReader.Read($readBuffer, 0, $readBuffer.Length)) -gt 0) {
                $wholeFile.AddRange([Enumerable]::Take($readBuffer, $samplesRead));
            }
            $this.AudioData = $wholeFile.ToArray();

        } finally {
            $audioFileReader.Dispose()
        }
    }
}
