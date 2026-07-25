from fastapi import FastAPI

app = FastAPI()


@app.get("/")
def home():
	return {"message": "Genesis backend is alive!"}


@app.get("/health")
def health():
	return {"status": "ok", "project": "genesis"}


# run:  uvicorn main:app --reload   -> interactive docs at http://127.0.0.1:8000/docs
