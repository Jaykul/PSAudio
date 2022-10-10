namespace PSAudio;
using System;
using System.Linq;
using System.Collections.Generic;
using NAudio.Wave;
using NAudio.Wave.SampleProviders;

public class CachedSound
{
    public float[] AudioData { get; private set; }
    public WaveFormat WaveFormat { get; private set; }

    public CachedSound(string audioFileName)
    {
        //# Pre-load the audio file
        var audioFileReader = new AudioFileReader(audioFileName);
        try
        {
            //# Resample the audio file to 44.1kHz
            var sampler = new WdlResamplingSampleProvider(audioFileReader, 44100);
            WaveFormat = sampler.WaveFormat;

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
}