# CMD Bash Alias Imitation

**Bash-style command aliases for Windows Command Prompt, powered by the built-in `DOSKEY` utility.**

A lightweight way to give `cmd.exe` familiar shortcuts such as `grep`, `clear`, `home`, and `..` without installing Bash, replacing your shell, or adding third-party dependencies.

> [!NOTE]
> These are **DOSKEY macros**, not actual Bash aliases or replacements for Windows commands. They work at an interactive CMD prompt; they do not automatically expand inside `.bat` or `.cmd` scripts.

## Features

- Native Windows functionality using `cmd.exe`, `doskey`, and `findstr`.
- Plain-text, easily customized alias definitions in `%USERPROFILE%\.cmd_aliases`.
- Optional automatic loading for all CMD sessions through the current user's registry **AutoRun** setting.
- Alternative setup for a single **Windows Terminal** Command Prompt profile.
- Color-coded batch installer, with existing-file backup and AutoRun collision protection.
- No administrative privileges required for the current-user installation.

## Requirements

- Windows (tested on Windows 11)
- Command Prompt (`cmd.exe`) and the built-in `doskey.exe`
- Windows PowerShell 5.1 for the optional installer and its colorized output

## Quick installation

1. Download or clone this repository.
2. Open the repository folder in File Explorer.
3. Run **`installer.bat`** as your normal Windows user.
4. If `%USERPROFILE%\.cmd_aliases` already exists, choose to **back it up and replace it**, retain it, or cancel.
5. Choose a startup method:
   - **1 — CMD AutoRun:** registers automatic loading for the current Windows user, provided the AutoRun value is not already occupied.
   - **2 — Windows Terminal:** leaves terminal settings unchanged; follow the profile instructions below.
   - **3 — Skip:** installs only the macro file.
6. Open a new CMD window or tab. Test with `alias` or `pwd`.

The installer **moves** the repository's example `.cmd_aliases` to `%USERPROFILE%`, as requested, rather than copying it. **This removes the tracked example from your working Git checkout**, so GitHub Desktop will show a deleted file. If you want to keep the repository unchanged, copy `.cmd_aliases` to your user profile manually instead of running the installer. Re-running the installer when the source file is absent but the destination exists lets you revisit startup configuration.

The installer uses Windows PowerShell for colored status messages and for writing the optional current-user registry value; no separately downloaded PowerShell package is required on supported Windows 10/11 systems.

## Manual installation

Copy the `.cmd_aliases` file into your user profile. The final path should be:

```text
%USERPROFILE%\.cmd_aliases
```

For example, use this command **from the repository folder**:

```cmd
copy ".cmd_aliases" "%USERPROFILE%\.cmd_aliases"
```

If the file already exists, review and merge your definitions rather than overwriting it blindly.

### Option A — CMD AutoRun (all normal CMD sessions)

This option automatically loads macros when `cmd.exe` starts, including CMD launched outside Windows Terminal.

1. Press **Win + R**, enter `regedit`, and press Enter.
2. Navigate to `HKEY_CURRENT_USER\Software\Microsoft\Command Processor` (create the **Command Processor** key under **Microsoft** if it does not exist).
3. Create an **Expandable String Value (REG_EXPAND_SZ)** named `AutoRun` if there isn't one already.
4. Set its value data to:

   ```cmd
   if exist "%USERPROFILE%\.cmd_aliases" doskey /macrofile="%USERPROFILE%\.cmd_aliases"
   ```

5. Open a **new CMD session** and test `alias`.

**Important:** If `AutoRun` already contains commands, **do not overwrite it**. Integrate the `doskey` loader with the existing commands (for example, by appending ` & if exist "%USERPROFILE%\.cmd_aliases" doskey /macrofile="%USERPROFILE%\.cmd_aliases"`), after reviewing the existing entry. Changing AutoRun affects future CMD processes for your Windows account; `cmd /d` intentionally disables AutoRun for an individual session. Avoid configuring both methods for the same CMD session unless you want redundant macro loading.

### Option B — Windows Terminal profile (one profile only)

This option loads the file only when the chosen Windows Terminal **Command Prompt** profile starts.

1. Open **Windows Terminal → Settings → Profiles → Command Prompt**.
2. Under **Command line**, enter:

   ```cmd
   cmd.exe /k "doskey /macrofile=%USERPROFILE%\.cmd_aliases"
   ```

3. Save, then open a new Command Prompt tab using that profile.

If your Windows user profile path contains spaces, use a quoted path in the DOSKEY command and verify CMD's nested quote handling, or prefer the **AutoRun** method above.

For users editing Windows Terminal's `settings.json`, an equivalent profile property is:

```json
"commandline": "cmd.exe /k \"doskey /macrofile=%USERPROFILE%\\.cmd_aliases\""
```

**Do not put the same loader in both AutoRun and the profile** unless double-loading is intentional.

### Option C — One-time manual loading

Run this in the **existing interactive CMD session**:

```cmd
doskey /macrofile="%USERPROFILE%\.cmd_aliases"
```

The aliases are available immediately in that session, but they will not load into future sessions until you configure one of the startup methods above.

## Customizing aliases

Open `%USERPROFILE%\.cmd_aliases` with a text editor. Each line uses:

```text
name=command arguments
```

For example:

```text
ll=dir /a $*
search=findstr /i $*
repo=cd /d "%USERPROFILE%\Source\Git-Repos"
```

DOSKEY placeholders include `$*` (all arguments), `$1` through `$9` (individual arguments), and `$T` (multiple commands). Reload after saving:

```cmd
doskey /macrofile="%USERPROFILE%\.cmd_aliases"
```

To inspect **actually loaded** macros instead of the text file, run:

```cmd
doskey /macros
```

or (if you keep the default defintion for alias included by default)

```cmd
alias
```

Note: Do not remove the alias named alias in the .cmd_aliases file if you wish to retain the most Linux-like alias experience.

Reloading definitions does not automatically remove macros that you deleted from the file; close and reopen CMD to start with a fresh set.

## Troubleshooting

| Symptom | Action |
| --- | --- |
| `'alias' is not recognized` | Ensure the file exists and the current CMD session loaded it using `doskey /macrofile=...`. |
| Macros work in one window but not another | Configure CMD AutoRun or the correct Windows Terminal profile. |
| An AutoRun value already exists | Leave it intact and manually integrate the DOSKEY loader; the installer will not overwrite it. |
| Macros do not work in a batch script | DOSKEY macros are for interactive console input; call the actual command inside scripts. |

## License

MIT License

See the repository's [LICENSE](LICENSE) file for its license terms.

---

**References:** [Microsoft DOSKEY documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/doskey) · [Microsoft CMD documentation](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/cmd) · [Windows Terminal profile settings](https://learn.microsoft.com/en-us/windows/terminal/customize-settings/profile-general)
