from typing import Annotated

from fastapi import Depends, FastAPI
from pydantic import BaseModel

from entities.entities import StageTwoAnswer
from entities.stage2_testcases import test1

app = FastAPI()


fake_items_db = [{"item_name": "Foo"}, {"item_name": "Bar"}, {"item_name": "Baz"}]


class Item(BaseModel):
    name: str
    description: str | None = None
    price: float
    tax: float | None = None


class CommonQueryParams:
    def __init__(self, q: str | None = None, skip: int = 0, limit: int = 100):
        self.q = q
        self.skip = skip
        self.limit = limit


@app.get("/items/")
async def read_items(commons: Annotated[CommonQueryParams, Depends(CommonQueryParams)]):
    response = {}
    if commons.q:
        response.update({"q": commons.q})
    items = fake_items_db[commons.skip : commons.skip + commons.limit]
    response.update({"items": items})
    return response


@app.post("/items/")
async def create_item(item: Item):
    return item


@app.get("/stage2/{token}")
async def get_stage_two(token: str):
    if token == "0":
        return test1


@app.post("/stage2/{token}")
async def stage_two(token: str, answer: StageTwoAnswer):
    print(token)
    print(answer)
    return answer
