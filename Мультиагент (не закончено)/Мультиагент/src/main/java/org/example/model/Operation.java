package org.example.model;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Operation {
    int oper_type;
    int equip_type;
    double oper_time;
    int oper_async_point;
    private static ArrayList<OperProduct> oper_products;

    public Integer getType() {
        return equip_type;
    }
    public static List<OperProduct> getOperProducts() {
        return oper_products;
    }

}
