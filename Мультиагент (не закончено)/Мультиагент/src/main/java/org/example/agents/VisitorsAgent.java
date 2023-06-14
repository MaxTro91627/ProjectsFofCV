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
import org.example.config.JadeAgent;
import org.example.model.Order;
import org.example.model.Visitor;

import java.util.ArrayList;

@JadeAgent("VisitorsAgent")
public class VisitorsAgent extends Agent {

    private AID[] manager;

    @Override
    protected void setup() {
        System.out.println("Hello! Custom-agent " + VisitorsAgent.class.getName() + " is ready.");

        final DFAgentDescription dfd = new DFAgentDescription();
        final ServiceDescription sd = new ServiceDescription();
        sd.setType(VisitorsAgent.class.getName()); // died tut
        sd.setName(VisitorsAgent.class.getName());
        dfd.addServices(sd);
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

        int id;
        if (msg[0] != null) {
            id = Integer.parseInt(msg[0].getContent());
            ArrayList<Integer> orders = null;
            ArrayList<Visitor> visitors = Order.getOrders();
            int i = -1;
            for (Visitor visitor : visitors) {
                i++;
                if (i == id) {
                    orders = visitor.getVisOrdDishes();
                }
            }

            assert orders != null;
            for (Integer dish_id : orders) {
                addBehaviour(new TickerBehaviour(this, 10000) {
                    @Override
                    protected void onTick() {
                        DFAgentDescription df = new DFAgentDescription();
                        ServiceDescription sd = new ServiceDescription();
                        sd.setType(MainAgent.class.getName());
                        df.addServices(sd);
                        try {
                            DFAgentDescription[] result = DFService.search(myAgent, df);
                            manager = new AID[result.length];
                            for (int i = 0; i < result.length; ++i) {
                                manager[i] = result[i].getName();
                            }
                        } catch (FIPAException fe) {
                            fe.printStackTrace();
                        }
//                        myAgent.addBehaviour(new SendMessageBehaviour<>(manager));
                    }
                });

                addBehaviour(new Behaviour() {
                    @Override
                    public void action() {
                        ACLMessage message = myAgent.receive();
                        if (message != null) {
                            System.out.println("It`ll be done in " + message.getContent() + "min\n");
                        }
                    }

                    @Override
                    public boolean done() {
                        return false;
                    }
                });

            }
        }

    }
}
