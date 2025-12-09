Crescere — Game Design Document

---

CONTENTS
1. High Concept
2. Design Goals & Pillars
3. Target Audience & Platform
4. Overview & Setting
5. Narrative Summary
6. Player Character
7. Core Gameplay Systems
8. Controls & Input
9. Level & Encounter Design
10. Enemies & Hazards
11. Puzzles & Progression
12. Visual & Art Direction
13. Sound & Music Design
14. User Interface (UI) and HUD
15. Technical Architecture
16. Tools, Pipeline & Assets
17. Production Schedule & Milestones
18. Risks & Mitigations
19. Appendix: Reference Assets

---

1. HIGH CONCEPT

Crescere is a 2D side-scrolling platformer focused on tight movement and environmental puzzles. The game blends responsive platforming (dash, variable jump, crouch, plunge) with collectible-driven progression: the player collects fragments to unlock story beats and the credits. The experience is small-scale, polished, and designed as a student project demonstrating layered, expressive mechanics.

"Crescere" (Italian for "to grow") presents short, distinct levels that collectively teach and challenge the player on platforming control, exploration, and puzzle-solving.

2. DESIGN GOALS & PILLARS

- Precision Movement: Make movement feel responsive and rewarding — players should feel in control.
- Learnable Challenges: Introduce mechanics gradually so each new level teaches something new.
- Exploration & Reward: Place collectibles that reward the player with endings on the amount collected.
- Mood & Atmosphere: Use music, sound, and visuals to create a coherent emotional tone.
- Educational Scope: Keep scope achievable for a student project while showing polish and design craft.

3. TARGET AUDIENCE & PLATFORM

- Audience: Teen to adult players who enjoy skill-based platformers and short-form levels.
- Platform: Android mobile builds, desktop for development and testing.
- Accessibility: Simple controls, mobile on-screen buttons.

4. OVERVIEW & SETTING

- Setting: Abstracted organic/tech environments (e.g., abandoned facility, mechanical ruins). Scenes use simple but expressive art to support theme.
- Tone: Curious, slightly melancholic, with moments of discovery rather than horror.

5. NARRATIVE SUMMARY

- Core Premise: The player collects fragments of a moon. As fragments are gathered, game ending differs.
- Structure: Non-linear micro-stories told through environment, optional text/dialogue triggers, and the credits screen which summarizes percentage completion.
- Delivery: Minimal explicit narrative — focus on environmental storytelling and short dialogue (dialogue manager handles presentation).

6. PLAYER CHARACTER

- Controls: Move left/right, jump (variable height), dash (directional), crouch (toggle), plunge (downward "attack").
- Abilities:
  - Dash: Fast burst for crossing gaps and dodging hazards. Short cooldown.
  - Variable Jump: Hold jump for slightly higher arcs.
  - Crouch: Reduce collision height, interact with small gaps, modifies jump strength.
  - Plunge: Fast downward attack to break certain platforms or trigger switches.
- Stats:
  - Movement speed ~300 units
  - Jump velocity and hold strength tuned for level geometry
  - Dash speed ~1200 units for short bursts

7. CORE GAMEPLAY SYSTEMS

- Movement: CharacterBody2D-based movement with smoothing, coyote time, and jump buffering for forgiving platforming.
- Collectibles: Coins (score) and Fragments (progression). Fragments must be submitted at a terminal at the end to count toward completion percentage.
- Checkpoints: Area-based checkpoints set respawn positions. Collecting fragments does not auto-save unless a checkpoint is reached.
- Dialogue & UI: Non-blocking dialogues appear via DialogManager. Game.suppress_jump prevents jump during submission/interaction.

8. CONTROLS & INPUT

Primary controls (keyboard for development, touch for mobile):
- Left/Right: Move
- Jump: Tap/hold for variable jump
- Dash: Dedicated button (directional dash when moving or aiming)
- Crouch: Toggle (crouch collision swap)
- Submit/Interact: Context button when near terminal.

Mobile: On-screen TouchScreenButtons mirror these actions. Optional sensitivity and button size settings may be exposed for accessibility.

9. LEVEL & ENCOUNTER DESIGN

Design approach:
- Each level focuses on one or two mechanics and teaches them through short platforming puzzles.
- Levels are compact (2–6 screens).
- Layout uses visual cues (tiling, contrast) to guide the player toward necessary paths.

Example level flow pattern:
- Intro area (safe, teaching new mechanic)
- Challenge corridor (requires using mechanic to pass)
- Exploration branch (contains coins/fragments)
- Terminal (end of level)

10. HAZARDS

- Spikes: Instant death hazards. Placed to teach jump/dash timing.
- Moving Platforms: Timed traversal; some require dash to cross.

Design notes: Hazards are used to highlight the player's movement toolkit, not to punish arbitrary mistakes; checkpoints are placed to reduce frustration.

11. PUZZLES & PROGRESSION

- Puzzle types:
  - Navigation puzzles using dash and variable jump
  - Size-based puzzles requiring crouch to pass
  - Timing puzzles: moving platforms
  - Block puzzles: use plunge to hit breakable blocks.

- Progression: Fragments are placed to encourage exploration and the solving of short, self-contained puzzles.

12. VISUAL & ART DIRECTION

- Art Style: Pixel/hand-drawn hybrid, moderate detail — aim for readable silhouettes and strong contrast for gameplay-critical objects.
- Palette: Muted midtones with occasional saturated accent color for interactables and fragments.
- Animations: Emphasize snappy movement frames for dash, jump, fall, walk, crouch transitions.

13. SOUND & MUSIC DESIGN

- Music: Short, looping tracks that match level mood — subtle, ambient, supportive of flow.
- SFX: Crisp landing, dash whoosh, pickup chimes for coins/fragments.
- Audio Manager: Centralized playback ensures consistent volume and ducking during dialogue.

14. USER INTERFACE (UI) AND HUD

- HUD Elements:
  - Coins counter (top-left)
  - Fragments counter and percent at ending
  - Contextual prompt ("Press to Submit") when near terminal

- Menus: Simple start menu, and credits screen with completion percentage.

15. TECHNICAL ARCHITECTURE

- Engine: Godot 4.5 stable
- Language: GDScript
- Autosingletons: `Game` (game_state.gd), `DialogManager`, `Transition`, `AudioManager`.
- Scenes: Modular scenes for each object type (coins, fragments, spike, spring, platform).
- Build: Export to Android (.aab) via `android/` config.

Key technical decisions:
- Use `CharacterBody2D` for the player for built-in physics handling.
- Use signals for collectible and checkpoint events.
- Keep audio playback through manager to allow global control and mobile performance optimizations.

16. TOOLS, PIPELINE & ASSETS

- Art: Sprites exported as PNG; Aseprite source files stored in `Assets/`.
- Audio: SFX and music stored under `Assets/Audio/`.
- Scenes & Prefabs: Use modular tscn prefabs for reusability.

17. PRODUCTION SCHEDULE & MILESTONES

(Example timeline for a student project — adjustable to term length)
- Week 1–2: Core movement prototype (jump, dash, crouch)
- Week 3: Level template and first two levels
- Week 4: Collectibles, checkpoints, and terminals
- Week 5: Sound, UI, and polish
- Week 6: Mobile input and exporting, documentation, submission

Milestone deliverables:
- Prototype playable build
- Short polished levels
- Android export (.aab)
- Documentation (design doc + privacy policy)

18. RISKS & MITIGATIONS

- Scope creep: Keep milestone scope tight; lock mechanics after core prototype.
- Mobile performance issues: Profile early, use compressed audio and atlases.
- Input feel: Tune coyote time and jump buffering early for polish.

19. APPENDIX: REFERENCE ASSETS

- Placeholder art list (in `Assets/`): `block.png`, `platform.png`, `coinmoon.png`, etc.
- Audio list: SFX for spike, coin, dash, submit; background music loops.

---

END