[![Check site](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml/badge.svg)](https://github.com/sompyakurel/mitho-mart/actions/workflows/check.yml)
[![Deploy to S3](https://github.com/sompyakurel/mitho-mart/actions/workflows/deploy.yml/badge.svg)](https://github.com/sompyakurel/mitho-mart/actions/workflows/deploy.yml)

# Mitho Mart - Nepali & Indian Grocery (Sample Portfolio Project)

Mitho Mart is a sample Nepali & Indian grocery website, built as a portfolio project to show HTML, CSS, JavaScript, Git, GitHub Pages, GitHub Actions CI/CD, Terraform, and AWS S3 hosting.

This is a demo only. It is not a real shop. There are no real orders, no payment, and the phone number and address are fictional.

## Live demos

- GitHub Pages (HTTPS): https://sompyakurel.github.io/mitho-mart/
- AWS S3 website (HTTP only): http://mitho-mart-portfolio-sompyakurel.s3-website.us-east-2.amazonaws.com

Note on the S3 URL: the endpoint uses a dot, `s3-website.us-east-2`, not a dash. The dash form gives a DNS NXDOMAIN error. Use the URL above exactly, or get it from Terraform output, do not reconstruct it from memory.

CloudFront (HTTPS for S3) is in progress, not live yet: see "CloudFront status" below.

## Features

- Categories - 11 shop categories as cards, with emoji icons. Tap or click a category, or press Enter / Space when it is focused, to open a detail card below the categories showing sample items in that category. Clicking another category replaces the detail, it does not stack.
- Fresh This Week - 11 sample fresh items, including Fresh Spinach, updated weekly by an owner in a real shop. Sample items only.
- Request Pickup - sample pickup form, after Fresh This Week, with a confirmation and a sample MM- reference, no real order, no payment online, you pay in store.
- Open-now badge - shows Open now or Closed based on the visitor's current time and sample shop hours, green if open, gray if closed. The badge text is fully bilingual, see Nepali below.
- Store Hours - a hours table, Saturday 9 AM - 8:30 PM, all other days 9 AM - 8 PM. The table and the badge use the same hours, so they cannot disagree.
- Visit Us - at the bottom of the page, side by side with Store Hours on desktop, stacked on mobile. Sample address and fictional phone, with a pay-in-store note.
- Hero photo - a produce photo at the top of the page, below the orange banner.
- Nepali toggle - switches the whole site between English and Nepali, using data-en and data-ne attributes, with no page reload. This includes headings, categories, fresh items, hours days, Visit Us, category detail items, and the dynamic messages: the open badge and the pickup confirmation both re-render in the current language when you toggle, even if you toggle after submitting the pickup form. The page declares UTF-8 first in the head, so Devanagari script renders correctly on Pages and on S3.

## What it shows

- HTML for content and structure, CSS for styling, separate from content
- JavaScript for interactivity: pickup form confirmation, open-now time logic, language toggle, and expandable category details built from a JavaScript object, not from hidden HTML for every category
- Git and GitHub for version control, with explicit `git add` for changed files only, `git status` before push, and no `.DS_Store` in the repo
- GitHub Pages for HTTPS hosting, auto-deployed on push
- AWS S3 for website hosting in us-east-2, with Terraform infrastructure as code
- GitHub Actions for CI and CD on every push to main: a check workflow, and a deploy workflow that uploads the site to S3
- IAM least privilege: day-to-day AWS work as IAM user Som, not root, and a separate deploy-only IAM user for GitHub Actions, with permission to put objects into only this one bucket
- Terraform state discipline: state is local only and gitignored, the lock file is committed, and Terraform manages infrastructure while Actions deploys content, so the two do not fight over the same files

## Project structure

- index.html - all the words and headings, categories, fresh items, pickup form, open badge, hours table, Visit Us, and language toggle, plus the JavaScript for those features
- style.css - all the look: orange banner, hero photo, card grid, form card, open badge pill, hours table, info-row side-by-side layout, category hover, and detail card. No shop words in this file, except as needed for styling.
- infra/main.tf - Terraform for AWS: S3 bucket, S3 website configuration (index and error document both index.html), public access block, public-read bucket policy (GetObject only, visitors can read, not write), S3 objects for index.html and style.css with etag file hashes so Terraform re-uploads only when a file changes, and outputs for the website endpoint and, once deployed, the CloudFront domain. The CloudFront distribution code is currently local only, not yet committed, because it has not yet deployed, see below.
- infra/.gitignore - ignores `.terraform/` and `*.tfstate`, so state and provider plugins stay local and are never committed. `.terraform.lock.hcl` is committed on purpose, so provider versions are locked.
- .github/workflows/check.yml - CI check on every push to main. It checks that index.html exists and contains "Mitho Mart".
- .github/workflows/deploy.yml - CD deploy on every push to main, and on manual trigger. It checks out the repo, configures AWS credentials from GitHub Secrets, and runs `aws s3 cp` for index.html (text/html; charset=utf-8) and style.css (text/css) to s3://mitho-mart-portfolio-sompyakurel.
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

## How CD works (deploy to S3)

On every push to main, GitHub Actions also runs the Deploy to S3 workflow, separately from the check workflow:

1. Checkout the repo
2. Configure AWS credentials from GitHub Secrets, using the deploy-only IAM user, region us-east-2. The workflow file contains only secret names, never secret values.
3. Upload index.html to S3 with content-type text/html; charset=utf-8
4. Upload style.css to S3 with content-type text/css

This was proven with a push-only test: adding Fresh Spinach to index.html and pushing, with no Terraform apply, updated S3 via Actions alone. From then on, site content changes are push-only for both Pages and S3. Terraform is only for infrastructure changes, like changing main.tf, not for editing a heading or a category item.

Why not Terraform apply in CI? Terraform state lives only on the author's Mac and is gitignored. If Actions tried to run Terraform apply, it would have no state file, so it would think the bucket does not exist and try to create a bucket with a name that is already owned. So the split is deliberate: Terraform manages infrastructure, Actions deploys content.

## How Terraform works (infrastructure)

From the infra folder, with AWS credentials for IAM user Som, not root:

1. cd infra
2. terraform init - downloads the AWS provider, creates .terraform/ and .terraform.lock.hcl, creates nothing in AWS, no cost
3. terraform plan - shows what would change, read it before applying, especially the Plan line: 1 to add, 0 to change, 0 to destroy, or similar
4. terraform apply - type yes when asked, creates or updates only what plan showed

Outputs after apply:

- website_endpoint - the S3 website domain, dot form, see Live demos above
- cloudfront_domain - only after CloudFront deploys successfully, see CloudFront status below

Drift lesson learned on this project: Terraform and Actions must agree on content-type. Actions uploads index.html with text/html; charset=utf-8, so main.tf now uses that exact content-type for the index object. If main.tf said plain text/html, Terraform would try to revert S3 back to plain on every plan, and Actions would set it back to charset on every push, in a loop. Aligning them stops that loop.

## CloudFront status

CloudFront for HTTPS in front of S3 is in progress, not live yet, as of 2026-11-02.

What is planned: a CloudFront distribution with origin = the S3 website endpoint, http-only between CloudFront and S3, viewer protocol redirect-to-https, default root object index.html, default CloudFront certificate for *.cloudfront.net, price class PriceClass_100 (US, Canada, Europe only, cheapest), and a 1-hour default cache TTL, with a cache invalidation step to be added to the deploy workflow so pushes clear the CloudFront cache instead of waiting for expiry.

What blocked it: Terraform plan was clean (1 to add, 0 to change), but apply failed with AWS 403: "Your account must be verified before you can add new CloudFront resources." This is an account verification gate, not a code error and not an IAM permission error, because IAM user Som has AdministratorAccess with no permissions boundary. A support case was opened for account verification. Until Support lifts that gate, the CloudFront distribution is not deployed, there is no CloudFront domain to test yet, and the CloudFront code in main.tf is intentionally not committed, so the repo does not claim a distribution that does not exist. When Support verifies the account, the next steps are: retry Terraform apply with Som, copy the cloudfront_domain from apply output exactly and test it in a browser over HTTPS, add a CloudFront invalidation step to deploy.yml and a CreateInvalidation permission to the deploy user, test a push-only deploy through CloudFront, then update this README with the CloudFront domain.

In the meantime, HTTPS is already available via GitHub Pages, and S3 remains HTTP only, which is normal for S3 website hosting without CloudFront.

## Security notes

- Day-to-day AWS work uses IAM user Som, not root. Root was used for Terraform early on, then switched to Som, and Terraform plan with Som showed no changes, proving Som has the permissions needed. Root is not used day-to-day.
- GitHub Actions uses a separate, least-privilege deploy user, mitho-mart-deploy, with only s3:PutObject on this one bucket. Its key is stored as GitHub Secrets AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY, never in code, never in chat, never in a repo file.
- If a key ever appears in chat or in a repo, delete it and rotate it immediately, do not just deactivate it and leave it. This happened once on this project with a Som key, it was deleted and replaced, and the new key was verified with aws sts get-caller-identity and terraform plan before continuing.
- The bucket policy allows public read (GetObject) only. Visitors can read files, they cannot put, delete, or list the bucket. The sample site contains no real customer data, no real orders, and no real payment information.

## Known limitations

- Shop hours and fresh items are hard-coded samples, a real shop would update them from a file or a sheet.
- The hero photo is an external Unsplash image, not a local file in the repo, so if that Unsplash URL breaks, the photo will break, while the rest of the site still works.
- S3 website hosting is HTTP only until CloudFront is verified and deployed, see CloudFront status above.
- CloudFront caching, once live, will mean the CloudFront URL can show an old site for up to the cache TTL unless invalidated, which is why invalidation will be added to the deploy workflow.

## What's next

- CloudFront, after AWS Support verifies the account: apply the distribution, test HTTPS, add cache invalidation to Actions, then update this README with the CloudFront domain
- Optional hardening after CloudFront works: Origin Access Control, so the bucket can go private and only CloudFront can read it, instead of public-read
- Job sprint: update resume and LinkedIn with this repo, Pages link, and S3 link, and apply to junior / associate DevOps and cloud roles, Columbus or US-remote
