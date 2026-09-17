# Autodesk Fusion on Linux

<img align="center" src="https://codeberg.org/Lolig4/Autodesk-Fusion-360-on-Linux/raw/branch/main/files/images/autodesk-fusion-linux-logo.png" width="250px" height="250px">
</br></br>

This is not the project repository. Autodesk Fusion on Linux is developed on Codeberg:
**https://codeberg.org/Lolig4/Autodesk-Fusion-360-on-Linux**

Please look for install instructions there. This repository exists only to host the prebuilt Wine and
Proton runners, because Codeberg does not take release assets of this size. Nothing is developed here.

## What is hosted here

Three runners, each patched for Autodesk Fusion and Inventor and published as a release asset:

| Runner | Base | Archive |
| --- | --- | --- |
| `fusion-wine-build` | [Wine](https://www.winehq.org/) | `fusion-wine-build.tar.gz` |
| `GE-Proton11-Fusion` | [GE-Proton](https://github.com/GloriousEggroll/proton-ge-custom) | `GE-Proton11-Fusion.tar.gz` |
| `cachyos-wineland-11.0-Fusion` | [Proton Wineland](https://github.com/nanomatters/proton-cachyos) | `cachyos-wineland-11.0-Fusion.tar.xz` |

The patches they are built from live in the Codeberg repository under
[`files/setup/data`](https://codeberg.org/Lolig4/Autodesk-Fusion-360-on-Linux/src/branch/main/files/setup/data)

## Versioning

Each release is tagged `Version_N` and carries all three archives. When the installer downloads a
runner, it writes a `fusion-runner.conf` next to its files. It looks like this:

```ini
runner=GE-Proton11-Fusion
version=1
installed=2026-09-16
```

The installer and the launcher compare that `version` against the newest release and then offer an
update. A runner built locally has no such file, so they ask before replacing it.

## If you want to support my work

[![Donate with PayPal](https://img.shields.io/badge/Donate-PayPal-%230070BA?style=for-the-badge&logo=paypal&logoColor=white)](https://www.paypal.com/donate/?hosted_button_id=AE8F8PN55SPKL)
