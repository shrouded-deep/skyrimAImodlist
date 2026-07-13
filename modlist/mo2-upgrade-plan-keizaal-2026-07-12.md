# MO2 Upgrade Plan — Keizaal Fork (`E:\Skyrim`)

**Context:** Game Settings Override TOML load failure on **Win11 24H2** (build 26100).
Root cause is [MO2 USVFS breakage on Win11 24H2](https://github.com/ModOrganizer2/modorganizer/issues/2174)
(directory scan can succeed; `fopen`/open fails for virtual-only paths). Not a missing mod file.

**Resolution (2026-07-12):** MO2 upgraded **2.5.0 → 2.5.2**; GSO still fatal on launch.
**Game Settings Override + Collection are NOT compatible on this host** until MO2 ships a
merged USVFS fix. Both **disabled** on `Keizaal - Fork` — matches pristine Keizaal (never
had GSO). Anvil fundamentals tranche item **deferred**, not lost work: we documented root
cause, upgraded MO2, and ruled out false fixes (overwrite, `root\Data`, DLL co-location,
Collection disable).

**Current Fork instance**

| Component | Fork (`E:\Skyrim`) | Anvil (working reference) |
|---|---|---|
| MO2 | **2.5.2** (upgraded 2026-07-12) | **2.5.2** |
| usvfs | **0.5.6.1** | **0.5.6.1** |
| OS | Win11 **24H2** | (same class of issue possible) |
| GSO | **Disabled** — incompatible | Enabled (may work if Anvil host ≠ 24H2 USVFS path) |

Copying TOMLs to overwrite / `root\Data` / co-locating with the DLL did **not** fix GSO — consistent
with USVFS open-path bugs, not a simple missing-file problem.

---

## Recommendation: **upgrade to 2.5.2**, do **not** downgrade to 2.4

### Why upgrade (not 2.4)

| Option | Verdict |
|---|---|
| **MO2 2.5.2** | **Do this.** Current stable; matches Anvil; Qt6/Python 3.12; requires VC++ 14.40+. |
| **MO2 2.4.4** | **Avoid.** Last 2.4 release Dec 2021; Qt5/Python 3.7; FOMOD C#/OMOD/Python plugins expect 2.5; **no evidence** it fixes Win11 24H2 USVFS (bug affects 2.5.0–2.5.2). |
| **MO2 2.5.3 beta** | Optional later; dev builds include more USVFS hooks; 2.5.2 + patched usvfs is enough to try first. |

### Win11 USVFS patch (if 2.5.2 alone doesn't fix GSO)

After upgrading MO2, if GSO still errors, replace `usvfs_x64.dll` / `usvfs_x86.dll` in the MO2
folder with the community-tested build from
[issue #2217](https://github.com/ModOrganizer2/modorganizer/issues/2217#issuecomment-2900000000):
[usvfs-GetModuleFileNameA-hooked.zip](https://github.com/user-attachments/files/19950677/usvfs-GetModuleFileNameA-hooked.zip)

MO2 devs noted a release with the Holt/Silarn USVFS fixes is in progress (Apr 2026).

---

## Upgrade procedure (portable `E:\Skyrim`)

**Prereq:** Install [VC++ Redistributable 14.40+](https://aka.ms/vs/17/release/vc_redist.x64.exe) if MO2 2.5.2 won't start.

1. **Close MO2** completely.
2. **Backup** (one-time):
   - `E:\Skyrim\modorganizer.ini`
   - `E:\Skyrim\profiles\` (optional full copy)
3. Download **Mod.Organizer-2.5.2.7z** from [GitHub releases](https://github.com/ModOrganizer2/modorganizer/releases/tag/v2.5.2) or Nexus 6194.
4. Extract **over** `E:\Skyrim\` (replace `ModOrganizer.exe`, `usvfs_*.dll`, `Qt*`, `plugins\`, etc.).
   - **Do not** delete `mods\`, `profiles\`, `overwrite\`, `modorganizer.ini`, `downloads` path.
5. Launch `ModOrganizer.exe` → confirm **Help → About** shows **2.5.2**.
6. Profile **Keizaal - Fork** → **F5** refresh.
7. **Revert GSO workaround** (after USVFS confirmed):
   - Restore `ccld_GameSettingsOverride.dll` in `mods\Game Settings Override\` (remove `.mohidden`).
   - Remove duplicate TOMLs from `root\Data\...` if VFS works (keep mod + Collection layout).
8. Launch SKSE → confirm GSO popup gone; check `%PROFILE%\SKSE\ccld_GameSettingsOverride.log` if needed.

---

## GSO mod layout (target state after fix)

```
Game Settings Override/
  SKSE/Plugins/
    ccld_GameSettingsOverride.dll
    ccld_GameSettingsOverride/*.toml   ← co-located OR Collection mod provides folder
Game Settings Override - Collection/  ← optional; can stay enabled if USVFS honors overwrite
```

---

## Fallback — **APPLIED 2026-07-12**

- **Disabled** `Game Settings Override` + `Game Settings Override - Collection` on Fork.
- **Not Keizaal-native** — added via task-0067 fundamentals tranche; disabling restores
  pristine Keizaal behavior for engine-setting tweaks (no ESP / MAST impact).
- **Not equivalent:** Mod Function Menu (GSO reload UI only), MCM Helper (framework),
  powerofthree's Tweaks (different scope). Optional replacements for Collection tweaks:
  standalone Nexus ports or SkyPatcher — track separately if desired.
- Revisit when MO2 release includes merged USVFS fix ([issue #2174](https://github.com/ModOrganizer2/modorganizer/issues/2174),
  [#2217](https://github.com/ModOrganizer2/modorganizer/issues/2217)).

### Troubleshooting attempted (for the record)

| Attempt | Result |
|---|---|
| Co-locate TOMLs in GSO mod folder | Fail |
| Copy to MO2 overwrite | Fail |
| Copy to `root\Data` physical path | Fail |
| Hide mod DLL, deploy physical DLL+TOMLs | Fail |
| Disable Collection mod only | Fail |
| MO2 2.5.0 → 2.5.2 upgrade | GSO still fatal |
| Downgrade to 2.4 | Not tried — no evidence it fixes Win11 24H2 USVFS |

---

## Acceptance

- [x] MO2 About shows 2.5.2+
- [x] GSO ruled incompatible on Win11 24H2 — disabled on Fork (documented)
- [ ] SKSE launches without GSO fatal popup (user verify after F5)
- [ ] Pandora / xEdit / Synthesis still launch from MO2 toolbar (smoke test)
