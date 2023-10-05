from typing import List

from pydantic import BaseModel


class Coordinates(BaseModel):
    x: int
    y: int

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y


class StageTwoAnswer(BaseModel):
    accessiblePoints: List[Coordinates]


class Obstacle(BaseModel):
    pointA: Coordinates
    pointB: Coordinates


class StageTwoTestCase(BaseModel):
    obstacle: Obstacle
    targets: List[Coordinates]
