from typing import List

import requests
import numpy

from entities.entities import StageTwoTestCase, Coordinates

port: str = 'http://127.0.0.1:8000'
stage2: str = f'{port}/stage2'

testcase = requests.get(url=f'{stage2}/0')


def iterate_testcases(url: str, token: str):
    post_status = 200
    token = 0
    while post_status == 200 and int(token) < 2:
        resp = requests.get(url=f'{stage2}/{token}').json()
        result = arctan_coordinates(resp["targets"], resp["obstacle"]["pointA"], resp["obstacle"]["pointB"])
        post = requests.post(url=f'{stage2}/{token}', json={
            "accessiblePoints": result
        })
        post_status = post.status_code
        print(f"Token: {token}, Status: {post_status}")
        token = token + 1
    print("Success")


def calc_testcase(testcase: StageTwoTestCase) -> List[Coordinates]:
    result: List[Coordinates] = []
    targets = testcase.targets

    point_a = testcase.obstacle.pointA
    point_b = testcase.obstacle.pointB
    min_point = point_a if point_a < point_b else point_b
    max_point = point_a if point_a > point_b else point_b

    for target in targets:
        arctan = numpy.arctan2(target.x, target.y)
        if min_point <= arctan <= max_point:
            result.append(target)

    return result


def arctan_coordinates(targets: List[Coordinates], point_a, point_b) -> List[Coordinates]:
    result: List[Coordinates] = []
    arctan_x = numpy.arctan2(point_a["x"], point_b["x"])
    arctan_y = numpy.arctan2(point_a["y"], point_b["y"])
    min_point = arctan_x if arctan_x < arctan_y else arctan_y
    max_point = arctan_x if arctan_x > arctan_y else arctan_y

    for target in targets:
        arctan = numpy.arctan2(target["x"], target["y"])
        if min_point <= arctan <= max_point:
            result.append(target)

    return result


iterate_testcases(f"{port}{stage2}", "0")
