# InvestMate (Flutter + Firebase)

## What’s implemented
- App starts on an authentication screen (`AuthScreen`) with login and signup.
- Signup includes choosing a role (investor or project manager).
- After successful auth, the app navigates to a 4-tab layout (`MainWrapper`): Home, Explore, Portfolio, Profile.
- Explore supports search + filters and opens a project details page.
- Home, Explore, Portfolio, Profile, and Project Details screens render using mock (hard-coded) demo data.
- Profile includes a logout action that returns to the auth screen.

## Project structure (quick tour)
- `lib/main.dart`: App entry point + Firebase initialization.
- `lib/mainWrapper.dart`: Bottom navigation wrapper that switches between main screens.
- `lib/Screens/`: UI pages (auth, dashboard, explore, portfolio, profile, details, etc.).
- `lib/Models/`: Data models (example: `UserModel`, `Project`).
- `lib/Services/`: Intended place for API/database services.
- `lib/Theme/`: Colors and theme helpers.


## Tech stack used
### Flutter
- UI was built with Flutter widgets (Material design)
- Shared colors were centralized in `AppColors`

## What’s used right now (packages)
### Runtime dependencies
- **firebase_core**: Firebase initialization.
- **firebase_auth**: Email/password login and signup.
- **firebase_database**: Realtime Database access (read/write references).

### Authentication
The login/signup screen used `FirebaseAuth`:
- Login: `signInWithEmailAndPassword`
- Signup: `createUserWithEmailAndPassword`

