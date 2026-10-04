# NutriAI — Full Google Stitch UI Prompts (Coral/Orange Inspiration)

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

Style: playful, modern, soft, and premium with a warm aesthetic. Floating elements and lots of white space.

Colors:
- Primary: vibrant coral/orange (#FC5C39 to #FF8A66 gradient for hero elements)
- Secondary: soft peach (#FFEDD5)
- Macro colors: Calories light blue (#E0F2FE), Carbs mint green (#D1FAE5), Fat soft peach (#FFEDD5)
- Background light: #F8F9FA, cards white, text dark slate #1E293B / #64748B
- Dark mode: background #0F172A, cards #1E293B, same accents

Typography: Poppins or Nunito. Friendly, rounded sans-serif. Large bold headings (28-32px), body 14-16px, big bold numbers for stats.
Shape: heavily rounded cards (24px radius), pill buttons, soft diffused drop shadows on floating elements.
Components: primary pill button (coral), floating bottom navigation bar (pill shape, not full width) with 5 icons: Home, Analytics, a prominent circular '+' center button in coral, Plan, Settings. Semi-circle gauge for daily progress. Meal cards with rounded thumbnails. 
Iconography: soft, rounded line icons. Large touch targets (min 48px).
Generate both light and dark versions.
```

---

## AUTH & ONBOARDING

### 1. Splash
```text
Splash screen for NutriAI. Centered logo: a stylized coral/orange leaf or fire icon combined with a camera lens. App name "NutriAI" below in a friendly rounded font. Soft coral gradient background, minimal.
```

### 2. Welcome
```text
Welcome screen for NutriAI. Top: hero illustration of healthy food with a scanning frame. Headline "Track meals with a photo". Subtext "AI estimates calories and macros in seconds." Three-dot page indicator (one coral). Buttons: "Get Started" (primary coral pill) and "I already have an account" (text link).
```

### 3. Register
```text
Register screen. Title "Create your account". Fields with icons: Full name, Email, Password (show/hide toggle), Confirm password. Password strength hint. Primary button "Create Account" (coral). Divider "or". Small text "Already have an account? Log in".
```

### 4. Login
```text
Login screen. Title "Welcome back 👋". Fields: Email, Password with show/hide. "Forgot password?" link right aligned. Primary button "Log In" (coral). Bottom: "New here? Create account".
```

### 5. Forgot / Reset password
```text
Forgot password screen: back arrow, title "Reset password", short description, email field, button "Send reset link" (coral). Success state with a mail icon and "Check your inbox".
```

### 6. Onboarding step 1 — Goal
```text
Onboarding step 1 of 8. Top: back arrow and progress bar. Title "What's your goal?". Four large heavily rounded cards with icons: Lose Weight, Maintain Weight, Gain Weight, Build Muscle. Selected card has coral border and check. Bottom: "Continue" button.
```

### 7. Onboarding step 2 — Gender
```text
Onboarding step 2 of 8. Title "What's your gender?". Three selectable pill-shaped cards: Male, Female, Prefer not to say. Continue button.
```

### 8. Onboarding step 3 — Birthday
```text
Onboarding step 3 of 8. Title "When were you born?". A wheel date picker. Shows calculated age chip "You are 28" in soft peach. Continue button.
```

### 9. Onboarding step 4 — Height
```text
Onboarding step 4 of 8. Title "How tall are you?". Toggle cm | ft. Large number display "172 cm" with a horizontal ruler slider below. Continue button.
```

### 10. Onboarding steps 5 & 6 — Weight and target weight
```text
Two onboarding screens. Screen 5: "Current weight?" with big number "72.0 kg" and a ruler slider. Screen 6: "Target weight?" same style, plus a chip showing "-4 kg to go" in coral.
```

### 11. Onboarding step 7 — Activity
```text
Onboarding step 7 of 8. Title "How active are you?". Five stacked selectable cards with icons and descriptions (Sedentary, Lightly Active, etc.).
```

### 12. Onboarding step 8 — Diet
```text
Onboarding step 8 of 8. Title "Any diet preference?". Grid of selectable chips: Everything, Vegetarian, Vegan, Keto, etc. Button "Create my plan".
```

### 13. Calculating + Daily plan result
```text
Loading: animated coral ring. Result "Your daily plan": semi-circle gauge "2,100 kcal/day" with a fire icon. Below, three soft macro chips: Calories (light blue), Carbs (mint green), Fat (soft peach). Buttons: "Start Tracking" (coral) and "Adjust plan".
```

---

## MAIN APP

### 14. Dashboard (Home)
```text
Home dashboard. Header: "Hi Anthony 👋" with avatar and a settings gear. Horizontal week date strip (selected day is coral). Large semi-circle daily progress gauge: "1250 / 2000 cal" with an orange gradient arc and fire icon. Below, three pill-shaped macro chips: Calories (blue), Carbs (green), Fat (peach). Bottom section: Meal cards (Breakfast logged, Not logged yet) with "+ Add Meal" buttons. Floating bottom nav bar with center coral "+" button.
```

### 15. Dashboard — empty & over-target states
```text
Variants of Home dashboard. (a) Empty: semi-circle at 0%, message "Snap your first meal". (b) Over target: semi-circle turns red, "150 cal over", gentle message.
```

### 16. Add Meal
```text
Add Meal bottom-sheet. Meal type chips: Breakfast, Lunch, Snack, Dinner. Two large action cards: "Take Photo" (coral highlight) and "Upload Photo". Search bar "Search food..."
```

### 17. Camera (Scanner)
```text
Scanner screen. Full-screen viewfinder looking at a bowl of vegetables and chicken. A horizontal green laser scan line with a transparent overlay. Top: back button, title "Scanner". Bottom: Floating pills for "Scan Food" (coral active), "Barcode", "Food Label", "Ingredients". Large circular shutter button.
```

### 18. Photo preview
```text
Photo preview screen. Large captured meal photo. Bottom buttons: "Retake" (outline), "Crop", and "Use Photo" (primary coral).
```

### 19. AI analyzing
```text
AI analyzing screen. Meal photo with animated scanning frame. Status text "Identifying your food..." with 3 step indicators.
```

### 20. AI review (key screen)
```text
AI results review. Top: meal photo. Summary card: "480 kcal" with three soft macro chips (blue, green, peach). Detected items: "Chicken Biryani — 250g". Buttons: "+ Add food". Sticky bottom button "Save Meal" (coral).
```

### 21. Edit food item
```text
Edit food item bottom sheet. Fields: Food name, Quantity with stepper, Unit dropdown, and editable Calories, Protein, Carbs, Fat. Save changes button.
```

### 22. AI error states
```text
Error screens: (a) "AI is unavailable"; (b) "Couldn't find food" with "Retake photo" (coral); (c) "Scan limit reached".
```

### 23. Food search
```text
Food search screen. Search bar. Result cards: food name, serving, kcal, heart icon, "+" button.
```

### 24. Food detail / quantity
```text
Food detail bottom sheet. Food name "Avocado Toast". Donut chart of macros in blue, green, peach. Button "Add to Breakfast" (coral).
```

### 25. Custom food
```text
Create custom food form. Fields: Name, Serving, Calories, Macros. "Save food" button.
```

### 26. Recipes tab
```text
Recipes screen. Top: back arrow, title "Recipes", "Favorites" coral button. Search bar. Horizontal filters (Breakfast, Lunch). Grid of highly rounded recipe cards showing image, title "Avocado Toast", "520 Kcal", time "10 min".
```

### 27. Meal detail
```text
Meal detail screen. Large photo header. Title "Lunch". Nutrition summary card with semi-circle gauge. Item list. Actions: Edit, Duplicate, Delete.
```

### 28. Water tracking
```text
Water tracking screen. Liquid wave fill animation. Quick add buttons: +250ml.
```

### 29. Analytics (Progress)
```text
Analytics tab. Range selector tabs. Bar chart for calories per day. Horizontal bars for macros. 7-day streak row with check circles.
```

### 30. Add weight
```text
Add weight bottom sheet: large number input, date picker, "Save" button.
```

### 31. Weekly report
```text
Weekly report screen. Stat tiles: avg calories, avg protein. Highlights with coral checks.
```

### 32. Plan
```text
Plan tab. "AI Nutrition Coach" placeholder, sparkle illustration, "Coming soon".
```

---

## PROFILE, SETTINGS & PAYWALL

### 33. Profile
```text
Profile screen. Avatar, name, "Edit profile". Stat row. Card list for Settings, Notifications, Subscription.
```

### 34. Edit profile & nutrition goals
```text
Edit profile screen. Avatar change, height, weight. Nutrition goals screen with sliders.
```

### 35. Settings
```text
Settings screen. Account, Preferences (Theme), Notifications, Privacy.
```

### 36. Paywall
```text
Subscription paywall. Coral gradient header "Unlock Pro". Plan selector cards. Button "Start Pro".
```

### 37. Delete account confirmation
```text
Delete account confirmation dialog. Warning icon, text field to type DELETE, red delete button.
```

---

## REFINEMENT PROMPTS (use after generating)

```text
Keep the same design system. Ensure the floating bottom navigation bar is present.
```
```text
Use the semi-circle gauge for daily progress instead of a full circle.
```
```text
Ensure macro chips use the soft blue, green, and peach pastel colors.
```
