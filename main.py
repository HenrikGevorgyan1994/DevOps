from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import uvicorn

from db import Item, SessionLocal

app = FastAPI()



class ItemCreate(BaseModel):
    name: str
    note: str | None = None


@app.get("/")
def home():
    return {"message": "Genesis backend is alive!"}


@app.get("/health")
def health():
    return {"status": "ok", "project": "genesis"}


@app.post("/items", status_code=201)
def create_item(payload: ItemCreate):
    db = SessionLocal()
    try:
        item = Item(name=payload.name, note=payload.note)
        db.add(item)
        db.commit()
        db.refresh(item)
        return {"id": item.id, "name": item.name, "note": item.note, "status": "saved"}
    finally:
        db.close()


@app.get("/items")
def list_items():
    db = SessionLocal()
    try:
        items = db.query(Item).all()
        return [{"id": item.id, "name": item.name, "note": item.note} for item in items]
    finally:
        db.close()


@app.get("/items/{item_id}")
def get_item(item_id: int):
    db = SessionLocal()
    try:
        item = db.query(Item).filter(Item.id == item_id).first()
        if item is None:
            raise HTTPException(status_code=404, detail="Item not found")
        return {"id": item.id, "name": item.name, "note": item.note}
    finally:
        db.close()


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)

# run:  uvicorn main:app --reload   -> interactive docs at http://127.0.0.1:8000/docs
