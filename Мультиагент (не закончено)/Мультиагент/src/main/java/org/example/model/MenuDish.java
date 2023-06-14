package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MenuDish {
    int menu_dish_id;
    int menu_dish_card;
    int menu_dish_price;
    boolean menu_dish_active;
    public Integer getId() {
        return menu_dish_id;
    }
}
