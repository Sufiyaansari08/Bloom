-- ==============================================================================
-- 🌸 Bloom — Supabase / PostgreSQL Production Schema
-- ==============================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. USER PROFILES TABLE
CREATE TABLE IF NOT EXISTS user_profiles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    email TEXT UNIQUE,
    date_of_birth DATE,
    height_cm NUMERIC(5,2),
    weight_kg NUMERIC(5,2),
    blood_group TEXT,
    avg_cycle_length INTEGER DEFAULT 28,
    avg_period_length INTEGER DEFAULT 5,
    primary_goal TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 2. CYCLES TABLE
CREATE TABLE IF NOT EXISTS cycles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    start_date DATE NOT NULL,
    end_date DATE,
    cycle_length INTEGER,
    period_length INTEGER,
    is_predicted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 3. DAILY LOGS TABLE
CREATE TABLE IF NOT EXISTS daily_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    cycle_id UUID REFERENCES cycles(id) ON DELETE SET NULL,
    date DATE NOT NULL,
    flow_intensity TEXT CHECK (flow_intensity IN ('spotting', 'light', 'medium', 'heavy', 'very_heavy')),
    pain_level INTEGER CHECK (pain_level >= 0 AND pain_level <= 10),
    mood TEXT CHECK (mood IN ('great', 'good', 'okay', 'not_great', 'bad')),
    sleep_hours NUMERIC(4,2),
    water_intake TEXT,
    stress_level INTEGER CHECK (stress_level >= 0 AND stress_level <= 10),
    activity_level TEXT CHECK (activity_level IN ('sedentary', 'moderate', 'active')),
    remedies TEXT,
    pain_after_1hr INTEGER CHECK (pain_after_1hr >= 0 AND pain_after_1hr <= 10),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE,
    UNIQUE(user_id, date)
);

-- 4. DAILY SYMPTOMS TABLE (Normalized Multi-select)
CREATE TABLE IF NOT EXISTS daily_symptoms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    daily_log_id UUID NOT NULL REFERENCES daily_logs(id) ON DELETE CASCADE,
    symptom_name TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 5. REMINDERS TABLE
CREATE TABLE IF NOT EXISTS reminders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    time_of_day TEXT NOT NULL,
    days_before INTEGER DEFAULT 1,
    is_enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- 6. AI INSIGHTS CACHE TABLE
CREATE TABLE IF NOT EXISTS ai_insights (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES user_profiles(id) ON DELETE CASCADE,
    category TEXT NOT NULL CHECK (category IN ('home_summary', 'compare_cycles', 'pain_insights', 'mood_trends', 'lifestyle', 'doctor_report')),
    cycle_phase TEXT,
    headline TEXT,
    insight_text TEXT NOT NULL,
    generated_date DATE NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    is_synced BOOLEAN DEFAULT TRUE,
    is_deleted BOOLEAN DEFAULT FALSE
);

-- ==============================================================================
-- Indexes for High Performance Queries
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_cycles_user ON cycles(user_id);
CREATE INDEX IF NOT EXISTS idx_daily_logs_user_date ON daily_logs(user_id, date);
CREATE INDEX IF NOT EXISTS idx_daily_symptoms_log ON daily_symptoms(daily_log_id);
CREATE INDEX IF NOT EXISTS idx_ai_insights_user_date ON ai_insights(user_id, generated_date);
