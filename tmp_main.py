from fastapi import FastAPI, status
from pydantic import BaseModel
from requests import Response
from compare_array_dicts import contains_all_key_values


class Stage2PostItem(BaseModel):
    def __init__(self, accessible_points: [{str: int}] = None):
        self.accessible_points = accessible_points


class CommonQueryParams:
    def __init__(self, q: str | None = None, skip: int = 0, limit: int = 100):
        self.q = q
        self.skip = skip
        self.limit = limit


class Tmp:
    def __init__(self, tmp: int = 0):
        self.tmp = tmp


app = FastAPI()


ITEM_0: {} = {
    "obstacle": {
    "pointB": {"x": -3, "y": -5},
    "pointA": {"x": 4, "y": -6}
    },
    "targets": [
        {"x": -1, "y": -4},
        {"x": -5, "y": -9},
        {"x": 6, "y": -6},
        {"x": 6, "y": 8}
    ]
}


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/hello/{name}")
async def say_hello(name: str):
    return {"message": f"Hello {name}"}


#https://reset.inso.tuwien.ac.at/ase/<scenarioPrefix>/assignment/<yourMatrikelnr>/stage/2/testcase/<testcase>?token=<token>
@app.get("/ase/hyperloop/assignment/11730105/stage/2/testcase/test?token={token}")
async def get_token(token: int):
    if token == 0:
        return ITEM_0


@app.post("/ase/hyperloop/assignment/11730105/stage/2/testcase/test?token={token}")
async def post_token(token: int, item: Stage2PostItem, response: Response):
    if token == 0:
        if contains_all_key_values(ITEM_0.get("targets"), item.accessiblePoints):
            return "Correct"
        else:
            response.status_code = status.HTTP_417_EXPECTATION_FAILED
            return "False"
