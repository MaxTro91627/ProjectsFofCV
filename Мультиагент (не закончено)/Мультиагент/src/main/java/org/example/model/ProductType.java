package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductType {
    int prod_type_id;
    String prod_type_name;
    boolean prod_is_food;
}
