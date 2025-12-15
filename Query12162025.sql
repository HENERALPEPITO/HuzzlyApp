
-- Drop test schemas if they exist TEST ONLY
DROP SCHEMA "new_huzzly" CASCADE;
DROP SCHEMA "ShiftApiTest" CASCADE;
DROP SCHEMA "Huzzly_app" CASCADE;


-- Revoke from PUBLIC (every role)
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA public FROM PUBLIC;



-- Add auth_trigger_logs table
CREATE TABLE IF NOT EXISTS api.auth_trigger_logs (
  id bigint NOT NULL DEFAULT nextval('auth_trigger_logs_id_seq'::regclass),
  user_id uuid,
  detected_role text,
  message text,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT auth_trigger_logs_pkey PRIMARY KEY (id)
);

-- Add posted_shifts table (exists in public, not in api)
CREATE TABLE IF NOT EXISTS api.posted_shifts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  created_at timestamp with time zone DEFAULT now(),
  shift_date date NOT NULL,
  shift_time time without time zone NOT NULL,
  zone text NOT NULL,
  position text NOT NULL,
  quantity integer DEFAULT 1,
  hourly_wage numeric,
  status text DEFAULT 'open'::text,
  CONSTRAINT posted_shifts_pkey PRIMARY KEY (id)
);

-- Add missing columns to api.users
ALTER TABLE api.users 
  ADD COLUMN IF NOT EXISTS email text,
  ADD COLUMN IF NOT EXISTS name text,
  ADD COLUMN IF NOT EXISTS phone_number text,
  ADD COLUMN IF NOT EXISTS preferred_contact text,
  ADD COLUMN IF NOT EXISTS address text,
  ADD COLUMN IF NOT EXISTS lat numeric,
  ADD COLUMN IF NOT EXISTS long numeric,
  ADD COLUMN IF NOT EXISTS first text,
  ADD COLUMN IF NOT EXISTS last text;

-- Add missing columns to api.workers
ALTER TABLE api.workers
  ADD COLUMN IF NOT EXISTS screen_step bigint,
  ADD COLUMN IF NOT EXISTS sector text,
  ADD COLUMN IF NOT EXISTS role_sector text[],
  ADD COLUMN IF NOT EXISTS deleted_at timestamp without time zone,
  ADD COLUMN IF NOT EXISTS role text;