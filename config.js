// Supabase connection. Both values are public by design: access is controlled
// by the database rules (only e-mails in allowed_emails can read or write).
window.SITZPLAN_CONFIG = {
  url: "",      // e.g. https://abcdefgh.supabase.co
  anonKey: ""   // "anon" / "publishable" key from Project Settings → API
};
