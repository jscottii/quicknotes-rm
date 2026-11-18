# Quick Notes fan for the reMarkable Paper Pro Move

Tap the bottom-left corner with your finger and a fan of up to 5 pinned notebooks opens, wherever you are on the tablet.

- **Tap a bubble** to open that notebook.
- **Tap +** to pin a notebook from a paged list, or to create a new note in a "Quick Notes" folder. The **+** only shows while you have fewer than 5 pinned.
- **Press and hold a bubble** for Rename or Remove. Renaming opens a built-in keyboard. The new label only changes the bubble; the notebook keeps its own name.
- **Bubbles stay centred** on the arc as you add more.
- **The pen passes through** the corner. Only finger taps open the fan.

Pins and labels are saved in `/home/root/.local/share/quicknotes/slots.json`.

## Compatibility

| reMarkable OS | Status |
|---|---|
| 3.28.0.172 | Tested on a Paper Pro Move |
| 3.29.0.148, 3.29.1.0 | Prepared, not yet tested |

The patch only loads on the versions listed at the top of `quickNotes.qmd`. On any other version it's skipped, and the tablet runs normally.

**Requires:** xovi, qt-resource-rebuilder and qt-command-executor.

## Install

**With vellum** (once the package is published):

```sh
vellum add quicknotes-fan
```

**From a Mac**, with the tablet connected by USB:

```sh
./install.sh            # install or update
./install.sh --logs     # show the mod's log lines
./install.sh --remove   # uninstall (your pins are kept)
```

After a reboot, start xovi again with `/home/root/xovi/start` on the tablet, or use tripletap.

## Adding support for a new reMarkable version

1. Add a `VERSION x.y.z.w` line at the top of `quickNotes.qmd`.
2. Install it and run `./install.sh --logs`.
3. Look for `[quicknotes] overlay created` and for any `Error while` lines.
