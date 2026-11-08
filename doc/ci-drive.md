# Google Drive images and GitHub Actions

Git stores `fig.dvc`, which records a directory hash, file count and total size.
DVC's directory object records the individual image hashes. Google Drive stores
these content-addressed objects. A clean runner checks out a commit and its
pinned engine submodule, downloads the images described by that commit, then
compiles and validates the PDF. The workflow uploads the PDF as a run artifact.

## One-time CI setup

The existing Google Cloud project is `amazing-sunset-508122-m9` (project number
`1031664104364`). Two downloaded OAuth client files were located locally;
one matches both the client ID and secret in the developer DVC configuration.
They are **OAuth client credentials**,
not a service-account private key, and do not replace the CI identity below.

To inspect the project from this workstation, first sign in to gcloud:

```bash
gcloud auth login
gcloud projects describe amazing-sunset-508122-m9 \
  --format='yaml(projectId,projectNumber,name,lifecycleState)'
gcloud services list --enabled --project=amazing-sunset-508122-m9 \
  --filter='config.name:drive.googleapis.com'
gcloud iam service-accounts list --project=amazing-sunset-508122-m9
```

Initial inspection found gcloud unauthenticated. The owner subsequently logged
in and verified that Drive API is enabled and no service accounts existed.
The implementation created `cuo-guide-ci@amazing-sunset-508122-m9.iam.gserviceaccount.com`
and configured the GitHub secret. The owner shared the folder as Editor.
An upload test then failed with HTTP 403 because service accounts have no My Drive
storage quota. Upload using the owner's identity; CI only needs Viewer access.
Google can list
existing service-account key metadata, but cannot download an existing private
key again. Locate its original file or create a new key after choosing the
appropriate service account.

1. In a Google Cloud project, enable the Google Drive API and create a dedicated
   service account for this guide. Project-level administrator roles are not
   required for reading a shared Drive folder.
2. Create a JSON key for that account and keep it outside the repository.
3. Share the existing DVC folder with its `client_email` as **Viewer**:
   <https://drive.google.com/drive/folders/1x1Ik5nHlqWlCeNtfMWO5uzYWFaq3On0H>.
   Ensure the DVC objects inherit access. CI only downloads; your local user
   remains responsible for uploading images.
4. Set the repository Actions secret from the key file without pasting the key
   into chat or committing it:

   ```bash
   gh secret set GDRIVE_CREDENTIALS_DATA \
     --repo lufreitas0000/cg-serra-do-cuo < /absolute/path/to/service-account.json
   ```

5. After the updated image objects have been uploaded and the workflow is on
   GitHub, run **Build guide PDF** from Actions. A successful run must restore
   images on its empty runner, compile the PDF and pass placeholder validation.

The service-account option is set only in the runner's `.dvc/config.local`.
Its JSON is supplied through `GDRIVE_CREDENTIALS_DATA` only to the download step.
Developer machines retain their existing OAuth configuration. Fork pull requests
are skipped because they cannot access the repository secret; no
`pull_request_target` workflow is used.

See the [DVC Google Drive documentation](https://dvc.org/doc/user-guide/data-management/remote-storage/google-drive)
for service-account setup and supported credential formats.

## Test the CI identity locally

Use an empty temporary clone and cache so cached local images cannot mask an
authentication or remote-data failure. Run this after the candidate commit has
been pushed; use its branch in the clone command if it is not on main yet.

```bash
git clone --recurse-submodules https://github.com/lufreitas0000/cg-serra-do-cuo.git /tmp/cuo-drive-test
cd /tmp/cuo-drive-test
dvc remote modify --local gdrive gdrive_use_service_account true
dvc remote modify --local gdrive gdrive_service_account_json_file_path /absolute/path/to/service-account.json
dvc pull fig.dvc --remote gdrive
make build
make validate
```

No `dvc push`, remote garbage collection, or Drive write access is needed for this
test. A successful check using a developer's OAuth token would not by itself
establish that the CI identity works.

## Updating images

```bash
# Edit or add files in fig/, then record and upload the new image objects:
dvc add fig
dvc push fig.dvc --remote gdrive
make build
make validate
git add fig.dvc
git commit -m "Update guide images"
```

Upload with DVC before pushing the Git commit so CI can fetch the new objects.
Keep the Drive objects needed by older editions; avoid remote garbage collection
unless its effect on historical builds has been reviewed.

## Investigation checkpoint — 2026-11-08

- The initial manifest contained 32 files, 28,135,831 bytes. It already omitted
  the two overview maps and `b_machado.jpg`; the maps were not deleted by this
  investigation. All three originals were found in the sibling repository at
  `../climbing-guide/production/images/` and copied without modification.
- Local `dvc status --json` initially returned `{}`: the old local images matched
  their manifest. That check says nothing about the remote's completeness.
- A real `dvc status -c --json` request failed with `invalid_grant`. Renew the
  local user's OAuth authorization before uploading the restored images. The
  local client ID and client secret alone are not a valid cached user login.
- No Actions repository secrets were configured at inspection time. No remote
  restore or hosted PDF build has passed yet.
- The existing PDF contained missing-image placeholders even for files present
  in `fig/`. Adding `fig/` to `TEXINPUTS` fixes the engine's file-existence lookup;
  `make validate` now rejects placeholder text in the actual PDF.
- The updated manifest records 35 files, 31,251,333 bytes. A local three-pass
  build and full validation passed in the workspace namespace sandbox. A
  negative test temporarily removed one map and confirmed rejection, then
  restored it. This is local evidence, not a successful Drive download.
- Talhado's existing cover references `example-image-a.jpg`, a sample bundled
  with TeX's `mwe` package. The check verifies its availability and prints an
  editorial warning; replacing that illustration requires a suitable photograph.

Never commit OAuth tokens or service-account keys. The ignored local DVC config
and your cached user credentials are not part of the GitHub setup.

## Subsequent live test

After service-account creation and folder sharing, a clone with an empty DVC
cache successfully downloaded the published 32-file manifest: exactly 28,135,831
bytes. The GitHub credential secret is configured. This establishes that the CI
identity can read the existing data. The restored three images and updated
35-file manifest still require an owner-authenticated upload before the new
candidate can pass a hosted build. The service-account upload failed with the
My Drive storage-quota restriction described above.
