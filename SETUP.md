# SETUP.md

## Through Two Sets of Eyes - Infrastructure Setup Guide

**Version:** 0.1 draft - May 2026
**Status:** Active - work in progress
**Maintained by:** Peter Shanks (botheredbybees@gmail.com)

---

## What This Document Is

This is the step-by-step guide for setting up the *Through Two Sets of Eyes* infrastructure from scratch. It is written for the person doing the initial setup - currently the project founder - but is detailed enough that a technically confident volunteer could follow it.

HANDOVER.md covers maintaining a running project. This document covers getting to running in the first place. Once Phase E is complete and the pilot has run, this document becomes historical record rather than active guidance - keep it in the repository as a reference for anyone who needs to rebuild the infrastructure from scratch.

**Assumed skills:** WordPress administration, basic Google Workspace, GitHub. No programming required for Phases A-D. Phase C (Google Apps Scripts) requires comfort with simple JavaScript - if that is not you, flag it as a task for a technical volunteer before starting Phase C.

**Estimated time:** Phases A-D will take approximately 8-12 hours of focused work spread across several sessions. Phase E is the pilot project itself - eight weeks plus preparation.

---

## Phase A: Accounts and Credentials

*Estimated time: 1-2 hours*
*Do this first. Everything else depends on it.*

---

### A1. Set up a password manager

All project credentials must be stored in a shared password manager from day one. Do not use your personal password manager for project credentials - the project needs to be able to survive a change of coordinator, and credentials stored in a personal account cannot be transferred.

**Recommended option:** Bitwarden
- Free for individual use, low-cost for organisations
- Open source
- Web, desktop, and mobile apps
- Credential sharing works cleanly between org members
- Self-hostable if you want full control later

**Setup steps:**
1. Create a Bitwarden account at `bitwarden.com` using the project Google account email (create that first - see A2)
2. Create a new Collection called "Through Two Sets of Eyes"
3. Add all credentials to this collection as you create them in subsequent steps
4. Share the collection with the second coordinator when recruited

**Alternative:** 1Password, KeePass (self-hosted), or any password manager that supports credential sharing. The specific tool matters less than the discipline of using it consistently.

- [ ] Password manager account created
- [ ] Project credentials collection created
- [ ] Setup instructions documented in password manager notes

---

### A2. Create the project Google account

**Account:** `thru2setsofeyes@gmail.com` - check availability; if taken try `thru2setsofeyes.project@gmail.com` or similar

**Setup steps:**
1. Go to `accounts.google.com/signup`
2. Create the account with a strong password - store immediately in Bitwarden
3. Add a recovery email - use your personal email address for now; update to a second coordinator's email when one is recruited
4. Add a recovery phone number
5. Enable two-factor authentication - use an authenticator app, not SMS if possible. Store the backup codes in Bitwarden.
6. Do not sign up for any Google paid services at this stage

**Services this account will use (all free tier):**
- Gmail - for project coordinator communications
- Google Forms - data collection
- Google Sheets - master data store
- Google Drive - image submission storage and backups
- Google Apps Script - automation

- [ ] Project Google account created
- [ ] Two-factor authentication enabled
- [ ] Recovery details set
- [ ] Credentials stored in Bitwarden

---

### A3. Confirm GitHub organisation ownership

The `thru2setsofeyes` GitHub organisation already exists. Confirm the following:

1. You can access `github.com/thru2setsofeyes` as an owner
2. Create the kit repository: go to the org page, click New Repository, name it `kit`, set to Public, add a README
3. Add a second owner as soon as one is available - this cannot be automated, it requires a human decision. Make a note in the project's GitHub Issues as a reminder

**Repository initialisation:**
1. Clone the new repo locally
2. Copy the planning documents from `botheredbybees/thru2setsofeyes/docs/planning/` into `kit/spec/`
3. Copy HANDOVER.md and SETUP.md to the repo root
4. Create the directory structure from the specification:

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
    ├── google-forms/
    │   ├── README.md
    │   └── form-definitions/
    └── backup/
        └── README.md
```

5. Create stub README.md files in each empty directory so they appear in the repository
6. Write the LICENSE file - MIT licence text is at `https://opensource.org/licenses/MIT` - replace `[year]` with 2026 and `[fullname]` with "Through Two Sets of Eyes Contributors"
7. Commit and push

- [ ] `github.com/thru2setsofeyes/kit` repository created
- [ ] Directory structure initialised
- [ ] Planning docs migrated to `spec/`
- [ ] HANDOVER.md and SETUP.md at repo root
- [ ] LICENSE file added
- [ ] Second org owner - pending recruitment

---

### A4. Domain name

Confirm which domain name will be used for the project site. Current candidates pointing to the sidewalkcircus server:

- `thru2setsofeyes.org` - preferred, check availability
- Alternatives if taken - confirm with project founder

**Steps:**
1. Confirm domain availability and register if not already done
2. Confirm DNS is pointing to the sidewalkcircus server IP
3. Note the domain registrar and credentials in Bitwarden

- [ ] Domain name confirmed
- [ ] DNS pointing to correct server
- [ ] Registrar credentials in Bitwarden

---

## Phase B: WordPress

*Estimated time: 3-4 hours*
*Requires: Hostmonster/Bluehost admin access, domain name confirmed*

---

### B1. Decide on WordPress architecture

Two options:

**Option 1: WordPress Multisite**
Convert the existing sidewalkcircus WordPress installation to Multisite. The Palimpsest Path project becomes the primary subsite. Through Two Sets of Eyes becomes a second subsite reachable at `thru2setsofeyes.org` via domain mapping.

*Recommended if:* You expect to run more projects from the same server. One codebase, one set of updates, shared infrastructure.

*Conversion guide:* `https://developer.wordpress.org/advanced-administration/multisite/create-network/`

*Domain mapping plugin:* Domain Mapping System (free tier) - `https://wordpress.org/plugins/domain-mapping-system/`

**Option 2: Separate subdirectory installation**
Install a second independent WordPress in a subdirectory such as `sidewalkcircus.org/t2soe/` and redirect `thru2setsofeyes.org` to it via your existing PHP redirect script.

*Recommended if:* You want complete separation between projects and are comfortable maintaining two WordPress installations independently.

**Decision:**

- [ ] Architecture decision made: _______________
- [ ] Multisite conversion completed OR subdirectory installation created

---

### B2. Install and configure required plugins

Install each plugin from the WordPress plugin directory (wp-admin > Plugins > Add New) unless otherwise noted.

**Contact Form 7** (already installed on sidewalkcircus - confirm available on new subsite if using Multisite)
- No additional configuration needed at this stage - forms will be built in B4

**User Submitted Posts**
- Settings > User Submitted Posts
- Set submissions to require login: Yes
- Set moderation: All submissions require approval
- Disable all post type fields except: title, content, image upload
- Custom fields will be configured in B4

**FooGallery**
- Install FooGallery from plugin directory
- Settings > FooGallery > General: enable lazy loading
- Custom fields for gallery items (site, week, prompt, cohort, caption) are added via the WordPress custom fields interface - instructions in `infrastructure/wordpress/README.md`

**Leaflet Maps Marker**
- Install from plugin directory
- No API key required - uses OpenStreetMap
- Configure default map centre to Australia for V1.0
- Map pins will be added as sites register

**WP Super Cache**
- Install from plugin directory
- Settings > WP Super Cache: enable caching
- Recommended settings: Simple caching mode, enable compression
- Test that the gallery pages load correctly after enabling - occasionally caching conflicts with gallery plugins

**UpdraftPlus**
- Install from plugin directory
- Settings > UpdraftPlus > Settings:
  - Backup schedule: Daily for database, Weekly for files
  - Remote storage: Backblaze B2 (see B3 for B2 setup)
  - Email notification: project Google account email
- Run a manual backup immediately after configuration and confirm it appears in B2

**Wordfence**
- Install from plugin directory
- Run the setup wizard
- Enable firewall in Learning Mode for the first week, then switch to Enabled
- Set email alerts to the project Google account email
- Enable two-factor authentication for the WordPress admin account

**WP Mail SMTP**
- Install from plugin directory
- Settings > WP Mail SMTP > Setup Wizard
- Select Brevo (formerly Sendinblue) as the mailer
- Create a Brevo account at `brevo.com` using the project Google account email
- Generate a Brevo API key and enter in WP Mail SMTP
- Send a test email to confirm delivery
- Store Brevo credentials in Bitwarden

**WP Data Access**
- Install from plugin directory
- Google Sheets connection will be configured in Phase C after the master Sheet exists

- [ ] All plugins installed
- [ ] UpdraftPlus configured and first backup confirmed
- [ ] Wordfence active
- [ ] WP Mail SMTP sending correctly
- [ ] Brevo credentials in Bitwarden

---

### B3. Set up Backblaze B2 remote storage

1. Create a Backblaze account at `backblaze.com` using the project Google account email
2. Create a new B2 bucket named `thru2setsofeyes-backups` - set to Private
3. Create an application key with read/write access to this bucket only
4. Enter the bucket name, key ID, and application key in UpdraftPlus remote storage settings
5. Run a manual backup and confirm the file appears in the B2 bucket
6. Store B2 credentials in Bitwarden
7. Share bucket access with a second person independently of the primary account - Backblaze supports multiple application keys per bucket

- [ ] Backblaze B2 account created
- [ ] Bucket created
- [ ] UpdraftPlus connected and backup confirmed in B2
- [ ] Credentials in Bitwarden
- [ ] Second person has independent bucket access

---

### B4. Build the site structure

Create the following pages in wp-admin > Pages > Add New. Set the page template to the appropriate layout as you build each section.

**Top-level pages:**
- Home
- About
- Run a Project
- Gallery
- Project Map
- Data
- News
- Contributing

**Child pages:**

Under About:
- What is Through Two Sets of Eyes?
- The evidence base
- Core design principles
- Contact

Under Run a Project:
- Register a site (CF7 form - build in this step)
- Download the kit (links to GitHub releases)
- Facilitator contributions (User Submitted Posts page)

Under Gallery:
- Browse by site
- Browse by week
- Browse by prompt

**Contact Form 7 forms to build:**

*Site Registration Form* - fields as specified in 2.8-Site_registration_process.md. Set to email submissions to the project coordinator and store in database.

*Site Status Update Form* - fields: site code, new status (select from four options), current week number if in progress, brief notes. Linked from the registration confirmation email sent to facilitators.

*General Contact Form* - name, email, message. Standard CF7 setup.

**Menus:**
- Primary navigation: Home, About, Run a Project, Gallery, Project Map, Data, News
- Footer: Contributing, GitHub (external link), Contact

- [ ] All pages created
- [ ] CF7 forms built and tested
- [ ] Navigation menus configured
- [ ] Site visible at project domain

---

## Phase C: Google Workspace

*Estimated time: 3-4 hours*
*Requires: Project Google account, basic JavaScript comfort for Apps Scripts*
*Note: If Apps Scripts are beyond your current comfort level, the forms and sheets can be built without them initially - scripts can be added later. The project works without automation; it just requires more manual work from the coordinator.*

---

### C1. Create the master Google Sheet

1. Sign in to Google Drive with the project account
2. Create a new Google Sheet named "Through Two Sets of Eyes - Master Data"
3. Create six tabs named exactly:
   - SWEMWBS
   - Images
   - Registrations
   - Completions
   - SessionNotes
   - CodexNotes (for coordinator internal notes - not fed by any form)

4. In the SWEMWBS tab, create the following column headers in row 1:

| Column | Header |
|---|---|
| A | Timestamp |
| B | SiteCode |
| C | FacilitatorCode |
| D | ParticipantCode |
| E | Cohort |
| F | Timepoint |
| G | SurveyDate |
| H | Q1 |
| I | Q2 |
| J | Q3 |
| K | Q4 |
| L | Q5 |
| M | Q6 |
| N | Q7 |
| O | RawTotal |
| P | MetricScore |
| Q | FormVersion |
| R | Notes |

5. In column O (RawTotal), add the formula `=SUM(H2:N2)` starting in O2. This auto-calculates when data is entered.

6. In column P (MetricScore), add a VLOOKUP formula referencing the SWEMWBS conversion table. The conversion table needs to be added to a separate tab named `SWEMWBSConversion` with two columns: RawScore (7-35) and MetricScore (published values). The formula in P2 is:
`=IFERROR(VLOOKUP(O2,SWEMWBSConversion!$A:$B,2,FALSE),"")`

The SWEMWBS conversion table values are available from the University of Warwick WEMWBS resources page: `https://warwick.ac.uk/fac/sci/med/research/platform/wemwbs/`

7. Apply the same formula pattern down columns O and P for 500 rows - sufficient for many sites of data

8. Note the Sheet URL - you will need it for WP Data Access configuration and for the form definitions

- [ ] Master Google Sheet created
- [ ] All six tabs created
- [ ] SWEMWBS column headers and formulas added
- [ ] Conversion table added
- [ ] Sheet URL noted in Bitwarden

---

### C2. Create the five Google Forms

For each form: go to `forms.google.com`, create a new form, and link it to the corresponding tab in the master Sheet (Responses > Link to Sheets > select existing spreadsheet).

Detailed field specifications for each form are in the corresponding kit documents:
- Form 1 (SWEMWBS): Section 2.4 Document 4
- Form 2 (Image Submission): Section 2.6
- Form 3 (Site Registration): Section 2.8
- Form 4 (Site Completion): Section 2.7
- Form 5 (Session Notes): Section 3.4

**For each form after creation:**
1. Enable email notifications to the project coordinator on submission (Responses > Get email notifications)
2. Customise the confirmation message shown to respondents
3. Test with a dummy submission and confirm the row appears in the correct Sheet tab
4. Copy the form URL and store in Bitwarden

**QR code generation for Form 2 (Image Submission):**

Each site needs sixteen QR codes - eight per cohort, one per week - each encoding a Form 2 URL with site code, week number, and cohort pre-filled as URL parameters. Google Forms supports pre-filled URLs via the pre-fill feature (three-dot menu > Get pre-filled link).

The QR code generation process:
1. Open Form 2
2. Three-dot menu > Get pre-filled link
3. Fill in the site code, week number, and cohort fields with the correct values
4. Copy the resulting URL
5. Generate a QR code from the URL using any free QR code generator - `qr-code-generator.com` or similar
6. Download as PNG and include in the print-ready QR code card for that site and week

Document this process in `infrastructure/google-forms/README.md` so it can be repeated for each new site.

- [ ] All five forms created
- [ ] Each form linked to correct Sheet tab
- [ ] Test submissions confirmed
- [ ] Form URLs in Bitwarden
- [ ] QR code generation process documented

---

### C3. Write and test Google Apps Scripts

Open the master Google Sheet and go to Extensions > Apps Script. Create four scripts as separate files within the same Apps Script project.

**Script 1: Image organisation**

Trigger: On Form Submit for Form 2

```javascript
function organiseImageSubmission(e) {
  const sheet = e.range.getSheet();
  const row = e.values;
  
  // Column indices (0-based) - adjust if form field order changes
  const siteCode = row[1];  // SiteCode column
  const weekNum = row[2];   // WeekNumber column
  const participantCode = row[3]; // ParticipantCode column
  
  // Get the uploaded file from the form response
  const formResponse = e.namedValues;
  
  // Create folder structure in Drive
  const rootFolder = DriveApp.getFoldersByName('submissions').next();
  
  let siteFolder;
  const siteFolders = rootFolder.getFoldersByName(siteCode);
  siteFolder = siteFolders.hasNext() 
    ? siteFolders.next() 
    : rootFolder.createFolder(siteCode);
  
  let weekFolder;
  const weekName = 'week-' + weekNum;
  const weekFolders = siteFolder.getFoldersByName(weekName);
  weekFolder = weekFolders.hasNext() 
    ? weekFolders.next() 
    : siteFolder.createFolder(weekName);
  
  // Note: file renaming requires additional handling
  // See infrastructure/google-forms/README.md for full implementation
}
```

*Note: Google Forms file uploads land in a specific Drive folder tied to the form response. Moving and renaming them requires fetching the file ID from the form response - the full implementation is more involved than shown here and is documented in `infrastructure/google-forms/README.md`. This stub confirms the trigger and folder structure logic; complete before going live.*

**Script 2: Site registration notification**

Trigger: On Form Submit for Form 3

```javascript
function notifyRegistration(e) {
  const values = e.namedValues;
  const facilitatorName = values['Name'][0];
  const facilitatorEmail = values['Email'][0];
  const location = values['Location'][0];
  const startDate = values['Proposed start date'][0];
  
  const coordinatorEmail = 'thru2setsofeyes@gmail.com';
  const subject = 'New site registration: ' + location;
  const body = [
    'A new site has registered for Through Two Sets of Eyes.',
    '',
    'Facilitator: ' + facilitatorName,
    'Email: ' + facilitatorEmail,
    'Location: ' + location,
    'Proposed start date: ' + startDate,
    '',
    'Review the full registration in the master Sheet:',
    '[SHEET URL]',
    '',
    'Next steps:',
    '1. Assign site code and facilitator code',
    '2. Generate QR code card set',
    '3. Reply to facilitator within 48 hours'
  ].join('\n');
  
  GmailApp.sendEmail(coordinatorEmail, subject, body);
}
```

**Script 3: Site completion confirmation**

Trigger: On Form Submit for Form 4

```javascript
function confirmCompletion(e) {
  const values = e.namedValues;
  const facilitatorEmail = values['Email'][0];
  const siteCode = values['Site code'][0];
  const siteName = values['Site name'][0];
  
  const subject = 'Data submission received - ' + siteName;
  const body = [
    'Thank you for submitting your project data.',
    '',
    'Site: ' + siteName + ' (' + siteCode + ')',
    'Submission received: ' + new Date().toLocaleDateString('en-AU'),
    '',
    'Your data will be reviewed and added to the project dataset.',
    'You will hear from the project coordinator if anything is missing.',
    '',
    'Your images are already in the gallery at:',
    '[WORDPRESS GALLERY URL]',
    '',
    'Thank you for running a Through Two Sets of Eyes project.',
    'Your contribution matters.'
  ].join('\n');
  
  GmailApp.sendEmail(facilitatorEmail, subject, body);
}
```

**Script 4: Monthly CSV export**

Trigger: Time-based, monthly, first day of each month

```javascript
function monthlyExport() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName('SWEMWBS');
  const data = sheet.getDataRange().getValues();
  
  // Convert to CSV
  const csv = data.map(row => 
    row.map(cell => 
      typeof cell === 'string' && cell.includes(',') 
        ? '"' + cell + '"' 
        : cell
    ).join(',')
  ).join('\n');
  
  // Save to Drive backup folder
  const backupFolder = DriveApp.getFoldersByName('backups').next();
  const filename = 'SWEMWBS-export-' + 
    new Date().toISOString().slice(0,10) + '.csv';
  backupFolder.createFile(filename, csv, MimeType.CSV);
  
  // Email notification
  GmailApp.sendEmail(
    'thru2setsofeyes@gmail.com',
    'Monthly SWEMWBS export completed',
    'Export saved to Drive backups folder: ' + filename
  );
}
```

**Testing each script:**
1. Run manually from the Apps Script editor using the Run button
2. Check for errors in the Execution Log
3. Confirm the expected output - folder created, email sent, file saved
4. Set the trigger via Triggers (clock icon in the left sidebar)

- [ ] Script 1 written and tested - image organisation
- [ ] Script 2 written and tested - registration notification
- [ ] Script 3 written and tested - completion confirmation
- [ ] Script 4 written and tested - monthly export
- [ ] All triggers set
- [ ] `infrastructure/google-forms/README.md` updated with full Script 1 implementation

---

### C4. Connect WP Data Access to Google Sheet

1. In WordPress, go to WP Data Access settings
2. Follow the plugin's Google Sheets connection guide to authenticate with the project Google account
3. Connect to the master Sheet
4. Configure the public data dashboard page to display:
   - Count of completed sites (from Completions tab)
   - Total participant count (from Registrations tab)
   - Mean SWEMWBS metric scores by cohort and timepoint (from SWEMWBS tab)
5. Test that the dashboard page displays correctly and updates when new data is added to the Sheet

- [ ] WP Data Access connected to Google Sheet
- [ ] Public dashboard displaying correctly

---

## Phase D: Content

*Estimated time: ongoing - this is the bulk of the writing work*
*Can proceed in parallel with Phases B and C once the repo structure exists*

---

### D1. Core repository files

Write the following files in the kit repository root:

**README.md** - the project front door. Should cover:
- What the project is in three sentences
- How to run a project - link to kit download and facilitator guide
- How to contribute - link to CONTRIBUTING.md
- How to get help - link to GitHub Issues
- Licence statement

Keep it short. The specification and facilitator guide carry the detail.

**CONTRIBUTING.md** - covers:
- How to raise an Issue
- How to propose a kit change
- How to submit a translation
- How to submit a cultural adaptation
- The core design principles that cannot be changed without forking
- The two-week comment period required for changes to core design principles

**CHANGELOG.md** - initialise with:
```markdown
# Changelog

## v0.1.0 - May 2026
- Initial specification drafted
- Planning documents committed to repository
```

- [ ] README.md written
- [ ] CONTRIBUTING.md written
- [ ] CHANGELOG.md initialised

---

### D2. Kit documents

Write each kit document from its specification. These are the actual facilitator-facing files - the specification documents in `spec/` are the design blueprints; the kit documents in `kit/` are what facilitators download and use.

Order of priority:

1. `kit/facilitator-guide/facilitator-guide.md` - the most important document
2. `kit/prompt-cards/prompt-cards.md` and print-ready files
3. `kit/consent-templates/` - all three templates
4. `kit/swemwbs-pack/` - all five documents
5. `kit/exhibition-guide/exhibition-guide.md`
6. `kit/image-submission-guide/image-submission-guide.md`
7. `kit/data-submission-guide/data-submission-guide.md`

Each document should be written in plain language, second person, and tested by reading it aloud - if it sounds like a policy document, rewrite it.

*Note: This is the phase where Claude Code with agents and skills will save significant time. The specification documents are stable enough to use as source material for generating first drafts of each kit document.*

- [ ] Facilitator guide written
- [ ] Prompt cards written and print-ready files generated
- [ ] Consent templates written
- [ ] SWEMWBS pack documents written
- [ ] Exhibition guide written
- [ ] Image submission guide written
- [ ] Data submission guide written

---

### D3. Infrastructure documentation

Write the following files in the `infrastructure/` subdirectories:

**infrastructure/wordpress/README.md** - the WordPress site rebuild guide. Covers plugin list, theme, custom fields configuration, and page structure. Sufficient for a competent WordPress user to rebuild the site from scratch.

**infrastructure/wordpress/plugins.md** - detailed configuration notes for each plugin, including any non-default settings.

**infrastructure/google-forms/README.md** - the Google Forms setup guide. Covers all five forms, field specifications, Sheet connection, and the full Script 1 image organisation implementation.

**infrastructure/google-forms/form-definitions/** - XLSForm-compatible CSV definitions of all five forms. These allow forms to be reconstructed if the Google account is lost.

**infrastructure/backup/README.md** - the backup and restoration guide. Covers UpdraftPlus restoration procedure step by step, Google Drive Takeout export procedure, and how to rebuild from scratch if both the WordPress site and Google account are lost simultaneously.

**adaptations/README.md** - explains the purpose of the adaptations directory and how to contribute a cultural or linguistic adaptation.

**translations/README.md** - explains the purpose of the translations directory, the requirement to use validated SWEMWBS translations, and how to contribute a language pack.

- [ ] infrastructure/wordpress/README.md written
- [ ] infrastructure/wordpress/plugins.md written
- [ ] infrastructure/google-forms/README.md written
- [ ] infrastructure/google-forms/form-definitions/ populated
- [ ] infrastructure/backup/README.md written
- [ ] adaptations/README.md written
- [ ] translations/README.md written

---

### D4. Update HANDOVER.md with real details

Once Phases B and C are complete, return to HANDOVER.md and replace all placeholders:

- WordPress admin URL
- Project domain URL
- WordPress gallery URL
- Master Google Sheet URL
- Password manager name and location
- All `[to be confirmed]` entries

Then remove Section 8 (Infrastructure Setup Status) from HANDOVER.md - it belongs in SETUP.md, not in the maintenance guide.

- [ ] All HANDOVER.md placeholders replaced
- [ ] Section 8 removed from HANDOVER.md
- [ ] HANDOVER.md reviewed for accuracy against the running infrastructure

---

## Phase E: Pilot

*The pilot is the project itself - run as a real site, not a test.*
*Cygnet, Tasmania is the planned first site.*

---

### E1. Register the pilot site

Complete the site registration form on the WordPress site as a real facilitator would. This tests the registration workflow end to end.

Assign the pilot site code: `CYG001`

Confirm:
- Registration notification email received by coordinator
- Site appears on project map
- QR code card set generated and print-ready

- [ ] Pilot site registered via WordPress form
- [ ] Registration workflow confirmed end to end
- [ ] QR code cards generated for CYG001

---

### E2. Run the pilot

Eight weeks plus Phase 0 preparation. Run it as a real project - real participants, real exhibition, real SWEMWBS data collection.

Document everything that doesn't work as GitHub Issues during the run. The pilot is the best possible kit test.

- [ ] Phase 0 completed - venue confirmed, cohorts recruited, orientation delivered
- [ ] Weeks 1-8 completed
- [ ] Week 8 closing event held
- [ ] Post-project SWEMWBS collected

---

### E3. Submit pilot data

Complete the Site Completion Form as a real facilitator would. This tests the completion workflow end to end.

Confirm:
- Completion confirmation email received by facilitator
- Data appears in master Sheet
- Images appear in WordPress gallery
- Site status updated to Completed on project map

- [ ] Site Completion Form submitted
- [ ] Data confirmed in master Sheet
- [ ] Gallery updated
- [ ] Project map updated

---

### E4. Review and release

After the pilot:

1. Review all GitHub Issues raised during the pilot - fix, defer to V2.0, or close as by design
2. Update kit documents based on pilot learnings
3. Recruit a second GitHub org owner - the project should not go public without one
4. Tag V1.0 release in GitHub
5. Announce on the WordPress News page
6. Remove "pilot" or "draft" language from all public-facing documents

- [ ] Pilot Issues reviewed and resolved
- [ ] Kit documents updated from pilot learnings
- [ ] Second org owner recruited
- [ ] V1.0 tagged in GitHub
- [ ] Public launch announced

---

## You're Done

If every checkbox in this document is ticked, the project is live and HANDOVER.md is the document that matters from here.

Archive this document - move it to `spec/` or a `history/` directory - so it doesn't clutter the root of the repository for future contributors who won't need it.

Thank the people who helped get it here.

---

*End of SETUP.md v0.1 draft*

*Next review: on completion of Phase A, to confirm account details*

---
