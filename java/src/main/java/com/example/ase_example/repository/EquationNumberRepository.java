package com.example.ase_example.repository;

import com.example.ase_example.entity.EquationNumber;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface EquationNumberRepository extends JpaRepository<EquationNumber, Integer> {
    /**
     * Retrieves all numbers with an equal amount of ticks.
     *
     * @param digit digit with the corresponding tick amount
     *
     * @return a list of equation number entities
     */
    @Query("""
    SELECT n
    FROM EquationNumber n
    WHERE n.ticks = (SELECT n.ticks FROM EquationNumber n WHERE n.digit = ?1)
    """)
    List<EquationNumber> findTicksByDigit(int digit);

    /**
     * Retrieves all numbers with a maximum difference of one tick for a digit.
     *
     * @param digit digit with the corresponding tick amount
     *
     * @return a list of number entities
     */
    @Query("""
    SELECT  n
    FROM EquationNumber n
    WHERE n.ticks - 1 = (SELECT n.ticks FROM EquationNumber n WHERE n.digit = ?1) OR
          n.ticks = (SELECT n.ticks FROM EquationNumber n WHERE n.digit = ?1) OR
          n.ticks + 1 = (SELECT n.ticks FROM EquationNumber n WHERE n.digit = ?1)
    """)
    List<EquationNumber> findTickSegmentsByDigit(int digit);
}
