# 💊 MediTick - Medicine Reminder App

**MediTick** is a Flutter-based mobile application designed to help users manage their daily medication schedules. It features a clean, professional UI, local database persistence, and reliable background alarm notifications.

This project was built as an assignment for the **Internshala Internship**, strictly adhering to the design and technical constraints provided.

---

## 📱 Features

- **📅 Smart Scheduling:** Users can add medicines with specific dosages and time schedules.
- **🔔 Reliable Alarms:** triggers full-screen "Alarm" style notifications with sound at the exact scheduled time (even if the app is closed).
- **💾 Local Persistence:** Uses **Hive Database** to store data locally without an internet connection.
- **⚡ Auto-Sorting:** The home screen automatically sorts medicines chronologically (e.g., 9 AM meds appear before 2 PM meds).
- **🎨 UI/UX Constraint:** Strictly follows the **Teal (Primary)** and **Orange (Accent)** color scheme.

---

## 🛠️ Tech Stack & Architecture

- **Framework:** Flutter (Dart)
- **State Management:** `Provider` (Separation of Logic & UI)
- **Local Storage:** `Hive` (NoSQL, fast, lightweight)
- **Notifications:** `flutter_local_notifications`
- **Date/Time Handling:** `intl` & `timezone`

### 📂 Folder Structure (Clean Architecture)

The project follows a modular structure to ensure scalability and readability:

lib/ ├── main.dart # Entry point & App Config ├── models/ # Data Models (Hive Adapters) │ └── medicine.dart ├── providers/ # State Management Logic │ └── medicine_provider.dart ├── screens/ # UI Screens │ ├── home_screen.dart # List of medicines │ └── add_medicine_screen.dart ├── services/ # Background Services │ └── notification_service.dart # Alarm & Notification Logic └── widgets/ # Reusable UI Components

## 🚀 How to Run

1.  **Clone the repository:**

    ```bash
    git clone [https://github.com/SumitSinghBharangar/medi_tick](https://github.com/SumitSinghBharangar/medi_tick)
    ```

2.  **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the App:**
    ```bash
    flutter run
    ```

> **Note for Android 13+ Users:**
> Upon first launch, the app will request permission to send notifications and schedule exact alarms. Please **Allow** these permissions to ensure the reminder system functions correctly.

---

## 🧠 Key Technical Decisions

**Why Hive instead of Shared Preferences?**

- **Scalability:** Storing a list of complex objects (Medicines) in Shared Preferences requires constant JSON encoding/decoding, which is inefficient. Hive handles object storage natively and is significantly faster.
- **Reactive UI:** Hive pairs well with Provider to update the UI instantly when data changes.

**Why Provider?**

- To avoid "Spaghetti Code" caused by passing data down the widget tree manually.
- To separate business logic (saving data, scheduling alarms) from the UI layer.

---

## 👨‍💻 Author

**Sumit Singh**

- Computer Science Student
- Flutter Developer
