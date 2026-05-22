-- submissions bucket: anon can upload, not read
INSERT INTO storage.buckets (id, name, public)
    VALUES ('submissions', 'submissions', false)
    ON CONFLICT (id) DO NOTHING;

INSERT INTO storage.buckets (id, name, public)
    VALUES ('gallery', 'gallery', true)
    ON CONFLICT (id) DO NOTHING;

-- Allow anon to upload to submissions bucket only
CREATE POLICY "Anon can upload to submissions"
    ON storage.objects FOR INSERT
    TO anon
    WITH CHECK (bucket_id = 'submissions');

-- Anon cannot read from submissions bucket
CREATE POLICY "Anon cannot read submissions"
    ON storage.objects FOR SELECT
    TO anon
    USING (bucket_id = 'gallery');

-- Authenticated coordinator can read submissions for moderation
CREATE POLICY "Authenticated can read submissions"
    ON storage.objects FOR SELECT
    TO authenticated
    USING (bucket_id = 'submissions');

-- Authenticated coordinator can move approved images to gallery
CREATE POLICY "Authenticated can insert to gallery"
    ON storage.objects FOR INSERT
    TO authenticated
    WITH CHECK (bucket_id = 'gallery');

-- Authenticated coordinator can delete rejected submissions
CREATE POLICY "Authenticated can delete from submissions"
    ON storage.objects FOR DELETE
    TO authenticated
    USING (bucket_id = 'submissions');

-- Restrict moderation_queue to authenticated users only
ALTER VIEW moderation_queue OWNER TO authenticated;

CREATE POLICY "Authenticated users can read moderation queue"
    ON image_submissions FOR SELECT
    USING (auth.role() = 'authenticated');