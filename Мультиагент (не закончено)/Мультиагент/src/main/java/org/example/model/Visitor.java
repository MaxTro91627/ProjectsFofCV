package org.example.model;

import java.util.ArrayList;

import static java.util.Objects.isNull;

public class Visitor {
    private String vis_name;
    private Integer vis_ord_total;
    private ArrayList<Integer> vis_ord_dishes;

    public Visitor() {
        this.vis_ord_dishes = new ArrayList<>();
    }

    public String getVisName() {
        return vis_name;
    }

    public Integer getVisOrdTotal() {
        return vis_ord_total;
    }

    public ArrayList<Integer> getVisOrdDishes() {
        return vis_ord_dishes;
    }

    public boolean checkNulls() {
        if (isNull(vis_name) || isNull(vis_ord_total)) {
            return true;
        }
        for (Integer n : vis_ord_dishes) {
            if (isNull(n)) {
                return true;
            }
        }
        return false;
    }
}
