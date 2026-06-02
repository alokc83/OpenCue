# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

OpenCue is a native macOS teleprompter app built with SwiftUI and AppKit. It targets creators, presenters, and podcasters who need a private, local-first prompter that works as a floating overlay during Zoom/OBS/screen recording and supports external displays and mirror mode for pro hardware (e.g., Elgato Prompter).

## Build & Run

The Xcode project is generated from `project.yml` using [XcodeGen](https://github.com/yonaskolb/XcodeGen).

```bash
# Regenerate the Xcode project after changing project.yml
xcodegen generate

# Build from command line
xcodebuild -project OpenCue.xcodeproj -scheme OpenCue -configuration Debug build -quiet

# Open in Xcode
open OpenCue.xcodeproj
```

- **Deployment target**: macOS 14.0
- **Swift version**: 5.0
- **Signing**: Ad-hoc (`CODE_SIGN_IDENTITY: "-"`) for local builds
- **No external dependencies** — pure Apple frameworks (SwiftUI, AppKit, Combine, QuartzCore)

There are no tests yet.

## Architecture

The codebase is organized into three layers:

**Core** — Domain logic and data, no UI imports:
- `Models/ScriptDocument.swift` — `ScriptDocument`, `ScriptSegment`, `PromptSettings` value types. All Codable. `PromptSettings` stores colors as hex strings, WPM, mirror flags, and countdown seconds.
- `Playback/PlaybackEngine.swift` — `@MainActor ObservableObject` driving scroll via `CVDisplayLink`. Converts WPM to pixels-per-second for frame-accurate scrolling. Owns `scrollOffset`, `isPlaying`, `speedMultiplier`, `countdown`. Supports a configurable countdown before playback starts (via `startCountdown()` → `startEngine()`). The engine is a shared reference — the same instance is passed to both the external prompter window and the operator controls view.
- `Persistence/CueStorage.swift` — `@MainActor ObservableObject` providing the script list. Scripts are individual JSON files in `~/Library/Application Support/{bundleId}/Scripts/`. Injected as `@EnvironmentObject` from the app root.
- `ImportExport/ScriptIOController.swift` — Import/export via `NSOpenPanel`/`NSSavePanel`. Imports `.txt` and `.md` files; exports as `.md`.

**Features** — SwiftUI views:
- `Library/ScriptLibraryView.swift` — `NavigationSplitView` sidebar listing scripts with context menu (duplicate, export, delete). Entry point view.
- `Editor/ScriptEditorView.swift` — Title + body editor with toolbar containing: settings popover (`PromptSettingsView`), external display menu (populated by `DisplayManager`), and floating prompt button. Auto-saves on every change via `onChange`. Has two modes: editing mode (normal editor) and operator mode (shows `OperatorControlsView` when an external display session is active). Posts `Notification.Name.startPrompting` to launch the floating prompter.
- `Prompter/PrompterView.swift` — Full prompter display. Takes a shared `PlaybackEngine` via `@ObservedObject`. Handles keyboard input (Space=play/pause, Up/Down=speed). Shows countdown overlay, control bar on hover, and red reading-position markers. Applies `scaleEffect` for mirror mode. Includes `Color(hex:)` extension.
- `Prompter/OperatorControlsView.swift` — Operator's control panel shown in the editor area when prompting to an external display. Controls play/pause/restart/rewind/speed on the shared `PlaybackEngine`. Posts `Notification.Name.closeOperatorView` to return to editing mode and calls `ExternalWindowController.shared.closeAll()`.
- `Settings/PromptSettingsView.swift` — Form for typography, colors, opacity, mirroring. Includes `Color.toHex()` extension.

**Platform** — macOS-specific windowing:
- `Windows/FloatingWindowController.swift` — Singleton. Creates an `NSPanel` with `.floating` level and `.nonactivatingPanel` so it stays above other apps without stealing focus. Creates its own `PlaybackEngine` internally. Used for overlay-while-recording workflow.
- `Windows/ExternalWindowController.swift` — Singleton. Manages full-screen borderless windows on external displays (keyed by UUID). Takes a shared `PlaybackEngine` so the operator controls and the external display scroll in sync. Has `closeAll()` to tear down all external windows.
- `Displays/DisplayManager.swift` — Tracks connected `NSScreen`s, refreshes on `didChangeScreenParametersNotification`.

**Data flow — two prompting paths**:
1. **Floating overlay**: User clicks "Prompt" → `NotificationCenter` post (`.startPrompting`) → `OpenCueApp.onReceive` → `FloatingWindowController.shared.showPrompter(for:)` → creates its own `PlaybackEngine` and `PrompterView` inside a floating `NSPanel`.
2. **External display**: User selects a display from the toolbar menu → `ScriptEditorView.startExternalPrompting(on:)` → creates a shared `PlaybackEngine` → passes it to both `ExternalWindowController.shared.showPrompter(with:on:)` (full-screen on external display) and stores it as `operatorEngine` so the editor switches to `OperatorControlsView` (operator controls the same engine instance).

## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
| ------ | ---------- |
| `detect_changes` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context` | Need source snippets for review — token-efficient |
| `get_impact_radius` | Understanding blast radius of a change |
| `get_affected_flows` | Finding which execution paths are impacted |
| `query_graph` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes` | Finding functions/classes by name or keyword |
| `get_architecture_overview` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.

<!-- code-review-graph MCP tools -->
## MCP Tools: code-review-graph

**IMPORTANT: This project has a knowledge graph. ALWAYS use the
code-review-graph MCP tools BEFORE using Grep/Glob/Read to explore
the codebase.** The graph is faster, cheaper (fewer tokens), and gives
you structural context (callers, dependents, test coverage) that file
scanning cannot.

### When to use graph tools FIRST

- **Exploring code**: `semantic_search_nodes` or `query_graph` instead of Grep
- **Understanding impact**: `get_impact_radius` instead of manually tracing imports
- **Code review**: `detect_changes` + `get_review_context` instead of reading entire files
- **Finding relationships**: `query_graph` with callers_of/callees_of/imports_of/tests_for
- **Architecture questions**: `get_architecture_overview` + `list_communities`

Fall back to Grep/Glob/Read **only** when the graph doesn't cover what you need.

### Key Tools

| Tool | Use when |
| ------ | ---------- |
| `detect_changes` | Reviewing code changes — gives risk-scored analysis |
| `get_review_context` | Need source snippets for review — token-efficient |
| `get_impact_radius` | Understanding blast radius of a change |
| `get_affected_flows` | Finding which execution paths are impacted |
| `query_graph` | Tracing callers, callees, imports, tests, dependencies |
| `semantic_search_nodes` | Finding functions/classes by name or keyword |
| `get_architecture_overview` | Understanding high-level codebase structure |
| `refactor_tool` | Planning renames, finding dead code |

### Workflow

1. The graph auto-updates on file changes (via hooks).
2. Use `detect_changes` for code review.
3. Use `get_affected_flows` to understand impact.
4. Use `query_graph` pattern="tests_for" to check coverage.
