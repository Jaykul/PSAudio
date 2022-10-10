namespace PSAudio;
using System;
using System.Linq;
using System.Collections.Generic;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;

public class CachedSoundSampleProvider : ISampleProvider
{

    public float[] AudioData { get; private set; }
    private long Position = 0;
    private WaveFormat OutputFormat;

    public CachedSoundSampleProvider(string audioFileName)
    {
        //# Pre-load the audio file
        var audioFileReader = new AudioFileReader(audioFileName);
        try
        {
            //# Resample the audio file to 44.1kHz
            var sampler = new WdlResamplingSampleProvider(audioFileReader, 44100);
            OutputFormat = sampler.WaveFormat;

            var data = new List<float>((int)(audioFileReader.Length / 4));
            //# Read about a second of audio at a time
            var buffer = new float[sampler.WaveFormat.AverageBytesPerSecond];
            var samplesRead = 0;
            while ((samplesRead = sampler.Read(buffer, 0, buffer.Length)) > 0)
            {
                data.AddRange(buffer.Take(samplesRead));
            }
            AudioData = data.ToArray();

        }
        finally
        {
            audioFileReader.Dispose();
        }
    }

    // # Interface implementation for [int] Read([float[]] buffer, [int] offset, [int] count)
    public int Read(float[] buffer, int offset, int count)
    {
        var availableSamples = AudioData.Length - Position;
        var samplesToCopy = Math.Min(availableSamples, count);

        Array.Copy(AudioData, Position, buffer, offset, samplesToCopy);

        // # Auto-resetting position (if we return 0), then reset for the next use
        Position = samplesToCopy < count ? 0 : Position + samplesToCopy;
        return (int)samplesToCopy;
    }

    // # Interface implementation for [WaveFormat] WaveFormat { get }
    public WaveFormat WaveFormat
    {
        get { return OutputFormat; }
    }
}