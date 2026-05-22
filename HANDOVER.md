# HANDOVER.md

## Through Two Sets of Eyes - Project Coordinator Handover Guide

**Version:** 0.2 draft - May 2026
**Status:** Pre-launch - placeholders to be updated as infrastructure is completed
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

**Infrastructure maintenance** - keeping the WordPress site, GitHub repository, and Supabase database running and backed up.

**Active coordination** - supporting registered sites through their eight-week projects, reviewing image submissions, curating the public gallery, and managing data.

The full project specification lives at:
`github.com/thru2setsofeyes/kit/spec/specification.md`

Read it before your first week as coordinator.

---

## 3. The Three Platforms

The project runs across three platforms. You need access to all three.

### 3.1 GitHub

**Organisation:** `github.com/thru2setsofeyes`
**Primary repository:** `github.com/thru2setsofeyes/kit`
**Your role:** Organisation owner

GitHub holds the kit documents, version history, issue tracker, and contributor wiki. Facilitators raise support questions here. Kit updates are published here as releases.

**Weekly tasks:** Check open Issues for facilitator questions. Aim to respond within 48 hours.

**As-needed tasks:** Review and merge pull requests. Tag new releases when kit documents are updated. Update the Wiki when an Issue generates a useful resolved answer.

**Critical requirement:** The organisation must have a minimum of two owners at all times. If you are the only owner, recruiting a second owner is your first priority. Instructions for adding an org owner:
`https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/maintaining-ownership-continuity-for-your-organization`

---

### 3.2 WordPress Site

**URL:** `[thru2setsofeyes.org - to be confirmed at launch]`
**Hosting:** Sidewalkcircus.org server - Hostmonster/Bluehost shared hosting
**Admin URL:** `[URL]/wp-admin`
**Admin credentials:** See Section 5
**PHP version:** 8.2

WordPress handles only public-facing content. All structured project data lives in Supabase. WordPress pages fetch from Supabase via the JavaScript client library where dynamic content is needed.

**Weekly tasks:**
- Check User Submitted Posts moderation queue for new facilitator contributions - approve or reject
- Check GitHub Issues for facilitator questions requiring a response
- Update site status pins on the project map for any sites that have submitted a status update via the CF7 status form
- Check for WordPress plugin updates in wp-admin - apply minor updates immediately

**Monthly tasks:**
- Verify UpdraftPlus backup has run successfully - check backup log in wp-admin > Settings > UpdraftPlus
- Confirm most recent backup file exists in Backblaze B2
- Check that the public data dashboard is displaying current statistics from Supabase

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
| WP Mail SMTP | Email delivery via Brevo | Low |

*Update sensitivity: Low - update when convenient. Medium - within a week. High - within 48 hours for security plugins; test on staging for UpdraftPlus before applying to production.*

**If the WordPress site goes down:**
1. Check Hostmonster/Bluehost server status at `https://www.bluehost.com/help/network-status`
2. If server is up but site is down, check Wordfence logs for a security block
3. If unresolvable within an hour, restore from most recent UpdraftPlus backup
4. Restoration instructions: `infrastructure/backup/README.md` in the kit repository
5. Note: restoring WordPress does not affect Supabase - the database is independent

---

### 3.3 Supabase

**Project URL:** `https://mybqgaimdeluvgjegmmj.supabase.co`
**Dashboard:** `https://supabase.com/dashboard/project/mybqgaimdeluvgjegmmj`
**Credentials:** Supabase anon key and service key in Bitwarden. See Section 5.

Supabase holds all structured project data - SWEMWBS scores, image metadata, site registrations, session notes, and site completion records. It also holds the two image storage buckets.

**The two keys and what they do:**

*Anon key* - low-privilege public key embedded in form pages. Allows anonymous inserts to data tables and uploads to the `submissions` bucket. Safe to include in client-side JavaScript. Rotate if compromised.

*Service key* - full database access. Never included in client-side code. Used only for coordinator scripts and any server-side automation. Keep in Bitwarden only.

**Weekly tasks - image moderation:**
1. Sign into the Supabase dashboard
2. Go to Table Editor > `image_submissions` and filter by `moderation_status = pending`
   - or run: `SELECT * FROM moderation_queue ORDER BY submitted_at ASC`
3. For each pending submission:
   - Open the image from Storage > `submissions` bucket
   - Check for safeguarding concerns - if any found, do not proceed, contact facilitator directly
   - If approved: resize image to maximum 1200px longest edge, copy to `gallery` bucket using the same file path convention, then update the row:
     ```sql
     UPDATE image_submissions
     SET moderation_status = 'approved',
         gallery_published = true,
         gallery_published_at = NOW(),
         moderated_at = NOW()
     WHERE id = [submission_id];
     ```
   - If rejected: update the row:
     ```sql
     UPDATE image_submissions
     SET moderation_status = 'rejected',
         moderation_notes = '[reason]',
         moderated_at = NOW()
     WHERE id = [submission_id];
     ```
4. Email print-ready files to the relevant facilitator within 24 hours of approval

**Weekly tasks - site registrations:**
1. Check email for new CF7 site registration submissions
2. Review each registration for completeness
3. If approved, assign site code and facilitator code, then insert to Supabase:
   ```sql
   INSERT INTO sites (
       site_code, facilitator_code,
       facilitator_name, facilitator_email,
       town_suburb, state_territory, country,
       location_type, organisation,
       proposed_start_date, proposed_session_day,
       venue_type, venue_name,
       cofacilitator_name, cofacilitator_role,
       cofacilitator_org, cofacilitator_bgcheck,
       target_cohort_size,
       youth_recruitment, older_adult_recruitment,
       confirmed_venue, confirmed_cofacilitator,
       read_facilitator_guide,
       data_submission_agreed, data_handling_agreed
   ) VALUES (
       '[SITE_CODE]', '[FAC_CODE]',
       -- fill remaining values from CF7 submission
   );
   -- check that it worked
    SELECT status_update_key FROM sites WHERE site_code = '[SITE_CODE]';
   ```
4. Generate sixteen QR code cards for the site - instructions in `infrastructure/supabase/README.md`
5. Email the facilitator: site code, facilitator code, status update key, QR code cards

**Monthly tasks:**
- Run `pg_dump` backup and store in Backblaze B2:
  ```bash
  pg_dump \
    "postgresql://postgres:[PASSWORD]@db.mybqgaimdeluvgjegmmj.supabase.co:5432/postgres" \
    --no-owner --no-acl \
    -f thru2setsofeyes-backup-$(date +%Y-%m-%d).sql
  ```
- Export `gallery` bucket contents via Supabase Storage > Download and store in Backblaze B2
- Check Supabase dashboard > Settings > Backups to confirm automatic daily backups are running
- Review `site_completions` for any new entries requiring data review - set `data_review_complete = true` when done

**If Supabase becomes inaccessible:**
- The automatic daily backup (7-day retention) can be restored by Supabase support
- The monthly `pg_dump` file in Backblaze B2 can restore to any PostgreSQL 15 instance
- Image files in the `gallery` bucket are also backed up monthly to Backblaze B2
- Migration procedure if Supabase is permanently unavailable: see Section 3.5 of the platform architecture specification

---

## 4. Weekly and Monthly Coordinator Schedule

### Weekly (during active project season)

When one or more sites are active the following applies. The session day varies by site - check the `proposed_session_day` field in the `sites` table for each active site.

**Within 24 hours of each site's session day:**
- Check `moderation_queue` for new image submissions
- Review for safeguarding concerns before any other action
- Approve and prepare print-ready files
- Email print-ready files to facilitator
- Upload approved images to `gallery` bucket and update `image_submissions` table

**Within 48 hours of session day:**
- Respond to any new GitHub Issues from facilitators
- Check CF7 site registration inbox for new registrations

**End of each week:**
- Update project map status pins for any status change submissions received

### Monthly (year-round)

- Run `pg_dump` backup and upload to Backblaze B2
- Export `gallery` bucket to Backblaze B2
- Verify UpdraftPlus WordPress backup in Backblaze B2
- Confirm Supabase automatic backups running in dashboard
- Review `site_completions` for entries requiring coordinator review
- Check all WordPress plugins for updates
- Review GitHub Issues for anything unresolved beyond two weeks

### Annually

Run the Minimum Viable Continuity Test:
- WordPress site accessible, all plugins current
- UpdraftPlus backup confirmed successful in past seven days
- Backblaze B2 contains recent WordPress backup files
- Supabase automatic backups confirmed in Settings > Backups
- Monthly `pg_dump` file dated within past 35 days exists in B2
- Monthly `gallery` bucket export dated within past 35 days exists in B2
- `infrastructure/supabase/schema.sql` matches the current live schema - verify by comparing with Supabase Table Editor
- GitHub organisation has at least two active owners
- HANDOVER.md reflects current reality - update anything that has changed

---

## 5. Credentials and Access

**This section intentionally contains no credentials.** All credentials are stored in `[password manager name and location - to be confirmed]`, shared with `[second coordinator name - to be confirmed]`.

The following accounts exist and their credentials must be in the password manager:

| Account | Purpose | URL |
|---|---|---|
| GitHub org owner | Kit repository and issue tracking | github.com/thru2setsofeyes |
| WordPress admin | Site administration | [thru2setsofeyes.org/wp-admin] |
| Hostmonster/Bluehost | Hosting account and server access | bluehost.com |
| Supabase project | Database and storage | supabase.com/dashboard |
| Supabase anon key | Embedded in form pages | See Supabase > Settings > API |
| Supabase service key | Coordinator scripts only - never in client code | See Supabase > Settings > API |
| Backblaze B2 | Remote backup storage | backblaze.com |
| Brevo | Transactional email for WordPress and Supabase | brevo.com |
| Domain registrar | DNS management | [to be confirmed] |

**Rotating the Supabase anon key:**

If the anon key is compromised or accidentally published:
1. Supabase dashboard > Settings > API > Regenerate anon key
2. Update the key in every form page that includes it
3. Update the key in Bitwarden
4. Note the rotation date in Bitwarden

The service key should never appear in any public-facing code. If it is accidentally committed to GitHub or otherwise exposed, rotate it immediately via the same process and treat any data as potentially compromised.

**Transferring access to a new coordinator:**
1. Add new coordinator as GitHub org owner before removing yourself
2. Add new coordinator as WordPress admin before removing yourself
3. Grant new coordinator access to Supabase project via Settings > Team
4. Share Bitwarden credentials directly - do not email
5. Transfer Hostmonster/Bluehost account if you are the account holder
6. Update this document with new coordinator's name and contact details
7. Run the Minimum Viable Continuity Test together before handover is complete

---

## 6. Emergency Contacts and Escalation

**If the WordPress site goes down:**
- Check Hostmonster/Bluehost server status first
- Restore from UpdraftPlus backup if needed - `infrastructure/backup/README.md`
- Supabase data is unaffected - the database is independent of WordPress

**If Supabase is inaccessible:**
- Check Supabase status at `https://status.supabase.com`
- If a platform outage, wait - automatic backups mean no data is lost for events under 7 days
- If the project account is inaccessible, recover via account recovery email documented in Bitwarden
- Monthly `pg_dump` backup in Backblaze B2 allows restoration to any PostgreSQL 15 instance
- Form pages will fail while Supabase is inaccessible - post a notice on the WordPress site

**If a safeguarding concern arises from an image submission:**
- Do not approve the image or copy it to the `gallery` bucket
- Do not email the image to the facilitator
- Contact the facilitator directly by phone or email - contact details in the `sites` table
- Ask the facilitator to follow their local mandatory reporting obligations
- Update the `image_submissions` row:
  ```sql
  UPDATE image_submissions
  SET moderation_status = 'rejected',
      moderation_notes = 'Safeguarding concern - coordinator notified facilitator [date]'
  WHERE id = [submission_id];
  ```
- Document the incident privately - not in any shared or public document

**If a facilitator reports a participant in crisis:**
- This is outside the coordinator role
- Direct the facilitator to local emergency services and their organisation's safeguarding lead
- The coordinator is not a crisis service

**If the project founder is unavailable:**
- The specification, this document, and the kit are sufficient to continue the project
- Raise questions as GitHub Issues
- If no second coordinator exists, post a call for volunteers as a GitHub Issue and on the WordPress News page

---

## 7. What Good Coordination Looks Like

The coordinator role is mostly invisible when it is working well. Facilitators get responses within 48 hours. Images appear in the gallery within a week of submission. The WordPress site loads quickly. Backups run quietly. The annual continuity test passes without drama.

The moments that require more active coordination:

- **A new site registers** - respond warmly and promptly. Their first impression of the project is their impression of you. Generate their QR cards and get them in their hands before their Week 1.
- **A safeguarding concern arises** - act promptly and carefully. Section 6 is the minimum. Use your judgement.
- **A facilitator goes quiet mid-project** - reach out gently after two missed weekly session notes. Most of the time there is a simple explanation.
- **A kit improvement is obvious** - raise it as a GitHub Issue. You are the person closest to how the kit performs in practice.
- **The Supabase anon key appears in a public place** - rotate it immediately, do not wait.

The project exists to generate evidence that intergenerational community arts improves wellbeing. Every completed site that submits data is a contribution to that argument. Your job is to make it as easy as possible for facilitators to complete their projects and submit their data, and to make sure the infrastructure survives long enough for the evidence to accumulate.

---

## 8. Infrastructure Setup Status

*This section tracks what has been built and what remains. Update as each item is completed. Delete this section once the project is fully operational and replace with a simple note: "Infrastructure setup completed [date]."*

**Phase A - Accounts and credentials**
- [x] GitHub org `thru2setsofeyes` created
- [x] Supabase project created
- [ ] Password manager set up with all project credentials
- [ ] Second GitHub org owner added
- [ ] `github.com/thru2setsofeyes/kit` repository created

**Phase B - WordPress**
- [ ] WordPress architecture decision made
- [ ] Through Two Sets of Eyes subsite or subdirectory created
- [ ] Required plugins installed and configured
- [ ] Site structure built
- [ ] CF7 forms configured
- [ ] WP Mail SMTP configured with Brevo
- [ ] UpdraftPlus configured with Backblaze B2

**Phase C - Supabase**
- [x] Supabase project created
- [x] Database schema applied
- [x] Storage buckets created with policies
- [x] SWEMWBS conversion table populated
- [x] RLS enabled on all tables
- [x] moderation_queue restricted to authenticated role
- [ ] Bucket file size limits and MIME types set
- [ ] Custom SMTP configured in Supabase
- [ ] Form pages built and tested
- [ ] Complete data flow tested end to end

**Phase D - Content**
- [ ] Planning docs migrated to org repo
- [ ] README.md, CONTRIBUTING.md, CHANGELOG.md written
- [ ] Kit documents written from specification
- [ ] infrastructure/supabase/schema.sql committed
- [ ] infrastructure/supabase/policies.sql committed
- [ ] HANDOVER.md updated with real URLs and credentials

**Phase E - Pilot**
- [ ] Cygnet registered as first site
- [ ] Pilot project run
- [ ] Pilot data submitted
- [ ] Second org owner recruited
- [ ] V1.0 released

---

*End of HANDOVER.md v0.2 draft*

*Next review: on completion of Phase B, to add WordPress URLs and confirm credential storage*

---


