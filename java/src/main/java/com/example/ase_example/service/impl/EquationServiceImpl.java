package com.example.ase_example.service.impl;

import com.example.ase_example.endpoint.dto.CorrectedEquationsDto;
import com.example.ase_example.endpoint.dto.EquationDto;
import com.example.ase_example.entity.EquationNumber;
import com.example.ase_example.exception.FatalException;
import com.example.ase_example.repository.EquationNumberRepository;
import com.example.ase_example.service.EquationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.lang.invoke.MethodHandles;
import java.util.ArrayList;
import java.util.List;

@Service
public class EquationServiceImpl implements EquationService {
    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final EquationNumberRepository repository;

    public EquationServiceImpl(EquationNumberRepository repository) {
        this.repository = repository;
    }

    @Override
    public List<EquationNumber> getAllEquationNumbers() {
        return repository.findAll();
    }

    @Override
    public CorrectedEquationsDto getCorrectedEquationsStage1(String equation) {
        LOGGER.debug("getCorrectedEquationsStage1({})", equation);

        List<String> result = new ArrayList<>();
        String[] numbers = equation.split("=");

        if (numbers.length != 2) {
            throw new FatalException("Invalid equation format");
        }

        int number1 = Integer.parseInt(numbers[0]);
        int number2 = Integer.parseInt(numbers[1]);
        if (number1 == number2) {
            result.add(number1 + "=" + number2);
            return new CorrectedEquationsDto(result);
        }

        List<EquationNumber> numbers1 = repository.findTicksByDigit(number1);
        List<Integer> number1Int = numbers1.stream().map(EquationNumber::getDigit).toList();

        if (number1Int.contains(number2)) {
            result.add(number1 + "=" + number1);
            result.add(number2 + "=" + number2);
        }
        return new CorrectedEquationsDto(result);
    }

    @Override
    public CorrectedEquationsDto getCorrectedEquationsStage2(String equation) {
        LOGGER.debug("getCorrectedEquationsStage2({})", equation);

        List<String> result = new ArrayList<>();
        CorrectedEquationsDto correctedEquations = new CorrectedEquationsDto();
        String[] equationSplit = equation.split("=");
        if (equationSplit.length != 2) {
            throw new FatalException("Invalid equation format");
        }
        String[] leftEquation = equationSplit[0].split("[+-]");
        String[] leftEquationPlus = equationSplit[0].split("\\+");
        String[] leftEquationMinus = equationSplit[0].split("-");
        if (leftEquation.length != 2) {
            throw new FatalException("Invalid equation format");
        }

        int number1 = Integer.parseInt(leftEquation[0]);
        int number2 = Integer.parseInt(leftEquation[1]);
        int numberResult = Integer.parseInt(equationSplit[1]);

        List<EquationNumber> number1Collection = repository.findTicksByDigit(number1);
        List<EquationNumber> number2Collection = repository.findTicksByDigit(number2);
        List<EquationNumber> resultCollection = repository.findTicksByDigit(numberResult);

        for (EquationNumber num : number1Collection) {
            if (leftEquationPlus.length == 2 && (num.getDigit() + number2 == numberResult)) {
                result.add(num.getDigit() + "+" + number2 + "=" + numberResult);
            }
            if (leftEquationMinus.length == 2 && (num.getDigit() - number2 == numberResult)) {
                result.add(num.getDigit() + "-" + number2 + "=" + numberResult);
            }
        }

        for (EquationNumber num : number2Collection) {
            if (leftEquationPlus.length == 2 && (number1 + num.getDigit() == numberResult)) {
                String entry = number1 + "+" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (leftEquationMinus.length == 2 && (number1 - num.getDigit() == numberResult)) {
                String entry = number1 + "-" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        for (EquationNumber num : resultCollection) {
            if (leftEquationPlus.length == 2 && (number1 + number2 == num.getDigit())) {
                String entry = number1 + "+" + number2 + "=" + num.getDigit();
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (leftEquationMinus.length == 2 && (number1 - number2 == num.getDigit())) {
                String entry = number1 + "-" + number2 + "=" + num.getDigit();
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        return new CorrectedEquationsDto(result);
    }

    @Override
    public CorrectedEquationsDto getCorrectedEquationsStage3(String equation) {
        LOGGER.debug("getCorrectedEquationsStage3({})", equation);
        CorrectedEquationsDto stage2Result = getCorrectedEquationsStage2(equation);

        List<String> result = (List<String>) stage2Result.getCorrectedEquations();
        CorrectedEquationsDto correctedEquations = new CorrectedEquationsDto();
        String[] equationSplit = equation.split("=");
        if (equationSplit.length != 2) {
            throw new FatalException("Invalid equation format");
        }
        String[] leftEquation = equationSplit[0].split("[+-]");
        String[] leftEquationPlus = equationSplit[0].split("\\+");
        String[] leftEquationMinus = equationSplit[0].split("-");
        if (leftEquation.length != 2) {
            throw new FatalException("Invalid equation format");
        }

        int number1 = Integer.parseInt(leftEquation[0]);
        int number2 = Integer.parseInt(leftEquation[1]);
        int numberResult = Integer.parseInt(equationSplit[1]);

        List<EquationNumber> number1Collection = repository.findTicksByDigit(number1);
        List<EquationNumber> number2Collection = repository.findTicksByDigit(number2);

        for (EquationNumber num : number1Collection) {
            if (leftEquationPlus.length == 2 && (number2 + num.getDigit() == numberResult)) {
                String entry = number2 + "+" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (leftEquationMinus.length == 2 && (number2 - num.getDigit() == numberResult)) {
                String entry = number2 + "-" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        for (EquationNumber num : number2Collection) {
            if (leftEquationPlus.length == 2 && (num.getDigit() + number1 == numberResult)) {
                String entry = num.getDigit() + "+" + number1 + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (leftEquationMinus.length == 2 && (num.getDigit() - number1 == numberResult)) {
                String entry = num.getDigit() + "-" + number1 + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        correctedEquations.setCorrectedEquations(result);
        return correctedEquations;
    }

    @Override
    public CorrectedEquationsDto getCorrectedEquationsStage4(String equation) {
        LOGGER.debug("getCorrectedEquationsStage4({})", equation);
        CorrectedEquationsDto stage3Result = getCorrectedEquationsStage3(equation);

        List<String> result = (List<String>) stage3Result.getCorrectedEquations();
        CorrectedEquationsDto correctedEquations = new CorrectedEquationsDto();
        String[] equationSplit = equation.split("=");
        if (equationSplit.length != 2) {
            throw new FatalException("Invalid equation format");
        }
        String[] leftEquation = equationSplit[0].split("[+-]");
        if (leftEquation.length != 2) {
            throw new FatalException("Invalid equation format");
        }

        int number1 = Integer.parseInt(leftEquation[0]);
        int number2 = Integer.parseInt(leftEquation[1]);
        int numberResult = Integer.parseInt(equationSplit[1]);

        List<EquationNumber> number1Collection = repository.findTicksByDigit(number1);
        List<EquationNumber> number2Collection = repository.findTicksByDigit(number2);

        for (EquationNumber num : number1Collection) {
            if (number2 + num.getDigit() == numberResult) {
                String entry = number2 + "+" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (number2 - num.getDigit() == numberResult) {
                String entry = number2 + "-" + num.getDigit() + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        for (EquationNumber num : number2Collection) {
            if (num.getDigit() + number1 == numberResult) {
                String entry = num.getDigit() + "+" + number1 + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
            if (num.getDigit() - number1 == numberResult) {
                String entry = num.getDigit() + "-" + number1 + "=" + numberResult;
                if (!result.contains(entry)) {
                    result.add(entry);
                }
            }
        }

        correctedEquations.setCorrectedEquations(result);
        return correctedEquations;
    }
}
