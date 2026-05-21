# HANDOVER.md

## Through Two Sets of Eyes - Project Coordinator Handover Guide

**Version:** 0.1 draft - May 2026
**Status:** Pre-infrastructure - URLs and credentials to be updated during setup phases B and C
**Maintained by:** Peter Shanks (botheredbybees@gmail.com)
**Review due:** Annually, or immediately before any change of coordinator

---

## 1. What This Document Is

This document is written for the person taking over as project coordinator for *Through Two Sets of Eyes*. It assumes you have goodwill and basic computer literacy but no prior involvement with the project. It is not a quick-start guide - read it all the way through before doing anything.

If the current coordinator is unavailable and you are reading this in an emergency, start with Section 6 (Emergency Contacts and Escalation) before anything else.

---

## 2. What the Project Is

*Through Two Sets of Eyes* is an open-source kit for running intergenerational community photography projects. Two cohorts - younger people and older adults - respond to identical weekly photographic prompts and display their images publicly in a paired exhibition, without attribution, until a Week 8 reveal event where they meet for the first time.

The coordinator role has two functions:

**Infrastructure maintenance** - keeping the WordPress site, GitHub repository, and Google Workspace running and backed up.

**Active coordination** - supporting registered sites through their eight-week projects, reviewing image submissions, curating the public gallery, and managing data.

In the early life of the project these two functions are held by the same person. As the project grows they may separate - infrastructure maintenance to a technical volunteer, active coordination to someone with a community arts background.

The full project specification lives at:
`github.com/thru2setsofeyes/kit/spec/specification.md`

Read it before your first week as coordinator. It is the source of truth for every design decision.

---

## 3. The Three Platforms

The project runs across three platforms. You need access to all three.

### 3.1 GitHub

**Organisation:** `github.com/thru2setsofeyes`
**Primary repository:** `github.com/thru2setsofeyes/kit`
**Your role:** Organisation owner

GitHub holds the kit documents, version history, issue tracker, and contributor wiki. Facilitators raise support questions here. Kit updates are published here as releases.

**Weekly tasks:** Check open Issues for facilitator questions requiring a response. Aim to respond within 48 hours.

**As-needed tasks:** Review and merge pull requests for kit contributions. Tag new releases when kit documents are updated. Update the Wiki when an Issue generates a useful resolved answer.

**Critical requirement:** The organisation must have a minimum of two owners at all times. If you are the only owner, recruiting a second owner is your first priority. Instructions for adding an org owner are at `https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/maintaining-ownership-continuity-for-your-organization`.

---

### 3.2 WordPress Site

**URL:** `[thru2setsofeyes.org - to be confirmed at launch]`
**Hosting:** Sidewalkcircus.org server - Hostmonster/Bluehost shared hosting
**Admin URL:** `[URL]/wp-admin`
**Admin credentials:** See Section 5

The WordPress site is the public face of the project. It hosts the image gallery, project map, facilitator forum, site registration form, and public data dashboard.

**Weekly tasks:**
- Review participant image submissions from the Google Drive folder (see 3.3) and upload approved images to the gallery
- Update site status pins on the project map for any sites that have submitted a status update
- Check for plugin updates in wp-admin - apply minor updates immediately, test major updates on a staging copy first

**Monthly tasks:**
- Verify UpdraftPlus backup has run successfully - check the backup log in wp-admin under Settings > UpdraftPlus
- Confirm the most recent backup file exists in Backblaze B2 remote storage (see Section 5 for credentials)
- Update the public data dashboard from the master Google Sheet

**Plugin inventory:**

| Plugin | Purpose | Update sensitivity |
|---|---|---|
| Contact Form 7 | Site registration and contact forms | Low |
| User Submitted Posts | Facilitator community contributions | Low |
| FooGallery | Public image gallery | Medium |
| Leaflet Maps Marker | Project site map | Low |
| WP Super Cache | Page caching | Low |
| UpdraftPlus | Automated backups | High - test before updating |
| Wordfence | Security | High - update promptly |
| WP Mail SMTP | Email delivery | Low |
| WP Data Access | Data dashboard | Medium |

*Update sensitivity guide: Low - update when convenient. Medium - update within a week of release. High - update within 48 hours for security plugins; test on staging for backup plugins before applying to production.*

**If the WordPress site goes down:**
1. Check Hostmonster/Bluehost server status at `https://www.bluehost.com/help/network-status`
2. If the server is up but the site is down, check Wordfence logs for a security block
3. If you cannot resolve it within an hour, restore from the most recent UpdraftPlus backup
4. Restoration instructions are in `infrastructure/backup/README.md` in the kit repository

---

### 3.3 Google Workspace

**Project Google account:** `[thru2setsofeyes@gmail.com - to be confirmed]`
**Credentials:** See Section 5

Google Workspace holds all project data - SWEMWBS scores, image submissions, site registrations, session notes, and site completion forms. It is the data backbone of the project.

**The five Google Forms and their Sheet tabs:**

| Form | Completed by | Sheet tab | Notes |
|---|---|---|---|
| Form 1 - SWEMWBS Data Entry | Facilitators | SWEMWBS | One row per participant per timepoint |
| Form 2 - Participant Image Submission | Participants | Images | Images stored in linked Drive folder |
| Form 3 - Site Registration | Prospective facilitators | Registrations | Triggers coordinator notification email |
| Form 4 - Site Completion | Facilitators post Week 8 | Completions | Includes session notes file upload |
| Form 5 - Session Notes | Facilitators weekly | SessionNotes | Lightweight weekly check-in |

**Master Google Sheet URL:** `[to be confirmed at launch]`

**Google Drive image submissions folder:** `submissions/` - organised automatically by site code and week number via Apps Script

**Weekly tasks:**
- Open the `submissions/` Drive folder and review the current week's image submissions for safeguarding concerns
- Prepare print-ready image files (resize to maximum 1200px on longest edge) and email to the relevant facilitator within 24 hours of submission review
- Upload approved images to the WordPress gallery, tagged with site, week, prompt, cohort, and caption

**As-needed tasks:**
- Review new site registrations (Form 3) and respond within 48 hours - assign site code and facilitator code, generate QR code card set, add site to WordPress project map
- Review site completion submissions (Form 4) and acknowledge receipt

**Monthly tasks:**
- Confirm the Apps Script monthly CSV export has run - check the backup folder in Google Drive for a file dated within the last 30 days
- Export submitted images via Google Takeout as a monthly backup

**If a facilitator reports missing SWEMWBS data:**
1. Check the SWEMWBS Sheet tab for the site code and participant code
2. If the row exists, the data was received - confirm with the facilitator
3. If the row is missing, ask the facilitator to re-enter from their paper forms using Form 1
4. If paper forms are also lost, record the gap in the site's completion record with a note

---

## 4. Weekly and Monthly Coordinator Schedule

### Weekly (during active project season)

The project runs in eight-week cycles. When one or more sites are active, the following applies:

**Within 24 hours of each site's session day:**
- Review image submissions in Google Drive `submissions/` folder
- Check for safeguarding concerns - if any found, do not proceed to print; contact the facilitator directly
- Prepare print-ready files and email to facilitator
- Upload images to WordPress gallery

**Within 48 hours of session day:**
- Respond to any new GitHub Issues from facilitators
- Check Form 5 session notes for anything requiring follow-up

**End of each week:**
- Update project map status pins for any sites that have submitted a status change

### Monthly (year-round)

- Verify UpdraftPlus backup log - confirm successful run
- Verify Backblaze B2 remote storage contains recent backup files
- Confirm Apps Script CSV export has run
- Export Google Drive image submissions via Takeout
- Update public data dashboard from master Sheet
- Review GitHub Issues for anything unresolved beyond two weeks
- Check all WordPress plugins for available updates

### Annually

Run the Minimum Viable Continuity Test (full checklist in Section 3.5 of the platform architecture specification):
- WordPress site accessible, all plugins current
- UpdraftPlus backup confirmed successful in the past seven days
- Monthly Sheet export running and accumulating
- At least one other person has independent access to backup storage
- This HANDOVER.md file reflects current reality - update anything that has changed
- GitHub organisation has at least two active owners

---

## 5. Credentials and Access

**This section intentionally contains no credentials.** Credentials are stored in `[password manager name and location - to be confirmed]`, shared with `[second coordinator name - to be confirmed]`.

The following accounts exist and their credentials must be in the password manager:

| Account | Purpose | URL |
|---|---|---|
| GitHub org owner | Kit repository and issue tracking | github.com/thru2setsofeyes |
| WordPress admin | Site administration | [thru2setsofeyes.org/wp-admin] |
| Hostmonster/Bluehost | Hosting account and server access | bluehost.com |
| Google project account | All data collection | gmail.com |
| Backblaze B2 | Remote backup storage | backblaze.com |
| Brevo | Transactional email | brevo.com |
| Domain registrar | DNS management for thru2setsofeyes.org | [to be confirmed] |

**Transferring access to a new coordinator:**

1. Add the new coordinator as a GitHub org owner before removing yourself
2. Add the new coordinator as a WordPress admin before removing yourself
3. Share the password manager credentials directly - do not email passwords
4. Transfer the Hostmonster/Bluehost account if you are the account holder - instructions at `[hosting provider transfer URL]`
5. Transfer the Google account credentials - the new coordinator should change the password immediately on receipt
6. Update this document with the new coordinator's name and contact details
7. Run the Minimum Viable Continuity Test together before the handover is complete

---

## 6. Emergency Contacts and Escalation

**If you cannot access the WordPress site:**
- Check Hostmonster/Bluehost server status first
- Restore from UpdraftPlus backup if needed - instructions in `infrastructure/backup/README.md`
- If you cannot restore within 24 hours, post a notice on the GitHub repository README

**If you cannot access the Google project account:**
- Google account recovery requires access to the recovery email or phone - these are documented in the password manager
- The master Sheet data is backed up monthly as CSV in Google Drive and in Backblaze B2 - no data is permanently lost if the account is inaccessible temporarily

**If a safeguarding concern arises from an image submission:**
- Do not upload the image to the WordPress gallery
- Do not email the image to the facilitator
- Contact the facilitator directly by email or phone - contact details are in the Site Registration Sheet tab
- Ask the facilitator to follow their local mandatory reporting obligations
- Document the incident in a private note in the Site Completion Sheet tab
- Do not record identifying details of the participant in any shared document

**If a facilitator reports a participant in crisis:**
- This is outside the coordinator role - direct the facilitator to their local emergency services and their own organisation's safeguarding lead
- The coordinator is not a crisis service and should not attempt to be one

**If the project founder is unavailable:**
- The specification, this document, and the kit are sufficient to continue the project without the founder
- Raise questions as GitHub Issues - the community of facilitators and contributors is the ongoing knowledge base
- If no second coordinator exists, post a call for volunteers as a GitHub Issue and on the WordPress site news page

---

## 7. What Good Coordination Looks Like

The coordinator role is mostly invisible when it is working well. Facilitators get responses within 48 hours. Images appear in the gallery within a week of submission. The WordPress site loads quickly. Backups run quietly in the background. The annual continuity test passes without drama.

The moments that require more active coordination are:

- A new site registers - assign codes, generate QR cards, welcome the facilitator warmly, answer their first questions patiently. Their first impression of the project is their impression of you.
- A safeguarding concern arises - act promptly and carefully. The guidance in Section 6 is the minimum. Use your judgement.
- A facilitator goes quiet mid-project - reach out gently after two missed weekly session notes. Most of the time there is a simple explanation. Occasionally a project is in trouble and early contact makes the difference.
- A kit improvement is obvious - raise it as a GitHub Issue yourself. You are the person closest to how the kit performs in practice.

The project exists to generate evidence that intergenerational community arts improves wellbeing. Every completed site that submits data is a contribution to that argument. Your job is to make it as easy as possible for facilitators to complete their projects and submit their data, and to make sure the infrastructure survives long enough for the evidence to accumulate.

---

## 8. Infrastructure Setup Status

*This section tracks what has been built and what remains. Update it as each item is completed. Delete this section once the project is fully operational and replace with a simple note: "Infrastructure setup completed [date]."*

**Phase A - Accounts and credentials**
- [x] GitHub org `thru2setsofeyes` created
- [ ] Project Google account created
- [ ] Password manager set up with all project credentials
- [ ] Second GitHub org owner added
- [ ] `github.com/thru2setsofeyes/kit` repository created

**Phase B - WordPress**
- [ ] WordPress Multisite decision made - Multisite conversion or separate subdirectory
- [ ] Through Two Sets of Eyes subsite created
- [ ] Required plugins installed and configured
- [ ] Site structure built - pages, menus, gallery, map
- [ ] CF7 forms configured
- [ ] WP Mail SMTP configured with Brevo
- [ ] UpdraftPlus configured with Backblaze B2

**Phase C - Google Workspace**
- [ ] Five Google Forms created
- [ ] Master Google Sheet created with formula columns
- [ ] Four Google Apps Scripts written and tested
- [ ] Initial QR code card sets generated for pilot site

**Phase D - Content**
- [ ] Planning docs migrated from `botheredbybees` to org repo
- [ ] README.md, CONTRIBUTING.md, CHANGELOG.md written
- [ ] Kit documents written from specification
- [ ] HANDOVER.md updated with real URLs and credentials inventory

**Phase E - Pilot**
- [ ] Cygnet registered as first site
- [ ] Pilot project run
- [ ] Pilot data submitted
- [ ] Second org owner recruited
- [ ] V1.0 released

---

*End of HANDOVER.md v0.1 draft*

*Next review: on completion of Phase B, to add real URLs throughout*

---
