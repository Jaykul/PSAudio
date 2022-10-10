# PSAudio

It's just a PowerShell command based on NAudio to play audio files.
Particularly, it's an async sound player that supports layering sounds.

- You could play a sound from your prompt function, without blocking the prompt!
- You could add sounds back to your [BurntToast](https://github.com/Windos/BurntToast) notifications.
- You could even add sound to [PowerArcade](https://github.com/StartAutomating/PowerArcade) games. 😉

By default, `Start-Sound` resamples the audio and caches it in memory so it can handle audio files in different formats and sample rates, and can play sounds again without needing to read the file from disk again. Obviously, this is not ideal for large files, so you can disable it with the `-NoCache` switch. However, currently, the `-NoCache` switch doesn't handle resampling, so you would need to make sure your audio files were in the same format and sample rate as the default audio device.

## Installing

```powershell
Install-Module PSAudio
```

## Examples

```powershell
Start-Sound blaster-zap
```

Plays one of the sounds in the "audio" folder of the module.

```powershell
Start-Sound wikimedia-sound-of-human-knowledge-2, crystal-piano
```

Plays two sounds (nearly) simultaneously.


```powershell
Start-Sound crystal-epiano
Start-Sleep -Seconds 2
Start-Sound blaster-zap
Start-Sleep -Seconds 1
Start-Sound mega-zap-3
```

Plays a sound, and then another and another, layering them.

## Contributing

I just wrote this over the weekend, so it doesn't do very much. I'd love to play more, but I don't have any particular plans. If you have any ideas, or even if you want to take it over completely, open an issue or a PR.