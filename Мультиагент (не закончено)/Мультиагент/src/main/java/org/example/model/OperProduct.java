package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class OperProduct {
    int prod_type;
    double prod_quantity;
    public Integer getType() {
        return prod_type;
    }
    public double getQuantity() {
        return prod_quantity;
    }

}