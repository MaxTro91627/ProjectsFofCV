package org.example.agents;

import jade.core.AID;
import jade.core.Agent;
import jade.core.behaviours.Behaviour;
import jade.core.behaviours.TickerBehaviour;
import jade.domain.DFService;
import jade.domain.FIPAAgentManagement.DFAgentDescription;
import jade.domain.FIPAAgentManagement.ServiceDescription;
import jade.domain.FIPAException;
import jade.lang.acl.ACLMessage;
import org.example.behaviour.SendMessageBehaviour;
import org.example.model.*;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import static java.lang.Integer.parseInt;

public class ProcessAgent extends Agent {
    AID[] agents;

    @Override
    protected void setup() {
        System.out.println("Hello from " + getAID().getName());
        final DFAgentDescription dfd = new DFAgentDescription();
        final ServiceDescription sd = new ServiceDescription();
        sd.setType(ProcessAgent.class.getName());
        sd.setName(ProcessAgent.class.getName());
        dfd.addServices(sd);

        try {
            DFService.register(this, dfd);
        } catch (FIPAException e) {
            throw new RuntimeException(e);
        }
        final ACLMessage[] message = new ACLMessage[1];
        addBehaviour(new Behaviour() {
            @Override
            public void action() {
                message[0] = myAgent.receive();
            }

            @Override
            public boolean done() {
                return false;
            }
        });
        if (message[0] != null) {
            Integer dishCard = parseInt(message[0].getContent());
            boolean ingr_exist = false;
            List<Equipment> equipment = EquipmentType.getEq();
            Double time;
            List<DishCard> dishes = Dishes.getDishes();
            StringBuilder cookingTime = new StringBuilder();
            for (DishCard dish : dishes) {
                if (ingr_exist) {
                    break;
                }
                if (Objects.equals(dish.getId(), dishCard)) {
                    List<Operation> operList = dish.getOperations();
                    for (Operation operProd : operList) {
                        Integer eq = operProd.getType();

                        List<OperProduct> operProducts = operProd.getOperProducts();
                        ArrayList<Product> products = Products.getProducts();
                        for (OperProduct operProduct : operProducts) {
                            for (Product product : products) {
                                if (Objects.equals(product.getType(), operProduct.getType())) {
                                    if (product.getQuantity() < operProduct.getQuantity()) {
                                        addBehaviour(new TickerBehaviour(this, 10000) {
                                            @Override
                                            protected void onTick() {
                                                DFAgentDescription dfd = new DFAgentDescription();
                                                ServiceDescription sd = new ServiceDescription();
                                                sd.setType(MenuAgent.class.getName());
                                                dfd.addServices(sd);
                                                try {
                                                    DFAgentDescription[] result = DFService.search(myAgent, dfd);
                                                    agents = new AID[result.length];
                                                    for (int i = 0; i < result.length; ++i) {
                                                        agents[i] = result[i].getName();
                                                    }
                                                } catch (FIPAException fe) {
                                                    fe.printStackTrace();
                                                }
                                                myAgent.addBehaviour(new SendMessageBehaviour<>(agents, new MenuDish()));
                                            }
                                        });
                                        ingr_exist = true;
                                        break;
                                    }
                                }
                            }
                            if (ingr_exist) {
                                break;
                            }
                        }
                        if (ingr_exist) {
                            break;
                        }
                        time = dish.getTime();
                        for (OperProduct operProduct : operProducts) {
                            for (Product product : products) {
                                if (Objects.equals(product.getType(), operProduct.getType())) {
                                    product.setNewQuantity(operProduct.getQuantity());
                                }
                            }
                        }
                        for (Equipment Equip : equipment) {
                            if (Objects.equals(Equip.getType(), eq))
                            {
                                addBehaviour(new TickerBehaviour(this, 10000) {
                                    @Override
                                    protected void onTick() {
                                        DFAgentDescription df = new DFAgentDescription();
                                        ServiceDescription sd = new ServiceDescription();
                                        sd.setType(FacilitiesAgent.class.getName());
                                        df.addServices(sd);
                                        try {
                                            DFAgentDescription[] result = DFService.search(myAgent, df);
                                            agents = new AID[result.length];
                                            for (int i = 0; i < result.length; ++i) {
                                                agents[i] = result[i].getName();
                                            }
                                        } catch (FIPAException fe) {
                                            fe.printStackTrace();
                                        }
//                                        myAgent.addBehaviour(new SendMessageBehaviour<>(agents));
//                                        не понимаю (
                                    }
                                });
                                final ACLMessage[] ans = new ACLMessage[1];
                                addBehaviour(new Behaviour() {
                                    @Override
                                    public void action() {
                                        ans[0] = myAgent.receive();
                                    }

                                    @Override
                                    public boolean done() {
                                        return false;
                                    }
                                });
                                cookingTime.append(ans[0].getContent()).append(' ').append(time);
                            }
                        }

                    }
                }
            }

            addBehaviour(new TickerBehaviour(this, 10000) {
                @Override
                protected void onTick() {
                    // Update the list of seller agents
                    DFAgentDescription template = new DFAgentDescription();
                    ServiceDescription sd = new ServiceDescription();
                    sd.setType(MenuAgent.class.getName());
                    template.addServices(sd);
                    try {
                        DFAgentDescription[] result = DFService.search(myAgent, template);
                        agents = new AID[result.length];
                        for (int i = 0; i < result.length; ++i) {
                            agents[i] = result[i].getName();
                        }
                    } catch (FIPAException fe) {
                        fe.printStackTrace();
                    }
//                    myAgent.addBehaviour(new SendMessageBehaviour<>(agents));
                }
            });
        }
    }

}
