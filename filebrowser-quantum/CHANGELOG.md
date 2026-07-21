### 1.5.0-stable (2026-07-21)
## What's Changed

 **New Features**:
 - Added basic html viewer with relative reference support (#2522)
 - Shares can have pinned files, requires a user to have edit access to share (#2522)
 - Enhanced search
   - now uses "lazy" match by default. (#2509)
   - added missing `case sensitive` option in the UI
 - Progressive Web App (PWA) improvements
   - restored install prompt with sidebar install button (#2086)
   - camera and video capture buttons on upload (mobile-friendly `capture` inputs)
   - send files to other apps via the Web Share API (`Send to app` in the context menu)
 - App notifications for file operations (#2478)
   - optional browser notifications when uploads, chunked downloads, move/copy, or failures finish while the tab is in the background
   - single on/off toggle in Notifications settings, stored in browser local storage

 **Notes**:
 - [docker] upgraded ffmpeg version 8.1 to 8.1.2

 **BugFixes**:
 - Fixed OnlyOffice reopening an older editor state after a document is modified (#2633) (#2578).
 - Cannot "Reset and generate new two-factor code" to reset the TOTP for a user (#2399) (#2641).
 - fix upload shares with password (#2589) (#2573)
 - fix token when returning from preview on shares with pass (#2588) (#2465)
 - fix share undefined url after editing (#2567) (#2523)
 - fixed PWA manifest `scope` and `id` so install works when the app is served under a base URL
 - installing a public share as a PWA now opens the share URL instead of the site root (#2302)

**Full Changelog**: https://github.com/gtsteffaniak/filebrowser/compare/v1.4.0-stable...v1.5.0-stable

# Changelog

## 1.4.0-stable (2026-07-21)

- Initial FileBrowser Quantum HA addon
- Based on gtsteffaniak/filebrowser v1.4.0-stable
- Support for HA ingress, healthcheck, and persistent storage
