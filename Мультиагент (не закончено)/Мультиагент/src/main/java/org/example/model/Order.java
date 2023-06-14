package org.example.model;

import java.util.ArrayList;

public class Order {
    private static ArrayList<Visitor> orders;

    public Order() {
        this.orders = new ArrayList<>();
    }

    public static ArrayList<Visitor> getOrders() {
        return orders;
    }
}
