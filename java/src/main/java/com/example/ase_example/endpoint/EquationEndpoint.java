package com.example.ase_example.endpoint;

import com.example.ase_example.endpoint.dto.CorrectedEquationsDto;
import com.example.ase_example.endpoint.dto.EquationDto;
import com.example.ase_example.entity.EquationNumber;
import com.example.ase_example.service.EquationService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.*;

import java.lang.invoke.MethodHandles;
import java.util.List;

@RestController
@RequestMapping(value = EquationEndpoint.BASE_PATH)
public class EquationEndpoint {
    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    static final String BASE_PATH = "/equation";
    private final EquationService service;

    public EquationEndpoint(EquationService service) {
        this.service = service;
    }

    @GetMapping("all_numbers")
    public List<EquationNumber> allEquationNumbers() {
        return service.getAllEquationNumbers();
    }

    @PostMapping("/stage1")
    public CorrectedEquationsDto stage1(@RequestBody EquationDto equation) {
        LOGGER.info("POST " + BASE_PATH + "/stage1");
        LOGGER.debug("stage1({})", equation);
        return service.getCorrectedEquationsStage1(equation.getEquation());
    }

    @PostMapping("/stage2")
    public CorrectedEquationsDto stage2(@RequestBody EquationDto equation) {
        LOGGER.info("POST " + BASE_PATH + "/stage2");
        LOGGER.debug("stage2({})", equation);
        return service.getCorrectedEquationsStage2(equation.getEquation());
    }

    @PostMapping("/stage3")
    public CorrectedEquationsDto stage3(@RequestBody EquationDto equation) {
        LOGGER.info("POST " + BASE_PATH + "/stage3");
        LOGGER.debug("stage3({})", equation);
        return service.getCorrectedEquationsStage3(equation.getEquation());
    }

    @PostMapping("/stage4")
    public CorrectedEquationsDto stage4(@RequestBody EquationDto equation) {
        LOGGER.info("POST " + BASE_PATH + "/stage4");
        LOGGER.debug("stage4({})", equation);
        return service.getCorrectedEquationsStage4(equation.getEquation());
    }

}
