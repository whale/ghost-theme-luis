# Luis's Ghost Theme

A custom Ghost theme, designed in Figma and built with Claude Code.

## Status

🟡 Setting up — theme development hasn't started yet.

## What's in this folder

| Folder/File | What it is |
|-------------|-----------|
| `dev/luis/` | **Your theme.** This is where all the action happens. |
| `reference/` | 20+ professional Ghost themes for Claude to study. You don't need to read these — Claude does. |
| `CLAUDE.md` | Instructions that tell Claude how to work with you and this project. |
| `GHOST-THEME-REFERENCE.md` | A complete reference guide to how Ghost themes work. Claude reads this before implementing features. |

## How to work on your theme

### Starting a session

1. Open **Terminal** (Cmd+Space → type "Terminal" → Enter)
2. Type these two commands:
   ```
   cd ~/ghost-theme-luis
   claude
   ```
3. Tell Claude what you want to work on. Examples:
   - "I want to start translating my Figma homepage design into code"
   - "Add a navigation bar with links to Home, About, and Writing"
   - "Make the post titles bigger and change the font to Inter"

### Useful things to say to Claude

| You say... | What happens |
|------------|-------------|
| "Save my progress" | Creates a save point you can return to later |
| "Undo that" | Reverts the last change |
| "It was working before" | Shows past save points — pick one to go back to |
| "Show me what changed" | Shows a before/after comparison |
| "Package my theme" | Creates a .zip file to upload to Ghost |
| "Push my changes" | Sends your work to GitHub (so others can see it) |
| "Pull the latest changes" | Downloads changes someone else made |

### Seeing your theme on Ghost

1. Tell Claude: "Package my theme"
2. Claude creates a `.zip` file
3. Go to your Ghost Admin panel → Settings → Design → Upload Theme
4. Upload the zip
5. Activate the theme

### When things go wrong

**Don't panic.** Every change you make gets a save point. You can always go back.

- Say **"undo that"** to reverse the last thing Claude did
- Say **"go back to where it was working"** and Claude will show you save points to choose from
- Say **"start over on this file"** to reset a specific file to its last saved version
- **Nothing is permanent** until you upload it to Ghost. Your live site is safe while you experiment.

## How to get updates from collaborators

If someone else (like the repo owner) pushes changes:

1. Open Terminal
2. `cd ~/ghost-theme-luis && claude`
3. Say: "Pull the latest changes"

Claude handles the rest.

## Ghost Pro site

**Admin URL:** [to be filled in]
**Live site:** [to be filled in]
