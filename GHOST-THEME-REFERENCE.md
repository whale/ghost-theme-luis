# Ghost Theme Development Reference

> Compiled from analysis of all 20 official Ghost themes. Use as a baseline for developing new themes.

---

## Table of Contents

1. [Theme Structure Overview](#1-theme-structure-overview)
2. [Template Hierarchy](#2-template-hierarchy)
3. [default.hbs - The Layout Shell](#3-defaulthbs---the-layout-shell)
4. [index.hbs - Homepage](#4-indexhbs---homepage)
5. [post.hbs - Single Post](#5-posthbs---single-post)
6. [page.hbs - Static Pages](#6-pagehbs---static-pages)
7. [Archive Pages (tag.hbs, author.hbs)](#7-archive-pages)
8. [Error Templates](#8-error-templates)
9. [Custom Templates](#9-custom-templates)
10. [Partials System](#10-partials-system)
11. [Handlebars Helpers Reference](#11-handlebars-helpers-reference)
12. [package.json Configuration](#12-packagejson-configuration)
13. [Custom Design Settings (config.custom)](#13-custom-design-settings)
14. [Membership & Paywall Patterns](#14-membership--paywall-patterns)
15. [Build System & Assets](#15-build-system--assets)
16. [Category-Specific Features](#16-category-specific-features)

---

## 1. Theme Structure Overview

### Minimum Required Files

```
theme-name/
  package.json          # Theme metadata and configuration (REQUIRED)
  default.hbs           # Main layout wrapper (REQUIRED)
  index.hbs             # Homepage template (REQUIRED)
  post.hbs              # Single post template (REQUIRED)
```

### Full Standard Structure

```
theme-name/
  package.json
  default.hbs
  index.hbs
  post.hbs
  page.hbs              # Static page template
  tag.hbs               # Tag archive page
  author.hbs            # Author archive page
  error.hbs             # Server error page (standalone, no layout)
  error-404.hbs         # 404 page (uses default layout)
  home.hbs              # Optional: custom homepage (overrides index.hbs on page 1)
  custom-*.hbs          # Optional: per-post layout variants
  partials/
    *.hbs               # Reusable template fragments
    icons/
      *.hbs             # SVG icon partials
    components/         # (newer themes) Modular UI components
      *.hbs
  assets/
    css/
      screen.css        # Main stylesheet (or multiple source files)
    js/
      *.js              # Theme JavaScript
    built/              # Compiled output (CSS + JS)
      screen.css
      theme-name.js
  gulpfile.js           # Build configuration
  routes.yaml           # Optional: custom routing
  locales/              # Optional: translation files
    en.json
```

### Theme Sizes Across Official Themes

| Theme | Files | .hbs Templates | Category |
|-------|-------|----------------|----------|
| casper | 51 | 25 | Magazine (default) |
| source | 69 | 42 | News/Magazine/Newsletter |
| edition | 89 | 36 | Blog/Newsletter |
| dawn | 87 | 33 | Newsletter |
| headline | 66 | 32 | News |
| episode | 45 | 32 | Podcast |
| wave | 77 | 32 | Podcast |
| taste | 39 | 27 | Blog |
| bulletin | 62 | 26 | Newsletter |
| journal | 59 | 25 | Newsletter |
| digest | 59 | 25 | Newsletter |
| alto | 69 | 24 | Blog |
| solo | 46 | 22 | Blog |
| attila | 79 | 28 | Blog |
| dope | 71 | 20 | Magazine |
| liebling | 240 | 20 | Magazine |
| london | 46 | 19 | Magazine |
| ease | 46 | 14 | Documentation |
| ruby | 54 | 12 | Magazine |
| edge | 48 | 10 | Photography |

---

## 2. Template Hierarchy

```
default.hbs                 (layout shell: HTML, head, nav, {{{body}}}, footer)
  |
  +-- index.hbs             (homepage: post loop + pagination)
  +-- home.hbs              (optional: overrides index.hbs on page 1 only)
  +-- post.hbs              (single post: full article + comments + related)
  +-- page.hbs              (static page: content only, no metadata)
  +-- tag.hbs               (tag archive: tag header + post loop)
  +-- author.hbs            (author archive: author header + post loop)
  +-- error-404.hbs         (404 page, uses default layout)
  +-- custom-*.hbs          (per-post layout variants, selectable in editor)
  |
  error.hbs                 (server errors: standalone, NO default layout)
```

Every child template declares `{{!< default}}` on line 1 to inject into `{{{body}}}` of `default.hbs`. The one exception is `error.hbs` which is a standalone HTML page (for reliability during server failures).

When both `home.hbs` and `index.hbs` exist, Ghost uses `home.hbs` for page 1 of the homepage and `index.hbs` for page 2+. Themes using this: episode, wave, digest, bulletin, headline, dope, taste.

---

## 3. default.hbs - The Layout Shell

### Universal Skeleton

Every Ghost theme's default.hbs follows this structure:

```handlebars
<!DOCTYPE html>
<html lang="{{@site.locale}}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{meta_title}}</title>
    <link rel="stylesheet" href="{{asset "built/screen.css"}}">
    {{ghost_head}}
</head>
<body class="{{body_class}}{{{block "body_class"}}}">

    <!-- HEADER / NAVIGATION -->
    <header id="gh-head" class="gh-head gh-outer">
        <div class="gh-head-inner gh-inner">
            <div class="gh-head-brand">
                <a class="gh-head-logo" href="{{@site.url}}">
                    {{#if @site.logo}}
                        <img src="{{@site.logo}}" alt="{{@site.title}}">
                    {{else}}
                        {{@site.title}}
                    {{/if}}
                </a>
                <button class="gh-search gh-icon-btn" data-ghost-search>{{> "icons/search"}}</button>
                <button class="gh-burger"></button>
            </div>
            <nav class="gh-head-menu">
                {{navigation}}
            </nav>
            <div class="gh-head-actions">
                <!-- Member state logic (see Membership section) -->
            </div>
        </div>
    </header>

    <!-- MAIN CONTENT (child template injected here) -->
    {{{body}}}

    <!-- FOOTER -->
    <footer class="gh-foot gh-outer">
        <div class="gh-foot-inner gh-inner">
            <div class="gh-copyright">
                {{@site.title}} &copy; {{date format="YYYY"}}
            </div>
            <nav class="gh-foot-menu">
                {{navigation type="secondary"}}
            </nav>
            <div class="gh-powered-by">
                <a href="https://ghost.org/">Powered by Ghost</a>
            </div>
        </div>
    </footer>

    <script src="{{asset "built/theme-name.js"}}"></script>
    {{ghost_foot}}
</body>
</html>
```

### Mandatory Elements

| Element | Purpose | Placement |
|---------|---------|-----------|
| `{{meta_title}}` | Dynamic page title | In `<title>` |
| `{{@site.locale}}` | HTML lang attribute | On `<html>` |
| `{{ghost_head}}` | SEO meta, structured data, injected code | **Last** in `<head>` |
| `{{{body}}}` | Child template injection (triple-stache, unescaped) | Between header and footer |
| `{{ghost_foot}}` | Portal widget, tracking scripts | **Last** before `</body>` |
| `{{body_class}}` | Context-aware CSS classes | On `<body>` |
| `{{asset "..."}}` | Cache-busted asset URLs | For CSS/JS references |

### Navigation Patterns

**3-column header** (used by most themes):
1. **Brand column**: Logo + mobile hamburger + search button
2. **Menu column**: `{{navigation}}` primary nav
3. **Actions column**: Search + member sign in/subscribe/account buttons

**Two architecture approaches:**
- **Inline** (casper, edition, dawn, ease, edge, solo): Header coded directly in default.hbs
- **Partial-based** (source, episode, taste): `{{> "components/navigation"}}` with parameters

### Color Scheme / Dark Mode

Themes implement dark mode on the `<html>` or `<body>` tag:

```handlebars
{{!-- Casper: class on <html> --}}
<html lang="{{@site.locale}}"
  {{#match @custom.color_scheme "Dark"}} class="dark-mode"
  {{else match @custom.color_scheme "Auto"}} class="auto-color"
  {{/match}}>

{{!-- Dawn: class on <html> --}}
<html{{#match @custom.color_scheme "Dark"}} class="theme-dark"{{/match}}
     {{#match @custom.color_scheme "Light"}} class="theme-light"{{/match}}>

{{!-- Source/Episode: Dynamic contrast calculation via JS in <head> --}}
<style>:root { --background-color: {{@custom.site_background_color}} }</style>
<script>
    // YIQ luminance calculation against background color
    // Sets class="has-light-text" or "has-dark-text" on <html>
</script>
```

### Layout Toggles via Body Class

Body classes drive major layout changes via CSS:

```handlebars
<body class="{{body_class}}
  is-head-{{#match @custom.navigation_layout "Logo on the left"}}left-logo
    {{else match @custom.navigation_layout "Logo in the middle"}}middle-logo
    {{else}}stacked{{/match}}
  {{#match @custom.title_font "=" "Elegant serif"}} has-serif-title{{/match}}
  {{#match @custom.body_font "=" "Modern sans-serif"}} has-sans-body{{/match}}
  {{{block "body_class"}}}">
```

### Block/ContentFor System

Child templates can inject content into the parent layout:

```handlebars
{{!-- In default.hbs: --}}
<body class="{{body_class}}{{{block "body_class"}}}">
{{{block "scripts"}}}

{{!-- In child templates (e.g., custom-full-feature-image.hbs): --}}
{{#contentFor "body_class"}} has-full-image is-head-transparent{{/contentFor}}
```

Used by: edition, dawn, ruby, solo, headline, ease, episode, taste, wave, liebling, dope.

### Conditional Content in default.hbs

Some themes inject homepage-specific content directly in the layout (outside `{{{body}}}`):

```handlebars
{{!-- Edition: featured posts above body on homepage --}}
{{#is "home"}}
    {{> "cover"}}
    {{#if @custom.show_featured_posts}}
        {{> "featured-posts"}}
    {{/if}}
{{/is}}

{{{body}}}
```

### Lightbox / PhotoSwipe

All themes conditionally load a lightbox partial for image zoom on posts/pages:

```handlebars
{{#is "post, page"}}
    {{> "lightbox"}}    {{!-- casper, source --}}
    {{> "pswp"}}        {{!-- edition, dawn, ease, edge --}}
{{/is}}
```

Exception: **edge** loads PhotoSwipe unconditionally because the lightbox is also needed on the index page (photography grid).

---

## 4. index.hbs - Homepage

### Basic Structure

```handlebars
{{!< default}}

<div class="post-feed">
    {{#foreach posts}}
        {{> "post-card"}}
    {{/foreach}}
</div>

{{pagination}}
```

The partial name varies by theme: `"post-card"` (casper), `"loop"` (edition, dawn, edge), `"loop-grid"` (headline).

### Featured Posts - Three Patterns

**Pattern 1 - Separate `{{#get}}` query** (digest, headline):
```handlebars
{{#get "posts" filter="featured:true" limit="5" as |featured|}}
    {{#if featured}}
        <section class="gh-section-featured">
            {{#foreach featured}}
                {{> loop}}
            {{/foreach}}
        </section>
    {{/if}}
{{/get}}
```

**Pattern 2 - Partial in default.hbs** (edition, dawn, ease):
```handlebars
{{!-- In default.hbs, above {{{body}}}: --}}
{{#if @custom.show_featured_posts}}
    {{> "featured-posts"}}
{{/if}}
```

**Pattern 3 - Inline in feed** (casper, edge):
Featured posts appear in the same loop, distinguished only by CSS class from `{{post_class}}`.

### Tag-Based Homepages

Some themes organize the homepage by tags rather than a flat post list:

```handlebars
{{!-- Ease (docs theme): tags as "topics" with nested post queries --}}
{{#get "tags" limit="100"}}
    {{#foreach tags}}
        <section class="topic">
            <h2><a href="{{url}}">{{name}}</a></h2>
            {{#get "posts" order="published_at asc" filter="tag:{{slug}}" limit="5"}}
                {{#foreach posts}}
                    <li><a href="{{url}}">{{title}}</a></li>
                {{/foreach}}
            {{/get}}
        </section>
    {{/foreach}}
{{/get}}
```

```handlebars
{{!-- Headline (news theme): curated sections via tag slugs --}}
{{#get "tags" filter="slug:[{{@custom.enter_tag_slugs_for_primary_sections}}]"}}
    {{#foreach tags}}
        {{> "topic-grid"}}
    {{/foreach}}
{{/get}}
```

### Component-Based Homepage (Source)

Source delegates everything to a component partial:
```handlebars
<main class="gh-main">
    {{> "components/post-list" feed="index" postFeedStyle=@custom.post_feed_style
        showTitle=true showSidebar=@custom.show_publication_info_sidebar}}
</main>
```

---

## 5. post.hbs - Single Post

### Basic Structure

```handlebars
{{!< default}}

{{#post}}
<article class="gh-article {{post_class}}">
    <header class="gh-article-header gh-canvas">
        {{!-- Tags --}}
        {{#primary_tag}}
            <a class="gh-article-tag" href="{{url}}">{{name}}</a>
        {{/primary_tag}}
        {{#if featured}}
            <span class="gh-article-featured">{{> "icons/fire"}} Featured</span>
        {{/if}}

        {{!-- Title --}}
        <h1 class="gh-article-title">{{title}}</h1>

        {{!-- Custom excerpt --}}
        {{#if custom_excerpt}}
            <p class="gh-article-excerpt">{{custom_excerpt}}</p>
        {{/if}}

        {{!-- Metadata --}}
        <div class="gh-article-meta">
            {{#foreach authors}}
                {{#if profile_image}}
                    <img src="{{img_url profile_image size="xs"}}" alt="{{name}}">
                {{/if}}
            {{/foreach}}
            <span>{{authors}}</span>
            <time datetime="{{date format="YYYY-MM-DD"}}">{{date format="DD MMM YYYY"}}</time>
            {{#if reading_time}}<span>{{reading_time}}</span>{{/if}}
        </div>
    </header>

    {{!-- Feature Image --}}
    {{#if feature_image}}
        <figure class="gh-article-image">
            <img
                srcset="{{img_url feature_image size="s"}} 300w,
                        {{img_url feature_image size="m"}} 600w,
                        {{img_url feature_image size="l"}} 1000w,
                        {{img_url feature_image size="xl"}} 2000w"
                sizes="(min-width: 1400px) 1400px, 92vw"
                src="{{img_url feature_image size="xl"}}"
                alt="{{#if feature_image_alt}}{{feature_image_alt}}{{else}}{{title}}{{/if}}"
            />
            {{#if feature_image_caption}}
                <figcaption>{{feature_image_caption}}</figcaption>
            {{/if}}
        </figure>
    {{/if}}

    {{!-- Content --}}
    <section class="gh-content gh-canvas">
        {{content}}
    </section>
</article>
{{/post}}

{{!-- Comments --}}
{{#post}}
    {{#if comments}}
        <section class="gh-comments gh-canvas">
            {{comments}}
        </section>
    {{/if}}
{{/post}}

{{!-- Related Posts --}}
{{#if @custom.show_recent_posts_footer}}
    {{#get "posts" filter="id:-{{id}}" limit="3" as |more_posts|}}
        {{#if more_posts}}
            {{#foreach more_posts}}
                {{> "post-card"}}
            {{/foreach}}
        {{/if}}
    {{/get}}
{{/if}}
```

### Content Rendering

All themes use `{{content}}` (double-stache, not triple) because it's a special helper that already outputs raw HTML. The wrapping classes `gh-content gh-canvas` are near-universal, controlling content width and card styling.

### Related Posts - Two Approaches

**Simple exclusion** (casper): `filter="id:-{{id}}"` - excludes current post
**Tag-based matching** (liebling): `filter="tags:[{{post.tags}}]+id:-{{post.id}}"` - matches shared tags

### Previous/Next Navigation

Only a few themes implement this:
```handlebars
{{#prev_post}}<a href="{{url}}">Previous</a>{{/prev_post}}
{{#next_post}}<a href="{{url}}">Next</a>{{/next_post}}
```

Used by: attila, solo, journal (labels as "Previous issue"/"Next issue").

### Post-Specific Features by Theme

| Feature | Themes |
|---------|--------|
| Reading progress bar | attila |
| Social share buttons | attila (Twitter, Facebook, LinkedIn, Email, Web Share API) |
| Code syntax highlighting | attila (highlight.js) |
| Disqus comments | attila (via `@custom.disqus_shortname`) |
| Drop caps | source (via `@custom.enable_drop_caps_on_posts`) |
| Audio player | wave (custom player using og_description as audio URL) |
| Podcast service links | episode (Apple, Spotify, YouTube Music) |

---

## 6. page.hbs - Static Pages

page.hbs is a stripped-down post.hbs. Key differences:

| Feature | post.hbs | page.hbs |
|---------|----------|----------|
| Title + Feature Image | Always shown | Conditional via `{{#match @page.show_title_and_feature_image}}` |
| Author / Date / Tags | Yes | No |
| Reading Time | Yes | No |
| Comments | Yes | No |
| Related Posts | Yes (often) | No |
| Subscription CTA | Yes (often) | No |
| `{{content}}` | Yes | Yes |

### Typical page.hbs

```handlebars
{{!< default}}

{{#post}}
<article class="gh-article {{post_class}}">
    {{#match @page.show_title_and_feature_image}}
        <header class="gh-article-header gh-canvas">
            <h1 class="gh-article-title">{{title}}</h1>
            {{#if feature_image}}
                <figure class="gh-article-image">...</figure>
            {{/if}}
        </header>
    {{/match}}
    <section class="gh-content gh-canvas">
        {{content}}
    </section>
</article>
{{/post}}
```

The `{{#match @page.show_title_and_feature_image}}` check (Ghost 5+) lets editors toggle title/image visibility per-page from the admin UI.

---

## 7. Archive Pages

### tag.hbs

```handlebars
{{!< default}}

{{#tag}}
<section class="gh-archive">
    {{#if feature_image}}
        <img src="{{img_url feature_image size="l"}}" alt="{{name}}">
    {{/if}}
    <h1>{{name}}</h1>
    {{#if description}}
        <p>{{description}}</p>
    {{else}}
        <p>A collection of {{plural ../pagination.total empty="zero posts" singular="% post" plural="% posts"}}</p>
    {{/if}}
</section>
{{/tag}}

{{#foreach posts}}
    {{> "post-card"}}
{{/foreach}}

{{pagination}}
```

### author.hbs

```handlebars
{{!< default}}

{{#author}}
<section class="gh-archive">
    {{#if profile_image}}
        <img src="{{img_url profile_image}}" alt="{{name}}">
    {{/if}}
    <h1>{{name}}</h1>
    {{#if bio}}<p>{{bio}}</p>{{/if}}
    {{#if location}}<span>{{location}}</span>{{/if}}
    {{!-- Social links --}}
    {{#if twitter}}<a href="{{social_url type="twitter"}}">Twitter</a>{{/if}}
    {{#if facebook}}<a href="{{social_url type="facebook"}}">Facebook</a>{{/if}}
    {{#if linkedin}}<a href="{{social_url type="linkedin"}}">LinkedIn</a>{{/if}}
    {{!-- + bluesky, threads, mastodon, tiktok, youtube, instagram --}}
</section>
{{/author}}

{{#foreach posts}}
    {{> "post-card"}}
{{/foreach}}

{{pagination}}
```

Both follow the same pattern: scoped data block (`{{#tag}}` or `{{#author}}`), metadata header, then standard post loop with pagination.

---

## 8. Error Templates

### error.hbs (Server Errors)

**Does NOT use `{{!< default}}`** - it's a standalone HTML page for reliability during server failures. No `{{ghost_head}}`, no `{{ghost_foot}}`, no JavaScript, no API calls.

```handlebars
<!DOCTYPE html>
<html>
<head>
    <title>{{meta_title}}</title>
    <link rel="stylesheet" href="{{asset "built/screen.css"}}">
</head>
<body>
    <h1>{{statusCode}}</h1>
    <p>{{message}}</p>
    <a href="{{@site.url}}">Go to the front page</a>

    {{!-- Development: theme validation errors --}}
    {{#if errorDetails}}
        {{#foreach errorDetails}}
            <em>{{{rule}}}</em>
            {{#foreach failures}}
                <p>{{ref}}: {{message}}</p>
            {{/foreach}}
        {{/foreach}}
    {{/if}}
</body>
</html>
```

### error-404.hbs (Not Found)

**Uses `{{!< default}}`** - a 404 is normal operation, not a server failure. Can safely fetch content:

```handlebars
{{!< default}}

<h1>{{statusCode}}</h1>
<p>{{message}}</p>
<a href="{{@site.url}}">Go to the front page</a>

{{#get "posts" limit="3" as |posts|}}
    {{#foreach posts}}
        {{> "post-card"}}
    {{/foreach}}
{{/get}}
```

Most official themes (source, edition, dawn, etc.) do NOT provide error templates, relying on Ghost's built-in defaults.

---

## 9. Custom Templates

Custom templates (named `custom-*.hbs`) appear in the Ghost editor's template selector, letting authors choose per-post layouts.

### Found Across Official Themes

| Theme | Template | Purpose |
|-------|----------|---------|
| edition | `custom-full-feature-image.hbs` | Full-width feature image |
| edition | `custom-narrow-feature-image.hbs` | Narrow feature image |
| edition | `custom-no-feature-image.hbs` | No feature image |
| dawn | `custom-full-feature-image.hbs` | Full-width feature image |
| dawn | `custom-narrow-feature-image.hbs` | Narrow feature image |
| dawn | `custom-no-feature-image.hbs` | No feature image |
| headline | `custom-full-feature-image.hbs` | Full-screen cover image |
| headline | `custom-wide-feature-image.hbs` | Wide feature image |

### Implementation Pattern

Custom templates pass different parameters to a shared content partial:

```handlebars
{{!-- custom-full-feature-image.hbs --}}
{{!< default}}
{{#post}}
    {{> "content" width="full"}}
{{/post}}
{{> "related-posts"}}
{{#post}}{{> "comments"}}{{/post}}

{{!-- custom-narrow-feature-image.hbs --}}
{{!< default}}
{{#post}}
    {{> "content" width="narrow"}}
{{/post}}

{{!-- custom-no-feature-image.hbs --}}
{{!< default}}
{{#post}}
    {{> "content" no_image=true}}
{{/post}}
```

Headline's `custom-full-feature-image.hbs` also uses `{{#contentFor "body_class"}}` to inject CSS classes into the parent layout for transparent header support.

---

## 10. Partials System

### Universal Partials (found in most themes)

| Partial | Purpose |
|---------|---------|
| `loop.hbs` or `post-card.hbs` | Post card in feed listings |
| `pswp.hbs` or `lightbox.hbs` | PhotoSwipe lightbox markup |
| `icons/*.hbs` | SVG icons as inline partials |
| `navigation.hbs` or `components/navigation.hbs` | Header navigation |
| `content-cta.hbs` | Paywall/subscription call-to-action |
| `feature-image.hbs` | Responsive feature image rendering |

### Naming Conventions

- **Flat structure** (casper, dawn, edition): `partials/post-card.hbs`, `partials/loop.hbs`
- **Component-based** (source, episode, taste): `partials/components/navigation.hbs`, `partials/components/footer.hbs`
- **Icon partials**: Always under `partials/icons/` with SVG markup

### Passing Parameters to Partials

```handlebars
{{!-- Passing custom settings --}}
{{> "components/navigation" navigationLayout=@custom.navigation_layout}}

{{!-- Passing layout parameters --}}
{{> "content" width="full"}}
{{> "content" width="narrow" no_image=true}}

{{!-- Passing IDs for form fields --}}
{{> "email-subscription" email_field_id="footer-email"}}

{{!-- Passing display toggles --}}
{{> "components/post-list" feed="index" postFeedStyle=@custom.post_feed_style
    showTitle=true showSidebar=@custom.show_publication_info_sidebar}}

{{!-- Passing data --}}
{{> components/footer footerText=@custom.footer_text}}
```

### Post Card Partial (Representative Example)

```handlebars
{{!-- partials/post-card.hbs (Casper pattern) --}}
<article class="post-card {{post_class}}">
    {{#if feature_image}}
    <a class="post-card-image-link" href="{{url}}">
        <img class="post-card-image"
            srcset="{{img_url feature_image size="s"}} 300w,
                    {{img_url feature_image size="m"}} 600w,
                    {{img_url feature_image size="l"}} 1000w,
                    {{img_url feature_image size="xl"}} 2000w"
            sizes="(max-width: 1000px) 400px, 800px"
            src="{{img_url feature_image size="m"}}"
            alt="{{#if feature_image_alt}}{{feature_image_alt}}{{else}}{{title}}{{/if}}"
            loading="lazy" />
        {{!-- Access badge --}}
        {{#unless access}}{{^has visibility="public"}}
            <div class="post-card-access">
                {{> "icons/lock"}}
                {{#has visibility="members"}}Members only{{else}}Paid-members only{{/has}}
            </div>
        {{/has}}{{/unless}}
    </a>
    {{/if}}
    <div class="post-card-content">
        <a href="{{url}}">
            <div class="post-card-tags">
                {{#primary_tag}}<span>{{name}}</span>{{/primary_tag}}
                {{#if featured}}<span>{{> "icons/fire"}} Featured</span>{{/if}}
            </div>
            <h2 class="post-card-title">{{title}}</h2>
            {{#if excerpt}}<p class="post-card-excerpt">{{excerpt}}</p>{{/if}}
        </a>
        <footer class="post-card-meta">
            <time datetime="{{date format="YYYY-MM-DD"}}">{{date format="DD MMM YYYY"}}</time>
            {{#if reading_time}}<span>{{reading_time}}</span>{{/if}}
            {{#if @site.comments_enabled}}{{comment_count}}{{/if}}
        </footer>
    </div>
</article>
```

---

## 11. Handlebars Helpers Reference

### Layout & Structure

| Helper | Description | Used In |
|--------|-------------|---------|
| `{{ghost_head}}` | SEO meta, structured data, injected code | Every default.hbs |
| `{{ghost_foot}}` | Portal widget, tracking scripts | Every default.hbs |
| `{{{body}}}` | Child template injection (triple-stache) | default.hbs only |
| `{{body_class}}` | Context CSS classes (home-template, post-template, etc.) | Every default.hbs |
| `{{post_class}}` | Post-specific CSS classes | Post cards and articles |
| `{{meta_title}}` | SEO page title | Every default.hbs |
| `{{asset "path"}}` | Cache-busted asset URL | CSS/JS references |
| `{{pagination}}` | Built-in pagination navigation | index, tag, author |
| `{{{block "name"}}}` | Block placeholder in parent | default.hbs |
| `{{#contentFor "name"}}` | Inject into parent block | Child templates |

### Content

| Helper | Description |
|--------|-------------|
| `{{content}}` | Full post HTML (special helper, already unescaped) |
| `{{excerpt}}` | Plain-text excerpt. Supports `words="N"` |
| `{{title}}` | Post/page title |
| `{{url}}` | Post/page URL. Supports `absolute="true"` |
| `{{custom_excerpt}}` | Author-provided custom excerpt |
| `{{{html}}}` | Raw HTML (used in paywall context for truncated content) |

### Data Fetching

**`{{#get}}` - The most powerful helper.** Queries the Ghost API:

```handlebars
{{!-- Featured posts --}}
{{#get "posts" filter="featured:true" limit="5" as |featured|}}

{{!-- Related posts (by shared tags) --}}
{{#get "posts" filter="tags:[{{post.tags}}]+id:-{{post.id}}" limit="3" as |related|}}

{{!-- Posts by tag --}}
{{#get "posts" filter="tag:{{slug}}" limit="7" include="tags,authors"}}

{{!-- Tag listing with counts --}}
{{#get "tags" include="count.posts" order="count.posts desc" limit="100"}}

{{!-- All authors --}}
{{#get "authors" limit="all" include="count.posts" order="count.posts desc"}}

{{!-- Check if page 2 exists --}}
{{#get "posts" fields="id" limit="10" page="2" as |secondPage|}}
```

### Iteration

```handlebars
{{#foreach posts}}...{{/foreach}}               {{!-- Standard loop --}}
{{#foreach posts limit="1"}}...{{/foreach}}      {{!-- Limited --}}
{{#foreach posts visibility="all"}}...{{/foreach}} {{!-- All visibility levels --}}
{{#foreach authors}}...{{/foreach}}
{{#foreach tags}}...{{/foreach}}
{{#foreach navigation}}...{{/foreach}}
```

Loop variables: `@first`, `@last`, `@index`, `@odd`, `@even`.

### Context Checking

**`{{#is}}` - Page context:**
```handlebars
{{#is "home"}}...{{/is}}
{{#is "post"}}...{{/is}}
{{#is "post, page"}}...{{/is}}
{{#is "tag, author"}}...{{/is}}
{{^is "home"}}...{{/is}}              {{!-- inverted --}}
```

**`{{#has}}` - Content properties:**
```handlebars
{{#has visibility="paid"}}...{{/has}}
{{#has visibility="members"}}...{{/has}}
{{#has visibility="filter"}}...{{/has}}
{{^has visibility="public"}}...{{/has}}      {{!-- inverted --}}
{{#has index="0"}}...{{/has}}                {{!-- first item --}}
{{#has number="nth:3"}}...{{/has}}           {{!-- every 3rd --}}
{{#has any="twitter, facebook"}}...{{/has}}  {{!-- author socials --}}
```

**`{{#match}}` - Value comparison (heavily used for custom settings):**
```handlebars
{{#match @custom.feed_layout "Classic"}}...{{/match}}
{{#match @custom.feed_layout "!=" "Hidden"}}...{{/match}}
{{#match posts.length ">=" 7}}...{{/match}}
{{#match @page.show_title_and_feature_image}}...{{/match}}

{{!-- Chained else match: --}}
{{#match @custom.color_scheme "Dark"}} ...
{{else match @custom.color_scheme "Auto"}} ...
{{/match}}
```

### Post Data

```handlebars
{{#post}}...{{/post}}                  {{!-- Post data scope --}}
{{#primary_tag}}<a href="{{url}}">{{name}}</a>{{/primary_tag}}
{{primary_tag.name}}                    {{!-- Dot notation --}}
{{primary_tag.accent_color}}            {{!-- Tag accent color --}}
{{#prev_post}}<a href="{{url}}">{{/prev_post}}
{{#next_post}}<a href="{{url}}">{{/next_post}}
{{#tag}}...{{/tag}}                    {{!-- Tag archive data scope --}}
{{#author}}...{{/author}}              {{!-- Author archive data scope --}}
```

### Date Formatting

```handlebars
{{date format="YYYY-MM-DD"}}              {{!-- ISO: 2024-01-15 --}}
{{date format="DD MMM YYYY"}}             {{!-- Display: 15 Jan 2024 --}}
{{date format="MMMM YYYY"}}              {{!-- Month: January 2024 --}}
{{date format="YYYY"}}                    {{!-- Year only (for copyright) --}}
{{date published_at format="DD MMM YYYY"}} {{!-- Explicit field --}}
{{date updated_at format="DD MMM YYYY"}}   {{!-- Last updated (ease) --}}
{{date published_at timeago="true"}}       {{!-- Relative: "3 days ago" --}}
```

### Images

```handlebars
{{!-- Responsive srcset pattern --}}
srcset="{{img_url feature_image size="s"}} 300w,
        {{img_url feature_image size="m"}} 600w,
        {{img_url feature_image size="l"}} 1000w,
        {{img_url feature_image size="xl"}} 2000w"

{{!-- WebP format (source theme) --}}
{{img_url feature_image size="s" format="webp"}}

{{!-- Profile images --}}
{{img_url profile_image size="xs"}}

{{!-- Available named sizes: xxs, xs, s, m, l, xl, xxl --}}
{{!-- (defined in package.json config.image_sizes) --}}
```

### Navigation

```handlebars
{{navigation}}                         {{!-- Primary nav --}}
{{navigation type="secondary"}}        {{!-- Footer nav --}}

{{!-- Manual iteration (liebling): --}}
{{#foreach navigation}}
    <li class="nav-{{slug}}{{#if current}} nav-current{{/if}}">
        <a href="{{url absolute="true"}}">{{label}}</a>
    </li>
{{/foreach}}
```

### Metadata & Counters

```handlebars
{{reading_time}}                                           {{!-- "5 min read" --}}
{{reading_time minute="1 min" minutes="% min"}}            {{!-- Custom format --}}
{{comment_count}}                                          {{!-- Comment count --}}
{{comment_count class="gh-comments-count"}}                {{!-- With CSS class --}}
{{comments}}                                               {{!-- Full comment embed --}}
{{comments title="" count=false}}                          {{!-- No title/count --}}
{{plural pagination.total empty="0" singular="% post" plural="% posts"}}
{{recommendations}}                                        {{!-- Recommendations widget --}}
{{social_url type="twitter"}}                              {{!-- Social profile URL --}}
{{tiers}}                                                  {{!-- List membership tiers --}}
```

### Site-Level Data (`@site`)

```handlebars
{{@site.title}}                    {{!-- Publication name --}}
{{@site.description}}              {{!-- Publication description --}}
{{@site.url}}                      {{!-- Base URL --}}
{{@site.logo}}                     {{!-- Logo image URL --}}
{{@site.icon}}                     {{!-- Favicon/icon --}}
{{@site.cover_image}}              {{!-- Site cover image --}}
{{@site.locale}}                   {{!-- Language locale --}}
{{@site.members_enabled}}          {{!-- Membership active? --}}
{{@site.members_invite_only}}      {{!-- Invite-only signups? --}}
{{@site.comments_enabled}}         {{!-- Comments active? --}}
{{@site.paid_members_enabled}}     {{!-- Paid tiers active? --}}
{{@site.recommendations_enabled}}  {{!-- Recommendations active? --}}
```

### Translation

```handlebars
{{t "Subscribe"}}                  {{!-- Translated string --}}
{{t "1 min read"}}                 {{!-- Used in helper params --}}
{{reading_time minute=(t "1 min read") minutes=(t "% min read")}}
```

Used by attila and liebling. Requires `locales/en.json` (or other locale files).

---

## 12. package.json Configuration

### Required Fields

```json
{
    "name": "theme-name",
    "description": "A brief theme description",
    "version": "1.0.0",
    "engines": { "ghost": ">=5.0.0" },
    "license": "MIT",
    "keywords": ["ghost", "theme", "ghost-theme"],
    "author": {
        "name": "Author Name",
        "email": "author@example.com",
        "url": "https://example.com"
    },
    "config": {
        "posts_per_page": 10,
        "image_sizes": { ... },
        "card_assets": true,
        "custom": { ... }
    }
}
```

### posts_per_page

Controls pagination. Range across official themes: 3 (episode) to 25 (casper).

| Value | Typical Use |
|-------|-------------|
| 3-5 | Podcast, single-column, visual-heavy themes |
| 6-10 | Standard blogs, newsletters |
| 12-15 | Grid layouts, magazines |
| 25 | Dense listing (casper) |

### image_sizes

Ghost generates responsive image variants. The standard set used by most official themes:

```json
"image_sizes": {
    "xs":  { "width": 150 },
    "s":   { "width": 300 },
    "m":   { "width": 720 },
    "l":   { "width": 960 },
    "xl":  { "width": 1200 },
    "xxl": { "width": 2000 }
}
```

Casper and liebling add `"xxs": { "width": 30 }` for LQIP (Low Quality Image Placeholder) blur-up effects.

Templates reference sizes via: `{{img_url feature_image size="l"}}`.

### card_assets

Controls whether Ghost auto-injects CSS/JS for editor cards (bookmark, gallery, etc.):

```json
"card_assets": true              // Most themes: inject all card assets
"card_assets": {                 // Liebling: custom card styling
    "exclude": ["bookmark", "gallery"]
}
```

---

## 13. Custom Design Settings

The `config.custom` section defines settings visible in Ghost Admin > Design > Site-wide.

### Setting Types

**Select (dropdown):**
```json
"navigation_layout": {
    "type": "select",
    "options": ["Logo on the left", "Logo in the middle", "Stacked"],
    "default": "Logo on the left"
}
```

**Boolean (toggle):**
```json
"show_related_posts": {
    "type": "boolean",
    "default": true,
    "group": "post"
}
```

**Text (free input):**
```json
"email_signup_text": {
    "type": "text",
    "default": "Sign up for more like this.",
    "group": "post"
}
```

**Color (color picker):**
```json
"site_background_color": {
    "type": "color",
    "default": "#ffffff"
}
```

**Image (image uploader):**
```json
"white_logo_for_dark_mode": {
    "type": "image",
    "group": "homepage"
}
```

### Groups

Settings are organized into groups in Ghost Admin:
- `"homepage"` - Controls homepage layout/content
- `"post"` - Controls individual post display
- *(ungrouped)* - Appears in site-wide settings

### Conditional Visibility (Source only)

```json
"header_text": {
    "type": "text",
    "group": "homepage",
    "description": "Defaults to site description when empty",
    "visibility": "header_style:[Landing, Search]"
}
```

Setting only appears when another setting has a specific value.

### Common Settings Across Themes

| Setting | Type | Themes |
|---------|------|--------|
| `navigation_layout` | select | 17/20 |
| `title_font` | select | 17/20 |
| `body_font` | select | 17/20 |
| `color_scheme` | select | casper, dawn, alto, attila |
| `feed_layout` / `post_feed_style` | select | casper, edition, source |
| `header_style` | select | casper, source, headline |
| `show_featured_posts` | boolean | edition, dawn, ease, alto, source |
| `show_author` | boolean | source, edition, dawn, dope, alto |
| `show_related_posts` | boolean | dawn, edition, dope, edge, alto, ruby, source |
| `email_signup_text` | text | casper, edition, episode, headline, taste |

### Settings Complexity by Theme

Source is the most configurable (17 settings), followed by edition (11) and casper/episode (10 each). Bulletin and journal are the most minimal (3 each).

---

## 14. Membership & Paywall Patterns

### Navigation Member State Logic

The single most shared code pattern across all 20 themes:

```handlebars
{{#unless @site.members_enabled}}
    {{!-- Members OFF: search only --}}
    <button data-ghost-search>Search</button>
{{else}}
    <button data-ghost-search>Search</button>
    {{#unless @member}}
        {{!-- Not logged in --}}
        {{#unless @site.members_invite_only}}
            <a href="#/portal/signin" data-portal="signin">Sign in</a>
            <a href="#/portal/signup" data-portal="signup">Subscribe</a>
        {{else}}
            <a href="#/portal/signin" data-portal="signin">Sign in</a>
        {{/unless}}
    {{else}}
        {{!-- Logged in --}}
        <a href="#/portal/account" data-portal="account">Account</a>
    {{/unless}}
{{/unless}}
```

### Content Paywall CTA

Displayed when a post's content is gated:

```handlebars
{{{html}}}   {{!-- Truncated preview content --}}
<section class="content-cta">
    {{#has visibility="paid"}}
        <h2>This post is for paying subscribers only</h2>
    {{/has}}
    {{#has visibility="members"}}
        <h2>This post is for subscribers only</h2>
    {{/has}}
    {{#has visibility="filter"}}
        <h2>This post is for subscribers on the {{tiers}} only</h2>
    {{/has}}

    {{#if @member}}
        <button data-portal="account/plans">Upgrade now</button>
    {{else}}
        <button data-portal="signup">Subscribe now</button>
        <button data-portal="signin">Already have an account? Sign in</button>
    {{/if}}
</section>
```

Three visibility levels: `paid`, `members`, `filter` (specific tiers).
Two user states: logged in (upgrade) vs not logged in (subscribe).

### Portal Integration (`data-portal`)

All membership actions go through Ghost Portal:

| Attribute | Action |
|-----------|--------|
| `data-portal="signup"` | Opens signup modal |
| `data-portal="signin"` | Opens signin modal |
| `data-portal="account"` | Opens account settings |
| `data-portal="account/plans"` | Opens plan upgrade |
| `data-portal="upgrade"` | Opens upgrade flow |
| `data-portal` (bare) | Opens generic portal |

### Form-Based Signup

For inline email forms without opening Portal:

```handlebars
<form data-members-form>
    <input type="email" name="email" placeholder="jamie@example.com"
           required data-members-email>
    <button type="submit">Subscribe</button>
    <p data-members-error></p>
</form>
```

The `data-members-form` and `data-members-email` attributes handle signup without a modal.

### Access Badge on Post Cards

```handlebars
{{#unless access}}
    {{^has visibility="public"}}
        <div class="post-card-access">
            {{> "icons/lock"}}
            {{#has visibility="members"}}Members only{{else}}Paid-members only{{/has}}
        </div>
    {{/has}}
{{/unless}}
```

### Member Data Available

```handlebars
{{@member}}                    {{!-- Current member object (falsy if not logged in) --}}
{{@member.paid}}               {{!-- Boolean: is a paid subscriber? --}}
{{@site.members_enabled}}      {{!-- Boolean: membership feature active? --}}
{{@site.paid_members_enabled}} {{!-- Boolean: paid tiers exist? --}}
{{@site.members_invite_only}}  {{!-- Boolean: invite-only mode? --}}
{{access}}                     {{!-- Boolean: current viewer can see this content --}}
{{visibility}}                 {{!-- String: "public", "members", "paid", or filter --}}
```

---

## 15. Build System & Assets

### Standard Build Pipeline (18/20 themes)

All official Ghost themes use **Gulp** with this pipeline:

```
CSS: PostCSS (easy-import -> autoprefixer -> cssnano)
JS:  Concatenate + Uglify
HBS: Livereload
```

Standard npm scripts:
```json
"scripts": {
    "dev": "gulp",
    "zip": "gulp zip",
    "test": "gscan ."
}
```

**CSS pipeline** (gulpfile.js):
```javascript
function css(done) {
    pump([
        src('assets/css/screen.css', {sourcemaps: true}),
        postcss([
            easyimport,       // Resolve @import statements
            autoprefixer(),   // Vendor prefixes
            cssnano()         // Minification
        ]),
        dest('assets/built/', {sourcemaps: '.'}),
        livereload()
    ], handleError(done));
}
```

**JS pipeline:**
```javascript
function js(done) {
    pump([
        src(['assets/js/lib/*.js', 'assets/js/*.js'], {sourcemaps: true}),
        concat('theme-name.js'),
        uglify(),
        dest('assets/built/', {sourcemaps: '.'}),
        livereload()
    ], handleError(done));
}
```

### Exceptions

| Theme | Build Tool | CSS Approach |
|-------|-----------|-------------|
| attila | Grunt | Sass (.scss) |
| liebling | Laravel Mix (Webpack) | Sass, page-specific CSS bundles |

### Common Dependencies

| Package | Purpose |
|---------|---------|
| `gulp` | Task runner |
| `postcss` + `postcss-easy-import` | CSS imports resolution |
| `autoprefixer` | CSS vendor prefixes |
| `cssnano` | CSS minification |
| `gulp-concat` + `gulp-uglify` | JS bundling |
| `gulp-livereload` | Dev auto-refresh |
| `gulp-zip` | Distribution packaging |
| `gscan` | Ghost theme validation/linting |
| `@tryghost/shared-theme-assets` | Shared JS (pagination, lightbox, header) |

### CSS Organization

**Modular** (most themes): Separate files per component, imported via PostCSS:
```
assets/css/
  screen.css          # Entry point with @imports
  general/
    vars.css          # CSS custom properties
    reset.css
    typography.css
  blog/
    article.css
    post-card.css
  site/
    header.css
    footer.css
    cover.css
```

**CSS Custom Properties** commonly used:
```css
:root {
    --font-sans: Inter, -apple-system, BlinkMacSystemFont, sans-serif;
    --font-serif: Lora, Times, serif;
    --color-primary-text: #15171a;
    --ghost-accent-color: #...;    /* Set by Ghost from admin settings */
    --content-width: 640px;
}
```

Ghost injects `--ghost-accent-color` automatically. Themes reference it: `var(--ghost-accent-color, #fallback)`.

### Theme Validation

All themes include `gscan` for validation:
```bash
npm test    # Runs: gscan .
```

gscan checks for required files, valid package.json, correct helper usage, and accessibility.

---

## 16. Category-Specific Features

### Podcast Themes (episode, wave)

**Episode:**
- External podcast platform links (Apple, Spotify, YouTube Music) via `@custom` settings
- No built-in audio player - relies on Ghost's native audio card
- Dynamic text contrast calculation against configurable background color
- `home.hbs` for landing page, `index.hbs` for "All episodes" archive
- Suppresses feature image on episode pages (`hideFeatureImage=true`)

**Wave (most feature-rich podcast theme):**
- **Custom audio player** with play/pause, skip -10s/+30s, speed control (1x/1.5x/2x), progress bar
- **Repurposes `og_description` field** as audio file URL: `<audio src="{{og_description}}">`
- **Custom podcast RSS feed** (`rss.hbs`) with iTunes/Google Play namespace extensions
- **Custom routing** (`routes.yaml`): separates podcast episodes from blog posts (tagged `blog` at `/blog/`)
- Persistent bottom-bar player on non-post pages
- Content-type detection: shows player when `og_description` exists, standard layout otherwise
- Labels: "Hosted by" for episodes, "Written by" for blog posts

### Newsletter Themes (dawn, journal, digest, bulletin)

**Common patterns:**
- "Issues" vocabulary instead of "posts"
- Prominent subscribe CTAs with fake email input styling
- Previous/next "issue" navigation
- Content-CTA paywall with gradient overlay
- Full article display on homepage (latest issue)

**Dawn:** Dark mode support, white logo for dark mode, custom post layout templates (full/narrow/no feature image)

**Journal:** Most newsletter-centric - sidebar layout with About section, email signup, featured posts, topic tags with issue counts, recommendations widget

**Digest:** Displays most recent post's full content directly on homepage; archive page with featured + latest sections

**Bulletin:** Most dramatic non-member experience - split-screen layout with subscribe CTA (left panel) and latest issue preview (right panel). Full-viewport height.

### Documentation Theme (ease)

- **Tag-based hierarchical navigation**: All content organized by tags as "topics"
- Posts ordered `published_at asc` (oldest first) for logical reading order
- "Last updated on" instead of "Published at" using `{{date updated_at}}`
- Minimal post cards: title + short excerpt, no images, no dates
- Previous/Next pagination between posts (page-turning in docs)
- No author information shown
- Prominent search bar with `data-ghost-search`
- Cover image with parallax (jarallax)
- Featured posts carousel (owl.carousel)

### Photography Theme (edge)

- **Masonry grid layout** via Masonry.js with `grid-sizer` anchor element
- **PhotoSwipe lightbox** loaded unconditionally (needed on index page too)
- Full-screen image viewer with zoom and navigation
- Only renders posts WITH feature images (skips text-only posts)
- Responsive grid: 3 columns desktop, 2 columns tablet
- Related posts use the same masonry grid layout

### News/Magazine Themes (headline, dope, london, ruby)

**Headline:** Most advanced tag-based section system with two section types:
- Primary sections (curated via tag slugs): large grid cards, 7 posts
- Secondary sections: compact text-only lists, 5 posts
- Auto-selects top 3 tags by post count if not configured
- Custom post templates for feature image variants

**Dope:** Full-screen tag carousel homepage (Owl Carousel), off-canvas side menu with recent posts + recommendations, parallax effects (jarallax), lock icon for paid content

**London:** Grid layout with every-3rd-post large card (`{{#has number="nth:3"}}post-card-large{{/has}}`), simplest magazine architecture

**Ruby:** Tag accent color integration via CSS custom properties (`style="--tag-color: {{primary_tag.accent_color}}"`), featured posts get full images vs constrained placeholders

### Blog Themes - Distinguishing Features

| Theme | Unique Features |
|-------|----------------|
| **casper** | Infinite scroll, dark mode (Light/Dark/Auto), multiple header styles, post image style options |
| **solo** | Personal/author-focused, three header layouts (Side by side, Large background, Typographic profile) |
| **taste** | Tag-based section grid alternating 3/4 columns, header action options (Subscribe/Search/None) |
| **alto** | Dark mode, white logo for dark mode, Owl Carousel featured slider |
| **edition** | Full-screen cover with parallax, featured posts carousel (tiny-slider), feed layout options (Expanded/Right thumbnail/Text-only/Minimal) |
| **attila** | Reading progress bar, code syntax highlighting (hljs), share options (Native/Default/Disabled), Disqus support, Sass, translations |
| **liebling** | Dark mode toggle with localStorage, Swiper.js featured slider, custom CTA button, page-specific CSS loading, bundled fonts, search API, fade animation toggle |

---

## Quick Start: Building a New Theme

1. Create `package.json` with `name`, `version`, `engines.ghost`, `config` (posts_per_page, image_sizes, card_assets)
2. Create `default.hbs` with the mandatory elements (ghost_head, body, ghost_foot, navigation)
3. Create `index.hbs` with `{{!< default}}`, a `{{#foreach posts}}` loop, and `{{pagination}}`
4. Create `post.hbs` with `{{!< default}}`, `{{#post}}` scope, and `{{content}}`
5. Add `page.hbs` (simplified post.hbs without metadata/comments)
6. Add `tag.hbs` and `author.hbs` for archive pages
7. Create partials for reusable components (post-card, navigation, icons)
8. Set up Gulp + PostCSS build pipeline
9. Validate with `gscan .`
10. Add `config.custom` settings for design customization in Ghost Admin
