## WordPress: Multiple Sites on One Server

Your PHP redirect approach will work fine for routing domain names to subdirectories, but running a second full WordPress installation in a subdirectory has some gotchas on shared hosting. A cleaner option that Hostmonster/Bluehost supports is **WordPress Multisite** - one WordPress installation that hosts multiple independent sites, each with their own theme, plugins, and content, reachable at different domains or subdomains.

The tradeoff:
- **Multisite** - one codebase to maintain, one set of plugin updates, shared database. Slightly more complex to set up initially but simpler to maintain long-term. Domain mapping (so `thru2setsofeyes.org` points to the right subsite) requires a plugin - Domain Mapping System has a free tier that works well.
- **Separate subdirectory install** - simpler to set up, but two WordPress installations to keep updated and secured independently. Fine for two sites, gets unwieldy at three or four.

Given you already have Palimpsest Path running and are planning more projects, Multisite is probably the right long-term architecture. Worth converting now rather than later when there are more sites to migrate.

The conversion process is well documented in the WordPress codex and is reversible if it causes problems. Your existing Palimpsest Path site becomes the primary subsite; Through Two Sets of Eyes becomes a second subsite reachable at `thru2setsofeyes.org`.

---

## Google Account

Set up a dedicated Google account - something like `thru2setsofeyes@gmail.com` - before doing anything else with the data collection infrastructure. Using your personal account creates the same single-point-of-failure problem we've been designing against everywhere else. The project account credentials go into a password manager that a future co-owner can access.

---

## GitHub Org and Repo

The sequence I'd suggest:

1. Create the kit repo inside the `thru2setsofeyes` org - `github.com/thru2setsofeyes/kit`
2. Copy the current planning docs from `botheredbybees/thru2setsofeyes` into the new repo under `spec/` as agreed in the spec
3. Leave `botheredbybees/thru2setsofeyes` as a personal scratchpad for drafting - archive it once the org repo is the working copy
4. Add a second org owner as soon as you have one - even a trusted friend who just holds the seat is better than none

---

## Timeline and HANDOVER.md

The fact that you're planning to keep working on this post-retirement changes the HANDOVER.md calculus somewhat. It doesn't need to be a "here is everything a stranger needs to take over tomorrow" document right now - it can be a living document that grows as the infrastructure is built. 

The most useful first draft covers:

- The architecture overview - what exists and where
- The weekly and monthly coordinator tasks
- The credential inventory - not the credentials themselves, but a list of what accounts exist and where the passwords are stored
- The infrastructure setup checklist - what still needs to be built, in order

That last section is actually the most useful thing right now - a sequenced list of everything that needs to happen to get from current state to V1.0 launch ready. It doubles as your personal project plan.

---

## Suggested Infrastructure Setup Sequence

Before HANDOVER.md, it might be worth drafting this as a standalone checklist in the repo:

**Phase A - Accounts and credentials**
1. Create `thru2setsofeyes@gmail.com` Google account
2. Set up a password manager entry for all project credentials
3. Transfer `thru2setsofeyes` GitHub org ownership to org - already done
4. Create `github.com/thru2setsofeyes/kit` repository

**Phase B - WordPress**
5. Decide: Multisite conversion or separate subdirectory install
6. Set up Through Two Sets of Eyes WordPress subsite
7. Install and configure required plugins
8. Build site structure - pages, menus, gallery, map
9. Configure CF7 forms
10. Configure WP Mail SMTP with Brevo
11. Configure UpdraftPlus with Backblaze B2

**Phase C - Google Workspace**
12. Create project Google Forms (5 forms)
13. Create master Google Sheet with formula columns
14. Write and test Google Apps Scripts (4 automations)
15. Generate initial QR code card sets for pilot site

**Phase D - Content**
16. Migrate planning docs from `botheredbybees` to org repo
17. Write README.md, CONTRIBUTING.md, CHANGELOG.md
18. Write kit documents from spec
19. Write HANDOVER.md second pass with real URLs and credentials inventory

**Phase E - Pilot**
20. Register Cygnet as the first site
21. Run the pilot
22. Submit pilot data
23. Recruit a second org owner
24. V1.0 release

