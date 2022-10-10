namespace PSAudio;
using System;
using System.Linq;
using System.Collections.Generic;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;

public class CachedSoundSampleProvider : ISampleProvider
{
    private CachedSound Audio;
    private long Position = 0;

    public CachedSoundSampleProvider(CachedSound audio)
    {
        Audio = audio;
    }

    // # Interface implementation for [int] Read([float[]] buffer, [int] offset, [int] count)
    public int Read(float[] buffer, int offset, int count)
    {
        var availableSamples = Audio.AudioData.Length - Position;
        var samplesToCopy = Math.Min(availableSamples, count);

        Array.Copy(Audio.AudioData, Position, buffer, offset, samplesToCopy);

        Position += samplesToCopy;
        return (int)samplesToCopy;
    }

    // # Interface implementation for [WaveFormat] WaveFormat { get }
    public WaveFormat WaveFormat
    {
        get { return Audio.WaveFormat; }
    }
}