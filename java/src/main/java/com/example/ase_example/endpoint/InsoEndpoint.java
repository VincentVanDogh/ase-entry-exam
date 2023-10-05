package com.example.ase_example.endpoint;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.lang.invoke.MethodHandles;

@RestController
@RequestMapping(value = InsoEndpoint.BASE_PATH)
public class InsoEndpoint {
    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    static final String BASE_PATH = "/inso";

    @GetMapping
    public String finished() {
        return "next";
    }
}
