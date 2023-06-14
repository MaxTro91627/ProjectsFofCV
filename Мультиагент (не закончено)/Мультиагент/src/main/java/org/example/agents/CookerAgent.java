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
import org.example.model.Cooker;
import org.example.model.Cookers;
import org.example.model.Equipment;

import java.util.ArrayList;
import java.util.Objects;

import static java.lang.Thread.sleep;

public class CookerAgent extends Agent {
    AID[] agents;

    ArrayList<Cooker> cookers = Cookers.getCookers();
    @Override
    protected void setup() {
        System.out.println("Hello from " + getAID().getName());

        final ACLMessage[] msg = new ACLMessage[1];
        Integer cookerID = null;

        final DFAgentDescription dfd = new DFAgentDescription();
        final ServiceDescription sd = new ServiceDescription();
        sd.setType(CookerAgent.class.getName());
        sd.setName(CookerAgent.class.getName());
        dfd.addServices(sd);

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

        try {
            DFService.register(this, dfd);
        } catch (FIPAException e) {
            throw new RuntimeException(e);
        }

        if (msg[0] != null) {
            boolean equipExist = false;
            while(!equipExist) {
                try {
                    sleep(2000);
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
                for (Cooker cooker : cookers) {
                    if (cooker.getCook_active()) {
                        cooker.changeActive();
                        cookerID = cooker.getCook_id();
                        equipExist = true;
                        break;
                    }
                }
            }
            try {
                sleep(3000);
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            for(Cooker cooker : cookers) {
                if(Objects.equals(cooker.getCook_id(), cookerID)) {
                    cooker.changeActive();
                    break;
                }
            }

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
//                    myAgent.addBehaviour(new SendMessageBehaviour<Equipment>(agents));
                }
            });

        }
    }
}
