package org.example.model;

import java.util.ArrayList;
import java.util.List;

public class Dishes {
    private static ArrayList<DishCard> dishes;

    public Dishes() {
        this.dishes = new ArrayList<>();
    }

    public static List<DishCard> getDishes() {
        return dishes;
    }
}
