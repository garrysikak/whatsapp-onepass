# whatsapp-onepass

One ffmpeg pass so WhatsApp’s second encode has less to invent.

WhatsApp re-encodes anything you send as **video**. Feed it 720p H.264
`yuv420p` + AAC, then attach the file as **Document / File**. A “video”
send of a 4K60 camera dump is how faces turn to soup.

## Run

Needs `ffmpeg` on the machine (Linux, macOS, WSL, Termux).

```bash
chmod +x whatsapp-onepass.sh
./whatsapp-onepass.sh clip.mp4
# writes clip-wa.mp4
```

Options:

```bash
./whatsapp-onepass.sh -h 720 -c 23 clip.mp4 out.mp4
```

## Why not a compressor app

A second consumer encoder on top of a phone dump, then WhatsApp’s encoder
on top of *that*, is three generations. Encode once, on purpose.

Longer notes (same command, more why):

https://westlywire.com/guides/compress-video-for-whatsapp-without-killing-it/

Script page:

https://westlywire.com/tools/whatsapp-onepass/

## License

MIT. See `LICENSE`.
