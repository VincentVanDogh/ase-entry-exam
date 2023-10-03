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
