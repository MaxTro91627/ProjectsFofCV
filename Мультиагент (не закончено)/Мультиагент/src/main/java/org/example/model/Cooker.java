package org.example.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Cooker {
    int cook_id;
    String cook_name;
    boolean cook_active;

    public boolean getCook_active() {
        return cook_active;
    }

    public void changeActive() {
        cook_active = !cook_active;
    }

}
