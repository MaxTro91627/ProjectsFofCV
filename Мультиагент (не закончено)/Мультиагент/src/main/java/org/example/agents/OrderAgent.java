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
import org.example.model.MenuDish;
import org.example.model.Order;

public class OrderAgent extends Agent {
    AID[] agents;

    @Override
    protected void setup() {
        System.out.println("Hello from " + getAID().getName());

        final DFAgentDescription dfd = new DFAgentDescription();
        final ServiceDescription sd = new ServiceDescription();
        sd.setType(OrderAgent.class.getName());
        sd.setName(OrderAgent.class.getName());

        dfd.addServices(sd);

        final ACLMessage[] mes = new ACLMessage[1];
        addBehaviour(new Behaviour() {
            @Override
            public void action() {
                mes[0] = myAgent.receive();
            }

            @Override
            public boolean done() {
                return false;
            }
        });

        String dish_id;
        if (mes[0] != null) {
            dish_id = mes[0].getContent();
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
                    myAgent.addBehaviour(new SendMessageBehaviour<MenuDish>(agents, new MenuDish()));
                    // опять-таки проблема с отправкой (((
                }
            });
            final ACLMessage[] msg = new ACLMessage[1];
            addBehaviour(new Behaviour() {
                @Override
                public void action() {
                    msg[0] = myAgent.receive();
                }

                @Override
                public boolean done() {
                    return false;
                }
            });
            if (msg[0] != null) {
                addBehaviour(new TickerBehaviour(this, 10000) {
                    @Override
                    protected void onTick() {
                        // Update the list of seller agents
                        DFAgentDescription template = new DFAgentDescription();
                        ServiceDescription sd = new ServiceDescription();
                        sd.setType(MainAgent.class.getName());
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
                        myAgent.addBehaviour(new SendMessageBehaviour<MainAgent>(agents, new MainAgent()));
                    }
                });
            }
        }
    }
}
