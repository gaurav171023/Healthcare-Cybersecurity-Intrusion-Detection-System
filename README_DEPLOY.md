Render deployment notes
======================

This file explains how to ensure Render uses Python 3.10 (so prebuilt wheels for
numpy / scikit-learn are used) and how to redeploy.

1) runtime.txt
----------------
The repository contains `runtime.txt` with:

    python-3.10.12

This tells Render to use Python 3.10.12 when the service build recognizes the
file. Make sure the file is in the repository root (it is) and included in the
commit that you deploy from.

2) Confirm runtime on Render
----------------------------
- Open your Render service in the Render dashboard.
- Under the service settings / environment or runtime section, ensure the
  service is configured to use the repository's `runtime.txt` or explicitly set
  the Python version to 3.10.
- If Render's dashboard has an option to "Use runtime.txt from repo", enable it.

3) Redeploy and check logs
--------------------------
- Trigger a manual deploy (Deploy Latest Commit).
- Watch the build logs. Look for lines indicating prebuilt wheels were downloaded,
  e.g. `Downloading scikit_learn-...-cp310-...whl` or `Successfully installed
  scikit-learn-...`.
- If you instead see Cython compile steps and compile errors, Render is using a
  Python version for which wheels are not available and pip attempted to build
  scikit-learn from source.

4) If Render still uses Python 3.13 (or you cannot change it)
-----------------------------------------------------------
- Option A (recommended): Use a Dockerfile that starts from a Python 3.10 base
  image and installs system deps (build-essential, gfortran, libopenblas-dev,
  liblapack-dev) before pip installing requirements. This guarantees reproducible
  builds.
- Option B: Pin to package versions that have wheels for the Python version in
  use (if such wheels exist). This can be fragile.

5) Quick verification checklist
-------------------------------
- `runtime.txt` present in repo root — yes
- `requirements.txt` pinned to supported versions for Python 3.10 — check
- After deploy, build logs show wheel installs for `numpy` and `scikit-learn`

If you'd like, I can add a Dockerfile that uses `python:3.10-slim` and installs
the system packages needed to build scientific Python packages, then installs
`requirements.txt`. Request that and I'll add it and push the change.

---
File added automatically to help with Render deployment; keep or edit as you
prefer.
