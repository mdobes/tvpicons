# Contributing

## Design specification

Every source file follows the same geometry, so the collection stays visually consistent and can be processed programmatically:

- Canvas: 250×250
- Artwork: the longest side measures 170, centred on the canvas
- Background: full bleed, part of the design — usually the brand's dominant colour or gradient, with the logo itself in a light colour
- Vector only — no embedded rasters, except where no vector version of a logo exists at all

The 170 constraint matters more than it looks. Without it, a tall logo and a wide wordmark each fill the canvas along a different axis and end up looking wildly different in size next to each other.

Any vector tool works as long as the output matches the spec.

## Naming

One logo per channel. There are no per-variant files — `nova` covers TV Nova regardless of whether a given lineup calls it Nova HD, Nova SD or Nova T2.

Separate channels get separate entries, even under a shared brand: `novasport1` through `novasport6`, `primazoom`, `jojkrimi`.

Keys are lowercase ASCII without spaces, mirroring the existing entries in `displayname.yml`.

## Adding a logo

1. Fork the repository.
2. Add `src/<key>.svg` following the design specification above.
3. Run `make displaynames` to register the key in `displayname.yml`.
4. Fill in the display name for the new entry.
5. Run `make check-displaynames` and make sure it passes.
6. Optionally run `make convert -- <key>` and look at the result.
7. Open a pull request.

PNG files are not committed. CI renders every changed source and uploads the results, so a pull request only ever contains SVG files and `displayname.yml`.

## Local rendering

Requires [Inkscape](https://inkscape.org/) on your `PATH`.

```
make convert -- nova                 # renders png/nova.png
make convert QUALITY=1024 -- nova    # at a different size
make clean                           # removes rendered PNGs
```

`make help` lists the available targets.

## Requests

Requests for channels you do not want to draw yourself are welcome as issues. This is a hobby project, though — there is no timeline and no guarantee that anything gets added.
