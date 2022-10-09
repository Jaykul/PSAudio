using namespace System;
using namespace NAudio.Wave;
using namespace NAudio.Wave.SampleProviders;

class AudioPlaybackEngine : IDisposable {
    [IWavePlayer]$outputDevice
    [MixingSampleProvider]$mixer

    # static [AudioPlaybackEngine]$Instance = [AudioPlaybackEngine]::new(44100, 2)


    AudioPlaybackEngine([int]$sampleRate = 44100, [int]$channelCount = 2)
    {
        $this.outputDevice = [WaveOutEvent]::new()
        $this.mixer = [MixingSampleProvider]::new([WaveFormat]::CreateIeeeFloatWaveFormat($sampleRate, $channelCount))
        $this.mixer.ReadFully = $true
        $this.outputDevice.Init([NAudio.Wave.WaveExtensionMethods]::ToWaveProvider($this.mixer))
        $this.outputDevice.Play()
    }

    [void] PlaySound([string]$fileName)
    {
        $reader = [AudioFileReader]::new($fileName);
        $this.AddMixerInput([AutoDisposeFileReader]::new($reader));
    }

    [ISampleProvider] ConvertToRightChannelCount([ISampleProvider]$provider)
    {
        if ($provider.WaveFormat.Channels -eq $this.mixer.WaveFormat.Channels)
        {
            return $provider;
        }
        if ($provider.WaveFormat.Channels -eq 1 && $this.mixer.WaveFormat.Channels -eq 2)
        {
            return [MonoToStereoSampleProvider]::new($provider);
        }
        throw "Not yet implemented this channel count conversion";
    }

    [void] PlaySound([CachedSound]$sound)
    {
        $this.AddMixerInput([CachedSoundSampleProvider]::new($sound));
    }

    [void] AddMixerInput([ISampleProvider]$provider)
    {
        $this.mixer.AddMixerInput($this.ConvertToRightChannelCount($provider));
    }

    [void] Dispose()
    {
        $this.outputDevice.Dispose();
    }
}
