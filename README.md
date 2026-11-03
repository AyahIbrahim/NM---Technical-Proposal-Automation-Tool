[README.md](https://github.com/user-attachments/files/34319999/README.md)
# New Metrics Technical Proposal Builder (v1, English)

A local web app that turns the intake form, client logo, RFP and scoping Q&A into an on-brand
technical proposal (.pptx) plus review notes (.docx). It runs on your own computer; nothing is
hosted online.

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
- Up to 5 phases; timelines over 30 weeks are shown in 2-week columns.


  - `ANTHROPIC_API_KEY`:turns on RFP analysis for everyone.
-
New Project > Deploy from GitHub repo, add the variables above under Variables, and under
Settings > Networking choose Generate Domain. That link is the website.

Running it on your own computer still works as before (no login there).
