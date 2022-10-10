namespace PSAudio;
using System;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;

public class AudioPlaybackEngine : IDisposable {
    IWavePlayer OutputDevice;
    MixingSampleProvider Mixer;

    public static AudioPlaybackEngine Instance = new AudioPlaybackEngine(44100, 2);

    public AudioPlaybackEngine(int sampleRate = 44100, int channelCount = 2) {
        this.OutputDevice = new WaveOutEvent();
        var format = WaveFormat.CreateIeeeFloatWaveFormat(sampleRate, channelCount);

        this.Mixer = new MixingSampleProvider(format);
        this.Mixer.ReadFully = true;

        this.OutputDevice.Init(this.Mixer);
        this.OutputDevice.Play();
    }

    ISampleProvider ConvertToRightChannelCount(ISampleProvider provider) {
        if (provider.WaveFormat.Channels == this.Mixer.WaveFormat.Channels) {
            return provider;
        }

        if (provider.WaveFormat.Channels == 1 && this.Mixer.WaveFormat.Channels == 2) {
            return new MonoToStereoSampleProvider(provider);
        }

        throw new NotImplementedException("Not yet implemented this channel count conversion");
    }

    void PlaySound(string fileName) {
        this.AddMixerInput(new SelfDisposingAudioFileReader(fileName));
    }

    public void PlaySound(CachedSound sound) {
        this.AddMixerInput(new CachedSoundSampleProvider(sound));
    }

    public void AddMixerInput(ISampleProvider provider) {
        this.Mixer.AddMixerInput(this.ConvertToRightChannelCount(provider));
    }

    public void Dispose() {
        this.OutputDevice.Dispose();
    }
}
