# TIMELINE.md

## Through Two Sets of Eyes - Project Timeline

**Document status:** Living document - update as milestones are reached
**Maintained by:** Peter Shanks (botheredbybees@gmail.com)

---

## Background

*Through Two Sets of Eyes* began as an assessment task for FXA301 (Creative Arts and Health Practice) at the University of Tasmania in Semester 1, 2026. The original proposal - *Cygnet Through Two Sets of Eyes* - described an eight-week intergenerational Photovoice project in Cygnet, Tasmania, pairing at-risk youth with older adults in a parallel photographic dialogue displayed in the window of Farah's IGA.

The broader kit and platform project developed from the recognition that the design had value beyond a single site, and that a reusable, open-source framework could generate meaningful evidence at scale if enough communities ran the same protocol.

---

## Phase 0: Concept and Academic Context

**February - May 2026**

- FXA301 AT4 proposal drafted - *Cygnet Through Two Sets of Eyes*
- Core design principles established: two independent cohorts, identical prompts, unattributed public exhibition, Week 8 reveal
- Photovoice methodology confirmed as the theoretical framework (Wang & Burris, 1997)
- CHIME framework identified as the wellbeing mechanism (Leamy et al., 2011)
- SWEMWBS selected as the primary quantitative outcome measure
- Parallel FXA100 AT4 essay developed - *Playing Presence* elder-clowning proposal - establishing the broader arts and health research context
- Intergenerational Photovoice literature identified: Garcia et al. (2013) as key methodological reference

---

## Phase 1: Kit Specification

**May 2026**

The project expanded from a single-site proposal to a reusable kit concept. Key decisions made:

**Scope and governance:**
- Named the kit *Through Two Sets of Eyes* - geographically unanchored, descriptive of the core mechanism
- Short handle `thru2setsofeyes` confirmed available and registered as GitHub organisation
- MIT licence chosen over Creative Commons - simpler, more permissive, familiar to open source community
- Independent kit model chosen over institutional affiliation - U3A networks as first-adopter target, not as owner
- Longevity-first design principle established: infrastructure must survive any individual maintainer

**Kit components specified:**
- Facilitator Guide - structure, contents, appendices A-M
- Prompt Card Set - eight weekly prompts finalised, SHOWED framework questions per card
- Consent Template Pack - three templates (adult, under-18, public photography)
- SWEMWBS Pack - five documents including participant code generation method
- Exhibition Guide - venue selection, print specifications, installation, Week 8 closing event
- Participant Image Submission Guide - participant-facing and facilitator-facing sections
- Data Submission Guide - post-project data submission process
- Site Registration Process - CF7 form, coordinator workflow, status tracking

**Platform architecture - first draft:**
Initial architecture proposed GitHub + WordPress + Google Workspace. Google Workspace subsequently abandoned after Google Apps Script execution timeout failures on trivial operations.

**Platform architecture - final:**
- GitHub: `github.com/thru2setsofeyes` organisation, `kit` repository
- WordPress: self-hosted on sidewalkcircus.org server (Hostmonster/Bluehost), PHP 8.2
- Supabase: PostgreSQL 15, managed hosting, free tier

**Key platform decisions and reasons:**
- Google Sheets abandoned: 6-minute execution limit, Apps Script timeouts even on trivial operations
- MySQL on shared hosting considered and rejected: Percona Server 5.7.23, EOL October 2023
- PostgreSQL on shared hosting considered and rejected: version 9.2.24, EOL 2017
- ODK Cloud considered and rejected: USD $199/month
- Supabase chosen: actively maintained PostgreSQL 15, free tier, open source, self-hostable if needed, SSL everywhere

**Supporting documents drafted:**
- `1.0-Project_specification.md` - Parts 1, 2, and 3
- `2.1` through `2.8` - all kit component specifications
- `3.0-Platform_architecture.md` - full platform architecture
- `HANDOVER.md` - coordinator handover guide
- `SETUP.md` - infrastructure setup guide

---

## Phase 2: Infrastructure Setup

**May 2026 - ongoing**

### Completed

**GitHub:**
- `thru2setsofeyes` organisation created at `github.com/thru2setsofeyes`
- Scratchpad repository at `botheredbybees/thru2setsofeyes` used for drafting
- All planning documents committed to `docs/planning/` in scratchpad repo
- `infrastructure/supabase/schema.sql` committed
- `infrastructure/supabase/policies.sql` committed
- `LICENSE` (MIT) committed
- `HANDOVER.md` committed
- `SETUP.md` committed
- `TIMELINE.md` committed (this document)

**Supabase:**
- Project created: `thru2setsofeyes` at `https://mybqgaimdeluvgjegmmj.supabase.co`
- Region: confirmed at setup
- Plan: Free
- Schema applied via SQL Editor - six tables, four views
- SWEMWBS conversion table populated - 29 rows (raw scores 7-35)
- Row Level Security enabled on all six tables
- Anon insert policies applied to five tables
- Public read policy applied to `swemwbs_conversion`
- `moderation_queue` view restricted to authenticated role via REVOKE/GRANT
- Storage buckets created: `submissions` (private), `gallery` (public)
- Storage policies applied - five policies covering anon and authenticated access

### Completed (continued)

**WordPress architecture decision:**
- WordPress Multisite confirmed as the deployment model for the sidewalkcircus.org server
- Through Two Sets of Eyes will be a subsite on the existing Multisite installation
- Domain mapping via Domain Mapping System plugin (free tier)
- Multisite install pending - `github.com/thru2setsofeyes/kit` repository to be created once Multisite is operational

**Planning review (May 2026):**
External review of the repository identified and actioned the following:
- `infrastructure/supabase/policies.sql` — misleading policy name corrected: "Anon cannot read submissions" renamed to "Anon can read gallery" to accurately reflect that the policy grants anon SELECT on the gallery bucket
- `infrastructure/supabase/schema.sql` — SWEMWBS auto-scoring trigger added: `calculate_swemwbs_scores()` now calculates `raw_total` and looks up `metric_score` from `swemwbs_conversion` on insert/update; leaves both NULL if any item is missing
- `docs/planning/2.1` — Week 8 reveal scenario added to Section 8 (If something goes wrong), including specific guidance on holding difficult closing moments
- `docs/planning/2.3` — Post-project online gallery removal clause added to Template 1; consent now distinguishes between physical exhibition withdrawal (up to Week 8) and online gallery removal (possible after, with caveats on third-party copies)
- `HANDOVER.md` — Coordinator absence protocol added for active project weeks
- Review also confirmed that the eight weekly prompts (2.2), the `updated_at` trigger for `sites`, and the safeguarding disclosure sections in 2.1 were already complete — these were incorrectly flagged as missing

### Remaining - Phase B (WordPress)

- [ ] WordPress architecture decision - Multisite vs subdirectory
- [ ] Through Two Sets of Eyes subsite or subdirectory created
- [ ] Plugins installed and configured: FooGallery, Leaflet Maps Marker, WP Super Cache, UpdraftPlus, Wordfence, WP Mail SMTP
- [ ] Backblaze B2 account and bucket created
- [ ] UpdraftPlus configured with B2
- [ ] Brevo account created, WP Mail SMTP configured
- [ ] Site structure built - pages, menus
- [ ] CF7 forms built: site registration, site status update, general contact
- [ ] Site visible at project domain

### Remaining - Phase C (Supabase completion)

- [ ] Bucket file size limits set: 15MB
- [ ] Bucket MIME types set: jpeg, png, heic, webp
- [ ] Custom SMTP configured in Supabase via Brevo
- [ ] Form pages built and tested - six pages total
- [ ] Coordinator registration form built with QR code generation and welcome email pre-draft
- [ ] Complete data flow tested end to end with TEST001 site

### Remaining - Phase D (Content)

- [ ] `github.com/thru2setsofeyes/kit` repository created
- [ ] Directory structure initialised
- [ ] Planning docs migrated from scratchpad to org repo under `spec/`
- [ ] `README.md` written
- [ ] `CONTRIBUTING.md` written
- [ ] `CHANGELOG.md` initialised
- [ ] Kit documents written from specification - seven documents
- [ ] Infrastructure documentation written - seven files
- [ ] HANDOVER.md updated with real URLs and credentials

---

## Phase 3: Pilot - Cygnet, Tasmania

**Target: second half of 2026**

**Site details:**
- Site code: CYG001
- Location: Cygnet, Tasmania
- Proposed exhibition venue: Farah's IGA window, Mary Street
- Older adult cohort: recruited via U3A Huon Valley networks
- Youth cohort: recruited via Cygnet drop-in centre
- Youth co-facilitator: to be confirmed - must hold Working With Children Check

**Milestones:**
- [ ] WordPress site live at project domain
- [ ] All form pages operational
- [ ] CYG001 registered via WordPress CF7 form
- [ ] CYG001 inserted to Supabase `sites` table
- [ ] QR code cards generated for CYG001
- [ ] Phase 0 completed - venue confirmed, cohorts recruited, orientation delivered
- [ ] Weeks 1-8 completed
- [ ] Week 8 closing event held at Farah's IGA
- [ ] Post-project SWEMWBS collected
- [ ] Site Completion form submitted
- [ ] Data confirmed in Supabase
- [ ] Images in gallery bucket and WordPress gallery
- [ ] Pilot GitHub Issues reviewed and resolved
- [ ] Kit documents updated from pilot learnings

---

## Phase 4: V1.0 Release

**Target: late 2026 / early 2027**

Dependent on pilot completion and lessons learned.

- [ ] Second GitHub org owner recruited
- [ ] All kit documents reviewed against pilot experience
- [ ] SETUP.md Section 8 removed from HANDOVER.md
- [ ] SETUP.md archived to `spec/history/`
- [ ] V1.0 tagged in GitHub
- [ ] Public launch announced on WordPress News page
- [ ] U3A Australia networks contacted with kit offer

---

## Phase 5: V2.0 Planning

**Target: 2027 and beyond**

Items explicitly deferred from V1.0:

**Multilingual and cross-cultural:**
- Language pack architecture - universal core with cultural adaptation layer
- SWEMWBS validated translations (40+ languages available)
- Prompt review process for cultural sensitivity
- Cultural adaptation registry on WordPress
- Priority languages for first translation pack - to be determined by first-adopter geography

**Technical:**
- Coordinator web interface replacing Supabase dashboard for moderation
- Automated site registration insert via Supabase Edge Function
- Automated QR code generation on registration
- Submission window management automation per site session schedule
- Image resize and gallery upload automation

**Scope extensions:**
- Optional third cohort - families with young children
- Remote and postal delivery variant for very isolated communities
- Cross-site paired exhibition - images from different countries responding to same prompt displayed together

**Research pathway:**
- Multi-site ethics approval - partner institution to be confirmed
- Publication target: *Arts in Psychotherapy*, *Health Promotion International*, or *BMC Public Health*
- Methodological contribution: distributed Photovoice model generating poolable quantitative and qualitative data without institutional research infrastructure at each site
- Garcia et al. (2013) as precedent for intergenerational Photovoice publication pathway

**Indigenous Australian engagement:**
- Explicitly deferred - requires co-design process, not adaptation of existing kit
- Separate ethics pathway
- Community data sovereignty must be resolved before any data sharing
- Palawa community context in Tasmania as natural starting point if interest exists

---

## Key References

Wang, C., & Burris, M. A. (1997). Photovoice: Concept, methodology, and use for participatory needs assessment. *Health Education & Behavior, 24*(3), 369-387. https://doi.org/10.1177/109019819702400309

Catalani, C., & Minkler, M. (2010). Photovoice: A review of the literature in health and public health. *Health Education & Behavior, 37*(3), 424-451. https://doi.org/10.1177/1090198109342084

Fancourt, D., & Finn, S. (2019). *What is the evidence on the role of the arts in improving health and well-being? A scoping review.* World Health Organization. https://www.euro.who.int/en/publications/abstracts/what-is-the-evidence-on-the-role-of-the-arts-in-improving-health-and-well-being-a-scoping-review-2019

Garcia, C. M., Aguilera-Guzman, R. M., Lindgren, S., Gutierrez, R., Raniolo, B., Genis, T., Vazquez-Benitez, G., & Clausen, L. (2013). Intergenerational photovoice projects: Optimising this mechanism for influencing health promotion policies and strengthening relationships. *Health Promotion Practice, 14*(5), 695-705. https://doi.org/10.1177/1524839912463575

Leamy, M., Bird, V., Le Boutillier, C., Williams, J., & Slade, M. (2011). Conceptual framework for personal recovery in mental health: Systematic review and narrative synthesis. *British Journal of Psychiatry, 199*(6), 445-452. https://doi.org/10.1192/bjp.bp.110.083733

Stewart-Brown, S., & Janmohamed, K. (2008). *Warwick-Edinburgh Mental Well-being Scale: User guide version 1.* NHS Health Scotland, University of Warwick and University of Edinburgh.

Tennant, R., Hiller, L., Fishwick, R., Platt, S., Joseph, S., Weich, S., Parkinson, J., Secker, J., & Stewart-Brown, S. (2007). The Warwick-Edinburgh Mental Well-being Scale (WEMWBS): Development and UK validation. *Health and Quality of Life Outcomes, 5*(63). https://doi.org/10.1186/1477-7525-5-63

---

*End of TIMELINE.md v0.1*

*Update this document when phases are completed, decisions are made, or the roadmap changes.*

---
