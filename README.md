# Sitzplan

Shared classroom seating plans for a small teaching team: draw rooms, enter classes as pseudonym codes, drag students onto seats, seat by rules (pairs apart/together, front/back, mixing, rotation), present on a smartboard, save an A4 image.

- Static site (GitHub Pages), data in Supabase (EU / Frankfurt), sign-in by e-mail link.
- Only e-mail addresses listed in `allowed_emails` can read or write anything.
- Fonts and the Supabase library are served from this site; no third-party CDNs.
- Store initials or pseudonyms only, never full names.

Setup: run `supabase/schema.sql` in the Supabase SQL Editor, add team e-mails to `allowed_emails`, put the project URL and anon key in `config.js`.
