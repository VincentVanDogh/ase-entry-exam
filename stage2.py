from typing import List

import requests
import numpy

from entities.entities import StageTwoTestCase, Coordinates

port: str = 'http://127.0.0.1:8000'
stage2: str = f'{port}/stage2'

testcase = requests.get(url=f'{stage2}/0')


def iterate_testcases(url: str, token: str):
    requests.get(url=f'{stage2}/{token}')


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
