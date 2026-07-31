# Genesis Backend

## Backend
- Framework: FastAPI
- `GET /`: Returns a simple liveness message: `{"message": "Genesis backend is alive!"}`.
- `GET /health`: Returns health metadata for the service: `{"status": "ok", "project": "genesis"}`.

## Data Layer
- Database: PostgreSQL
- ORM: SQLAlchemy
- Model: `Item` table with `id`, `name`, and `note` fields.
- `POST /items`: writes a new item to the database from JSON payload.
- `GET /items`: reads every stored item back as JSON.
- `GET /items/{item_id}`: reads a single item by its id.

## Running
Install dependencies:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Start PostgreSQL locally:
```bash
sudo systemctl enable --now postgresql
```

Create the database and user (one-time setup):
```bash
sudo -u postgres psql -c "CREATE USER genesis WITH PASSWORD 'secret';"
sudo -u postgres psql -c "CREATE DATABASE genesis OWNER genesis;"
```

Set the database URL from the environment:
```bash
export DATABASE_URL="postgresql://genesis:secret@localhost:5432/genesis"
```

Start the development server:
```bash
uvicorn main:app --reload
```

Interactive API docs:
- http://127.0.0.1:8000/docs
