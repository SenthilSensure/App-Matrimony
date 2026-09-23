# Matrimony App (app_matrimony)

A Flutter matrimony application running on **Android, iOS and Web** from a single codebase.

---

## 1. Is Signup Required? (Design Decision)

**Yes — but signup must stay minimal.**

Signup exists only to **create and verify an identity**. All the rich profile data
(religion, education, income, family, photos, partner preferences) is collected
*after* signup in a **guided Profile Completion wizard**, and later editable from the
**Profile page**.

Why not collect everything on signup?

| Approach | Result |
|---|---|
| All 25 fields on signup | Users abandon the form; no lead captured |
| Minimal signup + wizard | Account is created early; profile is completed step by step; drop-offs can be re-targeted via the verified mobile number |

### Field split

**Signup screen (minimum required)**
- Profile created for (Self / Son / Daughter / Brother / Sister / Relative)
- Full name
- Gender
- Date of birth (age auto-calculated, must be 18+)
- Mobile number → **OTP verification**
- Email (optional) / Password (only if using password login)

**Profile completion wizard (after OTP, before browsing matches)**
1. Religion & community — religion, caste/community, mother tongue, gothra (optional)
2. Education & career — highest education, occupation, employed in, annual income
3. Lifestyle & physical — height, weight, marital status, diet, smoke/drink, body type
4. Location — address, city, state, pincode, country
5. Family details — family type, family status, father/mother occupation, siblings
6. About me — short bio
7. Photos — profile photo + gallery (private/public)
8. Partner preferences — age range, height range, religion, caste, education, occupation, income, location

**Profile page (later)** — view/edit everything above, manage photos, privacy settings,
profile completion percentage, verification badges.

---

## 2. Complete Screen Flow

```
Splash (5s, reads login flag)
   |
   +-- logged in ------------------------------> Home (Dashboard)
   |
   +-- not logged in --> Intro / Onboarding --> Login
                                                  |
                                                  +--> OTP Verify --> Home
                                                  |
                                                  +--> Signup (minimal)
                                                          |
                                                          v
                                                    OTP Verify
                                                          |
                                                          v
                                            Profile Completion Wizard (steps 1..8)
                                                          |
                                                          v
                                                        Home
```

### Screen list

**A. Onboarding / Auth**
| # | Screen | Purpose |
|---|---|---|
| 1 | Splash | Branding, read login flag, route to Home or Login |
| 2 | Intro / Onboarding | 2–3 slides explaining the app (first launch only) |
| 3 | Login | Mobile number entry |
| 4 | OTP Verification | 6-digit OTP, resend timer, auto-read on Android |
| 5 | Signup | Minimal profile creation |
| 6 | Profile Completion Wizard | Multi-step form with progress indicator |

**B. Core**
| # | Screen | Purpose |
|---|---|---|
| 7 | Home / Dashboard | Daily recommendations, new matches, quick stats |
| 8 | Search / Filters | Advanced search: age, height, religion, caste, location, income, education |
| 9 | Match List | Recommended, newly joined, near me, mutual matches |
| 10 | Profile Detail (other user) | Full profile, photos, interest / shortlist / chat actions |
| 11 | Shortlist / Saved | Saved profiles |
| 12 | Interests | Sent, Received, Accepted, Declined tabs |
| 13 | Chat List | Conversations (unlocked after interest is accepted) |
| 14 | Chat Detail | 1-to-1 messaging |
| 15 | Notifications | Interest received/accepted, profile views, plan expiry |

**C. My Account**
| # | Screen | Purpose |
|---|---|---|
| 16 | My Profile | View own profile + completion % |
| 17 | Edit Profile | Section-wise editing (same sections as the wizard) |
| 18 | Manage Photos | Upload, delete, reorder, set primary, privacy |
| 19 | Partner Preferences | Edit match criteria |
| 20 | Who Viewed Me | Visitors list (usually premium) |
| 21 | Membership / Plans | Plan comparison |
| 22 | Payment / Checkout | Payment gateway + status |
| 23 | Settings | Notifications, privacy, change number, language |
| 24 | Help & Support | FAQ, contact, report a profile |
| 25 | Static pages | Terms, Privacy Policy, About (WebView) |
| 26 | Delete / Hide Profile | Deactivate or delete account |

**D. Admin/Ops (optional, usually web-only)**
- Profile verification queue, reported profiles, plan management.

---

## 3. Suggested Project Structure

```
lib/
├── main.dart
├── base/                # BasePage, BaseState, BasicPage, BaseProvider, BaseRepo
├── model/               # Request/response models (signup, profile, match, chat…)
├── provider/            # One provider per feature (state + validation + API calls)
├── service/             # ApiClient, ApiUrls, ApiMethods, repositories
├── ui/
│   ├── intro/           # splash, onboarding
│   ├── login/           # login, otp
│   ├── signup/          # signup, profile completion wizard
│   ├── home/            # dashboard, match list, search
│   ├── profile/         # my profile, edit, photos, preferences
│   ├── chat/            # chat list, chat detail
│   └── plans/           # membership, payment
└── utils/
    ├── constants/       # app_colors, app_text_style, app_strings, app_components…
    ├── di/              # get_it locator
    ├── router/          # app_router, route_guard
    ├── security/        # key manager, encryption
    └── storage/         # shared preferences wrapper
```

### Conventions used in this project
- **Every page** extends `BasePage` + `BaseState` with the `BasicPage` mixin.
- **Every page** exposes `uiWeb()` and `uiMobile()` and switches with `kIsWeb`,
  while all visual pieces are shared private widgets so both layouts stay identical.
- **No hard-coded strings/colors/styles** — use `AppStrings`, `AppColors`, `AppTextStyle`.
- **No inline widgets for inputs/buttons** — use `AppTextField`, `AppTextFieldTitle`,
  `AppDropDownBox`, `AppButton` from `app_components.dart`.
- **Controllers, validation and API calls live in the Provider**, never in the page.
- Navigation uses named routes registered in `AppRouter`; web routes are encrypted
  and protected by `RouteGuard`.

---

## 4. API Endpoints (expected)

| Area | Endpoint | Method |
|---|---|---|
| Auth | `authenticate` | POST |
| Signup | `MobileUserSignUp` | POST |
| OTP | `SendOtp`, `VerifyOtp` | POST |
| Profile | `GetProfile`, `UpdateProfile` | GET/POST |
| Photos | `UploadPhoto`, `DeletePhoto` | POST |
| Matches | `GetMatches`, `SearchProfiles` | POST |
| Interest | `SendInterest`, `RespondInterest` | POST |
| Chat | `GetChatList`, `GetMessages`, `SendMessage` | POST |
| Plans | `GetPlans`, `CreateOrder`, `VerifyPayment` | POST |

Base URL comes from `FlavorConfig` (`lib/utils/constants/flavor_config.dart`).

---

## 5. Current Status

| Screen | Status |
|---|---|
| Splash | ✅ Implemented (asset logo, 5s delay, routes by login flag) |
| Login | ✅ UI implemented (mobile number) — API pending |
| Signup | ✅ Minimal signup (profile for, name, gender, DOB/age, mobile) + provider + `MobileUserSignUp` call |
| Home | 🟡 Placeholder with logout |
| OTP, Profile wizard, Matches, Chat, Plans | ⬜ Not started |

### Theme
Derived from the app icon (`assets/matri_match.jpg`):
- Primary `#D6376E` (rose), Button `#E2457B`, Accent `#F2BF64` (gold),
  Background `#FFF6F9`, Border `#E0D7DB`.

---

## 6. Running the Project

```bash
flutter pub get

# Web  (do NOT use 5000 - it clashes with the API server and macOS AirPlay)
flutter run -d chrome --web-port 5173 \
  --dart-define=BASE_URL=http://localhost:5001/api/

# Android / iOS  (use the LAN IP of your machine, not localhost)
flutter run --dart-define=BASE_URL=http://192.168.1.2:5001/api/

# Release builds
flutter build web --release
flutter build apk --release
```

Requires Flutter SDK `^3.11.5`.

### 6.1 `ClientException: Failed to fetch` on web

On web, `http` calls run inside the browser, so `Failed to fetch` is the
browser refusing/failing the request. It has **four** possible causes:

| Cause | Check | Fix |
|---|---|---|
| API server not running | `lsof -nP -iTCP:5001 -sTCP:LISTEN` returns nothing | Start the backend |
| Port clash | Flutter web dev server was on `5000`, same as the API (macOS AirPlay Receiver also uses 5000) | Run web on `5173`, API on `5001` |
| **CORS** not enabled | Browser console shows `blocked by CORS policy` | Add CORS headers on the server (below) |
| Wrong host | `localhost` on the device ≠ your Mac | Web → `localhost`, Android emulator → `10.0.2.2`, real device → LAN IP |

The server must answer the pre-flight `OPTIONS` request. Express example:

```js
const cors = require('cors');
app.use(cors({ origin: '*' }));   // dev only
app.options('*', cors());
```

Verify from the terminal before blaming the app:

```bash
curl -i -X OPTIONS http://localhost:5001/api/signup \
  -H "Origin: http://localhost:5173" \
  -H "Access-Control-Request-Method: POST" \
  -H "Access-Control-Request-Headers: content-type"
```

You should see `Access-Control-Allow-Origin` in the response headers.

The base URL is no longer hard-coded — `main.dart` reads `BASE_URL` from
`--dart-define` and falls back to `localhost` on web / the LAN IP on mobile.

---

## 7. Next Steps

1. ~~Trim the signup page to the minimum fields~~ ✅ done.
2. Add the **OTP verification** screen (`sms_autofill` is already a dependency).
3. Build the **Profile Completion wizard** (one provider, 8 steps, progress bar).
4. Implement Home dashboard + match list + search filters.
5. Add interests, chat and membership plans.
