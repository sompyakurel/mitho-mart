[![Check site](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml/badge.svg)](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml)

# Mitho Mart - Nepali & Indian Grocery (Sample Portfolio Project)

Mitho Mart is a sample Nepali & Indian grocery website, built as a portfolio project to show HTML, CSS, Git, GitHub Pages, and GitHub Actions CI.

This is a demo only. It is not a real shop. There are no real orders, no payment, and the phone number is fictional.

## Live demo

https://sompyakurel.github.io/mitho-mart/

## What it shows

- HTML for content and structure
- CSS for styling, separate from content
- Git and GitHub for version control
- GitHub Pages for hosting
- GitHub Actions for CI on every push to main

## Project structure

- `index.html` - all the words and headings, categories, and sample phone number
- `style.css` - all the look: orange banner, card grid, colors, and layout. No shop words in this file.
- `.github/workflows/check.yml` - CI check on every push to main. It checks that `index.html` exists and contains "Mitho Mart".
- `README.md` - this file

## How to run it locally

1. Clone the repo:
   `git clone https://github.com/sompyakurel/mitho-mart.git`
2. Open `index.html` in a browser.

No build step and no server are needed for this version.

## How CI works

On every push to `main`, GitHub Actions runs the `Check site` workflow:

1. Checkout the repo
2. Check that `index.html` exists
3. Check that `index.html` contains "Mitho Mart"

If any step fails, the run fails and the badge at the top of this README shows failing. If all steps pass, the badge shows passing.

## What's next

- More shop features, like a Fresh This Week section or a pickup request form
- Terraform and a real deployment step, to show infrastructure as code
