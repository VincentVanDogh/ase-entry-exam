package com.example.ase_example.service;

import com.example.ase_example.endpoint.dto.CorrectedEquationsDto;
import com.example.ase_example.endpoint.dto.EquationDto;
import com.example.ase_example.entity.EquationNumber;

import java.util.List;

public interface EquationService {
    /**
     * Retrieves all equation numbers stored in the persistent data store.
     *
     * @return a list of equation numbers
     */
    List<EquationNumber> getAllEquationNumbers();

    /**
     * Retrieves a collection of corrected equations in stage 1.
     *
     * @param equation Equation provided by the frontend
     *
     * @return a corrected equation
     */
    CorrectedEquationsDto getCorrectedEquationsStage1(String equation);

    /**
     * Retrieves a collection of corrected equations in stage 2.
     *
     * @param equation Equation provided by the frontend
     *
     * @return a corrected equation
     */
    CorrectedEquationsDto getCorrectedEquationsStage2(String equation);

    /**
     * Retrieves a collection of corrected equations in stage 3.
     *
     * @param equation Equation provided by the frontend
     *
     * @return a corrected equation
     */
    CorrectedEquationsDto getCorrectedEquationsStage3(String equation);

    /**
     * Retrieves a collection of corrected equations in stage 4.
     *
     * @param equation Equation provided by the frontend
     *
     * @return a corrected equation
     */
    CorrectedEquationsDto getCorrectedEquationsStage4(String equation);
}
