package org.example.model;

import java.util.ArrayList;
import java.util.List;

public class CheckedDishes {
    private static ArrayList<MenuDish> checked_dishes;

    public CheckedDishes() {
        this.checked_dishes = new ArrayList<>();
    }

    public static List<MenuDish> getMenuDishes() {
        return checked_dishes;
    }
}
