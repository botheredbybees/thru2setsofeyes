# SETUP.md

## Through Two Sets of Eyes - Infrastructure Setup Guide

**Version:** 0.2 draft - May 2026
**Status:** Active - Phase A and Supabase setup complete
**Maintained by:** Peter Shanks (botheredbybees@gmail.com)

---

## What This Document Is

This is the step-by-step guide for setting up the *Through Two Sets of Eyes* infrastructure from scratch. It is written for the person doing the initial setup - currently the project founder - but is detailed enough that a technically confident volunteer could follow it.

HANDOVER.md covers maintaining a running project. This document covers getting to running in the first place. Once Phase E is complete and the pilot has run, this document becomes historical record rather than active guidance - keep it in the repository as a reference for anyone who needs to rebuild the infrastructure from scratch.

**Assumed skills:** WordPress administration, basic SQL, GitHub. Phase C requires comfort with the Supabase dashboard and basic JavaScript for form pages.

**Estimated time:** Phases A-D will take approximately 8-12 hours of focused work spread across several sessions. Phase E is the pilot project itself - eight weeks plus preparation.

---

## Phase A: Accounts and Credentials

*Status: Complete*

---

### A1. Password manager

Bitwarden or equivalent. All project credentials stored in a dedicated collection. See HANDOVER.md Section 5 for the credential inventory.

- [x] Password manager set up
- [x] Project credentials collection created

---

### A2. Project Google account

Not required. Data collection has moved to Supabase. A Google account is no longer part of the project infrastructure.

---

### A3. GitHub organisation

**Organisation:** `github.com/thru2setsofeyes`
**Primary repository:** `github.com/thru2setsofeyes/kit`

- [x] GitHub org created
- [x] Planning docs committed to `botheredbybees/thru2setsofeyes` scratchpad repo
- [ ] `github.com/thru2setsofeyes/kit` repository created and directory structure initialised
- [ ] Planning docs migrated from scratchpad to org repo under `spec/`
- [ ] HANDOVER.md and SETUP.md at repo root
- [ ] LICENSE file added
- [ ] Second org owner recruited - pending

**Directory structure to initialise:**

```
kit/
├── README.md
├── LICENSE
├── CONTRIBUTING.md
├── CHANGELOG.md
├── HANDOVER.md
├── SETUP.md
├── spec/
├── kit/
│   ├── facilitator-guide/
│   ├── prompt-cards/
│   ├── consent-templates/
│   ├── swemwbs-pack/
│   ├── exhibition-guide/
│   ├── image-submission-guide/
│   └── data-submission-guide/
├── translations/
│   └── README.md
├── adaptations/
│   └── README.md
└── infrastructure/
    ├── wordpress/
    │   ├── README.md
    │   └── plugins.md
    ├── supabase/
    │   ├── README.md
    │   ├── schema.sql
    │   └── policies.sql
    └── backup/
        └── README.md
```

---

### A4. Domain name

- [ ] Domain name confirmed - `thru2setsofeyes.org` or equivalent
- [ ] DNS pointing to sidewalkcircus.org server
- [ ] Registrar credentials in Bitwarden

---

## Phase B: WordPress

*Estimated time: 3-4 hours*
*Requires: Hostmonster/Bluehost admin access, domain name confirmed*

---

### B1. WordPress architecture decision

Two options evaluated:

**Option 1: WordPress Multisite** - convert existing sidewalkcircus installation. Recommended for long-term maintenance.

**Option 2: Separate subdirectory installation** - independent WordPress under `~/public_html/thru2setsofeyes/`.

- [ ] Architecture decision made: _______________
- [ ] WordPress subsite or subdirectory installation created

---

### B2. Install and configure required plugins

**Contact Form 7** - already installed on sidewalkcircus. Confirm available on new subsite if using Multisite. No additional configuration at this stage - forms built in B4.

**User Submitted Posts** - already installed. Settings:
- Submissions require login: Yes
- Moderation: All submissions require approval
- Post type fields: title, content, image upload only

**FooGallery**
- Install from plugin directory
- Enable lazy loading in settings
- Gallery images are served from Supabase `gallery` bucket - no local image storage required
- Configure gallery pages to load image URLs via JavaScript fetch from Supabase

**Leaflet Maps Marker**
- Install from plugin directory
- No API key required - uses OpenStreetMap
- Default map centre: Australia
- Map pins populated from Supabase `public_site_map` view via JavaScript fetch

**WP Super Cache**
- Install from plugin directory
- Enable Simple caching mode with compression
- Exclude the Data dashboard page from caching - it fetches live from Supabase
- Test gallery pages load correctly after enabling

**UpdraftPlus**
- Install from plugin directory
- Schedule: daily database, weekly files
- Remote storage: Backblaze B2 (configure in B3)
- Email notifications: project coordinator email
- Run manual backup immediately after configuration

**Wordfence**
- Install from plugin directory
- Run setup wizard
- Learning Mode for first week, then switch to Enabled
- Email alerts to project coordinator

**WP Mail SMTP**
- Install from plugin directory
- Mailer: Brevo (formerly Sendinblue)
- Create Brevo account using coordinator email
- Generate API key, enter in plugin settings
- Send test email to confirm delivery
- Store Brevo credentials in Bitwarden

*Note: WP Data Access is not required. The public data dashboard fetches directly from Supabase via JavaScript - no WordPress database plugin needed.*

- [ ] All plugins installed and configured
- [ ] UpdraftPlus first backup confirmed
- [ ] Wordfence active
- [ ] WP Mail SMTP sending correctly

---

### B3. Backblaze B2 remote storage

1. Create Backblaze account using coordinator email
2. Create bucket: `thru2setsofeyes-backups` - set to Private
3. Create application key with read/write access to this bucket only
4. Enter bucket name, key ID, and application key in UpdraftPlus remote storage settings
5. Run manual backup and confirm file appears in B2 bucket
6. Store B2 credentials in Bitwarden
7. Share bucket access with a second person - create a second application key for them

- [ ] Backblaze B2 account created
- [ ] Bucket created and UpdraftPlus connected
- [ ] Backup confirmed in B2
- [ ] Credentials in Bitwarden
- [ ] Second person has independent bucket access

---

### B4. Build the site structure

Create pages in wp-admin > Pages > Add New.

**Top-level pages:** Home, About, Run a Project, Gallery, Project Map, Data, News, Contributing

**Child pages under About:** What is Through Two Sets of Eyes?, The evidence base, Core design principles, Contact

**Child pages under Run a Project:** Register a site, Download the kit, Facilitator contributions

**Child pages under Gallery:** Browse by site, Browse by week, Browse by prompt

**Contact Form 7 forms to build:**

*Site Registration Form* - fields as specified in `2.8-Site_registration_process.md`. Submissions emailed to coordinator. Coordinator manually enters approved registrations into Supabase `sites` table.

*Site Status Update Form* - fields: site code, status update key, new status, current week number, brief notes. The form page validates the status update key against Supabase before accepting the update. Instructions for building this validation in JavaScript are in `infrastructure/supabase/README.md`.

*General Contact Form* - name, email, message.

**Menus:**
- Primary: Home, About, Run a Project, Gallery, Project Map, Data, News
- Footer: Contributing, GitHub (external link), Contact

- [ ] All pages created
- [ ] CF7 forms built and tested
- [ ] Navigation menus configured
- [ ] Site visible at project domain

---

## Phase C: Supabase

*Status: Core setup complete*
*Estimated time for remaining items: 1-2 hours*

---

### C1. Project created

**Project name:** thru2setsofeyes
**Project URL:** `https://mybqgaimdeluvgjegmmj.supabase.co`
**Region:** [confirm which region was selected at setup]
**Plan:** Free

- [x] Supabase project created
- [x] Project URL and keys stored in Bitwarden

---

### C2. Database schema

The complete schema was applied via the Supabase SQL Editor. The schema file is stored in the kit repository at `infrastructure/supabase/schema.sql`.

**Tables created:**
- [x] `sites` - master site registry with auto-generated `status_update_key`
- [x] `swemwbs_surveys` - SWEMWBS responses with unique constraint per participant per timepoint
- [x] `image_submissions` - participant image metadata with moderation workflow columns
- [x] `session_notes` - facilitator weekly session notes
- [x] `site_completions` - post-project completion data
- [x] `swemwbs_conversion` - raw-to-metric lookup table, 29 rows populated

**Views created:**
- [x] `public_dashboard` - aggregate SWEMWBS statistics, public access
- [x] `public_site_map` - site registry for map display, public access
- [x] `public_gallery` - approved published images, public access
- [x] `moderation_queue` - pending submissions, authenticated access only

**Row Level Security:**
- [x] RLS enabled on all six tables
- [x] Anon insert policies on sites, swemwbs_surveys, image_submissions, session_notes, site_completions
- [x] Public read on swemwbs_conversion
- [x] moderation_queue restricted to authenticated role

To rebuild from scratch on a new Supabase project, run these files in sequence via the SQL Editor:
1. `infrastructure/supabase/schema.sql`
2. `infrastructure/supabase/policies.sql`

---

### C3. Storage buckets

**`submissions` bucket - private**
- [x] Created with private access
- [x] Anon insert policy applied
- [x] Authenticated read, insert, delete policies applied

**`gallery` bucket - public**
- [x] Created with public access
- [x] Anon read policy applied
- [x] Authenticated insert and delete policies applied

*Note: File size limits and MIME type restrictions were not set during initial creation - both buckets currently allow any file type up to the Supabase default 50MB limit. Tighten these in Supabase > Storage > bucket settings:*
- [ ] `submissions` bucket: set 15MB limit, allowed types `image/jpeg,image/png,image/heic,image/webp`
- [ ] `gallery` bucket: set 15MB limit, allowed types `image/jpeg,image/png,image/heic,image/webp`

---

### C4. Supabase email configuration

Supabase can send transactional emails via a custom SMTP provider. Configure this so site completion confirmation emails are sent from a project address rather than Supabase's default.

1. Supabase dashboard > Settings > Auth > SMTP Settings
2. Enable custom SMTP
3. Enter Brevo SMTP credentials (same Brevo account used for WP Mail SMTP)
4. From address: `noreply@thru2setsofeyes.org` or equivalent
5. Send test email to confirm delivery

- [ ] Custom SMTP configured in Supabase
- [ ] Test email confirmed

---

### C5. Form pages

Each data collection form is a standalone HTML page using the Supabase JavaScript client library. These pages can be hosted as WordPress custom pages or as standalone HTML files in a subdirectory of the hosting server.

The Supabase anon key is included in participant and facilitator-facing pages. This is acceptable - the anon key is designed to be public and RLS enforces what anon users can and cannot do.

The coordinator registration page uses the service key and must be password-protected. It must never be publicly accessible.

**Forms to build - public facing:**

*Participant image submission form* - for participants. Pre-filled fields from QR code URL parameters: site code, week number, cohort, prompt text. Participant enters: participant code, caption. Uploads image directly to Supabase `submissions` bucket. On successful upload, JavaScript inserts metadata row to `image_submissions`. Uses anon key.

*SWEMWBS data entry form* - for facilitators. Fields: site code, facilitator code, participant code, cohort, survey interval, survey date, Q1-Q7. JavaScript validates site code and facilitator code against `sites` table, calculates raw total, looks up metric score from `swemwbs_conversion`, inserts complete row to `swemwbs_surveys`. Uses anon key.

*Session notes form* - for facilitators. Fields: site code, facilitator code, week number, session date, attendance youth, attendance older adult, notes. Inserts to `session_notes`. Uses anon key.

*Site completion form* - for facilitators. Fields as specified in `2.7-Data_submission_guide.md`. Inserts to `site_completions`. On success Supabase sends confirmation email via configured SMTP. Uses anon key.

*Site status update form* - for facilitators. Fields: site code, status update key, new status, current week number. JavaScript validates status update key against `sites` table before allowing update. Linked from registration confirmation email. Uses anon key.

**Forms to build - coordinator facing (password protected):**

*Site registration form* - for coordinator use only. Password protected via HTTP basic auth or a simple session token. Uses service key. Fields match the `sites` table exactly, with the addition of auto-population of derived fields.

The coordinator registration form does the following on submission:
1. Validates that the site code is not already in use
2. Inserts the new site row to `sites` - the `status_update_key` is auto-generated by the database
3. Fetches the generated `status_update_key` from the inserted row
4. Displays a confirmation screen showing: site code, facilitator code, status update key, and a pre-drafted welcome email ready to copy and send to the facilitator
5. Provides a link to download the sixteen QR code cards for the site - generated on the fly from the site code, cohort, and week number

The confirmation screen pre-drafts the facilitator welcome email in a copyable text block:

```
Subject: Through Two Sets of Eyes - Your site is registered

Hi [FacilitatorName],

Your Through Two Sets of Eyes project is registered. Here are your details:

Site code: [SITE_CODE]
Facilitator code: [FAC_CODE]
Status update key: [STATUS_UPDATE_KEY]

Your status update link:
[STATUS_UPDATE_FORM_URL]?site=[SITE_CODE]&key=[STATUS_UPDATE_KEY]

Your QR code cards are attached - print these before Week 1.
One set for each cohort, one card per week.

The Facilitator Guide is available at:
[KIT_DOWNLOAD_URL]

Please read it before your Phase 0 orientation session.

Welcome to the project.
[COORDINATOR_NAME]
```

**QR code generation:**

QR codes are generated client-side using the `qrcode.js` library - no server-side code required. Each QR code encodes the participant image submission form URL with site code, week number, and cohort as URL parameters:

```
https://[form-page-url]?site=CYG001&week=3&cohort=youth
```

The coordinator registration confirmation page generates all sixteen QR codes automatically and presents them as a print-ready A4 PDF - eight cards per page, one page per cohort. Each card shows the project name, week number, prompt text, and the QR code. The PDF is generated client-side using the `jsPDF` library.

Print specifications for QR code cards are in `infrastructure/supabase/README.md`.

**Hosting the form pages:**

All public-facing forms can be hosted as WordPress pages using a custom HTML block. The coordinator registration form must be on a password-protected WordPress page or in a password-protected subdirectory on the hosting server.

Recommended page structure on WordPress:

```
/submit/swemwbs          - SWEMWBS data entry (public)
/submit/images           - Participant image submission (public)
/submit/session-notes    - Session notes (public)
/submit/completion       - Site completion (public)
/submit/status           - Site status update (public)
/coordinator/register    - Site registration (password protected)
```

- [ ] Participant image submission form built and tested
- [ ] SWEMWBS data entry form built and tested
- [ ] Session notes form built and tested
- [ ] Site completion form built and tested
- [ ] Site status update form built and tested
- [ ] Coordinator site registration form built and tested
- [ ] QR code card generation working and print-ready PDF output confirmed
- [ ] Welcome email pre-draft displaying correctly on confirmation screen
- [ ] All public forms accessible at `/submit/` URLs
- [ ] Coordinator form password protected and accessible at `/coordinator/register`
- [ ] QR code generation process documented in `infrastructure/supabase/README.md`

---

### C6. Test the complete data flow

Before going live, test each form end to end using the pilot site code CYG001.

**Test sequence:**

1. Insert a test site registration via Supabase Table Editor:
```sql
INSERT INTO sites (
    site_code, facilitator_code,
    facilitator_name, facilitator_email,
    town_suburb, state_territory, country
) VALUES (
    'TEST001', 'FACTEST',
    'Test Facilitator', 'test@example.com',
    'Test Town', 'Tasmania', 'Australia'
);
```

2. Submit a test SWEMWBS form - confirm row appears in `swemwbs_surveys` with correct raw total and metric score

3. Submit a test image via the participant submission form - confirm file appears in `submissions` bucket and metadata row in `image_submissions` with `moderation_status = 'pending'`

4. Approve the test image via Table Editor - set `moderation_status = 'approved'`, `gallery_published = true` - confirm image appears in `public_gallery` view

5. Copy the test image to the `gallery` bucket manually via Supabase Storage browser - confirm it appears at the expected public URL

6. Submit a test session notes form - confirm row in `session_notes`

7. Submit a test site completion form - confirm row in `site_completions`, confirm confirmation email received

8. Submit a test status update - confirm `status` field updated in `sites` table

9. Delete all test data:
```sql
DELETE FROM site_completions WHERE site_code = 'TEST001';
DELETE FROM session_notes WHERE site_code = 'TEST001';
DELETE FROM image_submissions WHERE site_code = 'TEST001';
DELETE FROM swemwbs_surveys WHERE site_code = 'TEST001';
DELETE FROM sites WHERE site_code = 'TEST001';
```

- [ ] All seven test flows completed successfully
- [ ] Test data deleted

---

## Phase D: Content

*Estimated time: ongoing*
*Can proceed in parallel with Phase B once the repo structure exists*

---

### D1. Core repository files

- [ ] README.md written
- [ ] CONTRIBUTING.md written
- [ ] CHANGELOG.md initialised

---

### D2. Kit documents

Write each kit document from its specification in `spec/`. Priority order:

1. `kit/facilitator-guide/facilitator-guide.md`
2. `kit/prompt-cards/` - prompt-cards.md and print-ready files
3. `kit/consent-templates/` - all three templates
4. `kit/swemwbs-pack/` - all five documents
5. `kit/exhibition-guide/exhibition-guide.md`
6. `kit/image-submission-guide/image-submission-guide.md`
7. `kit/data-submission-guide/data-submission-guide.md`

*Note: This is the phase where Claude Code with agents and skills will save significant time. The specification documents in `spec/` are stable enough to use as source material for generating first drafts.*

- [ ] All kit documents written

---

### D3. Infrastructure documentation

- [ ] `infrastructure/wordpress/README.md` - WordPress rebuild guide
- [ ] `infrastructure/wordpress/plugins.md` - plugin configuration notes
- [ ] `infrastructure/supabase/README.md` - Supabase setup guide and QR code generation process
- [ ] `infrastructure/supabase/schema.sql` - complete schema as applied
- [ ] `infrastructure/supabase/policies.sql` - RLS and storage policies as applied
- [ ] `infrastructure/backup/README.md` - backup and restoration guide
- [ ] `adaptations/README.md` - adaptation contribution guide
- [ ] `translations/README.md` - translation contribution guide

---

### D4. Update HANDOVER.md with real details

Once Phases B and C are complete:

- [ ] WordPress admin URL added
- [ ] Project domain URL added
- [ ] Supabase project URL confirmed
- [ ] All `[to be confirmed]` placeholders replaced
- [ ] Section 8 (Infrastructure Setup Status) removed from HANDOVER.md

---

## Phase E: Pilot

*The pilot is the project itself - run as a real site, not a test.*

---

### E1. Register the pilot site

Complete the site registration form on the WordPress site as a real facilitator would. Insert the registration into Supabase manually after review.

Pilot site code: `CYG001`

- [ ] Pilot site registered via WordPress CF7 form
- [ ] Registration inserted to Supabase `sites` table
- [ ] QR code card set generated for CYG001 - sixteen cards, eight per cohort
- [ ] Site appears on WordPress project map

---

### E2. Run the pilot

Eight weeks plus Phase 0 preparation. Document everything that doesn't work as GitHub Issues during the run.

- [ ] Phase 0 completed
- [ ] Weeks 1-8 completed
- [ ] Week 8 closing event held
- [ ] Post-project SWEMWBS collected

---

### E3. Submit pilot data

Complete the site completion form as a real facilitator would.

- [ ] Site Completion form submitted
- [ ] Data confirmed in Supabase `site_completions`
- [ ] Images confirmed in `gallery` bucket and WordPress gallery
- [ ] Site status updated to Completed on project map

---

### E4. Review and release

- [ ] Pilot GitHub Issues reviewed and resolved
- [ ] Kit documents updated from pilot learnings
- [ ] Second org owner recruited
- [ ] V1.0 tagged in GitHub
- [ ] Public launch announced on WordPress News page

---

## You're Done

If every checkbox in this document is ticked, the project is live and HANDOVER.md is the document that matters from here.

Archive this document - move it to `spec/` or a `history/` directory - so it doesn't clutter the root of the repository for future contributors.

---

*End of SETUP.md v0.2 draft*

*Next review: on completion of Phase B, to add WordPress details*

