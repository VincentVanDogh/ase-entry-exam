package com.example.ase_example.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;

@Entity
public class EquationNumber {
    @Id
    @Column(nullable = false)
    private Integer digit;

    @Column
    private Integer ticks;

    public EquationNumber() {
    }

    public EquationNumber(Integer digit, Integer ticks) {
        this.digit = digit;
        this.ticks = ticks;
    }

    public Integer getDigit() {
        return digit;
    }

    public void setDigit(Integer digit) {
        this.digit = digit;
    }

    public Integer getTicks() {
        return ticks;
    }

    public void setTicks(Integer ticks) {
        this.ticks = ticks;
    }

    @Override
    public String toString() {
        return "equationNumber{" +
                "digit=" + digit +
                ", ticks=" + ticks +
                '}';
    }
}
