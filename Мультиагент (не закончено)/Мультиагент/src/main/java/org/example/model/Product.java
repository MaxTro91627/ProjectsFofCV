package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product {
    int prod_item_id;
    int prod_item_type;
    String prod_item_name;
    String prod_item_company;
    String prod_item_unit;
    double prod_item_quantity;
    int prod_item_cost;
    String prod_item_delivered;
    String prod_item_valid_until;
    public Integer getType() {
        return prod_item_type;
    }
    public Double getQuantity() {
        return prod_item_quantity;
    }

    public void setNewQuantity(Double quantity) {
        prod_item_quantity = prod_item_quantity - quantity;
    }
}
