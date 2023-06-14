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
import lombok.SneakyThrows;
import org.example.behaviour.SendMessageBehaviour;
import org.example.config.JadeAgent;
import org.example.model.Equipment;
import org.example.model.EquipmentType;

import java.util.List;
import java.util.Objects;

import static java.lang.Integer.parseInt;
import static java.lang.Thread.sleep;

@JadeAgent
public class FacilitiesAgent extends Agent {
    AID[] agents;

    @SneakyThrows
    @Override
    protected void setup() {
        System.out.println("Hello from " + getAID().getName());

        final DFAgentDescription dfd = new DFAgentDescription();
        final ServiceDescription sd = new ServiceDescription();
        sd.setType(FacilitiesAgent.class.getName());
        sd.setName(CookerAgent.class.getName());
        dfd.addServices(sd);

        DFService.register(this, dfd);
        final ACLMessage[] msg = {null};

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
            Integer equipType = parseInt(msg[0].getContent());
            List<Equipment> equipments = EquipmentType.getEq();
            Integer equipmentID;
            for (Equipment equipment : equipments) {
                if (Objects.equals(equipment.getType(), equipType)) {
                    boolean ready = equipment.getActive();
                    while (!ready)
                        try {
                            sleep(2000);
                            ready = equipment.getActive();
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                }
                equipment.setNewActivity();
                equipmentID = equipment.getId();

                addBehaviour(new TickerBehaviour(this, 10000) {
                    @Override
                    protected void onTick() {
                        DFAgentDescription df = new DFAgentDescription();
                        ServiceDescription sd = new ServiceDescription();
                        sd.setType(CookerAgent.class.getName());
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
//                        myAgent.addBehaviour(new SendMessageBehaviour<>(agents));
                    }
                });


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

                equipment.setNewActivity();

                ACLMessage orderAnswer = new ACLMessage((ACLMessage.INFORM));

                orderAnswer.addReceiver(msg[0].getSender());
                orderAnswer.setContent(equipmentID.toString() + ' ' + message[0].getContent());
                send(orderAnswer);
            }
        }
    }
}
