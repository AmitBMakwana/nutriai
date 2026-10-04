# NutriAI — Full Google Stitch UI Prompts

**Workflow**
1. Open https://stitch.withgoogle.com and create a new project. Choose **Mobile app**.
2. Paste **Prompt 0 (Design System)** first.
3. Then paste screen prompts **one at a time**. Each one repeats the key style so results stay consistent.
4. Refine with the follow-up prompts at the end.
5. Export to Figma/code and save in `design/` in your repo.

---

## PROMPT 0 — Design system (paste first)

```text
Design a mobile app called "NutriAI", an AI-powered nutrition and calorie tracking app. Tagline: "Snap your meal. Understand your nutrition. Reach your goal."

Style: modern, minimal, premium, friendly health-tech. Clean and airy, lots of white space.

Colors:
- Primary: fresh green (#22C55E to #16A34A gradient allowed for hero elements)
- Secondary: warm orange (#F59E0B) for calories/energy
- Macro colors: Protein blue (#3B82F6), Carbs amber (#F59E0B), Fat rose (#F43F5E)
- Water: sky blue (#38BDF8)
- Background light: #F8FAFC, cards white, text slate #0F172A / #64748B
- Dark mode: background #0B1220, cards #111A2E, same accents

Typography: Inter or Plus Jakarta Sans. Large bold headings (28-32px), body 15-16px, big numbers for stats.
Shape: rounded cards 20px radius, pill buttons, 8px spacing grid, soft subtle shadows.
Components: primary pill button (green), secondary outline button, rounded input fields with icons, circular calorie ring, macro progress cards, meal cards with thumbnail, bottom sheets, skeleton loaders, empty states with friendly illustrations.
Bottom navigation with 5 tabs: Home, Meals, Progress, Coach (with a "Soon" badge), Profile. A large centered green camera button for scanning.
Iconography: consistent rounded line icons. Large touch targets (min 48px).
Generate both light and dark versions.
```

---

## AUTH & ONBOARDING

### 1. Splash
```text
Splash screen for NutriAI. Centered logo: a green leaf combined with a camera-lens/viewfinder shape. App name "NutriAI" below and tagline "Snap your meal. Understand your nutrition." Soft green gradient background, minimal.
```

### 2. Welcome
```text
Welcome screen for NutriAI. Top: hero illustration of a plate of Indian food (dal, roti, rice) with a scanning frame and floating nutrition chips (kcal, protein). Headline "Track meals with a photo". Subtext "AI estimates calories and macros in seconds." Three-dot page indicator. Buttons: "Get Started" (primary green) and "I already have an account" (text link).
```

### 3. Register
```text
Register screen. Title "Create your account". Fields with icons: Full name, Email, Password (show/hide toggle), Confirm password. Password strength hint. Primary button "Create Account". Divider "or". Small text "Already have an account? Log in". Footer: Terms and Privacy links. Show one field in an error state with red helper text.
```

### 4. Login
```text
Login screen. Title "Welcome back 👋". Fields: Email, Password with show/hide. "Forgot password?" link right aligned. Primary button "Log In". Bottom: "New here? Create account".
```

### 5. Forgot / Reset password
```text
Forgot password screen: back arrow, title "Reset password", short description, email field, button "Send reset link". Also design the success state with a mail icon and "Check your inbox" message.
```

### 6. Onboarding step 1 — Goal
```text
Onboarding step 1 of 8. Top: back arrow and segmented progress bar (1/8). Title "What's your goal?". Four large selectable cards with icons: Lose Weight, Maintain Weight, Gain Weight, Build Muscle. One card shown selected with green border and check. Bottom: "Continue" button.
```

### 7. Onboarding step 2 — Gender
```text
Onboarding step 2 of 8. Title "What's your gender?". Subtext "Used to calculate your calorie needs." Three selectable cards: Male, Female, Prefer not to say. Continue button.
```

### 8. Onboarding step 3 — Birthday
```text
Onboarding step 3 of 8. Title "When were you born?". A wheel/scroll date picker (day, month, year). Shows calculated age chip "You are 28". Continue button.
```

### 9. Onboarding step 4 — Height
```text
Onboarding step 4 of 8. Title "How tall are you?". Toggle switch cm | ft/in. A large number display "172 cm" with a horizontal ruler slider below. Continue button.
```

### 10. Onboarding steps 5 & 6 — Weight and target weight
```text
Two onboarding screens (5 of 8 and 6 of 8). Screen 5: "What's your current weight?" with kg | lb toggle, big number "72.0 kg" and a ruler slider. Screen 6: "What's your target weight?" same style, plus a chip showing "-4 kg to go" in green.
```

### 11. Onboarding step 7 — Activity
```text
Onboarding step 7 of 8. Title "How active are you?". Five stacked selectable cards, each with icon, title and one-line description: Sedentary (desk job), Lightly Active (1-3 workouts/week), Moderately Active (3-5/week), Very Active (6-7/week), Extremely Active (physical job + training). One selected.
```

### 12. Onboarding step 8 — Diet
```text
Onboarding step 8 of 8. Title "Any diet preference?". Grid of selectable chips/cards with icons: Everything, Vegetarian, Vegan, Pescatarian, Keto, Other. Button "Create my plan".
```

### 13. Calculating + Daily plan result
```text
Two screens. (a) Loading: animated green ring with text "Building your personalized plan..." and rotating small tips. (b) Result "Your daily plan": large calorie ring "2,100 kcal/day", below three macro cards (Protein 140g, Carbs 210g, Fat 70g) and a water goal "2.5 L". Small note: "These are estimates, not medical advice." Buttons: "Start Tracking" (primary) and "Adjust plan" (text).
```

---

## MAIN APP

### 14. Dashboard (Home)
```text
Home dashboard, the main screen. Header: "Good morning 👋" and name "Amit" with avatar on the right, and a horizontal week date strip. Large circular calorie ring "1,245 / 2,100 kcal" with "855 kcal remaining" in the center. Below, three compact macro cards with progress bars: Protein 72/140g (blue), Carbs 135/210g (amber), Fat 38/70g (rose). Section "Today's meals": cards for Breakfast 420 kcal, Lunch 510 kcal, Snack 150 kcal with small food thumbnails, and an empty Dinner card with "+ Add". Water card "1.5 L / 2.5 L" with a wave fill and quick +250ml button. Bottom navigation with centered green scan button.
```

### 15. Dashboard — empty & over-target states
```text
Two variants of the Home dashboard. (a) New user, no meals: ring at 0, friendly illustration, message "Snap your first meal", big "Scan a meal" button. (b) Over target: ring turns orange/red with "150 kcal over", gentle non-judgmental message.
```

### 16. Add Meal
```text
Add Meal bottom-sheet/screen. Title "Add meal". Meal type chips: Breakfast, Lunch, Snack, Dinner. Two large action cards: "Take Photo" (camera icon, highlighted green) and "Upload Photo" (gallery icon). Divider "or". Search bar "Search food..." and quick row "Recent" and "Favorites".
```

### 17. Camera
```text
In-app camera screen. Full-screen viewfinder with a rounded scanning frame and hint "Place your meal inside the frame". Top: close button, flash toggle. Bottom: gallery thumbnail, large white capture button, camera flip. Tip chip: "Good lighting = better accuracy".
```

### 18. Photo preview
```text
Photo preview screen. Large captured meal photo. Bottom buttons: "Retake" (outline), "Crop", and "Use Photo" (primary green). Meal type chip shown at top.
```

### 19. AI analyzing
```text
AI analyzing screen. Meal photo with a animated green scanning line and corner brackets. Below: status text "Identifying your food..." with 3 step indicators (Detecting food, Estimating portions, Calculating nutrition) where the first is complete. Subtle sparkle icon.
```

### 20. AI review (key screen)
```text
AI results review screen. Top: small meal photo with a "✨ Meal analyzed" header and overall confidence "82% confidence" pill. Summary card: total "480 kcal" with three macro chips (Protein 22g, Carbs 58g, Fat 18g). List of detected items as cards: "Chicken Biryani — 250 g — 480 kcal" with confidence badge, edit pencil and remove icon. One item with a yellow "Low confidence, please check" badge. Buttons: "+ Add food". Footer note "Values are AI estimates." Sticky bottom primary button "Save Meal".
```

### 21. Edit food item
```text
Edit food item bottom sheet. Fields: Food name, Quantity with -/+ stepper, Unit dropdown (g, ml, piece, bowl, cup), and editable Calories, Protein, Carbs, Fat. Live preview of totals at top. Buttons "Cancel" and "Save changes". Small text "Changing quantity rescales nutrition automatically."
```

### 22. AI error states
```text
Three compact error/empty screens with friendly illustrations: (a) "AI is unavailable" with buttons "Try again" and "Enter meal manually"; (b) "We couldn't find food in this photo" with "Retake photo"; (c) "You've used all free scans this month" with "Upgrade to Pro" and "Add manually".
```

### 23. Food search
```text
Food search screen. Search bar with results below. Each result card: food name, serving ("1 medium roti, 40 g"), kcal and small macro numbers, heart/favorite icon and "+" button. Tabs: All, Favorites, My foods. Empty state and "Create custom food" link.
```

### 24. Food detail / quantity
```text
Food detail bottom sheet. Food name "Paneer Tikka". Serving selector and quantity stepper. Nutrition breakdown with donut chart of macros and rows for Calories, Protein, Carbs, Fat, Fiber. Button "Add to Lunch".
```

### 25. Custom food
```text
Create custom food form: Food name, Brand (optional), Serving size and unit, Calories, Protein, Carbs, Fat, Fiber. Button "Save food".
```

### 26. Meals tab
```text
Meals tab. Horizontal date strip. Day summary card (total kcal and macros). List grouped by Breakfast, Lunch, Snack, Dinner with meal cards (thumbnail, items summary, kcal, time). Swipe actions shown for Duplicate and Delete. Empty state for a day with no meals.
```

### 27. Meal detail
```text
Meal detail screen. Large photo header. Title "Lunch", time "12:42 PM". Nutrition summary card. Item list (Chicken Biryani 250 g, 480 kcal, macros). Actions: Edit, Duplicate, Delete (red, with confirmation dialog shown).
```

### 28. Water tracking
```text
Water tracking screen. Large animated glass/bottle fill showing "1.5 L / 2.5 L". Quick add buttons: 250 ml, 500 ml, 750 ml, 1000 ml. Today's log list with times and delete option. A -/+ 250 ml stepper.
```

### 29. Progress
```text
Progress tab. Range selector tabs: 7D, 30D, 3M, 6M, 1Y. Weight card: current 72 kg, target 68 kg, line chart trending down with dots, "Add weight" button. Calories card: bar chart per day with dashed target line and "Avg 1,920 kcal". Macros card: three horizontal bars with averages. Consistency card: "19 meals tracked" and a 7-day streak row with check circles.
```

### 30. Add weight
```text
Add weight bottom sheet: large number input with kg/lb toggle, date picker row, "Save" button, and a small history preview.
```

### 31. Weekly report (future)
```text
Weekly report screen (Phase 2, Sunday): title "Your weekly report". Stat tiles: avg calories 1,920, avg protein 118g, meals tracked 19, weight -0.6 kg. Highlights with green checks ("Protein goal hit 5 days"). Areas to improve with amber bullets. Friendly, non-medical tone.
```

### 32. Coach (coming soon)
```text
Coach tab placeholder: sparkle illustration, title "AI Nutrition Coach", "Coming soon", short benefits list (meal ideas, weekly insights), and "Notify me" button.
```

---

## PROFILE, SETTINGS & PAYWALL

### 33. Profile
```text
Profile tab. Avatar, name, email, "Edit profile" button. Stat row: Goal, Weight, Target. Card list: Nutrition goals, Body details, Units, Notifications, Subscription (with Pro badge), Privacy, Logout in red.
```

### 34. Edit profile & nutrition goals
```text
Two screens. (a) Edit profile: avatar change, name, height, weight, target weight, activity level dropdown, diet dropdown, Save. (b) Nutrition goals: editable calories, protein, carbs, fat and water with sliders, "Recalculate automatically" button, disclaimer.
```

### 35. Settings
```text
Settings screen with grouped sections: Account (email, change password), Preferences (Units metric/imperial, Language, Theme Light/Dark/System segmented control), Notifications (toggles for meal reminders, water reminders, weight reminder, weekly report with time pickers), Privacy (download data, Delete account in red), About (Terms, Privacy Policy, version).
```

### 36. Paywall
```text
Subscription paywall. Premium look with green gradient header, title "Unlock NutriAI Pro". Benefits with checks: 100 AI scans/month, detailed progress insights, weekly AI reports, priority analysis. Plan selector cards: Monthly and Yearly (Best value badge, savings %). Button "Start Pro". Small links: Restore purchases, Terms. Also a small usage banner variant: "3 of 5 free scans used".
```

### 37. Delete account confirmation
```text
Delete account confirmation dialog: warning icon, explanation that all meals, photos and data will be permanently deleted, text field to type DELETE, buttons "Cancel" and "Delete permanently" (red).
```

---

## REFINEMENT PROMPTS (use after generating)

```text
Keep the same design system. Make the calorie ring larger and add a soft green glow.
```
```text
Apply dark mode to this screen using the NutriAI dark palette.
```
```text
Make the layout more compact so it fits without scrolling on a 375x812 screen.
```
```text
Use Indian food examples in the content (roti, dal, paneer, idli, dosa, poha, biryani).
```
```text
Make the bottom navigation consistent with the other screens, with the centered scan button.
```
