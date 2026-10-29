[![Check site](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml/badge.svg)](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml)

# Mitho Mart - Nepali & Indian Grocery (Sample Portfolio Project)

Mitho Mart is a sample Nepali & Indian grocery website, built as a portfolio project to show HTML, CSS, JavaScript, Git, GitHub Pages, and GitHub Actions CI.

This is a demo only. It is not a real shop. There are no real orders, no payment, and the phone number is fictional.

## Live demo

https://sompyakurel.github.io/mitho-mart/

## Features

- Categories - shop categories as cards
- Fresh This Week - sample fresh items, updated weekly by an owner in a real shop
- Request Pickup - sample pickup form, with a confirmation and a sample MM- reference, no real order, no payment online, you pay in store
- Open-now badge - shows Open now or Closed based on the visitor's current time and sample shop hours, green if open, gray if closed
- Nepali toggle - switches headings and categories between English and Nepali, using data-en and data-ne attributes, with no page reload

## What it shows

- HTML for content and structure
- CSS for styling, separate from content
- JavaScript for interactivity: pickup form confirmation, open-now time logic, and language toggle
- Git and GitHub for version control
- GitHub Pages for hosting
- GitHub Actions for CI on every push to main

## Project structure

- index.html - all the words and headings, categories, fresh items, pickup form, open badge, and language toggle, plus the JavaScript for those features
- style.css - all the look: orange banner, card grid, form card, open badge pill, colors, and layout. No shop words in this file.
- .github/workflows/check.yml - CI check on every push to main. It checks that index.html exists and contains "Mitho Mart".
- README.md - this file

## How to run it locally

1. Clone the repo:
   git clone https://github.com/sompyakurel/mitho-mart.git
2. Open index.html in a browser.

No build step and no server are needed for this version.

## How CI works

On every push to main, GitHub Actions runs the Check site workflow:

1. Checkout the repo
2. Check that index.html exists
3. Check that index.html contains "Mitho Mart"

If any step fails, the run fails and the badge at the top of this README shows failing. If all steps pass, the badge shows passing.

## Known limitations

- The open badge and pickup confirmation messages stay in English for now, even in Nepali mode, because those messages are set by JavaScript at runtime, not stored in data attributes.
- Shop hours and fresh items are hard-coded samples, a real shop would update them from a file or a sheet.

## What's next

- Translate the open badge and pickup confirmation into Nepali mode as well
- Terraform and a real deployment step, to show infrastructure as code

