#!/bin/sh

echo ""
echo "Loading start.env file"
echo ""

while IFS='=' read -r key value; do
    value=$(echo "$value" | sed 's/^"//' | sed 's/"$//')
    export "$key=$value"
done <<EOF
$(cat start.env)
EOF

if [ $? -ne 0 ]; then
    echo "Failed to load environment variables"
    exit $?
fi

cd ../
echo 'Creating python virtual environment ".venv"'
pip3 install virtualenv
python -m virtualenv .venv

echo ""
echo "Restoring backend python packages"
echo ""

source ./.venv/Scripts/activate
python -m pip install -r app/backend/requirements.txt
if [ $? -ne 0 ]; then
    echo "Failed to restore backend python packages"
    exit $?
fi

echo ""
echo "Restoring frontend npm packages"
echo ""

cd app/frontend
npm install
if [ $? -ne 0 ]; then
    echo "Failed to restore frontend npm packages"
    exit $?
fi

echo ""
echo "Building frontend"
echo ""

npm run build
if [ $? -ne 0 ]; then
    echo "Failed to build frontend"
    exit $?
fi

echo ""
echo "Starting backend"
echo ""

cd ../backend

port=50505
host=localhost
python -m quart --app main:app run --port "$port" --host "$host" --reload
if [ $? -ne 0 ]; then
    echo "Failed to start backend"
    exit $?
fi
