# PROJECT HANDOVER: New Metrics Technical Proposal Builder

Prepared on 3 November 2026 for whoever continues this work with Claude from another account, without access to the original conversation.

**How to use this document**
- Sections 1 to 10 explain the project, its history, the rules agreed with Aya (the requester), the decisions taken and what remains.
- Appendix A is the file tree of the app. Appendix B holds **the complete source code and configuration** of the app, file by file and unshortened, so the app can be rebuilt from this document alone if the zip is lost.
- Labels used throughout:
  - **CONFIRMED**: Aya asked for it or approved it.
  - **DONE**: implemented and tested in this conversation.
  - **ASSUMPTION**: chosen by Claude and still to be validated by Aya.
  - **PENDING**: not done yet.
  - **UNKNOWN**: information that is not available.

---

## 1. Project Background

### 1.1 Purpose and objectives
New Metrics is a consulting company that designs customer and employee experience (CX / EX) programs. It partners with **Medallia**, a leading experience management platform, and sells Medallia implementation services to clients in response to their **RFPs** (requests for proposal), mostly in KSA and the GCC.

The project builds a **user-friendly web app** (the "Technical Proposal Builder"). It turns a structured brief into a finished, on-brand **New Metrics Medallia technical proposal** in PowerPoint (.pptx), plus a **review notes** file (.docx). The brief is made of:
- the intake form
- the client logo
- the client's RFP
- the scoping questions and answers (Q&A)

In Aya's words, the goal is to "Build an AI-assisted tool that turns a structured proposal brief (client details, scope figures, timeline, RFP and scoping answers) into a finalized, on-brand New Metrics technical proposal in PowerPoint, in English or Arabic, cutting preparation effort and standardizing proposal quality."

Hard rules from Aya (CONFIRMED):
- "CLIENTS ASKS WITHIN THEIR RFP NEED TO BE APPLIED AND FOLLOWED."
- The tool must create the proposal "without making things up from its mind." Nothing is invented.
- English first. Arabic (right-to-left) comes later.

### 1.2 Business context and problem
This is taken from Aya's design document, "Technical_Proposal_Automation_Design_V0.1".

Proposals are large PowerPoint decks.
- **Mostly standard content:** company overview, services, differentiators, Medallia overview, case studies and team profiles.
- **Tailored to each client:** cover, the three-phase approach, framing and filler slides, deliverables and quantities, client prerequisites, solution slides and the timeline.

Today every deck is assembled by hand. The owner starts from the most recent similar deck and then:
- replaces the client name and logo slide by slide
- updates quantities and prerequisites
- rebuilds the timeline
- reworks the solution slides against the RFP

This takes senior people hours and lets inconsistencies slip through. Examples: mixed client-name casing, an outdated copyright year, stray characters such as "XXX", and leftover slides from other clients.

**In scope (from the design doc):**
- Medallia technical proposals in the current New Metrics structure, as an editable .pptx on the approved template.
- English and Arabic, with right-to-left layout for Arabic.
- A governed master slide library.
- Generation of the client-specific slides.
- A review notes file with every deck.

**User journey:** the owner fills a short form and attaches the RFP and Q&A. The tool returns the deck plus review notes. The owner edits in PowerPoint, adds the commercial section, and sends the deck through the normal review.

### 1.3 Expected deliverables and outcomes
1. A web app with an intake form. It runs locally (DONE) and can be hosted online behind a username/password login (code DONE, deployment PENDING).
2. For each run:
   - an editable .pptx that follows the 2026 New Metrics template and brand guidelines
   - a .docx of review notes listing what to check, complete or confirm, RFP gaps, conflicts and flagged numbers
3. A **library** of rules and knowledge learnt from past proposals. It is used as context for the AI step.
4. Arabic output: PENDING, not started.

---

## 2. Complete Work History (chronological)

All dates are 2026. Every step below was done in one long project thread on claude.ai. "Delivered" means an updated `proposal-builder.zip` was shared with Aya.

### Phase A: Review and "training" (26 to 27 Oct)
| Date | What happened | Outcome |
|---|---|---|
| 26 Oct | Aya shared the design document `Technical_Proposal_Automation_Design_V0.1.docx` and asked for a thorough review only. | A review was written as a private claude.ai artifact (link in §9). Main gaps found: no technical design, an intake form too coarse ("number of deliverables" as one field), an under-sized plan, and internal contradictions (30 vs 60 day adoption checkpoint, unclear Arabic launch). |
| 26 Oct | Aya: "think more smart… don't take the document word by word… don't be too philosophical." | Agreed approach: treat the doc as intent, fill obvious gaps with sensible defaults, and flag only real blockers. |
| 26 Oct | Aya sent the core goal and problem statement (see §1). | Claude confirmed its understanding. It explained that "training" means building a reference library from New Metrics material, not retraining a model. |
| 26 Oct | Aya sent the EN and AR 2026 templates, the Client References EN deck and the About Medallia decks (EN, AR), and explained the proposal structure (see §3.2). | Written up as a private artifact, "New Metrics proposal structure: my understanding (EN)". |
| 26 Oct | Aya asked whether past proposals in client folders can go into the library. | Yes. Library organised under `/mnt/project-files/library/`, with a catalogue per proposal. |
| 26 Oct | Aya: follow only the **new** brand guidelines; use old proposals for content and slide logic only; ignore commercial documents. | Written into `library/RULES.md`. |
| 27 Oct | Aya added `Brand Guidelines - Presentation 2.pptx`. | Brand rules (fonts, colours, logo, footer, writing rules) added to `RULES.md`. |
| 27 Oct | Aya added the client folders: "Other different clients", CDF, KFH, Tatweer THC, Vision Bank, NHC, Neoleap. | Built `catalogue.md` / `catalogue.json` (22 proposals) and the knowledge files. KFH is the best example of the 2026 structure. THC is the best example of following an RFP-prescribed structure. Flagged three problems: the Alfa file was corrupted, the Africell PDF is scanned images only, and the NHC "Medallia - Clarification Questions.xlsx" **Sheet2 holds usernames and passwords**, so that sheet was excluded completely. |
| 27 Oct | Aya re-uploaded Alfa (`20250723_NM_Alfa 3.pptx`), said MIM = Ministry of Industry and Mineral Resources (KSA), and sent a screenshot of the intake form the tool must ask before building. | Catalogue fixed, and `knowledge/intake-form.md` written. |

### Phase B: First build (28 Oct)
| Date | What happened | Outcome |
|---|---|---|
| 28 Oct | Aya: "start building it now". | v1 delivered: a Flask app, `run_mac.command` and `run_windows.bat` launchers, a sample "Sample Bank" deck (76 slides) and review notes in `/mnt/project-files/app/sample/`. The sample is from v1 and is now outdated. |

### Phase C: Change rounds (1 to 2 Nov). Every item is DONE and was delivered as an updated zip.
1. **Windows launcher (1 Nov).** `run_windows.bat` showed "127.0.0.1 refused to connect".
   - Cause: the browser opened before the server was up, and the window closed on errors.
   - Fix: the launchers detect Python, keep the window open on error, and let the app open the browser only once it answers. They pick a free port between 5000 and 5019.
   - Aya then needed Python. Link given: https://www.python.org/downloads/windows/ (tick "Add python.exe to PATH").
   - Not tested on a real Windows machine.
2. **Team, references and form (1 Nov):**
   - Team profiles from the THC deck shown first, in this order: Rami Haffar, Karim Daou, Mohamad Zgheib, Aya Ibrahim, Amira Zeidan, Ali Mabrouk. Then the template profiles (Alaa, Iman, Kristel). The other THC profiles (Elie, Hannah-Mai, Reem, Abdulrahman Husain, Ingrid Moukarzel) are listed but unticked.
   - 33 new client references added: 4 from THC and 29 from the "New Branding Case Studies" deck. Near-duplicates were skipped.
   - Industry "Other" opens a free-text box.
   - "required" removed from the client logo.
   - The "channels in scope" section was removed.
   - "Surveys & deliverables" renamed to "Deliverables". The BRD, UAT and handover boxes were removed from the form.
   - "Program name" replaced by **Program type**: VoC / VoE / VoC and VoE / Other, with free text for Other.
   - The distribution channel count opens one name box per channel, plus "Not decided yet".
   - The NM logo appears in the header, with the favicon SVG.
3. **VoE references and deliverables (1 Nov):**
   - VoE case studies deck added. Only SANS (Saudi Air Navigation Services) was new.
   - References are filtered by program type: VoC shows 95, VoE shows 28, both shows both, Other shows all.
   - Deliverables section: the first item is the tick "Rely on RFP & Scoping Q&As to automatically extract the deliverables and requirements". Every box is optional, surveys included.
   - Aya confirmed that BRD, UAT and handover stay in every deck as standard deliverables, just not as form boxes.
4. **"GIVE ME THE FILE AGAIN" (1 Nov):** the zip was re-shared.
5. **Login and hosting (1 Nov).** Aya: "make the app login through username and password instead of through downloads and installing of things".
   - Added a login page, a Dockerfile, gunicorn and a hosting section in the README.
   - Credentials are read from host environment variables only.
   - Deployment is PENDING on Aya (see §6).
6. **Form and timeline (2 Nov):**
   - "Project details and description" made optional.
   - "Select all" added for client references and for team.
   - The logo "N/A, find it on web" option was made to search the web. It was later removed (round 8).
   - Timeline slide redesigned to match Aya's Project Plan reference slide (from the KFH deck): a W0…Wn grid, bright phase bars, light overlapping activity bars, a dashed note box at the top right, and an arrow when managed services continue.
   - Explained why "RFP analysis: off": there is no `ANTHROPIC_API_KEY`.
7. **Additional deliverables and team names (2 Nov):**
   - Added the free-text "Additional deliverables to consider" box, with no length limit.
   - The team list in the form shows names only. The profile slides in the deck are unchanged.
8. **Logo upload only, and timeline units (2 Nov):**
   - The "find it on web" option was removed. The logo is upload only and accepts any image (PNG, JPG, SVG, WebP, GIF, BMP, TIFF, HEIC).
   - Weeks / Months switch: weeks are labelled W0, W1…, months M0, M1…
   - No preparation phase; phase 1 starts at 0.
   - Up to **10 phases**. The phase overview splits into two slides (1/2, 2/2) above 5.
   - The launchers reinstall requirements when `requirements.txt` changes.
9. **Named items, topic set, training tick and section order (2 Nov):**
   - One name box per item for surveys, integrations and dashboard roles, plus text analytics and training. Each has its own "Not decided yet".
   - Text analytics: with 2 or more packages, the first box is pre-filled "<industry> topic set".
   - Training: the "Follow regular # of Medallia training program sessions" tick fills in 8 sessions.
   - RFP & scoping Q&A moved to section 3, after Project.
   - Names are used in the deck's activity steps.
   - The 8 sessions came from the KFH deck because Aya's screenshot did not arrive. Confirmation PENDING.
10. **Edit proposal requirements (2 Nov):**
    - The result page has an "Edit proposal requirements" button. It reopens the form with every value restored: fields, phases, unit, names, ticks, references, team.
    - Earlier uploaded files (logo, RFP, Q&A) are kept, with a "Kept from last time" note and a "remove it" tick.
    - Building again creates a new job; the earlier one is unchanged.
11. **Handover (3 Nov):** this document. The README's "Known limits" was also corrected, from "Up to 5 phases" to "Up to 10 phases", and its intro now mentions hosting. The zip was rebuilt.

### Completed vs in progress
- **Completed:** everything in Phases A to C above. Every change was tested locally with Playwright browser tests, and the generated decks were rendered to images with LibreOffice and checked visually.
- **In progress / pending:** see §6. In short:
  1. hosting deployment (waiting on Aya)
  2. Claude API key (waiting on Aya)
  3. confirmation of the 8 training sessions
  4. Arabic version
  5. visual filler slides

---

## 3. Requirements and Specifications

### 3.1 Standing rules (CONFIRMED by Aya)
- **Design follows only the new 2026 templates and brand guidelines.** Old proposals are for content and slide logic only, never design.
- **Ignore commercial documents** (pricing, financial proposals). Example: `20250417_NUPCO_Commercial_Proposal.pptx` is excluded.
- **Client asks in the RFP must be applied.** Nothing may be made up: no invented numbers, systems, channels, dates, regulators or references.
- **Never copy one client's content into another client's deck.**
- **The NHC "Medallia - Clarification Questions.xlsx" Sheet2 contains usernames and passwords and must stay excluded** from the library and from any processing.
- **Keep it simple.** Don't over-engineer and don't be "too philosophical".
- **English first**, Arabic later.

### 3.2 Proposal structure (CONFIRMED by Aya on 26 Oct)
1. **Cover:** client logo in the white rectangle on the right, RFP name, the "Technical Proposal" subtitle and the date.
2. **Table of contents:** always lists About Us; About Medallia; Executive Summary; Project Approach and Methodology; Project Plan and Governance; Client References; Our Team.
   - "About Us" is also called company overview or New Metrics overview.
   - "About Medallia" is also called technology overview, Medallia overview or solution overview.
   - "Client References" is also called case studies or reference cases.
3. **About Us:** the standard slides from the template.
4. **About Medallia:** a separate deck. On the slide "MOST NATIVE CAPTURE CAPABILITIES TO SECURE A HIGH VOLUME OF DATA", the client logo replaces the one under email, and the channel pictures are **lit or greyed** according to the client's requests. Only what is relevant is lit.
5. **Executive Summary:**
   - The **three-phase slide (QUANTIFIED)**: Program Design; Program Build & Tool Activation; Program Adoption & Scaling. These are the defaults; the client's RFP may ask for other phases.
   - Then the **framing slides**: boxes for objectives, key activities, assumptions, prerequisites and deliverables, with **quantities in brackets**, e.g. "Integration systems (2)", "BRD (1)", "CX Surveys (5)".
   - Then the project plan (timeline) and the project governance.
6. **Project Approach & Methodology:** the phases slide again (**UNQUANTIFIED**). Then each phase's framing slides, with **filler (solution) slides** between them, one per service or deliverable.
7. **Project Plan & Governance:** phases and durations.
8. **Client References**, then **Our Team**, then the closing slide.

### 3.3 Intake form: current specification (all DONE)
The section order in `templates/index.html` is:

**1 Client**
- Language: `language`, EN only for now.
- Client name: `client_name`, required.
- Industry: `industry_section`, codes 01 to 14 plus `other`. Choosing other opens `industry_other` (free text, required when other is chosen).
- Client logo: `logo`, optional, any image format.

**2 Project**
- Project title: `project_title`, required (the RFP name).
- Project details and description: `description`, optional.
- Program type: `program_type` = voc / voe / both / other. When other is chosen, `program_other` is required.

**3 RFP and scoping Q&A** (optional)
- `rfp`: .pdf / .docx / .txt
- `qa`: .xlsx / .docx / .pdf / .txt

**4 Deliverables** (optional)
- The tick `auto_deliverables`: "Rely on RFP & Scoping Q&As to automatically extract the deliverables and requirements". It needs an RFP or Q&A uploaded.
- Number boxes `d_<key>` for these keys:
  - `surveys`: Surveys
  - `channels`: Distribution channels
  - `integrations`: Integrations
  - `roles`: Dashboard roles
  - `ta`: Text analytics packages
  - `clf`: Close-the-loop forms
  - `trainings`: Training sessions
  - `ms_hours`: Managed services hours
- **Blank = unknown:** the item stays in the deck without a number. **0 = not in scope:** the item is removed. A typed number always wins over the documents.
- **Named items:** surveys, channels, integrations, roles, ta and trainings. Typing N opens N boxes named `name_<key>`, plus the tick `undecided_<key>` ("Not decided yet"). The form will not submit until all N boxes are filled or "Not decided yet" is ticked (checked both in the browser and on the server).
- **Text analytics rule:** the first `name_ta` box is pre-filled "<industry> topic set". The industry name comes from `industry_topic_names` (e.g. 07 → "Insurance"), or from the free text when the industry is Other. It updates when the industry changes, unless the user has edited it. The other boxes are free.
  - ASSUMPTION: the pre-fill happens from 1 package upwards, not only from 2. Aya said "if they put 2 or more"; pre-filling a single package with the industry set was judged harmless.
  - Validate with Aya if needed.
- **Training tick:** `std_trainings`, "Follow regular # of Medallia training program sessions". Ticking it sets `d_trainings` = 8 and fills in the 8 names from `standard_trainings`:
  1. Admin Concepts & Survey Configuration
  2. Survey Design & Survey Emails
  3. Organization
  4. Reporting (Part 1)
  5. Reporting (Part 2)
  6. Alerts
  7. Integrations
  8. Final Session

  Typing any number other than 8 unticks it, and the user then types the names. The list comes from the KFH deck's "Medallia Training Plan" slide (slide 64), because Aya's screenshot did not arrive. **PENDING Aya's confirmation.**
- "Additional deliverables to consider": `extra_deliverables`, free text with no limit.
  - With the API key: the AI turns the text into named deliverables, places them in the right phases and adds activities.
  - Without the key: the text is copied into the review notes under "To complete".

**5 Timeline**
- Unit switch `timeline_unit` = weeks / months. Labels are W0, W1… or M0, M1….
- Phases are rows of `phase_name` and `phase_weeks` (the field name stays `phase_weeks` even in months).
- 1 to 10 phases. The defaults are the 3 standard phases with 6 / 10 / 4 weeks.
- A live Gantt preview. Switching unit converts the durations (×/÷ 4.33).
- No preparation phase; the plan starts at 0.

**6 References and team**
- Client references: checkboxes named `references`, with values like `references:9`, `cases:29`, `thc_refs:2` or `voe_cases:1` (123 references in total), filtered by program type, same industry first. Has "Select all".
- Team: checkboxes named `team`, in the `TEAM` order from `app.py`, names only. Has "Select all".

**Result page:**
- Download the .pptx and the review notes .docx.
- "Edit proposal requirements" links to `/?edit=<job>`.
- The page shows the review notes and a summary of the phases and activities.

### 3.4 Deck generation rules (DONE)
- The deck is built from the template: `Technical Proposal Template 2026 [EN].pptx` (slide numbers in `T` in `engine/builder.py`). It also uses About Medallia, Client References, Case Studies, THC Team and References, and VoE Case Studies (in `source_decks/`).
- Section order is the one in §3.2. Divider numbers and TOC page numbers are filled in automatically.
- The copyright footer year is set to the current year.
- The capture slide lights the channels that match the named distribution channels (keywords in `channel_keywords`) plus any channels the AI finds in the RFP/Q&A. Everything else is greyed, and the client logo goes on the email example.
  - Unmatched names → review note.
  - If no channel matches, everything is greyed and a review note is added.
- Quantities appear in brackets: `Label (n)`.
- Named items are written into the activity steps:
  - "Build the surveys: A, B"
  - "Configure the agreed channels: …"
  - "Build the integrations: …"
  - "Configure the dashboards for: …"
  - "Activate the text analytics packages: …"
  - "Run the training sessions: …"

  When the matching generic step is missing, a line "<Label> in scope: …" is added instead.
- Timeline slide: full width, two-line W/0 headers, rows scale with their number. Above 30 columns (weeks or months), each column covers 2 units. There is a dashed note box and a right arrow when the last activity carries managed-services hours.
- Activities overlap: each runs for about 40% of its phase. The managed-services activity runs to the end of its phase.
- More than 5 phases → the phases slide splits into groups of 5, titled (1/2) and (2/2). Step markers are cloned and shrunk.
- References are taken by id. Team profiles are imported in the order of the form.
- The review notes (`.docx`, sections such as "To confirm", "To complete", "Inputs", "Conflicts") record:
  - assumptions
  - unmatched channels
  - undecided names
  - numbers found in AI text that are not in the form, RFP or Q&A
  - other client names found in the deck
  - conflicts between the form and the documents
  - the source of each number read from the documents

### 3.5 AI step (Claude API)
- Runs only when `ANTHROPIC_API_KEY` is set **and** at least one of these is present: RFP, Q&A, description, additional deliverables.
- Model `claude-opus-5-5`, called with streaming, adaptive thinking and JSON-schema structured output (`output_config.format`). Uses the beta `server-side-fallback-2026-07-01` with `fallbacks="default"`.
- The AI rewrites objectives, activities, assumptions, prerequisites and filler titles in the client's terms. It also:
  - picks capture channels
  - lists conflicts and the requested duration
  - extracts deliverable quantities with their sources
  - adds deliverables per phase
  - raises review flags
- **The AI never sets quantities in the text.** Quantities come from the form. Document quantities fill blank boxes only when `auto_deliverables` is ticked; otherwise a difference is recorded as a conflict.
- The whole form, names included, is passed to the AI. The library rules and knowledge files are passed as context.
- The AI step was tested only against a simulated API (`fake_api.py`, an SSE fake served through `ANTHROPIC_BASE_URL`). **It has never run against the real API** because there is no key.

### 3.6 Login and hosting (code DONE)
- The login is active only when `APP_USERNAME` is set. It also uses `APP_PASSWORD`.
- Security details:
  - `hmac.compare_digest` comparison
  - a 1-second delay after a failed attempt
  - 12-hour sessions
  - a secure cookie when hosted
  - a logout link
- Username given by Aya: `NM_MZTeam`. The password was given by Aya in the conversation. **It is deliberately not written in this document.** Get it from Aya and set it only as the `APP_PASSWORD` secret on the host, never in code or files.
- Other environment variables: `SECRET_KEY` (long random text), `ANTHROPIC_API_KEY` (optional), `PORT`.
- The Dockerfile uses python:3.12-slim and runs gunicorn with 1 worker, 4 threads, a 900 s timeout, bound to `$PORT`. It needs **≥1 GB of memory**, because a build uses about 500 MB.
- Generated decks live in `output/` and are lost when the host restarts.

---

## 4. Decisions and Rationale

| # | Decision | Status | Why | Alternatives rejected |
|---|---|---|---|---|
| 1 | "Training" means a reference library (rules, catalogue, knowledge files) given to Claude as context, plus fixed template slides. It does not mean fine-tuning. | CONFIRMED (explained to Aya, no objection) | Faithful to the brand, nothing invented, easy to update | Fine-tuning a model |
| 2 | Flask app with python-pptx that imports slides from the approved decks at package level | DONE | Keeps the exact 2026 design, so slides are copied, not redrawn | Generating slides from scratch (breaks the brand) |
| 3 | Quantities only from the form, or from the documents when the auto tick is on, with the source noted | CONFIRMED | "Nothing made up" | Letting the AI estimate |
| 4 | Blank = unknown (shown without a number), 0 = not in scope (removed) | DONE, explained to Aya | Every box is optional | Required boxes |
| 5 | BRD, UAT and handover stay in every deck but not on the form | CONFIRMED by Aya ("no brainer part of every proposal") | They are always included | Removing them from slides |
| 6 | References filtered by program type, same industry first | CONFIRMED | Aya's request | — |
| 7 | Credentials as host environment variables, never hardcoded | DONE | Security | Hardcoding in `app.py` |
| 8 | Railway recommended for hosting (≈$5/month, 1 GB) | Suggestion, PENDING Aya | A build uses ~500 MB, so free tiers are too small | Render, Azure, Fly.io (the Dockerfile works on them too) |
| 9 | Logo web search removed | CONFIRMED by Aya | Aya wants upload only | Wikidata / website search (built and then removed) |
| 10 | No preparation phase; the plan starts at W0/M0 | CONFIRMED | Aya's request | Preparation week |
| 11 | The 8 standard trainings taken from the KFH deck | ASSUMPTION, awaiting Aya | The screenshot did not arrive | — |
| 12 | Text analytics topic set pre-filled from 1 package upwards | ASSUMPTION | Harmless; Aya said "2 or more" | Only from 2 |
| 13 | Named items written into the activity steps (not the framing deliverable lines, which keep "Label (n)") | Claude's choice | Keeps the framing boxes short and readable | Long lists in the deliverables box |
| 14 | "Edit proposal requirements" creates a new job and keeps the old one | Claude's choice | Nothing is lost; the user can compare | Overwriting |
| 15 | Kept files are reused from the earlier job folder; the user can tick "remove it" | Claude's choice | Browsers cannot pre-fill file inputs | Asking the user to re-upload |
| 16 | Filler slides are clean text drafts in the brand layout | DONE (known limit) | Visual filler slides need design work | Copying visuals from past decks (other clients' content) |
| 17 | The capture slide's sample brand is covered with a white box and the client logo | DONE | Brand rule | — |

**Assumptions still to validate:** #11, #12, and the hex colour values read from the brand file (`RULES.md` says to confirm with marketing).
- Aya said to leave the catalogue "verify" items (e.g. Horizon Scope's country) as they are.
- The Africell PDF is scanned, and no text was read from it.

---

## 5. Technical Context

### 5.1 Stack and dependencies
- Python 3.10+ (Docker uses 3.12), with Flask ≥3.0, python-pptx 1.0.2, lxml, Pillow, python-docx, openpyxl, pdfplumber, anthropic ≥2.3.0, gunicorn, resvg-py (SVG) and pillow-heif (HEIC).
- Front end: plain HTML (Jinja), `static/app.js` (vanilla JS) and `static/style.css`. No build step.
- Testing used Playwright (Chromium) UI scripts and LibreOffice (`soffice --headless --convert-to pdf`) plus `pdftoppm` for rendering slides. These tools are not part of the package.

### 5.2 Where things are
**Shared project folder `/mnt/project-files/` (Aya's claude.ai project):**
- `app/proposal-builder/`: the current package. This is the source of truth.
- `app/proposal-builder.zip`: the downloadable package, ~113 MB, including the source decks. It is rebuilt with:
  ```bash
  cd /mnt/project-files/app && rm -f proposal-builder.zip && zip -qr proposal-builder.zip proposal-builder -x 'proposal-builder/.venv/*' 'proposal-builder/output/*' '*/__pycache__/*'
  ```
- `app/sample/`: the v1 sample deck and notes (outdated).
- `library/`:
  - `RULES.md`
  - `README.md`
  - `catalogue.md` / `catalogue.json` (22 past proposals)
  - `knowledge/*.md`: deliverables, domain-rules, filler-slides, intake-form, qa-checklist, rfp-to-slides, sections. A copy of `RULES.md` and `knowledge/` is inside the app at `proposal-builder/library/`.
- Client folders: `CDF/`, `KFH/`, `NHC/`, `Neoleap/`, `Tatweer THC/`, `Vision Bank/`, `Other different clients/`.
- Root files:
  - `20250107_NM_Technical Proposal Template 2026 [EN]-vf.pptx`
  - `20260122_NM_Technical Proposal Template 2026 [AR]-vf.pptx`
  - `20261101_NM_Client References [EN].pptx`
  - `20260510_NM_THC_VoC Program_Technical Proposal-vf.pptx`
  - `20250723_NM_Alfa 3.pptx`
  - `Brand Guidelines - Presentation 2.pptx`
- `uploads/hearth/`: Aya's uploads, named by id (see §9).

**During development, a working copy also lived in the session scratchpad** (`…/scratchpad/app/`), and changed files were copied into the package. That scratchpad is gone with the session; the package in `/mnt/project-files/app/proposal-builder/` is complete.

### 5.3 How a request flows (`app.py`)
1. `GET /` renders `index.html` with the defaults, industries, `TEAM`, program types, AI on/off and `edit` (a job id when editing).
2. The browser calls `GET /api/references?section=&program=&text=` to list references (Other industry → `section_for_text`).
3. `POST /generate` (multipart):
   1. Creates `output/<job>` (12 hex characters).
   2. `_form_from_request` parses fields, names and undecided flags, phases, the logo (`to_png`) and the documents (`read_document`). Earlier files are reused via `prev_job` unless `drop_<key>` is ticked. It writes `inputs.json`.
   3. `_validate`.
   4. `build_base_plan`, then optionally `tailor_with_ai`, then `finalize`.
   5. `DeckBuilder.build`.
   6. `plan_notes` and `qa_scan` add to the notes; `write_docx` writes them.
   7. Writes `result.json` and returns `{job, url}`.
4. `GET /result/<job>` shows the result page; `GET /download/<job>/<name>` serves the files.
5. `GET /api/inputs/<job>` returns the saved `inputs.json` so the form can be refilled for editing.
6. `/login` and `/logout`: a `before_request` hook enforces the login when `APP_USERNAME` is set.

### 5.4 Engine modules
- `engine/library.py`:
  - deck paths (`DECKS`)
  - `load_defaults`, `load_knowledge`
  - the references index (base Client References deck + `data/references_extra_EN.json`), with `REF_FIXES`, `REF_SKIP`, `PROGRAM_FIXES`
  - `program_tag`, `matches_program`, `pick_references`, `section_for_text`
- `engine/content.py`: `qty`, `map_channels`, `build_base_plan`, the AI schema and `SYSTEM` prompt, `tailor_with_ai`, `allowed_numbers`, `NAMED_STEPS` / `_named_steps`, `finalize`.
- `engine/builder.py`: `DeckBuilder`, with cover, TOC, dividers, About Medallia and capture slide, phases slides, framing slides, filler/card slides, understanding slide, timeline, references, team, footer year and `build`.
- `engine/pptx_ops.py`: low-level helpers. They cover the package-level slide `Importer` (with a PartNamer), shape cloning and deleting, text replacement, `set_slide_order`, and similar.
- `engine/inputs.py`: `read_document` (PDF via pdfplumber, DOCX, XLSX via openpyxl, TXT), with notes.
- `engine/images.py`: `to_png` (SVG via resvg, HEIC via pillow-heif, everything else via Pillow).
- `engine/review.py`: the `Notes` class, `plan_notes`, `qa_scan` (other client names, leftovers) and `write_docx`.

### 5.5 Technical issues met and how they were fixed
- **Launcher "refused to connect":** the server now opens the browser itself once it is ready, and the window stays open on error (see the launchers).
- **JS "Identifier 'sec' already declared"** broke the page. Fixed by renaming the variable to `cur`.
- **Stale reference list when the industry changed quickly.** Fixed with the `refsCall` counter guard.
- **The channel keyword "app" matched "whatsapp".** Fixed with regex word boundaries (`\b`).
- **Timeline overflowed with many rows.** Empty `<a:r><a:t/></a:r>` runs took the 18 pt default. Fixed by removing empty runs, adding rPr and scaling fonts.
- **The timeline arrow was placed off-slide.** Moved it to the table's right edge minus 330000 EMU.
- **Nested `<label>` elements** around the training tick and the "remove it" ticks. Restructured, because nested labels are invalid HTML.
- **Network blocks in the sandbox** (Wikidata, DuckDuckGo). The logo search was tested with mocks, then removed.
- **Memory:** a deck build uses about 500 MB, which sets the hosting size.

---

## 6. Outstanding Tasks

| # | Task | Owner | Status / blocker |
|---|---|---|---|
| 1 | **Put the app online.** Aya must:<br>(a) create an empty **private** GitHub repo (suggested name `proposal-builder`)<br>(b) connect GitHub to Claude (claude.ai/connect-github)<br>(c) create a **Railway** account (or similar) | Aya, then Claude | Waiting on Aya since 1 Nov. Then: push the package (without `.venv` and `output`; the source decks must be included), deploy from GitHub, set `APP_USERNAME`, `APP_PASSWORD`, `SECRET_KEY` and optionally `ANTHROPIC_API_KEY`, give the service ≥1 GB, generate a domain. **The Docker image has never been built or tested.** |
| 2 | **Claude API key** for RFP / Q&A analysis | Aya (console.anthropic.com, billed by Anthropic) | Not set, so "RFP analysis: off". The AI path has only been tested with a simulated API. First real run: check output quality, timing and cost. |
| 3 | **Confirm the 8 standard training sessions** (or resend the screenshot) | Aya | Asked on 2 Nov; no answer yet. If they differ, edit `standard_trainings` in `data/defaults.json`. |
| 4 | **Arabic version** (AR template, About Medallia AR, Client References AR, RTL, GE SS Two font) | Claude, with Aya's review | Not started. The AR source files exist (see §9). `language` only offers EN. |
| 5 | Visual filler slides (currently text drafts) | Claude / Aya | Known limit; not requested yet. |
| 6 | Test the Windows launcher on a real Windows PC | Aya | Only tested on Linux / Mac logic. |
| 7 | Validate the assumptions in §4 (#11, #12, brand hex codes) | Aya | Open |
| 8 | Africell PDF is scanned images (no text) | Aya, if needed | Not OCR'd. Low priority. |
| 9 | Design doc items (adoption checkpoint 30 vs 60 days, plan sizing, data residency) | Aya | Raised in the 26 Oct review; never decided. Not blocking the app. |

**UNKNOWN:**
- Whether Aya has created the GitHub repo or the Railway account.
- Whether Aya has tried the latest zip (the 2 Nov rounds 9–10, plus this README fix).
- Who besides Aya will use the app.

---

## 7. Next Steps (recommended order)

1. **Get the package.** Download `/mnt/project-files/app/proposal-builder.zip` from the project (or ask Aya for it). If it is lost, rebuild the code from Appendix B. Note that the source decks (`source_decks/*.pptx`) and the binary images (`static/nm_logo.png`, `data/capture/*.png`) are **not** in this document and must come from the zip or Aya's files.
   - *Expected:* a folder matching Appendix A.
2. **Run it locally** and check that the form loads.
   - Command: `pip install -r requirements.txt && python app.py`, or the launchers.
   - Build one proposal with sample values and open the .pptx.
   - *Expected:* about 80 slides, with the review notes shown on the result page.
3. **Ask Aya about the open items** in one message:
   - confirm the 8 training sessions
   - GitHub repo and Railway status
   - API key
4. **Deploy (once Aya has the repo and account):**
   1. Add the repo to the Claude session.
   2. Push the package.
   3. On Railway: New Project → Deploy from GitHub repo → Variables (`APP_USERNAME=NM_MZTeam`, `APP_PASSWORD=<from Aya>`, `SECRET_KEY=<random>`, `ANTHROPIC_API_KEY=<optional>`) → memory ≥1 GB → Settings → Networking → Generate Domain.
   - *Expected:* a login page at the domain; after sign-in, the form works and a build completes in under a minute without AI.
5. **With the API key:** run a real RFP, for example a KFH or NHC RFP from the client folders. **Never use NHC Sheet2.**
   - Check the tailored wording, the quantities from the documents and the review notes.
   - *Expected:* the "RFP analysis: on" badge, plus Understanding and Conflicts content in the notes.
6. **Then the next feature Aya asks for.** Arabic is the known next big item.

---

## 8. Working Instructions for the New Claude Instance

- **Preserve every rule and decision in §3 and §4.** In particular:
  - 2026 design only; old decks for content only
  - ignore commercial documents
  - nothing made up, and RFP asks applied
  - never copy one client's content into another's deck
  - NHC Sheet2 excluded
  - quantities only from the form or documented sources
  - BRD, UAT and handover kept in every deck
- **Don't redesign or redo completed work.** The form layout, field names (`d_<key>`, `name_<key>`, `undecided_<key>`, `std_trainings`, `auto_deliverables`, `extra_deliverables`, `timeline_unit`, `phase_name`, `phase_weeks`, `references`, `team`, `prev_job`, `drop_<key>`), the slide order and the timeline design were all approved through iterations with Aya.
- **Don't assume when information is missing.** Ask Aya one clear question, and recommend an answer. Aya prefers short, simple, practical replies and gets impatient with long theory.
- **Keep the existing conventions:**
  - Wording lives in `data/defaults.json`; the team list and order live in `TEAM` in `app.py`; reference corrections live at the top of `engine/library.py`.
  - User-facing text is plain English.
  - The review notes collect anything uncertain.
  - Credentials stay only in environment variables.
- **After each change:**
  1. Test the form in a browser (Playwright).
  2. Render the changed slides and look at them.
  3. Copy the files into `/mnt/project-files/app/proposal-builder/`.
  4. Rebuild the zip.
  5. Tell Aya what changed in a few bullets.
- **Document each change** (in the reply to Aya, and in the README if it affects use or setup).
- **Before starting, check for gaps:**
  - Compare the package against Appendix A.
  - Check whether Aya has answered the pending questions in §6.
  - Confirm the current date and the copyright footer year.

---

## 9. Important Reference Material

**Source decks inside the app (`source_decks/`):**
- `Technical Proposal Template 2026 [EN].pptx` (from `20250107_NM_Technical Proposal Template 2026 [EN]-vf.pptx`)
- `About Medallia [EN].pptx`
- `Client References [EN].pptx` (from `20261101_NM_Client References [EN].pptx`)
- `Case Studies [EN].pptx` (from New Branding Case Studies)
- `THC Team and References [EN].pptx` (refs on slides 1–4, profiles on slides 5–15)
- `VoE Case Studies [EN].pptx` (SANS)

**Library:** `/mnt/project-files/library/RULES.md`, `README.md`, `catalogue.md` / `catalogue.json`, and `knowledge/` (seven files).

**Best example decks:**
- KFH (2026 structure, Project Plan / timeline reference, Medallia Training Plan on slide 64)
- THC (`Tatweer THC/20260510_NM_THC_VoC Program_Technical Proposal-vf.pptx`: RFP-prescribed structure, team profiles)

**Aya's uploads (`/mnt/project-files/uploads/hearth/`, no extensions):**
| File id | Content |
|---|---|
| `a2b03466-…` | Design document `Technical_Proposal_Automation_Design_V0.1.docx` |
| `43c5eed0-…` | About Medallia **AR** (13 slides) |
| `355ed918-…` | Client References / case studies **AR** (34 slides) |
| `7ab43a4a-…` | New Branding Case Studies (91 slides) |
| `0ce229a1-…` | VoE Case Studies (19 slides) |
| `786b2d26-…` | Favicon SVG |
| `a5cb4dd5-…` | New Metrics logo PNG (header) |
| `1a1336be-…`, `562997f6-…`, `568a923c-…`, `98867d2e-…` | Screenshots and images Aya sent (intake form, launcher error, Project Plan reference slide and similar). The exact mapping is UNKNOWN; open them to check. |

**Private claude.ai artifacts from this conversation** (visible only to Aya's account):
- Design doc review: https://claude.ai/artifact/EhFnzTxGhB2xbgogc6aLvm
- "New Metrics proposal structure: my understanding (EN)": https://claude.ai/artifact/XG1XASRk3HGNAWdnGssprE

**External links:**
- Python for Windows: https://www.python.org/downloads/windows/
- Claude API keys: https://console.anthropic.com
- Hosting: https://railway.app
- Connect GitHub to Claude: https://claude.ai/connect-github

---

## 10. Final Handover Summary

- **Current status:** the app is feature-complete for English. It runs locally, and a login and Docker setup are ready for hosting. All of Aya's requests up to 2 Nov are DONE and delivered in `/mnt/project-files/app/proposal-builder.zip`.
- **Last completed activity:** the "Edit proposal requirements" button (2 Nov), which refills the whole form and keeps uploaded files. Then this handover, plus a small README correction and a zip rebuild (3 Nov).
- **Where work stopped:** waiting on Aya for three things:
  1. confirming the 8 standard training sessions
  2. a private GitHub repo plus Railway account to deploy
  3. optionally, a Claude API key
- **Very next action:** send Aya one short message asking for those three items. Once the repo exists, push the package and deploy it as in §7 step 4.

---

## Appendix A. File tree of `app/proposal-builder/`

Binary files are listed but not reproduced in Appendix B.

```
.dockerignore  (31 bytes)
.gitignore  (39 bytes)
Dockerfile  (570 bytes)
README.md  (5,375 bytes)
app.py  (16,863 bytes)
requirements.txt  (164 bytes)
run_mac.command  (889 bytes)
run_windows.bat  (1,671 bytes)
data/defaults.json  (15,010 bytes)
data/references_extra_EN.json  (6,490 bytes)
data/capture/dxa.png  (153,530 bytes)
data/capture/email.png  (55,802 bytes)
data/capture/feedless.png  (88,874 bytes)
data/capture/imports.png  (9,709 bytes)
data/capture/messaging.png  (260,303 bytes)
data/capture/social.png  (220,650 bytes)
data/capture/telephonic.png  (428,457 bytes)
data/capture/video.png  (585,994 bytes)
data/capture/voice.png  (313,787 bytes)
data/capture/web_app.png  (122,127 bytes)
engine/__init__.py  (0 bytes)
engine/builder.py  (34,340 bytes)
engine/content.py  (17,564 bytes)
engine/images.py  (1,364 bytes)
engine/inputs.py  (2,658 bytes)
engine/library.py  (8,924 bytes)
engine/pptx_ops.py  (13,068 bytes)
engine/review.py  (4,995 bytes)
library/RULES.md  (3,223 bytes)
library/knowledge/deliverables.md  (2,444 bytes)
library/knowledge/domain-rules.md  (1,636 bytes)
library/knowledge/filler-slides.md  (4,366 bytes)
library/knowledge/intake-form.md  (2,390 bytes)
library/knowledge/qa-checklist.md  (1,891 bytes)
library/knowledge/rfp-to-slides.md  (2,251 bytes)
library/knowledge/sections.md  (3,461 bytes)
source_decks/About Medallia [EN].pptx  (9,986,225 bytes)
source_decks/Case Studies [EN].pptx  (2,155,764 bytes)
source_decks/Client References [EN].pptx  (43,010,420 bytes)
source_decks/THC Team and References [EN].pptx  (11,592,814 bytes)
source_decks/Technical Proposal Template 2026 [EN].pptx  (47,192,310 bytes)
source_decks/VoE Case Studies [EN].pptx  (197,788 bytes)
static/app.js  (11,990 bytes)
static/favicon.svg  (8,317 bytes)
static/nm_logo.png  (19,290 bytes)
static/style.css  (7,664 bytes)
templates/index.html  (8,269 bytes)
templates/login.html  (1,001 bytes)
templates/result.html  (2,132 bytes)
```

Generated at runtime, not part of the package:
- `data/references_index_EN.json`: a cache of the Client References deck, rebuilt automatically when the deck changes.
- `.venv/`: the local virtual environment made by the launchers, including `.venv/installed.txt`, which is used to detect a changed `requirements.txt`.
- `output/<job>/` for each build. It holds `inputs.json` (used by "Edit proposal requirements"), `result.json`, `logo.png`, the uploaded `rfp_*` / `qa_*` files, the `.pptx` and the `_Review_Notes.docx`.

## Appendix B. Complete source code and configuration

This appendix holds every text file of the package, unshortened. Binary files (`source_decks/*.pptx`, `static/nm_logo.png`, `data/capture/*.png`) are not reproduced here; take them from the zip.

### `app.py`

```python
"""New Metrics technical proposal builder – local web app.

Run:  python app.py   then open http://127.0.0.1:5000
"""
import datetime
import hashlib
import hmac
import json
import os
import shutil
import re
import time
import traceback
import uuid

from flask import Flask, abort, jsonify, redirect, render_template, request, send_from_directory, session, url_for

from engine.builder import DeckBuilder, T
from engine.content import ai_available, allowed_numbers, build_base_plan, finalize, map_channels, tailor_with_ai
from engine.inputs import read_document
from engine.library import INDUSTRIES, load_defaults, matches_program, pick_references, references_index, section_for_text
from engine.images import to_png
from engine.review import Notes, plan_notes, qa_scan, write_docx

APP_DIR = os.path.dirname(os.path.abspath(__file__))
WORK = os.path.join(APP_DIR, "output")
os.makedirs(WORK, exist_ok=True)

app = Flask(__name__)
app.config["MAX_CONTENT_LENGTH"] = 200 * 1024 * 1024

# Login. When the app is hosted, the host sets APP_USERNAME and APP_PASSWORD (and SECRET_KEY).
# Without them (running on your own computer) there is no login page.
LOGIN_USER = os.environ.get("APP_USERNAME", "")
LOGIN_PASS = os.environ.get("APP_PASSWORD", "")
app.secret_key = os.environ.get("SECRET_KEY") or hashlib.sha256(("nm-proposal-builder" + LOGIN_PASS).encode()).hexdigest()
app.config.update(SESSION_COOKIE_HTTPONLY=True, SESSION_COOKIE_SAMESITE="Lax",
                  SESSION_COOKIE_SECURE=bool(os.environ.get("HTTPS_ONLY", LOGIN_USER)),
                  PERMANENT_SESSION_LIFETIME=datetime.timedelta(hours=12))


def _same(a, b):
    return hmac.compare_digest(a.encode("utf-8"), b.encode("utf-8"))


@app.before_request
def require_login():
    if not LOGIN_USER or request.endpoint in ("login", "static") or session.get("user") == LOGIN_USER:
        return None
    if request.path.startswith(("/api/", "/generate")):
        return jsonify(errors=["Your session has ended. Reload the page and sign in again."]), 401
    return redirect(url_for("login", next=request.path))


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        user, pw = request.form.get("username", ""), request.form.get("password", "")
        if LOGIN_USER and _same(user.strip(), LOGIN_USER) and _same(pw, LOGIN_PASS):
            session.clear()
            session.permanent = True
            session["user"] = LOGIN_USER
            nxt = request.args.get("next", "/")
            return redirect(nxt if nxt.startswith("/") and not nxt.startswith("//") else "/")
        time.sleep(1)   # slows down password guessing
        error = "Wrong username or password."
    return render_template("login.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))

# Team profiles, in the order they appear in the deck. "id" is "<source deck>:<slide number>".
TEAM = [{"id": "thc_refs:5", "name": "Rami Haffar", "role": "Partner – Digital Transformation, CX & EX", "on": True},
        {"id": "thc_refs:6", "name": "Karim Daou", "role": "Associate Partner (Technology)", "on": True},
        {"id": "thc_refs:7", "name": "Mohamad Zgheib", "role": "Team Leader", "on": True},
        {"id": "thc_refs:8", "name": "Aya Ibrahim", "role": "Technical Services Analyst", "on": True},
        {"id": "thc_refs:9", "name": "Amira Zeidan", "role": "Technical Services Analyst", "on": True},
        {"id": "thc_refs:10", "name": "Ali Mabrouk", "role": "Technical Services Associate", "on": True},
        {"id": "template:36", "name": "Alaa Arab", "role": "Principal", "on": True},
        {"id": "template:37", "name": "Iman Al-Barwani", "role": "Engagement Manager", "on": True},
        {"id": "template:38", "name": "Kristel El Achkar", "role": "Senior Consultant", "on": True},
        {"id": "thc_refs:11", "name": "Elie Khamisse", "role": "Associate Partner (Consulting)", "on": False},
        {"id": "thc_refs:12", "name": "Hannah-Mai Perl", "role": "Principal (Academy and Change Management)", "on": False},
        {"id": "thc_refs:13", "name": "Reem Al Ismaily", "role": "Senior Consultant", "on": False},
        {"id": "thc_refs:14", "name": "Abdulrahman Husain", "role": "Consultant", "on": False},
        {"id": "thc_refs:15", "name": "Ingrid Moukarzel", "role": "Consultant", "on": False}]
TEAM_IDS = [t["id"] for t in TEAM]


def job_dir(job):
    if not re.fullmatch(r"[a-f0-9]{12}", job or ""):
        abort(404)
    return os.path.join(WORK, job)


@app.route("/")
def index():
    d = load_defaults()
    edit = request.args.get("edit", "")
    if not (re.fullmatch(r"[a-f0-9]{12}", edit) and os.path.exists(os.path.join(WORK, edit, "inputs.json"))):
        edit = ""
    return render_template("index.html", defaults=d, industries=INDUSTRIES, team=TEAM, program_types=d["program_types"], login=bool(LOGIN_USER),
                           ai=ai_available(), phases=[p["name"] for p in d["phases"]], edit=edit)


@app.route("/api/inputs/<job>")
def api_inputs(job):
    """What was typed and uploaded for an earlier proposal, to edit and build again."""
    with open(os.path.join(job_dir(job), "inputs.json"), encoding="utf-8") as fh:
        return jsonify(json.load(fh))


def _previous_file(prev, key):
    """A file kept from the proposal being edited: (path, original name) or (None, None)."""
    if not prev or not re.fullmatch(r"[a-f0-9]{12}", prev) or request.form.get(f"drop_{key}"):
        return None, None
    try:
        with open(os.path.join(WORK, prev, "inputs.json"), encoding="utf-8") as fh:
            meta = json.load(fh)["files"].get(key)
    except (OSError, ValueError, KeyError):
        return None, None
    if not meta:
        return None, None
    path = os.path.join(WORK, prev, meta["stored"])
    return (path, meta["name"]) if os.path.exists(path) else (None, None)


@app.route("/api/references")
def api_references():
    section = request.args.get("section", "06")
    program = request.args.get("program", "voc")
    if section == "other":
        section = section_for_text(request.args.get("text", ""))
    picked = {r["id"] for r in pick_references(section, program_type=program)}
    order = [section] + INDUSTRIES[section][1] if section in INDUSTRIES else []
    order += [c for c in INDUSTRIES if c not in order]
    refs = [dict(r, picked=r["id"] in picked, industry_name=INDUSTRIES[r["section"]][0])
            for sec in order for r in references_index() if r["section"] == sec and matches_program(r, program)]
    return jsonify(refs)


def _form_from_request(job_path, notes):
    f = request.form
    d = load_defaults()
    form = {
        "language": f.get("language", "EN"),
        "client_name": f["client_name"].strip(),
        "industry_section": f.get("industry_section", "06"),
        "industry_other": f.get("industry_other", "").strip(),
        "project_title": f["project_title"].strip(),
        "description": f.get("description", "").strip(),
        "program_type": f.get("program_type", "voc"),
        "program_other": f.get("program_other", "").strip(),
        "deliverables": {x["key"]: f.get(f"d_{x['key']}", "").strip() for x in d["deliverables"]},
        "phases": [],
        "names": {k: [x.strip() for x in f.getlist(f"name_{k}") if x.strip()] for k in d["named_deliverables"]},
        "undecided": [k for k in d["named_deliverables"] if f.get(f"undecided_{k}")],
        "standard_trainings": bool(f.get("std_trainings")),
        "auto_deliverables": bool(f.get("auto_deliverables")),
        "timeline_unit": "months" if f.get("timeline_unit") == "months" else "weeks",
        "extra_deliverables": f.get("extra_deliverables", "").strip(),
        "reference_slides": f.getlist("references"),
        "team_slides": [x for x in TEAM_IDS if x in f.getlist("team")],
    }
    if form["industry_section"] == "other":
        form["industry_name"] = form["industry_other"]
        form["industry_section"] = section_for_text(form["industry_other"]) or ""
    else:
        form["industry_name"] = INDUSTRIES.get(form["industry_section"], ("",))[0]
    form["channel_names"] = form["names"]["channels"]
    form["channels_undecided"] = "channels" in form["undecided"]
    # named items: typed in the form, or not decided yet
    labels = {x["key"]: x["label"] for x in d["deliverables"]}
    for k in form["undecided"]:
        if k == "channels":
            notes.add("To confirm", "Distribution channels are not decided yet. Light the right channels on the Medallia capture slide once agreed.")
        else:
            notes.add("To confirm", f"{labels[k]}: the names are not decided yet, so the slides show the number only. Add the names once agreed.")
    _, unmatched = map_channels(form["channel_names"])
    for n in unmatched:
        notes.add("To confirm", f"The distribution channel '{n}' does not match a channel on the Medallia capture slide. Check that slide.")
    for name, weeks in zip(f.getlist("phase_name"), f.getlist("phase_weeks")):
        if name.strip() and weeks.strip():
            form["phases"].append({"name": name.strip(), "weeks": max(1, int(weeks))})
    # logo: any image file (PNG, JPG, SVG, WebP, GIF, HEIC...), converted to PNG for the deck
    # files from the proposal being edited are kept unless replaced or removed
    prev = f.get("prev_job", "")
    files = {}
    up = request.files.get("logo")
    path = os.path.join(job_path, "logo.png")
    if up and up.filename:
        try:
            to_png(up.read(), up.filename, path)
            form["logo_path"] = path
            files["logo"] = {"stored": "logo.png", "name": up.filename}
        except ValueError as e:
            form["logo_error"] = str(e)
    else:
        old, name = _previous_file(prev, "logo")
        if old:
            shutil.copyfile(old, path)
            form["logo_path"] = path
            files["logo"] = {"stored": "logo.png", "name": name}
    # documents
    texts = {}
    for key in ("rfp", "qa"):
        up = request.files.get(key)
        path = None
        if up and up.filename:
            name = up.filename
            path = os.path.join(job_path, f"{key}_" + re.sub(r"[^\w.\- ]", "_", name))
            up.save(path)
        else:
            old, name = _previous_file(prev, key)
            if old:
                path = os.path.join(job_path, os.path.basename(old))
                shutil.copyfile(old, path)
        if path:
            files[key] = {"stored": os.path.basename(path), "name": name}
            text, doc_notes = read_document(path)
            texts[key] = text
            for n in doc_notes:
                notes.add("Inputs", n)
    form["has_documents"] = bool(texts)
    # keep what was typed and uploaded, so the user can edit it and build again
    fields = {k: f.getlist(k) for k in f.keys() if k not in ("prev_job",) and not k.startswith("drop_")}
    with open(os.path.join(job_path, "inputs.json"), "w", encoding="utf-8") as fh:
        json.dump({"fields": fields, "files": files}, fh, ensure_ascii=False)
    return form, texts.get("rfp", ""), texts.get("qa", "")


def _validate(form):
    errors = []
    if not form["client_name"]:
        errors.append("Client name is required.")
    if not form["project_title"]:
        errors.append("Project title is required.")
    if form["auto_deliverables"] and not form["has_documents"]:
        errors.append("Upload the RFP or the scoping Q&A so the tool can read the deliverables from them, or untick that option.")
    if form.get("logo_error"):
        errors.append(form["logo_error"])
    if form["industry_section"] == "" and not form["industry_other"]:
        errors.append("Type the client's industry, or pick one from the list.")
    if form["program_type"] == "other" and not form["program_other"]:
        errors.append("Say what type of program it is.")
    d = load_defaults()
    labels = {x["key"]: x["label"] for x in d["deliverables"]}
    for k in d["named_deliverables"]:
        try:
            n = int(form["deliverables"].get(k) or 0)
        except ValueError:
            n = 0
        if n and k not in form["undecided"] and len(form["names"][k]) < n:
            errors.append(f"{labels[k]}: name all {n}, or tick 'Not decided yet'.")
    if not form["phases"]:
        errors.append("Add at least one phase with its duration.")
    if len(form["phases"]) > 10:
        errors.append("The timeline supports up to 10 phases.")
    if form["language"] != "EN":
        errors.append("Arabic proposals are not available yet.")
    return errors


@app.route("/generate", methods=["POST"])
def generate():
    job = uuid.uuid4().hex[:12]
    path = os.path.join(WORK, job)
    os.makedirs(path)
    notes = Notes()
    try:
        form, rfp, qa = _form_from_request(path, notes)
        errors = _validate(form)
        if errors:
            return jsonify(errors=errors), 400
        if form["auto_deliverables"] and not ai_available():
            notes.add("Inputs", "The deliverables could not be read from the RFP / Q&A because no Claude API key is set up. "
                      "The deck shows the deliverables without numbers.")
        plan = build_base_plan(form)
        if ai_available() and (rfp or qa or form["description"] or form["extra_deliverables"]):
            try:
                plan = tailor_with_ai(plan, form, rfp, qa)
            except Exception as e:
                notes.add("Inputs", f"The AI step did not run ({e}). The deck uses New Metrics' standard content.")
        if form["extra_deliverables"] and not plan["ai_used"]:
            notes.add("To complete", "Add the additional deliverables typed in the form to the phases (the RFP analysis "
                      "is off, so they were not placed automatically): " + form["extra_deliverables"])
        if form["program_type"] != "voc" and not plan["ai_used"]:
            notes.add("To complete", "The standard content is written for a VoC program. Adjust the wording for "
                      f"the {plan['program_name']} (employees instead of customers where needed).")
        plan = finalize(plan, form)
        builder = DeckBuilder(plan, form, notes)
        stem = re.sub(r"[^\w\-]+", "_", f"{datetime.date.today():%Y%m%d}_NM_{form['client_name']}_Technical_Proposal")
        deck = builder.build(os.path.join(path, stem + ".pptx"))
        plan_notes(notes, plan, form, allowed_numbers(form, rfp, qa, form["description"], form["extra_deliverables"]))
        qa_scan(notes, builder, plan["client"])
        write_docx(notes, os.path.join(path, stem + "_Review_Notes.docx"), f"{form['client_name']} – {form['project_title']}")
        with open(os.path.join(path, "result.json"), "w", encoding="utf-8") as fh:
            json.dump({"stem": stem, "notes": notes.as_dict(), "plan": plan, "slides": len(builder.prs.slides),
                       "ai_used": plan["ai_used"], "client": form["client_name"], "title": form["project_title"]},
                      fh, ensure_ascii=False, indent=1, default=str)
    except Exception as e:
        traceback.print_exc()
        return jsonify(errors=[f"Something went wrong while building the deck: {e}"]), 500
    return jsonify(job=job, url=url_for("result", job=job))


@app.route("/result/<job>")
def result(job):
    p = job_dir(job)
    with open(os.path.join(p, "result.json"), encoding="utf-8") as fh:
        r = json.load(fh)
    return render_template("result.html", r=r, job=job)


@app.route("/download/<job>/<path:name>")
def download(job, name):
    return send_from_directory(job_dir(job), name, as_attachment=True)


def _free_port(start=5000):
    import socket
    for port in range(start, start + 20):
        with socket.socket() as s:
            try:
                s.bind(("127.0.0.1", port))
                return port
            except OSError:
                continue
    raise SystemExit("No free port between 5000 and 5019. Close other apps and try again.")


def _open_browser_when_ready(url, port):
    import socket
    import threading
    import time
    import webbrowser

    def wait():
        for _ in range(120):
            try:
                with socket.create_connection(("127.0.0.1", port), timeout=1):
                    webbrowser.open(url)
                    return
            except OSError:
                time.sleep(0.5)
    threading.Thread(target=wait, daemon=True).start()


if __name__ == "__main__":
    port = int(os.environ["PORT"]) if os.environ.get("PORT") else _free_port()
    url = f"http://127.0.0.1:{port}"
    print(f"\nProposal builder running at {url}")
    print("Keep this window open while you use it. Close it to stop the app.\n")
    if "--no-browser" not in os.sys.argv:
        _open_browser_when_ready(url, port)
    app.run(host="127.0.0.1", port=port, debug=False)
```

### `engine/content.py`

```python
"""Turns the intake form (and the RFP / Q&A when given) into the proposal plan:
phases, framing boxes, filler slides, deliverables with quantities, and timeline.

Rule: quantities only ever come from the form. The AI step may rewrite wording to
follow the RFP, but every number it writes is checked against the inputs.
"""
import json
import os
import re

from .library import load_defaults, load_knowledge

LETTERS = "ABCDEFGHIJKLMNOP"
MODEL = "claude-opus-5-5"


def qty(form, key):
    v = form.get("deliverables", {}).get(key)
    try:
        return int(v) if v not in (None, "") else 0
    except ValueError:
        return 0


def excluded(form, key):
    """A box set to 0 means "not in scope". A blank box means "not known", so the work stays in."""
    return str(form.get("deliverables", {}).get(key, "")).strip() == "0"


def _deliverable_text(label, n):
    return f"{label} ({n})" if n else label


# named items from the form go into the activity steps: replace the generic step, or add one
NAMED_STEPS = {
    "surveys": ("Build the surveys on Medallia in English and Arabic", "Build the surveys: {}"),
    "channels": ("Configure each agreed channel", "Configure the agreed channels: {}"),
    "integrations": ("Build the data feeds agreed in the architecture", "Build the integrations: {}"),
    "roles": ("Configure dashboards per role", "Configure the dashboards for: {}"),
    "ta": ("Activate the industry topic set", "Activate the text analytics packages: {}"),
    "trainings": ("Run training for administrators, report users and close-the-loop users", "Run the training sessions: {}"),
}

NAMED_LABELS = {"surveys": "Surveys", "channels": "Distribution channels", "integrations": "Integrations",
                "roles": "Dashboard roles", "ta": "Text analytics packages", "trainings": "Training sessions"}


def _named_steps(key, names, steps):
    generic, named = NAMED_STEPS[key]
    joined = ", ".join(names)
    if generic in steps:
        return [named.format(joined) if s == generic else s for s in steps]
    line = f"{NAMED_LABELS[key]} in scope: {joined}"
    return steps if line in steps else [line] + steps


def _match_default(name, i, count, defaults):
    for p in defaults["phases"]:
        if p["name"].lower() == name.strip().lower():
            return p
    if count == len(defaults["phases"]):
        return defaults["phases"][i]
    return None


def map_channels(names):
    """Named distribution channels -> capture slide channel keys, plus the names that match none."""
    kw = load_defaults()["channel_keywords"]
    keys, unmatched = [], []
    for n in names:
        low = n.lower()
        hit = [k for k, words in kw.items() if any(re.search(r"\b" + re.escape(w), low) for w in words)]
        keys += [k for k in hit if k not in keys]
        if not hit:
            unmatched.append(n)
    return keys, unmatched


def program_name(form):
    t = form.get("program_type", "voc")
    if t == "other":
        return (form.get("program_other") or "").strip() or "program"
    return next((p["name"] for p in load_defaults()["program_types"] if p["key"] == t), "VoC program")


def build_base_plan(form):
    """Plan from the form and the library defaults only (no AI)."""
    d = load_defaults()
    phases_in = form["phases"]
    plan_phases = []
    for i, ph in enumerate(phases_in):
        base = _match_default(ph["name"], i, len(phases_in), d) or {
            "short": "", "objectives": [], "activities": [], "deliverables": [],
            "assumptions": [], "prerequisites": []}
        acts = []
        for a in base["activities"]:
            need = a.get("needs")
            if need and excluded(form, need):
                continue
            acts.append({"title": a["title"], "steps": list(a["steps"]),
                         "filler_title": a["filler"]["title"], "filler_takeaway": a["filler"]["takeaway"],
                         "deliverable_keys": [need] if need else []})
        dels = []
        for dl in base["deliverables"]:
            key = dl.get("key")
            need = dl.get("needs") or key
            if need and excluded(form, need):
                continue
            dels.append({"key": key, "label": dl["label"]})
        plan_phases.append({
            "name": ph["name"].strip(), "weeks": int(ph["weeks"]),
            "short": base["short"], "objectives": list(base["objectives"]),
            "activities": acts, "deliverables": dels,
            "assumptions": list(base["assumptions"]), "prerequisites": list(base["prerequisites"]),
            "from_library": bool(base["activities"]),
        })
    return {
        "client": form["client_name"].strip(),
        "title": form["project_title"].strip(),
        "program_name": program_name(form),
        "understanding": [],
        "phases": plan_phases,
        "channels": map_channels(form.get("channel_names") or [])[0],
        "requirements": [], "conflicts": [], "ai_flags": [],
        "requested_duration_weeks": 0,
        "ai_used": False,
    }


# --------------------------------------------------------------------- AI step

def _schema(channel_keys, deliverable_keys):
    s = lambda: {"type": "string"}
    arr = lambda item: {"type": "array", "items": item}
    obj = lambda props: {"type": "object", "properties": props, "required": list(props), "additionalProperties": False}
    activity = obj({"title": s(), "steps": arr(s()), "filler_title": s(), "filler_takeaway": s(),
                    "deliverable_keys": arr({"type": "string", "enum": deliverable_keys})})
    phase = obj({"name": s(), "short": s(), "objectives": arr(s()), "activities": arr(activity),
                 "assumptions": arr(s()), "prerequisites": arr(s()), "additional_deliverables": arr(s())})
    return obj({
        "proposal_title": s(),
        "program_name": s(),
        "understanding": arr(s()),
        "phases": arr(phase),
        "channels": arr({"type": "string", "enum": channel_keys}),
        "requirements": arr(obj({"requirement": s(), "source": s(), "addressed_in": s(),
                                 "status": {"type": "string", "enum": ["addressed", "partial", "gap"]}})),
        "conflicts": arr(obj({"topic": s(), "form_value": s(), "document_value": s(), "source": s()})),
        "requested_duration_weeks": {"type": "integer"},
        "deliverable_quantities": arr(obj({"key": {"type": "string", "enum": deliverable_keys}, "quantity": {"type": "integer"},
                                           "source": s()})),
        "review_flags": arr(s()),
    })


SYSTEM = """You prepare the content of a New Metrics technical proposal (a Medallia implementation proposal).
The program type in the form (VoC, VoE, both, or another type) decides the audience: customers, employees, or both.
You receive the consultant's intake form, a draft plan built from New Metrics' standard library, New Metrics' proposal rules, and optionally the client's RFP and scoping Q&A.

Your job:
1. Keep the draft plan's structure and the phase names and order from the form. Rewrite objectives, key activities, steps, assumptions, prerequisites and filler slide titles so they follow the RFP and Q&A, using the client's own terms. Add an activity when the RFP asks for work the draft does not cover; remove one only when the form or RFP excludes it.
2. Never invent facts: no numbers, volumes, system names, channels, regulators, dates or references that are not in the form, the RFP or the Q&A. Do not write quantities at all; the tool adds them from the form. If something is unclear, add a review flag instead of guessing.
3. Filler slide titles are action sentences in capitals that name the client, like the examples in the library (e.g. "WE WILL DESIGN THE SOLUTION ARCHITECTURE AND ENSURE MEDALLIA'S SEAMLESS INTEGRATION IN <CLIENT>'S IT LANDSCAPE"). The takeaway is one sentence of at most 25 words.
4. List every explicit requirement or evaluation criterion in the RFP and Q&A, where it comes from (section, page or Q&A row), where the plan addresses it, and whether it is addressed, partial or a gap.
5. Deliverable quantities: for each deliverable the RFP or Q&A states a number for (surveys, distribution channels, integrations, dashboard roles, text analytics packages, close-the-loop forms, training sessions, managed services hours), give the number and where it is stated. Only numbers written in the documents; leave out anything you would have to estimate.
6. List conflicts between the form and the documents (duration, number of surveys, channels, phases). Give the RFP's requested duration in weeks, or 0 if it does not state one.
7. Channels: choose the capture channels that the form's named distribution channels and the RFP or Q&A ask for.
8. Understanding: up to 5 short points on the client's context and objectives, taken from the RFP. Empty if there is no RFP.
9. Additional deliverables: the form's "extra_deliverables" text describes deliverables the consultant wants on top of the standard ones. Turn each into a short deliverable name, put it in the phase where it is produced (additional_deliverables), and add or adapt a key activity that produces it. No numbers unless the text gives them.
Write in clear, confident English, no jargon ("synergies", "turnkey", "moving the needle"). Q&A answers win over the RFP when they conflict.
Use the literal text <CLIENT> wherever the client's name goes."""


def ai_available():
    if os.environ.get("ANTHROPIC_API_KEY") or os.environ.get("ANTHROPIC_AUTH_TOKEN"):
        return True
    return os.path.isdir(os.path.expanduser("~/.config/anthropic"))


def tailor_with_ai(plan, form, rfp_text, qa_text):
    import anthropic

    d = load_defaults()
    knowledge = load_knowledge()
    channel_keys = [c["key"] for c in d["channels"]]
    deliverable_keys = [x["key"] for x in d["deliverables"]]
    draft = {"program_name": plan["program_name"], "phases": [
        {k: p[k] for k in ("name", "short", "objectives", "activities", "assumptions", "prerequisites")}
        for p in plan["phases"]]}
    form_view = {k: v for k, v in form.items() if k not in ("logo_path",)}
    library = "\n\n".join(f"### {name}\n{text}" for name, text in knowledge.items())
    user = [
        {"type": "text", "text": f"<proposal_rules>\n{library}\n</proposal_rules>"},
        {"type": "text", "text": f"<intake_form>\n{json.dumps(form_view, ensure_ascii=False, indent=1)}\n</intake_form>"},
        {"type": "text", "text": f"<draft_plan>\n{json.dumps(draft, ensure_ascii=False, indent=1)}\n</draft_plan>"},
        {"type": "text", "text": f"<rfp>\n{rfp_text or '(no RFP uploaded)'}\n</rfp>"},
        {"type": "text", "text": f"<scoping_qa>\n{qa_text or '(no Q&A uploaded)'}\n</scoping_qa>"},
        {"type": "text", "text": "Return the tailored plan."},
    ]
    client = anthropic.Anthropic()
    with client.beta.messages.stream(
        model=MODEL,
        max_tokens=64000,
        thinking={"type": "adaptive"},
        output_config={"effort": "high", "format": {"type": "json_schema", "schema": _schema(channel_keys, deliverable_keys)}},
        betas=["server-side-fallback-2026-07-01"],
        fallbacks="default",
        system=SYSTEM,
        messages=[{"role": "user", "content": user}],
    ) as stream:
        msg = stream.get_final_message()
    if msg.stop_reason == "refusal":
        raise RuntimeError("The AI step declined this request; the proposal was built from the library only.")
    if msg.stop_reason == "max_tokens":
        raise RuntimeError("The AI answer was cut off; the proposal was built from the library only.")
    text = "".join(b.text for b in msg.content if b.type == "text")
    out = json.loads(text)

    # keep phase names and weeks from the form; take the AI wording for the rest
    by_pos = out["phases"]
    for i, p in enumerate(plan["phases"]):
        if i >= len(by_pos):
            break
        a = by_pos[i]
        p["short"], p["objectives"] = a["short"], a["objectives"]
        p["activities"] = a["activities"]
        p["assumptions"], p["prerequisites"] = a["assumptions"], a["prerequisites"]
        p["deliverables"] += [{"label": x} for x in a.get("additional_deliverables") or []
                              if x.strip() and x.lower() not in [dl["label"].lower() for dl in p["deliverables"]]]
        keys_used = {k for act in a["activities"] for k in act["deliverable_keys"]}
        # deliverables with a quantity in the form but not in the library list for this phase
        for k in keys_used:
            if qty(form, k) and k not in [dl.get("key") for dl in p["deliverables"]]:
                label = next(x["label"] for x in d["deliverables"] if x["key"] == k)
                p["deliverables"].append({"key": k, "label": label})
    plan["title"] = plan["title"] or out["proposal_title"]
    plan["understanding"] = out["understanding"]
    if (rfp_text or qa_text) and out["channels"]:
        plan["channels_from_documents"] = out["channels"]
        added = [c for c in out["channels"] if c not in plan["channels"]]
        if added:
            plan["channels"] += added
            plan["ai_flags"] = ["These channels come from the RFP / Q&A, not from the distribution channels in the form, "
                                "and are lit on the Medallia capture slide: " + ", ".join(added) + "."]
    plan["requirements"] = out["requirements"]
    plan["conflicts"] = out["conflicts"]
    plan["requested_duration_weeks"] = out["requested_duration_weeks"]
    # deliverable numbers stated in the documents: fill blank boxes when the consultant asked for it
    plan["deliverable_sources"] = []
    labels = {x["key"]: x["label"] for x in d["deliverables"]}
    for item in out.get("deliverable_quantities") or []:
        k, q = item["key"], item["quantity"]
        if q <= 0:
            continue
        typed = str(form["deliverables"].get(k, "")).strip()
        if not typed and form.get("auto_deliverables"):
            form["deliverables"][k] = str(q)
            plan["deliverable_sources"].append(f"{labels[k]} ({q}) was taken from the documents ({item['source']}).")
        elif typed and typed != str(q):
            plan["conflicts"].append({"topic": labels[k], "form_value": typed, "document_value": str(q), "source": item["source"]})
    plan["ai_flags"] = plan.get("ai_flags", []) + out["review_flags"]
    plan["ai_used"] = True
    return plan


# ------------------------------------------------------------------ finishing

def allowed_numbers(form, *texts):
    nums = set()
    for v in form.get("deliverables", {}).values():
        if str(v).strip():
            nums.add(str(v).strip())
    for p in form["phases"]:
        nums.add(str(p["weeks"]))
    for names in (form.get("names") or {}).values():
        for n in names:
            nums.update(re.findall(r"\d[\d,\.]*", n))
    for t in texts:
        nums.update(re.findall(r"\d[\d,\.]*", t or ""))
    return nums


def finalize(plan, form):
    """Fill <CLIENT>, letter the activities, attach quantities, schedule the timeline."""
    client = plan["client"]
    possessive = client + ("'" if client.endswith("s") else "'s")

    def fill(t):
        return t.replace("<CLIENT>'S", possessive.upper()).replace("<CLIENT>'s", possessive) \
                .replace("<CLIENT>", client)

    named = {k: v for k, v in (form.get("names") or {}).items() if v}
    if form.get("channel_names") and not named.get("channels"):
        named["channels"] = [n for n in form["channel_names"] if n.strip()]
    start = 0  # the plan starts in week 0
    for p in plan["phases"]:
        p["short"] = fill(p["short"])
        p["objectives"] = [fill(x) for x in p["objectives"]]
        p["assumptions"] = [fill(x) for x in p["assumptions"]]
        p["prerequisites"] = [fill(x) for x in p["prerequisites"]]
        p["deliverable_lines"] = [_deliverable_text(dl["label"], qty(form, dl["key"]) if dl.get("key") else 0)
                                  for dl in p["deliverables"]]
        p["start"], p["end"] = start, start + p["weeks"] - 1
        n = max(len(p["activities"]), 1)
        for j, a in enumerate(p["activities"]):
            a["letter"] = LETTERS[j]
            a["title"] = fill(a["title"])
            a["steps"] = [fill(s) for s in a["steps"]]
            for k in a.get("deliverable_keys", []):
                if named.get(k):
                    a["steps"] = _named_steps(k, named[k], a["steps"])
            a["filler_title"] = fill(a["filler_title"]).upper()
            a["filler_takeaway"] = fill(a["filler_takeaway"])
            a["outputs"] = [_deliverable_text(next((x["label"] for x in p["deliverables"] if x.get("key") == k), k), qty(form, k))
                            for k in a.get("deliverable_keys", []) if qty(form, k)]
            # activities overlap: each runs for about 40% of the phase, starts spread across it
            span = max(1, min(p["weeks"], -(-p["weeks"] * 2 // 5)))
            off = round(j * (p["weeks"] - span) / (n - 1)) if n > 1 else 0
            a["start"] = start + off
            a["end"] = a["start"] + span - 1
            if "ms_hours" in a.get("deliverable_keys", []):   # support runs to the end of the plan
                a["end"] = p["end"]
        start = p["end"] + 1
    plan["understanding"] = [fill(x) for x in plan["understanding"]]
    plan["unit"] = form.get("timeline_unit", "weeks")
    plan["total"] = start
    plan["total_weeks"] = start if plan["unit"] == "weeks" else round(start * 4.33)
    plan["program_name"] = fill(plan["program_name"])
    return plan
```

### `engine/builder.py`

```python
"""Assembles the proposal deck from the 2026 template, the About Medallia deck and
the Client References deck, following the New Metrics section order."""
import copy
import datetime
import os
import re
import uuid

from lxml import etree
from pptx import Presentation
from pptx.oxml.ns import qn

from .library import DATA_DIR, deck_path, load_defaults
from .pptx_ops import (Importer, clone_shape, delete_shape, find_shape, fit_picture, iter_shapes,
                       replace_everywhere, scale_font, set_lines, set_paragraph_text,
                       set_slide_order, slide_text)

# Slide numbers (1-based) in the 2026 EN template
T = dict(cover=1, toc=2, about=list(range(3, 14)), exec_div=14, phases=15, framing=16, timeline=17,
         governance=18, approach_div=19, plan_div=22, plan_slides=list(range(24, 30)),
         refs_div=30, team_div=35, profiles=[36, 37, 38], closing=39)

# Phases slide: per column, the header group, its number and name boxes, and the bullet group / box
PHASE_COLS = [(183, 137, 138, 184, 186), (181, 139, 157, 187, 189), (182, 140, 162, 190, 1024),
              (171, 141, 167, 1025, 1027), (172, 174, 176, 1029, 1031)]
STEP_MARKERS = [3, 6, 8, 13, 15]
FRAMING = dict(title=7, objectives=18, activities=4, assumptions=19, prerequisites=10, deliverables=14,
               lbl_activities=11, lbl_objectives=12, lbl_deliverables=20, grp_assumptions=24, grp_prereq=23,
               grp_deliverables=22)
# About Medallia capture slide: picture shape id per channel
CAPTURE = {"email": 29, "web_app": 30, "messaging": 33, "feedless": 36, "social": 37, "imports": 40,
           "voice": 41, "video": 44, "dxa": 46, "telephonic": 7}
CAPTURE_EMAIL_OVERLAY = 6      # old client email mock-up left on the slide, removed
CAPTURE_LOGO_BOX = 48          # white box over the sample brand on the email example

EMU_PER_PT = 12700


def _txt(slide, sid):
    return find_shape(slide, shape_id=sid)


class DeckBuilder:
    def __init__(self, plan, form, notes):
        self.plan, self.form, self.notes = plan, form, notes
        lang = form.get("language", "EN")
        self.prs = Presentation(deck_path(lang, "template"))
        self.med = Presentation(deck_path(lang, "medallia"))
        self.lang = lang
        self._decks = {}
        self.imp = Importer(self.prs)
        self.base = list(self.prs.slides)
        self.generated = []   # slides whose text the QA scan checks
        self.client = plan["client"]

    # ------------------------------------------------------------ helpers
    def t(self, n):
        return self.base[n - 1]

    def deck(self, key):
        if key not in self._decks:
            self._decks[key] = Presentation(deck_path(self.lang, key))
        return self._decks[key]

    def source_slide(self, ref):
        """A slide from a source deck, by its id "<deck>:<slide number>"."""
        key, _, n = str(ref).partition(":")
        if key == "template":
            return self.t(int(n))
        slides = self.deck(key).slides
        n = int(n)
        return self.imp.import_slide(slides[n - 1]) if 1 <= n <= len(slides) else None

    def dup(self, n):
        return self.imp.import_slide(self.t(n))

    def logo(self, slide, box_shape):
        path = self.form.get("logo_path")
        if not path or not os.path.exists(path):
            return False
        fit_picture(slide, path, box_shape.left, box_shape.top, box_shape.width, box_shape.height, pad=0.12)
        if box_shape.has_text_frame:
            for p in box_shape.text_frame.paragraphs:
                for r in p.runs:
                    r.text = ""
        return True

    # ------------------------------------------------------------ sections
    def cover(self):
        s = self.t(T["cover"])
        tbox = _txt(s, 2)
        title = self.plan["title"].upper()
        set_paragraph_text(tbox.text_frame.paragraphs[0], title)
        line = find_shape(s, shape_id=9)
        bottom = (line.top - 40000) if line is not None else tbox.top + tbox.height
        tbox.height = int(tbox.height * 2.2)
        tbox.top = bottom - tbox.height
        tbox.text_frame._txBody.find(qn("a:bodyPr")).set("anchor", "b")
        if len(title) > 22:
            scale_font(tbox, max(0.55, 22 / len(title) * 1.25) if len(title) > 28 else 0.85)
        if not self.logo(s, _txt(s, 3)):
            self.notes.add("Inputs", "No client logo was added. The cover still shows the 'Client logo' placeholder.")
        date = datetime.date.today().strftime("%B %Y")
        paras = _txt(s, 5).text_frame.paragraphs
        if len(paras) >= 2:
            set_paragraph_text(paras[1], date)
        self.generated.append(s)
        return [s]

    def toc(self, entries):
        """entries: list of (label, slide). Page numbers are filled in at the end."""
        s = self.t(T["toc"])
        pairs = [(_txt(s, a), _txt(s, b)) for a, b in ((22, 23), (14, 15), (16, 17), (18, 19), (20, 21), (2, 3))]
        top, step = pairs[0][0].top, pairs[1][0].top - pairs[0][0].top
        while len(pairs) < len(entries):
            a = copy.deepcopy(pairs[-1][0]._element)
            b = copy.deepcopy(pairs[-1][1]._element)
            s.shapes._spTree.append(a)
            s.shapes._spTree.append(b)
            pairs.append((s.shapes[-2], s.shapes[-1]))
        for k, (lab, num) in enumerate(pairs):
            if k >= len(entries):
                delete_shape(lab)
                delete_shape(num)
                continue
            lab.top = num.top = top + k * step
            set_paragraph_text(lab.text_frame.paragraphs[0], entries[k][0])
            lab.width = max(lab.width, num.left - lab.left - 40000)
            if len(entries[k][0]) > 26:
                scale_font(lab, 0.85)
                lab.text_frame._txBody.find(qn("a:bodyPr")).set("wrap", "none")
        line = find_shape(s, shape_id=4)
        if line is not None:
            line.height = max(line.height, step * len(entries) + step // 2)
        self._toc = (s, pairs, entries)
        return [s]

    def _fill_toc_pages(self, order):
        s, pairs, entries = self._toc
        pos = {id(sl.part): i + 1 for i, sl in enumerate(order)}
        for k, (label, target) in enumerate(entries):
            set_paragraph_text(pairs[k][1].text_frame.paragraphs[0], f"{pos[id(target.part)]:02d}")

    def divider(self, slide, number):
        for sh in iter_shapes(slide.shapes):
            if sh.has_text_frame and re.fullmatch(r"\d{2}", sh.text_frame.text.strip()):
                set_paragraph_text(sh.text_frame.paragraphs[0], f"{number:02d}")
                break
        return slide

    def about_medallia(self):
        slides = []
        industry = self.form.get("industry_section", "")
        for i, src in enumerate(self.med.slides, 1):
            text = slide_text(src).upper()
            if "TOPIC SET" in text and "BANKING" in text and industry != "06":
                self.notes.add("To complete", "The About Medallia banking topic set slide was left out because the client is not a bank. Add the topic set slide for the client's industry if you have one.")
                continue
            s = self.imp.import_slide(src)
            self._fix_static_numbers(s)
            if "NATIVE CAPTURE" in text:
                self.capture_slide(s)
            slides.append(s)
        return slides

    def _fix_static_numbers(self, slide):
        """Some imported slides carry a typed page number; turn it into a real page number field."""
        for sh in list(iter_shapes(slide.shapes)):
            if sh.name.startswith("Slide Number") and sh.has_text_frame and sh.text_frame.text.strip().isdigit():
                p = sh.text_frame.paragraphs[0]._p
                r = p.find(qn("a:r"))
                if r is None:
                    continue
                fld = etree.Element(qn("a:fld"))
                fld.set("id", "{" + str(uuid.uuid4()).upper() + "}")
                fld.set("type", "slidenum")
                for child in list(r):
                    fld.append(child)
                p.replace(r, fld)

    def capture_slide(self, s):
        wanted = set(self.plan["channels"])
        for key, sid in CAPTURE.items():
            pic = find_shape(s, shape_id=sid)
            if pic is None:
                continue
            asset = next((os.path.join(DATA_DIR, "capture", f) for f in os.listdir(os.path.join(DATA_DIR, "capture"))
                          if f.startswith(key + ".")), None)
            blip = pic._element.find(".//" + qn("a:blip"))
            if asset:
                _, rId = s.part.get_or_add_image_part(asset)
                blip.set(qn("r:embed"), rId)
            for g in blip.findall(qn("a:grayscl")):
                blip.remove(g)
            # PowerPoint picture corrections (e.g. saturation 0 = greyed) live in an a14:imgProps
            # extension with a cached image layer; drop it so only our greyscale setting applies
            ext_lst = blip.find(qn("a:extLst"))
            if ext_lst is not None:
                for ext in list(ext_lst):
                    if ext.get("uri") == "{BEBA8EAE-BF5A-486C-A8C5-ECC9F3942E4B}":
                        ext_lst.remove(ext)
                if len(ext_lst) == 0:
                    blip.remove(ext_lst)
            if key not in wanted:
                g = etree.Element(qn("a:grayscl"))
                ext = blip.find(qn("a:extLst"))
                if ext is not None:
                    ext.addprevious(g)
                else:
                    blip.append(g)
        old = find_shape(s, shape_id=CAPTURE_EMAIL_OVERLAY)
        if old is not None:
            delete_shape(old)
        box = find_shape(s, shape_id=CAPTURE_LOGO_BOX)
        if box is not None:
            spTree = box._element.getparent()
            spTree.remove(box._element)
            spTree.append(box._element)
            box.fill.solid()
            from pptx.dml.color import RGBColor
            box.fill.fore_color.rgb = RGBColor(0xFF, 0xFF, 0xFF)
            box.line.fill.background()
            if not self.logo(s, box):
                self.notes.add("To complete", "Add the client logo on the email example of the Medallia capture slide.")
        if not wanted:
            self.notes.add("Inputs", "No distribution channel could be matched to the Medallia capture slide, so every channel on it is greyed out. Light the right ones by hand.")

    # ------------------------------------------------------------ phases slide
    def phases_slides(self, n, quantified):
        """The phases overview: one slide per group of up to 5 phases."""
        total = len(self.plan["phases"])
        groups = [list(range(i, min(i + 5, total))) for i in range(0, total, 5)]
        return [self.phases_slide(n, quantified, g, k, len(groups)) for k, g in enumerate(groups)]

    def phases_slide(self, n, quantified, idxs, page=0, pages=1):
        s = self.dup(n)
        phases = [self.plan["phases"][i] for i in idxs]
        N = len(phases)
        title = find_shape(s, shape_id=3)
        suffix = f" ({page + 1}/{pages})" if pages > 1 else ""
        set_paragraph_text(title.text_frame.paragraphs[0],
                           f"WE WILL FOLLOW A PRAGMATIC {len(self.plan['phases'])}-PHASE APPROACH TO DELIVER THE "
                           f"{self.plan['program_name'].upper()}{suffix}")
        heads = [find_shape(s, shape_id=c[0]) for c in PHASE_COLS]
        bodies = [find_shape(s, shape_id=c[3]) for c in PHASE_COLS]
        left0 = heads[0].left
        right = heads[-1].left + heads[-1].width
        slot = (right - left0) / (5 if pages > 1 else N)
        fx = min(slot / heads[0].width * 0.92, 2.0)
        for k in range(len(PHASE_COLS)):
            if k >= N:
                delete_shape(heads[k])
                delete_shape(bodies[k])
                continue
            ph = phases[k]
            _, num_id, name_id, _, bullets_id = PHASE_COLS[k]
            set_paragraph_text(find_shape(s, shape_id=num_id).text_frame.paragraphs[0], f"{idxs[k] + 1:02d}")
            unit = self.plan.get("unit", "weeks")
            dur = f"{ph['weeks']} {unit[:-1] if ph['weeks'] == 1 else unit}".upper()
            name = ph["name"].upper() + (f" ({dur})" if quantified else "")
            set_lines(find_shape(s, shape_id=name_id), [name])
            if quantified:
                lines = [a["title"] + (f" – {', '.join(a['outputs'])}" if a.get("outputs") else "") for a in ph["activities"]]
            else:
                lines = [a["title"] for a in ph["activities"]]
            box = find_shape(s, shape_id=bullets_id)
            set_lines(box, lines or [""])
            if N >= 4:     # narrow columns: smaller text so it stays above the footer
                scale_font(box, 0.85 if N == 4 else 0.78)
            for grp in (heads[k], bodies[k]):
                x = grp._element.find(qn("p:grpSpPr")).find(qn("a:xfrm"))
                ext = x.find(qn("a:ext"))
                ext.set("cx", str(int(int(ext.get("cx")) * fx)))
            heads[k].left = bodies[k].left = int(left0 + k * slot)
            # taller body when there is a lot of text
            chars = sum(len(l) for l in lines)
            per_line = max(18, int(26 * fx))
            est_lines = sum(max(1, -(-len(l) // per_line)) for l in lines) + len(lines) * 0.4
            x = bodies[k]._element.find(qn("p:grpSpPr")).find(qn("a:xfrm"))
            ext = x.find(qn("a:ext"))
            cap = 13
            if est_lines > cap:
                grow = min(est_lines / cap, 1.9)
                ext.set("cy", str(int(int(ext.get("cy")) * grow)))
                if est_lines > cap * 1.9:
                    scale_font(box, max(0.7, cap * 1.9 / est_lines))
        self.generated.append(s)
        return s

    # ------------------------------------------------------------ framing
    def _markers(self, s, active):
        N = len(self.plan["phases"])
        marks = [find_shape(s, shape_id=i) for i in STEP_MARKERS]
        if any(m is None for m in marks):
            return
        step = marks[1].left - marks[0].left
        on = copy.deepcopy(marks[0]._element.spPr.find(qn("a:solidFill")))
        off = copy.deepcopy(marks[1]._element.spPr.find(qn("a:solidFill")))
        if N > len(marks):
            # more phases than markers: add markers and shrink them to fit the same space
            right = marks[-1].left + marks[-1].width
            f = len(marks) / N
            w, h, top = int(marks[0].width * f), int(marks[0].height * f), marks[0].top
            for _ in range(N - len(marks)):
                el = clone_shape(marks[-1], s)
                marks.append(next(sh for sh in s.shapes if sh._element is el))
            for k, m in enumerate(marks):
                m.width, m.height = w, h
                m.top = top + int((h / f - h) / 2)
                m.left = int(right - (N - k) * step * f)
            step, shift = int(step * f), 0
            for k, m in enumerate(marks):
                spPr = m._element.spPr
                old = spPr.find(qn("a:solidFill"))
                new = copy.deepcopy(on if k == active else off)
                if old is not None:
                    old.addprevious(new)
                    spPr.remove(old)
            return
        shift = (len(marks) - N) * step
        for k, m in enumerate(marks):
            if k >= N:
                delete_shape(m)
                continue
            m.left = m.left + shift
            spPr = m._element.spPr
            old = spPr.find(qn("a:solidFill"))
            new = copy.deepcopy(on if k == active else off)
            if old is not None:
                old.addprevious(new)
                spPr.remove(old)

    def framing_slides(self, n, idx):
        ph = self.plan["phases"][idx]
        # split long phases over two slides so the text stays readable
        chunks, cur, lines = [], [], 0
        for a in ph["activities"]:
            need = 1 + len(a["steps"])
            if cur and lines + need > 18:
                chunks.append(cur)
                cur, lines = [], 0
            cur.append(a)
            lines += need
        chunks.append(cur)
        out = []
        for c, acts in enumerate(chunks):
            s = self.dup(n)
            title = _txt(s, FRAMING["title"])
            label = f"PHASE {idx + 1}: {ph['name'].upper()}" + (f" ({c + 1}/{len(chunks)})" if len(chunks) > 1 else "")
            runs = [r for p in title.text_frame.paragraphs for r in p.runs]
            if len(runs) >= 2:
                runs[-1].text = label
            set_lines(_txt(s, FRAMING["objectives"]), ph["objectives"] or [""])
            ka = []
            for a in acts:
                ka.append(("head", f"{a['letter']}. {a['title']}"))
                ka += [("bullet", st) for st in a["steps"]]
            box = _txt(s, FRAMING["activities"])
            set_lines(box, ka, styles={"head": 0, "bullet": 1})
            if len(ka) > 18:
                scale_font(box, max(0.75, 18 / len(ka)))
            for key in ("assumptions", "prerequisites", "deliverables"):
                b = _txt(s, FRAMING[key])
                vals = {"assumptions": ph["assumptions"], "prerequisites": ph["prerequisites"],
                        "deliverables": ph["deliverable_lines"]}[key]
                set_lines(b, vals or ["To be confirmed"])
                chars = sum(len(v) for v in vals)
                limit = 260 if key == "deliverables" else 120
                if chars > limit or len(vals) > (6 if key == "deliverables" else 3):
                    scale_font(b, max(0.7, min(limit / max(chars, 1), 1.0, (6 if key == "deliverables" else 3) / len(vals))))
            self._markers(s, idx)
            self.generated.append(s)
            out.append(s)
        return out

    # ------------------------------------------------------------ filler / text slides
    def _card_slide(self, title, takeaway, left_label, left_lines, right_label, right_lines, active=None):
        """An on-brand content slide built from the framing slide: a takeaway box on top,
        a large box on the left and one tall box on the right."""
        s = self.dup(T["framing"])
        F = FRAMING
        t = _txt(s, F["title"])
        paras = t.text_frame.paragraphs
        set_lines(t, [title])
        set_lines(_txt(s, F["objectives"]), [takeaway])
        set_lines(_txt(s, F["lbl_objectives"]), ["KEY TAKEAWAY"])
        set_lines(_txt(s, F["lbl_activities"]), [left_label])
        body = _txt(s, F["activities"])
        set_lines(body, [("bullet", l) for l in left_lines] or [("bullet", "")], styles={"bullet": 1})
        # right column: keep the deliverables box, stretch it over the assumptions/prerequisites space
        top_grp = _txt(s, F["grp_assumptions"])
        for gid in (F["grp_assumptions"], F["grp_prereq"]):
            g = find_shape(s, shape_id=gid)
            if g is not None:
                delete_shape(g)
        dgrp = find_shape(s, shape_id=F["grp_deliverables"])
        box = _txt(s, F["deliverables"])
        lbl = _txt(s, F["lbl_deliverables"])
        dy = box.top - body.top
        lbl.top -= dy
        box.top -= dy
        box.height = body.height
        set_lines(lbl, [right_label])
        set_lines(box, right_lines or [""])
        if active is None:
            for m in STEP_MARKERS:
                sh = find_shape(s, shape_id=m)
                if sh is not None:
                    delete_shape(sh)
        else:
            self._markers(s, active)
        if len(left_lines) > 16:
            scale_font(body, max(0.75, 16 / len(left_lines)))
        self.generated.append(s)
        return s

    def filler_slides(self, idx):
        ph = self.plan["phases"][idx]
        out = []
        for a in ph["activities"]:
            if a.get("outputs"):
                right_label, right = f"WHAT {self.client.upper()} GETS", a["outputs"]
            else:
                right_label, right = f"PHASE {idx + 1} DELIVERABLES", ph["deliverable_lines"]
            out.append(self._card_slide(a["filler_title"], a["filler_takeaway"],
                                        f"{a['letter']}. HOW WE WILL DO IT", a["steps"],
                                        right_label, right, active=idx))
        return out

    def understanding_slide(self):
        pts = self.plan.get("understanding") or []
        if not pts:
            return []
        resp = [f"Phase {i + 1}: {p['name']} – {p['short']}" for i, p in enumerate(self.plan["phases"])]
        return [self._card_slide("UNDERSTANDING YOUR REQUIREMENTS",
                                 f"We understood {self.client}'s objectives and shaped the approach around them.",
                                 "WHAT WE UNDERSTOOD", pts, "HOW THIS PROPOSAL RESPONDS", resp)]

    # ------------------------------------------------------------ timeline
    def timeline_slide(self):
        """Project plan Gantt in the style of the 2026 proposals: week columns W0..Wn, phase rows with
        the bright bar, activity rows with light bars, a dashed note box at the top right."""
        from pptx.dml.color import RGBColor
        from pptx.enum.shapes import MSO_SHAPE
        from pptx.enum.text import MSO_ANCHOR
        from pptx.text.text import _Paragraph
        from pptx.util import Pt
        s = self.dup(T["timeline"])
        tbl_shape = next(sh for sh in s.shapes if sh.has_table)
        tbl = tbl_shape._element.graphic.graphicData.tbl
        rows = tbl.findall(qn("a:tr"))
        hdr, ph_tpl, act_tpl = rows[0], rows[1], rows[2]

        def tc(row, i):
            return row.findall(qn("a:tc"))[i]
        tpl = {"hdr_label": tc(hdr, 0), "hdr_week": tc(hdr, 1),
               "ph_label": tc(ph_tpl, 0), "ph_on": tc(ph_tpl, 1), "ph_off": tc(ph_tpl, 3),
               "act_label": tc(act_tpl, 0), "act_on": tc(act_tpl, 1), "act_off": tc(act_tpl, 2)}
        tpl = {k: copy.deepcopy(v) for k, v in tpl.items()}

        unit = self.plan.get("unit", "weeks")
        letter = "M" if unit == "months" else "W"
        weeks = self.plan["total"]                # columns W0 .. W(n-1), or M0 .. M(n-1)
        bucket = 1 if weeks <= 30 else 2
        cols = [(w, min(w + bucket - 1, weeks - 1)) for w in range(0, weeks, bucket)]

        # same frame as the reference slide: full width, starting under the title
        tbl_shape.left, tbl_shape.top, tbl_shape.width = 304800, 721805, 11719556
        grid = tbl.find(qn("a:tblGrid"))
        for g in grid.findall(qn("a:gridCol")):
            grid.remove(g)
        label_w = 3397401 if len(cols) <= 28 else 3000000
        week_w = (tbl_shape.width - label_w) // len(cols)
        for i in range(len(cols) + 1):
            g = etree.SubElement(grid, qn("a:gridCol"))
            g.set("w", str(label_w if i == 0 else week_w))

        def cell(kind, text, second=None):
            c = copy.deepcopy(tpl[kind])
            txb = c.find(qn("a:txBody"))
            ps = txb.findall(qn("a:p"))
            for p in ps[1:]:
                txb.remove(p)
            set_paragraph_text(_Paragraph(ps[0], None), text)
            if second is not None:     # "W" over the week number
                r = ps[0].find(qn("a:r"))
                br = etree.SubElement(ps[0], qn("a:br"))
                if r.find(qn("a:rPr")) is not None:
                    br.append(copy.deepcopy(r.find(qn("a:rPr"))))
                r2 = copy.deepcopy(r)
                r2.find(qn("a:t")).text = second
                end = ps[0].find(qn("a:endParaRPr"))
                if end is not None:
                    end.addprevious(br)
                    end.addprevious(r2)
                else:
                    ps[0].append(r2)
            return c

        def row(src, cells):
            r = copy.deepcopy(src)
            for c in r.findall(qn("a:tc")):
                r.remove(c)
            for c in cells:
                r.append(c)
            return r

        for r in rows:
            tbl.remove(r)
        hcells = [cell("hdr_label", "Project Activities")]
        for a, b in cols:
            hcells.append(cell("hdr_week", letter, str(a) if a == b else f"{a}-{b}"))
        new_rows = [("hdr", row(hdr, hcells))]
        for i, ph in enumerate(self.plan["phases"]):
            cs = [cell("ph_label", f"{i + 1}. {ph['name']}")]
            for a, b in cols:
                cs.append(cell("ph_on" if not (b < ph["start"] or a > ph["end"]) else "ph_off", ""))
            new_rows.append(("ph", row(ph_tpl, cs)))
            for act in ph["activities"]:
                cs = [cell("act_label", f"{act['letter']}. {act['title']}")]
                for a, b in cols:
                    cs.append(cell("act_on" if not (b < act["start"] or a > act["end"]) else "act_off", ""))
                new_rows.append(("act", row(act_tpl, cs)))

        # row heights and text sizes fill the space down to the footer
        n_ph = sum(1 for k, _ in new_rows if k == "ph")
        n_act = sum(1 for k, _ in new_rows if k == "act")
        avail = 6240000 - tbl_shape.top
        hdr_h, ph_h = 430000, (315000 if n_ph <= 5 else 260000)
        f = 1.0
        act_h = max(200000, min(480000, (avail - hdr_h - ph_h * n_ph) // max(n_act, 1)))
        if hdr_h + ph_h * n_ph + act_h * n_act > avail:      # many rows: shrink everything
            f = avail / (hdr_h + ph_h * n_ph + act_h * n_act)
            hdr_h, ph_h, act_h = int(hdr_h * f), int(ph_h * f), int(act_h * f)
            act_h = max(act_h, 150000)
        act_sz = 1000 if act_h >= 400000 else 900 if act_h >= 300000 else 800 if act_h >= 240000 else 700
        fs = lambda v: max(700, int(v * min(1.0, f)))
        sizes = {"hdr": (hdr_h, fs(1100), fs(1000 if len(cols) <= 28 else 800)), "ph": (ph_h, fs(1200), 1000),
                 "act": (act_h, act_sz if f >= 1 else 700, act_sz)}
        for kind, r in new_rows:
            h, label_sz, week_sz = sizes[kind]
            r.set("h", str(h))
            tbl.append(r)
            for j, c in enumerate(r.findall(qn("a:tc"))):
                tcPr = c.find(qn("a:tcPr"))
                if tcPr is not None:
                    tcPr.set("marT", "0")
                    tcPr.set("marB", "0")
                    tcPr.set("anchor", "ctr")
                    if kind == "act" and j == 0:
                        tcPr.set("marL", "228600")
                for r_el in list(c.iter(qn("a:r"))):
                    t = r_el.find(qn("a:t"))
                    if t is None or not t.text:      # empty runs would take the 18pt default size
                        r_el.getparent().remove(r_el)
                    elif r_el.find(qn("a:rPr")) is None:
                        r_el.insert(0, etree.Element(qn("a:rPr")))
                for t_el in c.iter(qn("a:rPr"), qn("a:endParaRPr")):
                    t_el.set("sz", str(label_sz if j == 0 else week_sz))
                    if kind in ("hdr", "ph"):
                        t_el.set("b", "1")
                if kind == "hdr" and j > 0:
                    for p in c.iter(qn("a:p")):
                        pPr = p.find(qn("a:pPr"))
                        if pPr is None:
                            pPr = etree.Element(qn("a:pPr"))
                            p.insert(0, pPr)
                        pPr.set("algn", "ctr")
                        for ln in pPr.findall(qn("a:lnSpc")):
                            pPr.remove(ln)
                        lnSpc = etree.SubElement(pPr, qn("a:lnSpc"))
                        etree.SubElement(lnSpc, qn("a:spcPct")).set("val", "85000")
                        pPr.insert(0, lnSpc)
        tbl_shape.height = sum(int(r.get("h")) for _, r in new_rows)

        # the week 0 "preparation" arrow is not part of this design
        for sh in list(s.shapes):
            if sh.name.startswith("Arrow") or (sh.has_text_frame and "Week 0" in sh.text_frame.text):
                delete_shape(sh)
        # ongoing support continues after the plan: arrow at the end of the last row
        last = self.plan["phases"][-1]["activities"][-1:] if self.plan["phases"] else []
        if last and "ms_hours" in last[0].get("deliverable_keys", []):
            arrow = s.shapes.add_shape(MSO_SHAPE.RIGHT_ARROW, tbl_shape.left + tbl_shape.width - 330000,
                                       tbl_shape.top + tbl_shape.height - act_h // 2 - 121704, 470896, 243408)
            arrow.fill.solid()
            arrow.fill.fore_color.rgb = RGBColor(0x10, 0x63, 0xF7)
            arrow.line.fill.background()

        # title: duration
        title = next(sh for sh in s.shapes if sh.has_text_frame and "PROJECT PLAN" in sh.text_frame.text)
        if unit == "months":
            dur = f"{weeks} month" + ("s" if weeks != 1 else "")
        else:
            months = round(weeks / 4.33)
            dur = f"{months} months ({weeks} Weeks)" if weeks >= 8 else f"{weeks} Weeks"
        for p in title.text_frame.paragraphs:
            runs = p.runs
            for k, r in enumerate(runs):
                if re.search(r"\d+ (weeks|months)", r.text, re.I):
                    r.text = dur
                    if k > 0:   # same look as the rest of the sentence
                        r._r.replace(r._r.find(qn("a:rPr")), copy.deepcopy(runs[k - 1]._r.find(qn("a:rPr"))))
        # dependency note in a dashed box at the top right
        box = s.shapes.add_shape(MSO_SHAPE.RECTANGLE, 8008482, 37364, 4015874, 516309)
        box.fill.background()
        box.line.color.rgb = RGBColor(0xA6, 0xA6, 0xA6)
        box.line.width = 9525
        from pptx.enum.dml import MSO_LINE
        box.line.dash_style = MSO_LINE.DASH
        tf = box.text_frame
        tf.word_wrap = True
        tf.vertical_anchor = MSO_ANCHOR.MIDDLE
        tf.margin_left = tf.margin_right = 91440
        tf.margin_top = tf.margin_bottom = 27432
        p = tf.paragraphs[0]
        from pptx.enum.text import PP_ALIGN
        p.alignment = PP_ALIGN.LEFT
        for text, bold, italic in (("*Note: ", True, True),
                                   (f"Project timelines are dependent on {self.client}'s timely support across the defined "
                                    "workflow and assumptions. Any changes to the previous assumptions may impact the "
                                    "delivery schedule and delay the planned go-live time.", False, False)):
            r = p.add_run()
            r.text = text
            r.font.size = Pt(7.5)
            r.font.bold, r.font.italic = bold, italic
            r.font.color.rgb = RGBColor(0, 0, 0)
        self.generated.append(s)
        return s

    # ------------------------------------------------------------ governance etc.
    def client_text(self, slide):
        for old in ("[client name]", "[client Name]", "[Client Name]", "[client]"):
            replace_everywhere(slide, old, self.client)
        N, W, U = len(self.plan["phases"]), self.plan["total"], self.plan.get("unit", "weeks")
        replace_everywhere(slide, "Phases 1 to 5 (for 24 weeks)", f"Phases 1 to {N} (for {W} {U})")
        for sh in list(iter_shapes(slide.shapes)):
            if sh.has_text_frame and sh.text_frame.text.strip() == "Client logo":
                self.logo(slide, sh)
        return slide

    def references(self):
        out = [s for s in (self.source_slide(r) for r in self.form.get("reference_slides") or []) if s is not None]
        if not out:
            self.notes.add("To complete", "No client references were selected.")
        return out

    def team(self):
        """Team profiles in the order of the form's list."""
        chosen = self.form.get("team_slides") or [f"template:{n}" for n in T["profiles"]]
        return [s for s in (self.source_slide(r) for r in chosen) if s is not None]

    def footer_year(self):
        year = str(datetime.date.today().year)
        for m in self.prs.slide_masters:
            for part in [m] + list(m.slide_layouts):
                for t_el in part._element.iter(qn("a:t")):
                    if t_el.text and re.search(r"RESERVED \d{4}", t_el.text):
                        t_el.text = re.sub(r"RESERVED \d{4}", f"RESERVED {year}", t_el.text)

    # ------------------------------------------------------------ build
    def build(self, out_path):
        order = []
        order += self.cover()
        toc_slide = self.t(T["toc"])
        order.append(toc_slide)

        about_div = self.divider(self.t(T["about"][0]), 1)
        order += [about_div] + [self.t(n) for n in T["about"][1:]]

        med = self.about_medallia()
        med_div = self.divider(med[0], 2) if med else None
        order += med

        exec_div = self.divider(self.t(T["exec_div"]), 3)
        order.append(exec_div)
        order += self.understanding_slide()
        order += self.phases_slides(T["phases"], quantified=True)
        for i in range(len(self.plan["phases"])):
            order += self.framing_slides(T["framing"], i)
        order.append(self.timeline_slide())
        order.append(self.client_text(self.dup(T["governance"])))

        appr_div = self.divider(self.t(T["approach_div"]), 4)
        order.append(appr_div)
        order += self.phases_slides(T["phases"], quantified=False)
        for i in range(len(self.plan["phases"])):
            order += self.framing_slides(T["framing"], i)
            order += self.filler_slides(i)

        plan_div = self.divider(self.t(T["plan_div"]), 5)
        order.append(plan_div)
        order.append(self.timeline_slide())
        order += [self.client_text(self.t(n)) for n in T["plan_slides"]]

        refs_div = self.divider(self.t(T["refs_div"]), 6)
        order.append(refs_div)
        order += self.references()

        team_div = self.divider(self.t(T["team_div"]), 7)
        order.append(team_div)
        order += self.team()
        order.append(self.t(T["closing"]))

        entries = [("About Us", about_div)]
        if med_div is not None:
            entries.append(("About Medallia", med_div))
        entries += [("Executive Summary", exec_div), ("Project Approach and Methodology", appr_div),
                    ("Project Plan and Governance", plan_div), ("Client References", refs_div), ("Our Team", team_div)]
        self.toc(entries)
        self._fill_toc_pages(order)
        self.footer_year()
        set_slide_order(self.prs, order)
        self.prs.save(out_path)
        return out_path
```

### `engine/library.py`

```python
"""Paths to the source decks, the default content, and the client references index."""
import json
import os
import re

from pptx import Presentation

from .pptx_ops import iter_shapes

APP_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
DATA_DIR = os.path.join(APP_DIR, "data")
DECKS_DIR = os.path.join(APP_DIR, "source_decks")
KNOWLEDGE_DIR = os.path.join(APP_DIR, "library")

DECKS = {
    "EN": {
        "template": "Technical Proposal Template 2026 [EN].pptx",
        "medallia": "About Medallia [EN].pptx",
        "references": "Client References [EN].pptx",
        "cases": "Case Studies [EN].pptx",
        "thc_refs": "THC Team and References [EN].pptx",
        "voe_cases": "VoE Case Studies [EN].pptx",
    },
}

# Section numbers in the Client References deck, and which sections are closest to each.
INDUSTRIES = {
    "01": ("Government, ministries, municipalities", ["02", "12", "04"]),
    "02": ("Regulators, funding authorities", ["01", "06", "07"]),
    "03": ("Telecommunications", ["13", "06", "09"]),
    "04": ("Real estate, development", ["01", "10", "09"]),
    "05": ("Education", ["01", "02", "12"]),
    "06": ("Banking, fintech, financial services", ["07", "02", "13"]),
    "07": ("Insurance", ["06", "02", "12"]),
    "08": ("Oil & gas, utilities, petrochemicals", ["01", "02", "13"]),
    "09": ("Retail, shopping, food", ["10", "06", "14"]),
    "10": ("Hospitality, F&B, destinations, events", ["09", "04", "11"]),
    "11": ("Airport, airline, transport", ["10", "01", "08"]),
    "12": ("Healthcare", ["01", "07", "02"]),
    "13": ("IT, technology, business services", ["03", "06", "02"]),
    "14": ("Automotive", ["09", "13", "10"]),
}


def deck_path(lang, kind):
    return os.path.join(DECKS_DIR, DECKS[lang][kind])


def load_defaults():
    with open(os.path.join(DATA_DIR, "defaults.json"), encoding="utf-8") as f:
        return json.load(f)


def load_knowledge():
    """The library text files (rules, sections, deliverables...) used as context for the AI step."""
    out = {}
    if not os.path.isdir(KNOWLEDGE_DIR):
        return out
    for root, _, files in os.walk(KNOWLEDGE_DIR):
        for fn in sorted(files):
            if fn.endswith(".md"):
                with open(os.path.join(root, fn), encoding="utf-8") as f:
                    out[fn] = f.read()
    return out


def _is_divider(texts):
    nums = [t for t in texts if re.fullmatch(r"\d{2}", t)]
    return bool(nums) and len(texts) <= 4, (nums[0] if nums else None)


def build_references_index(lang="EN"):
    prs = Presentation(deck_path(lang, "references"))
    index, section = [], None
    skip = ("Industry", "Duration", "Country", "»", "CHALLENGE", "APPROACH", "OUTCOME", "THE CHALLENGE", "RESULTS")
    for i, slide in enumerate(prs.slides, 1):
        texts = [sh.text_frame.text.strip() for sh in iter_shapes(slide.shapes)
                 if sh.has_text_frame and sh.text_frame.text.strip()]
        is_div, num = _is_divider(texts)
        if is_div:
            section = num
            continue
        if section in (None, "00") or i == 1:
            continue
        body = " ".join(texts)
        if len(body) < 80:
            continue
        industry = next((t.split(":", 1)[1].strip() for t in texts if t.startswith("Industry:")), "")
        labels = [t.replace("\n", " ") for t in texts if not t.startswith(skip) and len(t) < 70 and not t.isdigit()]
        index.append({
            "slide": i,
            "section": section,
            "client": labels[0] if labels else f"Slide {i}",
            "project": labels[1] if len(labels) > 1 else "",
            "industry": industry,
            "voc": bool(re.search(r"medallia|voice of (the )?customer|\bvoc\b|voe", body, re.I)),
        })
    return index


def _base_references_index(lang="EN"):
    path = os.path.join(DATA_DIR, f"references_index_{lang}.json")
    src = deck_path(lang, "references")
    if os.path.exists(path) and os.path.getmtime(path) >= os.path.getmtime(src):
        with open(path, encoding="utf-8") as f:
            return json.load(f)
    idx = build_references_index(lang)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(idx, f, ensure_ascii=False, indent=1)
    return idx


def references_index(lang="EN"):
    """All case studies: the Client References deck, then the ones added from the Case Studies and
    THC decks (listed in data/references_extra_<lang>.json). Each has an id "<deck>:<slide>"."""
    idx = [dict(r, deck="references", **REF_FIXES.get(f"references:{r['slide']}", {}))
           for r in _base_references_index(lang) if f"references:{r['slide']}" not in REF_SKIP]
    extra = os.path.join(DATA_DIR, f"references_extra_{lang}.json")
    if os.path.exists(extra):
        with open(extra, encoding="utf-8") as f:
            idx += json.load(f)
    for r in idx:
        r["id"] = f"{r['deck']}:{r['slide']}"
        r["program"] = program_tag(r)
    return idx


# Corrections to titles the automatic reading of the Client References deck gets wrong,
# and slides that are testimonials rather than case studies.
REF_FIXES = {
    "references:15": {"project": "Beneficiary Care Governance, Operating Model & Digital Roadmap"},
    "references:17": {"project": "Customer Satisfaction Study"},
    "references:22": {"project": "CX Design and Improvement of Service and Product Strategy"},
    "references:63": {"project": "VOC program migration and enhancement"},
    "references:64": {"project": "Digital Experience Measurement"},
    "references:65": {"project": "VOC program migration and enhancement"},
    "references:62": {"program": "voc"},     # VoC platform overhaul
    "references:71": {"program": "voc"},     # Predictive NPS
}
REF_SKIP = {"references:34", "references:87", "references:89"}
# Program type of case studies whose title does not say it
PROGRAM_FIXES = {"Executive Office Work From Home Study": "voe", "Learning and development assessment": "voe",
                 "Closing Experience Gap": "voc", "Form Optimization": "voc", "Digital Channel Transformation": "voc",
                 "Branch Merger": "voc"}

EMPLOYEE = r"employee|\bex\b|\bvoe\b|engagement|360 feedback|workforce|people"
CUSTOMER = (r"customer|\bcx\b|\bvoc\b|patient|guest|passenger|beneficiar|citizen|client|digital experience|\bdx\b|"
            r"\bdxi\b|social listening|mystery shopping|service design|satisfaction|market research|\bnps\b|cx programs")
GENERIC = r"journey|experience measurement|experience transformation|experience uplift|experience gap"


def program_tag(r):
    """What a case study is about: "voc", "voe", "both", or "other" (neither, e.g. a strategy study)."""
    if r.get("program"):
        return r["program"]
    fixes = {k.lower(): v for k, v in PROGRAM_FIXES.items()}
    title = " ".join((r.get("project") or "").split()).lower()
    if title in fixes:
        return fixes[title]
    text = f"{r.get('project', '')} {r.get('client', '')}".lower()
    e, c = bool(re.search(EMPLOYEE, text)), bool(re.search(CUSTOMER, text))
    generic = bool(re.search(GENERIC, text))
    return "both" if e and c else "voe" if e else "voc" if c or generic else "other"


def matches_program(r, program_type):
    """VoC shows customer case studies, VoE employee ones, both shows either; other shows all."""
    if program_type == "voc":
        return r["program"] in ("voc", "both")
    if program_type == "voe":
        return r["program"] in ("voe", "both")
    if program_type == "both":
        return r["program"] != "other"
    return True


def section_for_text(text, lang="EN"):
    """Closest industry section for a free-text industry ("Other"), or None."""
    words = [w for w in re.findall(r"[a-z]{4,}", (text or "").lower())]
    if not words:
        return None
    scores = {}
    for code, (name, _) in INDUSTRIES.items():
        scores[code] = sum(2 for w in words if w[:5] in name.lower())
    for r in references_index(lang):
        ind = (r.get("industry") or "").lower()
        scores[r["section"]] += sum(1 for w in words if w[:5] in ind)
    best = max(scores, key=scores.get)
    return best if scores[best] else None


def pick_references(section, count=4, lang="EN", program_type="voc"):
    """Same industry first (Medallia / VoC projects first), then the closest industries,
    keeping only case studies that match the program type."""
    if section not in INDUSTRIES:
        return []
    idx = [r for r in references_index(lang) if matches_program(r, program_type)]
    program_is_voc = program_type != "voe"
    order = [section] + INDUSTRIES[section][1]
    picked = []
    for sec in order:
        refs = [r for r in idx if r["section"] == sec]
        refs.sort(key=lambda r: (not r["voc"]) if program_is_voc else 0)
        for r in refs:
            if len(picked) < count and r["id"] not in [p["id"] for p in picked]:
                picked.append(r)
    return picked
```

### `engine/pptx_ops.py`

```python
"""Low-level PowerPoint operations: copy slides inside a deck or between decks,
reorder and delete slides, and replace text while keeping the template formatting.

python-pptx has no slide copy, so this works on the package parts directly.
A slide copied from another deck brings its own layout and master with it,
unless an identical master already exists in the target deck.
"""
import copy
import hashlib
import re

from lxml import etree
from pptx.opc.constants import RELATIONSHIP_TARGET_MODE as RTM
from pptx.opc.constants import RELATIONSHIP_TYPE as RT
from pptx.opc.package import PartFactory, _Relationship
from pptx.opc.packuri import PackURI
from pptx.oxml.ns import qn

NS_R = "http://schemas.openxmlformats.org/officeDocument/2006/relationships"
NS_A = "http://schemas.openxmlformats.org/drawingml/2006/main"
NS_P = "http://schemas.openxmlformats.org/presentationml/2006/main"


class PartNamer:
    """Hands out unused part names. package.next_partname only sees parts that are
    already reachable, which is not true while a master and its layouts are being copied."""

    def __init__(self, package):
        self.used = {str(p.partname) for p in package.iter_parts()}

    def new(self, like):
        m = re.match(r"^(.*?)(\d*)(\.\w+)$", str(like))
        stem, ext = m.group(1), m.group(3)
        n = 1
        while f"{stem}{n}{ext}" in self.used:
            n += 1
        name = f"{stem}{n}{ext}"
        self.used.add(name)
        return PackURI(name)


def _add_rel(part, rId, reltype, target, external=False):
    part.rels._rels[rId] = _Relationship(
        part.rels._base_uri, rId, reltype, RTM.EXTERNAL if external else RTM.INTERNAL, target
    )


def _drop_slide_links(xml_part, rIds):
    """Remove hyperlinks that point at slides of the source deck."""
    root = xml_part._element
    for rId in rIds:
        for el in etree.ElementBase.xpath(root, f".//*[@r:id='{rId}']", namespaces={"r": NS_R}):
            if el.tag.endswith("}hlinkClick") or el.tag.endswith("}hlinkMouseOver"):
                el.getparent().remove(el)


class Importer:
    """Copies slides from one or more source decks into a target deck."""

    def __init__(self, dst_prs):
        self.dst = dst_prs
        self.pkg = dst_prs.part.package
        self.namer = PartNamer(self.pkg)
        # python-pptx's own part naming (pictures added later) must go through the same namer
        self.pkg.next_partname = lambda tmpl: self.namer.new(tmpl % 1)
        self.pkg.next_image_partname = lambda ext: self.namer.new(f"/ppt/media/image1.{ext}")
        self.pkg.next_media_partname = lambda ext: self.namer.new(f"/ppt/media/media1.{ext}")
        self.memo = {}          # id(src part) -> dst part
        self._master_sigs = {}  # signature -> dst master part
        for m in dst_prs.slide_masters:
            self._master_sigs[self._master_sig(m.part)] = m.part

    @staticmethod
    def _master_sig(master_part):
        h = hashlib.sha1(master_part.blob)
        for rel in sorted(master_part.rels.values(), key=lambda r: r.rId):
            if rel.is_external:
                continue
            if rel.reltype in (RT.SLIDE_LAYOUT, RT.THEME):
                h.update(rel.target_part.blob)
        return h.hexdigest()

    def _copy_part(self, src):
        """Copy a part and everything it points to (images, media, charts, theme...)."""
        key = id(src)
        if key in self.memo:
            return self.memo[key]
        new = PartFactory(self.namer.new(src.partname), src.content_type, self.pkg, src.blob)
        self.memo[key] = new
        slide_links = []
        for rel in src.rels.values():
            if rel.is_external:
                _add_rel(new, rel.rId, rel.reltype, rel.target_ref, external=True)
            elif rel.reltype in (RT.SLIDE, RT.NOTES_SLIDE, RT.NOTES_MASTER, RT.HANDOUT_MASTER):
                slide_links.append(rel.rId)
            else:
                _add_rel(new, rel.rId, rel.reltype, self._copy_part(rel.target_part))
        if slide_links and hasattr(new, "_element"):
            _drop_slide_links(new, slide_links)
        return new

    def _layout_for(self, src_layout_part):
        key = id(src_layout_part)
        if key in self.memo:
            return self.memo[key]
        src_master = src_layout_part.part_related_by(RT.SLIDE_MASTER)
        sig = self._master_sig(src_master)
        if sig in self._master_sigs:
            dst_master = self._master_sigs[sig]
            src_layouts = [r.target_part for r in sorted(src_master.rels.values(), key=lambda r: r.rId)
                           if not r.is_external and r.reltype == RT.SLIDE_LAYOUT]
            dst_layouts = [r.target_part for r in sorted(dst_master.rels.values(), key=lambda r: r.rId)
                           if not r.is_external and r.reltype == RT.SLIDE_LAYOUT]
            for s, d in zip(src_layouts, dst_layouts):
                self.memo[id(s)] = d
            self.memo[id(src_master)] = dst_master
        else:
            new_master = self._copy_part(src_master)
            rId = self.dst.part.relate_to(new_master, RT.SLIDE_MASTER)
            lst = self.dst.part._element.find(qn("p:sldMasterIdLst"))
            el = etree.SubElement(lst, qn("p:sldMasterId"))
            el.set("id", "2147483648")
            el.set(qn("r:id"), rId)
            self._master_sigs[sig] = new_master
            renumber_master_ids(self.dst)
        return self.memo[key]

    def import_slide(self, src_slide, position=None):
        """Copy src_slide (from any deck) to the end of the target deck. Returns the new slide."""
        src_part = src_slide.part
        same_deck = src_part.package is self.pkg
        layout_part = src_slide.slide_layout.part
        dst_layout = layout_part if same_deck else self._layout_for(layout_part)
        new = PartFactory(self.namer.new("/ppt/slides/slide.xml"), src_part.content_type, self.pkg, src_part.blob)
        slide_links = []
        for rel in src_part.rels.values():
            if rel.is_external:
                _add_rel(new, rel.rId, rel.reltype, rel.target_ref, external=True)
            elif rel.reltype == RT.SLIDE_LAYOUT:
                _add_rel(new, rel.rId, rel.reltype, dst_layout)
            elif rel.reltype in (RT.SLIDE, RT.NOTES_SLIDE):
                slide_links.append(rel.rId)
            elif same_deck:
                # media and images can be shared inside one deck; charts must be copied
                if rel.reltype == RT.CHART:
                    _add_rel(new, rel.rId, rel.reltype, self._copy_part(rel.target_part))
                else:
                    _add_rel(new, rel.rId, rel.reltype, rel.target_part)
            else:
                _add_rel(new, rel.rId, rel.reltype, self._copy_part(rel.target_part))
        if slide_links:
            _drop_slide_links(new, slide_links)
        rId = self.dst.part.relate_to(new, RT.SLIDE)
        sld_lst = self.dst.slides._sldIdLst
        ids = [int(s.get("id")) for s in sld_lst]
        el = etree.SubElement(sld_lst, qn("p:sldId"))
        el.set("id", str(max(ids + [255]) + 1))
        el.set(qn("r:id"), rId)
        slide = self.dst.slides[len(sld_lst) - 1]
        return slide


def renumber_master_ids(prs):
    """Master and layout ids must be unique across the whole file."""
    n = 2147483648
    lst = prs.part._element.find(qn("p:sldMasterIdLst"))
    for el in lst:
        el.set("id", str(n))
        n += 1
        master = prs.part.related_part(el.get(qn("r:id")))
        lay_lst = master._element.find(qn("p:sldLayoutIdLst"))
        if lay_lst is not None:
            for lel in lay_lst:
                lel.set("id", str(n))
                n += 1


def set_slide_order(prs, slides):
    """Keep only `slides`, in this order. Everything else is dropped from the deck."""
    sld_lst = prs.slides._sldIdLst
    by_part = {}
    for el in list(sld_lst):
        by_part[id(prs.part.related_part(el.get(qn("r:id"))))] = el
    keep = []
    for s in slides:
        keep.append(by_part[id(s.part)])
    keep_ids = {id(e) for e in keep}
    for el in list(sld_lst):
        sld_lst.remove(el)
        if id(el) not in keep_ids:
            prs.part.drop_rel(el.get(qn("r:id")))
    for el in keep:
        sld_lst.append(el)


# ---------------------------------------------------------------- text helpers

def iter_shapes(shapes, groups=False):
    for sh in shapes:
        if sh.shape_type == 6:
            if groups:
                yield sh
            yield from iter_shapes(sh.shapes, groups)
        else:
            yield sh


def find_shape(slide, shape_id=None, name=None, text=None):
    for sh in iter_shapes(slide.shapes, groups=True):
        if shape_id is not None and sh.shape_id == shape_id:
            return sh
        if name is not None and sh.name == name:
            return sh
        if text is not None and getattr(sh, 'has_text_frame', False) and sh.has_text_frame and sh.text_frame.text.strip().startswith(text):
            return sh
    return None


def _clear_runs(p):
    for r in list(p._p):
        if r.tag in (qn("a:r"), qn("a:br"), qn("a:fld")):
            p._p.remove(r)


def set_paragraph_text(p, text):
    """Replace a paragraph's text, keeping the first run's formatting."""
    runs = p._p.findall(qn("a:r"))
    rpr = copy.deepcopy(runs[0].find(qn("a:rPr"))) if runs and runs[0].find(qn("a:rPr")) is not None else None
    _clear_runs(p)
    r = etree.SubElement(p._p, qn("a:r"))
    if rpr is not None:
        r.append(rpr)
    t = etree.SubElement(r, qn("a:t"))
    t.text = text
    end = p._p.find(qn("a:endParaRPr"))
    if end is not None:
        p._p.remove(end)
        p._p.append(end)


def set_lines(shape, lines, styles=None):
    """Fill a text shape with lines. `styles` maps a line kind to the index of a
    template paragraph in the shape (e.g. {"head": 0, "bullet": 1}); each line is
    either a string (uses the first template) or a (kind, text) tuple."""
    tf = shape.text_frame
    paras = list(tf.paragraphs)
    templates = {}
    styles = styles or {"default": 0}
    for kind, idx in styles.items():
        src = paras[min(idx, len(paras) - 1)]._p
        templates[kind] = copy.deepcopy(src)
    first_kind = next(iter(styles))
    body = tf._txBody
    for p in paras:
        body.remove(p._p)
    if not lines:
        lines = [""]
    from pptx.text.text import _Paragraph
    for line in lines:
        kind, text = (line if isinstance(line, tuple) else (first_kind, line))
        el = copy.deepcopy(templates.get(kind, templates[first_kind]))
        body.append(el)
        set_paragraph_text(_Paragraph(el, tf), text)


def replace_in_shape(shape, old, new):
    """Replace text inside runs (only where the old text sits inside one run)."""
    if not shape.has_text_frame:
        return 0
    n = 0
    for p in shape.text_frame.paragraphs:
        for r in p.runs:
            if old in r.text:
                r.text = r.text.replace(old, new)
                n += 1
    return n


def replace_everywhere(slide, old, new):
    n = 0
    for sh in iter_shapes(slide.shapes):
        n += replace_in_shape(sh, old, new)
        if sh.has_table:
            for row in sh.table.rows:
                for c in row.cells:
                    for p in c.text_frame.paragraphs:
                        for r in p.runs:
                            if old in r.text:
                                r.text = r.text.replace(old, new)
                                n += 1
    return n


def slide_text(slide):
    out = []
    for sh in iter_shapes(slide.shapes):
        if sh.has_text_frame:
            out.append(sh.text_frame.text)
        if getattr(sh, "has_table", False) and sh.has_table:
            for row in sh.table.rows:
                for c in row.cells:
                    out.append(c.text_frame.text)
    return "\n".join(out)


def delete_shape(shape):
    el = shape._element
    el.getparent().remove(el)


def clone_shape(shape, slide):
    """Copy a shape element onto `slide` (same deck, same relationships)."""
    el = copy.deepcopy(shape._element)
    slide.shapes._spTree.append(el)
    return el


def fit_picture(slide, image_path, left, top, width, height, pad=0.1):
    """Add a picture centred inside a box, keeping its aspect ratio."""
    from PIL import Image
    with Image.open(image_path) as im:
        w, h = im.size
    bw, bh = width * (1 - 2 * pad), height * (1 - 2 * pad)
    scale = min(bw / w, bh / h)
    pw, ph = int(w * scale), int(h * scale)
    return slide.shapes.add_picture(image_path, int(left + (width - pw) / 2), int(top + (height - ph) / 2), pw, ph)


def scale_font(shape, factor):
    """Shrink every run in a shape by `factor` (used when content is longer than the template box)."""
    for p in shape.text_frame.paragraphs:
        for r in p.runs:
            if r.font.size:
                r.font.size = int(r.font.size * factor)
        end = p._p.find(qn("a:endParaRPr"))
        if end is not None and end.get("sz"):
            end.set("sz", str(int(int(end.get("sz")) * factor)))
```

### `engine/review.py`

```python
"""Review notes: what the consultant must check before sending, plus automatic QA checks
based on mistakes found in past proposals."""
import re

from .pptx_ops import slide_text

# Names from past proposals that must never appear in another client's generated slides
OTHER_CLIENTS = ["KFH", "Kuwait Finance House", "Neoleap", "NHC", "Tatweer", "THC", "Vision Bank", "anb", "SABIC",
                 "Wataniya", "Horizon Scope", "MIM", "Futtaim", "Msheireb", "Cigna", "DEWA", "GOSI", "Alfa",
                 "Sohar Port", "Ministry of Culture", "CDF", "NUPCO", "SAB"]
LEFTOVERS = [r"\bXXX?\b", r"\[client", r"\[replace", r"FIVE-STEP", r"Lorem", r"<CLIENT>", r"\bTBD\b"]


class Notes:
    ORDER = ["Inputs", "RFP coverage", "Conflicts", "To complete", "To confirm", "QA checks"]

    def __init__(self):
        self.items = {k: [] for k in self.ORDER}

    def add(self, section, text):
        if text not in self.items.setdefault(section, []):
            self.items[section].append(text)

    def as_dict(self):
        return {k: v for k, v in self.items.items() if v}


def plan_notes(notes, plan, form, allowed_numbers):
    if not plan["ai_used"]:
        if form.get("has_documents"):
            notes.add("Inputs", "The RFP / Q&A were not analysed because no Claude API key is set up. The deck uses New Metrics' standard content; check it against the RFP by hand.")
        else:
            notes.add("Inputs", "No RFP or Q&A was uploaded. The deck uses New Metrics' standard phase content.")
    for p in plan["phases"]:
        if not p.get("from_library") and not plan["ai_used"]:
            notes.add("To complete", f"Phase '{p['name']}' is not a standard phase, so its activities are empty. Fill them in, or set up the API key so they are written from the RFP.")
    req = plan.get("requirements") or []
    for r in req:
        if r["status"] != "addressed":
            notes.add("RFP coverage", f"{r['status'].upper()}: {r['requirement']} ({r['source']})" +
                      (f" – currently in {r['addressed_in']}" if r.get("addressed_in") else ""))
    if req:
        done = sum(1 for r in req if r["status"] == "addressed")
        notes.add("RFP coverage", f"{done} of {len(req)} RFP / Q&A requirements are addressed in the plan.")
    for c in plan.get("conflicts") or []:
        notes.add("Conflicts", f"{c['topic']}: form says {c['form_value']}, documents say {c['document_value']} ({c['source']}). The deck uses the form value.")
    rw = plan.get("requested_duration_weeks") or 0
    if rw and abs(rw - plan["total_weeks"]) > (0 if plan.get("unit", "weeks") == "weeks" else 2):
        notes.add("Conflicts", f"The RFP asks for about {rw} weeks; the timeline is {plan['total']} {plan.get('unit', 'weeks')}"
                  + (f" (about {plan['total_weeks']} weeks)." if plan.get("unit") == "months" else "."))
    for f in plan.get("deliverable_sources") or []:
        notes.add("To confirm", f)
    for f in plan.get("ai_flags") or []:
        notes.add("To confirm", f)
    # numbers written by the AI that do not come from the inputs
    for p in plan["phases"]:
        for a in p["activities"]:
            for txt in [a["title"], a["filler_title"], a["filler_takeaway"]] + a["steps"]:
                for n in re.findall(r"\d[\d,\.]*", txt):
                    if n.rstrip(".,") not in allowed_numbers and n not in ("1", "2", "3"):
                        notes.add("To confirm", f"Number '{n}' in \"{txt[:80]}\" is not in the form, RFP or Q&A. Check it.")
    notes.add("To confirm", "Team allocation on the governance slide (PM, consultants, SME %) is the template default. Adjust it to the real team.")
    notes.add("To complete", "Filler slides are text drafts in the brand layout. Replace or enrich them with visuals from the slide library where useful.")


def qa_scan(notes, builder, client):
    others = [n for n in OTHER_CLIENTS if n.lower() not in client.lower() and client.lower() not in n.lower()]
    for i, s in enumerate(builder.prs.slides, 1):
        if not any(s.part is g.part for g in builder.generated):
            continue
        text = slide_text(s)
        for pat in LEFTOVERS:
            if re.search(pat, text, re.I if pat != r"\bTBD\b" else 0):
                notes.add("QA checks", f"Slide {i}: leftover template text matching '{pat.strip(chr(92) + 'b')}'.")
        for n in others:
            if re.search(rf"\b{re.escape(n)}\b", text):
                notes.add("QA checks", f"Slide {i}: mentions '{n}', a name from another proposal.")
    if not notes.items["QA checks"]:
        notes.add("QA checks", "No leftover template text or other-client names found on the generated slides.")


def write_docx(notes, path, title):
    import docx
    d = docx.Document()
    d.add_heading(f"Review notes – {title}", level=1)
    for section, items in notes.as_dict().items():
        d.add_heading(section, level=2)
        for it in items:
            d.add_paragraph(it, style="List Bullet")
    d.save(path)
```

### `engine/inputs.py`

```python
"""Read the text out of an uploaded RFP or scoping Q&A (PDF, Word, Excel or text)."""
import os
import re


def read_document(path):
    """Returns (text, notes). Notes are things the review notes should mention."""
    notes = []
    ext = os.path.splitext(path)[1].lower()
    try:
        if ext == ".pdf":
            text = _pdf(path)
            if len(text.strip()) < 200:
                notes.append(f"{os.path.basename(path)} has almost no readable text (it may be scanned images). Its requirements could not be checked.")
        elif ext == ".docx":
            text = _docx(path)
        elif ext in (".xlsx", ".xlsm"):
            text, dropped = _xlsx(path)
            if dropped:
                notes.append(f"{dropped} row(s) in {os.path.basename(path)} mention passwords or usernames and were left out of the analysis.")
        elif ext in (".txt", ".md", ".csv"):
            with open(path, encoding="utf-8", errors="ignore") as f:
                text = f.read()
        else:
            return "", [f"{os.path.basename(path)}: file type {ext} is not supported. Upload PDF, Word, Excel or text."]
    except Exception as e:  # a broken upload should not stop the proposal
        return "", [f"{os.path.basename(path)} could not be read ({e})."]
    return text, notes


def _pdf(path):
    import pdfplumber
    parts = []
    with pdfplumber.open(path) as pdf:
        for i, page in enumerate(pdf.pages, 1):
            parts.append(f"[page {i}]\n" + (page.extract_text() or ""))
    return "\n".join(parts)


def _docx(path):
    import docx
    d = docx.Document(path)
    parts = [p.text for p in d.paragraphs if p.text.strip()]
    for t in d.tables:
        for row in t.rows:
            cells = []
            for c in row.cells:
                if c.text.strip() and (not cells or cells[-1] != c.text.strip()):
                    cells.append(c.text.strip())
            if cells:
                parts.append(" | ".join(cells))
    return "\n".join(parts)


SECRET = re.compile(r"pass(word)?|user ?name|login|credential", re.I)


def _xlsx(path):
    import openpyxl
    wb = openpyxl.load_workbook(path, data_only=True, read_only=True)
    parts, dropped = [], 0
    for ws in wb.worksheets:
        parts.append(f"[sheet {ws.title}]")
        for row in ws.iter_rows(values_only=True):
            cells = [str(c).strip() for c in row if c is not None and str(c).strip()]
            if not cells:
                continue
            line = " | ".join(cells)
            if SECRET.search(line):
                dropped += 1
                continue
            parts.append(line)
    return "\n".join(parts), dropped
```

### `engine/images.py`

```python
"""Turns an uploaded logo in any common image format into a PNG the deck can use."""
import io

from PIL import Image

try:                     # iPhone photos (HEIC / HEIF)
    import pillow_heif
    pillow_heif.register_heif_opener()
except ImportError:
    pass


def _is_svg(data, filename):
    if filename.lower().endswith((".svg", ".svgz")):
        return True
    head = data[:2000].lstrip().lower()
    return head.startswith(b"<?xml") and b"<svg" in head or head.startswith(b"<svg")


def to_png(data, filename, out_path):
    """Save the image as PNG at out_path. Raises ValueError with a message for the consultant."""
    if _is_svg(data, filename):
        import gzip
        import resvg_py
        if data[:2] == b"\x1f\x8b":
            data = gzip.decompress(data)
        try:
            data = bytes(resvg_py.svg_to_bytes(svg_string=data.decode("utf-8", errors="ignore"), width=1200))
        except Exception:
            raise ValueError("The SVG logo could not be read. Export it as PNG or JPG and upload that instead.")
    try:
        im = Image.open(io.BytesIO(data))
        im.seek(0)                       # first frame of a GIF / multi-page file
        im.convert("RGBA").save(out_path, "PNG")
    except Exception:
        raise ValueError(f"'{filename}' is not an image the tool can read. Upload the logo as PNG, JPG or SVG.")
```

### `engine/__init__.py`

_(empty file; marks `engine` as a Python package)_

### `templates/index.html`

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Proposal Builder</title>
<link rel="icon" type="image/svg+xml" href="{{ url_for('static', filename='favicon.svg') }}">
<link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
<header class="top">
  <img class="brand" src="{{ url_for('static', filename='nm_logo.png') }}" alt="New Metrics">
  <div class="top-title">Technical Proposal Builder</div>
  <div class="ai {{ 'on' if ai else 'off' }}" title="{{ 'RFP and Q&A are analysed with Claude' if ai else 'No Claude API key found: the deck uses standard content and RFPs are not analysed' }}">
    RFP analysis: {{ 'on' if ai else 'off' }}
  </div>
  {% if login %}<a class="ai" href="{{ url_for('logout') }}">Sign out</a>{% endif %}
</header>

<main>
<form id="f" enctype="multipart/form-data">

<section class="card">
  <h2><span class="num">1</span> Client</h2>
  <div class="grid2">
    <label><span>Language <em>required</em></span>
      <select name="language">
        <option value="EN" selected>English</option>
        <option value="AR" disabled>Arabic (coming later)</option>
      </select>
    </label>
    <label><span>Client name <em>required</em></span>
      <input name="client_name" id="client_name" required placeholder="As the client writes it in the RFP">
    </label>
    <label><span>Industry</span>
      <select name="industry_section" id="industry">
        {% for code, (name, _) in industries.items() %}
        <option value="{{ code }}" {{ 'selected' if code == '06' }}>{{ name }}</option>
        {% endfor %}
        <option value="other">Other</option>
      </select>
      <input name="industry_other" id="industry_other" placeholder="Type the client's industry" hidden>
      <small>Used to pick client references and the Medallia topic set.</small>
    </label>
    <div class="logo-box">
      <span class="lbl">Client logo</span>
      <input type="file" name="logo" id="logo" accept="image/*,.svg,.heic,.heif">
      <small class="hint-inline">Any image file: PNG, JPG, SVG, WebP, GIF, HEIC…</small>
      <span class="kept" id="kept_logo" hidden>Kept from last time: <b></b>. Upload a new file to replace it, or
        <label class="check inline"><input type="checkbox" name="drop_logo"> remove it</label></span>
    </div>
  </div>
</section>

<section class="card">
  <h2><span class="num">2</span> Project</h2>
  <label><span>Project title <em>required</em></span>
    <input name="project_title" required placeholder="The RFP name, e.g. Voice of Customer Platform">
  </label>
  <label><span>Project details and description <span class="opt">optional</span></span>
    <textarea name="description" rows="4" placeholder="What the client wants, scope, systems, anything agreed in scoping. This drives the objectives and key activities."></textarea>
  </label>
  <div class="narrow">
    <label><span>Program type <em>required</em></span>
      <select name="program_type" id="program_type">
        {% for p in program_types %}<option value="{{ p.key }}">{{ p.label }}</option>{% endfor %}
      </select>
    </label>
    <label id="program_other_box" hidden><span>What type of program is it?</span>
      <input name="program_other" id="program_other" placeholder="e.g. Voice of Patient program">
    </label>
  </div>
</section>

<section class="card">
  <h2><span class="num">3</span> RFP and scoping Q&amp;A <span class="opt">optional</span></h2>
  <div class="grid2">
    <div>
    <label><span>RFP document</span>
      <input type="file" name="rfp" accept=".pdf,.docx,.txt">
    </label>
    <span class="kept" id="kept_rfp" hidden>Kept from last time: <b></b>. Upload a new file to replace it, or
        <label class="check inline"><input type="checkbox" name="drop_rfp"> remove it</label></span>
    </div>
    <div>
    <label><span>Scoping questions and answers</span>
      <input type="file" name="qa" accept=".xlsx,.docx,.pdf,.txt">
    </label>
    <span class="kept" id="kept_qa" hidden>Kept from last time: <b></b>. Upload a new file to replace it, or
        <label class="check inline"><input type="checkbox" name="drop_qa"> remove it</label></span>
    </div>
  </div>
  {% if not ai %}<p class="warn">RFP analysis is off because no Claude API key is set up. The files are kept with the job but not analysed. See README.</p>{% endif %}
</section>

<section class="card">
  <h2><span class="num">4</span> Deliverables <span class="opt">optional</span></h2>
  <label class="check auto"><input type="checkbox" name="auto_deliverables" id="auto_deliverables">
    Rely on RFP &amp; Scoping Q&amp;As to automatically extract the deliverables and requirements</label>
  <p class="hint">Every box is optional. Numbers appear in brackets on the slides, e.g. "Surveys (8)".
    Leave a box blank if you don't know it, or put 0 if it is not in scope. A number you type always wins over the documents.</p>
  <div class="deliv">
    {% for x in defaults.deliverables %}
    <div class="dfield"><label><span>{{ x.label }}</span>
      <input type="number" min="0" name="d_{{ x.key }}" id="d_{{ x.key }}"></label>
      {% if x.key == 'trainings' %}<label class="check std"><input type="checkbox" id="std_trainings" name="std_trainings">
        Follow regular # of Medallia training program sessions</label>{% endif %}
    </div>
    {% endfor %}
  </div>
  <label class="extra"><span>Additional deliverables to consider <span class="opt">optional</span></span>
    <textarea name="extra_deliverables" rows="4" placeholder="Describe any other deliverables the client needs that are not listed above, e.g. a CX maturity assessment, an executive dashboard, a journey mapping workshop…"></textarea>
  </label>
  {% for key, n in defaults.named_deliverables.items() %}
  <div class="names" id="names_{{ key }}" data-key="{{ key }}" data-one="{{ n.one }}" hidden>
    <h3>{{ n.title }} <small>({{ n.hint }})</small></h3>
    <div class="deliv boxes"></div>
    <label class="check"><input type="checkbox" name="undecided_{{ key }}" class="undecided"> Not decided yet</label>
  </div>
  {% endfor %}
</section>

<section class="card">
  <h2><span class="num">5</span> Timeline</h2>
  <div class="unit-switch">
    <span>Plan the timeline in</span>
    <label class="chip"><input type="radio" name="timeline_unit" value="weeks" checked> Weeks (W0, W1, W2…)</label>
    <label class="chip"><input type="radio" name="timeline_unit" value="months"> Months (M0, M1, M2…)</label>
  </div>
  <p class="hint">Phases run one after the other, starting at 0. Rename phases if the RFP uses its own names (up to 10).</p>
  <div id="phases"></div>
  <button type="button" id="add_phase" class="btn ghost small">+ Add phase</button>
  <div id="gantt"></div>
</section>

<section class="card">
  <h2><span class="num">6</span> References and team</h2>
  <h3 class="first">Client references <small>(matching the program type; same industry first, then closest)</small></h3>
  <label class="check all"><input type="checkbox" id="refs_all"> Select all</label>
  <div id="refs" class="refs"></div>
  <h3>Team <small>(shown in the deck in this order)</small></h3>
  <label class="check all"><input type="checkbox" id="team_all"> Select all</label>
  <div class="chips">
    {% for t in team %}
    <label class="chip"><input type="checkbox" name="team" value="{{ t.id }}" {{ 'checked' if t.on }}> {{ t.name }}</label>
    {% endfor %}
  </div>
</section>

<div class="actions">
  <div id="errors" class="errors" hidden></div>
  <button type="submit" class="btn primary" id="go">Build proposal</button>
</div>
</form>
</main>

<div id="busy" hidden>
  <div class="busy-box">
    <div class="spinner"></div>
    <p id="busy_msg">Building the deck…</p>
    <small>{{ 'Reading the RFP and Q&A with Claude can take a few minutes.' if ai else 'This takes under a minute.' }}</small>
  </div>
</div>

<script>window.EDIT_JOB = {{ edit|tojson }};
window.DEFAULT_PHASES = {{ phases|tojson }};
window.STD_TRAININGS = {{ defaults.standard_trainings|tojson }};
window.TOPIC_NAMES = {{ defaults.industry_topic_names|tojson }};</script>
<script src="{{ url_for('static', filename='app.js') }}"></script>
</body>
</html>
```

### `templates/result.html`

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Proposal Ready</title>
<link rel="icon" type="image/svg+xml" href="{{ url_for('static', filename='favicon.svg') }}">
<link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
<header class="top">
  <img class="brand" src="{{ url_for('static', filename='nm_logo.png') }}" alt="New Metrics">
  <div class="top-title">Technical Proposal Builder</div>
  <a class="ai on" href="{{ url_for('index') }}">New proposal</a>
</header>
<main>
<section class="card done">
  <h2>{{ r.client }} – {{ r.title }}</h2>
  <p>{{ r.slides }} slides, {{ r.plan.total or r.plan.total_weeks }} {{ r.plan.unit or 'weeks' }}, {{ r.plan.phases|length }} phases.
     {{ 'Content tailored to the RFP / Q&A with Claude.' if r.ai_used else 'Built from New Metrics standard content.' }}</p>
  <div class="dl">
    <a class="btn primary" href="{{ url_for('download', job=job, name=r.stem + '.pptx') }}">Download proposal (.pptx)</a>
    <a class="btn ghost" href="{{ url_for('download', job=job, name=r.stem + '_Review_Notes.docx') }}">Download review notes (.docx)</a>
    <a class="btn ghost" href="{{ url_for('index', edit=job) }}">Edit proposal requirements</a>
  </div>
</section>

<section class="card">
  <h2>Review notes</h2>
  <p class="hint">Check these before the deck goes to the client.</p>
  {% for section, items in r.notes.items() %}
  <h3>{{ section }}</h3>
  <ul class="notes">{% for it in items %}<li>{{ it }}</li>{% endfor %}</ul>
  {% endfor %}
</section>

<section class="card">
  <h2>What went into the deck</h2>
  {% for p in r.plan.phases %}
  <h3>Phase {{ loop.index }}: {{ p.name }} <small>{{ 'M' if r.plan.unit == 'months' else 'W' }}{{ p.start }}–{{ 'M' if r.plan.unit == 'months' else 'W' }}{{ p.end }}</small></h3>
  <ul class="notes">
    {% for a in p.activities %}<li><b>{{ a.letter }}.</b> {{ a.title }}</li>{% endfor %}
  </ul>
  <p class="hint">Deliverables: {{ p.deliverable_lines|join(', ') }}</p>
  {% endfor %}
</section>
</main>
</body>
</html>
```

### `templates/login.html`

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Sign in – Proposal Builder</title>
<link rel="icon" type="image/svg+xml" href="{{ url_for('static', filename='favicon.svg') }}">
<link rel="stylesheet" href="{{ url_for('static', filename='style.css') }}">
</head>
<body>
<header class="top">
  <img class="brand" src="{{ url_for('static', filename='nm_logo.png') }}" alt="New Metrics">
  <div class="top-title">Technical Proposal Builder</div>
</header>
<main class="login">
<form class="card" method="post">
  <h2>Sign in</h2>
  {% if error %}<div class="errors">{{ error }}</div>{% endif %}
  <label><span>Username</span><input name="username" autocomplete="username" required autofocus></label>
  <label><span>Password</span><input name="password" type="password" autocomplete="current-password" required></label>
  <button class="btn primary" type="submit">Sign in</button>
</form>
</main>
</body>
</html>
```

### `static/app.js`

```javascript
// Intake form: timeline maker with live Gantt, references list, submit.
const $ = (s, el = document) => el.querySelector(s);
const phasesEl = $("#phases");
const DEFAULT_WEEKS = [6, 10, 4];
const unit = () => document.querySelector("[name=timeline_unit]:checked").value;
const unitName = () => unit();
const letter = () => unit() === "months" ? "M" : "W";

function phaseRow(name, weeks) {
  const row = document.createElement("div");
  row.className = "phase";
  row.innerHTML = `<span class="pnum"></span>
    <input name="phase_name" value="${name}" required>
    <input name="phase_weeks" type="number" min="1" max="104" value="${weeks}" required> <span class="unit">${unitName()}</span>
    <button type="button" class="x" title="Remove">×</button>`;
  $(".x", row).onclick = () => { if (phasesEl.children.length > 1) { row.remove(); renderGantt(); } };
  row.querySelectorAll("input").forEach(i => i.addEventListener("input", renderGantt));
  phasesEl.appendChild(row);
}

window.DEFAULT_PHASES.forEach((n, i) => phaseRow(n, DEFAULT_WEEKS[i] || 4));
$("#add_phase").onclick = () => {
  if (phasesEl.children.length >= 10) return;
  phaseRow("New phase", unit() === "months" ? 1 : 4); renderGantt();

};

function renderGantt() {
  const rows = [...phasesEl.children].map(r => ({
    name: r.querySelector("[name=phase_name]").value,
    weeks: Math.max(1, parseInt(r.querySelector("[name=phase_weeks]").value || "0", 10) || 0)
  }));
  rows.forEach((r, i) => phasesEl.children[i].querySelector(".pnum").textContent = i + 1);
  const total = rows.reduce((a, r) => a + r.weeks, 0);
  const months = Math.round(total / 4.33);
  const L = letter();
  const about = unit() === "weeks" ? (total >= 8 ? ` (about ${months} months)` : "") : ` (about ${Math.round(total * 4.33)} weeks)`;
  let start = 0, html = `<div class="g-total">Total: <b>${total} ${unit()}</b>${about}, ${L}0 to ${L}${total - 1}</div>`;
  html += `<div class="g-grid" style="--cols:${total}">`;
  html += `<div class="g-label"></div>` + Array.from({length: total}, (_, w) => `<div class="g-h">${L}${w}</div>`).join("");
  rows.forEach((r, i) => {
    html += `<div class="g-label">${i + 1}. ${r.name}</div>`;
    for (let w = 0; w < total; w++) {
      const on = w >= start && w < start + r.weeks;
      html += `<div class="g-c ${on ? "on c" + (i % 5) : ""}"></div>`;
    }
    start += r.weeks;
  });
  $("#gantt").innerHTML = html + "</div>";
}
renderGantt();

// switching between weeks and months converts the durations already typed
document.querySelectorAll("[name=timeline_unit]").forEach(rb => rb.onchange = () => {
  phasesEl.querySelectorAll("[name=phase_weeks]").forEach(i => {
    const v = parseInt(i.value || "0", 10) || 1;
    i.value = unit() === "months" ? Math.max(1, Math.ceil(v / 4.33)) : Math.round(v * 4.33);
  });
  phasesEl.querySelectorAll(".unit").forEach(u => u.textContent = unitName());
  renderGantt();
});

// industry "Other": free text, references follow what is typed
$("#industry").onchange = () => {
  const other = $("#industry").value === "other";
  $("#industry_other").hidden = !other;
  $("#industry_other").required = other;
  loadRefs();
};
let typing;
$("#industry_other").addEventListener("input", () => { clearTimeout(typing); typing = setTimeout(loadRefs, 500); });

// program type "Other": say what it is
$("#program_type").onchange = () => {
  const other = $("#program_type").value === "other";
  $("#program_other_box").hidden = !other;
  $("#program_other").required = other;
  loadRefs();
};

// one name box per item (surveys, channels, integrations, roles, text analytics, trainings), plus "Not decided yet"
const esc = v => (v || "").replace(/&/g, "&amp;").replace(/"/g, "&quot;");
const count = key => Math.min(50, Math.max(0, parseInt(($("#d_" + key) || {}).value || "0", 10) || 0));
let topicEdited = false;
function topicName() {
  const sec = $("#industry").value;
  const ind = sec === "other" ? $("#industry_other").value.trim() : (window.TOPIC_NAMES[sec] || "");
  return ind ? ind + " topic set" : "Industry topic set";
}
function nameBoxes(key) {
  const block = $("#names_" + key);
  if (!block) return;
  const n = count(key), box = block.querySelector(".boxes");
  const kept = [...box.querySelectorAll("input")].map(i => i.value);
  if (key === "ta" && n && !topicEdited) kept[0] = topicName();
  box.innerHTML = Array.from({length: n}, (_, i) =>
    `<label><span>${block.dataset.one} ${i + 1}</span><input name="name_${key}" value="${esc(kept[i])}"></label>`).join("");
  block.hidden = n === 0;
  if (key === "ta" && n) box.querySelector("input").addEventListener("input", () => { topicEdited = true; });
}
document.querySelectorAll(".names").forEach(block => {
  const key = block.dataset.key;
  $("#d_" + key).addEventListener("input", () => {
    if (key === "trainings" && count(key) !== window.STD_TRAININGS.length) $("#std_trainings").checked = false;
    nameBoxes(key);
  });
  nameBoxes(key);
});
// the industry drives the first text analytics package name
function refreshTopic() { if (!topicEdited) nameBoxes("ta"); }
$("#industry").addEventListener("change", refreshTopic);
$("#industry_other").addEventListener("input", refreshTopic);
// the regular Medallia training program
$("#std_trainings").onchange = () => {
  const box = $("#names_trainings .boxes");
  if ($("#std_trainings").checked) {
    $("#d_trainings").value = window.STD_TRAININGS.length;
    nameBoxes("trainings");
    box.querySelectorAll("input").forEach((inp, i) => { inp.value = window.STD_TRAININGS[i]; });
  }
};

// references
let refsCall = 0;
async function loadRefs() {
  const call = ++refsCall;
  const sec = $("#industry").value;
  const r = await fetch("/api/references?section=" + sec + "&program=" + $("#program_type").value +
                        "&text=" + encodeURIComponent(sec === "other" ? $("#industry_other").value : ""));
  const refs = await r.json();
  if (call !== refsCall) return false;  // a newer request is on its way
  let html = "", cur = null;
  refs.forEach(x => {
    if (x.section !== cur) { cur = x.section; html += `<div class="ref-sec">${x.industry_name}</div>`; }
    html += `<label class="ref"><input type="checkbox" name="references" value="${x.id}" ${x.picked ? "checked" : ""}>
      <b>${x.client}</b> <span>${x.project || ""}</span>${x.voc ? ' <i class="tag">VoC</i>' : ""}</label>`;
  });
  $("#refs").innerHTML = html || '<p class="hint">No case studies match this program type yet.</p>';
  $("#refs_all").checked = false;
  return true;
}
if (!window.EDIT_JOB) loadRefs();

// submit
$("#f").onsubmit = async e => {
  e.preventDefault();
  const errs = [];
  const hasDoc = k => document.querySelector(`[name=${k}]`).files.length ||
    (!$("#kept_" + k).hidden && !document.querySelector(`[name=drop_${k}]`).checked);
  if ($("#auto_deliverables").checked && !hasDoc("rfp") && !hasDoc("qa"))
    errs.push("Upload the RFP or the scoping Q&A so the tool can read the deliverables from them, or untick that option.");
  document.querySelectorAll(".names").forEach(block => {
    const key = block.dataset.key, n = count(key);
    const named = [...block.querySelectorAll(".boxes input")].filter(i => i.value.trim()).length;
    if (n && named < n && !block.querySelector(".undecided").checked)
      errs.push(`${block.querySelector("h3").firstChild.textContent.trim()}: ${n === 1 ? "fill the box" : `fill all ${n} boxes`}, or tick "Not decided yet".`);
  });
  if (errs.length) { showErrors(errs); return; }
  $("#busy").hidden = false;
  try {
    const r = await fetch("/generate", {method: "POST", body: new FormData(e.target)});
    const j = await r.json();
    if (!r.ok) { showErrors(j.errors || ["Unknown error"]); return; }
    window.location = j.url;
  } catch (err) {
    showErrors(["The server did not answer. Is the app still running? " + err]);
  } finally {
    $("#busy").hidden = true;
  }
};
function showErrors(list) {
  const el = $("#errors");
  el.innerHTML = list.map(x => `<div>${x}</div>`).join("");
  el.hidden = false;
  el.scrollIntoView({behavior: "smooth"});
}

// "Select all" for references and team
function selectAll(box, name) {
  box.onchange = () => document.querySelectorAll(`[name=${name}]`).forEach(c => c.checked = box.checked);
}
selectAll($("#refs_all"), "references");
selectAll($("#team_all"), "team");
document.addEventListener("change", e => {
  if (e.target.name === "references") $("#refs_all").checked = [...document.querySelectorAll("[name=references]")].every(c => c.checked);
  if (e.target.name === "team") $("#team_all").checked = [...document.querySelectorAll("[name=team]")].every(c => c.checked);
});


// "Edit proposal requirements": refill the form with what was used last time
async function restore(job) {
  const r = await fetch("/api/inputs/" + job);
  if (!r.ok) { loadRefs(); return; }
  const {fields, files} = await r.json();
  const one = k => (fields[k] || [""])[0];
  const form = $("#f");
  const hidden = document.createElement("input");
  hidden.type = "hidden"; hidden.name = "prev_job"; hidden.value = job;
  form.appendChild(hidden);
  // plain fields
  form.querySelectorAll("input[name], select[name], textarea[name]").forEach(el => {
    if (el.type === "file" || el.type === "hidden" || el.closest("#phases, .names, #refs") || !(el.name in fields)) return;
    if (el.type === "checkbox" || el.type === "radio") return;
    el.value = one(el.name);
  });
  // ticks (a tick missing from the saved form was unticked)
  form.querySelectorAll("input[type=checkbox][name]").forEach(el => {
    if (el.closest(".names, #refs") || el.name.startsWith("drop_") || el.name === "team") return;
    el.checked = (fields[el.name] || []).length > 0;
  });
  // timeline unit, then the phases as typed
  const u = one("timeline_unit") || "weeks";
  document.querySelector(`[name=timeline_unit][value=${u}]`).checked = true;
  const names = fields.phase_name || [], durs = fields.phase_weeks || [];
  if (names.length) {
    phasesEl.innerHTML = "";
    names.forEach((n, i) => phaseRow(n.replace(/"/g, "&quot;"), durs[i] || 1));
  }
  renderGantt();
  // industry and program "Other" boxes
  $("#industry_other").hidden = $("#industry").value !== "other";
  $("#industry_other").required = $("#industry").value === "other";
  $("#program_other_box").hidden = $("#program_type").value !== "other";
  $("#program_other").required = $("#program_type").value === "other";
  // name boxes per deliverable, filled in the saved order
  document.querySelectorAll(".names").forEach(block => {
    const key = block.dataset.key;
    nameBoxes(key);
    const saved = fields["name_" + key] || [];
    block.querySelectorAll(".boxes input").forEach((inp, i) => { inp.value = saved[i] || ""; });
    block.querySelector(".undecided").checked = (fields["undecided_" + key] || []).length > 0;
    if (key === "ta" && saved.length) topicEdited = true;
  });
  // team
  const team = new Set(fields.team || []);
  document.querySelectorAll("[name=team]").forEach(c => { c.checked = team.has(c.value); });
  $("#team_all").checked = [...document.querySelectorAll("[name=team]")].every(c => c.checked);
  // files kept from last time
  Object.entries(files || {}).forEach(([k, m]) => {
    const el = $("#kept_" + k);
    if (el) { el.querySelector("b").textContent = m.name; el.hidden = false; }
  });
  // references: load the list for this industry and program, then tick the saved ones
  const refs = new Set(fields.references || []);
  if (await loadRefs()) {
    document.querySelectorAll("[name=references]").forEach(c => { c.checked = refs.has(c.value); });
    $("#refs_all").checked = [...document.querySelectorAll("[name=references]")].every(c => c.checked);
  }
  const note = document.createElement("p");
  note.className = "editing";
  note.textContent = "You are editing the requirements of your last proposal. Change what you need, then click Build proposal again.";
  form.prepend(note);
}
if (window.EDIT_JOB) restore(window.EDIT_JOB);
```

### `static/style.css`

```css
:root {
  --blue: #2E6FF0; --sky: #2EC6EE; --navy: #0A3D78; --purple: #542FE5; --teal: #345E5D; --red: #DE3D3D;
  --ink: #111; --muted: #5b6474; --line: #dfe5f0; --bg: #f4f7fc; --card: #fff;
  font-family: "Geomanist", "Segoe UI", system-ui, -apple-system, Arial, sans-serif;
}
* { box-sizing: border-box; }
body { margin: 0; background: var(--bg); color: var(--ink); font-size: 15px; }
.top { display: flex; align-items: center; gap: 24px; padding: 12px 28px; color: var(--navy);
  background: #fff; border-bottom: 4px solid var(--blue); }
.brand { height: 40px; width: auto; display: block; }
.top-title { font-weight: 600; flex: 1; padding-left: 20px; border-left: 1px solid var(--line); }
.ai { font-size: 13px; padding: 5px 12px; border-radius: 20px; background: #eaf1ff; color: var(--blue); text-decoration: none; }
.ai.off { background: #f1f2f5; color: var(--muted); }
main { max-width: 980px; margin: 24px auto 80px; padding: 0 16px; }
.card { background: var(--card); border: 1px solid var(--line); border-radius: 14px; padding: 22px 26px; margin-bottom: 18px; }
h2 { margin: 0 0 14px; color: var(--blue); font-size: 18px; text-transform: uppercase; letter-spacing: .3px; display: flex; align-items: center; gap: 10px; }
h3 { font-size: 14px; margin: 18px 0 8px; text-transform: uppercase; color: var(--navy); }
h3 small, .opt { font-weight: 400; text-transform: none; color: var(--muted); font-size: 13px; }
.num { background: var(--blue); color: #fff; width: 26px; height: 26px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; font-size: 14px; }
label { display: flex; flex-direction: column; gap: 5px; font-weight: 600; font-size: 14px; margin-bottom: 14px; }
label em { font-style: normal; font-weight: 400; color: var(--red); font-size: 12px; }
label small, .hint { font-weight: 400; color: var(--muted); font-size: 13px; }
.hint { margin: -6px 0 14px; }
input, select, textarea { font: inherit; font-weight: 400; padding: 9px 11px; border: 1px solid var(--line); border-radius: 8px; background: #fff; }
input:focus, select:focus, textarea:focus { outline: 2px solid var(--blue); border-color: transparent; }
.grid2 { display: grid; grid-template-columns: 1fr 1fr; gap: 0 22px; }
.narrow { max-width: 360px; }
.logo-box { display: flex; flex-direction: column; gap: 6px; }
.logo-box .lbl { font-weight: 600; font-size: 14px; }
.check { flex-direction: row; align-items: center; gap: 8px; font-weight: 400; margin: 0; }
#logo_web { display: flex; flex-wrap: wrap; gap: 8px; align-items: center; }
#logo_web input { flex: 1; min-width: 200px; }
#logo_preview { width: 100%; display: flex; gap: 12px; align-items: center; }
#logo_preview img { max-height: 60px; max-width: 160px; border: 1px solid var(--line); border-radius: 6px; padding: 6px; background: #fff; }
.err { color: var(--red); font-size: 13px; }
.deliv { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 0 16px; }
.deliv label.req { color: var(--navy); }
.phase { display: flex; align-items: center; gap: 10px; margin-bottom: 8px; }
.phase .pnum { width: 22px; color: var(--blue); font-weight: 700; }
.phase input[name=phase_name] { flex: 1; }
.phase input[name=phase_weeks] { width: 80px; }
.x { border: 0; background: none; font-size: 22px; color: var(--muted); cursor: pointer; }
#gantt { margin-top: 14px; overflow-x: auto; }
.g-total { margin-bottom: 8px; font-size: 14px; }
.g-grid { display: grid; grid-template-columns: 200px repeat(var(--cols), minmax(16px, 1fr)); gap: 2px; font-size: 11px; }
.g-label { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; padding-right: 8px; }
.g-h { text-align: center; color: var(--muted); }
.g-c { height: 18px; background: #eef2f8; border-radius: 3px; }
.g-c.on.c0 { background: var(--blue); } .g-c.on.c1 { background: var(--purple); } .g-c.on.c2 { background: var(--teal); }
.g-c.on.c3 { background: var(--red); } .g-c.on.c4 { background: var(--sky); }
.chips { display: flex; flex-wrap: wrap; gap: 8px; }
.chip { flex-direction: row; align-items: center; gap: 6px; font-weight: 400; border: 1px solid var(--line); border-radius: 20px; padding: 6px 12px; margin: 0; cursor: pointer; }
.chip:has(input:checked) { border-color: var(--blue); background: #eaf1ff; }
.refs { max-height: 300px; overflow-y: auto; border: 1px solid var(--line); border-radius: 10px; padding: 6px 12px; }
.ref-sec { font-size: 12px; text-transform: uppercase; color: var(--muted); margin: 10px 0 4px; }
.ref { flex-direction: row; align-items: center; gap: 8px; font-weight: 400; margin: 0 0 4px; }
.ref span { color: var(--muted); }
.tag { font-style: normal; font-size: 11px; background: #eaf1ff; color: var(--blue); padding: 1px 6px; border-radius: 8px; }
.warn { background: #fff4e5; border-radius: 8px; padding: 10px 12px; font-size: 13px; }
.actions { display: flex; flex-direction: column; align-items: flex-end; gap: 10px; }
.errors { width: 100%; background: #fdecec; color: var(--red); border-radius: 10px; padding: 12px 16px; }
.btn { font: inherit; font-weight: 600; border: 0; border-radius: 10px; padding: 12px 22px; cursor: pointer; text-decoration: none; display: inline-block; }
.btn.primary { background: var(--blue); color: #fff; }
.btn.ghost { background: #eaf1ff; color: var(--blue); }
.btn.small { padding: 8px 14px; font-size: 14px; background: var(--navy); color: #fff; }
.btn.ghost.small { background: #eaf1ff; color: var(--blue); }
#busy { position: fixed; inset: 0; background: rgba(10,61,120,.55); display: flex; align-items: center; justify-content: center; }
#busy[hidden] { display: none; }
.busy-box { background: #fff; border-radius: 14px; padding: 30px 40px; text-align: center; max-width: 380px; }
.spinner { width: 42px; height: 42px; border: 4px solid #eaf1ff; border-top-color: var(--blue); border-radius: 50%; margin: 0 auto 14px; animation: spin 1s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }
.done .dl { display: flex; gap: 12px; flex-wrap: wrap; margin-top: 12px; }
.notes { margin: 0; padding-left: 20px; line-height: 1.5; }
@media (max-width: 700px) { .grid2 { grid-template-columns: 1fr; } .top { flex-wrap: wrap; } }

[hidden] { display: none !important; }
#industry_other { margin-top: 6px; }
#channel_names { margin-top: 4px; }
h3.first { margin-top: 0; }
.check.auto { font-weight: 600; background: #eaf1ff; border-radius: 8px; padding: 10px 12px; margin-bottom: 12px; }
main.login { max-width: 400px; margin-top: 80px; }
main.login .errors { margin-bottom: 14px; }
main.login .btn { width: 100%; }
.check.all { font-size: 13px; color: var(--blue); font-weight: 600; margin: 0 0 6px; }
.logo-pick { flex-direction: row; align-items: center; gap: 10px; font-weight: 400; margin: 6px 12px 0 0; cursor: pointer; }
.logo-pick small { max-width: 220px; overflow-wrap: anywhere; }
#logo_preview { flex-wrap: wrap; }
label.extra { margin-top: 6px; }
.hint-inline { font-weight: 400; color: var(--muted); font-size: 12px; }
.unit-switch { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-bottom: 10px; font-size: 14px; }
.unit { min-width: 52px; }

.check.std { font-size: 12.5px; margin: -6px 0 12px; line-height: 1.3; }
.names { margin-top: 14px; padding-top: 10px; border-top: 1px dashed #d5dbe7; }
.names h3 { margin: 0 0 8px; font-size: 15px; }
.names h3 small { font-weight: 400; color: #6b7690; }
.kept { display: block; font-size: 12.5px; color: #4a5672; margin-top: 4px; }
.check.inline { display: inline-flex; gap: 4px; font-size: 12.5px; }
.editing { background: #fff6e0; border: 1px solid #f0d58a; border-radius: 8px; padding: 10px 14px; margin: 0 0 14px; font-weight: 600; }
```

### `static/favicon.svg`

```xml
<svg xmlns="http://www.w3.org/2000/svg" width="47.847" height="47.493" viewBox="0 0 47.847 47.493" xmlns:c2pa="http://c2pa.org/manifest"><metadata><c2pa:manifest>AAAWgmp1bWIAAAAeanVtZGMycGEAEQAQgAAAqgA4m3EDYzJwYQAAABZcanVtYgAAAEdqdW1kYzJtYQARABCAAACqADibcQN1cm46YzJwYTo4ZmJjODMzNS0wZmUwLTQ2OTQtOTlhOS1hZmE2MzdhOTI1ZTQAAAADl2p1bWIAAAApanVtZGMyYXMAEQAQgAAAqgA4m3EDYzJwYS5hc3NlcnRpb25zAAAAALxqdW1iAAAARGp1bWRjYm9yABEAEIAAAKoAOJtxE2MycGEuaW5ncmVkaWVudC52MwAAAAAYYzJzaJyJkWtbmtlJc2LPS6mgGnsAAABwY2JvcqNpZGM6Zm9ybWF0bWltYWdlL3N2Zyt4bWxqaW5zdGFuY2VJRHgseG1wOmlpZDpkNTA1M2UzYi0xZTRhLTQxYWUtOTI3Zi02YmU3NzUyMDViN2RscmVsYXRpb25zaGlwaHBhcmVudE9mAAAB4mp1bWIAAABBanVtZGNib3IAEQAQgAAAqgA4m3ETYzJwYS5hY3Rpb25zLnYyAAAAABhjMnNorVS9qSmoNPOR+s8AfHOkkAAAAZljYm9yomdhY3Rpb25zgqJmYWN0aW9ua2MycGEub3BlbmVkanBhcmFtZXRlcnOha2luZ3JlZGllbnRzgaJjdXJseC1zZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmluZ3JlZGllbnQudjNkaGFzaFggV9mltY0YE7/bu+be6qvxyaJASC+X+qSngSiUNrVXb+2kZmFjdGlvbngdY29tLmFudGhyb3BpYy5jbGF1ZGUucHJvdmlkZWRqcGFyYW1ldGVyc6F4H2NvbS5hbnRocm9waWMub3JpZ2luLWNvbmZpZGVuY2VndW5rbm93bmtkZXNjcmlwdGlvbnhmQ2xhdWRlIHByb3ZpZGVkIHRoaXMgZmlsZSBhdCB0aGUgcmVxdWVzdCBvZiBhIHVzZXIgYW5kIG1heSBoYXZlIGNyZWF0ZWQgb3IgbW9kaWZpZWQgdGhlIGZpbGUgY29udGVudHMubXNvZnR3YXJlQWdlbnShZG5hbWVmQ2xhdWRlcmFsbEFjdGlvbnNJbmNsdWRlZPUAAADIanVtYgAAAEBqdW1kY2JvcgARABCAAACqADibcRNjMnBhLmhhc2guZGF0YQAAAAAYYzJzaCnIHsR/mfFcbMU+a2NtkGcAAACAY2JvcqVjYWxnZnNoYTI1NmNwYWRNAAAAAAAAAAAAAAAAAGRoYXNoWCAk0LVer6hASsFujWrhf6W8ThxaEkb3qOP6ZF/OGvUr5WRuYW1lbmp1bWJmIG1hbmlmZXN0amV4Y2x1c2lvbnOBomVzdGFydBiiZmxlbmd0aBkeBAAAAj5qdW1iAAAAJ2p1bWRjMmNsABEAEIAAAKoAOJtxA2MycGEuY2xhaW0udjIAAAACD2Nib3KlY2FsZ2ZzaGEyNTZpc2lnbmF0dXJleE1zZWxmI2p1bWJmPS9jMnBhL3VybjpjMnBhOjhmYmM4MzM1LTBmZTAtNDY5NC05OWE5LWFmYTYzN2E5MjVlNC9jMnBhLnNpZ25hdHVyZWppbnN0YW5jZUlEeCx4bXA6aWlkOmE3NzhhN2NmLTUyOGEtNDUwZS05YzY2LTUwZjEzZDY5OGRmNHJjcmVhdGVkX2Fzc2VydGlvbnODomN1cmx4LXNlbGYjanVtYmY9YzJwYS5hc3NlcnRpb25zL2MycGEuaW5ncmVkaWVudC52M2RoYXNoWCBX2aW1jRgTv9u75t7qq/HJokBIL5f6pKeBKJQ2tVdv7aJjdXJseCpzZWxmI2p1bWJmPWMycGEuYXNzZXJ0aW9ucy9jMnBhLmFjdGlvbnMudjJkaGFzaFgguvkqc1RmTkoWVcS35SRhWq7LtaiGGJjJBN9dBpon2amiY3VybHgpc2VsZiNqdW1iZj1jMnBhLmFzc2VydGlvbnMvYzJwYS5oYXNoLmRhdGFkaGFzaFgg2ddplpMH8NQ9X2JVfTnXq+G06W//873XngwUN8kcVcF0Y2xhaW1fZ2VuZXJhdG9yX2luZm+jZG5hbWVvQW50aHJvcGljIEZpbGVzZ3ZlcnNpb25lMS4wLjBrc3BlY1ZlcnNpb25lMi40LjAAABA4anVtYgAAAChqdW1kYzJjcwARABCAAACqADibcQNjMnBhLnNpZ25hdHVyZQAAABAIY2JvctKEWQISogEmGCFZAgowggIGMIIBjaADAgECAhRA5aAK7sI50L64g/oGQgU9Z1UTADAKBggqhkjOPQQDAzBJMRcwFQYDVQQKEw5BbnRocm9waWMsIFBCQzEuMCwGA1UEAxMlQW50aHJvcGljIENvbnRlbnQgQ3JlZGVudGlhbHMgUm9vdCBDQTAeFw0yNjA4MDcxODQzNTZaFw0yODA4MDYxOTQzNTZaMEQxFzAVBgNVBAoTDkFudGhyb3BpYywgUEJDMSkwJwYDVQQDEyBBbnRocm9waWMgQ2xhdWRlIENvbnRlbnQgU2lnbmluZzBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABJh6CmvLUBgFFNU0vUKlOVtE6djd17L5SuwX0LemFisBM3dkd/3cyjxFA3Qo5S46fX0/ihY0VZ7mfb9KF703t5OjWDBWMA4GA1UdDwEB/wQEAwIHgDAVBgNVHSUEDjAMBgorBgEEAYPoXgIBMAwGA1UdEwEB/wQCMAAwHwYDVR0jBBgwFoAUzlHiBIFOZFsj+OPEz5o+nMHXXMIwCgYIKoZIzj0EAwMDZwAwZAIwMXMdFJ4BetLLVY7ORuE9noqbbAZOZn/aArXyTwFAZfKrPzxF2vPoJNf1+UCdg1XGAjBwX1zd9WGqYkqmL5SFqw1QySjr1zJfpJM9+1rdDwSPLMOPOjKuiXjoU/pUUeG9RwmhY3BhZFkNngAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAPZYQOGaQVFyVC764eg1paFYNiYodqh+tdU2NBQvUnpZroC5TRo85CZLp61e4h6Xa42eEBfMlFNv9ulCHI/fQXRyltE=</c2pa:manifest></metadata><g id="Group_22283" data-name="Group 22283" transform="translate(-544.85 -565.047)"><path id="Path_14150" data-name="Path 14150" d="M302.911,2.019H287.045L273.738,49.512H285.6l6.654-23.747h4.006Z" transform="translate(271.112 563.027)" fill="#2e63f0"></path><path id="Path_14151" data-name="Path 14151" d="M305.784,49.512H321.65L334.957,2.019H323.093l-6.654,23.747h-4.006Z" transform="translate(257.74 563.027)" fill="#2e63f0"></path></g></svg>
```

### `data/defaults.json`

```json
{
 "deliverables": [
  {
   "key": "surveys",
   "label": "Surveys"
  },
  {
   "key": "channels",
   "label": "Distribution channels"
  },
  {
   "key": "integrations",
   "label": "Integrations"
  },
  {
   "key": "roles",
   "label": "Dashboard roles"
  },
  {
   "key": "ta",
   "label": "Text analytics package"
  },
  {
   "key": "clf",
   "label": "Close-the-loop form"
  },
  {
   "key": "trainings",
   "label": "Training sessions"
  },
  {
   "key": "ms_hours",
   "label": "Managed services hours"
  }
 ],
 "channels": [
  {
   "key": "email",
   "label": "Email"
  },
  {
   "key": "web_app",
   "label": "Digital feedback (web / app)"
  },
  {
   "key": "dxa",
   "label": "Digital behaviour (DXA)"
  },
  {
   "key": "messaging",
   "label": "Messaging (SMS, WhatsApp)"
  },
  {
   "key": "voice",
   "label": "Voice / speech analytics"
  },
  {
   "key": "social",
   "label": "Social and reviews"
  },
  {
   "key": "video",
   "label": "Video"
  },
  {
   "key": "feedless",
   "label": "QR codes / kiosks"
  },
  {
   "key": "telephonic",
   "label": "Telephonic (CATI, IVR)"
  },
  {
   "key": "imports",
   "label": "Imports (API / SFTP)"
  }
 ],
 "phases": [
  {
   "name": "Program Design",
   "short": "Design the survey program, architecture and dashboards with <CLIENT> stakeholders",
   "objectives": [
    "Activate the Medallia platform for <CLIENT>",
    "Translate <CLIENT>'s requirements into a signed-off program design",
    "Design surveys, integrations, dashboards and alerts before build starts"
   ],
   "activities": [
    {
     "title": "Activate the Medallia license and set up the instance",
     "steps": [
      "Activate the license and set up the <CLIENT> instance",
      "Set up environments and user access",
      "Confirm hosting and security requirements"
     ],
     "filler": {
      "title": "WE WILL ACTIVATE THE MEDALLIA LICENSE AND SET UP THE INSTANCE FOR <CLIENT>",
      "takeaway": "A ready platform from week one, so design work can start on the real environment."
     }
    },
    {
     "title": "Kick off the project and align on scope, governance and plan",
     "steps": [
      "Run the kick-off meeting with the core teams",
      "Confirm scope, timeline and success criteria",
      "Agree on governance and the communication plan"
     ],
     "filler": {
      "title": "WE WILL PREPARE THE PROJECT PLAN, DEFINE THE GOVERNANCE STRUCTURE AND ALIGN ON THE CORE TEAM FROM BOTH <CLIENT> AND NEW METRICS",
      "takeaway": "A shared plan and clear owners from the first week."
     }
    },
    {
     "title": "Gather business requirements and document them in the BRD",
     "steps": [
      "Collect current surveys, journeys and data sources",
      "Run requirement workshops with business owners",
      "Document and sign off the Medallia-adapted BRD"
     ],
     "filler": {
      "title": "WE WILL START BY COLLECTING CUSTOMER EXPERIENCE DATA FROM <CLIENT>'S STAKEHOLDERS TO UNDERSTAND THE CURRENT STATE",
      "takeaway": "Requirements are captured once, signed off, and drive every build step."
     }
    },
    {
     "title": "Design the surveys, triggers and distribution rules",
     "steps": [
      "Define the touchpoints and moments to measure",
      "Design questionnaires in English and Arabic using best-practice guidelines",
      "Set trigger points, sampling and distribution parameters"
     ],
     "needs": "surveys",
     "filler": {
      "title": "WE WILL DESIGN THE SURVEY QUESTIONNAIRES IN LINE WITH SURVEY DESIGN GUIDELINES AND BEST PRACTICES",
      "takeaway": "Short, consistent surveys that customers finish and teams can act on."
     }
    },
    {
     "title": "Design the solution architecture and integrations",
     "steps": [
      "Map <CLIENT>'s systems and data flows",
      "Define the integration method (API or SFTP) per system",
      "Agree data fields, frequency and security controls"
     ],
     "needs": "integrations",
     "filler": {
      "title": "WE WILL DESIGN THE SOLUTION ARCHITECTURE AND ENSURE MEDALLIA'S SEAMLESS INTEGRATION IN <CLIENT>'S IT LANDSCAPE",
      "takeaway": "One clear architecture that IT signs off before any build."
     }
    },
    {
     "title": "Design role-based dashboards, alerts and close-the-loop",
     "steps": [
      "Identify dashboard roles and data access rules",
      "Design alert and escalation paths aligned with <CLIENT>'s hierarchy",
      "Define close-the-loop workflows and timings"
     ],
     "needs": "roles",
     "filler": {
      "title": "WE WILL MAKE SURE THE DASHBOARDS REFLECT <CLIENT>'S ROLES AND DATA ACCESS, WITH CLEAR ALERT ESCALATION PATHS",
      "takeaway": "Every user sees what they need to act, and every alert has an owner."
     }
    }
   ],
   "deliverables": [
    {
     "label": "BRD"
    },
    {
     "key": "surveys",
     "label": "Survey designs"
    },
    {
     "label": "Solution architecture design",
     "needs": "integrations"
    },
    {
     "key": "roles",
     "label": "Dashboard and alert design (roles)"
    }
   ],
   "assumptions": [
    "<CLIENT> shares brand guidelines, existing surveys and data fields on time",
    "Stakeholders are available for workshops and sign-off",
    "Surveys are in English and Arabic"
   ],
   "prerequisites": [
    "Nominated <CLIENT> project manager and IT contact",
    "Access to relevant documentation and systems information"
   ]
  },
  {
   "name": "Program Build & Tool Activation",
   "short": "Configure, integrate and test the program on Medallia, then go live",
   "objectives": [
    "Build the approved design on Medallia",
    "Connect Medallia to <CLIENT>'s systems and channels",
    "Test with <CLIENT> and go live"
   ],
   "activities": [
    {
     "title": "Configure the surveys and brand theme",
     "steps": [
      "Build the surveys on Medallia in English and Arabic",
      "Apply <CLIENT>'s brand theme",
      "Set up triggers and distribution rules"
     ],
     "needs": "surveys",
     "filler": {
      "title": "WE WILL INITIATE THE CREATION OF SURVEYS AND THE DEVELOPMENT OF INTERACTIVE ROLE-BASED DASHBOARDS",
      "takeaway": "The approved design becomes a working program on Medallia."
     }
    },
    {
     "title": "Activate the distribution channels",
     "steps": [
      "Configure each agreed channel",
      "Test delivery and response capture per channel",
      "Confirm volumes and sampling rules"
     ],
     "needs": "channels",
     "filler": {
      "title": "WE WILL ENABLE THE RIGHT LISTENING POSTS ACROSS <CLIENT>'S CUSTOMER ENGAGEMENT CHANNELS",
      "takeaway": "Feedback is captured where customers already interact with <CLIENT>."
     }
    },
    {
     "title": "Build the integrations with <CLIENT>'s systems",
     "steps": [
      "Build the data feeds agreed in the architecture",
      "Test in development and production environments",
      "Monitor data quality after go-live"
     ],
     "needs": "integrations",
     "filler": {
      "title": "WE WILL ENSURE MEDALLIA'S SEAMLESS INTEGRATION IN <CLIENT>'S IT LANDSCAPE, ALIGNED WITH THE ARCHITECTURE DESIGNED IN PHASE 1",
      "takeaway": "Survey triggers and customer data flow automatically, with no manual uploads."
     }
    },
    {
     "title": "Build the role-based dashboards, alerts and close-the-loop",
     "steps": [
      "Configure dashboards per role",
      "Set up alerts and escalation rules",
      "Configure the close-the-loop form and workflow"
     ],
     "needs": "roles",
     "filler": {
      "title": "WE WILL BUILD AND CONFIGURE DASHBOARDS TO DELIVER INSIGHTS AND CAPABILITIES FOR ALL MEDALLIA USERS",
      "takeaway": "Real-time insight for each role, with clear follow-up on every alert."
     }
    },
    {
     "title": "Configure text analytics",
     "steps": [
      "Activate the industry topic set",
      "Tune topics and sentiment for English and native Arabic",
      "Add text analytics views to dashboards"
     ],
     "needs": "ta",
     "filler": {
      "title": "WE WILL LEVERAGE THE TEXT ANALYTICS AND AI ENGINE OF MEDALLIA IN BOTH ENGLISH AND NATIVE ARABIC TO ANALYZE CUSTOMER SENTIMENT",
      "takeaway": "Open comments become themes and sentiment that teams can act on."
     }
    },
    {
     "title": "Run SIT and UAT, then go live",
     "steps": [
      "Run system integration testing",
      "Support <CLIENT> through user acceptance testing",
      "Go live and confirm the launch checklist"
     ],
     "filler": {
      "title": "WE WILL TEST THE PROGRAM END TO END WITH <CLIENT> BEFORE GO-LIVE",
      "takeaway": "A controlled launch, signed off by <CLIENT>."
     }
    }
   ],
   "deliverables": [
    {
     "key": "surveys",
     "label": "Surveys configured"
    },
    {
     "key": "channels",
     "label": "Channels activated"
    },
    {
     "key": "integrations",
     "label": "Integrations"
    },
    {
     "key": "roles",
     "label": "Role-based dashboards"
    },
    {
     "key": "ta",
     "label": "Text analytics package"
    },
    {
     "key": "clf",
     "label": "Close-the-loop form"
    },
    {
     "label": "UAT phase"
    }
   ],
   "assumptions": [
    "Integrations are limited to the systems agreed in Phase 1",
    "Customisations Medallia does not support are out of scope",
    "<CLIENT> provides test data and testers for UAT"
   ],
   "prerequisites": [
    "Signed-off BRD and architecture",
    "Access to test and production environments",
    "Regulatory or security approvals obtained by <CLIENT> where required"
   ]
  },
  {
   "name": "Program Adoption & Scaling",
   "short": "Train users, hand over and support adoption after go-live",
   "objectives": [
    "Enable <CLIENT>'s users and administrators on Medallia",
    "Hand over the solution with full documentation",
    "Drive adoption and plan the next scaling steps"
   ],
   "activities": [
    {
     "title": "Train users and administrators",
     "steps": [
      "Run training for administrators, report users and close-the-loop users",
      "Share user guides and recordings",
      "Confirm readiness per user group"
     ],
     "needs": "trainings",
     "filler": {
      "title": "WE WILL ORGANIZE TRAINING SESSIONS TO ENSURE ALL MEDALLIA ASPECTS ARE COVERED AND STAKEHOLDERS ARE FULLY ENABLED ON THE PLATFORM",
      "takeaway": "Every user group can run and use the program on its own."
     }
    },
    {
     "title": "Hand over the solution",
     "steps": [
      "Prepare the solution handover document and Medallia guideline",
      "Walk <CLIENT>'s team through the configuration",
      "Agree support and governance after go-live"
     ],
     "filler": {
      "title": "WE WILL DEVELOP AND CREATE A SOLUTION HANDOVER DOCUMENT AND MEDALLIA GUIDELINE FOR <CLIENT>",
      "takeaway": "<CLIENT> owns the program with full documentation."
     }
    },
    {
     "title": "Support adoption after go-live",
     "steps": [
      "Track usage and response rates",
      "Resolve issues during hypercare",
      "Recommend next scaling steps"
     ],
     "filler": {
      "title": "WE WILL ENSURE MEDALLIA'S SOLUTION ADOPTION AND GOVERNANCE FOR THE <CLIENT> PROGRAM",
      "takeaway": "Adoption is measured and supported, not assumed."
     }
    },
    {
     "title": "Provide managed services support",
     "steps": [
      "Handle change requests and enhancements",
      "Maintain surveys, dashboards and integrations",
      "Report on support hours used"
     ],
     "needs": "ms_hours",
     "filler": {
      "title": "WE WILL ENSURE PLATFORM STABILITY THROUGH PROACTIVE MAINTENANCE AND PLANNED SUPPORT",
      "takeaway": "Ongoing support keeps the program running and improving."
     }
    }
   ],
   "deliverables": [
    {
     "key": "trainings",
     "label": "Training sessions"
    },
    {
     "label": "Handover document"
    },
    {
     "key": "ms_hours",
     "label": "Managed services hours"
    }
   ],
   "assumptions": [
    "Trainings are delivered online unless agreed otherwise",
    "<CLIENT> nominates trainees per user group"
   ],
   "prerequisites": [
    "Program live in production",
    "Trainee lists shared before sessions"
   ]
  }
 ],
 "seniority": [
  "Partner",
  "Principal",
  "Director",
  "Associate Director",
  "Engagement Manager",
  "Senior Manager",
  "Manager",
  "Senior Consultant",
  "Consultant",
  "Business Analyst",
  "Analyst"
 ],
 "program_types": [
  {
   "key": "voc",
   "label": "VoC (Voice of Customer)",
   "name": "VoC program"
  },
  {
   "key": "voe",
   "label": "VoE (Voice of Employee)",
   "name": "VoE program"
  },
  {
   "key": "both",
   "label": "VoC and VoE",
   "name": "VoC and VoE program"
  },
  {
   "key": "other",
   "label": "Other",
   "name": ""
  }
 ],
 "channel_keywords": {
  "email": [
   "email",
   "e-mail",
   "mail"
  ],
  "messaging": [
   "sms",
   "whatsapp",
   "messag",
   "text message",
   "chat",
   "push"
  ],
  "web_app": [
   "web",
   "website",
   "app",
   "mobile",
   "digital",
   "portal",
   "intercept",
   "online"
  ],
  "feedless": [
   "qr",
   "kiosk",
   "tablet",
   "feedless",
   "link",
   "in-store",
   "branch"
  ],
  "telephonic": [
   "ivr",
   "cati",
   "phone",
   "telephon",
   "call"
  ],
  "voice": [
   "voice",
   "speech",
   "call recording"
  ],
  "social": [
   "social",
   "review",
   "google"
  ],
  "video": [
   "video"
  ],
  "dxa": [
   "dxa",
   "behaviour",
   "behavior",
   "session replay",
   "heatmap"
  ],
  "imports": [
   "import",
   "api",
   "sftp",
   "file",
   "upload"
  ]
 },
 "named_deliverables": {
  "surveys": {
   "one": "Survey",
   "title": "Name the surveys",
   "hint": "e.g. Branch visit, Call centre, Onboarding (relational)"
  },
  "channels": {
   "one": "Channel",
   "title": "Name the distribution channels",
   "hint": "e.g. Email, SMS, WhatsApp, QR code"
  },
  "integrations": {
   "one": "Integration",
   "title": "Name the integrations",
   "hint": "e.g. CRM, core banking, contact centre"
  },
  "roles": {
   "one": "Dashboard role",
   "title": "Name the dashboard roles",
   "hint": "e.g. Admin, Executive, Branch manager"
  },
  "ta": {
   "one": "Package",
   "title": "Name the text analytics packages",
   "hint": "the first one is the client's industry topic set"
  },
  "trainings": {
   "one": "Session",
   "title": "Name the training sessions",
   "hint": "e.g. Admin concepts, Reporting, Alerts"
  }
 },
 "standard_trainings": [
  "Admin Concepts & Survey Configuration",
  "Survey Design & Survey Emails",
  "Organization",
  "Reporting (Part 1)",
  "Reporting (Part 2)",
  "Alerts",
  "Integrations",
  "Final Session"
 ],
 "industry_topic_names": {
  "01": "Government",
  "02": "Government",
  "03": "Telecommunications",
  "04": "Real Estate",
  "05": "Education",
  "06": "Banking",
  "07": "Insurance",
  "08": "Utilities",
  "09": "Retail",
  "10": "Hospitality",
  "11": "Travel & Transportation",
  "12": "Healthcare",
  "13": "Technology",
  "14": "Automotive"
 }
}
```

### `data/references_extra_EN.json`

```json
[
 {
  "deck": "thc_refs",
  "slide": 1,
  "section": "02",
  "client": "NATIONAL DEVELOPMENT FUND (NDF)",
  "project": "Beneficiary Perception and Ecosystem Market Research",
  "industry": "Development Financial Services",
  "voc": false
 },
 {
  "deck": "thc_refs",
  "slide": 2,
  "section": "03",
  "client": "OMANTEL",
  "project": "AI Capability Development Program",
  "industry": "Telecommunications",
  "voc": false
 },
 {
  "deck": "thc_refs",
  "slide": 3,
  "section": "04",
  "client": "ALDAR",
  "project": "Customer Experience Transformation",
  "industry": "Real Estate",
  "voc": false
 },
 {
  "deck": "thc_refs",
  "slide": 4,
  "section": "01",
  "client": "GASCO",
  "project": "Voice Of Customer Program",
  "industry": "Public Sector",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 1,
  "section": "06",
  "client": "FAB",
  "project": "VOC program migration and enhancement",
  "industry": "Banking",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 2,
  "section": "09",
  "client": "Tehnomanija",
  "project": "Voice of Customer Program",
  "industry": "Electronics",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 3,
  "section": "11",
  "client": "Oman Post",
  "project": "Customer Data Analysis Study",
  "industry": "Domestic Parcel Services",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 4,
  "section": "08",
  "client": "DEWA",
  "project": "Social Listening and Marketing Project",
  "industry": "Public Service Infrastructure",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 5,
  "section": "04",
  "client": "EJADAH",
  "project": "Relational Customer and supplier Experience Study",
  "industry": "Asset Management Service",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 6,
  "section": "04",
  "client": "EJADAH",
  "project": "Customer Experience Transformation",
  "industry": "Asset Management / Real Estate",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 7,
  "section": "11",
  "client": "Transom",
  "project": "Learning and development assessment",
  "industry": "Transportations",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 8,
  "section": "13",
  "client": "Electra",
  "project": "Relational Partner Experience Study",
  "industry": "Integrated Production House",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 9,
  "section": "10",
  "client": "Americana",
  "project": "Engagement Pulse Survey",
  "industry": "Operating Restaurant Chains Manufacturing Consumer Packaged Goods",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 10,
  "section": "04",
  "client": "NEPI ROCKCASTLE",
  "project": "Employee Engagement Survey",
  "industry": "Commercial Company",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 11,
  "section": "10",
  "client": "FARAH Experiences",
  "project": "Employee Engagement Survey",
  "industry": "Entertainment",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 12,
  "section": "03",
  "client": "Zain",
  "project": "Zain Kuwait B2B – VoC Design & Implementation",
  "industry": "Telecommunications",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 13,
  "section": "01",
  "client": "National Cybersecurity Authority",
  "project": "Employee Engagement Survey",
  "industry": "Public Sector",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 14,
  "section": "06",
  "client": "Bank Muscat",
  "project": "Form Optimization",
  "industry": "Banking",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 15,
  "section": "07",
  "client": "GOSI",
  "project": "Design of End-to-End Customer Journeys",
  "industry": "Insurance",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 16,
  "section": "03",
  "client": "Ooredoo Group",
  "project": "Voice of the Customer Program – nmflo middleware deployment",
  "industry": "Telecommunication",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 17,
  "section": "02",
  "client": "Saudi Industrial Development Fund",
  "project": "Employee & Customer listening program - WIP",
  "industry": "Financial",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 18,
  "section": "03",
  "client": "Omantel",
  "project": "Market Research",
  "industry": "Telecommunications",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 19,
  "section": "03",
  "client": "Omantel",
  "project": "VOC program migration and enhancement",
  "industry": "Telecommunications",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 20,
  "section": "06",
  "client": "Mashreq",
  "project": "Measuring Employee Experience through 360 feedback",
  "industry": "Banking",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 21,
  "section": "06",
  "client": "Absa Group",
  "project": "Measuring Employee Experience through 360 feedback",
  "industry": "Banking",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 22,
  "section": "06",
  "client": "National Bank of Bahrain",
  "project": "Voice of Customer Program",
  "industry": "Banking",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 23,
  "section": "06",
  "client": "BISB",
  "project": "Voice of Customer Program",
  "industry": "Banking",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 24,
  "section": "13",
  "client": "Bein/ TOD",
  "project": "Digital Experience Measurement",
  "industry": "Media",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 25,
  "section": "07",
  "client": "GOSI",
  "project": "Design of End-to-End Customer and Digital Journeys",
  "industry": "Insurance",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 26,
  "section": "07",
  "client": "Tawuniya Insurance",
  "project": "Voice of Customer, Digital Experience Analytics, Customer 360 and Voice of Employee",
  "industry": "Insurance",
  "voc": true
 },
 {
  "deck": "cases",
  "slide": 27,
  "section": "03",
  "client": "Turk Telekom",
  "project": "Digital Channel Transformation",
  "industry": "Telecoms",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 28,
  "section": "01",
  "client": "ABU DHABI Executive Office (ADEO)",
  "project": "Digital Experience Measurement",
  "industry": "Public Sector",
  "voc": false
 },
 {
  "deck": "cases",
  "slide": 29,
  "section": "01",
  "client": "National Cybersecurity Authority",
  "project": "Digital Employee transformation",
  "industry": "Public Sector",
  "voc": false
 },
 {
  "deck": "voe_cases",
  "slide": 1,
  "section": "11",
  "client": "SAUDI AIR NAVIGATION SERVICES (SANS)",
  "project": "Employee Experience Program",
  "industry": "Aviation / Air Navigation",
  "voc": false
 }
]
```

### `requirements.txt`

```text
flask>=3.0
python-pptx==1.0.2
lxml>=5.0
Pillow>=10.0
python-docx>=1.1
openpyxl>=3.1
pdfplumber>=0.11
anthropic>=2.3.0
gunicorn>=23.0
resvg-py>=0.5
pillow-heif>=1.0
```

### `Dockerfile`

```dockerfile
# Container for hosting the proposal builder online (Railway, Render, Azure, Fly.io...).
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1 PORT=8000
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN rm -rf output .venv && mkdir output
EXPOSE 8000
# One worker keeps memory low (a build needs about 500 MB); threads let several people use it.
# The long timeout covers the RFP analysis, which can take a few minutes.
CMD gunicorn app:app --bind 0.0.0.0:${PORT} --workers 1 --threads 4 --timeout 900
```

### `.dockerignore`

```text
.venv
output
__pycache__
*.pyc
```

### `.gitignore`

```text
.venv/
output/
__pycache__/
*.pyc
.env
```

### `run_windows.bat`

```bat
@echo off
REM Double-click to start the proposal builder on Windows.
REM This window must stay open while you use the app. Errors are shown here.
title Proposal Builder
cd /d "%~dp0"

REM 1. Find Python (the "py" launcher from python.org, or "python")
set PY=
py -3 --version >nul 2>&1 && set PY=py -3
if not defined PY (
  python --version >nul 2>&1 && set PY=python
)
if not defined PY (
  echo.
  echo Python was not found. Install Python 3.10 or newer from https://www.python.org/downloads/
  echo During the install, tick "Add python.exe to PATH". Then double-click this file again.
  goto :fail
)

REM 2. First run: create a private Python folder (.venv) and install the libraries
if not exist ".venv\Scripts\python.exe" (
  echo Setting up for the first time. This takes a few minutes...
  if exist .venv rmdir /s /q .venv
  %PY% -m venv .venv || goto :fail
)
REM install again whenever requirements.txt changes (new versions of the app)
fc /b requirements.txt ".venv\installed.txt" >nul 2>&1
if errorlevel 1 (
  ".venv\Scripts\python.exe" -m pip install --upgrade pip
  ".venv\Scripts\python.exe" -m pip install -r requirements.txt || goto :fail
  copy /y requirements.txt ".venv\installed.txt" >nul
)

REM 3. Start the app. It opens the browser itself once it is ready.
".venv\Scripts\python.exe" app.py
if errorlevel 1 goto :fail
goto :eof

:fail
echo.
echo ------------------------------------------------------------
echo The proposal builder could not start. The error is shown above.
echo Take a screenshot of this window and send it over.
echo ------------------------------------------------------------
pause
```

### `run_mac.command`

```bash
#!/bin/bash
# Double-click to start the proposal builder on a Mac.
# Keep this window open while you use the app. Errors are shown here.
cd "$(dirname "$0")"
fail() { echo; echo "The proposal builder could not start. The error is shown above."; read -p "Press Enter to close."; exit 1; }
command -v python3 >/dev/null || { echo "Python 3 was not found. Install it from https://www.python.org/downloads/"; fail; }
if [ ! -x .venv/bin/python ]; then
  echo "Setting up for the first time. This takes a few minutes..."
  rm -rf .venv; python3 -m venv .venv || fail
fi
# install again whenever requirements.txt changes (new versions of the app)
if ! cmp -s requirements.txt .venv/installed.txt; then
  ./.venv/bin/python -m pip install --upgrade pip
  ./.venv/bin/python -m pip install -r requirements.txt || fail
  cp requirements.txt .venv/installed.txt
fi
./.venv/bin/python app.py || fail
```

### `README.md`

```markdown
# New Metrics Technical Proposal Builder (v1, English)

A web app that turns the intake form, client logo, RFP and scoping Q&A into an on-brand
technical proposal (.pptx) plus review notes (.docx). It runs on your own computer, or online
behind a login (see "Host it online with a login" below).

## Start it

1. Install Python 3.10 or newer from python.org. On Windows, tick "Add python.exe to PATH" in the installer.
2. Double-click `run_mac.command` (Mac) or `run_windows.bat` (Windows).
   A black window opens. The first start installs the packages (a few minutes); the browser opens
   by itself once the app is ready, usually at http://127.0.0.1:5000.
3. Keep the black window open while you use the app. Closing it stops the app.

If the browser says "127.0.0.1 refused to connect", look at the black window:
- "Python was not found": install Python as in step 1, then start again.
- An error during "pip install": check the internet connection (or company proxy), delete the
  `.venv` folder next to this README, and start again.
- Any other error: send a screenshot of the window.
If the app runs on another port (the window says which), use that address.

Manual start: `pip install -r requirements.txt` then `python app.py`.

## RFP analysis with Claude (optional but recommended)

Without a key the app still builds the full deck from New Metrics' standard content, using the
numbers from the form. With a key it also reads the RFP and Q&A, rewrites the objectives,
activities, assumptions and filler slide titles in the client's terms, checks every RFP
requirement, and lists gaps and conflicts in the review notes.

Set the key before starting:
- Mac: `export ANTHROPIC_API_KEY=sk-ant-...` in the terminal, then `python app.py`
- Windows: `set ANTHROPIC_API_KEY=sk-ant-...` then `python app.py`

The header shows "RFP analysis: on" when a key is found. The AI never sets quantities: every
number comes from the form, and any number in AI text that is not in the form, RFP or Q&A is
flagged in the review notes. When "Rely on RFP & Scoping Q&As" is ticked, numbers the documents
state are used for the boxes left blank, and each one is listed with its source in the review notes.
The client logo is uploaded as any image file (PNG, JPG, SVG, WebP, GIF, HEIC...); it is converted to PNG for the deck.

## What the deck contains

Cover (client logo, RFP name, date) -> table of contents -> About Us -> About Medallia (client logo
on the email example; the named distribution channels and any channels in the RFP / Q&A are lit, the rest greyed) -> Executive Summary (understanding
slide when an RFP is analysed, quantified phases, framing per phase, timeline, governance) ->
Project Approach (unquantified phases, then per phase its framing slide(s) and one filler slide
per key activity) -> Project Plan & Governance -> Client References (same industry first) -> Our
Team (in the order listed on the form) -> closing.

## Updating the library

- `source_decks/` holds the 2026 template, About Medallia and Client References decks, plus
  `Case Studies [EN].pptx` (case studies from the New Branding Case Studies deck that were not in
  Client References) and `THC Team and References [EN].pptx` (team profiles and the new case studies
  from the THC proposal) and `VoE Case Studies [EN].pptx` (the VoE case study not found elsewhere).
  The form lists only the case studies that match the program type (VoC, VoE, both, other);
  corrections to titles and types are at the top of `engine/library.py`. Replace the Client References deck with a newer version under the same
  name and its list rebuilds itself; the two added decks are listed in `data/references_extra_EN.json`.
- The team list and its order are at the top of `app.py` (TEAM).
- `data/defaults.json` holds the standard phases, activities, filler titles, assumptions and
  deliverables. Edit wording there.
- `library/` holds the rules and knowledge files used as context for the AI step.
- Generated decks are saved in `output/`.

## Known limits (v1)

- English only; Arabic is next.
- Filler slides are clean text drafts in the brand layout, not the visual slides from past
  proposals. Review notes remind you to enrich them.
- Up to 10 phases (the phase overview splits over two slides above 5). Timelines over 30 weeks (or months) are shown with 2 units per column.

## Host it online with a login

The app can run as a private website: people open a link and sign in, with nothing to install.

- `Dockerfile` runs the app on any host that accepts Docker (Railway, Render, Azure, Fly.io).
  Give it at least 1 GB of memory; one proposal build uses about 500 MB.
- Set these variables (secrets) on the host. The login page only appears when they are set:
  - `APP_USERNAME` and `APP_PASSWORD`: the shared sign-in.
  - `SECRET_KEY`: any long random text (keeps people signed in across restarts).
  - `ANTHROPIC_API_KEY`: optional, turns on RFP analysis for everyone.
- Generated decks are kept on the server only until it restarts, so download them straight away.

Example with Railway: put this folder in a private GitHub repository, then on railway.app choose
New Project > Deploy from GitHub repo, add the variables above under Variables, and under
Settings > Networking choose Generate Domain. That link is the website.

Running it on your own computer still works as before (no login there).
```

### `library/RULES.md`

```markdown
# Proposal library rules (from Aya, 26 Oct 2026)

## Design
- Design follows ONLY the new 2026 brand templates:
  - 20250107_NM_Technical Proposal Template 2026 [EN]-vf.pptx
  - 20260122_NM_Technical Proposal Template 2026 [AR]-vf.pptx
  - About Medallia (EN / AR) and Client References (EN / AR) decks
- Older proposals made with the old brand guidelines are used for content and slide logic only
  (wording, structure, filler slides, how RFP asks became slides). Never copy their design.

## What to ignore
- Commercial documents (pricing, financial proposals, payment or legal terms) are not used and not catalogued.

## Scope
- English first, Arabic later.
- Past proposals are examples to learn from. Never copy one client's content into another client's deck.

## Brand guidelines (from "Brand Guidelines - Presentation 2.pptx", added 27 Oct 2026)
Visual rules for every generated slide:
- Always use the approved 2026 slide templates, fonts and colours. Keep layouts minimal and clean, with no crowding or excessive layering.
- Fonts:
  - English: Geomanist. Headlines in Bold or Extra Bold, all caps or title case. Sub-headings in Medium or Semi-Bold. Body in Regular or Light. No heavy bold in paragraphs.
  - Arabic: GE SS Two. Headlines in Bold, body in Light.
  - Generated text must never fall back to Arial or Calibri.
- Colours:
  - Primary: Royal Blue (#2E6FF0) for headings in bold capitals; Black for sub-headings and body text.
  - Deck secondary, for charts and infographics: Vivid Sky Blue #2EC6EE (highlights), Dark Cerulean #0A3D78 (process steps), Han Purple #542FE5 (neutral insights / first bar), Police Blue #345E5D (strong segments), Steel Teal #4F9392 (secondary bar), Poppy Red #DE3D3D (key metrics).
  - Use at most 3-4 colours per chart, keep the same colour mapping for a metric across the deck, and use only the approved gradients.
  - Status colours (error, warning, success, info) are for their meaning only, never decoration.
  - Hex values were read from the guideline file's shapes and theme; confirm with marketing if exact codes matter.
- Logo: use only the approved versions (primary, or inverted on gradient or colour backgrounds) and keep the clear zone around it. Never recolour, stretch, rotate, outline, blur, add effects to, or alter the bolt.
- Icons: use the brand icon pack. With more than 10 icons in a deck, use black or white. Coloured icons must all come from the same pack.
- Content slides: section title, plus a one-sentence takeaway of at most 2 lines as the subtitle, telling the slide's part of the story.
- Footer: "| © COPYRIGHTS RESERVED <current year>". Update the year automatically.

Writing rules for generated text:
- Use the approved New Metrics description (template "Who we are") in every proposal. Never improvise a different one.
- Present New Metrics as broader than CX or tech, and as doing both strategy and implementation.
- Lead with the human-first approach, sustainable growth and outcomes, not just capabilities.
- Use the client's own terminology and KPIs from the RFP.
- Avoid jargon such as "synergies", "solutions provider", "turnkey services" and "moving the needle". Tone is bold, refined and insightful: clear, confident, no emojis.
```

### `library/knowledge/deliverables.md`

```markdown
# Framing and deliverables vocabulary

Quantities always in brackets after the item. Only use a number that comes from the RFP, the Q&A or the intake form. If none is given, leave a visible placeholder and list it in the review notes. Never guess.

## Standard deliverables by phase (seen across KFH, Horizon, Vision Bank, MIM, THC, anb)
**Program Design**
- Medallia license activation and instance setup
- BRD (1), Medallia-adapted
- Survey design: surveys (N), relational survey (N), survey builds (N); bilingual EN/AR
- Touchpoints / journeys (up to N); trigger points and distribution parameters
- Solution architecture and integration design
- Roles and dashboard design (up to N roles)
- Alert and close-the-loop design (1 alert per survey), escalation paths aligned to the client hierarchy
- Regulatory documentation support (SAMA / NCA / CBB as relevant)

**Program Build & Tool Activation**
- Survey configuration and theme per client brand guidelines
- Channels activated (N): SMS, Email, WhatsApp, Web intercept, App SDK, QR, IVR, Kiosk
- Integrations (N): CRM, core banking, contact centre (Cisco, Genesys), ERP (SAP, Oracle, Dynamics), Salesforce, via API or SFTP file drop
- Role-based dashboards (N roles)
- Text analytics package (1 TA package; industry topic set, e.g. 50 topics; EN + native Arabic)
- CLF / close-loop form (N)
- Historical data migration (up to N records) when migrating
- SIT, UAT phase (1), go-live

**Program Adoption & Scaling**
- Training sessions (up to N): admin, reporting users, close-loop users; user guides
- Solution handover document and Medallia guideline (1)
- Hypercare (N weeks/months)
- Managed services / support hours (N per year)
- Communication / change management plan
- Scalability options (DXA, speech, social, predictive) as optional extras

## Volumes
Responses (N per year), customers (N), triggers (up to N), services (N). Copy the RFP figure exactly.

## Assumptions (typical)
- Client shares brand guidelines, data fields and stakeholder contacts on time.
- Stakeholders are available for workshops, validation and sign-off.
- Integrations limited to the listed systems; customisations Medallia does not support are out of scope.
- Arabic and English only unless stated.

## Prerequisites (typical)
- Access to systems and test environments; IT contact for integrations.
- Signed-off BRD before build.
- Data privacy/regulatory approvals obtained by the client where required.
```

### `library/knowledge/domain-rules.md`

```markdown
# Domain rules

Facts the tool applies when the client matches. Only state what the inputs or these rules support.

## Saudi Arabia
- Data residency: propose Medallia KSA local hosting where the RFP raises residency or the client is government/regulated (THC, GOSI, Wataniya, anb).
- Regulators to reference when relevant: SAMA (banks, fintech, insurance), NCA (cybersecurity controls), PDPL (personal data). Offer the "regulatory documentation support" activity.
- SAMA-regulated payment/fintech clients (Neoleap): survey links must not be sent by SMS, Email or WhatsApp. Use in-app, web intercept, IVR, QR and receipts instead. Confirm per client in the Q&A.
- Bilingual EN / native Arabic surveys and text analytics are standard.

## Other GCC
- UAE: local hosting in UAE (DEWA). Bahrain: compliance under Bahrain's regulatory framework (KFH). Use the client's country regulator, not SAMA.

## Industry topic sets (text analytics)
Banking, insurance, telecom, government/public services, real estate, employee experience. Match the client's industry; THC and Wataniya used 50-topic sets.

## Program types
- VoC: customer surveys, journeys, close the loop.
- VoE / EX: employee lifecycle and engagement surveys (NHC); HR integrations; use "employees" in titles.
- DXA: digital experience analytics on web/app, often as optional scalability or free PoC (DEWA, SAB, anb).
- Chatbot / AI streams: separate stream in the timeline (Wataniya).

## References selection
Same industry first, then closest (banking near fintech and insurance; government near semi-government and utilities). Only use references in the Client References deck.
```

### `library/knowledge/filler-slides.md`

```markdown
# Filler (solution) slide catalogue

Titles are action sentences in capitals that name the client. Replace <CLIENT> and keep the client's terms. Pick only slides that match an activity in scope.

## Program Design
- WE WILL ACTIVATE THE MEDALLIA LICENSE AND SET UP THE INSTANCE FOR <CLIENT>
- WE WILL PREPARE THE PROJECT PHASE PLAN, DEFINE THE GOVERNANCE STRUCTURE, AND ALIGN ON THE CORE PROJECT TEAM FROM BOTH <CLIENT> AND NEW METRICS
- WE WILL START BY COLLECTING CUSTOMER EXPERIENCE RELATED DATA FROM VARIOUS STAKEHOLDERS AT <CLIENT> TO HELP US UNDERSTAND THE CURRENT STATE
- WE WILL COLLECT RELEVANT CUSTOMER JOURNEY MAPS TO REVIEW THEIR ALIGNMENT WITH THE SURVEYS PREVIOUSLY DESIGNED AT <CLIENT>
- WE WILL DEFINE KEY CUSTOMER TOUCHPOINTS FOR YOUR JOURNEY AND DEVELOP TAILORED QUESTIONNAIRES
- WE WILL DESIGN THE SURVEY QUESTIONNAIRES IN LINE WITH SURVEY DESIGN GUIDELINES AND BEST PRACTICES
- WE WILL MAKE SURE THE SURVEY DESIGN FOLLOWS BEST-IN-CLASS DESIGN GUIDING PRINCIPLES
- WE WILL REVIEW <CLIENT> SURVEYS, FROM INITIAL INPUT REVIEW TO OPTIMIZED QUESTIONNAIRES AND FINAL SIGN-OFF
- WE WILL PRESENT KPIS & METRICS FOR THE CUSTOMER (OR EMPLOYEE) EXPERIENCE TO MEASURE PERFORMANCE AT VARIOUS TOUCHPOINTS
- WE WILL DESIGN THE SOLUTION ARCHITECTURE AND ENSURE MEDALLIA'S SEAMLESS INTEGRATION IN <CLIENT>'S IT LANDSCAPE
- WE WILL IDENTIFY ALL DASHBOARD ROLES NEEDED TO DELIVER INSIGHTS AND CAPABILITIES FOR ALL MEDALLIA USERS
- WE WILL MAKE SURE THAT THE RESPECTIVE DASHBOARDS TAKE INTO CONSIDERATION THE NUMBER OF <CLIENT>'S ROLES AND THE DATA ACCESS REQUIRED
- WE WILL STRUCTURE AND DESIGN THE ALERT ESCALATION PATHS FROM THE HIGHEST TO THE LOWEST LEVELS, ALIGNED WITH <CLIENT>'S HIERARCHY
- WE WILL SUPPORT WITH THE NECESSARY DOCUMENTATION TO ENSURE COMPLIANCE UNDER THE UMBRELLA OF SAUDI REGULATORY BODIES (or the client country's regulator)
- WE WILL DEFINE A COMMUNICATIONS FRAMEWORK

## Program Build & Tool Activation
- WE WILL INITIATE THE CREATION OF SURVEYS AND THE DEVELOPMENT OF INTERACTIVE ROLE-BASED DASHBOARDS
- WE WILL CONFIGURE AND DEPLOY THE VOC PLATFORM IN MEDALLIA BASED ON THE APPROVED ARCHITECTURE, JOURNEYS, METRICS AND WORKFLOWS
- WE WILL ENSURE MEDALLIA'S SEAMLESS INTEGRATION IN <CLIENT>'S IT LANDSCAPE, ALIGNED WITH THE ARCHITECTURE DESIGNED IN PHASE 1
- WE WILL ENABLE THE RIGHT LISTENING POSTS ACROSS CUSTOMER ENGAGEMENT CHANNELS
- WE WILL ENSURE THAT QR CODES ARE PROPERLY CONFIGURED FOR EASE OF SURVEY ACCESS
- WE WILL LEVERAGE MEDALLIA'S DIGITAL SURVEY BUILDER (ALWAYS-ON) TO DEPLOY SURVEYS QUICKLY
- WE WILL LEVERAGE THE TEXT ANALYTICS AND AI ENGINE OF MEDALLIA IN BOTH ENGLISH AND NATIVE ARABIC TO ANALYZE CUSTOMER (OR EMPLOYEE) SENTIMENT
- WE WILL LEVERAGE AI & ADVANCED ANALYTICAL CAPABILITIES SUCH AS TREND DETECTION
- WE WILL BUILD AND CONFIGURE DASHBOARDS TO DELIVER INSIGHTS AND CAPABILITIES FOR ALL MEDALLIA USERS

## Program Adoption & Scaling
- WE WILL ORGANIZE TRAINING SESSIONS TO ENSURE ALL MEDALLIA ASPECTS ARE COVERED AND STAKEHOLDERS ARE FULLY ENABLED ON THE PLATFORM (1/2, 2/2)
- WE WILL DEVELOP AND CREATE A SOLUTION HANDOVER DOCUMENT AND MEDALLIA GUIDELINE FOR <CLIENT>
- WE WILL ENSURE MEDALLIA'S SOLUTION ADOPTION & GOVERNANCE FOR THE <CLIENT> PROGRAM
- WE WILL IDENTIFY WHERE RESISTANCE MAY OCCUR AND THE RIGHT INFLUENCERS AND CHANGE MAKERS
- WE WILL ENSURE PLATFORM STABILITY THROUGH PROACTIVE MAINTENANCE, SECURITY UPDATES AND PLANNED SERVICE COMMUNICATION (managed services)
- WE WILL ENSURE THAT THE SURVEY RESPONSES ARE AUTHENTIC THROUGH OUR QUALITY ASSURANCE PROCESS

## Optional / scalability (only if the RFP or intake asks)
- WE WILL LEVERAGE MEDALLIA DIGITAL EXPERIENCE ANALYTICS (DXA) TO TRACK UNSOLICITED DIGITAL EXPERIENCE ACROSS ALL DIGITAL PROPERTIES
- WE WILL LEVERAGE SOCIAL FEEDBACK TO CAPTURE REAL-TIME INSIGHTS INTO CUSTOMER ENGAGEMENT
- WE WILL DESIGN THE AI CHATBOT WORKFLOW IN LINE WITH THE AVAILABLE KNOWLEDGE BASE AND CHANNELS
- Speech analytics, predictive analytics, data maturity (anb, SABIC "program scalability" sections)

## Strategy add-ons (THC-style group programmes, only when in scope)
- Journey mapping workshops, service blueprint, personas and segments (B2C/B2B)
- Unified KPI models per subsidiary rolled into one experience index
- Future-state CX governance, target organisation structure, job descriptions and KPIs
- Knowledge transfer and CX capability building
```

### `library/knowledge/intake-form.md`

```markdown
# Intake form (asked before any proposal is generated)

The tool will not start generating until every required field is filled. Source: Aya, 27 Oct 2026.

| Field | Required | Input type | How the tool uses it |
|---|---|---|---|
| Language | Yes | English / Arabic | Picks the EN or AR slide library (template, About Medallia, Client References) and the layout direction (LTR / RTL). |
| Client name | Yes | Text | Used the same way everywhere: cover, titles, approach, prerequisites, timeline. Possessive form shown for a quick check. |
| Client logo | Yes | Image upload, or tick "N/A" | Placed on the cover white box, the Medallia capture slide (under the email example), and anywhere the template has a client logo. If N/A, the tool looks the logo up on the web, shows it for confirmation, and lists it in the review notes. |
| Project details and description | Yes | Free text | Sets the proposal title and drives the objectives and key-activity text in each phase. |
| Number of surveys | Yes | Number | Survey and questionnaire quantities in deliverables and prerequisites, e.g. "Surveys (15)". |
| Number of deliverables | Yes | Number per item: BRDs, integrations, channels, dashboards/roles, training sessions, etc. | Deliverable quantities in each phase's framing slide and on the quantified phases slide. |
| Timeline | Yes | Timeline maker: duration in weeks per phase (and per activity if wanted) | Builds the weekly Gantt slide and the stated project duration ("N months (N weeks)"). |
| RFP document | Optional | PDF / DOCX upload | Requirements are extracted and mapped to approach and solution slides. Unanswered asks and conflicts (e.g. requested duration vs timeline entered) go in the review notes. |
| Scoping questions and answers | Optional | XLSX / DOCX / PDF upload | Client answers refine solution slides, prerequisites and assumptions. Q&A wins over the RFP where they conflict. |

## Behaviour rules
- Form values are the source of truth for numbers. If the RFP or Q&A gives a different number, the tool keeps the form value and flags the difference in the review notes.
- Phases default to Program Design / Program Build & Tool Activation / Program Adoption & Scaling; the timeline maker lets the user rename, add or remove phases (e.g. when the RFP prescribes Build / Activate / Operate).
- Nothing outside the form, RFP, Q&A and library is stated as fact.
```

### `library/knowledge/qa-checklist.md`

```markdown
# Review checklist (the tool runs this on every generated deck)

Each item below was found in a real past proposal.

## Leftover template or other-client text
- Placeholders: XXX, [replace with industry name], <CLIENT>, "Lorem" (CDF had XXX in the phases slide).
- Other clients' names: "Sohar Port", "Ministry of Culture", or any client in the catalogue other than the current one.
- Template step counts: "FIVE-STEP" when the deck has 3 phases.
- The template's sample timeline slide left in alongside the real one.
- Editorial notes on slides: "updated as per new NM branding design" (Neoleap).

## Consistency
- Same phase names everywhere: phases slides, framing, timeline, filler.
- Same quantities everywhere (surveys, roles, channels, trainings, weeks). NHC had 26 weeks on one slide and 15 on another.
- Activity letters match between framing, timeline and filler slides.
- Program name matches the scope: VoC vs VoE vs EX ("VOE" typo in a VoC deck, "PRORAM", "threew-step").
- Client name spelled the same way throughout, including possessives.

## Against the RFP
- Every RFP ask and evaluation criterion is answered somewhere.
- Duration matches the requested duration (Vision Bank mismatch).
- Channels lit on the capture slide equal the channels in scope.
- Prohibited channels not proposed (SAMA rule for fintech/banking survey links, see domain-rules.md).
- Nothing claimed that is not in the inputs: references, numbers, certifications, integrations.

## Brand
- Only 2026 template layouts, Geomanist / GE SS Two, approved colours, footer year current.
- Titles in capitals, takeaway subtitle at most 2 lines, no crowded slides.
- No commercial content (prices, payment milestones, T&C) in the technical proposal (SABIC, Cigna had these).

## Data hygiene
- No credentials, personal data or internal-only notes copied from inputs (NHC Q&A file had usernames and passwords).
```

### `library/knowledge/rfp-to-slides.md`

```markdown
# How RFP asks become slides

Rule zero: every explicit ask in the RFP or Q&A must appear in the deck, in the client's words, and nothing outside the inputs is added as fact.

| RFP / Q&A says | Deck does | Seen in |
|---|---|---|
| Evaluation criteria with weights | Add a slide mapping each criterion to the page/section that answers it | KFH, THC |
| Prescribed proposal structure or headings | Rename sections and TOC to the RFP headings; keep our content under them | THC (Understanding your requirements, Technical approach, Implementation plan) |
| Compliance matrix / features list (e.g. Annex B) | RFP compliance section or table: requirement, compliant (Y/partial), where addressed | anb, Vision Bank |
| Requested duration | Timeline uses that duration; if we cannot meet it, say so in review notes, never silently change | Vision Bank (4 weeks asked, ~3 months proposed: flag) |
| Named channels | Light those channels on the Medallia capture slide; list them in Build deliverables | all |
| Named systems to integrate | Integrations (N) deliverable plus the architecture filler slide naming those systems | KFH, Neoleap (Cisco), Wataniya |
| Number of surveys / touchpoints / users / roles | Quantities in brackets on the quantified phases and framing slides | KFH (15 surveys, 5 roles), anb (25), MIM (6 touchpoints) |
| Response volumes | Volume on the phases slide and assumptions | anb 500K, THC 250K, Horizon 12K/yr |
| Languages | Bilingual EN/AR survey and TA deliverables | all KSA |
| Hosting / data residency | Security slide with local hosting statement; assumption | THC, GOSI, DEWA (UAE) |
| Support / managed services | MS hours (N) deliverable and governance after go-live | KFH 200, Wataniya 200, SABIC 100 |
| Team qualification requirements | Team slide matches required roles and certifications | CDF annex 5, THC |
| Phasing stated by client | Use their phase names and scope only the phase requested | Neoleap Phase I, Msheireb phase 1 |
| Client context and objectives | "Understanding your requirements" / "We understood your challenges" slide in the Exec Summary | THC, DEWA, Cigna |

Q&A answers override RFP text when they conflict. Note the source (RFP section or Q&A row) for every number in the review notes.
```

### `library/knowledge/sections.md`

```markdown
# Proposal sections (English, 2026 template)

The default order. If the RFP prescribes its own structure or headings, follow the RFP and map our sections onto its headings (see rfp-to-slides.md).

| # | Section | Source | What the tool does |
|---|---|---|---|
| 1 | Cover | Template | Client logo in the white box, RFP/project name exactly as the RFP names it, "Technical Proposal", month and year. |
| 2 | Table of contents | Template | About Us, About Medallia, Executive Summary, Project Approach & Methodology, Project Plan & Governance, Client References, Our Team. Rename items if the RFP prescribes headings. |
| 3 | About Us | Template, standard slides | Copied as is. Approved "Who we are" text only. |
| 4 | About Medallia | About Medallia deck | Copied as is, except the capture slide: client logo under the email example; requested channels in colour, the rest greyed. |
| 5 | Executive Summary | Generated | Optional "Understanding your requirements" slide when the RFP gives context; QUANTIFIED phases slide; framing slides per phase; timeline; governance. |
| 6 | Project Approach & Methodology | Generated | UNQUANTIFIED phases slide; then per phase: its framing slide(s), followed by filler (solution) slides for each activity. |
| 7 | Project Plan & Governance | Template + generated | Weekly Gantt (phase rows, lettered activities, kick-off, milestones), the client-dependency note, governance structure, communication structure, project management approach. |
| 8 | Client References | Client References deck | Pick references in the client's industry first, then the closest industries. Never invent a reference. |
| 9 | Our Team | Team profiles | Delivery team slide, then profiles from most senior to most junior. |
| 10 | Closing | Template | Thank you slide. |

## Phases
- Default three phases: 1. Program Design, 2. Program Build & Tool Activation, 3. Program Adoption & Scaling.
- Use the RFP's phases or wording when it gives them. Variants seen and accepted: Build / Activate / Operate (THC, Wataniya), 4-step (SABIC, Cigna, DEWA), 5-step (anb, NHC), streams for parallel work (Wataniya VoC + chatbot), "Phase I only in scope" (Neoleap, Msheireb).
- The approach title says the real number of steps: "WE WILL FOLLOW A PRAGMATIC 3-PHASE APPROACH TO DELIVER THE VOC PROGRAM". Never leave "FIVE-STEP" from the template when there are three.
- Quantified phases slide (Exec Summary) carries the numbers: surveys, channels, roles, trainings, weeks. Unquantified version (Approach) carries the same structure without numbers.

## Framing slide (one per phase, can split into 1/2, 2/2)
Boxes: Objectives; Key Activities (lettered A, B, C or numbered 1.1, 1.2); Assumptions; Prerequisites; Deliverables with quantities in brackets.
Activity letters run through the timeline and filler slides so the reader can follow A to A.

## Filler (solution) slides
One or more per key activity, titled as an action sentence about the client (see filler-slides.md). Takeaway subtitle of at most 2 lines.

## Timeline
- "PROJECT PLAN: We propose to execute this project over a timeline of N months (N weeks)".
- Rows: phases, then lettered activities, weekly columns, Week 0 preparation, kick-off, milestones/deliverable markers, hypercare if offered.
- Standard note: "*Note: Project timelines are dependent on <CLIENT>'s timely support across the defined activities."
- Duration must match the RFP's requested duration, or the review notes flag it.
```

---
_End of handover document._
