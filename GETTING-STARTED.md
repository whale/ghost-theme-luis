# Building Your Ghost Theme

You're going to turn your Figma designs into a live Ghost theme. An AI called **Claude Code** will do the actual coding — you describe what you want in plain English, and it writes the code.

This guide has 4 steps. Do them in order.

---

## What you need

- A Mac
- About 30 minutes
- A credit card (for the Claude Pro subscription — $20/month)

---

## Step 1: Create two accounts

You need accounts on two websites. Both sign-ups happen in your web browser.

### Claude (your AI coding partner) — $20/month

1. Open your browser and go to **https://claude.ai**
2. Click **Sign up** and create an account with your email
3. Go to **https://claude.ai/pricing**
4. Click **Subscribe** under the **Pro** plan ($20/month)

This is the AI that will write code for you. You talk to it in plain English and it builds your theme.

### GitHub (where your project lives online) — free

1. Go to **https://github.com**
2. Click **Sign up** and create a free account
3. **Remember your username** — you'll need it in the next step

GitHub is like a shared Dropbox folder built for code. It keeps a history of every change, and it's how you and your collaborator will work on the same project.

---

## Step 2: Text your collaborator

Send your collaborator a message with your GitHub username:

> Hey, my GitHub username is ________

That's it. They'll do something on their end to give you access to the project. You don't need to wait for them — keep going with Step 3.

---

## Step 3: Run the setup

This is the big step. You're going to open a built-in Mac app called **Terminal** and paste one command. That command installs everything you need automatically.

### Open Terminal

Press **Cmd+Space** (this opens Spotlight search). Type **Terminal**. Press **Enter**.

A window appears with a dark background and a blinking cursor. This is the terminal — a text-based way to tell your computer what to do. You type a command, press Enter, and the computer does it.

### Paste the setup command

Copy this entire line:

```
curl -fsSL https://raw.githubusercontent.com/whale/ghost-theme-luis/main/setup.sh | bash
```

Go back to Terminal. Paste it (**Cmd+V**). Press **Enter**.

**What this does:** Downloads a script from your project and runs it. The script installs everything automatically — developer tools, a terminal app called Ghostty, Claude Code, your project files, and 20+ reference themes that Claude will study.

### What to expect

The script takes about 10–15 minutes. It prints what it's doing at each step. Here's what will happen:

1. **It asks for your Mac password.** Type it and press Enter. The characters won't appear as you type — that's a security feature, not a bug. Just type it blind and press Enter.

2. **It may show a dialog box asking to install "Command Line Tools."** Click **Install** and wait for it to finish. This is normal — it's developer tools that macOS needs.

3. **It opens your web browser to connect to GitHub.** Follow the prompts:
   - Choose **GitHub.com**
   - Choose **HTTPS**
   - Choose **Login with a web browser**
   - It shows a short code — paste that code in your browser and click **Authorize**

4. **It downloads your project and reference themes.** This part runs on its own.

5. **It tells you "Setup complete!"** with instructions for what to do next.

If anything goes wrong partway through, just paste the same command again. The script is smart — it skips anything already installed and picks up where it left off.

---

## Step 4: Start Claude Code

The setup installed an app called **Ghostty**. This is your terminal from now on — it's cleaner and faster than the built-in Terminal you used for setup.

### Open Ghostty

Press **Cmd+Space**, type **Ghostty**, press **Enter**.

### Start your project

Type this and press **Enter**:

```
cd ~/ghost-theme-luis && claude
```

**What this means:**
- `cd ~/ghost-theme-luis` = "go to my project folder"
- `&&` = "then"
- `claude` = "start Claude Code"

**First time only:** Claude opens your browser to log in. Use the Claude account you created in Step 1.

### You're in

You'll see a text prompt where you can type in plain English. Try this:

> What files are in my project? Give me a quick overview.

Claude reads your project and explains everything. From here, you describe what you want and Claude builds it.

---

## Your daily routine

After setup is done, this is all you do each day:

1. Open **Ghostty**
2. Type `cd ~/ghost-theme-luis && claude` and press Enter
3. Tell Claude what you want to work on
4. When you want to see changes on your Ghost site, say **"package my theme"** and upload the zip (see below)
5. When you're done for the day, say **"save my progress and push to GitHub"**

---

## Seeing your theme on your Ghost site

When you want to preview what you've built:

1. Tell Claude: **"Package my theme for upload"**
2. Claude creates a `.zip` file and tells you where it is
3. In your browser, go to your Ghost Admin panel: **your-site.ghost.io/ghost/**
4. Go to **Settings** → **Design** → **Change theme** → **Upload theme**
5. Pick the `.zip` file Claude just created
6. Visit your site to see it

---

## Things you can say to Claude

| You say... | What happens |
|---|---|
| "Save my progress" | Creates a save point (like saving a video game) |
| "Undo that" | Reverses the last change |
| "It was working before" | Shows past save points — pick one to go back to |
| "Show me what changed" | Shows a before/after comparison |
| "Package my theme" | Creates a .zip to upload to Ghost |
| "Push my changes" | Sends your work to GitHub so your collaborator can see it |
| "Pull the latest changes" | Gets changes your collaborator made |
| "What does this file do?" | Claude explains any file in plain English |
| "How does Source handle this?" | Claude reads a reference theme and explains their approach |

---

## When things go wrong

**Don't panic.** Every change gets saved automatically. You can always go back.

| What happened | Say this to Claude |
|---|---|
| The last change broke something | "Undo that" |
| It was working earlier today | "Go back to the last version that was working" |
| One file got messed up | "Start over on this file" |
| Everything looks wrong | "Go back to the last save point" |
| You want to try something risky | "Create a branch called experiment" |

Nothing is permanent until you upload it to Ghost. Your live site is safe while you experiment.

---

## Quick glossary

Words you'll see Claude use:

**Terminal / Ghostty** — The app where you type commands. Ghostty is your terminal.

**Command** — A text instruction you type and press Enter to run.

**Git** — Your save-point system. Every "commit" is a snapshot you can return to.

**GitHub** — Where your project lives online. How you and your collaborator share work.

**Clone** — Download a project from GitHub to your computer.

**Push** — Send your changes up to GitHub.

**Pull** — Download changes from GitHub to your computer.

**Commit** — A save point. A snapshot of everything in your project right now.

**Branch** — A parallel copy of your project. Try risky things without affecting the main version.

**Ghost theme** — The files that control how your website looks:
- `.hbs` files — page structure (where things go, like a wireframe)
- `.css` files — styling (colors, fonts, spacing — your Figma design in code)
- `.js` files — behavior (optional — things like "load more posts on scroll")

---

## When you're done with setup

Once Claude Code is running and you can see your project files, text your collaborator:

> I'm set up and Claude is running. Ready to start building.

---

*If you get stuck at any point, ask Claude — it's designed to help you through problems. If Claude can't figure it out, call your collaborator.*
