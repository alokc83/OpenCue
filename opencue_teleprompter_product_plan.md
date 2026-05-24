# OpenCue Teleprompter Product Plan

## Executive recommendation

Build this as a **native macOS teleprompter for creators, presenters, podcasters, streamers, and solo video makers**.

Do **not** start by trying to beat every commercial app. Start by being the best at one painful workflow:

> I need a clean, reliable, private teleprompter on my Mac that works during Zoom, OBS, screen recording, external displays, and Elgato Prompter style setups without getting in my way.

That means the MVP should not be just a scrolling text box. It should be:

1. Script editor and script library
2. Smooth prompter playback
3. Floating overlay mode
4. Full screen mode
5. External display and mirror mode
6. Keyboard control
7. Local first storage
8. Strong typography and readability
9. No login, no cloud, no privacy creep

Voice following, remote control, video recording, Stream Deck, captions, AI cleanup, mobile companion, and team workflows should come later.

Competitors already cover a lot. PromptSmart’s big differentiator is voice based scrolling that follows speech and pauses when the speaker pauses. Teleprompter Pro and Teleprompter Premium emphasize import, mirroring, duplicate display windows, remote control, transparent windows, cue points, timed scrolling, custom colors, and browser based control. Teleprompter.com adds recording, horizontal and vertical mirroring, remote control, automatic captions, cloud import, keyboard shortcuts, offline use, and display customization. QPrompt proves there is real open source demand for a free, full featured teleprompter, especially for creators and event operators. Textream is especially relevant because it is already an open source macOS teleprompter with local speech recognition, word tracking, floating overlay, notch style display, and full screen modes.

Your gap is this:

> A polished native macOS teleprompter that is open source, privacy first, great with creator hardware, great as a floating overlay, and simple enough for normal people.

That is a good project.

---

# 1. Product positioning

## Product name idea

Working names:

| Name | Why it works |
|---|---|
| OpenCue | Professional, simple, open source friendly |
| CueKit | Mac native, developer friendly |
| Promptly | Friendly creator tool vibe |
| MacCue | Direct macOS positioning |
| GlassCue | Good if the product leans into prompter glass and overlay workflows |

My recommendation: **OpenCue**.

It sounds serious, open source, and not locked to one device.

## Primary users

### 1. Solo YouTubers and creators

They want scripts while recording, but they do not want to look like they are reading. They need adjustable text position, narrow reading area near camera, transparent overlay, keyboard control, and quick script editing.

### 2. Podcasters and interviewers

They need outline prompts, questions, intro notes, sponsor reads, guest bios, and segment markers. They do not always need full word by word script playback.

### 3. Remote workers and presenters

They need to read during Zoom, Teams, Meet, Loom, webinars, and sales calls. PromptSmart explicitly calls out semi transparent presentation windows over meetings as a corporate workflow.

### 4. Studio and production users

They need external display output, mirror mode, cue points, remote control, hardware control, and very reliable playback. Teleprompter Pro specifically promotes HDMI or AirPlay clean feed output with independent mirroring for pro hardware.

### 5. Elgato Prompter users

Elgato Prompter behaves like an external display, and users can move any app or window onto the Prompter display like an extra monitor. Teleprompter Pro’s guide also confirms that on Mac you can move its window to the Elgato Prompter display or use duplicate window mode. This is a strong product opportunity.

---

# 2. Core product principles

## Principle 1: Local first

No account. No cloud required. Scripts stay on the Mac unless the user chooses export or sync.

This matters because scripts may contain internal company notes, financial results, unreleased videos, podcast guests, or private talking points.

## Principle 2: Readability beats features

The prompter view must be excellent:

| Requirement | Why it matters |
|---|---|
| Large text | Reduces eye strain |
| Adjustable line height | Makes reading smoother |
| Adjustable width | Prevents eye movement from looking obvious |
| Vertical center marker | Helps the speaker stay on target |
| Side margins | Helps prompter glass and external monitors |
| Theme presets | Fast setup under pressure |
| Smooth scrolling | Bad scrolling ruins the product |
| Keyboard controls | Presenters cannot keep grabbing the mouse |

## Principle 3: Mac first, not generic desktop

Use SwiftUI where it fits, but use AppKit for serious window control. For macOS distribution outside the App Store, Developer ID and notarization are important for safe installation. Sparkle is a good later choice for automatic updates because it is an open source macOS update framework under MIT.

## Principle 4: Progressive releases

Every release should build on the previous one. Avoid “big rewrite later” traps.

## Principle 5: Open source project quality

The app needs docs, issue templates, contribution guide, architecture notes, screenshots, releases, changelog, and testable modules from the beginning.

---

# 3. Deep feature research

## A. Script creation and management

Expected features:

| Feature | MVP | Later | Notes |
|---|---:|---:|---|
| Create script | Yes |  | Basic editor |
| Edit script | Yes |  | Must be fast and obvious |
| Script library | Yes |  | Recent scripts, search, folders later |
| Auto save | Yes |  | Prevents panic during prep |
| Import TXT | Yes |  | Very easy |
| Import Markdown | Yes |  | Great for creators |
| Import RTF | 1.0 |  | Common Mac document format |
| Import PDF | 1.0 or 1.1 |  | Competitors support PDF import |
| Import DOCX | Later | 1.2 | Useful but not needed for MVP |
| Export TXT | Yes |  | Basic |
| Export Markdown | Yes |  | Developer and creator friendly |
| Export RTF | Later | 1.1 | Good compatibility |
| Script duplication | Yes |  | Useful for alternate takes |
| Segment markers | Yes |  | Needed for jumping around |
| Cue points | 1.0 |  | Common pro teleprompter feature |
| Notes per segment | Later | 1.2 | Useful for podcasts |
| Tag scripts | Later | 1.2 | Organize content |
| Archive scripts | Later | 1.3 | Keep library clean |

Recommendation: use a simple local document model first. Do not start with database complexity unless you need it. A JSON based library plus plain text script files is enough for MVP.

---

## B. Prompting modes

Expected modes:

| Mode | MVP | Later | Why |
|---|---:|---:|---|
| Classic scroll | Yes |  | Required |
| Manual scroll | Yes |  | User controls with trackpad, keyboard |
| Timed scroll | 1.0 |  | Script finishes in selected duration |
| Page mode | 1.1 |  | Common prompter behavior |
| Voice pause | Later | 1.3 | Scroll pauses when silence is detected |
| Voice follow | Later | 2.0 | Harder but valuable |
| Word tracking | Later | 2.0 | Advanced voice feature |
| Rehearsal mode | Later | 1.4 | Track read time, words per minute |
| Outline mode | Later | 1.2 | For talking points, not full scripts |

For MVP, build **classic scroll** extremely well. Most teleprompter apps fail not because they lack AI, but because scroll feels bad, controls are clumsy, or display setup is confusing.

---

## C. Display modes

This is where the app can win.

| Display mode | MVP | Later | Notes |
|---|---:|---:|---|
| Main window prompter | Yes |  | Basic playback |
| Full screen prompter | Yes |  | Needed for external display |
| Floating overlay | Yes |  | Huge creator workflow |
| Transparent overlay | 1.0 |  | Useful for recording, meetings, and streaming |
| Duplicate window | 1.0 |  | Critical for external monitors and prompter hardware |
| Independent mirror per display | 1.0 |  | External display may need mirrored text |
| Notch style overlay | Later | 1.4 | Advanced macOS specific feature |
| Sidecar full screen | Later | 1.4 | Useful but not MVP |
| OBS safe overlay | Later | 1.5 | Advanced creator workflow |
| Screen share invisible mode | Later | 1.5 | Strong differentiator if technically reliable |

For macOS, this requires a SwiftUI plus AppKit hybrid. SwiftUI gives clean UI. AppKit gives better control over floating windows, panels, levels, and external display behavior.

---

## D. Mirroring and pro hardware

This is required for real teleprompter glass.

| Feature | MVP | Later |
|---|---:|---:|
| Horizontal mirror | Yes |  |
| Vertical mirror | 1.0 |  |
| Independent mirror on duplicate display | 1.0 |  |
| External display picker | 1.0 |  |
| Remember display profile | 1.1 |  |
| Elgato Prompter setup preset | 1.1 |  |
| Studio prompter preset | 1.2 |  |

Competitors emphasize mirroring heavily because prompter glass often requires reversed text.

---

## E. Controls

Minimum controls:

| Control | MVP | Later | Notes |
|---|---:|---:|---|
| Space to play and pause | Yes |  | Essential |
| Arrow keys to adjust speed | Yes |  | Common teleprompter pattern |
| Escape to exit | Yes |  | Expected |
| Jump to start/end | Yes |  | Useful |
| Jump to cue point | 1.0 |  | Needed for production |
| Custom shortcuts | 1.0 |  | Useful for personalized workflows |
| Bluetooth keyboard | Yes |  | Works through keyboard shortcuts |
| Presenter clicker | 1.0 |  | Usually maps as keyboard input |
| Game controller | 1.2 |  | Useful for hands free control |
| Stream Deck plugin | 1.4 |  | Strong creator integration |
| Browser remote | 1.5 |  | Useful for producer or phone control |
| iPhone remote | 2.0 |  | More work, but valuable |

Stream Deck is worth supporting after the app is stable.

---

## F. Voice features

Voice is valuable, but dangerous for MVP because it can eat the schedule.

| Feature | Release | Notes |
|---|---:|---|
| Silence detection pause | 1.3 | Easier than full speech recognition |
| Basic speech recognition proof | 1.3 | Experimental |
| Voice follow scrolling | 2.0 | Major feature |
| Word highlighting | 2.0 | Great differentiator |
| Multi language speech profile | 2.1 | More advanced |
| Reading analytics | 2.1 | Words per minute, pauses, drift |
| Local only guarantee | Always | Must be clear |

Recommendation: do **not** ship voice follow in 1.0. Ship the foundation first.

---

## G. Recording and captions

This is tempting, but I would delay it.

| Feature | Release | Why |
|---|---:|---|
| Camera preview | 1.6 | Useful for creators |
| Record camera while reading | 2.2 | Competes with full creator apps |
| Screen recording | 2.3 | Bigger permission and reliability surface |
| Captions from script | 1.6 | Easier, high value |
| SRT export | 1.6 | Useful for YouTube |
| Burned in subtitles | Later | Not core teleprompter |

---

# 4. Recommended technical architecture

## Stack

| Layer | Recommendation |
|---|---|
| Language | Swift |
| UI | SwiftUI |
| Window control | AppKit |
| Storage | Local JSON plus files first |
| Rich text | AttributedString / NSAttributedString |
| Speech | Apple Speech framework later |
| Audio | AVFoundation / AVAudioEngine later |
| Remote control | Local WebSocket server later |
| External display | NSScreen plus AppKit windows |
| Updates | Sparkle after first public release |
| Distribution | GitHub Releases, Homebrew Cask later, notarized DMG |
| License | MIT or Apache 2.0 |

## Why native Swift instead of Electron

Use native Swift because this app lives and dies by macOS window behavior, overlay quality, keyboard handling, display selection, and low resource usage. Electron would be faster for a prototype, but it is the wrong long term foundation for a polished macOS tool.

## Suggested module layout

| Module | Responsibility |
|---|---|
| OpenCueApp | App entry, menu commands, scene setup |
| CueCore | Script model, timing, playback engine |
| CueStorage | Local persistence, import, export |
| CuePrompterUI | Prompter rendering views |
| CueEditorUI | Script editor and library UI |
| CueWindows | Floating windows, duplicate windows, external display |
| CueControls | Keyboard shortcuts, input commands |
| CueSpeech | Speech recognition later |
| CueRemote | Browser and mobile remote later |
| CueRecording | Recording and caption export later |

## Core data model

```swift
struct ScriptDocument: Codable, Identifiable {
    var id: UUID
    var title: String
    var body: String
    var createdAt: Date
    var updatedAt: Date
    var segments: [ScriptSegment]
    var settings: PromptSettings
}

struct ScriptSegment: Codable, Identifiable {
    var id: UUID
    var title: String?
    var startCharacterIndex: Int
    var cuePointName: String?
}

struct PromptSettings: Codable {
    var fontSize: Double
    var lineHeight: Double
    var textWidth: Double
    var textColorHex: String
    var backgroundColorHex: String
    var backgroundOpacity: Double
    var wordsPerMinute: Double
    var mirrorHorizontal: Bool
    var mirrorVertical: Bool
    var countdownSeconds: Int
}
```

---

# 5. MVP definition

## MVP goal

The MVP should let a Mac user:

1. Create or paste a script
2. Format it for readability
3. Start prompting
4. Control speed without touching the mouse
5. Use full screen or floating overlay
6. Use a mirrored external display
7. Save and reopen scripts
8. Trust that everything is local

## MVP should not include

Do not include these yet:

1. Voice following
2. Camera recording
3. Cloud sync
4. iPhone remote
5. Teams and organization features
6. AI script rewriting
7. Stream Deck plugin
8. Screen recording
9. Complex rich text editing
10. Accounts or login

This restraint matters. If you include too much, you will create a half working app instead of a sharp MVP.

---

# 6. Release milestones

## 0.1.0, Project foundation

### Goal

Create a clean, buildable, contributor friendly macOS project.

### Features

| Area | Scope |
|---|---|
| App shell | Native macOS SwiftUI app |
| Navigation | Library, editor, prompter |
| Data model | Codable script model |
| Storage | Local app support folder |
| Settings | Basic app settings |
| Tests | Unit tests for model and playback timing |
| Docs | README, build instructions, contribution guide |

### Acceptance criteria

| Requirement | Pass condition |
|---|---|
| App builds from clean checkout | Yes |
| User can create a script | Yes |
| Script persists after restart | Yes |
| README explains local first privacy | Yes |
| Contributor can run tests | Yes |

---

## 0.2.0, Script editor and library

### Goal

Make the app useful before playback is advanced.

### Features

| Area | Scope |
|---|---|
| Script library | List, create, duplicate, rename, delete |
| Editor | Plain text editor |
| Auto save | Save edits automatically |
| Import | TXT and Markdown |
| Export | TXT and Markdown |
| Search | Search script titles |
| Metadata | Created date, updated date, word count, estimated read time |

### Acceptance criteria

| Requirement | Pass condition |
|---|---|
| User can manage multiple scripts | Yes |
| App does not lose edits | Yes |
| Import works with normal text files | Yes |
| Estimated read time updates | Yes |

---

## 0.3.0, Core prompter playback

### Goal

Make basic teleprompter playback feel great.

### Features

| Area | Scope |
|---|---|
| Playback | Play, pause, restart |
| Speed | Words per minute or pixels per second |
| Countdown | Optional countdown before start |
| Typography | Font size, line height, text width |
| Theme | Light, dark, high contrast |
| Controls | Space, arrows, escape |
| Progress | Percent complete, remaining time |
| Scroll quality | Smooth animation |

### Acceptance criteria

| Requirement | Pass condition |
|---|---|
| Scroll is smooth on Intel and Apple Silicon | Yes |
| Space toggles play and pause | Yes |
| Arrow keys adjust speed live | Yes |
| User can read comfortably full screen | Yes |

---

## 0.4.0, Floating overlay mode

### Goal

Support the most important macOS creator workflow.

### Features

| Area | Scope |
|---|---|
| Floating window | Always on top prompter |
| Resizing | Resize and reposition |
| Transparency | Adjustable background opacity |
| Mouse pass through toggle | Optional later in this milestone |
| Compact controls | Hide controls while prompting |
| Safe exit | Escape closes overlay |

### Acceptance criteria

| Requirement | Pass condition |
|---|---|
| Overlay stays above normal app windows | Yes |
| Overlay position is remembered | Yes |
| User can use it over Zoom, OBS, browser, or notes | Yes |
| Controls do not clutter the screen | Yes |

---

## 0.5.0, External display and mirroring

### Goal

Make it work with actual teleprompter hardware.

### Features

| Area | Scope |
|---|---|
| Full screen display picker | Choose target display |
| Mirror horizontal | Required |
| Mirror vertical | Useful |
| Duplicate window | Separate operator and talent windows |
| Independent settings | Mirror only on output window |
| Display profiles | Remember per display setup |

### Acceptance criteria

| Requirement | Pass condition |
|---|---|
| User can prompt on second display | Yes |
| User can mirror text for glass | Yes |
| Main window can remain editable while output displays | Yes |
| Works with Elgato Prompter as external display | Manual test |

---

## 1.0.0, Public MVP release

### Goal

Stable public release suitable for creators.

### Must have

| Category | Features |
|---|---|
| Script workflow | Create, edit, duplicate, delete, import TXT/Markdown, export TXT/Markdown |
| Playback | Smooth scroll, play, pause, restart, countdown |
| Readability | Font size, line height, width, colors, themes |
| Controls | Keyboard shortcuts, live speed adjustment |
| Modes | Main window, full screen, floating overlay, external display |
| Pro hardware | Horizontal mirror, vertical mirror, duplicate output window |
| Privacy | Local first, no network required |
| Reliability | Crash safe auto save |
| Distribution | Signed and notarized DMG, GitHub release |
| Docs | User guide, quick start, hardware setup guide |

### 1.0.0 acceptance criteria

| Requirement | Pass condition |
|---|---|
| New user can start prompting in under 2 minutes | Yes |
| App works offline | Yes |
| Scripts survive crash or force quit | Yes |
| External display mode works reliably | Yes |
| Mirror mode is obvious and testable | Yes |
| README has screenshots and install steps | Yes |
| Release includes changelog | Yes |

---

# 7. Post MVP release roadmap

## 1.1.0, Production polish release

### Goal

Make 1.0 feel professional.

### Features

| Area | Scope |
|---|---|
| Cue points | Add, rename, jump |
| Page mode | Page by page prompting |
| Timed scroll | Finish script in chosen duration |
| RTF import/export | Better document compatibility |
| Presets | Creator, webinar, studio, Elgato |
| Shortcut editor | Customize common shortcuts |
| Backup/export settings | Move setup to another Mac |

### Why this matters

Cue points, timed scroll, paging, and custom shortcuts are all mature teleprompter expectations.

---

## 1.2.0, Creator workflow release

### Goal

Make it better for YouTubers, podcasters, and course creators.

### Features

| Area | Scope |
|---|---|
| Outline mode | Prompts as bullets or sections |
| Segment notes | Notes not shown in talent view |
| Sponsor read mode | Reusable blocks |
| Script templates | YouTube, podcast, meeting, course |
| Markdown headings as cue points | Auto generate cue list |
| DOCX import | Nice to have |
| Better search | Search script content |
| Tags | Organize scripts by project |

### Recommendation

This is where your app starts to feel like a creator tool, not just a prompter.

---

## 1.3.0, Voice assist release

### Goal

Add helpful voice behavior without overcommitting to full voice follow.

### Features

| Area | Scope |
|---|---|
| Mic permission flow | Clear explanation |
| Silence pause | Pause or slow down when user stops speaking |
| Voice activity indicator | Show whether app hears speech |
| Basic speech recognition experiment | Optional lab feature |
| Language setting | User selected speech language |
| Privacy indicator | Clear local processing messaging where applicable |

### Recommendation

Start with **voice assist**, not full voice follow. Full voice follow is where bugs become very visible.

---

## 1.4.0, Hardware control release

### Goal

Make it excellent in a creator desk setup.

### Features

| Area | Scope |
|---|---|
| Game controller support | Play, pause, speed, cue jumps |
| Presenter remote presets | Common clickers |
| Stream Deck plugin | Play, pause, speed up, speed down, next cue |
| Stream Deck Plus dial support | Speed and opacity control |
| MIDI input research | Optional for studios |
| Control diagnostics | Show detected input events |

---

## 1.5.0, Remote control release

### Goal

Let someone else control the prompter.

### Features

| Area | Scope |
|---|---|
| Local web remote | Control from phone browser |
| QR pairing | Scan to connect |
| Same network only | Keep it simple and private |
| Remote controls | Play, pause, speed, jump cue |
| Operator view | Current section, next cue, time left |
| Optional password | Prevent accidental control |
| LAN permissions guide | Explain firewall/network behavior |

### Recommendation

Browser remote before native iPhone app. It is faster, cross platform, and works without App Store friction.

---

## 1.6.0, Captions and exports release

### Goal

Help creators finish videos faster.

### Features

| Area | Scope |
|---|---|
| SRT export from script | Generate subtitles based on timing estimate |
| VTT export | Web captions |
| Segment timing editor | Adjust caption timings |
| YouTube description export | Optional |
| Recording checklist | Preflight for creator workflow |

### Recommendation

Caption export is lower risk than full video recording and directly helps YouTube creators.

---

## 2.0.0, Voice follow release

### Goal

Add flagship voice following.

### Features

| Area | Scope |
|---|---|
| Full voice follow | Scroll follows spoken script |
| Word highlighting | Highlight current word or phrase |
| Off script handling | Pause when user ad libs |
| Resume detection | Continue when user returns |
| Reading analytics | Pace, pauses, completion |
| Local speech engine | Prefer local processing |
| Accuracy tuning | Per language and per mic behavior |

### Why this is version 2.0

Voice following is a major product promise. If you ship this, it must be excellent.

---

## 2.1.0, Multilingual and accessibility release

### Goal

Make the app better for more users.

### Features

| Area | Scope |
|---|---|
| UI localization | Community translations |
| Script language profiles | Reading speed, font defaults |
| Dyslexia friendly fonts | Optional bundled or system safe |
| High contrast themes | Accessibility |
| Reduced motion mode | Accessibility |
| VoiceOver improvements | macOS accessibility |
| Right to left support | Arabic, Hebrew |

---

## 2.2.0, Recording release

### Goal

Become a lightweight creator recording tool.

### Features

| Area | Scope |
|---|---|
| Camera preview | See framing while reading |
| Record video | Basic local recording |
| Audio input selection | Mic picker |
| Take management | Save takes per script |
| Countdown and slate | Useful for editing |
| Export video | Simple export |

### Recommendation

Only do this after the teleprompter is loved. Otherwise you will compete with OBS, QuickTime, Screen Studio, Descript, and camera apps too early.

---

## 2.3.0, Studio release

### Goal

Support more serious production setups.

### Features

| Area | Scope |
|---|---|
| Multi output | Different displays with different settings |
| Operator console | Control room style UI |
| Talent view | Clean output only |
| Rundown mode | Multiple scripts in order |
| Network control API | Local API for studios |
| OBS integration | Browser source or local control |
| Import production rundown | CSV or Markdown |

---

## 3.0.0, Companion ecosystem

### Goal

Expand beyond Mac without bloating the Mac app.

### Features

| Area | Scope |
|---|---|
| iPhone remote app | Native remote |
| iPad prompter mode | Secondary device prompting |
| Watch control | Simple play and pause |
| Optional sync | iCloud or local network sync |
| Team script handoff | Later, optional |

---

# 8. Backlog by priority

## Must have for 1.0

1. Script library
2. Local auto save
3. Script editor
4. Smooth scrolling
5. Play and pause
6. Speed control
7. Countdown
8. Font size
9. Line height
10. Text width
11. Theme colors
12. Full screen
13. Floating overlay
14. External display picker
15. Horizontal mirror
16. Duplicate window
17. Keyboard shortcuts
18. Import TXT and Markdown
19. Export TXT and Markdown
20. Signed and notarized release

## Should have for 1.0

1. Vertical mirror
2. Transparent overlay
3. Progress bar
4. Remaining time
5. Crash recovery
6. Display profile memory
7. Basic onboarding
8. Sample scripts
9. Quick start guide
10. Elgato Prompter guide

## Not for 1.0

1. Voice follow
2. Video recording
3. AI rewrite
4. Team collaboration
5. Cloud sync
6. Native mobile app
7. Stream Deck plugin
8. Browser remote
9. Screen recording
10. Captions

---

# 9. Open source project structure

## Repository structure

```text
OpenCue/
  OpenCue/
    App/
    Features/
      Library/
      Editor/
      Prompter/
      Settings/
    Core/
      Models/
      Playback/
      ImportExport/
      Persistence/
    Platform/
      Windows/
      Displays/
      Keyboard/
  OpenCueTests/
  OpenCueUITests/
  Docs/
    QuickStart.md
    HardwareSetup.md
    ElgatoPrompter.md
    Architecture.md
    Contributing.md
  Scripts/
    build.sh
    package.sh
  README.md
  CHANGELOG.md
  LICENSE
```

## Good first issues

1. Add a new theme preset
2. Add keyboard shortcut documentation
3. Add Markdown import tests
4. Add sample scripts
5. Improve README screenshots
6. Add display detection debug panel
7. Add estimated read time tests
8. Add localization file structure

## Contribution rules

1. No network features without privacy review
2. No analytics by default
3. No cloud dependency in core app
4. All playback engine changes need tests
5. Window behavior must be manually tested on single display, dual display, and full screen app scenarios
6. Every release must include a changelog

---

# 10. Biggest product risks

## Risk 1: Floating window behavior is harder than it looks

macOS full screen spaces, screen sharing, Stage Manager, multiple monitors, and app focus can make overlays tricky. Prototype this early.

## Risk 2: Smooth scrolling is deceptively important

If scrolling stutters, the product feels amateur immediately.

## Risk 3: Voice follow can become a rabbit hole

Do not let voice features delay 1.0.

## Risk 4: Importing rich documents can become messy

Start with TXT and Markdown. Add RTF and PDF after the core app is stable.

## Risk 5: External display testing needs real hardware

Test with at least:

1. Built in display only
2. External monitor
3. Elgato Prompter or similar external display
4. AirPlay display if possible
5. Screen recording or OBS workflow

---

# 11. Final recommended roadmap

| Version | Name | Main outcome |
|---|---|---|
| 0.1.0 | Foundation | App builds, stores scripts, basic architecture |
| 0.2.0 | Script Library | Create, edit, import, export scripts |
| 0.3.0 | Playback | Smooth classic teleprompter |
| 0.4.0 | Overlay | Floating macOS overlay |
| 0.5.0 | External Display | Mirror and duplicate output |
| 1.0.0 | Public MVP | Reliable local first Mac teleprompter |
| 1.1.0 | Production Polish | Cue points, timed scroll, page mode |
| 1.2.0 | Creator Workflow | Templates, outline mode, segments |
| 1.3.0 | Voice Assist | Silence pause and speech foundation |
| 1.4.0 | Hardware Control | Game controller and Stream Deck |
| 1.5.0 | Remote Control | Browser remote over LAN |
| 1.6.0 | Captions | SRT and VTT export |
| 2.0.0 | Voice Follow | Full voice based prompting |
| 2.2.0 | Recording | Camera recording and takes |
| 2.3.0 | Studio | Operator console and multi output |
| 3.0.0 | Ecosystem | iPhone, iPad, Watch companion |

---

# Strongest recommendation

Build **OpenCue 1.0** around this promise:

> A private, native, open source Mac teleprompter that works beautifully as a floating overlay or external display prompter.

That is clear. That is buildable. That is useful. And it gives you a strong foundation for voice, remote control, captions, recording, and studio workflows later.
