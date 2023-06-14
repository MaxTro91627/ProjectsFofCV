package org.example.model;

import java.util.ArrayList;

public class Products {
    private static ArrayList<Product> products;

    public Products() {
        this.products = new ArrayList<>();
    }

    public static ArrayList<Product> getProducts() {
        return products;
    }
}
