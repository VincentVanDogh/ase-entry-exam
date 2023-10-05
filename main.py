from fastapi import FastAPI

from compare_array_dicts import contains_all_coordinates
from entities.entities import StageTwoAnswer
from entities.stage2_testcases import test1

app = FastAPI()


@app.get("/stage2/{token}")
async def get_stage_two(token: str):
    if token == "0":
        return test1


@app.post("/stage2/{token}")
async def stage_two(token: str, answer: StageTwoAnswer):
    if token == "0":
        return contains_all_coordinates(test1.targets, answer.accessiblePoints)
    if token == "1":
        return True
    return "Unknown token"
