# TV Picons

Channel logos for Czech and Slovak TV, authored as SVG and published as square PNG tiles.

Browse the collection at [picons.dobes.dev](https://picons.dobes.dev/).

Some of the icons originate from [MarhyCZ's Picons](https://github.com/MarhyCZ/picons).

## What these are

Square 1:1 tiles with the background as part of the design — usually the brand's dominant colour or gradient. They are intended for IPTV playlists (`tvg-logo`), Kodi, and web players, where a tile sits on an unpredictable background and a transparent logo would disappear on either a light or a dark skin.

They are deliberately not Enigma2 picons. Enigma2 expects a 5:3 aspect ratio (220×132, 400×240) and filenames derived from the DVB service reference of your own channel list.

## Usage

Two pre-generated sizes are published: 640×640 and 1024×1024. Open the [gallery](https://picons.dobes.dev/), right-click any logo and copy the image link.

In an M3U playlist:

```
#EXTINF:-1 tvg-logo="https://<cdn-host>/640/nova.png",TV Nova HD
```

There is no need to download anything — the images are served from a CDN and updated when the sources change.

One logo per channel: `nova` covers TV Nova regardless of whether a given lineup calls it Nova HD, Nova SD or Nova T2. Mapping your own channel names onto these files is up to you.

## Contributing

New logos are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for the design specification and the steps to add one.