Using Docker for reproducible Render builds
=========================================

This project now includes a `Dockerfile` that forces Python 3.10 and installs
the system libraries required to build / install scientific Python packages
(numpy, scikit-learn, etc.). Use this if Render's managed Python runtime does
not pick up `runtime.txt` or if you want reproducible builds.

How it works
------------
- The Dockerfile uses `python:3.10-slim` as the base.
- It installs system build dependencies (build-essential, gfortran,
  libopenblas-dev, liblapack-dev) so pip can build packages if wheels are not
  available.
- It upgrades pip and installs `requirements.txt` inside the image.

Deploying on Render using Docker
-------------------------------
1. In the Render dashboard, go to your service settings and switch the service
   to "Docker" / "Container" (the exact UI labels may vary).
2. Choose the Dockerfile from the repository root (Render will auto-detect it
   if present).
3. Trigger a manual deploy (Manual Deploy → Deploy Latest Commit).
4. Watch the build logs in Render — they will show Docker image build steps and
   pip installing the dependencies.

Local testing
-------------
You can build and run the container locally (requires Docker installed):

```powershell
# from project root
docker build -t hcids:latest .
docker run --rm -p 8000:8000 hcids:latest
# then open http://localhost:8000 in your browser
```

Notes
-----
- Using Docker gives you full control of the Python version and system libs,
  avoiding build-time surprises on Render.
- The Dockerfile is intentionally minimal; you can extend it for multi-stage
  builds, static assets, or other production tweaks.
