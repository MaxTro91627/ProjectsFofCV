package org.example.model;

import java.util.ArrayList;

public class Cookers {
    private static ArrayList<Cooker> cookers;

    public Cookers() {
        this.cookers = new ArrayList<>();
    }
    public static ArrayList<Cooker> getCookers() {
        return cookers;
    }

}
