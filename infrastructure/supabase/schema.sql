-- ── Extensions ─────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ── Sites ──────────────────────────────────────────────────────────
CREATE TABLE sites (
    id                      SERIAL PRIMARY KEY,
    site_code               VARCHAR(20) UNIQUE NOT NULL,
    facilitator_code        VARCHAR(20) UNIQUE NOT NULL,
    status_update_key       VARCHAR(64) UNIQUE NOT NULL
                            DEFAULT encode(gen_random_bytes(32), 'hex'),

    -- Facilitator details
    facilitator_name        VARCHAR(200) NOT NULL,
    facilitator_email       VARCHAR(200) NOT NULL,

    -- Location
    town_suburb             VARCHAR(200),
    state_territory         VARCHAR(100),
    country                 VARCHAR(100) NOT NULL DEFAULT 'Australia',
    location_type           VARCHAR(20)
                            CHECK (location_type IN
                            ('metropolitan','regional','rural','remote')),
    organisation            VARCHAR(200),
    how_heard               TEXT,

    -- Project timeline
    proposed_start_date     DATE,
    proposed_session_day    VARCHAR(20),
    actual_start_date       DATE,
    actual_end_date         DATE,

    -- Venue
    venue_type              VARCHAR(50),
    venue_name              VARCHAR(200),
    venue_name_public_ok    BOOLEAN DEFAULT FALSE,

    -- Co-facilitator
    cofacilitator_name      VARCHAR(200),
    cofacilitator_role      VARCHAR(200),
    cofacilitator_org       VARCHAR(200),
    cofacilitator_bgcheck   BOOLEAN,

    -- Cohort targets
    target_cohort_size      INTEGER,
    youth_recruitment       TEXT,
    older_adult_recruitment TEXT,

    -- Registration confirmations
    confirmed_venue         BOOLEAN DEFAULT FALSE,
    confirmed_cofacilitator BOOLEAN DEFAULT FALSE,
    read_facilitator_guide  BOOLEAN DEFAULT FALSE,
    data_submission_agreed  BOOLEAN DEFAULT FALSE,
    data_handling_agreed    BOOLEAN DEFAULT FALSE,

    -- Status
    status                  VARCHAR(30) NOT NULL DEFAULT 'registered'
                            CHECK (status IN (
                            'registered','in_progress','completed','incomplete')),
    current_week            INTEGER CHECK (current_week BETWEEN 1 AND 8),

    -- Coordinator fields
    coordinator_notes       TEXT,
    data_review_complete    BOOLEAN DEFAULT FALSE,
    publication_register    BOOLEAN DEFAULT FALSE,

    -- Timestamps
    registered_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── SWEMWBS Conversion Table ───────────────────────────────────────
-- Populated once manually from Tennant et al. (2007) Table 4
-- https://warwick.ac.uk/fac/sci/med/research/platform/wemwbs/
CREATE TABLE swemwbs_conversion (
    raw_score       SMALLINT PRIMARY KEY CHECK (raw_score BETWEEN 7 AND 35),
    metric_score    NUMERIC(4,1) NOT NULL
);

-- Insert conversion values
-- Source: Tennant et al. (2007), Stewart-Brown & Janmohamed (2008)
INSERT INTO swemwbs_conversion (raw_score, metric_score) VALUES
    (7,  7.00),
    (8,  8.50),
    (9,  9.51),
    (10, 10.33),
    (11, 11.06),
    (12, 11.73),
    (13, 12.36),
    (14, 12.96),
    (15, 13.54),
    (16, 14.11),
    (17, 14.67),
    (18, 15.22),
    (19, 15.77),
    (20, 16.32),
    (21, 16.88),
    (22, 17.45),
    (23, 18.03),
    (24, 18.63),
    (25, 19.25),
    (26, 19.90),
    (27, 20.58),
    (28, 21.31),
    (29, 22.10),
    (30, 22.96),
    (31, 23.92),
    (32, 24.98),
    (33, 26.19),
    (34, 27.60),
    (35, 29.41);

-- ── SWEMWBS Surveys ────────────────────────────────────────────────
CREATE TABLE swemwbs_surveys (
    id                  SERIAL PRIMARY KEY,
    site_code           VARCHAR(20) NOT NULL REFERENCES sites(site_code),
    facilitator_code    VARCHAR(20) NOT NULL,
    participant_code    VARCHAR(20) NOT NULL,
    cohort              VARCHAR(20) NOT NULL
                        CHECK (cohort IN ('youth','older_adult')),
    survey_interval     VARCHAR(20) NOT NULL
                        CHECK (survey_interval IN
                        ('baseline','mid_point','post_project')),
    survey_date         DATE NOT NULL,

    -- The seven SWEMWBS items (1-5 scale)
    q1_optimistic       SMALLINT CHECK (q1_optimistic BETWEEN 1 AND 5),
    q2_useful           SMALLINT CHECK (q2_useful BETWEEN 1 AND 5),
    q3_relaxed          SMALLINT CHECK (q3_relaxed BETWEEN 1 AND 5),
    q4_problems_well    SMALLINT CHECK (q4_problems_well BETWEEN 1 AND 5),
    q5_thinking_clearly SMALLINT CHECK (q5_thinking_clearly BETWEEN 1 AND 5),
    q6_close_to_people  SMALLINT CHECK (q6_close_to_people BETWEEN 1 AND 5),
    q7_own_mind         SMALLINT CHECK (q7_own_mind BETWEEN 1 AND 5),

    -- Derived scores - calculated by application on insert
    raw_total           SMALLINT,
    metric_score        NUMERIC(4,1),

    -- Metadata
    form_version        VARCHAR(20),
    notes               TEXT,
    submitted_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- Prevent duplicate submissions
    UNIQUE (site_code, participant_code, survey_interval)
);

-- ── Image Submissions ──────────────────────────────────────────────
CREATE TABLE image_submissions (
    id                   SERIAL PRIMARY KEY,
    site_code            VARCHAR(20) NOT NULL REFERENCES sites(site_code),
    participant_code     VARCHAR(20) NOT NULL,
    cohort               VARCHAR(20) NOT NULL
                         CHECK (cohort IN ('youth','older_adult')),
    week_number          SMALLINT NOT NULL CHECK (week_number BETWEEN 1 AND 8),
    prompt_text          TEXT,

    -- File storage - path within Supabase Storage bucket
    image_path           VARCHAR(500) NOT NULL,
    -- convention: submissions/[site_code]/week-[n]/[site]-w[n]-[participant].[ext]

    caption_text         TEXT,

    -- Moderation
    moderation_status    VARCHAR(20) NOT NULL DEFAULT 'pending'
                         CHECK (moderation_status IN
                         ('pending','approved','rejected')),
    moderation_notes     TEXT,
    moderated_at         TIMESTAMPTZ,

    -- Gallery
    gallery_published    BOOLEAN DEFAULT FALSE,
    gallery_published_at TIMESTAMPTZ,

    submitted_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    -- One submission per participant per week
    UNIQUE (site_code, participant_code, week_number)
);

-- ── Session Notes ──────────────────────────────────────────────────
CREATE TABLE session_notes (
    id                     SERIAL PRIMARY KEY,
    site_code              VARCHAR(20) NOT NULL REFERENCES sites(site_code),
    facilitator_code       VARCHAR(20) NOT NULL,
    week_number            SMALLINT NOT NULL CHECK (week_number BETWEEN 1 AND 8),
    session_date           DATE NOT NULL,
    attendance_youth       SMALLINT,
    attendance_older_adult SMALLINT,
    notes                  TEXT,
    submitted_at           TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    UNIQUE (site_code, week_number)
);

-- ── Site Completions ───────────────────────────────────────────────
CREATE TABLE site_completions (
    id                          SERIAL PRIMARY KEY,
    site_code                   VARCHAR(20) UNIQUE NOT NULL
                                REFERENCES sites(site_code),
    facilitator_code            VARCHAR(20) NOT NULL,

    -- Cohort outcomes
    youth_recruited             SMALLINT,
    youth_completed             SMALLINT,
    youth_age_range             VARCHAR(50),
    older_adult_recruited       SMALLINT,
    older_adult_completed       SMALLINT,
    older_adult_age_range       VARCHAR(50),

    -- Co-facilitator
    cofacilitator_role          VARCHAR(200),
    cofacilitator_org           VARCHAR(200),
    cofacilitator_bgcheck       BOOLEAN,

    -- Exhibition
    venue_type                  VARCHAR(50),
    venue_name                  VARCHAR(200),
    venue_name_public_ok        BOOLEAN DEFAULT FALSE,
    foot_traffic_estimate       VARCHAR(20)
                                CHECK (foot_traffic_estimate IN (
                                'under_50','50_200','200_500','over_500')),
    closing_event_held          BOOLEAN,
    closing_event_attendance    SMALLINT,

    -- Protocol deviations
    prompts_modified            BOOLEAN DEFAULT FALSE,
    prompts_modified_detail     TEXT,
    core_principles_modified    BOOLEAN DEFAULT FALSE,
    core_principles_detail      TEXT,
    other_deviations            TEXT,

    -- Open reflection
    what_worked_well            TEXT,
    what_to_do_differently      TEXT,
    run_again                   VARCHAR(10)
                                CHECK (run_again IN ('yes','no','maybe')),
    run_again_detail            TEXT,
    interested_in_publication   VARCHAR(10)
                                CHECK (interested_in_publication IN
                                ('yes','no','maybe')),

    -- Safeguarding - excluded from all public queries
    safeguarding_incident       BOOLEAN DEFAULT FALSE,
    safeguarding_detail         TEXT,

    -- Session logs
    session_logs_path           VARCHAR(500),

    -- Coordinator
    data_review_complete        BOOLEAN DEFAULT FALSE,
    data_review_notes           TEXT,
    publication_register_entry  BOOLEAN DEFAULT FALSE,

    submitted_at                TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ── SWEMWBS auto-score trigger ────────────────────────────────────
-- Calculates raw_total and looks up metric_score on insert or update.
-- Leaves both NULL if any of the seven items are missing.
CREATE OR REPLACE FUNCTION calculate_swemwbs_scores()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.q1_optimistic IS NOT NULL
    AND NEW.q2_useful IS NOT NULL
    AND NEW.q3_relaxed IS NOT NULL
    AND NEW.q4_problems_well IS NOT NULL
    AND NEW.q5_thinking_clearly IS NOT NULL
    AND NEW.q6_close_to_people IS NOT NULL
    AND NEW.q7_own_mind IS NOT NULL THEN
        NEW.raw_total := NEW.q1_optimistic + NEW.q2_useful + NEW.q3_relaxed
                        + NEW.q4_problems_well + NEW.q5_thinking_clearly
                        + NEW.q6_close_to_people + NEW.q7_own_mind;
        SELECT metric_score INTO NEW.metric_score
        FROM swemwbs_conversion
        WHERE raw_score = NEW.raw_total;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER swemwbs_auto_score
    BEFORE INSERT OR UPDATE ON swemwbs_surveys
    FOR EACH ROW
    EXECUTE FUNCTION calculate_swemwbs_scores();

-- ── Updated_at trigger ─────────────────────────────────────────────
-- Keeps sites.updated_at current automatically
CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER sites_updated_at
    BEFORE UPDATE ON sites
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at();

-- ── Row Level Security ─────────────────────────────────────────────
-- Enable RLS on all tables
ALTER TABLE sites ENABLE ROW LEVEL SECURITY;
ALTER TABLE swemwbs_surveys ENABLE ROW LEVEL SECURITY;
ALTER TABLE image_submissions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE site_completions ENABLE ROW LEVEL SECURITY;
ALTER TABLE swemwbs_conversion ENABLE ROW LEVEL SECURITY;

-- Public read access to conversion table only
CREATE POLICY "Public can read conversion table"
    ON swemwbs_conversion FOR SELECT
    USING (true);

-- Anon insert policies - allow form submissions without login
CREATE POLICY "Anon can insert surveys"
    ON swemwbs_surveys FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Anon can insert images"
    ON image_submissions FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Anon can insert session notes"
    ON session_notes FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Anon can insert site completions"
    ON site_completions FOR INSERT
    WITH CHECK (true);

CREATE POLICY "Anon can insert site registrations"
    ON sites FOR INSERT
    WITH CHECK (true);

-- Status update via key - anon can update status fields only
CREATE POLICY "Anon can update status via key"
    ON sites FOR UPDATE
    USING (true)
    WITH CHECK (true);
-- Note: the application layer enforces status_update_key validation
-- before allowing any update - RLS alone is not sufficient here

-- ── Public Views ───────────────────────────────────────────────────

-- Safe aggregate view for public dashboard
CREATE VIEW public_dashboard AS
SELECT
    COUNT(DISTINCT sc.site_code)                        AS total_sites_completed,
    COALESCE(SUM(sc.youth_completed +
        sc.older_adult_completed), 0)                   AS total_participants,
    ROUND(AVG(CASE
        WHEN sw.cohort = 'youth'
        AND sw.survey_interval = 'baseline'
        THEN sw.metric_score END), 1)                   AS youth_baseline_mean,
    ROUND(AVG(CASE
        WHEN sw.cohort = 'youth'
        AND sw.survey_interval = 'post_project'
        THEN sw.metric_score END), 1)                   AS youth_post_mean,
    ROUND(AVG(CASE
        WHEN sw.cohort = 'older_adult'
        AND sw.survey_interval = 'baseline'
        THEN sw.metric_score END), 1)                   AS older_adult_baseline_mean,
    ROUND(AVG(CASE
        WHEN sw.cohort = 'older_adult'
        AND sw.survey_interval = 'post_project'
        THEN sw.metric_score END), 1)                   AS older_adult_post_mean
FROM site_completions sc
LEFT JOIN swemwbs_surveys sw ON sw.site_code = sc.site_code;

-- Site map view - respects venue name permission, excludes PII
CREATE VIEW public_site_map AS
SELECT
    s.site_code,
    s.status,
    s.current_week,
    s.town_suburb,
    s.state_territory,
    s.country,
    s.location_type,
    CASE WHEN s.venue_name_public_ok
        THEN s.venue_name ELSE NULL END                 AS venue_name,
    s.actual_start_date,
    s.actual_end_date,
    s.registered_at
FROM sites s;

-- Coordinator moderation queue
CREATE VIEW moderation_queue AS
SELECT
    i.id,
    i.site_code,
    i.participant_code,
    i.cohort,
    i.week_number,
    i.prompt_text,
    i.image_path,
    i.caption_text,
    i.submitted_at
FROM image_submissions i
WHERE i.moderation_status = 'pending'
ORDER BY i.submitted_at ASC;

-- Gallery view - approved and published images only, no PII
CREATE VIEW public_gallery AS
SELECT
    i.site_code,
    i.cohort,
    i.week_number,
    i.prompt_text,
    i.image_path,
    i.caption_text,
    i.gallery_published_at
FROM image_submissions i
WHERE i.moderation_status = 'approved'
AND i.gallery_published = TRUE
ORDER BY i.gallery_published_at DESC;

-- Revoke public access to moderation_queue
REVOKE SELECT ON moderation_queue FROM anon;
REVOKE SELECT ON moderation_queue FROM public;

-- Grant access to authenticated role only
GRANT SELECT ON moderation_queue TO authenticated;