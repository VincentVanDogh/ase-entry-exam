from entities.entities import StageTwoTestCase, Coordinates, Obstacle

# Coordinates

coordinates1: Coordinates = Coordinates(x=-3, y=-5)
coordinates2: Coordinates = Coordinates(x=4, y=-6)

coordinates3: Coordinates = Coordinates(x=-1, y=-4)
coordinates4: Coordinates = Coordinates(x=-5, y=-9)
coordinates5: Coordinates = Coordinates(x=-6, y=-6)
coordinates6: Coordinates = Coordinates(x=-6, y=8)

# Obstacle
obstacle1: Obstacle = Obstacle(pointA=coordinates1, pointB=coordinates2)

# Test Case
test1: StageTwoTestCase = StageTwoTestCase(obstacle=obstacle1, targets=[coordinates3, coordinates4, coordinates5, coordinates6])

# t = StageTwoTestCase(obstacle={'pointA': Obstacle()})