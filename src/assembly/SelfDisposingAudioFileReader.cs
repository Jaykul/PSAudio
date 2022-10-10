namespace PSAudio;
using NAudio.Wave;

internal class SelfDisposingAudioFileReader : ISampleProvider {
    private AudioFileReader Reader;
    private bool IsDisposed;
    public WaveFormat WaveFormat { get; private set; }

    internal SelfDisposingAudioFileReader(string fileName) {
        Reader = new AudioFileReader(fileName);
        WaveFormat = Reader.WaveFormat;
    }

    public int Read(float[] buffer, int offset, int count) {
        if (IsDisposed) {
            return 0;
        }

        int read = Reader.Read(buffer, offset, count);
        if (read == 0) {
            Reader.Dispose();
            IsDisposed = true;
        }

        return read;
    }
}
