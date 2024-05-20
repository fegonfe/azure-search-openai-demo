 #!/bin/sh

echo 'Creating Python virtual environment ".venv"...'
python -m venv .venv

echo 'Installing dependencies from "requirements.txt" into virtual environment (in quiet mode)...'
source ./.venv/Scripts/activate
python -m pip --quiet --disable-pip-version-check install -r app/backend/requirements.txt
