package com.example.ase_example.endpoint.dto;

import java.util.ArrayList;
import java.util.Collection;

public class CorrectedEquationsDto {
    private Collection<String> correctedEquations;

    public CorrectedEquationsDto() {
    }

    public CorrectedEquationsDto(Collection<String> correctedEquations) {
        this.correctedEquations = correctedEquations;
    }

    public Collection<String> getCorrectedEquations() {
        return correctedEquations;
    }

    public void setCorrectedEquations(Collection<String> correctedEquations) {
        this.correctedEquations = correctedEquations;
    }

    public void addCorrectedEquation(String equation) {
        if (correctedEquations != null) {
            correctedEquations.add(equation);
        } else {
            correctedEquations = new ArrayList<>();
            correctedEquations.add(equation);
        }
    }
}
