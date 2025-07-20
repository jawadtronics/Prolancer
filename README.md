# Prolancer | Perosnalised Ai Job Cover Letter Generator

A smart, credit-based job description generator built with **Flutter Web**, **Supabase**, and **OpenRouter’s DeepSeek AI model**. It allows Google login, user credit management, profile data input, and real-time AI-powered text generation.

---

## 🚀 Features

- 🔐 Google Sign-In using Supabase
- 📥 Auto-create user entry in database on first login
- 🪪 Store user profile data: `id`, `email`, `credits`, `is_pro_user`, `profileDescription`
- 💳 Credit management (e.g. +10 credits button)
- 🧾 Input and display profile description
- 🤖 AI-powered job description generation using OpenRouter + DeepSeek
- 📤 Input field for job description with scrollable output field for AI response
- 🎭 Onboarding popup prompting user to complete profile
- 🧭 Page navigation with fade transitions
- 🧹 Hidden browser back button on generator page
- 🎨 Clean, Material UI with centered text, styled buttons, and Google profile picture

---

## 🛠️ Setup Instructions

### 1. Supabase Setup

1. Go to [https://supabase.io](https://supabase.io) and create a new project.
2. Enable **Google OAuth** in `Authentication > Providers`.
3. Create a table called `user_profiles` with the following columns:

| Column Name        | Type   | Default | Notes                        |
|--------------------|--------|---------|------------------------------|
| `id`               | UUID   |         | Primary Key, from `auth.uid` |
| `email`            | text   |         |                              |
| `credits`          | int    | 10      |                              |
| `is_pro_user`      | bool   | false   |                              |
| `profileDescription` | text | null    | Optional user input          |

4. Enable **Row Level Security (RLS)** on `user_profiles` 



## 🧠 Tech Stack

- Layer	Technology
- Frontend	Flutter Web
- Backend	Supabase (DB + Auth)
- AI	OpenRouter + DeepSeek
- Hosting	Firebase Hosting / Vercel

## 👨‍💻 About the Developer

- Jawad Ul Hassan
- Full Stack Developer | Automation Engineer
- 🌍 LinkedIn ( https://linkdin.com/in/jawadtronics ) 
