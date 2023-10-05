from entities.entities import Coordinates


def contains_all_key_values(arr_dict_solution: [{}], arr_dict_submission: [{}]) -> bool:
    """
    Compares whether two arrays contain the same dictionaries
    :param arr_dict_solution: expected array and the dictionaries contained within
    :param arr_dict_submission: submitted array containing dictionaries by the user
    :return:
    """
    if len(arr_dict_solution) != len(arr_dict_submission):
        return False
    for solution in arr_dict_solution:
        count = 0
        for submission in arr_dict_submission:
            if solution == submission:
                arr_dict_submission.pop(count)
                break
            count = count + 1
    return True if len(arr_dict_submission) == 0 else False


def contains_all_coordinates(coordinates_solution: [Coordinates], coordinates_submission: [Coordinates]) -> bool:
    """
    Compares whether two arrays contain the same Coordinates
    :param coordinates_solution: expected array and the Coordinates contained within
    :param coordinates_submission: submitted array containing Coordinates by the user
    :return: True if both arrays contain the same Coordinates
    """
    if len(coordinates_solution) != len(coordinates_submission):
        return False
    for solution in coordinates_solution:
        count = 0
        for submission in coordinates_submission:
            if solution == submission:
                coordinates_submission.pop(count)
                break
            count = count + 1
    return True if len(coordinates_submission) == 0 else False
