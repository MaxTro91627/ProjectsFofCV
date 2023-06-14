package org.example.model;

import java.util.ArrayList;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DishCard {
    int card_id;
    String dish_name;
    String card_descr;
    double card_time;
    ArrayList<Operation> operations;
    public Integer getId() {
        return card_id;
    }
    public Double getTime() {
        return card_time;
    }
}
