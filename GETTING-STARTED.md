# Building Your Ghost Theme

You're going to turn your Figma designs into a live Ghost theme. An AI called **Claude Code** will do the actual coding — you just describe what you want in plain English.

This guide walks you through every step, in order. Do them one at a time. Don't skip ahead.

---

## What you'll need before you start

- Your Mac
- About 30 minutes for setup
- A credit card (for the Claude Pro subscription — $20/month)
- The zip file you received along with this guide (`luis-ghost-setup.zip`)

## Before anything else: Unzip the files

You received a zip file called `luis-ghost-setup.zip`. It contains two files:

- **GETTING-STARTED.md** — this guide (you're reading it)
- **setup.sh** — a script that installs your tools (you'll run this in Step 4)

**Do this now:**

1. Find `luis-ghost-setup.zip` in your **Downloads** folder
2. **Double-click** it — macOS automatically unzips it and creates a folder
3. Open that folder. You'll see the two files.
4. Drag **`setup.sh`** to your **home folder**. To find your home folder: open Finder, look in the left sidebar for the folder with a **house icon** and **your name**. That's it. Drag `setup.sh` there.

`setup.sh` is now ready for Step 4. Keep reading.

---

## Step 1: Create a Claude account

**Where:** https://claude.ai

1. Go to that link in your web browser (Safari, Chrome, whatever you use)
2. Click **Sign up** and create an account with your email
3. After signing up, go to https://claude.ai/pricing
4. Subscribe to the **Pro plan** — it costs **$20/month**

**What is Claude?** It's an AI. Claude Code is the version that runs in your terminal and writes code for you. You talk to it like a person. The Pro plan is what gives you access to it.

---

## Step 2: Create a GitHub account

**Where:** https://github.com

1. Go to that link
2. Click **Sign up** and create a free account
3. Pick a username you'll remember

**What is GitHub?** Think of it as Dropbox for code, but with a complete history of every change ever made. It's how we'll share the project — I can see your changes, you can see mine.

**IMPORTANT — Do this now before continuing:**

Text or message your collaborator with exactly this:

> My GitHub username is ______. Please run this in your terminal:
> `gh api repos/whale/ghost-theme-luis/collaborators/YOUR-USERNAME -X PUT`

Replace YOUR-USERNAME with your actual GitHub username. He needs to run that command to give you access to the project. **Wait until he confirms he did it before moving to Step 6.** Steps 3, 4, and 5 don't need access, so keep going with those while you wait.

---

## Step 3: Download Warp (your terminal app)

**Where:** https://www.warp.dev

1. Go to that link
2. Click **Download** — it downloads a regular Mac app
3. Open your **Downloads** folder, find the Warp file, and drag it into your **Applications** folder
4. Open Warp from Applications (or Spotlight: press **Cmd+Space**, type **Warp**, press **Enter**)
5. It asks you to create a Warp account — follow the prompts. This is free.

**What is a terminal?** It's an app where you type commands instead of clicking buttons. It looks like a text window with a blinking cursor. You type something, press Enter, and the computer does it. That's it. Warp makes this less intimidating by grouping commands and their results into visual blocks, like messages in a chat.

**From this point on, every step happens inside Warp.**

---

## Step 4: Install your developer tools

This step installs five things your Mac needs. You run one command and it handles everything.

You already moved `setup.sh` to your home folder at the top of this guide. Now you'll run it.

**Open Warp and type this, then press Enter:**

```
bash ~/setup.sh
```

**What does "run" mean?** You type the command into Warp and press Enter. The computer reads it and executes the instruction. That's called "running" a command.

**What does this command mean?**
- `bash` = a program that reads and runs script files
- `~/setup.sh` = the file you moved to your home folder (`~` is shorthand for your home folder)

The script takes a few minutes. It prints what it's doing at each step so you can follow along.

**If it asks for your password:** Type your Mac login password and press Enter. The characters won't appear as you type — that's a security feature, not a bug. Just type it blind and press Enter.

**What it installs:**
- **Homebrew** — an app store for developer tools (installs the other things below)
- **Git** — your save-point system (lets you undo mistakes and go back to working versions)
- **GitHub CLI** — connects your terminal to your GitHub account
- **Node.js** — a behind-the-scenes tool that Ghost themes need to work
- **Claude Code** — the AI that will help you write your theme

**When it finishes:** Close Warp completely (**Cmd+Q**) and reopen it. This is necessary so Warp recognizes the new tools.

---

## Step 5: Connect your terminal to GitHub

Open Warp and type this, then press Enter:

```
gh auth login
```

It asks you a few questions. Choose exactly these answers:

| It asks you... | You pick... |
|---|---|
| Where do you use GitHub? | **GitHub.com** |
| What is your preferred protocol? | **HTTPS** |
| How would you like to authenticate? | **Login with a web browser** |

It shows you a short code and opens your web browser. Paste the code into the browser page, click **Authorize**, and you're connected.

**You only do this once.** From now on, your terminal knows who you are on GitHub.

---

## Step 6: Download the project

This downloads the project I set up for you from GitHub to your Mac.

**Type this in Warp and press Enter:**

```
gh repo clone whale/ghost-theme-luis ~/ghost-theme-luis
```

**What this does:** Downloads ("clones") the project into a folder called `ghost-theme-luis` in your home folder.

**Then type this and press Enter:**

```
cd ~/ghost-theme-luis
```

**What `cd` means:** "Change directory." It's like double-clicking a folder in Finder. You're telling the terminal "I want to be inside this folder now."

---

## Step 7: Download the reference themes

Now run the setup script one more time. This time it downloads 20+ professional Ghost themes that Claude will study as examples when building yours.

```
bash ~/setup.sh
```

Same command as Step 4. The script is smart — it skips the tools it already installed and just downloads the reference themes.

You don't need to read or open these themes yourself. They're for Claude to learn from.

---

## Step 8: Start Claude Code

Make sure you're in your project folder, then launch Claude:

```
cd ~/ghost-theme-luis
claude
```

**First time only:** It opens your web browser and asks you to log in with the Claude account you created in Step 1. Log in, and it brings you back to the terminal.

You're now inside Claude Code. You'll see a text prompt where you can type in plain English.

**Try saying this to Claude:**

> What files are in my project? Give me a quick overview.

Claude reads your project and explains everything. It can see all your files, read the reference themes, and use the documentation — all automatically.

---

## Step 9: Start building your theme

Tell Claude about your Figma design. You can describe it, or drag a screenshot into the Warp window. Examples of things to say:

> I want my homepage to have a large title at the top, then a list of my posts below with just the title and date. The font should be Inter.

> Look at how the Source theme handles the homepage. I want something similar but simpler.

> Make the background dark and the text light gray.

Claude writes the code, explains what it did, and saves your progress automatically.

---

## Step 10: See your theme on your Ghost site

When you want to preview your theme on your actual website:

1. Tell Claude: **"Package my theme for upload"**
2. Claude creates a `.zip` file and tells you where it is
3. In your browser, go to your Ghost Admin panel: **your-site.ghost.io/ghost/**
4. Navigate to **Settings** then **Design** then **Change theme** then **Upload theme**
5. Click the upload area and select the `.zip` file Claude told you about
6. Visit your site to see it live

---

## Your daily routine (after setup is done)

Once everything above is done, this is all you do each day:

1. Open **Warp**
2. Type `cd ~/ghost-theme-luis` and press Enter
3. Type `claude` and press Enter
4. Tell Claude what you want to work on
5. When you want to see changes on your site, say **"package my theme"** and upload the zip
6. When you're done for the day, say **"save my progress and push to GitHub"**

---

## Things you can say to Claude

| You say... | What happens |
|---|---|
| "Save my progress" | Creates a save point (like saving a video game) |
| "Undo that" | Reverses the last change |
| "It was working before" | Shows you past save points — pick one to go back to |
| "Show me what changed" | Shows a before/after comparison |
| "Package my theme" | Creates a .zip to upload to Ghost |
| "Push my changes" | Sends your latest work to GitHub so your collaborator can see it |
| "Pull the latest changes" | Downloads changes your collaborator made |
| "What does this file do?" | Claude explains any file in plain English |
| "How does Source handle the homepage?" | Claude reads a reference theme and explains their approach |

---

## When things go wrong

**Don't panic.** Every change gets saved automatically. You can always go back.

| What happened | What to say to Claude |
|---|---|
| The last change broke something | "Undo that" |
| It was working earlier today | "Go back to the last version that was working" |
| One file got messed up | "Start over on this file" |
| Everything looks wrong | "Go back to the last save point" |
| You want to try something risky | "Create a branch called experiment" — this makes a parallel copy so your main version stays safe |

**Nothing is permanent until you upload it to Ghost.** Your live site is safe while you experiment.

---

## Quick glossary

**Terminal** — An app where you type commands. Warp is your terminal.

**Command** — A text instruction you type and press Enter to run.

**Git** — Your save-point system. Every "commit" is a snapshot you can return to.

**GitHub** — Where your project lives online. How you and I share work.

**Clone** — Download a project from GitHub to your computer.

**Push** — Send your changes from your computer up to GitHub.

**Pull** — Download changes from GitHub to your computer.

**Commit** — Create a save point. A snapshot of your project at this moment.

**Branch** — A parallel version of your project. Try things without affecting the main version.

**Ghost theme** — A collection of files that control how your Ghost website looks. Three types of files:
- `.hbs` files — page structure (like wireframes: "title goes here, content goes here")
- `.css` files — styling (colors, fonts, spacing — where your Figma design becomes real)
- `.js` files — behavior (optional, things like "load more posts when I scroll")

---

---

## When you're done with setup

Once you've finished Steps 1–9 and Claude Code is running, **send your collaborator a message:**

> I'm set up. Claude Code is running and I can see the project files. Ready to start building.

This lets them know everything worked and you're ready to go.

---

*If you get stuck, ask Claude first — it's designed to help you work through problems. If Claude is stuck, call your collaborator.*
