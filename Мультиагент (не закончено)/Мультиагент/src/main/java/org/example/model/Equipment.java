package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Equipment {
    int equip_id;
    int equip_type;
    String equip_name;
    boolean equip_active;
    public Integer getType() {
        return equip_type;
    }
    public boolean getActive() {
        return equip_active;
    }
    public Integer getId() {
        return equip_id;
    }
    public void setNewActivity() {
        equip_active = !equip_active;
    }
}
