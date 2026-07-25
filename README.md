# Genesis Backend

## Backend
- Framework: FastAPI
- `GET /`: Returns a simple liveness message: `{"message": "Genesis backend is alive!"}`.
- `GET /health`: Returns health metadata for the service: `{"status": "ok", "project": "genesis"}`.

## Running
Install dependencies:
```bash
pip install -r requirements.txt
```

Start the development server:
```bash
uvicorn main:app --reload
```

Interactive API docs:
- http://127.0.0.1:8000/docs
