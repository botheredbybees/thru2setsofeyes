# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Is

This is the scratchpad/planning repository (`botheredbybees/thru2setsofeyes`) for the *Through Two Sets of Eyes* open-source intergenerational community photography project. The production repository will live at `github.com/thru2setsofeyes/kit` once the infrastructure is complete.

There is no build system, test suite, or package manager. The repository contains:
- Planning and specification documents (`docs/planning/`)
- Supabase SQL schema and RLS policies (`infrastructure/supabase/`)
- Coordinator and setup guides (`HANDOVER.md`, `SETUP.md`, `TIMELINE.md`)

## Architecture: Three Decoupled Platforms

The project runs across three platforms, deliberately independent — a failure in any one does not affect the others:

**GitHub** (`github.com/thru2setsofeyes/kit`)
Kit documents, version history, issue tracking, contributor wiki. Facilitators raise support questions here.

**WordPress** (self-hosted on sidewalkcircus.org/Bluehost, PHP 8.2)
Public-facing website only. Holds no structured project data. Dynamic content (gallery, map, dashboard) is fetched from Supabase via the Supabase JavaScript client library embedded in WordPress pages. Key plugins: Contact Form 7, FooGallery, Leaflet Maps Marker, UpdraftPlus (backup to Backblaze B2), WP Mail SMTP (via Brevo).

**Supabase** (`https://mybqgaimdeluvgjegmmj.supabase.co`)
PostgreSQL 15, file storage, REST API, coordinator authentication. All structured project data lives here.

## Supabase Schema

Six tables, four views. Schema source of truth: `infrastructure/supabase/schema.sql`. RLS and storage policies: `infrastructure/supabase/policies.sql`. Running these two files in sequence on a fresh Supabase project recreates the entire database.

**Tables:**
- `sites` — master site registry; `status_update_key` (64-char hex, auto-generated) allows facilitators to update their site status without authentication
- `swemwbs_surveys` — SWEMWBS wellbeing responses; unique per `(site_code, participant_code, survey_interval)`
- `image_submissions` — participant photo metadata with moderation workflow (`pending` → `approved`/`rejected`); unique per `(site_code, participant_code, week_number)`
- `session_notes` — facilitator weekly notes; unique per `(site_code, week_number)`
- `site_completions` — post-project completion data; one per site
- `swemwbs_conversion` — static 29-row lookup table mapping raw SWEMWBS scores (7–35) to metric scores per Tennant et al. (2007)

**Views:**
- `public_dashboard` — aggregate SWEMWBS statistics; public access
- `public_site_map` — site registry for the Leaflet map; respects `venue_name_public_ok` flag
- `public_gallery` — approved, published images only; no PII
- `moderation_queue` — pending submissions; `REVOKE`d from `anon` and `public`, `GRANT`ed to `authenticated` only

**RLS summary:** All tables allow anon INSERT (forms submit without login). `swemwbs_conversion` allows anon SELECT. No anon SELECT on any other table. Authenticated role has full access.

## Storage Buckets

- `submissions` (private) — participant images land here; anon INSERT only; coordinator reads for moderation
- `gallery` (public) — coordinator-approved images copied here; served directly from bucket URLs in WordPress gallery
- File path convention: `[site_code]/week-[n]/[site_code]-w[n]-[participant_code].[ext]`

## Key Data Flows

**Site registration:** CF7 WordPress form → email to coordinator → coordinator inserts to `sites` table manually → coordinator emails facilitator with site code, facilitator code, and status update key

**Image submission:** Participant scans QR code → browser form uploads directly to `submissions` bucket → JavaScript inserts metadata to `image_submissions` with `moderation_status = 'pending'`

**SWEMWBS entry:** Facilitator form → validates site/facilitator codes → calculates raw total → looks up metric score from `swemwbs_conversion` → inserts to `swemwbs_surveys`

**Image moderation:** Coordinator reviews `moderation_queue` view → resizes approved image → copies to `gallery` bucket → updates `moderation_status = 'approved'` and `gallery_published = true`

## Form Pages (to be built)

All data collection forms are standalone HTML pages using the Supabase JavaScript client library, hosted as WordPress custom pages. The anon key is intentionally public (RLS enforces access at the database layer). The coordinator registration form uses the service key and must be password-protected.

Public forms at `/submit/`: `swemwbs`, `images`, `session-notes`, `completion`, `status`
Coordinator form at `/coordinator/register` (password protected)

QR codes are generated client-side using `qrcode.js`; print-ready A4 PDFs use `jsPDF`. Each QR code encodes the image submission URL with `site`, `week`, and `cohort` as URL parameters.

## Key Design Constraints

- **Anon insert is intentional** — facilitators and participants do not create accounts; application-layer validation (site code existence, participant code format) supplements RLS
- **No application backend** — all logic runs in client-side JavaScript against the Supabase REST API
- **`status_update_key` validation is application-layer** — the RLS `UPDATE` policy on `sites` is permissive; the form page must validate the key before submitting
- **SWEMWBS metric scores** are never calculated independently — always look up from `swemwbs_conversion`; the mapping is a validated psychometric instrument (Tennant et al., 2007)
- **Safeguarding-sensitive fields** (`safeguarding_incident`, `safeguarding_detail` in `site_completions`) must be excluded from all public-facing queries

## Infrastructure Status

- **Complete:** Supabase schema, RLS, storage buckets, SWEMWBS conversion table
- **Remaining:** WordPress setup (Phase B), remaining Supabase config — bucket MIME/size limits, custom SMTP, form pages (Phase C), content/kit documents (Phase D), pilot (Phase E)

See `TIMELINE.md` for full project history and `SETUP.md` for the sequenced setup checklist.

## Security Notes

- **Anon key**: safe to embed in client-side JavaScript; rotate via Supabase dashboard if compromised, then update all form pages
- **Service key**: never in client-side code; coordinator scripts only; stored in Bitwarden
- WordPress backup (UpdraftPlus) and Supabase backup (`pg_dump`) are independent — restoring one does not affect the other
