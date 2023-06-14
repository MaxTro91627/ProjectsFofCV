package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class EquipmentType {
    private static ArrayList<Equipment> equipment;

    public EquipmentType() {
        this.equipment = new ArrayList<>();
    }

    public static List<Equipment> getEq() {
        return equipment;
    }

    int equip_type_id;
    String equip_type_name;
}
