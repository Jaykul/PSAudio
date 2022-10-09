using namespace System;
using namespace NAudio.Wave;

class CachedSoundSampleProvider : ISampleProvider
{
    [CachedSound]$cachedSound;
    [long]$position;

    CachedSoundSampleProvider([CachedSound]$cachedSound)
    {
        $this.cachedSound = $cachedSound;
    }

    [int] Read([float[]]$buffer, [int]$offset, [int]$count)
    {
        $availableSamples = $this.cachedSound.AudioData.Length - $this.position;
        $samplesToCopy = [Math]::Min($availableSamples, $count);
        [Array]::Copy($this.cachedSound.AudioData, $this.position, $buffer, $offset, $samplesToCopy);
        $this.position += $samplesToCopy;
        return [int]$samplesToCopy;
    }

    [WaveFormat] get_WaveFormat() { return $this.cachedSound.WaveFormat }
}
