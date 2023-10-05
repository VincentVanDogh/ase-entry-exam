package com.example.ase_example.datagenerator;

import com.example.ase_example.endpoint.dto.CorrectedEquationsDto;
import com.example.ase_example.entity.EquationNumber;
import com.example.ase_example.exception.FatalException;
import com.example.ase_example.repository.EquationNumberRepository;
import com.example.ase_example.service.EquationService;
import jakarta.annotation.PostConstruct;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.*;
import java.lang.invoke.MethodHandles;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Collection;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class EquationGenerator {
    private static final Logger LOGGER = LoggerFactory.getLogger(MethodHandles.lookup().lookupClass());
    private final String GET_TOKEN = " https://reset.inso.tuwien.ac.at/ase/<scenarioPrefix>/assignment/11730105/token";
    private final String GET_TEST_CASE = "https://reset.inso.tuwien.ac.at/ase/<scenarioPrefix>/assignment/11730105/stage/1/testcase/<testcase>?token=<token>";
    private final String POST_SOLUTION = "https://reset.inso.tuwien.ac.at/ase/<scenarioPrefix>/assignment/11730105/stage/1/testcase/<testcase>?token=<token>";
    private final String GET_NEXT = "https://reset.inso.tuwien.ac.at/ase/<scenarioPrefix>/assignment/11730105/finish?token=<token>";

    private final String tokenPattern = "\\{\\s*\"token\"\\s*:\\s*\"(.*)\"\\}";
    private final String equationPattern = "\\{\\s*\"equation\"\\s*:\\s*\"(.*)\"\\}";
    private final String MESSAGE = "\"message\"\\s*:\\s*\"(.*)\"";
    private final String LINK_TO_NEXT_TASK = "\"linkToNextTask\"\\s*:\\s*\"(.*)\"";
    private final String EXTRACT_STAGE = "stage/(\\d+)/";

    private final String GET_DEMO_TOKEN = "https://reset.inso.tuwien.ac.at/ase/demo-0ef893ce14/assignment/11730105/token";
    private final String GET_DEMO_TEST_CASE = "https://reset.inso.tuwien.ac.at/ase/demo-0ef893ce14/assignment/11730105/stage/1/testcase/1?token=";
    private final String GET_DEMO_NEXT = "https://reset.inso.tuwien.ac.at/ase/demo-0ef893ce14/assignment/11730105/finish?token=<token>";

    @Autowired
    private EquationNumberRepository repository;

    @Autowired
    private EquationService service;

    @PostConstruct
    public void initializeData() throws IOException {
        fillNumbersWithTicks();

        // 1. Get token
        String tokenMessage = getRequest(GET_DEMO_TOKEN);
        String token = findRegexGroup(tokenMessage, tokenPattern);

        String request = GET_DEMO_TEST_CASE + token;
        int counter = 0;

        boolean stage1 = false;
        boolean stage2 = false;
        boolean stage3 = false;
        boolean stage4 = false;

        while (!getRequest(GET_DEMO_NEXT).contains("next") && counter < 1000) {
            if (findRegexGroup(request, EXTRACT_STAGE).equals("1") && !stage1) {
                System.out.println("\nStage 1:");
                stage1 = true;
            }
            if (findRegexGroup(request, EXTRACT_STAGE).equals("2") && !stage2) {
                System.out.println("\nStage 2:");
                stage2 = true;
            }
            if (findRegexGroup(request, EXTRACT_STAGE).equals("3") && !stage3) {
                System.out.println("\nStage 3:");
                stage3 = true;
            }
            if (findRegexGroup(request, EXTRACT_STAGE).equals("4") && !stage4) {
                System.out.println("\nStage 4:");
                stage4 = true;
            }

            // GET the equation
            String equation = getRequest(request);
            String equationExtracted = findRegexGroup(equation, "\"equation\"\\s*:\\s*\"(.*)\"");

            System.out.println("equation: " + equationExtracted);

            // Calculate and POST the result
            String stage = findRegexGroup(request, "stage/(\\d+)/");
            CorrectedEquationsDto solution = null;
            switch (stage) {
                case "1" -> solution = service.getCorrectedEquationsStage1(equationExtracted);
                case "2" -> solution = service.getCorrectedEquationsStage2(equationExtracted);
                case "3" -> solution = service.getCorrectedEquationsStage3(equationExtracted);
                case "4" -> solution = service.getCorrectedEquationsStage4(equationExtracted);
            }
            if (solution == null) {
                throw new FatalException("Somehow landed in a non-existing stage");
            }
            String solutions = collectionToString(solution.getCorrectedEquations());
            String body = "{\n" + "\"correctedEquations\": " + solutions + "\n}";

            System.out.println("correctedEquations: " + solutions);

            String response = postRequest(request, body);

            String message = findRegexGroup(response, MESSAGE);
            if (message.toLowerCase().equals("accepted")) {
                request = findRegexGroup(response, LINK_TO_NEXT_TASK);
            }
            counter++;
        }
        if (counter < 300) {
            System.out.println("SUCCESSFUL");
        } else {
            System.out.println("UNSUCCESSFUL");
        }
    }

    public void fillNumbersWithTicks() {
        if (!repository.findAll().isEmpty()) {
            LOGGER.info("Numbers with corresponding ticks already generated");
        } else {
            LOGGER.info("Generating numbers with corresponding ticks");
            repository.save(new EquationNumber(0, 6));
            repository.save(new EquationNumber(1, 2));
            repository.save(new EquationNumber(2, 5));
            repository.save(new EquationNumber(3, 5));
            repository.save(new EquationNumber(4, 4));
            repository.save(new EquationNumber(5, 5));
            repository.save(new EquationNumber(6, 6));
            repository.save(new EquationNumber(7, 3));
            repository.save(new EquationNumber(8, 7));
            repository.save(new EquationNumber(9, 6));
        }
    }

    private String getRequest(String apiLink) throws IOException {
        // LOGGER.info("Sending GET-request");

        URL obj = new URL(apiLink);
        HttpURLConnection con = (HttpURLConnection) obj.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("User-Agent", "Mozilla/5.0");
        int responseCode = con.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) { // success
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer response = new StringBuffer();

            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // print result
            return response.toString();
        } else {
            System.out.println("GET request did not work.");
        }

        return "";
    }

    private String postRequest(String apiLink, String body) throws IOException {
        // LOGGER.info("Sending POST-request");

        URL url = new URL(apiLink);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setDoOutput(true);
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setRequestProperty("User-Agent", "Mozilla/5.0");

        try (DataOutputStream dos = new DataOutputStream(conn.getOutputStream())) {
            dos.writeBytes(body);
        }

        String result = "";
        try (BufferedReader bf = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            String line;
            while ((line = bf.readLine()) != null) {
                result += (line + "\n");
            }
        }
        return result;
    }

    private String findRegexGroup(String line, String pattern) {
        // Create a Pattern object
        Pattern r = Pattern.compile(pattern);

        // Now create matcher object.
        Matcher m = r.matcher(line);

        if (m.find()) {
            return m.group(1);
        }
        return "";
    }

    private String collectionToString(Collection<String> collection) {
        if (collection.isEmpty()) {
            return "[]";
        }
        String result = "[";
        for (String entry : collection) {
            result += ("\"" + entry + "\", ");
        }
        return result.substring(0, result.length() - 2) + "]";
    }
}
