using namespace NAudio.Wave;

class AutoDisposeFileReader : ISampleProvider
{
    [AudioFileReader]$reader
    [bool]$isDisposed
    [WaveFormat]$WaveFormat

    AutoDisposeFileReader([AudioFileReader]$reader)
    {
        $this.reader = $reader;
        $this.WaveFormat = $reader.WaveFormat;
    }

    [int] Read([float[]]$buffer, [int]$offset, [int]$count)
    {
        if ($this.isDisposed) {
            return 0;
        }
        [int]$read = $this.reader.Read($buffer, $offset, $count);
        if ($read -eq 0)
        {
            $this.reader.Dispose();
            $this.isDisposed = $true;
        }
        return $read;
    }
}
