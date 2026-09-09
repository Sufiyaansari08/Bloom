# 🌸 Bloom — Menstrual Health, Cycle Tracker & Clinical Insights

**Bloom** is a premium, modern, offline-first menstrual cycle, ovulation, and holistic wellness tracking mobile application built with **Flutter**. Designed with clinical utility and aesthetic excellence in mind, Bloom empowers users to track their physiological rhythms, understand symptom patterns, and export comprehensive clinical doctor reports.

---

## 📌 Executive Summary

* **Platform:** Cross-platform Mobile (iOS & Android)
* **Framework:** Flutter (Dart SDK `>=3.0.0`)
* **State Management:** Riverpod (`flutter_riverpod`)
* **Navigation:** Declarative Routing via `go_router`
* **Current Status:** 100% Complete UI/UX with Dummy Data, ready for Offline-First local database (`sqflite`) integration followed by cloud synchronization (Supabase + FastAPI + LLM).

---

## 🎨 Design System & Aesthetics

Bloom utilizes a curated, soft yet vibrant color palette tailored for wellness and medical clarity:

### 1. Color Palette (`AppColors`)
* **Primary Purple:** `#7051C7` (Used for primary CTAs, main action headers, period phase indicators)
* **Primary Pink:** `#F65E87` (Used for accents, cycle highlights, secondary interactive elements)
* **Background:** `#FAF7FC` / `#FFFFFF` (Clean, warm off-white)
* **Text Primary:** `#302A3A` (Deep plum charcoal for optimal contrast and readability)
* **Text Secondary:** `#8A8194` (Muted violet-gray for subtitles and metadata)
* **Borders & Dividers:** `#E7DFEC` (Subtle boundary borders)
* **Cards & Containers:** Rounded corners (`BorderRadius.circular(24)` or `28`), subtle elevation, clean borders.

### 2. Typography & Visual Principles
* **Typography:** Clean Google Fonts with strong visual hierarchy.
* **Component Design:** Floating card layouts, segmented pill buttons, micro-animations, rich SVG/PNG medical illustrations, and responsive bottom sheets.

---

## 🚀 Implemented Features & Screens

### 1. Welcome & Onboarding (`lib/features/welcome/`, `lib/features/onboarding/`)
* Multi-step onboarding collecting baseline menstrual health metrics:
  * Name, age, last period date, average cycle length, average period duration.
  * Health goals (track period, fertility/conception, symptom monitoring).

### 2. Home Dashboard (`lib/features/home/`)
* **Interactive Cycle Wheel / Visualizer:** Dynamic cycle progress ring displaying current cycle day, fertile window, and expected next period.
* **Daily Insights & Micro-logs:** Quick status cards with daily motivational and physiological context.
* **Quick Log CTA:** Instant access to daily symptom and check-in logging.

### 3. Calendar & Daily Logging (`lib/features/calendar/`, `lib/features/checkin/`, `lib/features/period_logging/`)
* **Table Calendar:** Month and week views highlighting period days, fertile days, and ovulation.
* **Comprehensive Symptom Logging:**
  * **Flow Intensity:** Spotting, Light, Medium, Heavy.
  * **Pain & Cramps:** 1–10 visual severity sliders.
  * **Mood Tracking:** Great, Good, Neutral, Low, Sensitive, Irritable.
  * **Physical Symptoms:** Headache, Bloating, Acne, Fatigue, Tender Breasts, Backache.
  * **Vaginal Discharge / Fluid:** Dry, Sticky, Creamy, Egg White, Watery.
  * **Lifestyle Averages:** Sleep duration, Water intake (glasses/liters), Activity level, Stress level.

### 4. Insights & Analytics Suite (`lib/features/insights/`)
* **Cycle Patterns:** Detailed historical view of cycle variability, average lengths, and regular/irregular status.
* **Compare Cycles (`CompareCyclesPage`):** Side-by-side comparative table (Current vs. Previous cycle, or custom user-selected historical cycles) analyzing period length, average pain, headaches, bloating, sleep, and stress.
* **Pain Insights:** Correlation graphs and triggers analyzing when pain peaks across cycle phases (Follicular, Ovulatory, Luteal, Menstrual).
* **Mood Trends:** Phase-by-phase mood distributions.
* **Lifestyle Insights:** Water, sleep, and stress averages across multiple cycles.

### 5. Clinical Doctor Report Generator (`lib/features/doctor_report/`)
* **Report Setup Flow (`DoctorReportSetupPage`):** Custom date range and cycle span selection (1 to 6 cycles).
* **Interactive Report Preview (`DoctorReportResultPage`):** Formatted breakdown with cycle length bar charts (`fl_chart`), period distributions, symptom incidence tables, and clinical summaries.
* **Clinical PDF Generation (`PdfGeneratorService`):**
  * Fully formatted A4 single-page medical document using the `pdf` and `printing` packages.
  * **Horizontal Title Banner:** Confidential patient header with date ranges.
  * **Patient Metrics Grid:** Age, height, weight, blood group.
  * **2-Row Key Metrics Grid:** Avg/Shortest/Longest cycle lengths, Avg/Shortest/Longest period lengths, cycle variation, and average pain severity.
  * **Spacious Bar Charts:** Cycle Length chart (with 7-day interval y-axis: `0, 7, 14, 21, 28, 35`) and Period Length chart.
  * **Symptom Patterns & Mood Tables:** Clean, structured tabular breakdown designed for rapid physician scanning.
  * **Clinical Observation Summary:** Diagnostic synthesis paragraph.
  * **Download & Share Handlers:** Native system print/save dialog integration for "Download PDF" and native share sheet for "Share with Doctor".

### 6. Notifications & Reminders (`lib/features/reminders/`)
* Customizable daily check-in alerts, period start predictions, fertile window notifications, and medication/contraception reminders.

---

## 📂 Project Architecture

```
lib/
├── core/
│   ├── router/          # AppRouter (go_router route definitions)
│   ├── theme/           # AppColors, AppTheme, typography tokens
│   └── widgets/         # Reusable global widgets (InfoDialog, buttons, custom app bars)
├── features/
│   ├── auth/            # Auth screens & state
│   ├── calendar/        # Calendar screen & providers
│   ├── checkin/         # Daily check-in bottom sheets and forms
│   ├── doctor_report/   # Doctor report setup, preview, and PdfGeneratorService
│   ├── history/         # Past cycle logs & timelines
│   ├── home/            # Home dashboard, cycle dial, and widgets
│   ├── insights/        # Comparison tables, pattern graphs, mood/pain analytics
│   ├── onboarding/      # User onboarding questionnaire
│   ├── period_logging/  # Specialized flow & bleeding logging
│   ├── profile/         # User profile, health settings, preferences
│   ├── reminders/       # Notification scheduler & settings
│   └── welcome/         # Splash and welcome landing screens
├── shared/              # Shared models, utilities, constants
└── main.dart            # Application entry point & Riverpod ProviderScope
```

---

## 🛠️ Tech Stack & Key Dependencies

| Dependency | Purpose |
| :--- | :--- |
| `flutter_riverpod: ^2.6.1` | Reactive state management & dependency injection |
| `go_router: ^17.5.0` | Declarative, URL-based deep linking & navigation |
| `table_calendar: ^3.2.1` | Highly customizable monthly/weekly calendar widget |
| `fl_chart: ^1.2.0` | High-performance interactive charts for insights |
| `pdf: ^3.13.0` | Native PDF document layout and generation engine |
| `printing: ^5.15.0` | Native OS print preview, layout, and PDF export dialogs |
| `google_fonts: ^8.2.1` | Typography & dynamic font loading |
| `intl: ^0.20.3` | Date formatting, localization, and time utilities |

---

## 🗺️ Architectural Roadmap

### 📍 Current Stage: UI Complete with Dummy State
All screens, charts, tables, navigation flows, and PDF generation are fully built and visually polished using in-memory mock data.

---

### 📍 Next Milestone: Phase 1 — Offline-First SQLite Integration
To provide a private, zero-latency experience that functions without network connectivity:
1. **Package:** Integrate `sqflite` and `path_provider`.
2. **Local Schema:**
   * `users` (id, name, age, height, weight, blood_group, created_at)
   * `cycles` (id, user_id, start_date, end_date, length, is_predicted)
   * `daily_logs` (id, cycle_id, date, flow, pain_level, mood, sleep_hours, water_intake, stress_level)
   * `symptom_entries` (id, log_id, symptom_name, severity)
3. **Repository Pattern:** Create Data Repositories (`CycleRepository`, `LogRepository`) wired to Riverpod StateNotifiers to replace hardcoded lists.

---

### 📍 Future Milestone: Phase 2 — Cloud Sync & Authentication (Supabase)
1. **Auth:** Supabase Auth (Email/Password, Magic Link, or Apple/Google Sign-In) to sync user identity.
2. **PostgreSQL Sync:** Two-way sync engine bridging local SQLite rows with remote Supabase PostgreSQL tables when internet is active.
3. **Row-Level Security (RLS):** Strict cryptographic protection ensuring only authenticated users can access their sensitive health logs.

---

### 📍 Future Milestone: Phase 3 — Backend API & AI Insights (Python FastAPI + LLMs)
1. **Backend Framework:** Python (FastAPI) for high-concurrency asynchronous endpoints.
2. **AI-Driven Personalization:**
   * Backend aggregates anonymized 3-month cycle trends.
   * Prompts Anthropic Claude or OpenAI GPT-4o-mini to generate compassionate, clinically sound lifestyle recommendations (e.g., luteal phase nutrition, sleep hygiene during high-stress cycles).
   * Caches insights to minimize latency and token cost.

---

## 💻 Local Setup & Development

### Prerequisites
* Flutter SDK (`>=3.22.0`)
* Dart SDK (`>=3.4.0`)
* Android Studio / Xcode

### Installation
```bash
# 1. Clone repository
git clone https://github.com/Sufiyaansari08/Bloom.git
cd bloom

# 2. Install dependencies
flutter pub get

# 3. Run the development build
flutter run

# 4. Build release APK (Android)
flutter build apk --release
```

---

## 📄 License & Attribution
Developed with ❤️ by the Bloom Team. Proprietary & Confidential for commercial deployment.
